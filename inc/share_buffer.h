#ifndef __SHARE_BUFFER_H__
#define __SHARE_BUFFER_H__

#include <stdint.h>
#include <string.h>
#include <hpm_can_drv.h>

typedef enum
{
    SHARE_BUFFER_STATUS_IDLE = 0,
    SHARE_BUFFER_STATUS_WRITING,
    SHARE_BUFFER_STATUS_READING,
    SHARE_BUFFER_STATUS_FULL,
}share_buffer_status_t;

typedef struct share_buffer_item_t
{
    can_receive_buf_t* data;
    share_buffer_status_t status;
    uint8_t current_index;
    uint8_t max_index;
    struct share_buffer_item_t* next;
}share_buffer_item_t;

typedef struct {
    uint16_t consume_save_index; /*核1将从共享区域的数据存在一个数组里面 需要知道现在保存到哪个位置了提供给下次使用*/
    share_buffer_item_t* items;
    uint16_t size;
    uint16_t wait;
    uint16_t max_wait;
    share_buffer_item_t* write_head;
    share_buffer_item_t* consume_head;
    bool is_full;
}share_buffer_t;




void share_buffer_item_init(share_buffer_item_t* item, can_receive_buf_t* data, uint16_t size);
void share_buffer_init(share_buffer_t* block, share_buffer_item_t* items, uint16_t size);

#endif


