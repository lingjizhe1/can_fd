
 #include "global.h"
#if (BOARD_RUNNING_CORE == HPM_CORE0)
 #include <stdio.h>
 #include <string.h>
 #include <stdbool.h>
 #include "board.h"
 #include "hpm_debug_console.h"
 #include "../inc/tran_receTest.h"
 #include "hpm_can_drv.h"
 #include "share_buffer.h"
 #include "isr0.h"

 #include "hpm_soc_feature.h"
#include "hpm_mbx_drv.h"
#include "hpm_gptmr_drv.h"
#include "hpm_interrupt.h"



 #include "multicore_common.h"
 
 // CAN相关全局变量定义
 volatile bool has_new_rcv_msg = false;
 volatile bool has_sent_out = false; 
 volatile bool has_error = false;
 volatile uint32_t error_flags = 0;
 volatile can_receive_buf_t s_can_rx_buf;
 

 extern  volatile bool can_read;
extern  volatile bool can_send;

// Timer related variables

// Data recording array - record transmission count per millisecond

 
 
  // Memory optimization: 16KB shared memory limit
  #define RAM_BUFFER_BLOCK_SIZE (4)
  #define MAX_CAN_BUFFER_SIZE (50)    // Reduced from 1024 to 50, adapt to 16KB shared memory
  // Calculation: 4 × 50 × 80 = 16,000 bytes ≈ 15.6KB
  
  
  // Place CAN buffer in shared memory for inter-core communication
  #define SHARED_CACHELINE_ALIGN  __attribute__((section(".sh_mem"), aligned(HPM_L1C_CACHELINE_SIZE)))
  #define SHARED_STRUCT_ALIGN     __attribute__((section(".sh_mem"), aligned(32)))
  SHARED_STRUCT_ALIGN share_buffer_t ram_buffer_block;
  SHARED_STRUCT_ALIGN share_buffer_item_t ram_buffer_block_items[RAM_BUFFER_BLOCK_SIZE];
  SHARED_CACHELINE_ALIGN can_receive_buf_t ram_buffer[RAM_BUFFER_BLOCK_SIZE][MAX_CAN_BUFFER_SIZE];

speed_test_t speed_test_data;


 
 

void board_can_loopback_test_in_interrupt_mode(void)
 {
     CAN_Type *ptr = BOARD_APP_CAN_BASE;
     can_config_t can_config;
     can_get_default_config(&can_config);
     can_config.baudrate = 1000000; /* 1Mbps */
     can_config.mode = can_mode_loopback_internal;
     board_init_can(ptr);
     uint32_t can_src_clk_freq = board_init_can_clock(ptr);
     can_config.irq_txrx_enable_mask = CAN_EVENT_RECEIVE | CAN_EVENT_TX_PRIMARY_BUF | CAN_EVENT_TX_SECONDARY_BUF;
     hpm_stat_t status = can_init(ptr, &can_config, can_src_clk_freq);
     if (status != status_success) {
         printf("CAN initialization failed, error code: %d\n", status);
         return;
     }
     intc_m_enable_irq_with_priority(BOARD_APP_CAN_IRQn, 1);  // CAN interrupt priority set to 1, allow MBX interrupt nesting
 
     can_transmit_buf_t tx_buf;
     memset(&tx_buf, 0, sizeof(tx_buf));
     tx_buf.dlc = 8;
 
          for (uint32_t i = 0; i < 8; i++) {
         tx_buf.data[i] = (uint8_t) i | (i << 4);
     }

     printf("Starting to send 2048 CAN messages...\n");
     
     for (uint32_t i = 0; i < 2048; i++) {
         tx_buf.id = i;
         can_send_message_nonblocking(BOARD_APP_CAN_BASE, &tx_buf);
    
         /* MBX send item_full_notice */
         if(ram_buffer_block.wait > 0)
         {
             
             mbx_enable_intr(HPM_MBX0A, MBX_CR_TWMEIE_MASK);
             while(1)
             {
                 if(can_send){
                     mbx_send_message(HPM_MBX0A, (uint32_t)2);  // Send current count as message
                     ram_buffer_block.wait--;
                     break;
                 }
             }
         }
         
         
 
 
         while (!has_sent_out) {
         }
 
         while (!has_new_rcv_msg) {
 
         }
                  has_new_rcv_msg = false;
         has_sent_out = false;
     }
     
     printf("2048 CAN messages sent completed!\n");
}

#define CAN_BUFFER_COUNT (2048)
can_receive_buf_t can_buffers[CAN_BUFFER_COUNT];

void share_buffer_max_speed_test(void)
{
   // 初始化CAN缓冲区数组
   for (int i = 0; i < CAN_BUFFER_COUNT; i++) {
       // 清零整个缓冲区
       memset(&can_buffers[i], 0, sizeof(can_receive_buf_t));
       
       // 设置CAN ID (递增从0到2047)
       can_buffers[i].id = i;
       
       // 设置数据长度为8字节
       can_buffers[i].dlc = 8;
       
       // 设置为标准帧（非扩展ID）
       can_buffers[i].extend_id = 0;
       
       // 设置为数据帧（非远程帧）
       can_buffers[i].remote_frame = 0;
       
       // 设置为CAN 2.0帧（非CANFD）
       can_buffers[i].canfd_frame = 0;
       
       // 关闭比特率切换
       can_buffers[i].bitrate_switch = 0;
       
       // 非回环消息
       can_buffers[i].loopback_message = 0;
       
       // 无错误
       can_buffers[i].error_type = 0;
       can_buffers[i].error_state_indicator = 0;
       
       // 设置循环时间为0
       can_buffers[i].cycle_time = 0;
       
       // 设置数据：00 11 22 33 44 55 66 77
       // 注意：data字段在结构体中位于第8个字节开始的位置
       uint8_t *data_ptr = (uint8_t*)&can_buffers[i].buffer[2]; // 跳过前两个32位字段
       data_ptr[0] = 0x00;
       data_ptr[1] = 0x11;
       data_ptr[2] = 0x22;
       data_ptr[3] = 0x33;
       data_ptr[4] = 0x44;
       data_ptr[5] = 0x55;
       data_ptr[6] = 0x66;
       data_ptr[7] = 0x77;
       
   }
   while(1)
   {
        for(int i = 0; i < CAN_BUFFER_COUNT; i++)
        {
        // Protect frame count increment from timer interrupt
        //uint32_t mstatus = disable_global_irq(CSR_MSTATUS_MIE_MASK);
        speed_test_data.frame_sent_count++;
        //enable_global_irq(mstatus);
       
  //clock_cpu_delay_us(1);
       memcpy(get_writeable_ram(&ram_buffer_block), &can_buffers[i], sizeof(can_receive_buf_t));
       // 内存屏障和缓存清理
      // __asm__ volatile ("fence" : : : "memory");  // 数据同步屏障
       
       if(ram_buffer_block.wait > 0)
       {
           
           mbx_enable_intr(HPM_MBX0A, MBX_CR_TWMEIE_MASK);
           while(1)
           {
               if(can_send){
                   mbx_send_message(HPM_MBX0A, (uint32_t)2);  // 发送当前计数作为消息
                   ram_buffer_block.wait--;
                   break;
               }
           }
       }
       
       // Check for timer results
       check_and_print_results();
       }
   }
   
}
 
 int main(void)
 {
 
     board_init();
     
     //multicore_release_cpu(HPM_CORE1, SEC_CORE_IMG_START);
     //memset(axi_sram_can_buffers, 1, sizeof(axi_sram_can_buffers));
    clock_add_to_group(clock_mbx0, 0);

    
     multicore_release_cpu(HPM_CORE1, SEC_CORE_IMG_START);
     clock_cpu_delay_ms(3000);
        clock_add_to_group(clock_mbx0, 0);

    ram_buffer_block_init();
    mbx_interrupt_init();
    
    // Initialize speed test data
    memset(&speed_test_data, 0, sizeof(speed_test_data));
    
    timer_interrupt_init();
     
    // Initialize array

     //board_can_loopback_test_in_interrupt_mode();
     
     share_buffer_max_speed_test();
   
     
     while(1);  // Stay here after completion
    // while(1);
 
         
     return 0;
 }
#endif
