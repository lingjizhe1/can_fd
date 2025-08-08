#ifndef CAN_TEST_H
#define CAN_TEST_H

#include <stdint.h>
#include "share_buffer.h"

// CAN相关全局变量声明
extern volatile bool has_new_rcv_msg;
extern volatile bool has_sent_out; 
extern volatile bool has_error;
extern volatile uint32_t error_flags;
extern volatile can_receive_buf_t s_can_rx_buf;

// 共享内存缓冲区相关
extern share_buffer_t ram_buffer_block;
extern share_buffer_item_t ram_buffer_block_items[];
extern can_receive_buf_t ram_buffer[4][50];

// CAN缓冲区管理函数
hpm_stat_t write_can_data_to_shared_buffer(can_receive_buf_t* can_data);
share_buffer_item_t* get_available_buffer_item(void);
void ram_buffer_block_init(void);

// 共享内存读取函数
hpm_stat_t read_can_data_from_shared_buffer(uint16_t buffer_index, uint16_t frame_index, can_receive_buf_t* can_data);
hpm_stat_t get_shared_buffer_status(uint16_t buffer_index, uint16_t* frame_count, uint16_t* max_frames);
hpm_stat_t clear_shared_buffer(uint16_t buffer_index);

// CAN测试函数
void board_can_loopback_test_in_interrupt_mode(void);

#endif