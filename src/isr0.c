#if (BOARD_RUNNING_CORE == HPM_CORE0)
#include "multicore_common.h"
#include "hpm_mbx_drv.h"
#include "hpm_can_drv.h"
#include "board.h"
#include "isr0.h"
#include "global.h"
volatile bool can_read = false;
volatile bool can_send = false;

#define MBX HPM_MBX0A
#define MBX_IRQ IRQn_MBX0A
extern volatile bool has_new_rcv_msg;
extern volatile bool has_sent_out; 
extern volatile bool has_error;
extern volatile uint32_t error_flags;
extern volatile can_receive_buf_t s_can_rx_buf;

SDK_DECLARE_EXT_ISR_M(BOARD_APP_CAN_IRQn, board_can_isr)
 void board_can_isr(void)
 {
     static int count = 0;
     uint8_t flags = can_get_tx_rx_flags(BOARD_APP_CAN_BASE);
    
     if ((flags & CAN_EVENT_RECEIVE) != 0) {
         // 使用本地临时缓冲区接收数据
  

         
         
        assert(ram_buffer_block.is_full == false);
         
         hpm_stat_t read_status = can_read_received_message(BOARD_APP_CAN_BASE, get_writeable_ram(&ram_buffer_block));
         
         if (read_status == status_success) {
           // printf("write to ram buffer success,the count is %d\n",count++);
             has_new_rcv_msg = true;
             //printf("can isr exit");
           
 
         } else {
             printf("Error: CAN data read failed\n");
         }
     }
     
     if ((flags & (CAN_EVENT_TX_PRIMARY_BUF | CAN_EVENT_TX_SECONDARY_BUF))) {
         has_sent_out = true;
     }
     
     if ((flags & CAN_EVENT_ERROR) != 0) {
         has_error = true;
     }
     
     // 清除CAN标志位
     can_clear_tx_rx_flags(BOARD_APP_CAN_BASE, flags);
 
     // 处理错误中断
     error_flags = can_get_error_interrupt_flags(BOARD_APP_CAN_BASE);
     if (error_flags != 0) {
         has_error = true;
         printf("CAN error interrupt: error_flags=0x%08x\n", error_flags);
     }
     can_clear_error_interrupt_flags(BOARD_APP_CAN_BASE, error_flags);
 }
 #endif


void mbx_interrupt_init(void)
{
    mbx_init(MBX);  // 初始化MBX
    intc_m_enable_irq_with_priority(MBX_IRQ, 2);  // MBX中断优先级为1，可以嵌套CAN中断
}


SDK_DECLARE_EXT_ISR_M(MBX_IRQ, isr_mbx)
void isr_mbx(void)
{   
   
    
    volatile uint32_t sr = MBX->SR;
    volatile uint32_t cr = MBX->CR;
    if ((sr & MBX_SR_TWME_MASK) && (cr & MBX_CR_TWMEIE_MASK)) {
        
        can_send = true;
        
        mbx_disable_intr(MBX, MBX_CR_TWMEIE_MASK);
    } 

    
    //printf("MBX ISR: Exiting\n");
}






