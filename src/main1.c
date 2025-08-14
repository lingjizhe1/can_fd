
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
 


 
 int main(void)
 {
 
     
     uint8_t ret = 0;
     long long int i = 0;
     board_init_core1();
  
    
     
     mbx_init(HPM_MBX0B);
     hpm_stat_t stat;
     
          
     
   intc_m_enable_irq_with_priority(IRQn_MBX0B, 2);
    // printf("HPM_MBX0B CR: 0x%x\n", HPM_MBX0B->CR);
    // printf(" success\n");
  
   //  printf("ram_buffer_block = 0x%8X \n", &ram_buffer_block);
     //printf("RAM_BUFFER_BLOCK_SIZE = %d  MAX_CAN_BUFFER_SIZE = %d\n", RAM_BUFFER_BLOCK_SIZE, MAX_CAN_BUFFER_SIZE);
     
     clock_add_to_group(clock_mbx0, 0);
     mbx_enable_intr(HPM_MBX0B, MBX_CR_RWMVIE_MASK);

     /* reciever */
     while (1) {
         if (can_read) {
             stat = mbx_retrieve_message(HPM_MBX0B, &i);

             if (stat == status_success) {
                 //printf("core %d: got %ld\n", BOARD_RUNNING_CORE, i);
                 //printf("notice_count: %d\n", notice_count);
                 ret = Oconsume_head_switch(&ram_buffer_block);
                if(ret == 0)
                {
                    ret = Ocopy_to_axi_sram(&ram_buffer_block);
                    if(ret == 0)
                    {
                      //  printf("copy to axi_sram success\n");
                      
                    }
                    else
                    {
                        printf("copy to axi_sram failed\n");
                        

                    }
                }
                else
                {
                    printf("consume_head_switch failed\n");
                }
            
             } else {
                printf("core %d: error getting message\n", BOARD_RUNNING_CORE);
 
             }
             
               
             can_read = false;
             mbx_enable_intr(HPM_MBX0B, MBX_CR_RWMVIE_MASK);
             if(notice_count == 40)
             {
                break;
             }
            }
         }
     
     //// 循环打印axi_sram_can_buffers的数据
     //printf("\n=== 打印axi_sram_can_buffers数据 ===\n");
     //for(int i = 0; i < AXI_SRAM_CAN_BUFFER_COUNT; i++)
     //{
     //    printf("Buffer[%d]: ID=0x%08X, DLC=%d, Data: ", 
     //           i, axi_sram_can_buffers[i].id, axi_sram_can_buffers[i].dlc);
         
     //    // 打印数据字节
     //    for(int j = 0; j < 8; j++)
     //    {
     //        printf("0x%02X ", axi_sram_can_buffers[i].data[j]);
     //    }
     //    printf("\n");
         
     //    // 每打印10个缓冲区数据后暂停一下，避免输出过快
     //    if((i + 1) % 10 == 0)
     //    {
     //        clock_cpu_delay_ms(100);
     //    }
     //}
     printf("===complete ===\n\n");
 }
 
 #endif
