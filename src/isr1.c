
 #if (BOARD_RUNNING_CORE == HPM_CORE0)
 #else
 #include "hpm_mbx_drv.h"
 #include "app_mbx.h"
 #include "board.h"
 #include "isr1.h"  
 
 volatile bool can_read = false;
 volatile bool can_send = false;
 #define MBX HPM_MBX0B
 #define MBX_IRQ IRQn_MBX0B
 
 volatile uint8_t notice_count = 0;/* 获取通知次数，每次获取代表core0写满了一个item  */
 SDK_DECLARE_EXT_ISR_M(MBX_IRQ, isr_mbx)
 void isr_mbx(void)
 {
    
     volatile uint32_t sr = MBX->SR;
     volatile uint32_t cr = MBX->CR;
     if ((sr & MBX_SR_RWMV_MASK) && (cr & MBX_CR_RWMVIE_MASK)) {
         can_read = true;
         notice_count++;
         mbx_disable_intr(MBX, MBX_CR_RWMVIE_MASK);
     } 
 
 }
 #endif
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 