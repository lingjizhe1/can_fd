#if (BOARD_RUNNING_CORE == HPM_CORE0)
#include "multicore_common.h"
#include "hpm_mbx_drv.h"
#include "hpm_can_drv.h"
#include "hpm_gptmr_drv.h"
#include "board.h"
#include "isr0.h"
#include "global.h"
#include "hpm_interrupt.h"
volatile bool can_read = false;
volatile bool can_send = false;

#define MBX HPM_MBX0A
#define MBX_IRQ IRQn_MBX0A

// Timer related definitions
#define TIMER_GPTMR BOARD_GPTMR
#define TIMER_CH BOARD_GPTMR_CHANNEL
#define TIMER_IRQ BOARD_GPTMR_IRQ

extern volatile bool has_new_rcv_msg;
extern volatile bool has_sent_out; 
extern volatile bool has_error;
extern volatile uint32_t error_flags;
extern volatile can_receive_buf_t s_can_rx_buf;
extern speed_test_t speed_test_data;

// Timer interrupt variables
static volatile uint8_t timer_count = 0;
static volatile bool timer_enabled = true;
static volatile bool print_results = false;

SDK_DECLARE_EXT_ISR_M(BOARD_APP_CAN_IRQn, board_can_isr)
 void board_can_isr(void)
 {
     static int count = 0;
     uint8_t flags = can_get_tx_rx_flags(BOARD_APP_CAN_BASE);
    
     if ((flags & CAN_EVENT_RECEIVE) != 0) {
         // 使用本地临时缓冲区接收数据
  

         
         
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

    
    //printf("MBX ISR: Exiting\n");
}

// Timer interrupt service routine
SDK_DECLARE_EXT_ISR_M(TIMER_IRQ, timer_isr)
void timer_isr(void)
{
    if (gptmr_check_status(TIMER_GPTMR, GPTMR_CH_RLD_STAT_MASK(TIMER_CH))) {
        gptmr_clear_status(TIMER_GPTMR, GPTMR_CH_RLD_STAT_MASK(TIMER_CH));
        
        if (timer_enabled && timer_count < 60) {
            // Save current frame count with protection
            //uint32_t mstatus = disable_global_irq(CSR_MSTATUS_MIE_MASK);
            speed_test_data.frame_count[timer_count] = speed_test_data.frame_sent_count;
            uint8_t current_count = timer_count;
            timer_count++;
            //enable_global_irq(mstatus);
            
            // Check if 60 seconds completed
            if (timer_count >= 60) {
                timer_enabled = false;
                gptmr_disable_irq(TIMER_GPTMR, GPTMR_CH_RLD_IRQ_MASK(TIMER_CH));
                print_results = true;
            }
        }
    }
}

// Timer initialization function
void timer_interrupt_init(void)
{
    uint32_t gptmr_freq;
    gptmr_channel_config_t config;

    // Initialize timer clock and pins
    init_gptmr_pins(TIMER_GPTMR);
    gptmr_freq = board_init_gptmr_clock(TIMER_GPTMR);
    
    // Get default configuration
    gptmr_channel_get_default_config(TIMER_GPTMR, &config);
    
    // Set reload value for 1 second (1000ms)
    config.reload = gptmr_freq / 1000 * 1000;
    
    // Configure timer channel
    gptmr_channel_config(TIMER_GPTMR, TIMER_CH, &config, false);
    
    // Reset variables
    timer_count = 0;
    timer_enabled = true;
    
    // Enable timer interrupt
    gptmr_enable_irq(TIMER_GPTMR, GPTMR_CH_RLD_IRQ_MASK(TIMER_CH));
    intc_m_enable_irq_with_priority(TIMER_IRQ, 2);
    
    // Start timer
    gptmr_start_counter(TIMER_GPTMR, TIMER_CH);
}

// Check and print results function
void check_and_print_results(void)
{
    if (print_results) {
        print_results = false;
        
        // Calculate frame differences for each second
        uint64_t frame_per_second[60];
        uint64_t min_frames = 0xFFFFFFFFFFFFFFFFULL;
        uint64_t max_frames = 0;
        uint64_t total_for_avg = 0;
        
        printf("Frame count results (60 seconds):\n");
        for (int i = 0; i < 60; i++) {
            if (i == 0) {
                frame_per_second[i] = speed_test_data.frame_count[i];
            } else {
                frame_per_second[i] = speed_test_data.frame_count[i] - speed_test_data.frame_count[i-1];
            }
            
            // Find min and max
            if (frame_per_second[i] < min_frames) {
                min_frames = frame_per_second[i];
            }
            if (frame_per_second[i] > max_frames) {
                max_frames = frame_per_second[i];
            }
            
            printf("Second %d: %llu frames\n", i + 1, frame_per_second[i]);
        }
        
        // Calculate average excluding min and max
        for (int i = 0; i < 60; i++) {
            total_for_avg += frame_per_second[i];
        }
        total_for_avg -= min_frames;
        total_for_avg -= max_frames;
        
        uint64_t average = total_for_avg / 58; // 60 - 2 (min and max)
        
        printf("\nStatistics:\n");
        printf("Total frames sent: %llu\n", speed_test_data.frame_sent_count);
        printf("Min frames per second: %llu\n", min_frames);
        printf("Max frames per second: %llu\n", max_frames);
        printf("Average frames per second (excluding min/max): %llu\n", average);
    }
}

#endif


