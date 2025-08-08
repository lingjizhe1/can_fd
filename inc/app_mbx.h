#ifndef __APP_MBX_H__
#define __APP_MBX_H__

#include "hpm_mbx_drv.h"
#if (BOARD_RUNNING_CORE == HPM_CORE0)
void item_full_notice(void);
void mbx_interrupt_init(void);  // 声明MBX中断初始化函数
#else
extern volatile uint8_t notice_count;

#endif





#endif