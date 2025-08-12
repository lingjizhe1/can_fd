
 #if (BOARD_RUNNING_CORE == HPM_CORE0)
 #else
 #include <stdio.h>
 #include <string.h>
 #include <stdbool.h>
 #include "board.h"
 #include "hpm_debug_console.h"
 #include "../inc/tran_receTest.h"
 #include "hpm_can_drv.h"
 #include "share_buffer.h"
 #include "can_test.h"
 #include "hpm_soc_feature.h"
 #include "hpm_mbx_drv.h"
 #include "app_mbx.h"
 #include "global.h"


 
 
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
       while(1);
     /* reciever */
     while (1) {
         if (can_read) {
             stat = mbx_retrieve_message(HPM_MBX0B, &i);
             if (stat == status_success) {
                 printf("core %d: got %ld\n", BOARD_RUNNING_CORE, i);
                 printf("notice_count: %d\n", notice_count);
                             ret = Oconsume_head_switch(&ram_buffer_block);
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
