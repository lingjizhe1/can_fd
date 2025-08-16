#ifndef __ISR0_H__
#define __ISR0_H__

#include "hpm_mbx_drv.h"

#include "board.h"

void mbx_interrupt_init(void);
void timer_interrupt_init(void);
void check_and_print_results(void);

#endif