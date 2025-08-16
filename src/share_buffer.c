#include "share_buffer.h"
#include "global.h"

/* 需要把can缓冲区数据直接写道共享内存中*/






#if (BOARD_RUNNING_CORE == HPM_CORE0)

typedef struct
{
    uint64_t block_count;
    
}test_speed;

test_speed test_speed_data;

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
    block->consume_head = &items[size-1];
    for(uint16_t i = 0; i < size - 1; i++)/*环形链表初始化*/
    {
        items[i].next = &items[i + 1];
    }
    items[size - 1].next = &items[0];
    block->is_full = false;
}


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

can_receive_buf_t* get_writeable_ram(share_buffer_t* block)
 {
     int8_t ret = 0;
     
  
     block->write_head->status = SHARE_BUFFER_STATUS_WRITING;
    // printf("block->write_head->next->status = %x\n",&(block->write_head->next->status));
             
     /* item 满了*/
     if(block->write_head->current_index + 1> block->write_head->max_index){
        //printf("get_writeable_ram():write_head is full,switch to next item\n"); 
        block->write_head->status = SHARE_BUFFER_STATUS_FULL;
         uint8_t index = block->write_head->current_index;
         share_buffer_item_t* writehead = block->write_head;     
         //printf("get_writeable_ram():write_head is full,switch to next item\n");
                      
         //item_full_notice();
         zushe:
         ret = write_head_switch(block);
         if(ret == -1)
         {   
             //printf("get_writeable_ram():next item is not available\n");
            // block->is_full = true;
             test_speed_data.block_count++;
             //printf("block->write_head->next->status = %x\n",&(block->write_head->next->status));
             //printf("block->write_head->next->status = %d\n",block->write_head->next->status);
             goto zushe;
         }
       
         return (can_receive_buf_t*)(writehead->data + index ); /* 返回当前item的data*/
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
         block->write_head->status = SHARE_BUFFER_STATUS_FULL;
         block->write_head = block->write_head->next;
         block->write_head->status = SHARE_BUFFER_STATUS_WRITING;
         block->write_head->current_index = 0;

         //
         return 0;
     }else{
        // printf("write_head_switch():next item is not available\n");
         return -1;          /* 下一个item不可用*/
     }
     
 }


#else
  /* consumer */
  
 #define AXI_SRAM_CAN_BUFFER_COUNT (2048)
 extern can_receive_buf_t axi_sram_can_buffers[AXI_SRAM_CAN_BUFFER_COUNT];
  int8_t Oconsume_head_switch(share_buffer_t* block)
  {
    //  printf("Oconsume_head_switch:block->consume_head->next->status = %x\n",block->consume_head->next->status);
      if(block->consume_head->next->status == SHARE_BUFFER_STATUS_FULL)
      {
          block->consume_head = block->consume_head->next;
          block->consume_head->status = SHARE_BUFFER_STATUS_READING;
          return 0;
      }else{
          return -1;
      }
  
  }
  
  
  int8_t Ocopy_to_axi_sram(share_buffer_t* block)
  {
      if(block->consume_head->status == SHARE_BUFFER_STATUS_READING)
      {
         memcpy(&axi_sram_can_buffers[block->consume_save_index], block->consume_head->data, MAX_CAN_BUFFER_SIZE * sizeof(can_receive_buf_t));
         block->consume_save_index += MAX_CAN_BUFFER_SIZE;
         if(block->consume_save_index > AXI_SRAM_CAN_BUFFER_COUNT)
         {
              block->consume_save_index = 0;
         }
         block->consume_head->status = SHARE_BUFFER_STATUS_IDLE;
         //printf("hello\n");
      
         memset(block->consume_head->data, 0, MAX_CAN_BUFFER_SIZE * sizeof(can_receive_buf_t));
         return 0;
      }
      return -1;
  }
#endif