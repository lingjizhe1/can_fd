#ifndef __GLOBAL_H__
#define __GLOBAL_H__

 #include "share_buffer.h"

 // 内存规划优化：共享内存16KB限制
 #define RAM_BUFFER_BLOCK_SIZE (4)
 #define MAX_CAN_BUFFER_SIZE (50)    // 从1024降到50，适应16KB共享内存
 // 计算：4 × 50 × 80 = 16,000字节 ≈ 15.6KB
 
 
 // 将CAN缓冲区放置在共享内存中，用于核间通信
 #define SHARED_CACHELINE_ALIGN  __attribute__((section(".sh_mem"), aligned(HPM_L1C_CACHELINE_SIZE)))
 #define SHARED_STRUCT_ALIGN     __attribute__((section(".sh_mem"), aligned(32)))
 extern share_buffer_t ram_buffer_block;
 extern share_buffer_item_t ram_buffer_block_items[RAM_BUFFER_BLOCK_SIZE];
 extern SHARED_CACHELINE_ALIGN can_receive_buf_t ram_buffer[RAM_BUFFER_BLOCK_SIZE][MAX_CAN_BUFFER_SIZE];

#endif