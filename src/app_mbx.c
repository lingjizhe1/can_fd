/*
 * Author: Jizhe Ling
 * Date: 2025-08-05
 * Description: core0向core1发送任意消息触发中断
 *
 */


#include "hpm_mbx_drv.h"
#include "app_mbx.h"
#include "board.h"

volatile bool can_read = false;
volatile bool can_send = false;

#if (BOARD_RUNNING_CORE == HPM_CORE0)
#define MBX HPM_MBX0A
#define MBX_IRQ IRQn_MBX0A



// MBX中断优先级设置为1，高于CAN中断的优先级2
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

    
    printf("MBX ISR: Exiting\n");
}


/* core0发送写满item通知*/

void item_full_notice(void)
{
    // 注意：mbx_init已经在初始化时调用，这里只需要发送消息
                    //mbx_init(HPM_MBX0A);
                mbx_enable_intr(HPM_MBX0A, MBX_CR_TWMEIE_MASK);
                //mbx_send_message(HPM_MBX0A, 0);  // 发送当前计数作为消息
    //mbx_empty_txfifo(MBX);
    //mbx_enable_intr(MBX, MBX_CR_TWMEIE_MASK);
   
    //mbx_send_message(MBX, 0);
    while(1)
    {
        if(can_send){
            mbx_send_message(MBX, 0);
            printf("MBX ISR: Message sent successfully (nested in CAN ISR)\n");
            can_send = false;
            break;
        }
    }  // 等待发送完成
}



#else
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

















