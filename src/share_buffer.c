#include "share_buffer.h"


/* 需要把can缓冲区数据直接写道共享内存中*/








void share_buffer_item_init(share_buffer_item_t* item, can_receive_buf_t* data, uint16_t size)
{
    item->data = data;
    item->status = SHARE_BUFFER_STATUS_IDLE;
    item->current_index = 0;
    item->max_index = size - 1;
}

void share_buffer_init(share_buffer_t* block, share_buffer_item_t* items, uint16_t size)
{
    block->items = items;
    block->size = size;
    block->wait = 0;
    block->max_wait = block->size - 1;
    block->write_head = &items[0];
    block->consume_head = &items[0];
    for(uint16_t i = 0; i < size - 1; i++)/*环形链表初始化*/
    {
        items[i].next = &items[i + 1];
    }
    items[size - 1].next = &items[0];
    block->is_full = false;
}


