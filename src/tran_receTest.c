/*
 * Copyright (c) 2021 HPMicro
 *
 * SPDX-License-Identifier: BSD-3-Clause
 *
 */

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
#define LED_FLASH_PERIOD_IN_MS 300

// 定义调试开关
// #define DEBUG_CAN_BUFFER

// 定义共享变量（放在共享内存段中）

#if (BOARD_RUNNING_CORE == HPM_CORE0)
#include "tran_receTest.h"
#include "can_test.h"
#include "multicore_common.h"

// CAN相关全局变量定义
volatile bool has_new_rcv_msg = false;
volatile bool has_sent_out = false; 
volatile bool has_error = false;
volatile uint32_t error_flags = 0;
volatile can_receive_buf_t s_can_rx_buf;

#endif
extern  volatile bool can_read;
extern  volatile bool can_send;
#if (BOARD_RUNNING_CORE == HPM_CORE0)


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

void ram_buffer_block_init(void)
{
    for(int i = 0; i < RAM_BUFFER_BLOCK_SIZE; i++)
    {
        share_buffer_item_init(&ram_buffer_block_items[i], &ram_buffer[i][0], MAX_CAN_BUFFER_SIZE);
    }
    share_buffer_init(&ram_buffer_block, ram_buffer_block_items, RAM_BUFFER_BLOCK_SIZE);
    
    printf("Shared memory CAN buffer initialization completed:\n");
    printf("- Buffer blocks: %d\n", RAM_BUFFER_BLOCK_SIZE);
    printf("- Max frames per block: %d\n", MAX_CAN_BUFFER_SIZE);
    printf("- Total memory usage: %d bytes\n", 
           RAM_BUFFER_BLOCK_SIZE * MAX_CAN_BUFFER_SIZE * sizeof(can_receive_buf_t));
}


void board_can_loopback_test_in_interrupt_mode(void)
{
    CAN_Type *ptr = BOARD_APP_CAN_BASE;
    can_config_t can_config;
    can_get_default_config(&can_config);
    can_config.baudrate = 1000000; /* 1Mbps */
    can_config.mode = can_mode_loopback_internal;
    board_init_can(ptr);
    uint32_t can_src_clk_freq = board_init_can_clock(ptr);
    can_config.irq_txrx_enable_mask = CAN_EVENT_RECEIVE | CAN_EVENT_TX_PRIMARY_BUF | CAN_EVENT_TX_SECONDARY_BUF;
    hpm_stat_t status = can_init(ptr, &can_config, can_src_clk_freq);
    if (status != status_success) {
        printf("CAN initialization failed, error code: %d\n", status);
        return;
    }
    intc_m_enable_irq_with_priority(BOARD_APP_CAN_IRQn, 1);  // CAN中断优先级设为1，允许MBX中断嵌套

    can_transmit_buf_t tx_buf;
    memset(&tx_buf, 0, sizeof(tx_buf));
    tx_buf.dlc = 8;

    for (uint32_t i = 0; i < 8; i++) {
        tx_buf.data[i] = (uint8_t) i | (i << 4);
    }

    for (uint32_t i = 0; i < 2048; i++) {
        tx_buf.id = i;
        can_send_message_nonblocking(BOARD_APP_CAN_BASE, &tx_buf);

        /*mbx发送item_full_notice  */
        if(ram_buffer_block.wait > 0)
        {
            
            mbx_enable_intr(HPM_MBX0A, MBX_CR_TWMEIE_MASK);
            while(1)
            {
                if(can_send){
                    mbx_send_message(HPM_MBX0A, (uint32_t)2);  // 发送当前计数作为消息
                    ram_buffer_block.wait--;
                    break;
                }
            }
        }
        
        


        while (!has_sent_out) {
        }

        while (!has_new_rcv_msg) {

        }
        has_new_rcv_msg = false;
        has_sent_out = false;
        //printf("New message received, ID=%08x\n", s_can_rx_buf.id);
    }
}
/* 优化的CAN中断处理函数 - 直接写入共享内存 */

SDK_DECLARE_EXT_ISR_M(BOARD_APP_CAN_IRQn, board_can_isr)
void board_can_isr(void)
{
    static int count = 0;
    uint8_t flags = can_get_tx_rx_flags(BOARD_APP_CAN_BASE);
   
    if ((flags & CAN_EVENT_RECEIVE) != 0) {
        // 使用本地临时缓冲区接收数据
 
        
        /* 读can并且写共享内存*/

        
        
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

/* 获取可用的共享内存 */
can_receive_buf_t* get_writeable_ram(share_buffer_t* block)
{
    int8_t ret = 0;
    
 
    block->write_head->status = SHARE_BUFFER_STATUS_WRITING;
            
              
            
    /* item 满了*/
    if(block->write_head->current_index + 1> block->write_head->max_index){
        block->write_head->status = SHARE_BUFFER_STATUS_FULL;
        uint8_t index = block->write_head->current_index;
            
        //printf("get_writeable_ram():write_head is full,switch to next item\n");
                     
        //item_full_notice();
        ret = write_head_switch(block);
        if(ret == -1)
        {   
            //printf("get_writeable_ram():next item is not available\n");
            block->is_full = true;
        }
      
        return (can_receive_buf_t*)(block->write_head->data + index ); /* 返回当前item的data*/
    }else{                                                           /* item 未满*/
        
        block->write_head->current_index++;
        return (can_receive_buf_t*)(block->write_head->data + block->write_head->current_index - 1); /* 返回当前item的data*/
    }


}

/* 写头切换 */
int8_t write_head_switch(share_buffer_t* block)
{
    if(block->write_head->next->status == SHARE_BUFFER_STATUS_IDLE)
    {
        block->wait++;
        block->write_head = block->write_head->next;
        block->write_head->status = SHARE_BUFFER_STATUS_WRITING;
        block->write_head->current_index = 0;
        return 0;
    }else{
       // printf("write_head_switch():next item is not available\n");
        return -1;          /* 下一个item不可用*/
    }
    
}
#else
/* consumer */


#endif




#if (BOARD_RUNNING_CORE == HPM_CORE0)
int main(void)
{
   
    
   
    
    board_init();

    multicore_release_cpu(HPM_CORE1, SEC_CORE_IMG_START);
   clock_add_to_group(clock_mbx0, 0);
   
    
    ram_buffer_block_init();
    mbx_interrupt_init();
    board_can_loopback_test_in_interrupt_mode();
    
  

        
    return 0;
}
#else

int main(void)
{

    long long int i = 0;
    board_init_core1();
    mbx_init(HPM_MBX0B);
    hpm_stat_t stat;

    printf("HPM_MBX0B CR: 0x%x\n", HPM_MBX0B->CR);
    printf(" success\n");
    
    clock_add_to_group(clock_mbx0, 0);
    mbx_enable_intr(HPM_MBX0B, MBX_CR_RWMVIE_MASK);
    /* reciever */
    while (1) {
        if (can_read) {
            stat = mbx_retrieve_message(HPM_MBX0B, &i);
            if (stat == status_success) {
                printf("core %d: got %ld\n", BOARD_RUNNING_CORE, i);
                printf("notice_count: %d\n", notice_count);
            } else {
                printf("core %d: error getting message\n", BOARD_RUNNING_CORE);
                
            }
            can_read = false;
            mbx_enable_intr(HPM_MBX0B, MBX_CR_RWMVIE_MASK);
            
            
        }
    }
}
#endif