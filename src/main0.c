
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
 
 int main(void)
 {
 
     board_init();
     
     //multicore_release_cpu(HPM_CORE1, SEC_CORE_IMG_START);
     //memset(axi_sram_can_buffers, 1, sizeof(axi_sram_can_buffers));
    clock_add_to_group(clock_mbx0, 0);

    
     multicore_release_cpu(HPM_CORE1, SEC_CORE_IMG_START);
     clock_cpu_delay_ms(1000);
    clock_add_to_group(clock_mbx0, 0);

     
     ram_buffer_block_init();
     mbx_interrupt_init();
     
     // Initialize array

     board_can_loopback_test_in_interrupt_mode();
     
   
   
     
     while(1);  // Stay here after completion
    // while(1);
 
         
     return 0;
 }
#endif
