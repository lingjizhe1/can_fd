
  #if (BOARD_RUNNING_CORE == HPM_CORE1)

 #include "hpm_mbx_drv.h"
 #include "share_buffer.h"
 #include "board.h"
 #include "isr1.h"  
 #include "global.h"
 volatile bool can_read = false;
 volatile bool can_send = false;
 #define MBX HPM_MBX0B
 #define MBX_IRQ IRQn_MBX0B
 
 volatile uint8_t notice_count = 0;/* 获取通知次数，每次获取代表core0写满了一个item  */
 SDK_DECLARE_EXT_ISR_M(MBX_IRQ, isr_mbx)
 void isr_mbx(void)
 {
    hpm_stat_t stat;
    int8_t i = 0;
    
    static uint8_t count = 0;
   
  //  printf("isr count = %d\n",count);
    count ++;
     volatile uint32_t sr = MBX->SR;
     volatile uint32_t cr = MBX->CR;
     if ((sr & MBX_SR_RWMV_MASK) && (cr & MBX_CR_RWMVIE_MASK)) {
        stat = mbx_retrieve_message(MBX, &i);
        //if(stat == status_fail)
        //{
        //    printf("mbx_retrieve_message failed\n");
        //    while(1);
        //}
         can_read = true;
         notice_count++;
         mbx_disable_intr(MBX, MBX_CR_RWMVIE_MASK);
 
                int ret = Oconsume_head_switch(&ram_buffer_block);
               if(ret == 0)
               {
                   ret = Ocopy_to_axi_sram(&ram_buffer_block);
                   if(ret == 0)
                   {
             //      printf("copy to axi_sram success\n");
                      
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
      //if(count < 40){
      
      mbx_enable_intr(MBX, MBX_CR_RWMVIE_MASK);
      //}else{
      //  printf("notice_count = %d \n ",notice_count );
      //}
    //  printf("core1:mbx_isr exit\n");
 }
#endif
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 