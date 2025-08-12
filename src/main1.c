
 #if (BOARD_RUNNING_CORE == HPM_CORE1)
 
 #include <stdio.h>
 #include <string.h>
 #include <stdbool.h>
 #include "board.h"
 #include "hpm_debug_console.h"
 #include "../inc/tran_receTest.h"
 #include "hpm_can_drv.h"
 #include "share_buffer.h"

 #include "hpm_soc_feature.h"
 #include "hpm_mbx_drv.h"

 #include "global.h"

extern volatile bool can_read;
extern volatile bool can_send;
extern volatile uint8_t notice_count;
 
  // 内存规划优化：共享内存16KB限制
  #define RAM_BUFFER_BLOCK_SIZE (4)
  #define MAX_CAN_BUFFER_SIZE (50)    // 从1024降到50，适应16KB共享内存
  // 计算：4 × 50 × 80 = 16,000字节 ≈ 15.6KB
  
  
  // 将CAN缓冲区放置在共享内存中，用于核间通信
  #define SHARED_CACHELINE_ALIGN  __attribute__((section(".sh_mem"), aligned(HPM_L1C_CACHELINE_SIZE)))
  #define SHARED_STRUCT_ALIGN     __attribute__((section(".sh_mem"), aligned(32)))
  SHARED_STRUCT_ALIGN share_buffer_t ram_buffer_block;
  SHARED_STRUCT_ALIGN share_buffer_item_t ram_buffer_block_items[RAM_BUFFER_BLOCK_SIZE];
  SHARED_CACHELINE_ALIGN can_receive_buf_t ram_buffer[RAM_BUFFER_BLOCK_SIZE][MAX_CAN_BUFFER_SIZE];



 #define AXI_SRAM_CAN_BUFFER_COUNT (2048)
 #define AXI_SRAM_ALIGN  __attribute__((section(".axi_sram"), aligned(HPM_L1C_CACHELINE_SIZE)))
 AXI_SRAM_ALIGN can_receive_buf_t axi_sram_can_buffers[AXI_SRAM_CAN_BUFFER_COUNT];
 

 int8_t Ocopy_to_axi_sram(share_buffer_t* block)
 {
     //if(block->consume_head->status == SHARE_BUFFER_STATUS_READING)
     //{
     //  //  memcpy(&axi_sram_can_buffers[block->consume_save_index], block->consume_head->data, MAX_CAN_BUFFER_SIZE * sizeof(can_receive_buf_t));
     //    block->consume_save_index += MAX_CAN_BUFFER_SIZE;
     //    block->consume_head->status = SHARE_BUFFER_STATUS_IDLE;
     
     //    memset(block->consume_head->data, 0, MAX_CAN_BUFFER_SIZE * sizeof(can_receive_buf_t));
     //    return 0;
     //}
     return -1;
 }

 
 
 int main(void)
 {
 
     
     uint8_t ret = 0;
     long long int i = 0;
     board_init_core1();
  
    
     
     mbx_init(HPM_MBX0B);
     hpm_stat_t stat;
     
          
     
   intc_m_enable_irq_with_priority(IRQn_MBX0B, 2);
     printf("HPM_MBX0B CR: 0x%x\n", HPM_MBX0B->CR);
     printf(" success\n");
  
     printf("ram_buffer_block = 0x%8X \n", &ram_buffer_block);
     //printf("RAM_BUFFER_BLOCK_SIZE = %d  MAX_CAN_BUFFER_SIZE = %d\n", RAM_BUFFER_BLOCK_SIZE, MAX_CAN_BUFFER_SIZE);
     
     clock_add_to_group(clock_mbx0, 0);
     mbx_enable_intr(HPM_MBX0B, MBX_CR_RWMVIE_MASK);

     /* reciever */
     while (1) {
         if (can_read) {
             stat = mbx_retrieve_message(HPM_MBX0B, &i);
             if (stat == status_success) {
                 printf("core %d: got %ld\n", BOARD_RUNNING_CORE, i);
                 printf("notice_count: %d\n", notice_count);
                             //ret = Oconsume_head_switch(&ram_buffer_block);
             //    if(ret == 0)
             //    {
             //        ret = Ocopy_to_axi_sram(&ram_buffer_block);
             //        if(ret == 0)
             //        {
             //            printf("copy to axi_sram success\n");
             //        }
             //        else
             //        {
             //            printf("copy to axi_sram failed\n");
             //        }
             //    }
             //    else
             //    {
             //        printf("consume_head_switch failed\n");
             //    }
            
             //} else {
             //    printf("core %d: error getting message\n", BOARD_RUNNING_CORE);
 
             //}
               
             can_read = false;
             mbx_enable_intr(HPM_MBX0B, MBX_CR_RWMVIE_MASK);
             }
         }
     }
 }
 #endif
