#ifndef TRAN_RECE_TEST_H
#define TRAN_RECE_TEST_H

#include <stdint.h>
#include "hpm_can_drv.h"
#include "share_buffer.h"


//// 共享数据结构
//typedef struct {
//    volatile uint32_t core0_flag ;     // 核0标志
//    volatile uint32_t core1_flag;     // 核1标志
//    volatile uint32_t data_buffer[256]; // 数据缓冲区
//    volatile uint32_t write_pos;      // 写位置
//    volatile uint32_t read_pos;       // 读位置
//    volatile uint32_t data_count;     // 数据计数
//} shared_memory_t;

//// 声明共享变量（放在共享内存段中）
//volatile shared_memory_t g_shared_memory __attribute__((section(".sh_mem")));
//volatile shared_memory_t g_shared_memory2 __attribute__((section(".sh_mem")));
can_receive_buf_t* get_writeable_ram(share_buffer_t* block);
int8_t write_head_switch(share_buffer_t* block);



#endif