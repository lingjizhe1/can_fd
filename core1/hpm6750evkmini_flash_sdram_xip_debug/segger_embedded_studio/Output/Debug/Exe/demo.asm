
Output/Debug/Exe/demo.elf:     file format elf32-littleriscv


Disassembly of section .init._start:

00000000 <_start>:
#define L(label) .L_start_##label

START_FUNC _start
        .option push
        .option norelax
        lui     gp,     %hi(__global_pointer$)
   0:	000011b7          	lui	gp,0x1
        addi    gp, gp, %lo(__global_pointer$)
   4:	8a418193          	add	gp,gp,-1884 # 8a4 <__global_pointer$>
        lui     tp,     %hi(__thread_pointer$)
   8:	01151237          	lui	tp,0x1151
        addi    tp, tp, %lo(__thread_pointer$)
   c:	80020213          	add	tp,tp,-2048 # 1150800 <__thread_pointer$>
        .option pop

        csrw    mstatus, zero
  10:	30001073          	csrw	mstatus,zero
        csrw    mcause, zero
  14:	34201073          	csrw	mcause,zero
    /* Initialize FCSR */
    fscsr zero
#endif

    /* Enable LMM1 clock */
    la t0, 0xF4000800
  18:	f40012b7          	lui	t0,0xf4001
  1c:	80028293          	add	t0,t0,-2048 # f4000800 <__SHARE_RAM_segment_end__+0xf2e80800>
    lw t1, 0(t0)
  20:	0002a303          	lw	t1,0(t0)
    ori t1, t1, 0x80
  24:	08036313          	or	t1,t1,128
    sw t1, 0(t0)
  28:	0062a023          	sw	t1,0(t0)
    la t0, _stack_safe
    mv sp, t0
    call _init_ext_ram
#endif

        lui     t0,     %hi(__stack_end__)
  2c:	000c02b7          	lui	t0,0xc0
        addi    sp, t0, %lo(__stack_end__)
  30:	00028113          	mv	sp,t0

#ifdef CONFIG_NOT_ENABLE_ICACHE
        call    l1c_ic_disable
#else
        call    l1c_ic_enable
  34:	426010ef          	jal	145a <l1c_ic_enable>
#endif
#ifdef CONFIG_NOT_ENABLE_DCACHE
        call    l1c_dc_invalidate_all
        call    l1c_dc_disable
#else
        call    l1c_dc_enable
  38:	3ce010ef          	jal	1406 <l1c_dc_enable>
        call    l1c_dc_invalidate_all
  3c:	6ef020ef          	jal	2f2a <l1c_dc_invalidate_all>

#ifndef __NO_SYSTEM_INIT
        //
        // Call _init
        //
        call    _init
  40:	19d030ef          	jal	39dc <_init>

00000044 <.Lpcrel_hi0>:
        // Call linker init functions which in turn performs the following:
        // * Perform segment init
        // * Perform heap init (if used)
        // * Call constructors of global Objects (if any exist)
        //
        la      s0, __SEGGER_init_table__       // Set table pointer to start of initialization table
  44:	00005437          	lui	s0,0x5
  48:	7cc40413          	add	s0,s0,1996 # 57cc <.L155+0x2>

0000004c <.L_start_RunInit>:
L(RunInit):
        lw      a0, (s0)                        // Get next initialization function from table
  4c:	4008                	lw	a0,0(s0)
        add     s0, s0, 4                       // Increment table pointer to point to function arguments
  4e:	0411                	add	s0,s0,4
        jalr    a0                              // Call initialization function
  50:	9502                	jalr	a0
        j       L(RunInit)
  52:	bfed                	j	4c <.L_start_RunInit>

00000054 <__SEGGER_init_done>:
        // Time to call main(), the application entry point.
        //

#ifndef NO_CLEANUP_AT_START
    /* clean up */
    call _clean_up
  54:	0c5030ef          	jal	3918 <_clean_up>

00000058 <.Lpcrel_hi1>:
    #define HANDLER_S_TRAP irq_handler_s_trap
#endif

#if !defined(USE_NONVECTOR_MODE) || (USE_NONVECTOR_MODE == 0)
    /* Initial machine trap-vector Base */
    la t0, __vector_table
  58:	95c18293          	add	t0,gp,-1700 # 200 <__vector_table>
    csrw mtvec, t0
  5c:	30529073          	csrw	mtvec,t0

    /* Enable vectored external PLIC interrupt */
    csrsi CSR_MMISC_CTL, 2
  60:	7d016073          	csrs	0x7d0,2

00000064 <start>:
        //
        // In a real embedded application ("Free-standing environment"),
        // main() does not get any arguments,
        // which means it is not necessary to init a0 and a1.
        //
        call    APP_ENTRY_POINT
  64:	161030ef          	jal	39c4 <reset_handler>
        tail    exit
  68:	a009                	j	6a <exit>

0000006a <exit>:
MARK_FUNC exit
        //
        // In a free-standing environment, if returned from application:
        // Loop forever.
        //
        j       .
  6a:	a001                	j	6a <exit>
        la      a1, args
        call    debug_getargs
        li      a0, ARGSSPACE
        la      a1, args
#else
        li      a0, 0
  6c:	4501                	li	a0,0
        li      a1, 0
  6e:	4581                	li	a1,0
#endif

        call    APP_ENTRY_POINT
  70:	155030ef          	jal	39c4 <reset_handler>
        tail    exit
  74:	bfdd                	j	6a <exit>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_DFL:

00000076 <__SEGGER_RTL_SIGNAL_SIG_DFL>:
  76:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_IGN:

000001fe <__SEGGER_RTL_SIGNAL_SIG_IGN>:
 1fe:	8082                	ret

Disassembly of section .isr_vector:

00000400 <board_timer_isr>:

#if !defined(NO_BOARD_TIMER_SUPPORT) || !NO_BOARD_TIMER_SUPPORT
static board_timer_cb timer_cb;
SDK_DECLARE_EXT_ISR_M(BOARD_CALLBACK_TIMER_IRQ, board_timer_isr)
void board_timer_isr(void)
{
 400:	1141                	add	sp,sp,-16
 402:	c606                	sw	ra,12(sp)
    if (gptmr_check_status(BOARD_CALLBACK_TIMER, GPTMR_CH_RLD_STAT_MASK(BOARD_CALLBACK_TIMER_CH))) {
 404:	45c1                	li	a1,16
 406:	f301c537          	lui	a0,0xf301c
 40a:	339020ef          	jal	2f42 <gptmr_check_status>
 40e:	87aa                	mv	a5,a0
 410:	cb89                	beqz	a5,422 <.L97>
        gptmr_clear_status(BOARD_CALLBACK_TIMER, GPTMR_CH_RLD_STAT_MASK(BOARD_CALLBACK_TIMER_CH));
 412:	45c1                	li	a1,16
 414:	f301c537          	lui	a0,0xf301c
 418:	34f020ef          	jal	2f66 <gptmr_clear_status>
        timer_cb();
 41c:	82c22783          	lw	a5,-2004(tp) # fffff82c <__SHARE_RAM_segment_end__+0xfee7f82c>
 420:	9782                	jalr	a5

00000422 <.L97>:
    }
}
 422:	0001                	nop
 424:	40b2                	lw	ra,12(sp)
 426:	0141                	add	sp,sp,16
 428:	8082                	ret

0000042a <default_isr_67>:
SDK_DECLARE_EXT_ISR_M(BOARD_CALLBACK_TIMER_IRQ, board_timer_isr)
 42a:	711d                	add	sp,sp,-96
 42c:	c006                	sw	ra,0(sp)
 42e:	c216                	sw	t0,4(sp)
 430:	c41a                	sw	t1,8(sp)
 432:	c61e                	sw	t2,12(sp)
 434:	c826                	sw	s1,16(sp)
 436:	ca2a                	sw	a0,20(sp)
 438:	cc2e                	sw	a1,24(sp)
 43a:	ce32                	sw	a2,28(sp)
 43c:	d036                	sw	a3,32(sp)
 43e:	d23a                	sw	a4,36(sp)
 440:	d43e                	sw	a5,40(sp)
 442:	d642                	sw	a6,44(sp)
 444:	d846                	sw	a7,48(sp)
 446:	da4a                	sw	s2,52(sp)
 448:	dc4e                	sw	s3,56(sp)
 44a:	de52                	sw	s4,60(sp)
 44c:	c0d6                	sw	s5,64(sp)
 44e:	c2da                	sw	s6,68(sp)
 450:	c4f2                	sw	t3,72(sp)
 452:	c6f6                	sw	t4,76(sp)
 454:	c8fa                	sw	t5,80(sp)
 456:	cafe                	sw	t6,84(sp)
 458:	34102973          	csrr	s2,mepc
 45c:	300029f3          	csrr	s3,mstatus
 460:	7cb02af3          	csrr	s5,0x7cb
 464:	7cd02b73          	csrr	s6,0x7cd
 468:	30046073          	csrs	mstatus,8
 46c:	b5c18313          	add	t1,gp,-1188 # 400 <board_timer_isr>
 470:	9302                	jalr	t1
 472:	30047073          	csrc	mstatus,8
 476:	e4200737          	lui	a4,0xe4200
 47a:	04300693          	li	a3,67
 47e:	c354                	sw	a3,4(a4)
 480:	30099073          	csrw	mstatus,s3
 484:	34191073          	csrw	mepc,s2
 488:	7cdb1073          	csrw	0x7cd,s6
 48c:	7cba9073          	csrw	0x7cb,s5
 490:	4082                	lw	ra,0(sp)
 492:	4292                	lw	t0,4(sp)
 494:	4322                	lw	t1,8(sp)
 496:	43b2                	lw	t2,12(sp)
 498:	44c2                	lw	s1,16(sp)
 49a:	4552                	lw	a0,20(sp)
 49c:	45e2                	lw	a1,24(sp)
 49e:	4672                	lw	a2,28(sp)
 4a0:	5682                	lw	a3,32(sp)
 4a2:	5712                	lw	a4,36(sp)
 4a4:	57a2                	lw	a5,40(sp)
 4a6:	5832                	lw	a6,44(sp)
 4a8:	58c2                	lw	a7,48(sp)
 4aa:	5952                	lw	s2,52(sp)
 4ac:	59e2                	lw	s3,56(sp)
 4ae:	5a72                	lw	s4,60(sp)
 4b0:	4a86                	lw	s5,64(sp)
 4b2:	4b16                	lw	s6,68(sp)
 4b4:	4e26                	lw	t3,72(sp)
 4b6:	4eb6                	lw	t4,76(sp)
 4b8:	4f46                	lw	t5,80(sp)
 4ba:	4fd6                	lw	t6,84(sp)
 4bc:	6125                	add	sp,sp,96
 4be:	0cc0000f          	fence	io,io
 4c2:	30200073          	mret

Disassembly of section .isr_vector:

000004c8 <isr_mbx>:
#define MBX_IRQ IRQn_MBX0B

volatile uint8_t notice_count = 0;/* 获取通知次数，每次获取代表core0写满了一个item  */
SDK_DECLARE_EXT_ISR_M(MBX_IRQ, isr_mbx)
void isr_mbx(void)
{
 4c8:	1101                	add	sp,sp,-32
 4ca:	ce06                	sw	ra,28(sp)
   
    volatile uint32_t sr = MBX->SR;
 4cc:	f00a47b7          	lui	a5,0xf00a4
 4d0:	43dc                	lw	a5,4(a5)
 4d2:	c63e                	sw	a5,12(sp)
    volatile uint32_t cr = MBX->CR;
 4d4:	f00a47b7          	lui	a5,0xf00a4
 4d8:	439c                	lw	a5,0(a5)
 4da:	c43e                	sw	a5,8(sp)
    if ((sr & MBX_SR_RWMV_MASK) && (cr & MBX_CR_RWMVIE_MASK)) {
 4dc:	47b2                	lw	a5,12(sp)
 4de:	8b85                	and	a5,a5,1
 4e0:	c78d                	beqz	a5,50a <.L4>
 4e2:	47a2                	lw	a5,8(sp)
 4e4:	8b85                	and	a5,a5,1
 4e6:	c395                	beqz	a5,50a <.L4>
        can_read = true;
 4e8:	4705                	li	a4,1
 4ea:	84e202a3          	sb	a4,-1979(tp) # fffff845 <__SHARE_RAM_segment_end__+0xfee7f845>
        notice_count++;
 4ee:	84424783          	lbu	a5,-1980(tp) # fffff844 <__SHARE_RAM_segment_end__+0xfee7f844>
 4f2:	0ff7f793          	zext.b	a5,a5
 4f6:	0785                	add	a5,a5,1 # f00a4001 <__SHARE_RAM_segment_end__+0xeef24001>
 4f8:	0ff7f713          	zext.b	a4,a5
 4fc:	84e20223          	sb	a4,-1980(tp) # fffff844 <__SHARE_RAM_segment_end__+0xfee7f844>
        mbx_disable_intr(MBX, MBX_CR_RWMVIE_MASK);
 500:	4585                	li	a1,1
 502:	f00a4537          	lui	a0,0xf00a4
 506:	3aa030ef          	jal	38b0 <mbx_disable_intr>

0000050a <.L4>:
    } 

}
 50a:	0001                	nop
 50c:	40f2                	lw	ra,28(sp)
 50e:	6105                	add	sp,sp,32
 510:	8082                	ret

00000512 <default_isr_57>:
SDK_DECLARE_EXT_ISR_M(MBX_IRQ, isr_mbx)
 512:	711d                	add	sp,sp,-96
 514:	c006                	sw	ra,0(sp)
 516:	c216                	sw	t0,4(sp)
 518:	c41a                	sw	t1,8(sp)
 51a:	c61e                	sw	t2,12(sp)
 51c:	c826                	sw	s1,16(sp)
 51e:	ca2a                	sw	a0,20(sp)
 520:	cc2e                	sw	a1,24(sp)
 522:	ce32                	sw	a2,28(sp)
 524:	d036                	sw	a3,32(sp)
 526:	d23a                	sw	a4,36(sp)
 528:	d43e                	sw	a5,40(sp)
 52a:	d642                	sw	a6,44(sp)
 52c:	d846                	sw	a7,48(sp)
 52e:	da4a                	sw	s2,52(sp)
 530:	dc4e                	sw	s3,56(sp)
 532:	de52                	sw	s4,60(sp)
 534:	c0d6                	sw	s5,64(sp)
 536:	c2da                	sw	s6,68(sp)
 538:	c4f2                	sw	t3,72(sp)
 53a:	c6f6                	sw	t4,76(sp)
 53c:	c8fa                	sw	t5,80(sp)
 53e:	cafe                	sw	t6,84(sp)
 540:	34102973          	csrr	s2,mepc
 544:	300029f3          	csrr	s3,mstatus
 548:	7cb02af3          	csrr	s5,0x7cb
 54c:	7cd02b73          	csrr	s6,0x7cd
 550:	30046073          	csrs	mstatus,8
 554:	c2418313          	add	t1,gp,-988 # 4c8 <isr_mbx>
 558:	9302                	jalr	t1
 55a:	30047073          	csrc	mstatus,8
 55e:	e4200737          	lui	a4,0xe4200
 562:	03900693          	li	a3,57
 566:	c354                	sw	a3,4(a4)
 568:	30099073          	csrw	mstatus,s3
 56c:	34191073          	csrw	mepc,s2
 570:	7cdb1073          	csrw	0x7cd,s6
 574:	7cba9073          	csrw	0x7cb,s5
 578:	4082                	lw	ra,0(sp)
 57a:	4292                	lw	t0,4(sp)
 57c:	4322                	lw	t1,8(sp)
 57e:	43b2                	lw	t2,12(sp)
 580:	44c2                	lw	s1,16(sp)
 582:	4552                	lw	a0,20(sp)
 584:	45e2                	lw	a1,24(sp)
 586:	4672                	lw	a2,28(sp)
 588:	5682                	lw	a3,32(sp)
 58a:	5712                	lw	a4,36(sp)
 58c:	57a2                	lw	a5,40(sp)
 58e:	5832                	lw	a6,44(sp)
 590:	58c2                	lw	a7,48(sp)
 592:	5952                	lw	s2,52(sp)
 594:	59e2                	lw	s3,56(sp)
 596:	5a72                	lw	s4,60(sp)
 598:	4a86                	lw	s5,64(sp)
 59a:	4b16                	lw	s6,68(sp)
 59c:	4e26                	lw	t3,72(sp)
 59e:	4eb6                	lw	t4,76(sp)
 5a0:	4f46                	lw	t5,80(sp)
 5a2:	4fd6                	lw	t6,84(sp)
 5a4:	6125                	add	sp,sp,96
 5a6:	0cc0000f          	fence	io,io
 5aa:	30200073          	mret

Disassembly of section .isr_vector:

000005b0 <nmi_handler>:
#endif

    .section .isr_vector, "ax"
    .weak nmi_handler
nmi_handler:
1:    j 1b
 5b0:	a001                	j	5b0 <nmi_handler>

000005b2 <default_irq_handler>:
#else

.weak default_irq_handler
.align 2
default_irq_handler:
1:    j 1b
 5b2:	a001                	j	5b2 <default_irq_handler>

Disassembly of section .isr_vector:

000005b4 <irq_handler_trap>:
#if defined(__ICCRISCV__) && (IRQ_HANDLER_TRAP_AS_ISR == 1)
extern int __vector_table[];
HPM_ATTR_MACHINE_INTERRUPT
#endif
void irq_handler_trap(void)
{
 5b4:	7175                	add	sp,sp,-144
 5b6:	c706                	sw	ra,140(sp)
 5b8:	c516                	sw	t0,136(sp)
 5ba:	c31a                	sw	t1,132(sp)
 5bc:	c11e                	sw	t2,128(sp)
 5be:	deaa                	sw	a0,124(sp)
 5c0:	dcae                	sw	a1,120(sp)
 5c2:	dab2                	sw	a2,116(sp)
 5c4:	d8b6                	sw	a3,112(sp)
 5c6:	d6ba                	sw	a4,108(sp)
 5c8:	d4be                	sw	a5,104(sp)
 5ca:	d2c2                	sw	a6,100(sp)
 5cc:	d0c6                	sw	a7,96(sp)
 5ce:	cef2                	sw	t3,92(sp)
 5d0:	ccf6                	sw	t4,88(sp)
 5d2:	cafa                	sw	t5,84(sp)
 5d4:	c8fe                	sw	t6,80(sp)

000005d6 <.LBB19>:
    long mcause = read_csr(CSR_MCAUSE);
 5d6:	342027f3          	csrr	a5,mcause
 5da:	c4be                	sw	a5,72(sp)
 5dc:	47a6                	lw	a5,72(sp)

000005de <.LBE19>:
 5de:	c2be                	sw	a5,68(sp)

000005e0 <.LBB20>:
    long mepc = read_csr(CSR_MEPC);
 5e0:	341027f3          	csrr	a5,mepc
 5e4:	c0be                	sw	a5,64(sp)
 5e6:	4786                	lw	a5,64(sp)

000005e8 <.LBE20>:
 5e8:	c6be                	sw	a5,76(sp)

000005ea <.LBB21>:
    long mstatus = read_csr(CSR_MSTATUS);
 5ea:	300027f3          	csrr	a5,mstatus
 5ee:	de3e                	sw	a5,60(sp)
 5f0:	57f2                	lw	a5,60(sp)

000005f2 <.LBE21>:
 5f2:	dc3e                	sw	a5,56(sp)

000005f4 <.LBB22>:
    int ucode = read_csr(CSR_UCODE);
#endif
#ifdef __riscv_flen
    int fcsr = read_fcsr();
#endif
    int mcctlbeginaddr = read_csr(CSR_MCCTLBEGINADDR);
 5f4:	7cb027f3          	csrr	a5,0x7cb
 5f8:	da3e                	sw	a5,52(sp)
 5fa:	57d2                	lw	a5,52(sp)

000005fc <.LBE22>:
 5fc:	d83e                	sw	a5,48(sp)

000005fe <.LBB23>:
    int mcctldata = read_csr(CSR_MCCTLDATA);
 5fe:	7cd027f3          	csrr	a5,0x7cd
 602:	d63e                	sw	a5,44(sp)
 604:	57b2                	lw	a5,44(sp)

00000606 <.LBE23>:
 606:	d43e                	sw	a5,40(sp)
#else
    __asm volatile("" : : : "a7", "a0", "a1", "a2", "a3");
#endif

    /* Do your trap handling */
    if ((mcause & CSR_MCAUSE_INTERRUPT_MASK) && ((mcause & CSR_MCAUSE_EXCEPTION_CODE_MASK) == IRQ_M_TIMER)) {
 608:	4796                	lw	a5,68(sp)
 60a:	0007dc63          	bgez	a5,622 <.L25>
 60e:	4716                	lw	a4,68(sp)
 610:	6785                	lui	a5,0x1
 612:	17fd                	add	a5,a5,-1 # fff <.LC11+0xb>
 614:	8f7d                	and	a4,a4,a5
 616:	479d                	li	a5,7
 618:	00f71563          	bne	a4,a5,622 <.L25>
        /* Machine timer interrupt */
        mchtmr_isr();
 61c:	3c4030ef          	jal	39e0 <mchtmr_isr>
 620:	a04d                	j	6c2 <.L26>

00000622 <.L25>:
            __plic_complete_irq(HPM_PLIC_BASE, HPM_PLIC_TARGET_M_MODE, irq_index);
        }
    }
#endif

    else if ((mcause & CSR_MCAUSE_INTERRUPT_MASK) && ((mcause & CSR_MCAUSE_EXCEPTION_CODE_MASK) == IRQ_M_SOFT)) {
 622:	4796                	lw	a5,68(sp)
 624:	0607d263          	bgez	a5,688 <.L27>
 628:	4716                	lw	a4,68(sp)
 62a:	6785                	lui	a5,0x1
 62c:	17fd                	add	a5,a5,-1 # fff <.LC11+0xb>
 62e:	8f7d                	and	a4,a4,a5
 630:	478d                	li	a5,3
 632:	04f71b63          	bne	a4,a5,688 <.L27>
 636:	e64007b7          	lui	a5,0xe6400
 63a:	ca3e                	sw	a5,20(sp)
 63c:	c802                	sw	zero,16(sp)

0000063e <.LBB24>:
 */
ATTR_ALWAYS_INLINE static inline uint32_t __plic_claim_irq(uint32_t base, uint32_t target)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
            HPM_PLIC_CLAIM_OFFSET +
            (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
 63e:	47c2                	lw	a5,16(sp)
 640:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_CLAIM_OFFSET +
 644:	47d2                	lw	a5,20(sp)
 646:	973e                	add	a4,a4,a5
 648:	002007b7          	lui	a5,0x200
 64c:	0791                	add	a5,a5,4 # 200004 <__DLM_segment_end__+0x140004>
 64e:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
 650:	c63e                	sw	a5,12(sp)
    return *claim_addr;
 652:	47b2                	lw	a5,12(sp)
 654:	439c                	lw	a5,0(a5)

00000656 <.LBE26>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_m_claim_swi(void)
{
    __plic_claim_irq(HPM_PLICSW_BASE, 0);
}
 656:	0001                	nop

00000658 <.LBE24>:
        /* Machine SWI interrupt */
        intc_m_claim_swi();
        swi_isr();
 658:	38c030ef          	jal	39e4 <swi_isr>
 65c:	e64007b7          	lui	a5,0xe6400
 660:	d23e                	sw	a5,36(sp)
 662:	d002                	sw	zero,32(sp)
 664:	4785                	li	a5,1
 666:	ce3e                	sw	a5,28(sp)

00000668 <.LBB28>:
                                                          uint32_t target,
                                                          uint32_t irq)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
            HPM_PLIC_CLAIM_OFFSET +
            (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
 668:	5782                	lw	a5,32(sp)
 66a:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_CLAIM_OFFSET +
 66e:	5792                	lw	a5,36(sp)
 670:	973e                	add	a4,a4,a5
 672:	002007b7          	lui	a5,0x200
 676:	0791                	add	a5,a5,4 # 200004 <__DLM_segment_end__+0x140004>
 678:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
 67a:	cc3e                	sw	a5,24(sp)
    *claim_addr = irq;
 67c:	47e2                	lw	a5,24(sp)
 67e:	4772                	lw	a4,28(sp)
 680:	c398                	sw	a4,0(a5)
}
 682:	0001                	nop

00000684 <.LBE30>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_m_complete_swi(void)
{
    __plic_complete_irq(HPM_PLICSW_BASE, HPM_PLIC_TARGET_M_MODE, PLICSWI);
}
 684:	0001                	nop

00000686 <.LBE28>:
        intc_m_complete_swi();
 686:	a835                	j	6c2 <.L26>

00000688 <.L27>:
    } else if (!(mcause & CSR_MCAUSE_INTERRUPT_MASK) && ((mcause & CSR_MCAUSE_EXCEPTION_CODE_MASK) == MCAUSE_ECALL_FROM_MACHINE_MODE)) {
 688:	4796                	lw	a5,68(sp)
 68a:	0207c763          	bltz	a5,6b8 <.L29>
 68e:	4716                	lw	a4,68(sp)
 690:	6785                	lui	a5,0x1
 692:	17fd                	add	a5,a5,-1 # fff <.LC11+0xb>
 694:	8f7d                	and	a4,a4,a5
 696:	47ad                	li	a5,11
 698:	02f71063          	bne	a4,a5,6b8 <.L29>
        /* Machine Syscal call */
        __asm volatile(
 69c:	000027b7          	lui	a5,0x2
 6a0:	cd278793          	add	a5,a5,-814 # 1cd2 <syscall_handler>
 6a4:	8736                	mv	a4,a3
 6a6:	86b2                	mv	a3,a2
 6a8:	862e                	mv	a2,a1
 6aa:	85aa                	mv	a1,a0
 6ac:	8546                	mv	a0,a7
 6ae:	9782                	jalr	a5
        "mv a0, a7\n"
        #endif
        "jalr %0\n"
        : : "r"(syscall_handler) : "a4"
        );
        mepc += 4;
 6b0:	47b6                	lw	a5,76(sp)
 6b2:	0791                	add	a5,a5,4
 6b4:	c6be                	sw	a5,76(sp)
 6b6:	a031                	j	6c2 <.L26>

000006b8 <.L29>:
    } else {
        mepc = exception_handler(mcause, mepc);
 6b8:	45b6                	lw	a1,76(sp)
 6ba:	4516                	lw	a0,68(sp)
 6bc:	32c030ef          	jal	39e8 <exception_handler>
 6c0:	c6aa                	sw	a0,76(sp)

000006c2 <.L26>:
    }

    /* Restore CSR */
    write_csr(CSR_MSTATUS, mstatus);
 6c2:	57e2                	lw	a5,56(sp)
 6c4:	30079073          	csrw	mstatus,a5
    write_csr(CSR_MEPC, mepc);
 6c8:	47b6                	lw	a5,76(sp)
 6ca:	34179073          	csrw	mepc,a5
    write_csr(CSR_UCODE, ucode);
#endif
#ifdef __riscv_flen
    write_fcsr(fcsr);
#endif
    write_csr(CSR_MCCTLDATA, mcctldata);
 6ce:	57a2                	lw	a5,40(sp)
 6d0:	7cd79073          	csrw	0x7cd,a5
    write_csr(CSR_MCCTLBEGINADDR, mcctlbeginaddr);
 6d4:	57c2                	lw	a5,48(sp)
 6d6:	7cb79073          	csrw	0x7cb,a5
}
 6da:	0001                	nop
 6dc:	40ba                	lw	ra,140(sp)
 6de:	42aa                	lw	t0,136(sp)
 6e0:	431a                	lw	t1,132(sp)
 6e2:	438a                	lw	t2,128(sp)
 6e4:	5576                	lw	a0,124(sp)
 6e6:	55e6                	lw	a1,120(sp)
 6e8:	5656                	lw	a2,116(sp)
 6ea:	56c6                	lw	a3,112(sp)
 6ec:	5736                	lw	a4,108(sp)
 6ee:	57a6                	lw	a5,104(sp)
 6f0:	5816                	lw	a6,100(sp)
 6f2:	5886                	lw	a7,96(sp)
 6f4:	4e76                	lw	t3,92(sp)
 6f6:	4ee6                	lw	t4,88(sp)
 6f8:	4f56                	lw	t5,84(sp)
 6fa:	4fc6                	lw	t6,80(sp)
 6fc:	6149                	add	sp,sp,144
 6fe:	30200073          	mret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_ERR:

00000702 <__SEGGER_RTL_SIGNAL_SIG_ERR>:
 702:	8082                	ret

Disassembly of section .text.l1c_dc_enable:

00001406 <l1c_dc_enable>:
    }
#endif
}

void l1c_dc_enable(void)
{
    1406:	1101                	add	sp,sp,-32
    1408:	ce06                	sw	ra,28(sp)

0000140a <.LBB48>:
#endif

/* get cache control register value */
ATTR_ALWAYS_INLINE static inline uint32_t l1c_get_control(void)
{
    return read_csr(CSR_MCACHE_CTL);
    140a:	7ca027f3          	csrr	a5,0x7ca
    140e:	c63e                	sw	a5,12(sp)
    1410:	47b2                	lw	a5,12(sp)

00001412 <.LBE52>:
    1412:	0001                	nop

00001414 <.LBE50>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_dc_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
    1414:	8b89                	and	a5,a5,2
    1416:	00f037b3          	snez	a5,a5
    141a:	0ff7f793          	zext.b	a5,a5

0000141e <.LBE48>:
    if (!l1c_dc_is_enabled()) {
    141e:	0017c793          	xor	a5,a5,1
    1422:	0ff7f793          	zext.b	a5,a5
    1426:	c791                	beqz	a5,1432 <.L11>
#ifdef L1C_DC_DISABLE_WRITEAROUND_ON_ENABLE
        l1c_dc_disable_writearound();
#else
        l1c_dc_enable_writearound();
    1428:	20ad                	jal	1492 <l1c_dc_enable_writearound>
#endif
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DPREF_EN_MASK | HPM_MCACHE_CTL_DC_EN_MASK);
    142a:	40200793          	li	a5,1026
    142e:	7ca7a073          	csrs	0x7ca,a5

00001432 <.L11>:
    }
}
    1432:	0001                	nop
    1434:	40f2                	lw	ra,28(sp)
    1436:	6105                	add	sp,sp,32
    1438:	8082                	ret

Disassembly of section .text.l1c_ic_enable:

0000145a <l1c_ic_enable>:
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
    }
}

void l1c_ic_enable(void)
{
    145a:	1141                	add	sp,sp,-16

0000145c <.LBB58>:
    return read_csr(CSR_MCACHE_CTL);
    145c:	7ca027f3          	csrr	a5,0x7ca
    1460:	c63e                	sw	a5,12(sp)
    1462:	47b2                	lw	a5,12(sp)

00001464 <.LBE62>:
    1464:	0001                	nop

00001466 <.LBE60>:
}

ATTR_ALWAYS_INLINE static inline bool l1c_ic_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
    1466:	8b85                	and	a5,a5,1
    1468:	00f037b3          	snez	a5,a5
    146c:	0ff7f793          	zext.b	a5,a5

00001470 <.LBE58>:
    if (!l1c_ic_is_enabled()) {
    1470:	0017c793          	xor	a5,a5,1
    1474:	0ff7f793          	zext.b	a5,a5
    1478:	c789                	beqz	a5,1482 <.L21>
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_IPREF_EN_MASK
    147a:	30100793          	li	a5,769
    147e:	7ca7a073          	csrs	0x7ca,a5

00001482 <.L21>:
                              | HPM_MCACHE_CTL_CCTL_SUEN_MASK
                              | HPM_MCACHE_CTL_IC_EN_MASK);
    }
}
    1482:	0001                	nop
    1484:	0141                	add	sp,sp,16
    1486:	8082                	ret

Disassembly of section .text.l1c_dc_enable_writearound:

00001492 <l1c_dc_enable_writearound>:
    l1c_op(HPM_L1C_CCTL_CMD_L1I_VA_UNLOCK, address, size);
}

void l1c_dc_enable_writearound(void)
{
    set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_WAROUND_MASK);
    1492:	6799                	lui	a5,0x6
    1494:	7ca7a073          	csrs	0x7ca,a5
}
    1498:	0001                	nop
    149a:	8082                	ret

Disassembly of section .text.board_init_pmp:

0000149c <board_init_pmp>:
        clock_add_to_group(clock_usb0, 0);
    }
}

void board_init_pmp(void)
{
    149c:	712d                	add	sp,sp,-288
    149e:	10112e23          	sw	ra,284(sp)
    uint32_t start_addr;
    uint32_t end_addr;
    uint32_t length;
    pmp_entry_t pmp_entry[16];
    uint8_t index = 0;
    14a2:	100107a3          	sb	zero,271(sp)

    /* Init noncachable memory */
    extern uint32_t __noncacheable_start__[];
    extern uint32_t __noncacheable_end__[];
    start_addr = (uint32_t) __noncacheable_start__;
    14a6:	011407b7          	lui	a5,0x1140
    14aa:	00078793          	mv	a5,a5
    14ae:	10f12423          	sw	a5,264(sp)
    end_addr = (uint32_t) __noncacheable_end__;
    14b2:	80020793          	add	a5,tp,-2048 # fffff800 <__SHARE_RAM_segment_end__+0xfee7f800>
    14b6:	10f12223          	sw	a5,260(sp)
    length = end_addr - start_addr;
    14ba:	10412703          	lw	a4,260(sp)
    14be:	10812783          	lw	a5,264(sp)
    14c2:	40f707b3          	sub	a5,a4,a5
    14c6:	10f12023          	sw	a5,256(sp)
    if (length > 0) {
    14ca:	10012783          	lw	a5,256(sp)
    14ce:	c3e5                	beqz	a5,15ae <.L145>
        /* Ensure the address and the length are power of 2 aligned */
        assert((length & (length - 1U)) == 0U);
    14d0:	10012783          	lw	a5,256(sp)
    14d4:	fff78713          	add	a4,a5,-1 # 113ffff <_extram_size+0x13ffff>
    14d8:	10012783          	lw	a5,256(sp)
    14dc:	8ff9                	and	a5,a5,a4
    14de:	cf89                	beqz	a5,14f8 <.L146>
    14e0:	26400613          	li	a2,612
    14e4:	000017b7          	lui	a5,0x1
    14e8:	36078593          	add	a1,a5,864 # 1360 <.LC24>
    14ec:	000017b7          	lui	a5,0x1
    14f0:	3a078513          	add	a0,a5,928 # 13a0 <.LC25>
    14f4:	147020ef          	jal	3e3a <__SEGGER_RTL_X_assert>

000014f8 <.L146>:
        assert((start_addr & (length - 1U)) == 0U);
    14f8:	10012783          	lw	a5,256(sp)
    14fc:	fff78713          	add	a4,a5,-1
    1500:	10812783          	lw	a5,264(sp)
    1504:	8ff9                	and	a5,a5,a4
    1506:	cf89                	beqz	a5,1520 <.L147>
    1508:	26500613          	li	a2,613
    150c:	000017b7          	lui	a5,0x1
    1510:	36078593          	add	a1,a5,864 # 1360 <.LC24>
    1514:	000017b7          	lui	a5,0x1
    1518:	3c078513          	add	a0,a5,960 # 13c0 <.LC26>
    151c:	11f020ef          	jal	3e3a <__SEGGER_RTL_X_assert>

00001520 <.L147>:
        pmp_entry[index].pmp_addr = PMP_NAPOT_ADDR(start_addr, length);
    1520:	10812783          	lw	a5,264(sp)
    1524:	0027d713          	srl	a4,a5,0x2
    1528:	10012783          	lw	a5,256(sp)
    152c:	17fd                	add	a5,a5,-1
    152e:	838d                	srl	a5,a5,0x3
    1530:	00f766b3          	or	a3,a4,a5
    1534:	10012783          	lw	a5,256(sp)
    1538:	838d                	srl	a5,a5,0x3
    153a:	fff7c713          	not	a4,a5
    153e:	10f14783          	lbu	a5,271(sp)
    1542:	8f75                	and	a4,a4,a3
    1544:	0792                	sll	a5,a5,0x4
    1546:	11078793          	add	a5,a5,272
    154a:	978a                	add	a5,a5,sp
    154c:	eee7aa23          	sw	a4,-268(a5)
        pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
    1550:	10f14783          	lbu	a5,271(sp)
    1554:	0792                	sll	a5,a5,0x4
    1556:	11078793          	add	a5,a5,272
    155a:	978a                	add	a5,a5,sp
    155c:	477d                	li	a4,31
    155e:	eee78823          	sb	a4,-272(a5)
        pmp_entry[index].pma_addr = PMA_NAPOT_ADDR(start_addr, length);
    1562:	10812783          	lw	a5,264(sp)
    1566:	0027d713          	srl	a4,a5,0x2
    156a:	10012783          	lw	a5,256(sp)
    156e:	17fd                	add	a5,a5,-1
    1570:	838d                	srl	a5,a5,0x3
    1572:	00f766b3          	or	a3,a4,a5
    1576:	10012783          	lw	a5,256(sp)
    157a:	838d                	srl	a5,a5,0x3
    157c:	fff7c713          	not	a4,a5
    1580:	10f14783          	lbu	a5,271(sp)
    1584:	8f75                	and	a4,a4,a3
    1586:	0792                	sll	a5,a5,0x4
    1588:	11078793          	add	a5,a5,272
    158c:	978a                	add	a5,a5,sp
    158e:	eee7ae23          	sw	a4,-260(a5)
        pmp_entry[index].pma_cfg.val = PMA_CFG(ADDR_MATCH_NAPOT, MEM_TYPE_MEM_NON_CACHE_BUF, AMO_EN);
    1592:	10f14783          	lbu	a5,271(sp)
    1596:	0792                	sll	a5,a5,0x4
    1598:	11078793          	add	a5,a5,272
    159c:	978a                	add	a5,a5,sp
    159e:	473d                	li	a4,15
    15a0:	eee78c23          	sb	a4,-264(a5)
        index++;
    15a4:	10f14783          	lbu	a5,271(sp)
    15a8:	0785                	add	a5,a5,1
    15aa:	10f107a3          	sb	a5,271(sp)

000015ae <.L145>:
    }

    /* Init share memory */
    extern uint32_t __share_mem_start__[];
    extern uint32_t __share_mem_end__[];
    start_addr = (uint32_t)__share_mem_start__;
    15ae:	0117c7b7          	lui	a5,0x117c
    15b2:	00078793          	mv	a5,a5
    15b6:	10f12423          	sw	a5,264(sp)
    end_addr = (uint32_t)__share_mem_end__;
    15ba:	011807b7          	lui	a5,0x1180
    15be:	00078793          	mv	a5,a5
    15c2:	10f12223          	sw	a5,260(sp)
    length = end_addr - start_addr;
    15c6:	10412703          	lw	a4,260(sp)
    15ca:	10812783          	lw	a5,264(sp)
    15ce:	40f707b3          	sub	a5,a4,a5
    15d2:	10f12023          	sw	a5,256(sp)
    if (length > 0) {
    15d6:	10012783          	lw	a5,256(sp)
    15da:	c3e5                	beqz	a5,16ba <.L148>
        /* Ensure the address and the length are power of 2 aligned */
        assert((length & (length - 1U)) == 0U);
    15dc:	10012783          	lw	a5,256(sp)
    15e0:	fff78713          	add	a4,a5,-1 # 117ffff <__AXI_SRAM_segment_end__+0x3fff>
    15e4:	10012783          	lw	a5,256(sp)
    15e8:	8ff9                	and	a5,a5,a4
    15ea:	cf89                	beqz	a5,1604 <.L149>
    15ec:	27500613          	li	a2,629
    15f0:	000017b7          	lui	a5,0x1
    15f4:	36078593          	add	a1,a5,864 # 1360 <.LC24>
    15f8:	000017b7          	lui	a5,0x1
    15fc:	3a078513          	add	a0,a5,928 # 13a0 <.LC25>
    1600:	03b020ef          	jal	3e3a <__SEGGER_RTL_X_assert>

00001604 <.L149>:
        assert((start_addr & (length - 1U)) == 0U);
    1604:	10012783          	lw	a5,256(sp)
    1608:	fff78713          	add	a4,a5,-1
    160c:	10812783          	lw	a5,264(sp)
    1610:	8ff9                	and	a5,a5,a4
    1612:	cf89                	beqz	a5,162c <.L150>
    1614:	27600613          	li	a2,630
    1618:	000017b7          	lui	a5,0x1
    161c:	36078593          	add	a1,a5,864 # 1360 <.LC24>
    1620:	000017b7          	lui	a5,0x1
    1624:	3c078513          	add	a0,a5,960 # 13c0 <.LC26>
    1628:	013020ef          	jal	3e3a <__SEGGER_RTL_X_assert>

0000162c <.L150>:
        pmp_entry[index].pmp_addr = PMP_NAPOT_ADDR(start_addr, length);
    162c:	10812783          	lw	a5,264(sp)
    1630:	0027d713          	srl	a4,a5,0x2
    1634:	10012783          	lw	a5,256(sp)
    1638:	17fd                	add	a5,a5,-1
    163a:	838d                	srl	a5,a5,0x3
    163c:	00f766b3          	or	a3,a4,a5
    1640:	10012783          	lw	a5,256(sp)
    1644:	838d                	srl	a5,a5,0x3
    1646:	fff7c713          	not	a4,a5
    164a:	10f14783          	lbu	a5,271(sp)
    164e:	8f75                	and	a4,a4,a3
    1650:	0792                	sll	a5,a5,0x4
    1652:	11078793          	add	a5,a5,272
    1656:	978a                	add	a5,a5,sp
    1658:	eee7aa23          	sw	a4,-268(a5)
        pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
    165c:	10f14783          	lbu	a5,271(sp)
    1660:	0792                	sll	a5,a5,0x4
    1662:	11078793          	add	a5,a5,272
    1666:	978a                	add	a5,a5,sp
    1668:	477d                	li	a4,31
    166a:	eee78823          	sb	a4,-272(a5)
        pmp_entry[index].pma_addr = PMA_NAPOT_ADDR(start_addr, length);
    166e:	10812783          	lw	a5,264(sp)
    1672:	0027d713          	srl	a4,a5,0x2
    1676:	10012783          	lw	a5,256(sp)
    167a:	17fd                	add	a5,a5,-1
    167c:	838d                	srl	a5,a5,0x3
    167e:	00f766b3          	or	a3,a4,a5
    1682:	10012783          	lw	a5,256(sp)
    1686:	838d                	srl	a5,a5,0x3
    1688:	fff7c713          	not	a4,a5
    168c:	10f14783          	lbu	a5,271(sp)
    1690:	8f75                	and	a4,a4,a3
    1692:	0792                	sll	a5,a5,0x4
    1694:	11078793          	add	a5,a5,272
    1698:	978a                	add	a5,a5,sp
    169a:	eee7ae23          	sw	a4,-260(a5)
        pmp_entry[index].pma_cfg.val = PMA_CFG(ADDR_MATCH_NAPOT, MEM_TYPE_MEM_NON_CACHE_BUF, AMO_EN);
    169e:	10f14783          	lbu	a5,271(sp)
    16a2:	0792                	sll	a5,a5,0x4
    16a4:	11078793          	add	a5,a5,272
    16a8:	978a                	add	a5,a5,sp
    16aa:	473d                	li	a4,15
    16ac:	eee78c23          	sb	a4,-264(a5)
        index++;
    16b0:	10f14783          	lbu	a5,271(sp)
    16b4:	0785                	add	a5,a5,1
    16b6:	10f107a3          	sb	a5,271(sp)

000016ba <.L148>:
    }

    pmp_config(&pmp_entry[0], index);
    16ba:	10f14703          	lbu	a4,271(sp)
    16be:	878a                	mv	a5,sp
    16c0:	85ba                	mv	a1,a4
    16c2:	853e                	mv	a0,a5
    16c4:	24f9                	jal	1992 <pmp_config>
}
    16c6:	0001                	nop
    16c8:	11c12083          	lw	ra,284(sp)
    16cc:	6115                	add	sp,sp,288
    16ce:	8082                	ret

Disassembly of section .text.read_pmp_cfg:

0000170a <read_pmp_cfg>:

#define PMP_ENTRY_MAX 16
#define PMA_ENTRY_MAX 16

uint32_t read_pmp_cfg(uint32_t idx)
{
    170a:	7179                	add	sp,sp,-48
    170c:	c62a                	sw	a0,12(sp)
    uint32_t pmp_cfg = 0;
    170e:	d602                	sw	zero,44(sp)
    switch (idx) {
    1710:	4732                	lw	a4,12(sp)
    1712:	478d                	li	a5,3
    1714:	04f70763          	beq	a4,a5,1762 <.L2>
    1718:	4732                	lw	a4,12(sp)
    171a:	478d                	li	a5,3
    171c:	04e7e963          	bltu	a5,a4,176e <.L9>
    1720:	4732                	lw	a4,12(sp)
    1722:	4789                	li	a5,2
    1724:	02f70963          	beq	a4,a5,1756 <.L4>
    1728:	4732                	lw	a4,12(sp)
    172a:	4789                	li	a5,2
    172c:	04e7e163          	bltu	a5,a4,176e <.L9>
    1730:	47b2                	lw	a5,12(sp)
    1732:	c791                	beqz	a5,173e <.L5>
    1734:	4732                	lw	a4,12(sp)
    1736:	4785                	li	a5,1
    1738:	00f70963          	beq	a4,a5,174a <.L6>
    case 3:
        pmp_cfg = read_csr(CSR_PMPCFG3);
        break;
    default:
        /* Do nothing */
        break;
    173c:	a80d                	j	176e <.L9>

0000173e <.L5>:
        pmp_cfg = read_csr(CSR_PMPCFG0);
    173e:	3a0027f3          	csrr	a5,pmpcfg0
    1742:	ce3e                	sw	a5,28(sp)
    1744:	47f2                	lw	a5,28(sp)

00001746 <.LBE2>:
    1746:	d63e                	sw	a5,44(sp)
        break;
    1748:	a025                	j	1770 <.L7>

0000174a <.L6>:
        pmp_cfg = read_csr(CSR_PMPCFG1);
    174a:	3a1027f3          	csrr	a5,pmpcfg1
    174e:	d03e                	sw	a5,32(sp)
    1750:	5782                	lw	a5,32(sp)

00001752 <.LBE3>:
    1752:	d63e                	sw	a5,44(sp)
        break;
    1754:	a831                	j	1770 <.L7>

00001756 <.L4>:
        pmp_cfg = read_csr(CSR_PMPCFG2);
    1756:	3a2027f3          	csrr	a5,pmpcfg2
    175a:	d23e                	sw	a5,36(sp)
    175c:	5792                	lw	a5,36(sp)

0000175e <.LBE4>:
    175e:	d63e                	sw	a5,44(sp)
        break;
    1760:	a801                	j	1770 <.L7>

00001762 <.L2>:
        pmp_cfg = read_csr(CSR_PMPCFG3);
    1762:	3a3027f3          	csrr	a5,pmpcfg3
    1766:	d43e                	sw	a5,40(sp)
    1768:	57a2                	lw	a5,40(sp)

0000176a <.LBE5>:
    176a:	d63e                	sw	a5,44(sp)
        break;
    176c:	a011                	j	1770 <.L7>

0000176e <.L9>:
        break;
    176e:	0001                	nop

00001770 <.L7>:
    }
    return pmp_cfg;
    1770:	57b2                	lw	a5,44(sp)
}
    1772:	853e                	mv	a0,a5
    1774:	6145                	add	sp,sp,48
    1776:	8082                	ret

Disassembly of section .text.write_pmp_addr:

0000177a <write_pmp_addr>:
        break;
    }
}

void write_pmp_addr(uint32_t value, uint32_t idx)
{
    177a:	1141                	add	sp,sp,-16
    177c:	c62a                	sw	a0,12(sp)
    177e:	c42e                	sw	a1,8(sp)
    switch (idx) {
    1780:	4722                	lw	a4,8(sp)
    1782:	47bd                	li	a5,15
    1784:	08e7ea63          	bltu	a5,a4,1818 <.L38>
    1788:	47a2                	lw	a5,8(sp)
    178a:	00279713          	sll	a4,a5,0x2
    178e:	88c18793          	add	a5,gp,-1908 # 130 <.L21>
    1792:	97ba                	add	a5,a5,a4
    1794:	439c                	lw	a5,0(a5)
    1796:	8782                	jr	a5

00001798 <.L36>:
    case 0:
        write_csr(CSR_PMPADDR0, value);
    1798:	47b2                	lw	a5,12(sp)
    179a:	3b079073          	csrw	pmpaddr0,a5
        break;
    179e:	a8b5                	j	181a <.L37>

000017a0 <.L35>:
    case 1:
        write_csr(CSR_PMPADDR1, value);
    17a0:	47b2                	lw	a5,12(sp)
    17a2:	3b179073          	csrw	pmpaddr1,a5
        break;
    17a6:	a895                	j	181a <.L37>

000017a8 <.L34>:
    case 2:
        write_csr(CSR_PMPADDR2, value);
    17a8:	47b2                	lw	a5,12(sp)
    17aa:	3b279073          	csrw	pmpaddr2,a5
        break;
    17ae:	a0b5                	j	181a <.L37>

000017b0 <.L33>:
    case 3:
        write_csr(CSR_PMPADDR3, value);
    17b0:	47b2                	lw	a5,12(sp)
    17b2:	3b379073          	csrw	pmpaddr3,a5
        break;
    17b6:	a095                	j	181a <.L37>

000017b8 <.L32>:
    case 4:
        write_csr(CSR_PMPADDR4, value);
    17b8:	47b2                	lw	a5,12(sp)
    17ba:	3b479073          	csrw	pmpaddr4,a5
        break;
    17be:	a8b1                	j	181a <.L37>

000017c0 <.L31>:
    case 5:
        write_csr(CSR_PMPADDR5, value);
    17c0:	47b2                	lw	a5,12(sp)
    17c2:	3b579073          	csrw	pmpaddr5,a5
        break;
    17c6:	a891                	j	181a <.L37>

000017c8 <.L30>:
    case 6:
        write_csr(CSR_PMPADDR6, value);
    17c8:	47b2                	lw	a5,12(sp)
    17ca:	3b679073          	csrw	pmpaddr6,a5
        break;
    17ce:	a0b1                	j	181a <.L37>

000017d0 <.L29>:
    case 7:
        write_csr(CSR_PMPADDR7, value);
    17d0:	47b2                	lw	a5,12(sp)
    17d2:	3b779073          	csrw	pmpaddr7,a5
        break;
    17d6:	a091                	j	181a <.L37>

000017d8 <.L28>:
    case 8:
        write_csr(CSR_PMPADDR8, value);
    17d8:	47b2                	lw	a5,12(sp)
    17da:	3b879073          	csrw	pmpaddr8,a5
        break;
    17de:	a835                	j	181a <.L37>

000017e0 <.L27>:
    case 9:
        write_csr(CSR_PMPADDR9, value);
    17e0:	47b2                	lw	a5,12(sp)
    17e2:	3b979073          	csrw	pmpaddr9,a5
        break;
    17e6:	a815                	j	181a <.L37>

000017e8 <.L26>:
    case 10:
        write_csr(CSR_PMPADDR10, value);
    17e8:	47b2                	lw	a5,12(sp)
    17ea:	3ba79073          	csrw	pmpaddr10,a5
        break;
    17ee:	a035                	j	181a <.L37>

000017f0 <.L25>:
    case 11:
        write_csr(CSR_PMPADDR11, value);
    17f0:	47b2                	lw	a5,12(sp)
    17f2:	3bb79073          	csrw	pmpaddr11,a5
        break;
    17f6:	a015                	j	181a <.L37>

000017f8 <.L24>:
    case 12:
        write_csr(CSR_PMPADDR12, value);
    17f8:	47b2                	lw	a5,12(sp)
    17fa:	3bc79073          	csrw	pmpaddr12,a5
        break;
    17fe:	a831                	j	181a <.L37>

00001800 <.L23>:
    case 13:
        write_csr(CSR_PMPADDR13, value);
    1800:	47b2                	lw	a5,12(sp)
    1802:	3bd79073          	csrw	pmpaddr13,a5
        break;
    1806:	a811                	j	181a <.L37>

00001808 <.L22>:
    case 14:
        write_csr(CSR_PMPADDR14, value);
    1808:	47b2                	lw	a5,12(sp)
    180a:	3be79073          	csrw	pmpaddr14,a5
        break;
    180e:	a031                	j	181a <.L37>

00001810 <.L20>:
    case 15:
        write_csr(CSR_PMPADDR15, value);
    1810:	47b2                	lw	a5,12(sp)
    1812:	3bf79073          	csrw	pmpaddr15,a5
        break;
    1816:	a011                	j	181a <.L37>

00001818 <.L38>:
    default:
        /* Do nothing */
        break;
    1818:	0001                	nop

0000181a <.L37>:
    }
}
    181a:	0001                	nop
    181c:	0141                	add	sp,sp,16
    181e:	8082                	ret

Disassembly of section .text.read_pma_cfg:

00001852 <read_pma_cfg>:
    return status_success;
}

#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
uint32_t read_pma_cfg(uint32_t idx)
{
    1852:	7179                	add	sp,sp,-48
    1854:	c62a                	sw	a0,12(sp)
    uint32_t pma_cfg = 0;
    1856:	d602                	sw	zero,44(sp)
    switch (idx) {
    1858:	4732                	lw	a4,12(sp)
    185a:	478d                	li	a5,3
    185c:	04f70763          	beq	a4,a5,18aa <.L72>
    1860:	4732                	lw	a4,12(sp)
    1862:	478d                	li	a5,3
    1864:	04e7e963          	bltu	a5,a4,18b6 <.L79>
    1868:	4732                	lw	a4,12(sp)
    186a:	4789                	li	a5,2
    186c:	02f70963          	beq	a4,a5,189e <.L74>
    1870:	4732                	lw	a4,12(sp)
    1872:	4789                	li	a5,2
    1874:	04e7e163          	bltu	a5,a4,18b6 <.L79>
    1878:	47b2                	lw	a5,12(sp)
    187a:	c791                	beqz	a5,1886 <.L75>
    187c:	4732                	lw	a4,12(sp)
    187e:	4785                	li	a5,1
    1880:	00f70963          	beq	a4,a5,1892 <.L76>
    case 3:
        pma_cfg = read_csr(CSR_PMACFG3);
        break;
    default:
        /* Do nothing */
        break;
    1884:	a80d                	j	18b6 <.L79>

00001886 <.L75>:
        pma_cfg = read_csr(CSR_PMACFG0);
    1886:	bc0027f3          	csrr	a5,0xbc0
    188a:	ce3e                	sw	a5,28(sp)
    188c:	47f2                	lw	a5,28(sp)

0000188e <.LBE24>:
    188e:	d63e                	sw	a5,44(sp)
        break;
    1890:	a025                	j	18b8 <.L77>

00001892 <.L76>:
        pma_cfg = read_csr(CSR_PMACFG1);
    1892:	bc1027f3          	csrr	a5,0xbc1
    1896:	d03e                	sw	a5,32(sp)
    1898:	5782                	lw	a5,32(sp)

0000189a <.LBE25>:
    189a:	d63e                	sw	a5,44(sp)
        break;
    189c:	a831                	j	18b8 <.L77>

0000189e <.L74>:
        pma_cfg = read_csr(CSR_PMACFG2);
    189e:	bc2027f3          	csrr	a5,0xbc2
    18a2:	d23e                	sw	a5,36(sp)
    18a4:	5792                	lw	a5,36(sp)

000018a6 <.LBE26>:
    18a6:	d63e                	sw	a5,44(sp)
        break;
    18a8:	a801                	j	18b8 <.L77>

000018aa <.L72>:
        pma_cfg = read_csr(CSR_PMACFG3);
    18aa:	bc3027f3          	csrr	a5,0xbc3
    18ae:	d43e                	sw	a5,40(sp)
    18b0:	57a2                	lw	a5,40(sp)

000018b2 <.LBE27>:
    18b2:	d63e                	sw	a5,44(sp)
        break;
    18b4:	a011                	j	18b8 <.L77>

000018b6 <.L79>:
        break;
    18b6:	0001                	nop

000018b8 <.L77>:
    }
    return pma_cfg;
    18b8:	57b2                	lw	a5,44(sp)
}
    18ba:	853e                	mv	a0,a5
    18bc:	6145                	add	sp,sp,48
    18be:	8082                	ret

Disassembly of section .text.write_pma_addr:

000018de <write_pma_addr>:
        /* Do nothing */
        break;
    }
}
void write_pma_addr(uint32_t value, uint32_t idx)
{
    18de:	1141                	add	sp,sp,-16
    18e0:	c62a                	sw	a0,12(sp)
    18e2:	c42e                	sw	a1,8(sp)
    switch (idx) {
    18e4:	4722                	lw	a4,8(sp)
    18e6:	47bd                	li	a5,15
    18e8:	08e7ea63          	bltu	a5,a4,197c <.L108>
    18ec:	47a2                	lw	a5,8(sp)
    18ee:	00279713          	sll	a4,a5,0x2
    18f2:	8cc18793          	add	a5,gp,-1844 # 170 <.L91>
    18f6:	97ba                	add	a5,a5,a4
    18f8:	439c                	lw	a5,0(a5)
    18fa:	8782                	jr	a5

000018fc <.L106>:
    case 0:
        write_csr(CSR_PMAADDR0, value);
    18fc:	47b2                	lw	a5,12(sp)
    18fe:	bd079073          	csrw	0xbd0,a5
        break;
    1902:	a8b5                	j	197e <.L107>

00001904 <.L105>:
    case 1:
        write_csr(CSR_PMAADDR1, value);
    1904:	47b2                	lw	a5,12(sp)
    1906:	bd179073          	csrw	0xbd1,a5
        break;
    190a:	a895                	j	197e <.L107>

0000190c <.L104>:
    case 2:
        write_csr(CSR_PMAADDR2, value);
    190c:	47b2                	lw	a5,12(sp)
    190e:	bd279073          	csrw	0xbd2,a5
        break;
    1912:	a0b5                	j	197e <.L107>

00001914 <.L103>:
    case 3:
        write_csr(CSR_PMAADDR3, value);
    1914:	47b2                	lw	a5,12(sp)
    1916:	bd379073          	csrw	0xbd3,a5
        break;
    191a:	a095                	j	197e <.L107>

0000191c <.L102>:
    case 4:
        write_csr(CSR_PMAADDR4, value);
    191c:	47b2                	lw	a5,12(sp)
    191e:	bd479073          	csrw	0xbd4,a5
        break;
    1922:	a8b1                	j	197e <.L107>

00001924 <.L101>:
    case 5:
        write_csr(CSR_PMAADDR5, value);
    1924:	47b2                	lw	a5,12(sp)
    1926:	bd579073          	csrw	0xbd5,a5
        break;
    192a:	a891                	j	197e <.L107>

0000192c <.L100>:
    case 6:
        write_csr(CSR_PMAADDR6, value);
    192c:	47b2                	lw	a5,12(sp)
    192e:	bd679073          	csrw	0xbd6,a5
        break;
    1932:	a0b1                	j	197e <.L107>

00001934 <.L99>:
    case 7:
        write_csr(CSR_PMAADDR7, value);
    1934:	47b2                	lw	a5,12(sp)
    1936:	bd779073          	csrw	0xbd7,a5
        break;
    193a:	a091                	j	197e <.L107>

0000193c <.L98>:
    case 8:
        write_csr(CSR_PMAADDR8, value);
    193c:	47b2                	lw	a5,12(sp)
    193e:	bd879073          	csrw	0xbd8,a5
        break;
    1942:	a835                	j	197e <.L107>

00001944 <.L97>:
    case 9:
        write_csr(CSR_PMAADDR9, value);
    1944:	47b2                	lw	a5,12(sp)
    1946:	bd979073          	csrw	0xbd9,a5
        break;
    194a:	a815                	j	197e <.L107>

0000194c <.L96>:
    case 10:
        write_csr(CSR_PMAADDR10, value);
    194c:	47b2                	lw	a5,12(sp)
    194e:	bda79073          	csrw	0xbda,a5
        break;
    1952:	a035                	j	197e <.L107>

00001954 <.L95>:
    case 11:
        write_csr(CSR_PMAADDR11, value);
    1954:	47b2                	lw	a5,12(sp)
    1956:	bdb79073          	csrw	0xbdb,a5
        break;
    195a:	a015                	j	197e <.L107>

0000195c <.L94>:
    case 12:
        write_csr(CSR_PMAADDR12, value);
    195c:	47b2                	lw	a5,12(sp)
    195e:	bdc79073          	csrw	0xbdc,a5
        break;
    1962:	a831                	j	197e <.L107>

00001964 <.L93>:
    case 13:
        write_csr(CSR_PMAADDR13, value);
    1964:	47b2                	lw	a5,12(sp)
    1966:	bdd79073          	csrw	0xbdd,a5
        break;
    196a:	a811                	j	197e <.L107>

0000196c <.L92>:
    case 14:
        write_csr(CSR_PMAADDR14, value);
    196c:	47b2                	lw	a5,12(sp)
    196e:	bde79073          	csrw	0xbde,a5
        break;
    1972:	a031                	j	197e <.L107>

00001974 <.L90>:
    case 15:
        write_csr(CSR_PMAADDR15, value);
    1974:	47b2                	lw	a5,12(sp)
    1976:	bdf79073          	csrw	0xbdf,a5
        break;
    197a:	a011                	j	197e <.L107>

0000197c <.L108>:
    default:
        /* Do nothing */
        break;
    197c:	0001                	nop

0000197e <.L107>:
    }
}
    197e:	0001                	nop
    1980:	0141                	add	sp,sp,16
    1982:	8082                	ret

Disassembly of section .text.pmp_config:

00001992 <pmp_config>:

    return status;
}

hpm_stat_t pmp_config(const pmp_entry_t *entry, uint32_t num_of_entries)
{
    1992:	7139                	add	sp,sp,-64
    1994:	de06                	sw	ra,60(sp)
    1996:	c62a                	sw	a0,12(sp)
    1998:	c42e                	sw	a1,8(sp)
    hpm_stat_t status = status_invalid_argument;
    199a:	4789                	li	a5,2
    199c:	d63e                	sw	a5,44(sp)
    do {
        HPM_BREAK_IF((entry == NULL) || (num_of_entries < 1U) || (num_of_entries > 15U));
    199e:	47b2                	lw	a5,12(sp)
    19a0:	cfcd                	beqz	a5,1a5a <.L140>
    19a2:	47a2                	lw	a5,8(sp)
    19a4:	cbdd                	beqz	a5,1a5a <.L140>
    19a6:	4722                	lw	a4,8(sp)
    19a8:	47bd                	li	a5,15
    19aa:	0ae7e863          	bltu	a5,a4,1a5a <.L140>

000019ae <.LBB47>:

        for (uint32_t i = 0; i < num_of_entries; i++) {
    19ae:	d402                	sw	zero,40(sp)
    19b0:	a871                	j	1a4c <.L141>

000019b2 <.L142>:
            uint32_t idx = i / 4;
    19b2:	57a2                	lw	a5,40(sp)
    19b4:	8389                	srl	a5,a5,0x2
    19b6:	d23e                	sw	a5,36(sp)
            uint32_t offset = (i * 8) & 0x1F;
    19b8:	57a2                	lw	a5,40(sp)
    19ba:	078e                	sll	a5,a5,0x3
    19bc:	8be1                	and	a5,a5,24
    19be:	d03e                	sw	a5,32(sp)
            uint32_t pmp_cfg = read_pmp_cfg(idx);
    19c0:	5512                	lw	a0,36(sp)
    19c2:	33a1                	jal	170a <read_pmp_cfg>
    19c4:	ce2a                	sw	a0,28(sp)
            pmp_cfg &= ~(0xFFUL << offset);
    19c6:	5782                	lw	a5,32(sp)
    19c8:	0ff00713          	li	a4,255
    19cc:	00f717b3          	sll	a5,a4,a5
    19d0:	fff7c793          	not	a5,a5
    19d4:	4772                	lw	a4,28(sp)
    19d6:	8ff9                	and	a5,a5,a4
    19d8:	ce3e                	sw	a5,28(sp)
            pmp_cfg |= ((uint32_t)entry->pmp_cfg.val) << offset;
    19da:	47b2                	lw	a5,12(sp)
    19dc:	0007c783          	lbu	a5,0(a5)
    19e0:	873e                	mv	a4,a5
    19e2:	5782                	lw	a5,32(sp)
    19e4:	00f717b3          	sll	a5,a4,a5
    19e8:	4772                	lw	a4,28(sp)
    19ea:	8fd9                	or	a5,a5,a4
    19ec:	ce3e                	sw	a5,28(sp)
            write_pmp_addr(entry->pmp_addr, i);
    19ee:	47b2                	lw	a5,12(sp)
    19f0:	43dc                	lw	a5,4(a5)
    19f2:	55a2                	lw	a1,40(sp)
    19f4:	853e                	mv	a0,a5
    19f6:	3351                	jal	177a <write_pmp_addr>
            write_pmp_cfg(pmp_cfg, idx);
    19f8:	5592                	lw	a1,36(sp)
    19fa:	4572                	lw	a0,28(sp)
    19fc:	175010ef          	jal	3370 <write_pmp_cfg>
#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
            uint32_t pma_cfg = read_pma_cfg(idx);
    1a00:	5512                	lw	a0,36(sp)
    1a02:	3d81                	jal	1852 <read_pma_cfg>
    1a04:	cc2a                	sw	a0,24(sp)
            pma_cfg &= ~(0xFFUL << offset);
    1a06:	5782                	lw	a5,32(sp)
    1a08:	0ff00713          	li	a4,255
    1a0c:	00f717b3          	sll	a5,a4,a5
    1a10:	fff7c793          	not	a5,a5
    1a14:	4762                	lw	a4,24(sp)
    1a16:	8ff9                	and	a5,a5,a4
    1a18:	cc3e                	sw	a5,24(sp)
            pma_cfg |= ((uint32_t)entry->pma_cfg.val) << offset;
    1a1a:	47b2                	lw	a5,12(sp)
    1a1c:	0087c783          	lbu	a5,8(a5)
    1a20:	873e                	mv	a4,a5
    1a22:	5782                	lw	a5,32(sp)
    1a24:	00f717b3          	sll	a5,a4,a5
    1a28:	4762                	lw	a4,24(sp)
    1a2a:	8fd9                	or	a5,a5,a4
    1a2c:	cc3e                	sw	a5,24(sp)
            write_pma_cfg(pma_cfg, idx);
    1a2e:	5592                	lw	a1,36(sp)
    1a30:	4562                	lw	a0,24(sp)
    1a32:	19b010ef          	jal	33cc <write_pma_cfg>
            write_pma_addr(entry->pma_addr, i);
    1a36:	47b2                	lw	a5,12(sp)
    1a38:	47dc                	lw	a5,12(a5)
    1a3a:	55a2                	lw	a1,40(sp)
    1a3c:	853e                	mv	a0,a5
    1a3e:	3545                	jal	18de <write_pma_addr>
#endif
            ++entry;
    1a40:	47b2                	lw	a5,12(sp)
    1a42:	07c1                	add	a5,a5,16
    1a44:	c63e                	sw	a5,12(sp)

00001a46 <.LBE48>:
        for (uint32_t i = 0; i < num_of_entries; i++) {
    1a46:	57a2                	lw	a5,40(sp)
    1a48:	0785                	add	a5,a5,1
    1a4a:	d43e                	sw	a5,40(sp)

00001a4c <.L141>:
    1a4c:	5722                	lw	a4,40(sp)
    1a4e:	47a2                	lw	a5,8(sp)
    1a50:	f6f761e3          	bltu	a4,a5,19b2 <.L142>

00001a54 <.LBE47>:
        }
        fencei();
    1a54:	0000100f          	fence.i

        status = status_success;
    1a58:	d602                	sw	zero,44(sp)

00001a5a <.L140>:

    } while (false);

    return status;
    1a5a:	57b2                	lw	a5,44(sp)
}
    1a5c:	853e                	mv	a0,a5
    1a5e:	50f2                	lw	ra,60(sp)
    1a60:	6121                	add	sp,sp,64
    1a62:	8082                	ret

Disassembly of section .text.uart_default_config:

00001a6e <uart_default_config>:
#endif

#define HPM_UART_BAUDRATE_SCALE (1000U)

void uart_default_config(UART_Type *ptr, uart_config_t *config)
{
    1a6e:	1141                	add	sp,sp,-16
    1a70:	c62a                	sw	a0,12(sp)
    1a72:	c42e                	sw	a1,8(sp)
    (void) ptr;
    config->baudrate = 115200;
    1a74:	47a2                	lw	a5,8(sp)
    1a76:	6771                	lui	a4,0x1c
    1a78:	20070713          	add	a4,a4,512 # 1c200 <__NONCACHEABLE_RAM_segment_size__+0xc200>
    1a7c:	c3d8                	sw	a4,4(a5)
    config->word_length = word_length_8_bits;
    1a7e:	47a2                	lw	a5,8(sp)
    1a80:	470d                	li	a4,3
    1a82:	00e784a3          	sb	a4,9(a5)
    config->parity = parity_none;
    1a86:	47a2                	lw	a5,8(sp)
    1a88:	00078523          	sb	zero,10(a5)
    config->num_of_stop_bits = stop_bits_1;
    1a8c:	47a2                	lw	a5,8(sp)
    1a8e:	00078423          	sb	zero,8(a5)
    config->fifo_enable = true;
    1a92:	47a2                	lw	a5,8(sp)
    1a94:	4705                	li	a4,1
    1a96:	00e78723          	sb	a4,14(a5)
    config->rx_fifo_level = uart_rx_fifo_trg_not_empty;
    1a9a:	47a2                	lw	a5,8(sp)
    1a9c:	00078623          	sb	zero,12(a5)
    config->tx_fifo_level = uart_tx_fifo_trg_not_full;
    1aa0:	47a2                	lw	a5,8(sp)
    1aa2:	000785a3          	sb	zero,11(a5)
    config->dma_enable = false;
    1aa6:	47a2                	lw	a5,8(sp)
    1aa8:	000786a3          	sb	zero,13(a5)
    config->modem_config.auto_flow_ctrl_en = false;
    1aac:	47a2                	lw	a5,8(sp)
    1aae:	000787a3          	sb	zero,15(a5)
    config->modem_config.loop_back_en = false;
    1ab2:	47a2                	lw	a5,8(sp)
    1ab4:	00078823          	sb	zero,16(a5)
    config->modem_config.set_rts_high = false;
    1ab8:	47a2                	lw	a5,8(sp)
    1aba:	000788a3          	sb	zero,17(a5)
    config->txidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
#endif
#if defined(HPM_IP_FEATURE_UART_RX_EN) && (HPM_IP_FEATURE_UART_RX_EN == 1)
    config->rx_enable = true;
#endif
}
    1abe:	0001                	nop
    1ac0:	0141                	add	sp,sp,16
    1ac2:	8082                	ret

Disassembly of section .text.uart_send_byte:

00001ace <uart_send_byte>:

    return status_success;
}

hpm_stat_t uart_send_byte(UART_Type *ptr, uint8_t c)
{
    1ace:	1101                	add	sp,sp,-32
    1ad0:	c62a                	sw	a0,12(sp)
    1ad2:	87ae                	mv	a5,a1
    1ad4:	00f105a3          	sb	a5,11(sp)
    uint32_t retry = 0;
    1ad8:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
    1ada:	a811                	j	1aee <.L48>

00001adc <.L51>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
    1adc:	4772                	lw	a4,28(sp)
    1ade:	6785                	lui	a5,0x1
    1ae0:	38878793          	add	a5,a5,904 # 1388 <.LC24+0x28>
    1ae4:	00e7eb63          	bltu	a5,a4,1afa <.L54>
            break;
        }
        retry++;
    1ae8:	47f2                	lw	a5,28(sp)
    1aea:	0785                	add	a5,a5,1
    1aec:	ce3e                	sw	a5,28(sp)

00001aee <.L48>:
    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
    1aee:	47b2                	lw	a5,12(sp)
    1af0:	5bdc                	lw	a5,52(a5)
    1af2:	0207f793          	and	a5,a5,32
    1af6:	d3fd                	beqz	a5,1adc <.L51>
    1af8:	a011                	j	1afc <.L50>

00001afa <.L54>:
            break;
    1afa:	0001                	nop

00001afc <.L50>:
    }

    if (retry > HPM_UART_DRV_RETRY_COUNT) {
    1afc:	4772                	lw	a4,28(sp)
    1afe:	6785                	lui	a5,0x1
    1b00:	38878793          	add	a5,a5,904 # 1388 <.LC24+0x28>
    1b04:	00e7f463          	bgeu	a5,a4,1b0c <.L52>
        return status_timeout;
    1b08:	478d                	li	a5,3
    1b0a:	a031                	j	1b16 <.L53>

00001b0c <.L52>:
    }

    ptr->THR = UART_THR_THR_SET(c);
    1b0c:	00b14703          	lbu	a4,11(sp)
    1b10:	47b2                	lw	a5,12(sp)
    1b12:	d398                	sw	a4,32(a5)
    return status_success;
    1b14:	4781                	li	a5,0

00001b16 <.L53>:
}
    1b16:	853e                	mv	a0,a5
    1b18:	6105                	add	sp,sp,32
    1b1a:	8082                	ret

Disassembly of section .text.mbx_init:

00001b8c <mbx_init>:
 * @brief   Initialization
 *
 * @param[in] ptr MBX base address
 */
static inline void mbx_init(MBX_Type *ptr)
{
    1b8c:	1101                	add	sp,sp,-32
    1b8e:	ce06                	sw	ra,28(sp)
    1b90:	c62a                	sw	a0,12(sp)
    mbx_empty_txfifo(ptr);
    1b92:	4532                	lw	a0,12(sp)
    1b94:	56d010ef          	jal	3900 <mbx_empty_txfifo>
    mbx_disable_intr(ptr, MBX_CR_ALL_INTERRUPTS_MASK);
    1b98:	0b200593          	li	a1,178
    1b9c:	4532                	lw	a0,12(sp)
    1b9e:	547010ef          	jal	38e4 <mbx_disable_intr>
}
    1ba2:	0001                	nop
    1ba4:	40f2                	lw	ra,28(sp)
    1ba6:	6105                	add	sp,sp,32
    1ba8:	8082                	ret

Disassembly of section .text.mbx_retrieve_message:

00001baa <mbx_retrieve_message>:
 * @param[out] msg Pointer to buffer to save message data
 *
 * @return status_success if everything is okay
 */
static inline hpm_stat_t mbx_retrieve_message(MBX_Type *ptr, uint32_t *msg)
{
    1baa:	1141                	add	sp,sp,-16
    1bac:	c62a                	sw	a0,12(sp)
    1bae:	c42e                	sw	a1,8(sp)
    if (ptr->SR & MBX_SR_RWMV_MASK) {
    1bb0:	47b2                	lw	a5,12(sp)
    1bb2:	43dc                	lw	a5,4(a5)
    1bb4:	8b85                	and	a5,a5,1
    1bb6:	c799                	beqz	a5,1bc4 <.L6>
        *msg = ptr->RXREG;
    1bb8:	47b2                	lw	a5,12(sp)
    1bba:	47d8                	lw	a4,12(a5)
    1bbc:	47a2                	lw	a5,8(sp)
    1bbe:	c398                	sw	a4,0(a5)
        return status_success;
    1bc0:	4781                	li	a5,0
    1bc2:	a021                	j	1bca <.L7>

00001bc4 <.L6>:
    }
    return status_mbx_not_available;
    1bc4:	678d                	lui	a5,0x3
    1bc6:	6b278793          	add	a5,a5,1714 # 36b2 <.L17+0x6>

00001bca <.L7>:
}
    1bca:	853e                	mv	a0,a5
    1bcc:	0141                	add	sp,sp,16
    1bce:	8082                	ret

Disassembly of section .text.main:

00001bd0 <main>:
    return 0;
}
#else

int main(void)
{
    1bd0:	715d                	add	sp,sp,-80
    1bd2:	c686                	sw	ra,76(sp)

    long long int i = 0;
    1bd4:	4781                	li	a5,0
    1bd6:	4801                	li	a6,0
    1bd8:	c03e                	sw	a5,0(sp)
    1bda:	c242                	sw	a6,4(sp)
    board_init_core1();
    1bdc:	3ea010ef          	jal	2fc6 <board_init_core1>
    mbx_init(HPM_MBX0B);
    1be0:	f00a4537          	lui	a0,0xf00a4
    1be4:	3765                	jal	1b8c <mbx_init>
    hpm_stat_t stat;

    printf("HPM_MBX0B CR: 0x%x\n", HPM_MBX0B->CR);
    1be6:	f00a47b7          	lui	a5,0xf00a4
    1bea:	439c                	lw	a5,0(a5)
    1bec:	85be                	mv	a1,a5
    1bee:	e6018513          	add	a0,gp,-416 # 704 <.LC0>
    1bf2:	2a8010ef          	jal	2e9a <printf>
    printf(" success\n");
    1bf6:	e7418513          	add	a0,gp,-396 # 718 <.LC1>
    1bfa:	2a0010ef          	jal	2e9a <printf>
    1bfe:	03900793          	li	a5,57
    1c02:	ce3e                	sw	a5,28(sp)
    1c04:	4789                	li	a5,2
    1c06:	cc3e                	sw	a5,24(sp)
    1c08:	e40007b7          	lui	a5,0xe4000
    1c0c:	ca3e                	sw	a5,20(sp)
    1c0e:	47f2                	lw	a5,28(sp)
    1c10:	c83e                	sw	a5,16(sp)
    1c12:	47e2                	lw	a5,24(sp)
    1c14:	c63e                	sw	a5,12(sp)

00001c16 <.LBB14>:
            HPM_PLIC_PRIORITY_OFFSET + ((irq-1) << HPM_PLIC_PRIORITY_SHIFT_PER_SOURCE));
    1c16:	47c2                	lw	a5,16(sp)
    1c18:	17fd                	add	a5,a5,-1 # e3ffffff <__SHARE_RAM_segment_end__+0xe2e7ffff>
    1c1a:	00279713          	sll	a4,a5,0x2
    1c1e:	47d2                	lw	a5,20(sp)
    1c20:	97ba                	add	a5,a5,a4
    1c22:	0791                	add	a5,a5,4
    volatile uint32_t *priority_ptr = (volatile uint32_t *)(base +
    1c24:	c43e                	sw	a5,8(sp)
    *priority_ptr = priority;
    1c26:	47a2                	lw	a5,8(sp)
    1c28:	4732                	lw	a4,12(sp)
    1c2a:	c398                	sw	a4,0(a5)
}
    1c2c:	0001                	nop

00001c2e <.LBE16>:
 * @param[in] priority Priority of interrupt
 */
ATTR_ALWAYS_INLINE static inline void intc_set_irq_priority(uint32_t irq, uint32_t priority)
{
    __plic_set_irq_priority(HPM_PLIC_BASE, irq, priority);
}
    1c2e:	0001                	nop
    1c30:	dc02                	sw	zero,56(sp)
    1c32:	03900793          	li	a5,57
    1c36:	da3e                	sw	a5,52(sp)
    1c38:	e40007b7          	lui	a5,0xe4000
    1c3c:	d83e                	sw	a5,48(sp)
    1c3e:	57e2                	lw	a5,56(sp)
    1c40:	d63e                	sw	a5,44(sp)
    1c42:	57d2                	lw	a5,52(sp)
    1c44:	d43e                	sw	a5,40(sp)

00001c46 <.LBB18>:
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
    1c46:	57b2                	lw	a5,44(sp)
    1c48:	00779713          	sll	a4,a5,0x7
            HPM_PLIC_ENABLE_OFFSET +
    1c4c:	57c2                	lw	a5,48(sp)
    1c4e:	973e                	add	a4,a4,a5
            ((irq >> 5) << 2));
    1c50:	57a2                	lw	a5,40(sp)
    1c52:	8395                	srl	a5,a5,0x5
    1c54:	078a                	sll	a5,a5,0x2
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
    1c56:	973e                	add	a4,a4,a5
    1c58:	6789                	lui	a5,0x2
    1c5a:	97ba                	add	a5,a5,a4
    volatile uint32_t *current_ptr = (volatile uint32_t *)(base +
    1c5c:	d23e                	sw	a5,36(sp)
    uint32_t current = *current_ptr;
    1c5e:	5792                	lw	a5,36(sp)
    1c60:	439c                	lw	a5,0(a5)
    1c62:	d03e                	sw	a5,32(sp)
    current = current | (1 << (irq & 0x1F));
    1c64:	57a2                	lw	a5,40(sp)
    1c66:	8bfd                	and	a5,a5,31
    1c68:	4705                	li	a4,1
    1c6a:	00f717b3          	sll	a5,a4,a5
    1c6e:	873e                	mv	a4,a5
    1c70:	5782                	lw	a5,32(sp)
    1c72:	8fd9                	or	a5,a5,a4
    1c74:	d03e                	sw	a5,32(sp)
    *current_ptr = current;
    1c76:	5792                	lw	a5,36(sp)
    1c78:	5702                	lw	a4,32(sp)
    1c7a:	c398                	sw	a4,0(a5)
}
    1c7c:	0001                	nop

00001c7e <.LBE20>:
}
    1c7e:	0001                	nop

00001c80 <.LBE18>:
    
     intc_m_enable_irq_with_priority(IRQn_MBX0B, 2);

    mbx_enable_intr(HPM_MBX0B, MBX_CR_RWMVIE_MASK);
    1c80:	4585                	li	a1,1
    1c82:	f00a4537          	lui	a0,0xf00a4
    1c86:	447010ef          	jal	38cc <mbx_enable_intr>

00001c8a <.L12>:
    /* reciever */
    while (1) {
        if (can_read) {
    1c8a:	84524783          	lbu	a5,-1979(tp) # fffff845 <__SHARE_RAM_segment_end__+0xfee7f845>
    1c8e:	0ff7f793          	zext.b	a5,a5
    1c92:	dfe5                	beqz	a5,1c8a <.L12>
            stat = mbx_retrieve_message(HPM_MBX0B, &i);
    1c94:	878a                	mv	a5,sp
    1c96:	85be                	mv	a1,a5
    1c98:	f00a4537          	lui	a0,0xf00a4
    1c9c:	3739                	jal	1baa <mbx_retrieve_message>
    1c9e:	de2a                	sw	a0,60(sp)
            if (stat == status_success) {
    1ca0:	57f2                	lw	a5,60(sp)
    1ca2:	eb99                	bnez	a5,1cb8 <.L10>
                
                printf("notice_count: %d\n", notice_count);
    1ca4:	84424783          	lbu	a5,-1980(tp) # fffff844 <__SHARE_RAM_segment_end__+0xfee7f844>
    1ca8:	0ff7f793          	zext.b	a5,a5
    1cac:	85be                	mv	a1,a5
    1cae:	e8018513          	add	a0,gp,-384 # 724 <.LC2>
    1cb2:	1e8010ef          	jal	2e9a <printf>
    1cb6:	a031                	j	1cc2 <.L11>

00001cb8 <.L10>:
            } else {
                printf("core %d: error getting message\n", BOARD_RUNNING_CORE);
    1cb8:	4585                	li	a1,1
    1cba:	e9418513          	add	a0,gp,-364 # 738 <.LC3>
    1cbe:	1dc010ef          	jal	2e9a <printf>

00001cc2 <.L11>:
                
            }
            can_read = false;
    1cc2:	840202a3          	sb	zero,-1979(tp) # fffff845 <__SHARE_RAM_segment_end__+0xfee7f845>
            mbx_enable_intr(HPM_MBX0B, MBX_CR_RWMVIE_MASK);
    1cc6:	4585                	li	a1,1
    1cc8:	f00a4537          	lui	a0,0xf00a4
    1ccc:	401010ef          	jal	38cc <mbx_enable_intr>
        if (can_read) {
    1cd0:	bf6d                	j	1c8a <.L12>

Disassembly of section .text.syscall_handler:

00001cd2 <syscall_handler>:
{
    1cd2:	1101                	add	sp,sp,-32
    1cd4:	ce2a                	sw	a0,28(sp)
    1cd6:	cc2e                	sw	a1,24(sp)
    1cd8:	ca32                	sw	a2,20(sp)
    1cda:	c836                	sw	a3,16(sp)
    1cdc:	c63a                	sw	a4,12(sp)
}
    1cde:	0001                	nop
    1ce0:	6105                	add	sp,sp,32
    1ce2:	8082                	ret

Disassembly of section .text.pllctl_get_div:

00001ce4 <pllctl_get_div>:
 * @param [in] pll Index of the PLL to query
 * @param [in] div_index Divider index (0: DIV0, 1: DIV1)
 * @return Current divider value (1-based) or error status
 */
static inline hpm_stat_t pllctl_get_div(PLLCTL_Type *ptr, uint8_t pll, uint8_t div_index)
{
    1ce4:	1141                	add	sp,sp,-16
    1ce6:	c62a                	sw	a0,12(sp)
    1ce8:	87ae                	mv	a5,a1
    1cea:	8732                	mv	a4,a2
    1cec:	00f105a3          	sb	a5,11(sp)
    1cf0:	87ba                	mv	a5,a4
    1cf2:	00f10523          	sb	a5,10(sp)
    if ((pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1))
    1cf6:	00b14703          	lbu	a4,11(sp)
    1cfa:	4791                	li	a5,4
    1cfc:	00e7ec63          	bltu	a5,a4,1d14 <.L6>
            || !(PLLCTL_SOC_PLL_HAS_DIV0(pll))) {
    1d00:	00b14703          	lbu	a4,11(sp)
    1d04:	4785                	li	a5,1
    1d06:	00f70963          	beq	a4,a5,1d18 <.L7>
    1d0a:	00b14703          	lbu	a4,11(sp)
    1d0e:	4789                	li	a5,2
    1d10:	00f70463          	beq	a4,a5,1d18 <.L7>

00001d14 <.L6>:
        return status_invalid_argument;
    1d14:	4789                	li	a5,2
    1d16:	a80d                	j	1d48 <.L8>

00001d18 <.L7>:
    }
    if (div_index) {
    1d18:	00a14783          	lbu	a5,10(sp)
    1d1c:	cf81                	beqz	a5,1d34 <.L9>
        return PLLCTL_PLL_DIV0_DIV_GET(ptr->PLL[pll].DIV1) + 1;
    1d1e:	00b14783          	lbu	a5,11(sp)
    1d22:	4732                	lw	a4,12(sp)
    1d24:	079e                	sll	a5,a5,0x7
    1d26:	97ba                	add	a5,a5,a4
    1d28:	0c47a783          	lw	a5,196(a5) # 20c4 <.L__addsf3_add_no_normalization+0x20>
    1d2c:	0ff7f793          	zext.b	a5,a5
    1d30:	0785                	add	a5,a5,1
    1d32:	a819                	j	1d48 <.L8>

00001d34 <.L9>:
    } else {
        return PLLCTL_PLL_DIV0_DIV_GET(ptr->PLL[pll].DIV0) + 1;
    1d34:	00b14783          	lbu	a5,11(sp)
    1d38:	4732                	lw	a4,12(sp)
    1d3a:	079e                	sll	a5,a5,0x7
    1d3c:	97ba                	add	a5,a5,a4
    1d3e:	0c07a783          	lw	a5,192(a5)
    1d42:	0ff7f793          	zext.b	a5,a5
    1d46:	0785                	add	a5,a5,1

00001d48 <.L8>:
    }
}
    1d48:	853e                	mv	a0,a5
    1d4a:	0141                	add	sp,sp,16
    1d4c:	8082                	ret

Disassembly of section .text.clock_get_frequency:

00001d4e <clock_get_frequency>:

/***********************************************************************************************************************
 * Codes
 **********************************************************************************************************************/
uint32_t clock_get_frequency(clock_name_t clock_name)
{
    1d4e:	7179                	add	sp,sp,-48
    1d50:	d606                	sw	ra,44(sp)
    1d52:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
    1d54:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
    1d56:	47b2                	lw	a5,12(sp)
    1d58:	83a1                	srl	a5,a5,0x8
    1d5a:	0ff7f793          	zext.b	a5,a5
    1d5e:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
    1d60:	47b2                	lw	a5,12(sp)
    1d62:	0ff7f793          	zext.b	a5,a5
    1d66:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
    1d68:	4762                	lw	a4,24(sp)
    1d6a:	47b1                	li	a5,12
    1d6c:	08e7ec63          	bltu	a5,a4,1e04 <.L27>
    1d70:	47e2                	lw	a5,24(sp)
    1d72:	00279713          	sll	a4,a5,0x2
    1d76:	ef418793          	add	a5,gp,-268 # 798 <.L29>
    1d7a:	97ba                	add	a5,a5,a4
    1d7c:	439c                	lw	a5,0(a5)
    1d7e:	8782                	jr	a5

00001d80 <.L41>:
    case CLK_SRC_GROUP_COMMON:
        clk_freq = get_frequency_for_ip_in_common_group((clock_node_t) node_or_instance);
    1d80:	47d2                	lw	a5,20(sp)
    1d82:	0ff7f793          	zext.b	a5,a5
    1d86:	853e                	mv	a0,a5
    1d88:	2069                	jal	1e12 <.LFE131>
    1d8a:	ce2a                	sw	a0,28(sp)
        break;
    1d8c:	a8b5                	j	1e08 <.L42>

00001d8e <.L40>:
    case CLK_SRC_GROUP_ADC:
        clk_freq = get_frequency_for_i2s_or_adc(CLK_SRC_GROUP_ADC, node_or_instance);
    1d8e:	45d2                	lw	a1,20(sp)
    1d90:	4505                	li	a0,1
    1d92:	57b010ef          	jal	3b0c <get_frequency_for_i2s_or_adc>
    1d96:	ce2a                	sw	a0,28(sp)
        break;
    1d98:	a885                	j	1e08 <.L42>

00001d9a <.L39>:
    case CLK_SRC_GROUP_I2S:
        clk_freq = get_frequency_for_i2s_or_adc(CLK_SRC_GROUP_I2S, node_or_instance);
    1d9a:	45d2                	lw	a1,20(sp)
    1d9c:	4509                	li	a0,2
    1d9e:	56f010ef          	jal	3b0c <get_frequency_for_i2s_or_adc>
    1da2:	ce2a                	sw	a0,28(sp)
        break;
    1da4:	a095                	j	1e08 <.L42>

00001da6 <.L38>:
    case CLK_SRC_GROUP_WDG:
        clk_freq = get_frequency_for_wdg(node_or_instance);
    1da6:	4552                	lw	a0,20(sp)
    1da8:	635010ef          	jal	3bdc <get_frequency_for_wdg>
    1dac:	ce2a                	sw	a0,28(sp)
        break;
    1dae:	a8a9                	j	1e08 <.L42>

00001db0 <.L28>:
    case CLK_SRC_GROUP_PWDG:
        clk_freq = get_frequency_for_pwdg();
    1db0:	65d010ef          	jal	3c0c <get_frequency_for_pwdg>
    1db4:	ce2a                	sw	a0,28(sp)
        break;
    1db6:	a889                	j	1e08 <.L42>

00001db8 <.L37>:
    case CLK_SRC_GROUP_PMIC:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
    1db8:	016e37b7          	lui	a5,0x16e3
    1dbc:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
    1dc0:	ce3e                	sw	a5,28(sp)
        break;
    1dc2:	a099                	j	1e08 <.L42>

00001dc4 <.L36>:
    case CLK_SRC_GROUP_AHB:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
    1dc4:	451d                	li	a0,7
    1dc6:	20b1                	jal	1e12 <.LFE131>
    1dc8:	ce2a                	sw	a0,28(sp)
        break;
    1dca:	a83d                	j	1e08 <.L42>

00001dcc <.L35>:
    case CLK_SRC_GROUP_AXI0:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi0);
    1dcc:	4511                	li	a0,4
    1dce:	2091                	jal	1e12 <.LFE131>
    1dd0:	ce2a                	sw	a0,28(sp)
        break;
    1dd2:	a81d                	j	1e08 <.L42>

00001dd4 <.L34>:
    case CLK_SRC_GROUP_AXI1:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi1);
    1dd4:	4515                	li	a0,5
    1dd6:	2835                	jal	1e12 <.LFE131>
    1dd8:	ce2a                	sw	a0,28(sp)
        break;
    1dda:	a03d                	j	1e08 <.L42>

00001ddc <.L33>:
    case CLK_SRC_GROUP_AXI2:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi2);
    1ddc:	4519                	li	a0,6
    1dde:	2815                	jal	1e12 <.LFE131>
    1de0:	ce2a                	sw	a0,28(sp)
        break;
    1de2:	a01d                	j	1e08 <.L42>

00001de4 <.L32>:
    case CLK_SRC_GROUP_CPU0:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu0);
    1de4:	4501                	li	a0,0
    1de6:	2035                	jal	1e12 <.LFE131>
    1de8:	ce2a                	sw	a0,28(sp)
        break;
    1dea:	a839                	j	1e08 <.L42>

00001dec <.L31>:
    case CLK_SRC_GROUP_CPU1:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu1);
    1dec:	4509                	li	a0,2
    1dee:	2015                	jal	1e12 <.LFE131>
    1df0:	ce2a                	sw	a0,28(sp)
        break;
    1df2:	a819                	j	1e08 <.L42>

00001df4 <.L30>:
    case CLK_SRC_GROUP_SRC:
        clk_freq = get_frequency_for_source((clock_source_t) node_or_instance);
    1df4:	47d2                	lw	a5,20(sp)
    1df6:	0ff7f793          	zext.b	a5,a5
    1dfa:	853e                	mv	a0,a5
    1dfc:	415010ef          	jal	3a10 <get_frequency_for_source>
    1e00:	ce2a                	sw	a0,28(sp)
        break;
    1e02:	a019                	j	1e08 <.L42>

00001e04 <.L27>:
    default:
        clk_freq = 0UL;
    1e04:	ce02                	sw	zero,28(sp)
        break;
    1e06:	0001                	nop

00001e08 <.L42>:
    }
    return clk_freq;
    1e08:	47f2                	lw	a5,28(sp)
}
    1e0a:	853e                	mv	a0,a5
    1e0c:	50b2                	lw	ra,44(sp)
    1e0e:	6145                	add	sp,sp,48
    1e10:	8082                	ret

Disassembly of section .text.get_frequency_for_ip_in_common_group:

00001e12 <get_frequency_for_ip_in_common_group>:

    return clk_freq;
}

static uint32_t get_frequency_for_ip_in_common_group(clock_node_t node)
{
    1e12:	7139                	add	sp,sp,-64
    1e14:	de06                	sw	ra,60(sp)
    1e16:	87aa                	mv	a5,a0
    1e18:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
    1e1c:	d602                	sw	zero,44(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(node);
    1e1e:	00f14783          	lbu	a5,15(sp)
    1e22:	d43e                	sw	a5,40(sp)

    if (node_or_instance < clock_node_end) {
    1e24:	5722                	lw	a4,40(sp)
    1e26:	04a00793          	li	a5,74
    1e2a:	04e7e663          	bltu	a5,a4,1e76 <.L58>

00001e2e <.LBB6>:
        uint32_t clk_node = (uint32_t) node_or_instance;
    1e2e:	57a2                	lw	a5,40(sp)
    1e30:	d23e                	sw	a5,36(sp)

        uint32_t clk_div = 1UL + SYSCTL_CLOCK_DIV_GET(HPM_SYSCTL->CLOCK[clk_node]);
    1e32:	f4000737          	lui	a4,0xf4000
    1e36:	5792                	lw	a5,36(sp)
    1e38:	60078793          	add	a5,a5,1536
    1e3c:	078a                	sll	a5,a5,0x2
    1e3e:	97ba                	add	a5,a5,a4
    1e40:	439c                	lw	a5,0(a5)
    1e42:	0ff7f793          	zext.b	a5,a5
    1e46:	0785                	add	a5,a5,1
    1e48:	d03e                	sw	a5,32(sp)
        clock_source_t clk_mux = (clock_source_t) SYSCTL_CLOCK_MUX_GET(HPM_SYSCTL->CLOCK[clk_node]);
    1e4a:	f4000737          	lui	a4,0xf4000
    1e4e:	5792                	lw	a5,36(sp)
    1e50:	60078793          	add	a5,a5,1536
    1e54:	078a                	sll	a5,a5,0x2
    1e56:	97ba                	add	a5,a5,a4
    1e58:	439c                	lw	a5,0(a5)
    1e5a:	83a1                	srl	a5,a5,0x8
    1e5c:	8bbd                	and	a5,a5,15
    1e5e:	00f10fa3          	sb	a5,31(sp)
        clk_freq = get_frequency_for_source(clk_mux) / clk_div;
    1e62:	01f14783          	lbu	a5,31(sp)
    1e66:	853e                	mv	a0,a5
    1e68:	3a9010ef          	jal	3a10 <get_frequency_for_source>
    1e6c:	872a                	mv	a4,a0
    1e6e:	5782                	lw	a5,32(sp)
    1e70:	02f757b3          	divu	a5,a4,a5
    1e74:	d63e                	sw	a5,44(sp)

00001e76 <.L58>:
    }
    return clk_freq;
    1e76:	57b2                	lw	a5,44(sp)
}
    1e78:	853e                	mv	a0,a5
    1e7a:	50f2                	lw	ra,60(sp)
    1e7c:	6121                	add	sp,sp,64
    1e7e:	8082                	ret

Disassembly of section .text.clock_add_to_group:

00001e80 <clock_add_to_group>:
{
    switch_ip_clock(clock_name, CLOCK_OFF);
}

void clock_add_to_group(clock_name_t clock_name, uint32_t group)
{
    1e80:	7179                	add	sp,sp,-48
    1e82:	d606                	sw	ra,44(sp)
    1e84:	c62a                	sw	a0,12(sp)
    1e86:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
    1e88:	47b2                	lw	a5,12(sp)
    1e8a:	83c1                	srl	a5,a5,0x10
    1e8c:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
    1e8e:	4772                	lw	a4,28(sp)
    1e90:	15d00793          	li	a5,349
    1e94:	00e7ef63          	bltu	a5,a4,1eb2 <.L175>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, true);
    1e98:	47a2                	lw	a5,8(sp)
    1e9a:	0ff7f793          	zext.b	a5,a5
    1e9e:	4772                	lw	a4,28(sp)
    1ea0:	0742                	sll	a4,a4,0x10
    1ea2:	8341                	srl	a4,a4,0x10
    1ea4:	4685                	li	a3,1
    1ea6:	863a                	mv	a2,a4
    1ea8:	85be                	mv	a1,a5
    1eaa:	f4000537          	lui	a0,0xf4000
    1eae:	583010ef          	jal	3c30 <sysctl_enable_group_resource>

00001eb2 <.L175>:
    }
}
    1eb2:	0001                	nop
    1eb4:	50b2                	lw	ra,44(sp)
    1eb6:	6145                	add	sp,sp,48
    1eb8:	8082                	ret

Disassembly of section .text.clock_update_core_clock:

00001eba <clock_update_core_clock>:
    while (hpm_csr_get_core_cycle() < expected_ticks) {
    }
}

void clock_update_core_clock(void)
{
    1eba:	1101                	add	sp,sp,-32
    1ebc:	ce06                	sw	ra,28(sp)

00001ebe <.LBB17>:
    uint32_t hart_id = read_csr(CSR_MHARTID);
    1ebe:	f14027f3          	csrr	a5,mhartid
    1ec2:	c63e                	sw	a5,12(sp)
    1ec4:	47b2                	lw	a5,12(sp)

00001ec6 <.LBE17>:
    1ec6:	c43e                	sw	a5,8(sp)
    clock_name_t cpu_clk_name = (hart_id == 1U) ? clock_cpu1 : clock_cpu0;
    1ec8:	4722                	lw	a4,8(sp)
    1eca:	4785                	li	a5,1
    1ecc:	00f71663          	bne	a4,a5,1ed8 <.L202>
    1ed0:	000807b7          	lui	a5,0x80
    1ed4:	0789                	add	a5,a5,2 # 80002 <__DLM_segment_start__+0x2>
    1ed6:	a011                	j	1eda <.L203>

00001ed8 <.L202>:
    1ed8:	4781                	li	a5,0

00001eda <.L203>:
    1eda:	c23e                	sw	a5,4(sp)
    hpm_core_clock = clock_get_frequency(cpu_clk_name);
    1edc:	4512                	lw	a0,4(sp)
    1ede:	3d85                	jal	1d4e <clock_get_frequency>
    1ee0:	872a                	mv	a4,a0
    1ee2:	82e22823          	sw	a4,-2000(tp) # fffff830 <__SHARE_RAM_segment_end__+0xfee7f830>
    1ee6:	0001                	nop
    1ee8:	40f2                	lw	ra,28(sp)
    1eea:	6105                	add	sp,sp,32
    1eec:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

00001eee <sysctl_resource_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] resource target resource index
 * @return true if target resource is busy
 */
static inline bool sysctl_resource_target_is_busy(SYSCTL_Type *ptr, sysctl_resource_t resource)
{
    1eee:	1141                	add	sp,sp,-16
    1ef0:	c62a                	sw	a0,12(sp)
    1ef2:	87ae                	mv	a5,a1
    1ef4:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
    1ef8:	00a15783          	lhu	a5,10(sp)
    1efc:	4732                	lw	a4,12(sp)
    1efe:	078a                	sll	a5,a5,0x2
    1f00:	97ba                	add	a5,a5,a4
    1f02:	4398                	lw	a4,0(a5)
    1f04:	400007b7          	lui	a5,0x40000
    1f08:	8ff9                	and	a5,a5,a4
    1f0a:	00f037b3          	snez	a5,a5
    1f0e:	0ff7f793          	zext.b	a5,a5
}
    1f12:	853e                	mv	a0,a5
    1f14:	0141                	add	sp,sp,16
    1f16:	8082                	ret

Disassembly of section .text.system_init:

00001f18 <system_init>:
#endif
    __plic_set_feature(HPM_PLIC_BASE, plic_feature);
}

__attribute__((weak)) void system_init(void)
{
    1f18:	7179                	add	sp,sp,-48
    1f1a:	d606                	sw	ra,44(sp)
    1f1c:	47a1                	li	a5,8
    1f1e:	c83e                	sw	a5,16(sp)

00001f20 <.LBB16>:
 * @param[in] mask interrupt mask to be disabled
 * @retval current mstatus value before irq mask is disabled
 */
ATTR_ALWAYS_INLINE static inline uint32_t disable_global_irq(uint32_t mask)
{
    return read_clear_csr(CSR_MSTATUS, mask);
    1f20:	c602                	sw	zero,12(sp)
    1f22:	47c2                	lw	a5,16(sp)
    1f24:	3007b7f3          	csrrc	a5,mstatus,a5
    1f28:	c63e                	sw	a5,12(sp)
    1f2a:	47b2                	lw	a5,12(sp)

00001f2c <.LBE18>:
    1f2c:	0001                	nop

00001f2e <.LBB19>:
 * @brief   Disable IRQ from interrupt controller
 *
 */
ATTR_ALWAYS_INLINE static inline void disable_irq_from_intc(void)
{
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
    1f2e:	6785                	lui	a5,0x1
    1f30:	80078793          	add	a5,a5,-2048 # 800 <__SEGGER_RTL_fdiv_reciprocal_table+0x34>
    1f34:	3047b073          	csrc	mie,a5
}
    1f38:	0001                	nop

00001f3a <.LBE19>:
    disable_global_irq(CSR_MSTATUS_MIE_MASK);
    disable_irq_from_intc();
    enable_plic_feature();
    1f3a:	61f010ef          	jal	3d58 <enable_plic_feature>

00001f3e <.LBB21>:
    set_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
    1f3e:	6785                	lui	a5,0x1
    1f40:	80078793          	add	a5,a5,-2048 # 800 <__SEGGER_RTL_fdiv_reciprocal_table+0x34>
    1f44:	3047a073          	csrs	mie,a5
}
    1f48:	0001                	nop
    1f4a:	47a1                	li	a5,8
    1f4c:	ca3e                	sw	a5,20(sp)

00001f4e <.LBB23>:
    set_csr(CSR_MSTATUS, mask);
    1f4e:	47d2                	lw	a5,20(sp)
    1f50:	3007a073          	csrs	mstatus,a5
}
    1f54:	0001                	nop

00001f56 <.LBB25>:
#if !CONFIG_DISABLE_GLOBAL_IRQ_ON_STARTUP
    enable_global_irq(CSR_MSTATUS_MIE_MASK);
#endif

#ifndef CONFIG_NOT_ENALBE_ACCESS_TO_CYCLE_CSR
    uint32_t mcounteren = read_csr(CSR_MCOUNTEREN);
    1f56:	306027f3          	csrr	a5,mcounteren
    1f5a:	ce3e                	sw	a5,28(sp)
    1f5c:	47f2                	lw	a5,28(sp)

00001f5e <.LBE25>:
    1f5e:	cc3e                	sw	a5,24(sp)
    write_csr(CSR_MCOUNTEREN, mcounteren | 1); /* Enable MCYCLE */
    1f60:	47e2                	lw	a5,24(sp)
    1f62:	0017e793          	or	a5,a5,1
    1f66:	30679073          	csrw	mcounteren,a5
#endif

#if defined(CONFIG_ENABLE_BPOR_RETENTION) && CONFIG_ENABLE_BPOR_RETENTION
    bpor_enable_reg_value_retention(HPM_BPOR);
#endif
}
    1f6a:	0001                	nop
    1f6c:	50b2                	lw	ra,44(sp)
    1f6e:	6145                	add	sp,sp,48
    1f70:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_xtoa:

00001f72 <__SEGGER_RTL_xltoa>:
    1f72:	882a                	mv	a6,a0
    1f74:	88ae                	mv	a7,a1
    1f76:	852e                	mv	a0,a1
    1f78:	ca89                	beqz	a3,1f8a <.L2>
    1f7a:	02d00793          	li	a5,45
    1f7e:	00158893          	add	a7,a1,1
    1f82:	00f58023          	sb	a5,0(a1)
    1f86:	41000833          	neg	a6,a6

00001f8a <.L2>:
    1f8a:	8746                	mv	a4,a7
    1f8c:	4325                	li	t1,9

00001f8e <.L5>:
    1f8e:	02c876b3          	remu	a3,a6,a2
    1f92:	85c2                	mv	a1,a6
    1f94:	0ff6f793          	zext.b	a5,a3
    1f98:	02c85833          	divu	a6,a6,a2
    1f9c:	02d37d63          	bgeu	t1,a3,1fd6 <.L3>
    1fa0:	05778793          	add	a5,a5,87

00001fa4 <.L11>:
    1fa4:	0ff7f793          	zext.b	a5,a5
    1fa8:	00f70023          	sb	a5,0(a4) # f4000000 <__SHARE_RAM_segment_end__+0xf2e80000>
    1fac:	00170693          	add	a3,a4,1
    1fb0:	02c5f163          	bgeu	a1,a2,1fd2 <.L8>
    1fb4:	000700a3          	sb	zero,1(a4)

00001fb8 <.L6>:
    1fb8:	0008c683          	lbu	a3,0(a7)
    1fbc:	00074783          	lbu	a5,0(a4)
    1fc0:	0885                	add	a7,a7,1
    1fc2:	177d                	add	a4,a4,-1
    1fc4:	00d700a3          	sb	a3,1(a4)
    1fc8:	fef88fa3          	sb	a5,-1(a7)
    1fcc:	fee8e6e3          	bltu	a7,a4,1fb8 <.L6>
    1fd0:	8082                	ret

00001fd2 <.L8>:
    1fd2:	8736                	mv	a4,a3
    1fd4:	bf6d                	j	1f8e <.L5>

00001fd6 <.L3>:
    1fd6:	03078793          	add	a5,a5,48
    1fda:	b7e9                	j	1fa4 <.L11>

Disassembly of section .text.libc.itoa:

00001fdc <itoa>:
    1fdc:	46a9                	li	a3,10
    1fde:	87aa                	mv	a5,a0
    1fe0:	882e                	mv	a6,a1
    1fe2:	8732                	mv	a4,a2
    1fe4:	00d61563          	bne	a2,a3,1fee <.L301>
    1fe8:	4685                	li	a3,1
    1fea:	00054663          	bltz	a0,1ff6 <.L302>

00001fee <.L301>:
    1fee:	4681                	li	a3,0
    1ff0:	863a                	mv	a2,a4
    1ff2:	85c2                	mv	a1,a6
    1ff4:	853e                	mv	a0,a5

00001ff6 <.L302>:
    1ff6:	bfb5                	j	1f72 <__SEGGER_RTL_xltoa>

Disassembly of section .text.libc.fwrite:

00001ff8 <fwrite>:
    1ff8:	1101                	add	sp,sp,-32
    1ffa:	c64e                	sw	s3,12(sp)
    1ffc:	89aa                	mv	s3,a0
    1ffe:	8536                	mv	a0,a3
    2000:	cc22                	sw	s0,24(sp)
    2002:	ca26                	sw	s1,20(sp)
    2004:	c84a                	sw	s2,16(sp)
    2006:	ce06                	sw	ra,28(sp)
    2008:	84ae                	mv	s1,a1
    200a:	8432                	mv	s0,a2
    200c:	8936                	mv	s2,a3
    200e:	1da010ef          	jal	31e8 <__SEGGER_RTL_X_file_stat>
    2012:	02054463          	bltz	a0,203a <.L43>
    2016:	02848633          	mul	a2,s1,s0
    201a:	4501                	li	a0,0
    201c:	00966863          	bltu	a2,s1,202c <.L41>
    2020:	85ce                	mv	a1,s3
    2022:	854a                	mv	a0,s2
    2024:	152010ef          	jal	3176 <__SEGGER_RTL_X_file_write>
    2028:	02955533          	divu	a0,a0,s1

0000202c <.L41>:
    202c:	40f2                	lw	ra,28(sp)
    202e:	4462                	lw	s0,24(sp)
    2030:	44d2                	lw	s1,20(sp)
    2032:	4942                	lw	s2,16(sp)
    2034:	49b2                	lw	s3,12(sp)
    2036:	6105                	add	sp,sp,32
    2038:	8082                	ret

0000203a <.L43>:
    203a:	4501                	li	a0,0
    203c:	bfc5                	j	202c <.L41>

Disassembly of section .text.libc.__subsf3:

0000203e <__subsf3>:
    203e:	80000637          	lui	a2,0x80000
    2042:	8db1                	xor	a1,a1,a2
    2044:	a009                	j	2046 <__addsf3>

Disassembly of section .text.libc.__addsf3:

00002046 <__addsf3>:
    2046:	80000637          	lui	a2,0x80000
    204a:	00b546b3          	xor	a3,a0,a1
    204e:	0806ca63          	bltz	a3,20e2 <.L__addsf3_subtract>
    2052:	00b57563          	bgeu	a0,a1,205c <.L__addsf3_add_already_ordered>
    2056:	86aa                	mv	a3,a0
    2058:	852e                	mv	a0,a1
    205a:	85b6                	mv	a1,a3

0000205c <.L__addsf3_add_already_ordered>:
    205c:	00151713          	sll	a4,a0,0x1
    2060:	8361                	srl	a4,a4,0x18
    2062:	00159693          	sll	a3,a1,0x1
    2066:	82e1                	srl	a3,a3,0x18
    2068:	0ff00293          	li	t0,255
    206c:	06570563          	beq	a4,t0,20d6 <.L__addsf3_add_inf_or_nan>
    2070:	c325                	beqz	a4,20d0 <.L__addsf3_zero>
    2072:	ceb1                	beqz	a3,20ce <.L__addsf3_add_done>
    2074:	40d706b3          	sub	a3,a4,a3
    2078:	42e1                	li	t0,24
    207a:	04d2ca63          	blt	t0,a3,20ce <.L__addsf3_add_done>
    207e:	05a2                	sll	a1,a1,0x8
    2080:	8dd1                	or	a1,a1,a2
    2082:	01755713          	srl	a4,a0,0x17
    2086:	0522                	sll	a0,a0,0x8
    2088:	8d51                	or	a0,a0,a2
    208a:	47e5                	li	a5,25
    208c:	8f95                	sub	a5,a5,a3
    208e:	00f59633          	sll	a2,a1,a5
    2092:	821d                	srl	a2,a2,0x7
    2094:	00d5d5b3          	srl	a1,a1,a3
    2098:	00b507b3          	add	a5,a0,a1
    209c:	00a7f463          	bgeu	a5,a0,20a4 <.L__addsf3_add_no_normalization>
    20a0:	8385                	srl	a5,a5,0x1
    20a2:	0709                	add	a4,a4,2

000020a4 <.L__addsf3_add_no_normalization>:
    20a4:	177d                	add	a4,a4,-1
    20a6:	0ff77593          	zext.b	a1,a4
    20aa:	f0158593          	add	a1,a1,-255
    20ae:	cd91                	beqz	a1,20ca <.L__addsf3_inf>
    20b0:	075e                	sll	a4,a4,0x17
    20b2:	0087d513          	srl	a0,a5,0x8
    20b6:	07e2                	sll	a5,a5,0x18
    20b8:	8fd1                	or	a5,a5,a2
    20ba:	0007d663          	bgez	a5,20c6 <.L__addsf3_no_tie>
    20be:	0786                	sll	a5,a5,0x1
    20c0:	0505                	add	a0,a0,1 # f4000001 <__SHARE_RAM_segment_end__+0xf2e80001>
    20c2:	e391                	bnez	a5,20c6 <.L__addsf3_no_tie>
    20c4:	9979                	and	a0,a0,-2

000020c6 <.L__addsf3_no_tie>:
    20c6:	953a                	add	a0,a0,a4
    20c8:	8082                	ret

000020ca <.L__addsf3_inf>:
    20ca:	01771513          	sll	a0,a4,0x17

000020ce <.L__addsf3_add_done>:
    20ce:	8082                	ret

000020d0 <.L__addsf3_zero>:
    20d0:	817d                	srl	a0,a0,0x1f
    20d2:	057e                	sll	a0,a0,0x1f
    20d4:	8082                	ret

000020d6 <.L__addsf3_add_inf_or_nan>:
    20d6:	00951613          	sll	a2,a0,0x9
    20da:	da75                	beqz	a2,20ce <.L__addsf3_add_done>

000020dc <.L__addsf3_return_nan>:
    20dc:	7fc00537          	lui	a0,0x7fc00
    20e0:	8082                	ret

000020e2 <.L__addsf3_subtract>:
    20e2:	8db1                	xor	a1,a1,a2
    20e4:	40b506b3          	sub	a3,a0,a1
    20e8:	00b57563          	bgeu	a0,a1,20f2 <.L__addsf3_sub_already_ordered>
    20ec:	8eb1                	xor	a3,a3,a2
    20ee:	8d15                	sub	a0,a0,a3
    20f0:	95b6                	add	a1,a1,a3

000020f2 <.L__addsf3_sub_already_ordered>:
    20f2:	00159693          	sll	a3,a1,0x1
    20f6:	82e1                	srl	a3,a3,0x18
    20f8:	00151713          	sll	a4,a0,0x1
    20fc:	8361                	srl	a4,a4,0x18
    20fe:	05a2                	sll	a1,a1,0x8
    2100:	8dd1                	or	a1,a1,a2
    2102:	0ff00293          	li	t0,255
    2106:	0c570c63          	beq	a4,t0,21de <.L__addsf3_sub_inf_or_nan>
    210a:	c2f5                	beqz	a3,21ee <.L__addsf3_sub_zero>
    210c:	40d706b3          	sub	a3,a4,a3
    2110:	c695                	beqz	a3,213c <.L__addsf3_exponents_equal>
    2112:	4285                	li	t0,1
    2114:	08569063          	bne	a3,t0,2194 <.L__addsf3_exponents_differ_by_more_than_1>
    2118:	01755693          	srl	a3,a0,0x17
    211c:	0526                	sll	a0,a0,0x9
    211e:	00b532b3          	sltu	t0,a0,a1
    2122:	8d0d                	sub	a0,a0,a1
    2124:	02029263          	bnez	t0,2148 <.L__addsf3_normalization_steps>
    2128:	06de                	sll	a3,a3,0x17
    212a:	01751593          	sll	a1,a0,0x17
    212e:	8125                	srl	a0,a0,0x9
    2130:	0005d463          	bgez	a1,2138 <.L__addsf3_sub_no_tie_single>
    2134:	0505                	add	a0,a0,1 # 7fc00001 <__SHARE_RAM_segment_end__+0x7ea80001>
    2136:	9979                	and	a0,a0,-2

00002138 <.L__addsf3_sub_no_tie_single>:
    2138:	9536                	add	a0,a0,a3

0000213a <.L__addsf3_sub_done>:
    213a:	8082                	ret

0000213c <.L__addsf3_exponents_equal>:
    213c:	01755693          	srl	a3,a0,0x17
    2140:	0526                	sll	a0,a0,0x9
    2142:	0586                	sll	a1,a1,0x1
    2144:	8d0d                	sub	a0,a0,a1
    2146:	d975                	beqz	a0,213a <.L__addsf3_sub_done>

00002148 <.L__addsf3_normalization_steps>:
    2148:	4581                	li	a1,0
    214a:	01055793          	srl	a5,a0,0x10
    214e:	e399                	bnez	a5,2154 <.L1^B1>
    2150:	0542                	sll	a0,a0,0x10
    2152:	05c1                	add	a1,a1,16

00002154 <.L1^B1>:
    2154:	01855793          	srl	a5,a0,0x18
    2158:	e399                	bnez	a5,215e <.L2^B1>
    215a:	0522                	sll	a0,a0,0x8
    215c:	05a1                	add	a1,a1,8

0000215e <.L2^B1>:
    215e:	01c55793          	srl	a5,a0,0x1c
    2162:	e399                	bnez	a5,2168 <.L3^B1>
    2164:	0512                	sll	a0,a0,0x4
    2166:	0591                	add	a1,a1,4

00002168 <.L3^B1>:
    2168:	01e55793          	srl	a5,a0,0x1e
    216c:	e399                	bnez	a5,2172 <.L4^B1>
    216e:	050a                	sll	a0,a0,0x2
    2170:	0589                	add	a1,a1,2

00002172 <.L4^B1>:
    2172:	00054463          	bltz	a0,217a <.L5^B1>
    2176:	0506                	sll	a0,a0,0x1
    2178:	0585                	add	a1,a1,1

0000217a <.L5^B1>:
    217a:	0585                	add	a1,a1,1
    217c:	0506                	sll	a0,a0,0x1
    217e:	00e5f763          	bgeu	a1,a4,218c <.L__addsf3_underflow>
    2182:	8e8d                	sub	a3,a3,a1
    2184:	06de                	sll	a3,a3,0x17
    2186:	8125                	srl	a0,a0,0x9
    2188:	9536                	add	a0,a0,a3
    218a:	8082                	ret

0000218c <.L__addsf3_underflow>:
    218c:	0086d513          	srl	a0,a3,0x8
    2190:	057e                	sll	a0,a0,0x1f
    2192:	8082                	ret

00002194 <.L__addsf3_exponents_differ_by_more_than_1>:
    2194:	42e5                	li	t0,25
    2196:	fad2e2e3          	bltu	t0,a3,213a <.L__addsf3_sub_done>
    219a:	0685                	add	a3,a3,1
    219c:	40d00733          	neg	a4,a3
    21a0:	00e59733          	sll	a4,a1,a4
    21a4:	00d5d5b3          	srl	a1,a1,a3
    21a8:	00e03733          	snez	a4,a4
    21ac:	95ae                	add	a1,a1,a1
    21ae:	95ba                	add	a1,a1,a4
    21b0:	01755693          	srl	a3,a0,0x17
    21b4:	0522                	sll	a0,a0,0x8
    21b6:	8d51                	or	a0,a0,a2
    21b8:	40b50733          	sub	a4,a0,a1
    21bc:	00074463          	bltz	a4,21c4 <.L__addsf3_sub_already_normalized>
    21c0:	070a                	sll	a4,a4,0x2
    21c2:	8305                	srl	a4,a4,0x1

000021c4 <.L__addsf3_sub_already_normalized>:
    21c4:	16fd                	add	a3,a3,-1
    21c6:	06de                	sll	a3,a3,0x17
    21c8:	00875513          	srl	a0,a4,0x8
    21cc:	0762                	sll	a4,a4,0x18
    21ce:	00075663          	bgez	a4,21da <.L__addsf3_sub_no_tie>
    21d2:	0706                	sll	a4,a4,0x1
    21d4:	0505                	add	a0,a0,1
    21d6:	e311                	bnez	a4,21da <.L__addsf3_sub_no_tie>
    21d8:	9979                	and	a0,a0,-2

000021da <.L__addsf3_sub_no_tie>:
    21da:	9536                	add	a0,a0,a3
    21dc:	8082                	ret

000021de <.L__addsf3_sub_inf_or_nan>:
    21de:	0ff00293          	li	t0,255
    21e2:	ee568de3          	beq	a3,t0,20dc <.L__addsf3_return_nan>
    21e6:	00951593          	sll	a1,a0,0x9
    21ea:	d9a1                	beqz	a1,213a <.L__addsf3_sub_done>
    21ec:	bdc5                	j	20dc <.L__addsf3_return_nan>

000021ee <.L__addsf3_sub_zero>:
    21ee:	f731                	bnez	a4,213a <.L__addsf3_sub_done>
    21f0:	4501                	li	a0,0
    21f2:	8082                	ret

Disassembly of section .text.libc.__ltsf2:

000021f4 <__ltsf2>:
    21f4:	ff000637          	lui	a2,0xff000
    21f8:	00151693          	sll	a3,a0,0x1
    21fc:	02d66763          	bltu	a2,a3,222a <.L__ltsf2_zero>
    2200:	00159693          	sll	a3,a1,0x1
    2204:	02d66363          	bltu	a2,a3,222a <.L__ltsf2_zero>
    2208:	00b56633          	or	a2,a0,a1
    220c:	00161693          	sll	a3,a2,0x1
    2210:	ce89                	beqz	a3,222a <.L__ltsf2_zero>
    2212:	00064763          	bltz	a2,2220 <.L__ltsf2_negative>
    2216:	00b53533          	sltu	a0,a0,a1
    221a:	40a00533          	neg	a0,a0
    221e:	8082                	ret

00002220 <.L__ltsf2_negative>:
    2220:	00a5b533          	sltu	a0,a1,a0
    2224:	40a00533          	neg	a0,a0
    2228:	8082                	ret

0000222a <.L__ltsf2_zero>:
    222a:	4501                	li	a0,0
    222c:	8082                	ret

Disassembly of section .text.libc.__lesf2:

0000222e <__lesf2>:
    222e:	ff000637          	lui	a2,0xff000
    2232:	00151693          	sll	a3,a0,0x1
    2236:	02d66363          	bltu	a2,a3,225c <.L__lesf2_nan>
    223a:	00159693          	sll	a3,a1,0x1
    223e:	00d66f63          	bltu	a2,a3,225c <.L__lesf2_nan>
    2242:	00b56633          	or	a2,a0,a1
    2246:	00161693          	sll	a3,a2,0x1
    224a:	ca99                	beqz	a3,2260 <.L__lesf2_zero>
    224c:	00064563          	bltz	a2,2256 <.L__lesf2_negative>
    2250:	00a5b533          	sltu	a0,a1,a0
    2254:	8082                	ret

00002256 <.L__lesf2_negative>:
    2256:	00b53533          	sltu	a0,a0,a1
    225a:	8082                	ret

0000225c <.L__lesf2_nan>:
    225c:	4505                	li	a0,1
    225e:	8082                	ret

00002260 <.L__lesf2_zero>:
    2260:	4501                	li	a0,0
    2262:	8082                	ret

Disassembly of section .text.libc.__gtsf2:

00002264 <__gtsf2>:
    2264:	ff000637          	lui	a2,0xff000
    2268:	00151693          	sll	a3,a0,0x1
    226c:	02d66363          	bltu	a2,a3,2292 <.L__gtsf2_zero>
    2270:	00159693          	sll	a3,a1,0x1
    2274:	00d66f63          	bltu	a2,a3,2292 <.L__gtsf2_zero>
    2278:	00b56633          	or	a2,a0,a1
    227c:	00161693          	sll	a3,a2,0x1
    2280:	ca89                	beqz	a3,2292 <.L__gtsf2_zero>
    2282:	00064563          	bltz	a2,228c <.L__gtsf2_negative>
    2286:	00a5b533          	sltu	a0,a1,a0
    228a:	8082                	ret

0000228c <.L__gtsf2_negative>:
    228c:	00b53533          	sltu	a0,a0,a1
    2290:	8082                	ret

00002292 <.L__gtsf2_zero>:
    2292:	4501                	li	a0,0
    2294:	8082                	ret

Disassembly of section .text.libc.__gesf2:

00002296 <__gesf2>:
    2296:	ff000637          	lui	a2,0xff000
    229a:	00151693          	sll	a3,a0,0x1
    229e:	02d66763          	bltu	a2,a3,22cc <.L__gesf2_nan>
    22a2:	00159693          	sll	a3,a1,0x1
    22a6:	02d66363          	bltu	a2,a3,22cc <.L__gesf2_nan>
    22aa:	00b56633          	or	a2,a0,a1
    22ae:	00161693          	sll	a3,a2,0x1
    22b2:	ce99                	beqz	a3,22d0 <.L__gesf2_zero>
    22b4:	00064763          	bltz	a2,22c2 <.L__gesf2_negative>
    22b8:	00b53533          	sltu	a0,a0,a1
    22bc:	40a00533          	neg	a0,a0
    22c0:	8082                	ret

000022c2 <.L__gesf2_negative>:
    22c2:	00a5b533          	sltu	a0,a1,a0
    22c6:	40a00533          	neg	a0,a0
    22ca:	8082                	ret

000022cc <.L__gesf2_nan>:
    22cc:	557d                	li	a0,-1
    22ce:	8082                	ret

000022d0 <.L__gesf2_zero>:
    22d0:	4501                	li	a0,0
    22d2:	8082                	ret

Disassembly of section .text.libc.__fixunsdfsi:

000022d4 <__fixunsdfsi>:
    22d4:	0205c563          	bltz	a1,22fe <.L__fixunsdfsi_zero_result>
    22d8:	0145d613          	srl	a2,a1,0x14
    22dc:	c0160613          	add	a2,a2,-1023 # fefffc01 <__SHARE_RAM_segment_end__+0xfde7fc01>
    22e0:	00064f63          	bltz	a2,22fe <.L__fixunsdfsi_zero_result>
    22e4:	477d                	li	a4,31
    22e6:	8f11                	sub	a4,a4,a2
    22e8:	00074d63          	bltz	a4,2302 <.L__fixunsdfsi_overflow_result>
    22ec:	8155                	srl	a0,a0,0x15
    22ee:	05ae                	sll	a1,a1,0xb
    22f0:	8d4d                	or	a0,a0,a1
    22f2:	800006b7          	lui	a3,0x80000
    22f6:	8d55                	or	a0,a0,a3
    22f8:	00e55533          	srl	a0,a0,a4
    22fc:	8082                	ret

000022fe <.L__fixunsdfsi_zero_result>:
    22fe:	4501                	li	a0,0
    2300:	8082                	ret

00002302 <.L__fixunsdfsi_overflow_result>:
    2302:	557d                	li	a0,-1
    2304:	8082                	ret

Disassembly of section .text.libc.__floatundisf:

00002306 <__floatundisf>:
    2306:	c5bd                	beqz	a1,2374 <.L__floatundisf_high_word_zero>
    2308:	4701                	li	a4,0
    230a:	0105d693          	srl	a3,a1,0x10
    230e:	e299                	bnez	a3,2314 <.L8^B3>
    2310:	0741                	add	a4,a4,16
    2312:	05c2                	sll	a1,a1,0x10

00002314 <.L8^B3>:
    2314:	0185d693          	srl	a3,a1,0x18
    2318:	e299                	bnez	a3,231e <.L4^B10>
    231a:	0721                	add	a4,a4,8
    231c:	05a2                	sll	a1,a1,0x8

0000231e <.L4^B10>:
    231e:	01c5d693          	srl	a3,a1,0x1c
    2322:	e299                	bnez	a3,2328 <.L2^B10>
    2324:	0711                	add	a4,a4,4
    2326:	0592                	sll	a1,a1,0x4

00002328 <.L2^B10>:
    2328:	01e5d693          	srl	a3,a1,0x1e
    232c:	e299                	bnez	a3,2332 <.L1^B10>
    232e:	0709                	add	a4,a4,2
    2330:	058a                	sll	a1,a1,0x2

00002332 <.L1^B10>:
    2332:	0005c463          	bltz	a1,233a <.L0^B3>
    2336:	0705                	add	a4,a4,1
    2338:	0586                	sll	a1,a1,0x1

0000233a <.L0^B3>:
    233a:	fff74613          	not	a2,a4
    233e:	00c556b3          	srl	a3,a0,a2
    2342:	8285                	srl	a3,a3,0x1
    2344:	8dd5                	or	a1,a1,a3
    2346:	00e51533          	sll	a0,a0,a4
    234a:	0be60613          	add	a2,a2,190
    234e:	00a03533          	snez	a0,a0
    2352:	8dc9                	or	a1,a1,a0

00002354 <.L__floatundisf_round_and_pack>:
    2354:	065e                	sll	a2,a2,0x17
    2356:	0085d513          	srl	a0,a1,0x8
    235a:	05de                	sll	a1,a1,0x17
    235c:	0005a333          	sltz	t1,a1
    2360:	95ae                	add	a1,a1,a1
    2362:	959a                	add	a1,a1,t1
    2364:	0005d663          	bgez	a1,2370 <.L__floatundisf_round_down>
    2368:	95ae                	add	a1,a1,a1
    236a:	00b035b3          	snez	a1,a1
    236e:	952e                	add	a0,a0,a1

00002370 <.L__floatundisf_round_down>:
    2370:	9532                	add	a0,a0,a2

00002372 <.L__floatundisf_done>:
    2372:	8082                	ret

00002374 <.L__floatundisf_high_word_zero>:
    2374:	dd7d                	beqz	a0,2372 <.L__floatundisf_done>
    2376:	09d00613          	li	a2,157
    237a:	01055693          	srl	a3,a0,0x10
    237e:	e299                	bnez	a3,2384 <.L1^B11>
    2380:	0542                	sll	a0,a0,0x10
    2382:	1641                	add	a2,a2,-16

00002384 <.L1^B11>:
    2384:	01855693          	srl	a3,a0,0x18
    2388:	e299                	bnez	a3,238e <.L2^B11>
    238a:	0522                	sll	a0,a0,0x8
    238c:	1661                	add	a2,a2,-8

0000238e <.L2^B11>:
    238e:	01c55693          	srl	a3,a0,0x1c
    2392:	e299                	bnez	a3,2398 <.L3^B8>
    2394:	0512                	sll	a0,a0,0x4
    2396:	1671                	add	a2,a2,-4

00002398 <.L3^B8>:
    2398:	01e55693          	srl	a3,a0,0x1e
    239c:	e299                	bnez	a3,23a2 <.L4^B11>
    239e:	050a                	sll	a0,a0,0x2
    23a0:	1679                	add	a2,a2,-2

000023a2 <.L4^B11>:
    23a2:	00054463          	bltz	a0,23aa <.L5^B8>
    23a6:	0506                	sll	a0,a0,0x1
    23a8:	167d                	add	a2,a2,-1

000023aa <.L5^B8>:
    23aa:	85aa                	mv	a1,a0
    23ac:	4501                	li	a0,0
    23ae:	b75d                	j	2354 <.L__floatundisf_round_and_pack>

Disassembly of section .text.libc.__truncdfsf2:

000023b0 <__truncdfsf2>:
    23b0:	00159693          	sll	a3,a1,0x1
    23b4:	82d5                	srl	a3,a3,0x15
    23b6:	7ff00613          	li	a2,2047
    23ba:	04c68663          	beq	a3,a2,2406 <.L__truncdfsf2_inf_nan>
    23be:	c8068693          	add	a3,a3,-896 # 7ffffc80 <__SHARE_RAM_segment_end__+0x7ee7fc80>
    23c2:	02d05e63          	blez	a3,23fe <.L__truncdfsf2_underflow>
    23c6:	0ff00613          	li	a2,255
    23ca:	04c6f263          	bgeu	a3,a2,240e <.L__truncdfsf2_inf>
    23ce:	06de                	sll	a3,a3,0x17
    23d0:	01f5d613          	srl	a2,a1,0x1f
    23d4:	067e                	sll	a2,a2,0x1f
    23d6:	8ed1                	or	a3,a3,a2
    23d8:	05b2                	sll	a1,a1,0xc
    23da:	01455613          	srl	a2,a0,0x14
    23de:	8dd1                	or	a1,a1,a2
    23e0:	81a5                	srl	a1,a1,0x9
    23e2:	00251613          	sll	a2,a0,0x2
    23e6:	00062733          	sltz	a4,a2
    23ea:	9632                	add	a2,a2,a2
    23ec:	000627b3          	sltz	a5,a2
    23f0:	9632                	add	a2,a2,a2
    23f2:	963a                	add	a2,a2,a4
    23f4:	c211                	beqz	a2,23f8 <.L__truncdfsf2_no_round_tie>
    23f6:	95be                	add	a1,a1,a5

000023f8 <.L__truncdfsf2_no_round_tie>:
    23f8:	00d58533          	add	a0,a1,a3
    23fc:	8082                	ret

000023fe <.L__truncdfsf2_underflow>:
    23fe:	01f5d513          	srl	a0,a1,0x1f
    2402:	057e                	sll	a0,a0,0x1f
    2404:	8082                	ret

00002406 <.L__truncdfsf2_inf_nan>:
    2406:	00c59693          	sll	a3,a1,0xc
    240a:	8ec9                	or	a3,a3,a0
    240c:	ea81                	bnez	a3,241c <.L__truncdfsf2_nan>

0000240e <.L__truncdfsf2_inf>:
    240e:	81fd                	srl	a1,a1,0x1f
    2410:	05fe                	sll	a1,a1,0x1f
    2412:	7f800537          	lui	a0,0x7f800
    2416:	8d4d                	or	a0,a0,a1
    2418:	4581                	li	a1,0
    241a:	8082                	ret

0000241c <.L__truncdfsf2_nan>:
    241c:	800006b7          	lui	a3,0x80000
    2420:	00d5f633          	and	a2,a1,a3
    2424:	058e                	sll	a1,a1,0x3
    2426:	8175                	srl	a0,a0,0x1d
    2428:	8d4d                	or	a0,a0,a1
    242a:	0506                	sll	a0,a0,0x1
    242c:	8105                	srl	a0,a0,0x1
    242e:	8d51                	or	a0,a0,a2
    2430:	82a5                	srl	a3,a3,0x9
    2432:	8d55                	or	a0,a0,a3
    2434:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ldouble_to_double:

00002436 <__SEGGER_RTL_ldouble_to_double>:
    2436:	4158                	lw	a4,4(a0)
    2438:	451c                	lw	a5,8(a0)
    243a:	4554                	lw	a3,12(a0)
    243c:	1141                	add	sp,sp,-16
    243e:	c23a                	sw	a4,4(sp)
    2440:	c43e                	sw	a5,8(sp)
    2442:	7771                	lui	a4,0xffffc
    2444:	00169793          	sll	a5,a3,0x1
    2448:	83c5                	srl	a5,a5,0x11
    244a:	40070713          	add	a4,a4,1024 # ffffc400 <__SHARE_RAM_segment_end__+0xfee7c400>
    244e:	c636                	sw	a3,12(sp)
    2450:	97ba                	add	a5,a5,a4
    2452:	00f04a63          	bgtz	a5,2466 <.L27>
    2456:	800007b7          	lui	a5,0x80000
    245a:	4701                	li	a4,0
    245c:	8ff5                	and	a5,a5,a3

0000245e <.L28>:
    245e:	853a                	mv	a0,a4
    2460:	85be                	mv	a1,a5
    2462:	0141                	add	sp,sp,16
    2464:	8082                	ret

00002466 <.L27>:
    2466:	6711                	lui	a4,0x4
    2468:	3ff70713          	add	a4,a4,1023 # 43ff <.L__divsf3_lhs_inf_or_nan+0x7>
    246c:	00e78c63          	beq	a5,a4,2484 <.L29>
    2470:	7ff00713          	li	a4,2047
    2474:	00f75a63          	bge	a4,a5,2488 <.L30>
    2478:	4781                	li	a5,0
    247a:	4801                	li	a6,0
    247c:	c43e                	sw	a5,8(sp)
    247e:	c642                	sw	a6,12(sp)
    2480:	c03e                	sw	a5,0(sp)
    2482:	c242                	sw	a6,4(sp)

00002484 <.L29>:
    2484:	7ff00793          	li	a5,2047

00002488 <.L30>:
    2488:	45a2                	lw	a1,8(sp)
    248a:	4732                	lw	a4,12(sp)
    248c:	80000637          	lui	a2,0x80000
    2490:	01c5d513          	srl	a0,a1,0x1c
    2494:	8e79                	and	a2,a2,a4
    2496:	0712                	sll	a4,a4,0x4
    2498:	4692                	lw	a3,4(sp)
    249a:	8f49                	or	a4,a4,a0
    249c:	0732                	sll	a4,a4,0xc
    249e:	8331                	srl	a4,a4,0xc
    24a0:	8e59                	or	a2,a2,a4
    24a2:	82f1                	srl	a3,a3,0x1c
    24a4:	0592                	sll	a1,a1,0x4
    24a6:	07d2                	sll	a5,a5,0x14
    24a8:	00b6e733          	or	a4,a3,a1
    24ac:	8fd1                	or	a5,a5,a2
    24ae:	bf45                	j	245e <.L28>

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnan:

000024b0 <__SEGGER_RTL_float32_isnan>:
    24b0:	ff0007b7          	lui	a5,0xff000
    24b4:	0785                	add	a5,a5,1 # ff000001 <__SHARE_RAM_segment_end__+0xfde80001>
    24b6:	0506                	sll	a0,a0,0x1
    24b8:	00f53533          	sltu	a0,a0,a5
    24bc:	00154513          	xor	a0,a0,1
    24c0:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isinf:

000024c2 <__SEGGER_RTL_float32_isinf>:
    24c2:	010007b7          	lui	a5,0x1000
    24c6:	0506                	sll	a0,a0,0x1
    24c8:	953e                	add	a0,a0,a5
    24ca:	00153513          	seqz	a0,a0
    24ce:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnormal:

000024d0 <__SEGGER_RTL_float32_isnormal>:
    24d0:	ff0007b7          	lui	a5,0xff000
    24d4:	0506                	sll	a0,a0,0x1
    24d6:	953e                	add	a0,a0,a5
    24d8:	fe0007b7          	lui	a5,0xfe000
    24dc:	00f53533          	sltu	a0,a0,a5
    24e0:	8082                	ret

Disassembly of section .text.libc.floorf:

000024e2 <floorf>:
    24e2:	00151693          	sll	a3,a0,0x1
    24e6:	82e1                	srl	a3,a3,0x18
    24e8:	01755793          	srl	a5,a0,0x17
    24ec:	16fd                	add	a3,a3,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>
    24ee:	0fd00613          	li	a2,253
    24f2:	872a                	mv	a4,a0
    24f4:	0ff7f793          	zext.b	a5,a5
    24f8:	00d67963          	bgeu	a2,a3,250a <.L1240>
    24fc:	e789                	bnez	a5,2506 <.L1241>
    24fe:	800007b7          	lui	a5,0x80000
    2502:	00f57733          	and	a4,a0,a5

00002506 <.L1241>:
    2506:	853a                	mv	a0,a4
    2508:	8082                	ret

0000250a <.L1240>:
    250a:	f8178793          	add	a5,a5,-127 # 7fffff81 <__SHARE_RAM_segment_end__+0x7ee7ff81>
    250e:	0007d963          	bgez	a5,2520 <.L1243>
    2512:	00000513          	li	a0,0
    2516:	02075863          	bgez	a4,2546 <.L1242>
    251a:	6741a503          	lw	a0,1652(gp) # f18 <.Lmerged_single+0x18>
    251e:	8082                	ret

00002520 <.L1243>:
    2520:	46d9                	li	a3,22
    2522:	02f6c263          	blt	a3,a5,2546 <.L1242>
    2526:	008006b7          	lui	a3,0x800
    252a:	fff68613          	add	a2,a3,-1 # 7fffff <__DLM_segment_end__+0x73ffff>
    252e:	00f65633          	srl	a2,a2,a5
    2532:	fff64513          	not	a0,a2
    2536:	8d79                	and	a0,a0,a4
    2538:	8f71                	and	a4,a4,a2
    253a:	c711                	beqz	a4,2546 <.L1242>
    253c:	00055563          	bgez	a0,2546 <.L1242>
    2540:	00f6d6b3          	srl	a3,a3,a5
    2544:	9536                	add	a0,a0,a3

00002546 <.L1242>:
    2546:	8082                	ret

Disassembly of section .text.libc.__ashldi3:

00002548 <__ashldi3>:
    2548:	02067793          	and	a5,a2,32
    254c:	ef89                	bnez	a5,2566 <.L__ashldi3LongShift>
    254e:	00155793          	srl	a5,a0,0x1
    2552:	fff64713          	not	a4,a2
    2556:	00e7d7b3          	srl	a5,a5,a4
    255a:	00c595b3          	sll	a1,a1,a2
    255e:	8ddd                	or	a1,a1,a5
    2560:	00c51533          	sll	a0,a0,a2
    2564:	8082                	ret

00002566 <.L__ashldi3LongShift>:
    2566:	00c515b3          	sll	a1,a0,a2
    256a:	4501                	li	a0,0
    256c:	8082                	ret

Disassembly of section .text.libc.__udivdi3:

0000256e <__udivdi3>:
    256e:	1101                	add	sp,sp,-32
    2570:	cc22                	sw	s0,24(sp)
    2572:	ca26                	sw	s1,20(sp)
    2574:	c84a                	sw	s2,16(sp)
    2576:	c64e                	sw	s3,12(sp)
    2578:	ce06                	sw	ra,28(sp)
    257a:	c452                	sw	s4,8(sp)
    257c:	c256                	sw	s5,4(sp)
    257e:	c05a                	sw	s6,0(sp)
    2580:	842a                	mv	s0,a0
    2582:	892e                	mv	s2,a1
    2584:	89b2                	mv	s3,a2
    2586:	84b6                	mv	s1,a3
    2588:	2e069063          	bnez	a3,2868 <.L47>
    258c:	ed99                	bnez	a1,25aa <.L48>
    258e:	02c55433          	divu	s0,a0,a2

00002592 <.L49>:
    2592:	40f2                	lw	ra,28(sp)
    2594:	8522                	mv	a0,s0
    2596:	4462                	lw	s0,24(sp)
    2598:	44d2                	lw	s1,20(sp)
    259a:	49b2                	lw	s3,12(sp)
    259c:	4a22                	lw	s4,8(sp)
    259e:	4a92                	lw	s5,4(sp)
    25a0:	4b02                	lw	s6,0(sp)
    25a2:	85ca                	mv	a1,s2
    25a4:	4942                	lw	s2,16(sp)
    25a6:	6105                	add	sp,sp,32
    25a8:	8082                	ret

000025aa <.L48>:
    25aa:	010007b7          	lui	a5,0x1000
    25ae:	12f67863          	bgeu	a2,a5,26de <.L50>
    25b2:	4791                	li	a5,4
    25b4:	08c7e763          	bltu	a5,a2,2642 <.L52>
    25b8:	470d                	li	a4,3
    25ba:	02e60263          	beq	a2,a4,25de <.L54>
    25be:	06f60a63          	beq	a2,a5,2632 <.L55>
    25c2:	4785                	li	a5,1
    25c4:	fcf607e3          	beq	a2,a5,2592 <.L49>
    25c8:	4789                	li	a5,2
    25ca:	3af61c63          	bne	a2,a5,2982 <.L88>
    25ce:	01f59793          	sll	a5,a1,0x1f
    25d2:	00155413          	srl	s0,a0,0x1
    25d6:	8c5d                	or	s0,s0,a5
    25d8:	0015d913          	srl	s2,a1,0x1
    25dc:	bf5d                	j	2592 <.L49>

000025de <.L54>:
    25de:	555557b7          	lui	a5,0x55555
    25e2:	55578793          	add	a5,a5,1365 # 55555555 <__SHARE_RAM_segment_end__+0x543d5555>
    25e6:	02b7b6b3          	mulhu	a3,a5,a1
    25ea:	02a7b633          	mulhu	a2,a5,a0
    25ee:	02a78733          	mul	a4,a5,a0
    25f2:	02b787b3          	mul	a5,a5,a1
    25f6:	97b2                	add	a5,a5,a2
    25f8:	00c7b633          	sltu	a2,a5,a2
    25fc:	9636                	add	a2,a2,a3
    25fe:	00f706b3          	add	a3,a4,a5
    2602:	00e6b733          	sltu	a4,a3,a4
    2606:	9732                	add	a4,a4,a2
    2608:	97ba                	add	a5,a5,a4
    260a:	00e7b5b3          	sltu	a1,a5,a4
    260e:	9736                	add	a4,a4,a3
    2610:	00d736b3          	sltu	a3,a4,a3
    2614:	0705                	add	a4,a4,1
    2616:	97b6                	add	a5,a5,a3
    2618:	00173713          	seqz	a4,a4
    261c:	00d7b6b3          	sltu	a3,a5,a3
    2620:	962e                	add	a2,a2,a1
    2622:	97ba                	add	a5,a5,a4
    2624:	00c68933          	add	s2,a3,a2
    2628:	00e7b733          	sltu	a4,a5,a4
    262c:	843e                	mv	s0,a5
    262e:	993a                	add	s2,s2,a4
    2630:	b78d                	j	2592 <.L49>

00002632 <.L55>:
    2632:	01e59793          	sll	a5,a1,0x1e
    2636:	00255413          	srl	s0,a0,0x2
    263a:	8c5d                	or	s0,s0,a5
    263c:	0025d913          	srl	s2,a1,0x2
    2640:	bf89                	j	2592 <.L49>

00002642 <.L52>:
    2642:	67c1                	lui	a5,0x10
    2644:	02c5d6b3          	divu	a3,a1,a2
    2648:	01055713          	srl	a4,a0,0x10
    264c:	02f67a63          	bgeu	a2,a5,2680 <.L62>
    2650:	01051413          	sll	s0,a0,0x10
    2654:	8041                	srl	s0,s0,0x10
    2656:	02c687b3          	mul	a5,a3,a2
    265a:	40f587b3          	sub	a5,a1,a5
    265e:	07c2                	sll	a5,a5,0x10
    2660:	97ba                	add	a5,a5,a4
    2662:	02c7d933          	divu	s2,a5,a2
    2666:	02c90733          	mul	a4,s2,a2
    266a:	0942                	sll	s2,s2,0x10
    266c:	8f99                	sub	a5,a5,a4
    266e:	07c2                	sll	a5,a5,0x10
    2670:	943e                	add	s0,s0,a5
    2672:	02c45433          	divu	s0,s0,a2
    2676:	944a                	add	s0,s0,s2
    2678:	01243933          	sltu	s2,s0,s2
    267c:	9936                	add	s2,s2,a3
    267e:	bf11                	j	2592 <.L49>

00002680 <.L62>:
    2680:	02c687b3          	mul	a5,a3,a2
    2684:	01855613          	srl	a2,a0,0x18
    2688:	0ff77713          	zext.b	a4,a4
    268c:	0ff47413          	zext.b	s0,s0
    2690:	8936                	mv	s2,a3
    2692:	40f587b3          	sub	a5,a1,a5
    2696:	07a2                	sll	a5,a5,0x8
    2698:	963e                	add	a2,a2,a5
    269a:	033657b3          	divu	a5,a2,s3
    269e:	033785b3          	mul	a1,a5,s3
    26a2:	07a2                	sll	a5,a5,0x8
    26a4:	8e0d                	sub	a2,a2,a1
    26a6:	0622                	sll	a2,a2,0x8
    26a8:	9732                	add	a4,a4,a2
    26aa:	033755b3          	divu	a1,a4,s3
    26ae:	97ae                	add	a5,a5,a1
    26b0:	07a2                	sll	a5,a5,0x8
    26b2:	03358633          	mul	a2,a1,s3
    26b6:	8f11                	sub	a4,a4,a2
    26b8:	00855613          	srl	a2,a0,0x8
    26bc:	0ff67613          	zext.b	a2,a2
    26c0:	0722                	sll	a4,a4,0x8
    26c2:	9732                	add	a4,a4,a2
    26c4:	03375633          	divu	a2,a4,s3
    26c8:	97b2                	add	a5,a5,a2
    26ca:	07a2                	sll	a5,a5,0x8
    26cc:	03360533          	mul	a0,a2,s3
    26d0:	8f09                	sub	a4,a4,a0
    26d2:	0722                	sll	a4,a4,0x8
    26d4:	943a                	add	s0,s0,a4
    26d6:	03345433          	divu	s0,s0,s3
    26da:	943e                	add	s0,s0,a5
    26dc:	bd5d                	j	2592 <.L49>

000026de <.L50>:
    26de:	02818a93          	add	s5,gp,40 # 8cc <__SEGGER_RTL_Moeller_inverse_lut>
    26e2:	0cc5f063          	bgeu	a1,a2,27a2 <.L64>
    26e6:	10000737          	lui	a4,0x10000
    26ea:	87b2                	mv	a5,a2
    26ec:	00e67563          	bgeu	a2,a4,26f6 <.L65>
    26f0:	00461793          	sll	a5,a2,0x4
    26f4:	4491                	li	s1,4

000026f6 <.L65>:
    26f6:	40000737          	lui	a4,0x40000
    26fa:	00e7f463          	bgeu	a5,a4,2702 <.L66>
    26fe:	0489                	add	s1,s1,2
    2700:	078a                	sll	a5,a5,0x2

00002702 <.L66>:
    2702:	0007c363          	bltz	a5,2708 <.L67>
    2706:	0485                	add	s1,s1,1

00002708 <.L67>:
    2708:	8626                	mv	a2,s1
    270a:	8522                	mv	a0,s0
    270c:	85ca                	mv	a1,s2
    270e:	3d2d                	jal	2548 <__ashldi3>
    2710:	009994b3          	sll	s1,s3,s1
    2714:	0164d793          	srl	a5,s1,0x16
    2718:	e0078793          	add	a5,a5,-512 # fe00 <__ILM_segment_used_end__+0xa5b8>
    271c:	0786                	sll	a5,a5,0x1
    271e:	97d6                	add	a5,a5,s5
    2720:	0007d783          	lhu	a5,0(a5)
    2724:	00b4d813          	srl	a6,s1,0xb
    2728:	0014f713          	and	a4,s1,1
    272c:	02f78633          	mul	a2,a5,a5
    2730:	0792                	sll	a5,a5,0x4
    2732:	0014d693          	srl	a3,s1,0x1
    2736:	0805                	add	a6,a6,1
    2738:	03063633          	mulhu	a2,a2,a6
    273c:	8f91                	sub	a5,a5,a2
    273e:	96ba                	add	a3,a3,a4
    2740:	17fd                	add	a5,a5,-1
    2742:	c319                	beqz	a4,2748 <.L68>
    2744:	0017d713          	srl	a4,a5,0x1

00002748 <.L68>:
    2748:	02f686b3          	mul	a3,a3,a5
    274c:	8f15                	sub	a4,a4,a3
    274e:	02e7b733          	mulhu	a4,a5,a4
    2752:	07be                	sll	a5,a5,0xf
    2754:	8305                	srl	a4,a4,0x1
    2756:	97ba                	add	a5,a5,a4
    2758:	8726                	mv	a4,s1
    275a:	029786b3          	mul	a3,a5,s1
    275e:	9736                	add	a4,a4,a3
    2760:	00d736b3          	sltu	a3,a4,a3
    2764:	8726                	mv	a4,s1
    2766:	9736                	add	a4,a4,a3
    2768:	0297b6b3          	mulhu	a3,a5,s1
    276c:	9736                	add	a4,a4,a3
    276e:	8f99                	sub	a5,a5,a4
    2770:	02b7b733          	mulhu	a4,a5,a1
    2774:	02b787b3          	mul	a5,a5,a1
    2778:	00a786b3          	add	a3,a5,a0
    277c:	00f6b7b3          	sltu	a5,a3,a5
    2780:	95be                	add	a1,a1,a5
    2782:	00b707b3          	add	a5,a4,a1
    2786:	00178413          	add	s0,a5,1
    278a:	02848733          	mul	a4,s1,s0
    278e:	8d19                	sub	a0,a0,a4
    2790:	00a6f463          	bgeu	a3,a0,2798 <.L69>
    2794:	9526                	add	a0,a0,s1
    2796:	843e                	mv	s0,a5

00002798 <.L69>:
    2798:	00956363          	bltu	a0,s1,279e <.L109>
    279c:	0405                	add	s0,s0,1

0000279e <.L109>:
    279e:	4901                	li	s2,0
    27a0:	bbcd                	j	2592 <.L49>

000027a2 <.L64>:
    27a2:	02c5da33          	divu	s4,a1,a2
    27a6:	10000737          	lui	a4,0x10000
    27aa:	87b2                	mv	a5,a2
    27ac:	02ca05b3          	mul	a1,s4,a2
    27b0:	40b905b3          	sub	a1,s2,a1
    27b4:	00e67563          	bgeu	a2,a4,27be <.L71>
    27b8:	00461793          	sll	a5,a2,0x4
    27bc:	4491                	li	s1,4

000027be <.L71>:
    27be:	40000737          	lui	a4,0x40000
    27c2:	00e7f463          	bgeu	a5,a4,27ca <.L72>
    27c6:	0489                	add	s1,s1,2
    27c8:	078a                	sll	a5,a5,0x2

000027ca <.L72>:
    27ca:	0007c363          	bltz	a5,27d0 <.L73>
    27ce:	0485                	add	s1,s1,1

000027d0 <.L73>:
    27d0:	8626                	mv	a2,s1
    27d2:	8522                	mv	a0,s0
    27d4:	3b95                	jal	2548 <__ashldi3>
    27d6:	009994b3          	sll	s1,s3,s1
    27da:	0164d793          	srl	a5,s1,0x16
    27de:	e0078793          	add	a5,a5,-512
    27e2:	0786                	sll	a5,a5,0x1
    27e4:	9abe                	add	s5,s5,a5
    27e6:	000ad783          	lhu	a5,0(s5)
    27ea:	00b4d813          	srl	a6,s1,0xb
    27ee:	0014f713          	and	a4,s1,1
    27f2:	02f78633          	mul	a2,a5,a5
    27f6:	0792                	sll	a5,a5,0x4
    27f8:	0014d693          	srl	a3,s1,0x1
    27fc:	0805                	add	a6,a6,1
    27fe:	03063633          	mulhu	a2,a2,a6
    2802:	8f91                	sub	a5,a5,a2
    2804:	96ba                	add	a3,a3,a4
    2806:	17fd                	add	a5,a5,-1
    2808:	c319                	beqz	a4,280e <.L74>
    280a:	0017d713          	srl	a4,a5,0x1

0000280e <.L74>:
    280e:	02f686b3          	mul	a3,a3,a5
    2812:	8f15                	sub	a4,a4,a3
    2814:	02e7b733          	mulhu	a4,a5,a4
    2818:	07be                	sll	a5,a5,0xf
    281a:	8305                	srl	a4,a4,0x1
    281c:	97ba                	add	a5,a5,a4
    281e:	8726                	mv	a4,s1
    2820:	029786b3          	mul	a3,a5,s1
    2824:	9736                	add	a4,a4,a3
    2826:	00d736b3          	sltu	a3,a4,a3
    282a:	8726                	mv	a4,s1
    282c:	9736                	add	a4,a4,a3
    282e:	0297b6b3          	mulhu	a3,a5,s1
    2832:	9736                	add	a4,a4,a3
    2834:	8f99                	sub	a5,a5,a4
    2836:	02b7b733          	mulhu	a4,a5,a1
    283a:	02b787b3          	mul	a5,a5,a1
    283e:	00a786b3          	add	a3,a5,a0
    2842:	00f6b7b3          	sltu	a5,a3,a5
    2846:	95be                	add	a1,a1,a5
    2848:	00b707b3          	add	a5,a4,a1
    284c:	00178413          	add	s0,a5,1
    2850:	02848733          	mul	a4,s1,s0
    2854:	8d19                	sub	a0,a0,a4
    2856:	00a6f463          	bgeu	a3,a0,285e <.L75>
    285a:	9526                	add	a0,a0,s1
    285c:	843e                	mv	s0,a5

0000285e <.L75>:
    285e:	00956363          	bltu	a0,s1,2864 <.L76>
    2862:	0405                	add	s0,s0,1

00002864 <.L76>:
    2864:	8952                	mv	s2,s4
    2866:	b335                	j	2592 <.L49>

00002868 <.L47>:
    2868:	67c1                	lui	a5,0x10
    286a:	8ab6                	mv	s5,a3
    286c:	4a01                	li	s4,0
    286e:	00f6f563          	bgeu	a3,a5,2878 <.L77>
    2872:	01069493          	sll	s1,a3,0x10
    2876:	4a41                	li	s4,16

00002878 <.L77>:
    2878:	010007b7          	lui	a5,0x1000
    287c:	00f4f463          	bgeu	s1,a5,2884 <.L78>
    2880:	0a21                	add	s4,s4,8
    2882:	04a2                	sll	s1,s1,0x8

00002884 <.L78>:
    2884:	100007b7          	lui	a5,0x10000
    2888:	00f4f463          	bgeu	s1,a5,2890 <.L79>
    288c:	0a11                	add	s4,s4,4
    288e:	0492                	sll	s1,s1,0x4

00002890 <.L79>:
    2890:	400007b7          	lui	a5,0x40000
    2894:	00f4f463          	bgeu	s1,a5,289c <.L80>
    2898:	0a09                	add	s4,s4,2
    289a:	048a                	sll	s1,s1,0x2

0000289c <.L80>:
    289c:	0004c363          	bltz	s1,28a2 <.L81>
    28a0:	0a05                	add	s4,s4,1

000028a2 <.L81>:
    28a2:	01f91793          	sll	a5,s2,0x1f
    28a6:	8652                	mv	a2,s4
    28a8:	00145493          	srl	s1,s0,0x1
    28ac:	854e                	mv	a0,s3
    28ae:	85d6                	mv	a1,s5
    28b0:	8cdd                	or	s1,s1,a5
    28b2:	3959                	jal	2548 <__ashldi3>
    28b4:	0165d613          	srl	a2,a1,0x16
    28b8:	e0060613          	add	a2,a2,-512 # 7ffffe00 <__SHARE_RAM_segment_end__+0x7ee7fe00>
    28bc:	0606                	sll	a2,a2,0x1
    28be:	02818793          	add	a5,gp,40 # 8cc <__SEGGER_RTL_Moeller_inverse_lut>
    28c2:	97b2                	add	a5,a5,a2
    28c4:	0007d783          	lhu	a5,0(a5) # 40000000 <__SHARE_RAM_segment_end__+0x3ee80000>
    28c8:	00b5d513          	srl	a0,a1,0xb
    28cc:	0015f713          	and	a4,a1,1
    28d0:	02f78633          	mul	a2,a5,a5
    28d4:	0792                	sll	a5,a5,0x4
    28d6:	0015d693          	srl	a3,a1,0x1
    28da:	0505                	add	a0,a0,1 # 7f800001 <__SHARE_RAM_segment_end__+0x7e680001>
    28dc:	02a63633          	mulhu	a2,a2,a0
    28e0:	8f91                	sub	a5,a5,a2
    28e2:	00195b13          	srl	s6,s2,0x1
    28e6:	96ba                	add	a3,a3,a4
    28e8:	17fd                	add	a5,a5,-1
    28ea:	c319                	beqz	a4,28f0 <.L82>
    28ec:	0017d713          	srl	a4,a5,0x1

000028f0 <.L82>:
    28f0:	02f686b3          	mul	a3,a3,a5
    28f4:	8f15                	sub	a4,a4,a3
    28f6:	02e7b733          	mulhu	a4,a5,a4
    28fa:	07be                	sll	a5,a5,0xf
    28fc:	8305                	srl	a4,a4,0x1
    28fe:	97ba                	add	a5,a5,a4
    2900:	872e                	mv	a4,a1
    2902:	02b786b3          	mul	a3,a5,a1
    2906:	9736                	add	a4,a4,a3
    2908:	00d736b3          	sltu	a3,a4,a3
    290c:	872e                	mv	a4,a1
    290e:	9736                	add	a4,a4,a3
    2910:	02b7b6b3          	mulhu	a3,a5,a1
    2914:	9736                	add	a4,a4,a3
    2916:	8f99                	sub	a5,a5,a4
    2918:	0367b733          	mulhu	a4,a5,s6
    291c:	036787b3          	mul	a5,a5,s6
    2920:	009786b3          	add	a3,a5,s1
    2924:	00f6b7b3          	sltu	a5,a3,a5
    2928:	97da                	add	a5,a5,s6
    292a:	973e                	add	a4,a4,a5
    292c:	00170793          	add	a5,a4,1 # 40000001 <__SHARE_RAM_segment_end__+0x3ee80001>
    2930:	02f58633          	mul	a2,a1,a5
    2934:	8c91                	sub	s1,s1,a2
    2936:	0096f463          	bgeu	a3,s1,293e <.L83>
    293a:	94ae                	add	s1,s1,a1
    293c:	87ba                	mv	a5,a4

0000293e <.L83>:
    293e:	00b4e363          	bltu	s1,a1,2944 <.L84>
    2942:	0785                	add	a5,a5,1

00002944 <.L84>:
    2944:	477d                	li	a4,31
    2946:	41470733          	sub	a4,a4,s4
    294a:	00e7d633          	srl	a2,a5,a4
    294e:	c211                	beqz	a2,2952 <.L85>
    2950:	167d                	add	a2,a2,-1

00002952 <.L85>:
    2952:	02ca87b3          	mul	a5,s5,a2
    2956:	03360733          	mul	a4,a2,s3
    295a:	033636b3          	mulhu	a3,a2,s3
    295e:	40e40733          	sub	a4,s0,a4
    2962:	00e43433          	sltu	s0,s0,a4
    2966:	97b6                	add	a5,a5,a3
    2968:	40f907b3          	sub	a5,s2,a5
    296c:	40878433          	sub	s0,a5,s0
    2970:	01546763          	bltu	s0,s5,297e <.L86>
    2974:	008a9463          	bne	s5,s0,297c <.L95>
    2978:	01376363          	bltu	a4,s3,297e <.L86>

0000297c <.L95>:
    297c:	0605                	add	a2,a2,1

0000297e <.L86>:
    297e:	8432                	mv	s0,a2
    2980:	bd39                	j	279e <.L109>

00002982 <.L88>:
    2982:	4401                	li	s0,0
    2984:	bd29                	j	279e <.L109>

Disassembly of section .text.libc.__umoddi3:

00002986 <__umoddi3>:
    2986:	1101                	add	sp,sp,-32
    2988:	cc22                	sw	s0,24(sp)
    298a:	ca26                	sw	s1,20(sp)
    298c:	c84a                	sw	s2,16(sp)
    298e:	c64e                	sw	s3,12(sp)
    2990:	c452                	sw	s4,8(sp)
    2992:	ce06                	sw	ra,28(sp)
    2994:	c256                	sw	s5,4(sp)
    2996:	c05a                	sw	s6,0(sp)
    2998:	892a                	mv	s2,a0
    299a:	84ae                	mv	s1,a1
    299c:	8432                	mv	s0,a2
    299e:	89b6                	mv	s3,a3
    29a0:	8a36                	mv	s4,a3
    29a2:	2e069c63          	bnez	a3,2c9a <.L111>
    29a6:	e589                	bnez	a1,29b0 <.L112>
    29a8:	02c557b3          	divu	a5,a0,a2

000029ac <.L174>:
    29ac:	4701                	li	a4,0
    29ae:	a815                	j	29e2 <.L113>

000029b0 <.L112>:
    29b0:	010007b7          	lui	a5,0x1000
    29b4:	16f67163          	bgeu	a2,a5,2b16 <.L114>
    29b8:	4791                	li	a5,4
    29ba:	0cc7e063          	bltu	a5,a2,2a7a <.L116>
    29be:	470d                	li	a4,3
    29c0:	04e60d63          	beq	a2,a4,2a1a <.L118>
    29c4:	0af60363          	beq	a2,a5,2a6a <.L119>
    29c8:	4785                	li	a5,1
    29ca:	3ef60363          	beq	a2,a5,2db0 <.L152>
    29ce:	4789                	li	a5,2
    29d0:	3ef61363          	bne	a2,a5,2db6 <.L153>
    29d4:	01f59713          	sll	a4,a1,0x1f
    29d8:	00155793          	srl	a5,a0,0x1
    29dc:	8fd9                	or	a5,a5,a4
    29de:	0015d713          	srl	a4,a1,0x1

000029e2 <.L113>:
    29e2:	02870733          	mul	a4,a4,s0
    29e6:	40f2                	lw	ra,28(sp)
    29e8:	4a22                	lw	s4,8(sp)
    29ea:	4a92                	lw	s5,4(sp)
    29ec:	4b02                	lw	s6,0(sp)
    29ee:	02f989b3          	mul	s3,s3,a5
    29f2:	02f40533          	mul	a0,s0,a5
    29f6:	99ba                	add	s3,s3,a4
    29f8:	02f43433          	mulhu	s0,s0,a5
    29fc:	40a90533          	sub	a0,s2,a0
    2a00:	00a935b3          	sltu	a1,s2,a0
    2a04:	4942                	lw	s2,16(sp)
    2a06:	99a2                	add	s3,s3,s0
    2a08:	4462                	lw	s0,24(sp)
    2a0a:	413484b3          	sub	s1,s1,s3
    2a0e:	40b485b3          	sub	a1,s1,a1
    2a12:	49b2                	lw	s3,12(sp)
    2a14:	44d2                	lw	s1,20(sp)
    2a16:	6105                	add	sp,sp,32
    2a18:	8082                	ret

00002a1a <.L118>:
    2a1a:	555557b7          	lui	a5,0x55555
    2a1e:	55578793          	add	a5,a5,1365 # 55555555 <__SHARE_RAM_segment_end__+0x543d5555>
    2a22:	02b7b6b3          	mulhu	a3,a5,a1
    2a26:	02a7b633          	mulhu	a2,a5,a0
    2a2a:	02a78733          	mul	a4,a5,a0
    2a2e:	02b787b3          	mul	a5,a5,a1
    2a32:	97b2                	add	a5,a5,a2
    2a34:	00c7b633          	sltu	a2,a5,a2
    2a38:	9636                	add	a2,a2,a3
    2a3a:	00f706b3          	add	a3,a4,a5
    2a3e:	00e6b733          	sltu	a4,a3,a4
    2a42:	9732                	add	a4,a4,a2
    2a44:	97ba                	add	a5,a5,a4
    2a46:	00e7b5b3          	sltu	a1,a5,a4
    2a4a:	9736                	add	a4,a4,a3
    2a4c:	00d736b3          	sltu	a3,a4,a3
    2a50:	0705                	add	a4,a4,1
    2a52:	97b6                	add	a5,a5,a3
    2a54:	00173713          	seqz	a4,a4
    2a58:	00d7b6b3          	sltu	a3,a5,a3
    2a5c:	962e                	add	a2,a2,a1
    2a5e:	97ba                	add	a5,a5,a4
    2a60:	96b2                	add	a3,a3,a2
    2a62:	00e7b733          	sltu	a4,a5,a4
    2a66:	9736                	add	a4,a4,a3
    2a68:	bfad                	j	29e2 <.L113>

00002a6a <.L119>:
    2a6a:	01e59713          	sll	a4,a1,0x1e
    2a6e:	00255793          	srl	a5,a0,0x2
    2a72:	8fd9                	or	a5,a5,a4
    2a74:	0025d713          	srl	a4,a1,0x2
    2a78:	b7ad                	j	29e2 <.L113>

00002a7a <.L116>:
    2a7a:	67c1                	lui	a5,0x10
    2a7c:	02c5d733          	divu	a4,a1,a2
    2a80:	01055693          	srl	a3,a0,0x10
    2a84:	02f67b63          	bgeu	a2,a5,2aba <.L126>
    2a88:	02c707b3          	mul	a5,a4,a2
    2a8c:	40f587b3          	sub	a5,a1,a5
    2a90:	07c2                	sll	a5,a5,0x10
    2a92:	97b6                	add	a5,a5,a3
    2a94:	02c7d633          	divu	a2,a5,a2
    2a98:	028606b3          	mul	a3,a2,s0
    2a9c:	0642                	sll	a2,a2,0x10
    2a9e:	8f95                	sub	a5,a5,a3
    2aa0:	01079693          	sll	a3,a5,0x10
    2aa4:	01051793          	sll	a5,a0,0x10
    2aa8:	83c1                	srl	a5,a5,0x10
    2aaa:	97b6                	add	a5,a5,a3
    2aac:	0287d7b3          	divu	a5,a5,s0
    2ab0:	97b2                	add	a5,a5,a2
    2ab2:	00c7b633          	sltu	a2,a5,a2
    2ab6:	9732                	add	a4,a4,a2
    2ab8:	b72d                	j	29e2 <.L113>

00002aba <.L126>:
    2aba:	02c707b3          	mul	a5,a4,a2
    2abe:	01855613          	srl	a2,a0,0x18
    2ac2:	0ff6f693          	zext.b	a3,a3
    2ac6:	40f587b3          	sub	a5,a1,a5
    2aca:	07a2                	sll	a5,a5,0x8
    2acc:	963e                	add	a2,a2,a5
    2ace:	028657b3          	divu	a5,a2,s0
    2ad2:	028785b3          	mul	a1,a5,s0
    2ad6:	07a2                	sll	a5,a5,0x8
    2ad8:	8e0d                	sub	a2,a2,a1
    2ada:	0622                	sll	a2,a2,0x8
    2adc:	96b2                	add	a3,a3,a2
    2ade:	0286d5b3          	divu	a1,a3,s0
    2ae2:	97ae                	add	a5,a5,a1
    2ae4:	07a2                	sll	a5,a5,0x8
    2ae6:	02858633          	mul	a2,a1,s0
    2aea:	8e91                	sub	a3,a3,a2
    2aec:	00855613          	srl	a2,a0,0x8
    2af0:	0ff67613          	zext.b	a2,a2
    2af4:	06a2                	sll	a3,a3,0x8
    2af6:	96b2                	add	a3,a3,a2
    2af8:	0286d633          	divu	a2,a3,s0
    2afc:	97b2                	add	a5,a5,a2
    2afe:	07a2                	sll	a5,a5,0x8
    2b00:	02860533          	mul	a0,a2,s0
    2b04:	0ff97613          	zext.b	a2,s2
    2b08:	8e89                	sub	a3,a3,a0
    2b0a:	06a2                	sll	a3,a3,0x8
    2b0c:	96b2                	add	a3,a3,a2
    2b0e:	0286d6b3          	divu	a3,a3,s0
    2b12:	97b6                	add	a5,a5,a3
    2b14:	b5f9                	j	29e2 <.L113>

00002b16 <.L114>:
    2b16:	02818b13          	add	s6,gp,40 # 8cc <__SEGGER_RTL_Moeller_inverse_lut>
    2b1a:	0ac5fe63          	bgeu	a1,a2,2bd6 <.L128>
    2b1e:	10000737          	lui	a4,0x10000
    2b22:	87b2                	mv	a5,a2
    2b24:	00e67563          	bgeu	a2,a4,2b2e <.L129>
    2b28:	00461793          	sll	a5,a2,0x4
    2b2c:	4a11                	li	s4,4

00002b2e <.L129>:
    2b2e:	40000737          	lui	a4,0x40000
    2b32:	00e7f463          	bgeu	a5,a4,2b3a <.L130>
    2b36:	0a09                	add	s4,s4,2
    2b38:	078a                	sll	a5,a5,0x2

00002b3a <.L130>:
    2b3a:	0007c363          	bltz	a5,2b40 <.L131>
    2b3e:	0a05                	add	s4,s4,1

00002b40 <.L131>:
    2b40:	8652                	mv	a2,s4
    2b42:	854a                	mv	a0,s2
    2b44:	85a6                	mv	a1,s1
    2b46:	3409                	jal	2548 <__ashldi3>
    2b48:	01441a33          	sll	s4,s0,s4
    2b4c:	016a5793          	srl	a5,s4,0x16
    2b50:	e0078793          	add	a5,a5,-512 # fe00 <__ILM_segment_used_end__+0xa5b8>
    2b54:	0786                	sll	a5,a5,0x1
    2b56:	97da                	add	a5,a5,s6
    2b58:	0007d783          	lhu	a5,0(a5)
    2b5c:	00ba5813          	srl	a6,s4,0xb
    2b60:	001a7713          	and	a4,s4,1
    2b64:	02f78633          	mul	a2,a5,a5
    2b68:	0792                	sll	a5,a5,0x4
    2b6a:	001a5693          	srl	a3,s4,0x1
    2b6e:	0805                	add	a6,a6,1
    2b70:	03063633          	mulhu	a2,a2,a6
    2b74:	8f91                	sub	a5,a5,a2
    2b76:	96ba                	add	a3,a3,a4
    2b78:	17fd                	add	a5,a5,-1
    2b7a:	c319                	beqz	a4,2b80 <.L132>
    2b7c:	0017d713          	srl	a4,a5,0x1

00002b80 <.L132>:
    2b80:	02f686b3          	mul	a3,a3,a5
    2b84:	8f15                	sub	a4,a4,a3
    2b86:	02e7b733          	mulhu	a4,a5,a4
    2b8a:	07be                	sll	a5,a5,0xf
    2b8c:	8305                	srl	a4,a4,0x1
    2b8e:	97ba                	add	a5,a5,a4
    2b90:	8752                	mv	a4,s4
    2b92:	034786b3          	mul	a3,a5,s4
    2b96:	9736                	add	a4,a4,a3
    2b98:	00d736b3          	sltu	a3,a4,a3
    2b9c:	8752                	mv	a4,s4
    2b9e:	9736                	add	a4,a4,a3
    2ba0:	0347b6b3          	mulhu	a3,a5,s4
    2ba4:	9736                	add	a4,a4,a3
    2ba6:	8f99                	sub	a5,a5,a4
    2ba8:	02b7b733          	mulhu	a4,a5,a1
    2bac:	02b787b3          	mul	a5,a5,a1
    2bb0:	00a786b3          	add	a3,a5,a0
    2bb4:	00f6b7b3          	sltu	a5,a3,a5
    2bb8:	95be                	add	a1,a1,a5
    2bba:	972e                	add	a4,a4,a1
    2bbc:	00170793          	add	a5,a4,1 # 40000001 <__SHARE_RAM_segment_end__+0x3ee80001>
    2bc0:	02fa0633          	mul	a2,s4,a5
    2bc4:	8d11                	sub	a0,a0,a2
    2bc6:	00a6f463          	bgeu	a3,a0,2bce <.L133>
    2bca:	9552                	add	a0,a0,s4
    2bcc:	87ba                	mv	a5,a4

00002bce <.L133>:
    2bce:	dd456fe3          	bltu	a0,s4,29ac <.L174>

00002bd2 <.L160>:
    2bd2:	0785                	add	a5,a5,1
    2bd4:	bbe1                	j	29ac <.L174>

00002bd6 <.L128>:
    2bd6:	02c5dab3          	divu	s5,a1,a2
    2bda:	10000737          	lui	a4,0x10000
    2bde:	87b2                	mv	a5,a2
    2be0:	02ca85b3          	mul	a1,s5,a2
    2be4:	40b485b3          	sub	a1,s1,a1
    2be8:	00e67563          	bgeu	a2,a4,2bf2 <.L135>
    2bec:	00461793          	sll	a5,a2,0x4
    2bf0:	4a11                	li	s4,4

00002bf2 <.L135>:
    2bf2:	40000737          	lui	a4,0x40000
    2bf6:	00e7f463          	bgeu	a5,a4,2bfe <.L136>
    2bfa:	0a09                	add	s4,s4,2
    2bfc:	078a                	sll	a5,a5,0x2

00002bfe <.L136>:
    2bfe:	0007c363          	bltz	a5,2c04 <.L137>
    2c02:	0a05                	add	s4,s4,1

00002c04 <.L137>:
    2c04:	8652                	mv	a2,s4
    2c06:	854a                	mv	a0,s2
    2c08:	3281                	jal	2548 <__ashldi3>
    2c0a:	01441a33          	sll	s4,s0,s4
    2c0e:	016a5793          	srl	a5,s4,0x16
    2c12:	e0078793          	add	a5,a5,-512
    2c16:	0786                	sll	a5,a5,0x1
    2c18:	9b3e                	add	s6,s6,a5
    2c1a:	000b5783          	lhu	a5,0(s6)
    2c1e:	00ba5813          	srl	a6,s4,0xb
    2c22:	001a7713          	and	a4,s4,1
    2c26:	02f78633          	mul	a2,a5,a5
    2c2a:	0792                	sll	a5,a5,0x4
    2c2c:	001a5693          	srl	a3,s4,0x1
    2c30:	0805                	add	a6,a6,1
    2c32:	03063633          	mulhu	a2,a2,a6
    2c36:	8f91                	sub	a5,a5,a2
    2c38:	96ba                	add	a3,a3,a4
    2c3a:	17fd                	add	a5,a5,-1
    2c3c:	c319                	beqz	a4,2c42 <.L138>
    2c3e:	0017d713          	srl	a4,a5,0x1

00002c42 <.L138>:
    2c42:	02f686b3          	mul	a3,a3,a5
    2c46:	8f15                	sub	a4,a4,a3
    2c48:	02e7b733          	mulhu	a4,a5,a4
    2c4c:	07be                	sll	a5,a5,0xf
    2c4e:	8305                	srl	a4,a4,0x1
    2c50:	97ba                	add	a5,a5,a4
    2c52:	8752                	mv	a4,s4
    2c54:	034786b3          	mul	a3,a5,s4
    2c58:	9736                	add	a4,a4,a3
    2c5a:	00d736b3          	sltu	a3,a4,a3
    2c5e:	8752                	mv	a4,s4
    2c60:	9736                	add	a4,a4,a3
    2c62:	0347b6b3          	mulhu	a3,a5,s4
    2c66:	9736                	add	a4,a4,a3
    2c68:	8f99                	sub	a5,a5,a4
    2c6a:	02b7b733          	mulhu	a4,a5,a1
    2c6e:	02b787b3          	mul	a5,a5,a1
    2c72:	00a786b3          	add	a3,a5,a0
    2c76:	00f6b7b3          	sltu	a5,a3,a5
    2c7a:	95be                	add	a1,a1,a5
    2c7c:	972e                	add	a4,a4,a1
    2c7e:	00170793          	add	a5,a4,1 # 40000001 <__SHARE_RAM_segment_end__+0x3ee80001>
    2c82:	02fa0633          	mul	a2,s4,a5
    2c86:	8d11                	sub	a0,a0,a2
    2c88:	00a6f463          	bgeu	a3,a0,2c90 <.L139>
    2c8c:	9552                	add	a0,a0,s4
    2c8e:	87ba                	mv	a5,a4

00002c90 <.L139>:
    2c90:	01456363          	bltu	a0,s4,2c96 <.L140>
    2c94:	0785                	add	a5,a5,1

00002c96 <.L140>:
    2c96:	8756                	mv	a4,s5
    2c98:	b3a9                	j	29e2 <.L113>

00002c9a <.L111>:
    2c9a:	67c1                	lui	a5,0x10
    2c9c:	4a81                	li	s5,0
    2c9e:	00f6f563          	bgeu	a3,a5,2ca8 <.L141>
    2ca2:	01069a13          	sll	s4,a3,0x10
    2ca6:	4ac1                	li	s5,16

00002ca8 <.L141>:
    2ca8:	010007b7          	lui	a5,0x1000
    2cac:	00fa7463          	bgeu	s4,a5,2cb4 <.L142>
    2cb0:	0aa1                	add	s5,s5,8
    2cb2:	0a22                	sll	s4,s4,0x8

00002cb4 <.L142>:
    2cb4:	100007b7          	lui	a5,0x10000
    2cb8:	00fa7463          	bgeu	s4,a5,2cc0 <.L143>
    2cbc:	0a91                	add	s5,s5,4
    2cbe:	0a12                	sll	s4,s4,0x4

00002cc0 <.L143>:
    2cc0:	400007b7          	lui	a5,0x40000
    2cc4:	00fa7463          	bgeu	s4,a5,2ccc <.L144>
    2cc8:	0a89                	add	s5,s5,2
    2cca:	0a0a                	sll	s4,s4,0x2

00002ccc <.L144>:
    2ccc:	000a4363          	bltz	s4,2cd2 <.L145>
    2cd0:	0a85                	add	s5,s5,1

00002cd2 <.L145>:
    2cd2:	01f49793          	sll	a5,s1,0x1f
    2cd6:	8656                	mv	a2,s5
    2cd8:	00195a13          	srl	s4,s2,0x1
    2cdc:	8522                	mv	a0,s0
    2cde:	85ce                	mv	a1,s3
    2ce0:	0147ea33          	or	s4,a5,s4
    2ce4:	3095                	jal	2548 <__ashldi3>
    2ce6:	0165d613          	srl	a2,a1,0x16
    2cea:	e0060613          	add	a2,a2,-512
    2cee:	0606                	sll	a2,a2,0x1
    2cf0:	02818793          	add	a5,gp,40 # 8cc <__SEGGER_RTL_Moeller_inverse_lut>
    2cf4:	97b2                	add	a5,a5,a2
    2cf6:	0007d783          	lhu	a5,0(a5) # 40000000 <__SHARE_RAM_segment_end__+0x3ee80000>
    2cfa:	00b5d513          	srl	a0,a1,0xb
    2cfe:	0015f713          	and	a4,a1,1
    2d02:	02f78633          	mul	a2,a5,a5
    2d06:	0792                	sll	a5,a5,0x4
    2d08:	0015d693          	srl	a3,a1,0x1
    2d0c:	0505                	add	a0,a0,1
    2d0e:	02a63633          	mulhu	a2,a2,a0
    2d12:	8f91                	sub	a5,a5,a2
    2d14:	0014db13          	srl	s6,s1,0x1
    2d18:	96ba                	add	a3,a3,a4
    2d1a:	17fd                	add	a5,a5,-1
    2d1c:	c319                	beqz	a4,2d22 <.L146>
    2d1e:	0017d713          	srl	a4,a5,0x1

00002d22 <.L146>:
    2d22:	02f686b3          	mul	a3,a3,a5
    2d26:	8f15                	sub	a4,a4,a3
    2d28:	02e7b733          	mulhu	a4,a5,a4
    2d2c:	07be                	sll	a5,a5,0xf
    2d2e:	8305                	srl	a4,a4,0x1
    2d30:	97ba                	add	a5,a5,a4
    2d32:	872e                	mv	a4,a1
    2d34:	02b786b3          	mul	a3,a5,a1
    2d38:	9736                	add	a4,a4,a3
    2d3a:	00d736b3          	sltu	a3,a4,a3
    2d3e:	872e                	mv	a4,a1
    2d40:	9736                	add	a4,a4,a3
    2d42:	02b7b6b3          	mulhu	a3,a5,a1
    2d46:	9736                	add	a4,a4,a3
    2d48:	8f99                	sub	a5,a5,a4
    2d4a:	0367b733          	mulhu	a4,a5,s6
    2d4e:	036787b3          	mul	a5,a5,s6
    2d52:	014786b3          	add	a3,a5,s4
    2d56:	00f6b7b3          	sltu	a5,a3,a5
    2d5a:	97da                	add	a5,a5,s6
    2d5c:	973e                	add	a4,a4,a5
    2d5e:	00170793          	add	a5,a4,1
    2d62:	02f58633          	mul	a2,a1,a5
    2d66:	40ca0a33          	sub	s4,s4,a2
    2d6a:	0146f463          	bgeu	a3,s4,2d72 <.L147>
    2d6e:	9a2e                	add	s4,s4,a1
    2d70:	87ba                	mv	a5,a4

00002d72 <.L147>:
    2d72:	00ba6363          	bltu	s4,a1,2d78 <.L148>
    2d76:	0785                	add	a5,a5,1

00002d78 <.L148>:
    2d78:	477d                	li	a4,31
    2d7a:	41570733          	sub	a4,a4,s5
    2d7e:	00e7d7b3          	srl	a5,a5,a4
    2d82:	c391                	beqz	a5,2d86 <.L149>
    2d84:	17fd                	add	a5,a5,-1

00002d86 <.L149>:
    2d86:	0287b633          	mulhu	a2,a5,s0
    2d8a:	02f98733          	mul	a4,s3,a5
    2d8e:	028786b3          	mul	a3,a5,s0
    2d92:	9732                	add	a4,a4,a2
    2d94:	40e48733          	sub	a4,s1,a4
    2d98:	40d906b3          	sub	a3,s2,a3
    2d9c:	00d93633          	sltu	a2,s2,a3
    2da0:	8f11                	sub	a4,a4,a2
    2da2:	c13765e3          	bltu	a4,s3,29ac <.L174>
    2da6:	e2e996e3          	bne	s3,a4,2bd2 <.L160>
    2daa:	c086e1e3          	bltu	a3,s0,29ac <.L174>
    2dae:	b515                	j	2bd2 <.L160>

00002db0 <.L152>:
    2db0:	87aa                	mv	a5,a0
    2db2:	872e                	mv	a4,a1
    2db4:	b13d                	j	29e2 <.L113>

00002db6 <.L153>:
    2db6:	4781                	li	a5,0
    2db8:	bed5                	j	29ac <.L174>

Disassembly of section .text.libc.abs:

00002dba <abs>:
    2dba:	41f55793          	sra	a5,a0,0x1f
    2dbe:	8d3d                	xor	a0,a0,a5
    2dc0:	8d1d                	sub	a0,a0,a5
    2dc2:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pow10f:

00002dc4 <__SEGGER_RTL_pow10f>:
    2dc4:	1101                	add	sp,sp,-32
    2dc6:	cc22                	sw	s0,24(sp)
    2dc8:	c64e                	sw	s3,12(sp)
    2dca:	ce06                	sw	ra,28(sp)
    2dcc:	ca26                	sw	s1,20(sp)
    2dce:	c84a                	sw	s2,16(sp)
    2dd0:	842a                	mv	s0,a0
    2dd2:	4981                	li	s3,0
    2dd4:	00055563          	bgez	a0,2dde <.L17>
    2dd8:	40a00433          	neg	s0,a0
    2ddc:	4985                	li	s3,1

00002dde <.L17>:
    2dde:	6601a503          	lw	a0,1632(gp) # f04 <.Lmerged_single+0x4>
    2de2:	42818493          	add	s1,gp,1064 # ccc <__SEGGER_RTL_aPower2f>

00002de6 <.L18>:
    2de6:	ec19                	bnez	s0,2e04 <.L20>
    2de8:	00098763          	beqz	s3,2df6 <.L16>
    2dec:	85aa                	mv	a1,a0
    2dee:	6601a503          	lw	a0,1632(gp) # f04 <.Lmerged_single+0x4>
    2df2:	522010ef          	jal	4314 <__divsf3>

00002df6 <.L16>:
    2df6:	40f2                	lw	ra,28(sp)
    2df8:	4462                	lw	s0,24(sp)
    2dfa:	44d2                	lw	s1,20(sp)
    2dfc:	4942                	lw	s2,16(sp)
    2dfe:	49b2                	lw	s3,12(sp)
    2e00:	6105                	add	sp,sp,32
    2e02:	8082                	ret

00002e04 <.L20>:
    2e04:	00147793          	and	a5,s0,1
    2e08:	c781                	beqz	a5,2e10 <.L19>
    2e0a:	408c                	lw	a1,0(s1)
    2e0c:	348010ef          	jal	4154 <__mulsf3>

00002e10 <.L19>:
    2e10:	8405                	sra	s0,s0,0x1
    2e12:	0491                	add	s1,s1,4
    2e14:	bfc9                	j	2de6 <.L18>

Disassembly of section .text.libc.__SEGGER_RTL_prin_flush:

00002e16 <__SEGGER_RTL_prin_flush>:
    2e16:	4950                	lw	a2,20(a0)
    2e18:	ce19                	beqz	a2,2e36 <.L20>
    2e1a:	511c                	lw	a5,32(a0)
    2e1c:	1141                	add	sp,sp,-16
    2e1e:	c422                	sw	s0,8(sp)
    2e20:	c606                	sw	ra,12(sp)
    2e22:	842a                	mv	s0,a0
    2e24:	c399                	beqz	a5,2e2a <.L12>
    2e26:	490c                	lw	a1,16(a0)
    2e28:	9782                	jalr	a5

00002e2a <.L12>:
    2e2a:	40b2                	lw	ra,12(sp)
    2e2c:	00042a23          	sw	zero,20(s0)
    2e30:	4422                	lw	s0,8(sp)
    2e32:	0141                	add	sp,sp,16
    2e34:	8082                	ret

00002e36 <.L20>:
    2e36:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pre_padding:

00002e38 <__SEGGER_RTL_pre_padding>:
    2e38:	0105f793          	and	a5,a1,16
    2e3c:	eb91                	bnez	a5,2e50 <.L40>
    2e3e:	2005f793          	and	a5,a1,512
    2e42:	02000593          	li	a1,32
    2e46:	c399                	beqz	a5,2e4c <.L42>
    2e48:	03000593          	li	a1,48

00002e4c <.L42>:
    2e4c:	4050106f          	j	4a50 <__SEGGER_RTL_print_padding>

00002e50 <.L40>:
    2e50:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_init_prin_l:

00002e52 <__SEGGER_RTL_init_prin_l>:
    2e52:	1141                	add	sp,sp,-16
    2e54:	c226                	sw	s1,4(sp)
    2e56:	02400613          	li	a2,36
    2e5a:	84ae                	mv	s1,a1
    2e5c:	4581                	li	a1,0
    2e5e:	c422                	sw	s0,8(sp)
    2e60:	c606                	sw	ra,12(sp)
    2e62:	842a                	mv	s0,a0
    2e64:	1dd010ef          	jal	4840 <memset>
    2e68:	40b2                	lw	ra,12(sp)
    2e6a:	cc44                	sw	s1,28(s0)
    2e6c:	4422                	lw	s0,8(sp)
    2e6e:	4492                	lw	s1,4(sp)
    2e70:	0141                	add	sp,sp,16
    2e72:	8082                	ret

Disassembly of section .text.libc.vfprintf:

00002e74 <vfprintf>:
    2e74:	1101                	add	sp,sp,-32
    2e76:	cc22                	sw	s0,24(sp)
    2e78:	ca26                	sw	s1,20(sp)
    2e7a:	ce06                	sw	ra,28(sp)
    2e7c:	84ae                	mv	s1,a1
    2e7e:	842a                	mv	s0,a0
    2e80:	c632                	sw	a2,12(sp)
    2e82:	13f020ef          	jal	57c0 <__SEGGER_RTL_current_locale>
    2e86:	85aa                	mv	a1,a0
    2e88:	8522                	mv	a0,s0
    2e8a:	4462                	lw	s0,24(sp)
    2e8c:	46b2                	lw	a3,12(sp)
    2e8e:	40f2                	lw	ra,28(sp)
    2e90:	8626                	mv	a2,s1
    2e92:	44d2                	lw	s1,20(sp)
    2e94:	6105                	add	sp,sp,32
    2e96:	3e50106f          	j	4a7a <vfprintf_l>

Disassembly of section .text.libc.printf:

00002e9a <printf>:
    2e9a:	7139                	add	sp,sp,-64
    2e9c:	da3e                	sw	a5,52(sp)
    2e9e:	d22e                	sw	a1,36(sp)
    2ea0:	85aa                	mv	a1,a0
    2ea2:	84822503          	lw	a0,-1976(tp) # fffff848 <__SHARE_RAM_segment_end__+0xfee7f848>
    2ea6:	d432                	sw	a2,40(sp)
    2ea8:	1050                	add	a2,sp,36
    2eaa:	ce06                	sw	ra,28(sp)
    2eac:	d636                	sw	a3,44(sp)
    2eae:	d83a                	sw	a4,48(sp)
    2eb0:	dc42                	sw	a6,56(sp)
    2eb2:	de46                	sw	a7,60(sp)
    2eb4:	c632                	sw	a2,12(sp)
    2eb6:	3f7d                	jal	2e74 <vfprintf>
    2eb8:	40f2                	lw	ra,28(sp)
    2eba:	6121                	add	sp,sp,64
    2ebc:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_heap:

00002ebe <__SEGGER_init_heap>:
    2ebe:	00080537          	lui	a0,0x80
    2ec2:	00050513          	mv	a0,a0
    2ec6:	000845b7          	lui	a1,0x84
    2eca:	00058593          	mv	a1,a1
    2ece:	8d89                	sub	a1,a1,a0
    2ed0:	a009                	j	2ed2 <__SEGGER_RTL_init_heap>

Disassembly of section .text.libc.__SEGGER_RTL_init_heap:

00002ed2 <__SEGGER_RTL_init_heap>:
    2ed2:	479d                	li	a5,7
    2ed4:	00b7f763          	bgeu	a5,a1,2ee2 <.L68>
    2ed8:	84a22023          	sw	a0,-1984(tp) # fffff840 <__SHARE_RAM_segment_end__+0xfee7f840>
    2edc:	00052023          	sw	zero,0(a0) # 80000 <__DLM_segment_start__>
    2ee0:	c14c                	sw	a1,4(a0)

00002ee2 <.L68>:
    2ee2:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_toupper:

00002ee4 <__SEGGER_RTL_ascii_toupper>:
    2ee4:	f9f50713          	add	a4,a0,-97
    2ee8:	47e5                	li	a5,25
    2eea:	00e7e363          	bltu	a5,a4,2ef0 <.L5>
    2eee:	1501                	add	a0,a0,-32

00002ef0 <.L5>:
    2ef0:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towupper:

00002ef2 <__SEGGER_RTL_ascii_towupper>:
    2ef2:	f9f50713          	add	a4,a0,-97
    2ef6:	47e5                	li	a5,25
    2ef8:	00e7e363          	bltu	a5,a4,2efe <.L12>
    2efc:	1501                	add	a0,a0,-32

00002efe <.L12>:
    2efe:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_mbtowc:

00002f00 <__SEGGER_RTL_ascii_mbtowc>:
    2f00:	87aa                	mv	a5,a0
    2f02:	4501                	li	a0,0
    2f04:	c195                	beqz	a1,2f28 <.L55>
    2f06:	c20d                	beqz	a2,2f28 <.L55>
    2f08:	0005c703          	lbu	a4,0(a1) # 84000 <__heap_end__>
    2f0c:	07f00613          	li	a2,127
    2f10:	5579                	li	a0,-2
    2f12:	00e66b63          	bltu	a2,a4,2f28 <.L55>
    2f16:	c391                	beqz	a5,2f1a <.L57>
    2f18:	c398                	sw	a4,0(a5)

00002f1a <.L57>:
    2f1a:	0006a023          	sw	zero,0(a3)
    2f1e:	0006a223          	sw	zero,4(a3)
    2f22:	00e03533          	snez	a0,a4
    2f26:	8082                	ret

00002f28 <.L55>:
    2f28:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate_all:

00002f2a <l1c_dc_invalidate_all>:
{
    2f2a:	1141                	add	sp,sp,-16
    2f2c:	47dd                	li	a5,23
    2f2e:	00f107a3          	sb	a5,15(sp)

00002f32 <.LBB68>:
}

/* send command */
ATTR_ALWAYS_INLINE static inline void l1c_cctl_cmd(uint8_t cmd)
{
    write_csr(CSR_MCCTLCOMMAND, cmd);
    2f32:	00f14783          	lbu	a5,15(sp)
    2f36:	7cc79073          	csrw	0x7cc,a5
}
    2f3a:	0001                	nop

00002f3c <.LBE68>:
}
    2f3c:	0001                	nop
    2f3e:	0141                	add	sp,sp,16
    2f40:	8082                	ret

Disassembly of section .text.gptmr_check_status:

00002f42 <gptmr_check_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline bool gptmr_check_status(GPTMR_Type *ptr, uint32_t mask)
{
    2f42:	1141                	add	sp,sp,-16
    2f44:	c62a                	sw	a0,12(sp)
    2f46:	c42e                	sw	a1,8(sp)
    return (ptr->SR & mask) == mask;
    2f48:	47b2                	lw	a5,12(sp)
    2f4a:	2007a703          	lw	a4,512(a5)
    2f4e:	47a2                	lw	a5,8(sp)
    2f50:	8ff9                	and	a5,a5,a4
    2f52:	4722                	lw	a4,8(sp)
    2f54:	40f707b3          	sub	a5,a4,a5
    2f58:	0017b793          	seqz	a5,a5
    2f5c:	0ff7f793          	zext.b	a5,a5
}
    2f60:	853e                	mv	a0,a5
    2f62:	0141                	add	sp,sp,16
    2f64:	8082                	ret

Disassembly of section .text.gptmr_clear_status:

00002f66 <gptmr_clear_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline void gptmr_clear_status(GPTMR_Type *ptr, uint32_t mask)
{
    2f66:	1141                	add	sp,sp,-16
    2f68:	c62a                	sw	a0,12(sp)
    2f6a:	c42e                	sw	a1,8(sp)
    ptr->SR = mask;
    2f6c:	47b2                	lw	a5,12(sp)
    2f6e:	4722                	lw	a4,8(sp)
    2f70:	20e7a023          	sw	a4,512(a5)
}
    2f74:	0001                	nop
    2f76:	0141                	add	sp,sp,16
    2f78:	8082                	ret

Disassembly of section .text.board_init_console:

00002f7a <board_init_console>:
{
    2f7a:	1101                	add	sp,sp,-32
    2f7c:	ce06                	sw	ra,28(sp)
    init_uart_pins((UART_Type *) BOARD_CONSOLE_UART_BASE);
    2f7e:	f0074537          	lui	a0,0xf0074
    2f82:	28a9                	jal	2fdc <init_uart_pins>
    clock_add_to_group(BOARD_CONSOLE_UART_CLK_NAME, 0);
    2f84:	4581                	li	a1,0
    2f86:	012f07b7          	lui	a5,0x12f0
    2f8a:	02078513          	add	a0,a5,32 # 12f0020 <__SHARE_RAM_segment_end__+0x170020>
    2f8e:	ef3fe0ef          	jal	1e80 <clock_add_to_group>
    cfg.type = BOARD_CONSOLE_TYPE;
    2f92:	c002                	sw	zero,0(sp)
    cfg.base = (uint32_t) BOARD_CONSOLE_UART_BASE;
    2f94:	f00747b7          	lui	a5,0xf0074
    2f98:	c23e                	sw	a5,4(sp)
    cfg.src_freq_in_hz = clock_get_frequency(BOARD_CONSOLE_UART_CLK_NAME);
    2f9a:	012f07b7          	lui	a5,0x12f0
    2f9e:	02078513          	add	a0,a5,32 # 12f0020 <__SHARE_RAM_segment_end__+0x170020>
    2fa2:	dadfe0ef          	jal	1d4e <clock_get_frequency>
    2fa6:	87aa                	mv	a5,a0
    2fa8:	c43e                	sw	a5,8(sp)
    cfg.baudrate = BOARD_CONSOLE_UART_BAUDRATE;
    2faa:	67f1                	lui	a5,0x1c
    2fac:	20078793          	add	a5,a5,512 # 1c200 <__NONCACHEABLE_RAM_segment_size__+0xc200>
    2fb0:	c63e                	sw	a5,12(sp)
    if (status_success != console_init(&cfg)) {
    2fb2:	878a                	mv	a5,sp
    2fb4:	853e                	mv	a0,a5
    2fb6:	228d                	jal	3118 <console_init>
    2fb8:	87aa                	mv	a5,a0
    2fba:	c391                	beqz	a5,2fbe <.L74>

00002fbc <.L73>:
        while (1) {
    2fbc:	a001                	j	2fbc <.L73>

00002fbe <.L74>:
}
    2fbe:	0001                	nop
    2fc0:	40f2                	lw	ra,28(sp)
    2fc2:	6105                	add	sp,sp,32
    2fc4:	8082                	ret

Disassembly of section .text.board_init_core1:

00002fc6 <board_init_core1>:
{
    2fc6:	1141                	add	sp,sp,-16
    2fc8:	c606                	sw	ra,12(sp)
    clock_update_core_clock();
    2fca:	ef1fe0ef          	jal	1eba <clock_update_core_clock>
    board_init_console();
    2fce:	3775                	jal	2f7a <board_init_console>
    board_init_pmp();
    2fd0:	cccfe0ef          	jal	149c <board_init_pmp>
}
    2fd4:	0001                	nop
    2fd6:	40b2                	lw	ra,12(sp)
    2fd8:	0141                	add	sp,sp,16
    2fda:	8082                	ret

Disassembly of section .text.init_uart_pins:

00002fdc <init_uart_pins>:
 */

#include "board.h"

void init_uart_pins(UART_Type *ptr)
{
    2fdc:	1141                	add	sp,sp,-16
    2fde:	c62a                	sw	a0,12(sp)
    if (ptr == HPM_UART0) {
    2fe0:	4732                	lw	a4,12(sp)
    2fe2:	f00407b7          	lui	a5,0xf0040
    2fe6:	02f71f63          	bne	a4,a5,3024 <.L4>
        HPM_IOC->PAD[IOC_PAD_PY07].FUNC_CTL = IOC_PY07_FUNC_CTL_UART0_RXD;
    2fea:	f4040737          	lui	a4,0xf4040
    2fee:	6785                	lui	a5,0x1
    2ff0:	97ba                	add	a5,a5,a4
    2ff2:	4709                	li	a4,2
    2ff4:	e2e7ac23          	sw	a4,-456(a5) # e38 <__SEGGER_RTL_c_locale_data+0x30>
        HPM_IOC->PAD[IOC_PAD_PY06].FUNC_CTL = IOC_PY06_FUNC_CTL_UART0_TXD;
    2ff8:	f4040737          	lui	a4,0xf4040
    2ffc:	6785                	lui	a5,0x1
    2ffe:	97ba                	add	a5,a5,a4
    3000:	4709                	li	a4,2
    3002:	e2e7a823          	sw	a4,-464(a5) # e30 <__SEGGER_RTL_c_locale_data+0x28>
        /* PY port IO needs to configure PIOC as well */
        HPM_PIOC->PAD[IOC_PAD_PY07].FUNC_CTL = PIOC_PY07_FUNC_CTL_SOC_PY_07;
    3006:	f40d8737          	lui	a4,0xf40d8
    300a:	6785                	lui	a5,0x1
    300c:	97ba                	add	a5,a5,a4
    300e:	470d                	li	a4,3
    3010:	e2e7ac23          	sw	a4,-456(a5) # e38 <__SEGGER_RTL_c_locale_data+0x30>
        HPM_PIOC->PAD[IOC_PAD_PY06].FUNC_CTL = PIOC_PY06_FUNC_CTL_SOC_PY_06;
    3014:	f40d8737          	lui	a4,0xf40d8
    3018:	6785                	lui	a5,0x1
    301a:	97ba                	add	a5,a5,a4
    301c:	470d                	li	a4,3
    301e:	e2e7a823          	sw	a4,-464(a5) # e30 <__SEGGER_RTL_c_locale_data+0x28>
        HPM_BIOC->PAD[IOC_PAD_PZ11].FUNC_CTL = BIOC_PZ11_FUNC_CTL_SOC_PZ_11;
    } else if (ptr == HPM_PUART) {
        HPM_PIOC->PAD[IOC_PAD_PY07].FUNC_CTL = PIOC_PY07_FUNC_CTL_PUART_RXD;
        HPM_PIOC->PAD[IOC_PAD_PY06].FUNC_CTL = PIOC_PY06_FUNC_CTL_PUART_TXD;
    }
}
    3022:	a8c5                	j	3112 <.L10>

00003024 <.L4>:
    } else if (ptr == HPM_UART6) {
    3024:	4732                	lw	a4,12(sp)
    3026:	f00587b7          	lui	a5,0xf0058
    302a:	00f71d63          	bne	a4,a5,3044 <.L6>
        HPM_IOC->PAD[IOC_PAD_PE27].FUNC_CTL = IOC_PE27_FUNC_CTL_UART6_RXD;
    302e:	f40407b7          	lui	a5,0xf4040
    3032:	4709                	li	a4,2
    3034:	4ce7ac23          	sw	a4,1240(a5) # f40404d8 <__SHARE_RAM_segment_end__+0xf2ec04d8>
        HPM_IOC->PAD[IOC_PAD_PE28].FUNC_CTL = IOC_PE28_FUNC_CTL_UART6_TXD;
    3038:	f40407b7          	lui	a5,0xf4040
    303c:	4709                	li	a4,2
    303e:	4ee7a023          	sw	a4,1248(a5) # f40404e0 <__SHARE_RAM_segment_end__+0xf2ec04e0>
}
    3042:	a8c1                	j	3112 <.L10>

00003044 <.L6>:
    } else if (ptr == HPM_UART7) {
    3044:	4732                	lw	a4,12(sp)
    3046:	f005c7b7          	lui	a5,0xf005c
    304a:	00f71d63          	bne	a4,a5,3064 <.L7>
        HPM_IOC->PAD[IOC_PAD_PC02].FUNC_CTL = IOC_PC02_FUNC_CTL_UART7_RXD;
    304e:	f40407b7          	lui	a5,0xf4040
    3052:	4709                	li	a4,2
    3054:	20e7a823          	sw	a4,528(a5) # f4040210 <__SHARE_RAM_segment_end__+0xf2ec0210>
        HPM_IOC->PAD[IOC_PAD_PC03].FUNC_CTL = IOC_PC03_FUNC_CTL_UART7_TXD;
    3058:	f40407b7          	lui	a5,0xf4040
    305c:	4709                	li	a4,2
    305e:	20e7ac23          	sw	a4,536(a5) # f4040218 <__SHARE_RAM_segment_end__+0xf2ec0218>
}
    3062:	a845                	j	3112 <.L10>

00003064 <.L7>:
    } else if (ptr == HPM_UART13) {
    3064:	4732                	lw	a4,12(sp)
    3066:	f00747b7          	lui	a5,0xf0074
    306a:	02f71f63          	bne	a4,a5,30a8 <.L8>
        HPM_IOC->PAD[IOC_PAD_PZ08].FUNC_CTL = IOC_PZ08_FUNC_CTL_UART13_RXD;
    306e:	f4040737          	lui	a4,0xf4040
    3072:	6785                	lui	a5,0x1
    3074:	97ba                	add	a5,a5,a4
    3076:	4709                	li	a4,2
    3078:	f4e7a023          	sw	a4,-192(a5) # f40 <.LC1+0x4>
        HPM_IOC->PAD[IOC_PAD_PZ09].FUNC_CTL = IOC_PZ09_FUNC_CTL_UART13_TXD;
    307c:	f4040737          	lui	a4,0xf4040
    3080:	6785                	lui	a5,0x1
    3082:	97ba                	add	a5,a5,a4
    3084:	4709                	li	a4,2
    3086:	f4e7a423          	sw	a4,-184(a5) # f48 <.LC1+0xc>
        HPM_BIOC->PAD[IOC_PAD_PZ08].FUNC_CTL = BIOC_PZ08_FUNC_CTL_SOC_PZ_08;
    308a:	f5010737          	lui	a4,0xf5010
    308e:	6785                	lui	a5,0x1
    3090:	97ba                	add	a5,a5,a4
    3092:	470d                	li	a4,3
    3094:	f4e7a023          	sw	a4,-192(a5) # f40 <.LC1+0x4>
        HPM_BIOC->PAD[IOC_PAD_PZ09].FUNC_CTL = BIOC_PZ09_FUNC_CTL_SOC_PZ_09;
    3098:	f5010737          	lui	a4,0xf5010
    309c:	6785                	lui	a5,0x1
    309e:	97ba                	add	a5,a5,a4
    30a0:	470d                	li	a4,3
    30a2:	f4e7a423          	sw	a4,-184(a5) # f48 <.LC1+0xc>
}
    30a6:	a0b5                	j	3112 <.L10>

000030a8 <.L8>:
    } else if (ptr == HPM_UART14) {
    30a8:	4732                	lw	a4,12(sp)
    30aa:	f00787b7          	lui	a5,0xf0078
    30ae:	02f71f63          	bne	a4,a5,30ec <.L9>
        HPM_IOC->PAD[IOC_PAD_PZ10].FUNC_CTL = IOC_PZ10_FUNC_CTL_UART14_RXD;
    30b2:	f4040737          	lui	a4,0xf4040
    30b6:	6785                	lui	a5,0x1
    30b8:	97ba                	add	a5,a5,a4
    30ba:	4709                	li	a4,2
    30bc:	f4e7a823          	sw	a4,-176(a5) # f50 <.LC1+0x14>
        HPM_IOC->PAD[IOC_PAD_PZ11].FUNC_CTL = IOC_PZ11_FUNC_CTL_UART14_TXD;
    30c0:	f4040737          	lui	a4,0xf4040
    30c4:	6785                	lui	a5,0x1
    30c6:	97ba                	add	a5,a5,a4
    30c8:	4709                	li	a4,2
    30ca:	f4e7ac23          	sw	a4,-168(a5) # f58 <.LC1+0x1c>
        HPM_BIOC->PAD[IOC_PAD_PZ10].FUNC_CTL = BIOC_PZ10_FUNC_CTL_SOC_PZ_10;
    30ce:	f5010737          	lui	a4,0xf5010
    30d2:	6785                	lui	a5,0x1
    30d4:	97ba                	add	a5,a5,a4
    30d6:	470d                	li	a4,3
    30d8:	f4e7a823          	sw	a4,-176(a5) # f50 <.LC1+0x14>
        HPM_BIOC->PAD[IOC_PAD_PZ11].FUNC_CTL = BIOC_PZ11_FUNC_CTL_SOC_PZ_11;
    30dc:	f5010737          	lui	a4,0xf5010
    30e0:	6785                	lui	a5,0x1
    30e2:	97ba                	add	a5,a5,a4
    30e4:	470d                	li	a4,3
    30e6:	f4e7ac23          	sw	a4,-168(a5) # f58 <.LC1+0x1c>
}
    30ea:	a025                	j	3112 <.L10>

000030ec <.L9>:
    } else if (ptr == HPM_PUART) {
    30ec:	4732                	lw	a4,12(sp)
    30ee:	f40e47b7          	lui	a5,0xf40e4
    30f2:	02f71063          	bne	a4,a5,3112 <.L10>
        HPM_PIOC->PAD[IOC_PAD_PY07].FUNC_CTL = PIOC_PY07_FUNC_CTL_PUART_RXD;
    30f6:	f40d8737          	lui	a4,0xf40d8
    30fa:	6785                	lui	a5,0x1
    30fc:	97ba                	add	a5,a5,a4
    30fe:	4705                	li	a4,1
    3100:	e2e7ac23          	sw	a4,-456(a5) # e38 <__SEGGER_RTL_c_locale_data+0x30>
        HPM_PIOC->PAD[IOC_PAD_PY06].FUNC_CTL = PIOC_PY06_FUNC_CTL_PUART_TXD;
    3104:	f40d8737          	lui	a4,0xf40d8
    3108:	6785                	lui	a5,0x1
    310a:	97ba                	add	a5,a5,a4
    310c:	4705                	li	a4,1
    310e:	e2e7a823          	sw	a4,-464(a5) # e30 <__SEGGER_RTL_c_locale_data+0x28>

00003112 <.L10>:
}
    3112:	0001                	nop
    3114:	0141                	add	sp,sp,16
    3116:	8082                	ret

Disassembly of section .text.console_init:

00003118 <console_init>:
#include "hpm_uart_drv.h"

static UART_Type* g_console_uart = NULL;

hpm_stat_t console_init(console_config_t *cfg)
{
    3118:	7139                	add	sp,sp,-64
    311a:	de06                	sw	ra,60(sp)
    311c:	c62a                	sw	a0,12(sp)
    hpm_stat_t stat = status_fail;
    311e:	4785                	li	a5,1
    3120:	d63e                	sw	a5,44(sp)

    if (cfg->type == CONSOLE_TYPE_UART) {
    3122:	47b2                	lw	a5,12(sp)
    3124:	439c                	lw	a5,0(a5)
    3126:	e3b9                	bnez	a5,316c <.L2>

00003128 <.LBB2>:
        uart_config_t config = {0};
    3128:	cc02                	sw	zero,24(sp)
    312a:	ce02                	sw	zero,28(sp)
    312c:	d002                	sw	zero,32(sp)
    312e:	d202                	sw	zero,36(sp)
    3130:	d402                	sw	zero,40(sp)
        uart_default_config((UART_Type *)cfg->base, &config);
    3132:	47b2                	lw	a5,12(sp)
    3134:	43dc                	lw	a5,4(a5)
    3136:	873e                	mv	a4,a5
    3138:	083c                	add	a5,sp,24
    313a:	85be                	mv	a1,a5
    313c:	853a                	mv	a0,a4
    313e:	931fe0ef          	jal	1a6e <uart_default_config>
        config.src_freq_in_hz = cfg->src_freq_in_hz;
    3142:	47b2                	lw	a5,12(sp)
    3144:	479c                	lw	a5,8(a5)
    3146:	cc3e                	sw	a5,24(sp)
        config.baudrate = cfg->baudrate;
    3148:	47b2                	lw	a5,12(sp)
    314a:	47dc                	lw	a5,12(a5)
    314c:	ce3e                	sw	a5,28(sp)
        stat = uart_init((UART_Type *)cfg->base, &config);
    314e:	47b2                	lw	a5,12(sp)
    3150:	43dc                	lw	a5,4(a5)
    3152:	873e                	mv	a4,a5
    3154:	083c                	add	a5,sp,24
    3156:	85be                	mv	a1,a5
    3158:	853a                	mv	a0,a4
    315a:	2b69                	jal	36f4 <uart_init>
    315c:	d62a                	sw	a0,44(sp)
        if (status_success == stat) {
    315e:	57b2                	lw	a5,44(sp)
    3160:	e791                	bnez	a5,316c <.L2>
            g_console_uart = (UART_Type *)cfg->base;
    3162:	47b2                	lw	a5,12(sp)
    3164:	43dc                	lw	a5,4(a5)
    3166:	873e                	mv	a4,a5
    3168:	82e22a23          	sw	a4,-1996(tp) # fffff834 <__SHARE_RAM_segment_end__+0xfee7f834>

0000316c <.L2>:
        }
    }

    return stat;
    316c:	57b2                	lw	a5,44(sp)
}
    316e:	853e                	mv	a0,a5
    3170:	50f2                	lw	ra,60(sp)
    3172:	6121                	add	sp,sp,64
    3174:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_write:

00003176 <__SEGGER_RTL_X_file_write>:
__attribute__((used)) FILE *stdin  = &__SEGGER_RTL_stdin_file;  /* NOTE: Provide implementation of stdin for RTL. */
__attribute__((used)) FILE *stdout = &__SEGGER_RTL_stdout_file; /* NOTE: Provide implementation of stdout for RTL. */
__attribute__((used)) FILE *stderr = &__SEGGER_RTL_stderr_file; /* NOTE: Provide implementation of stderr for RTL. */

__attribute__((used)) int __SEGGER_RTL_X_file_write(__SEGGER_RTL_FILE *file, const char *data, unsigned int size)
{
    3176:	7179                	add	sp,sp,-48
    3178:	d606                	sw	ra,44(sp)
    317a:	c62a                	sw	a0,12(sp)
    317c:	c42e                	sw	a1,8(sp)
    317e:	c232                	sw	a2,4(sp)
    unsigned int count;
    (void)file;
    for (count = 0; count < size; count++) {
    3180:	ce02                	sw	zero,28(sp)
    3182:	a099                	j	31c8 <.L13>

00003184 <.L17>:
        if (data[count] == '\n') {
    3184:	4722                	lw	a4,8(sp)
    3186:	47f2                	lw	a5,28(sp)
    3188:	97ba                	add	a5,a5,a4
    318a:	0007c703          	lbu	a4,0(a5)
    318e:	47a9                	li	a5,10
    3190:	00f71b63          	bne	a4,a5,31a6 <.L20>
            while (status_success != uart_send_byte(g_console_uart, '\r')) {
    3194:	0001                	nop

00003196 <.L15>:
    3196:	83422783          	lw	a5,-1996(tp) # fffff834 <__SHARE_RAM_segment_end__+0xfee7f834>
    319a:	45b5                	li	a1,13
    319c:	853e                	mv	a0,a5
    319e:	931fe0ef          	jal	1ace <uart_send_byte>
    31a2:	87aa                	mv	a5,a0
    31a4:	fbed                	bnez	a5,3196 <.L15>

000031a6 <.L20>:
            }
        }
        while (status_success != uart_send_byte(g_console_uart, data[count])) {
    31a6:	0001                	nop

000031a8 <.L16>:
    31a8:	83422683          	lw	a3,-1996(tp) # fffff834 <__SHARE_RAM_segment_end__+0xfee7f834>
    31ac:	4722                	lw	a4,8(sp)
    31ae:	47f2                	lw	a5,28(sp)
    31b0:	97ba                	add	a5,a5,a4
    31b2:	0007c783          	lbu	a5,0(a5)
    31b6:	85be                	mv	a1,a5
    31b8:	8536                	mv	a0,a3
    31ba:	915fe0ef          	jal	1ace <uart_send_byte>
    31be:	87aa                	mv	a5,a0
    31c0:	f7e5                	bnez	a5,31a8 <.L16>
    for (count = 0; count < size; count++) {
    31c2:	47f2                	lw	a5,28(sp)
    31c4:	0785                	add	a5,a5,1
    31c6:	ce3e                	sw	a5,28(sp)

000031c8 <.L13>:
    31c8:	4772                	lw	a4,28(sp)
    31ca:	4792                	lw	a5,4(sp)
    31cc:	faf76ce3          	bltu	a4,a5,3184 <.L17>
        }
    }
    while (status_success != uart_flush(g_console_uart)) {
    31d0:	0001                	nop

000031d2 <.L18>:
    31d2:	83422783          	lw	a5,-1996(tp) # fffff834 <__SHARE_RAM_segment_end__+0xfee7f834>
    31d6:	853e                	mv	a0,a5
    31d8:	2d61                	jal	3870 <uart_flush>
    31da:	87aa                	mv	a5,a0
    31dc:	fbfd                	bnez	a5,31d2 <.L18>
    }
    return count;
    31de:	47f2                	lw	a5,28(sp)

}
    31e0:	853e                	mv	a0,a5
    31e2:	50b2                	lw	ra,44(sp)
    31e4:	6145                	add	sp,sp,48
    31e6:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_stat:

000031e8 <__SEGGER_RTL_X_file_stat>:
    }
    return 1;
}

__attribute__((used)) int __SEGGER_RTL_X_file_stat(__SEGGER_RTL_FILE *stream)
{
    31e8:	1141                	add	sp,sp,-16
    31ea:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 0;
    31ec:	4781                	li	a5,0
}
    31ee:	853e                	mv	a0,a5
    31f0:	0141                	add	sp,sp,16
    31f2:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_bufsize:

000031f4 <__SEGGER_RTL_X_file_bufsize>:

__attribute__((used)) int __SEGGER_RTL_X_file_bufsize(__SEGGER_RTL_FILE *stream)
{
    31f4:	1141                	add	sp,sp,-16
    31f6:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 1;
    31f8:	4785                	li	a5,1
}
    31fa:	853e                	mv	a0,a5
    31fc:	0141                	add	sp,sp,16
    31fe:	8082                	ret

Disassembly of section .text.pllctl_get_pll_freq_in_hz:

00003200 <pllctl_get_pll_freq_in_hz>:
    }
    return status_success;
}

uint32_t pllctl_get_pll_freq_in_hz(PLLCTL_Type *ptr, uint8_t pll)
{
    3200:	715d                	add	sp,sp,-80
    3202:	c686                	sw	ra,76(sp)
    3204:	c4a2                	sw	s0,72(sp)
    3206:	c2a6                	sw	s1,68(sp)
    3208:	c0ca                	sw	s2,64(sp)
    320a:	de4e                	sw	s3,60(sp)
    320c:	c62a                	sw	a0,12(sp)
    320e:	87ae                	mv	a5,a1
    3210:	00f105a3          	sb	a5,11(sp)
    if ((ptr == NULL) || (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
    3214:	47b2                	lw	a5,12(sp)
    3216:	c791                	beqz	a5,3222 <.L79>
    3218:	00b14703          	lbu	a4,11(sp)
    321c:	4791                	li	a5,4
    321e:	00e7f463          	bgeu	a5,a4,3226 <.L80>

00003222 <.L79>:
        return status_invalid_argument;
    3222:	4789                	li	a5,2
    3224:	aa35                	j	3360 <.L81>

00003226 <.L80>:
    }
    uint32_t fbdiv, frac, refdiv, postdiv, refclk, freq;
    if (ptr->PLL[pll].CFG1 & PLLCTL_PLL_CFG1_PLLPD_SW_MASK) {
    3226:	00b14783          	lbu	a5,11(sp)
    322a:	4732                	lw	a4,12(sp)
    322c:	0785                	add	a5,a5,1
    322e:	079e                	sll	a5,a5,0x7
    3230:	97ba                	add	a5,a5,a4
    3232:	43d8                	lw	a4,4(a5)
    3234:	020007b7          	lui	a5,0x2000
    3238:	8ff9                	and	a5,a5,a4
    323a:	c399                	beqz	a5,3240 <.L82>
        /* pll is powered down */
        return 0;
    323c:	4781                	li	a5,0
    323e:	a20d                	j	3360 <.L81>

00003240 <.L82>:
    }

    refdiv = PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0);
    3240:	00b14783          	lbu	a5,11(sp)
    3244:	4732                	lw	a4,12(sp)
    3246:	0785                	add	a5,a5,1 # 2000001 <__SHARE_RAM_segment_end__+0xe80001>
    3248:	079e                	sll	a5,a5,0x7
    324a:	97ba                	add	a5,a5,a4
    324c:	439c                	lw	a5,0(a5)
    324e:	83e1                	srl	a5,a5,0x18
    3250:	03f7f793          	and	a5,a5,63
    3254:	d43e                	sw	a5,40(sp)
    postdiv = PLLCTL_PLL_CFG0_POSTDIV1_GET(ptr->PLL[pll].CFG0);
    3256:	00b14783          	lbu	a5,11(sp)
    325a:	4732                	lw	a4,12(sp)
    325c:	0785                	add	a5,a5,1
    325e:	079e                	sll	a5,a5,0x7
    3260:	97ba                	add	a5,a5,a4
    3262:	439c                	lw	a5,0(a5)
    3264:	83d1                	srl	a5,a5,0x14
    3266:	8b9d                	and	a5,a5,7
    3268:	d23e                	sw	a5,36(sp)
    refclk = PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv);
    326a:	5722                	lw	a4,40(sp)
    326c:	5792                	lw	a5,36(sp)
    326e:	02f707b3          	mul	a5,a4,a5
    3272:	016e3737          	lui	a4,0x16e3
    3276:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
    327a:	02f757b3          	divu	a5,a4,a5
    327e:	d03e                	sw	a5,32(sp)

    if (ptr->PLL[pll].CFG0 & PLLCTL_PLL_CFG0_DSMPD_MASK) {
    3280:	00b14783          	lbu	a5,11(sp)
    3284:	4732                	lw	a4,12(sp)
    3286:	0785                	add	a5,a5,1
    3288:	079e                	sll	a5,a5,0x7
    328a:	97ba                	add	a5,a5,a4
    328c:	439c                	lw	a5,0(a5)
    328e:	8ba1                	and	a5,a5,8
    3290:	c395                	beqz	a5,32b4 <.L83>
        /* pll int mode */
        fbdiv = PLLCTL_PLL_CFG2_FBDIV_INT_GET(ptr->PLL[pll].CFG2);
    3292:	00b14783          	lbu	a5,11(sp)
    3296:	4732                	lw	a4,12(sp)
    3298:	0785                	add	a5,a5,1
    329a:	079e                	sll	a5,a5,0x7
    329c:	97ba                	add	a5,a5,a4
    329e:	4798                	lw	a4,8(a5)
    32a0:	6785                	lui	a5,0x1
    32a2:	17fd                	add	a5,a5,-1 # fff <.LC11+0xb>
    32a4:	8ff9                	and	a5,a5,a4
    32a6:	ce3e                	sw	a5,28(sp)
        freq = refclk * fbdiv;
    32a8:	5702                	lw	a4,32(sp)
    32aa:	47f2                	lw	a5,28(sp)
    32ac:	02f707b3          	mul	a5,a4,a5
    32b0:	d63e                	sw	a5,44(sp)
    32b2:	a075                	j	335e <.L84>

000032b4 <.L83>:
    } else {
        /* pll frac mode */
        fbdiv = PLLCTL_PLL_FREQ_FBDIV_FRAC_GET(ptr->PLL[pll].FREQ);
    32b4:	00b14783          	lbu	a5,11(sp)
    32b8:	4732                	lw	a4,12(sp)
    32ba:	0785                	add	a5,a5,1
    32bc:	079e                	sll	a5,a5,0x7
    32be:	97ba                	add	a5,a5,a4
    32c0:	47dc                	lw	a5,12(a5)
    32c2:	0ff7f793          	zext.b	a5,a5
    32c6:	ce3e                	sw	a5,28(sp)
        frac = PLLCTL_PLL_FREQ_FRAC_GET(ptr->PLL[pll].FREQ);
    32c8:	00b14783          	lbu	a5,11(sp)
    32cc:	4732                	lw	a4,12(sp)
    32ce:	0785                	add	a5,a5,1
    32d0:	079e                	sll	a5,a5,0x7
    32d2:	97ba                	add	a5,a5,a4
    32d4:	47dc                	lw	a5,12(a5)
    32d6:	0087d713          	srl	a4,a5,0x8
    32da:	010007b7          	lui	a5,0x1000
    32de:	17fd                	add	a5,a5,-1 # ffffff <_flash_size+0x7fffff>
    32e0:	8ff9                	and	a5,a5,a4
    32e2:	cc3e                	sw	a5,24(sp)
        freq = (uint32_t)((refclk * (fbdiv + ((double) frac / (1 << 24)))) + 0.5);
    32e4:	5502                	lw	a0,32(sp)
    32e6:	37a010ef          	jal	4660 <__floatunsidf>
    32ea:	842a                	mv	s0,a0
    32ec:	84ae                	mv	s1,a1
    32ee:	4572                	lw	a0,28(sp)
    32f0:	370010ef          	jal	4660 <__floatunsidf>
    32f4:	892a                	mv	s2,a0
    32f6:	89ae                	mv	s3,a1
    32f8:	4562                	lw	a0,24(sp)
    32fa:	366010ef          	jal	4660 <__floatunsidf>
    32fe:	872a                	mv	a4,a0
    3300:	87ae                	mv	a5,a1
    3302:	000006b7          	lui	a3,0x0
    3306:	0806a603          	lw	a2,128(a3) # 80 <.LC1>
    330a:	0846a683          	lw	a3,132(a3)
    330e:	853a                	mv	a0,a4
    3310:	85be                	mv	a1,a5
    3312:	102010ef          	jal	4414 <__divdf3>
    3316:	872a                	mv	a4,a0
    3318:	87ae                	mv	a5,a1
    331a:	863a                	mv	a2,a4
    331c:	86be                	mv	a3,a5
    331e:	854a                	mv	a0,s2
    3320:	85ce                	mv	a1,s3
    3322:	35b000ef          	jal	3e7c <__adddf3>
    3326:	872a                	mv	a4,a0
    3328:	87ae                	mv	a5,a1
    332a:	863a                	mv	a2,a4
    332c:	86be                	mv	a3,a5
    332e:	8522                	mv	a0,s0
    3330:	85a6                	mv	a1,s1
    3332:	6d3000ef          	jal	4204 <__muldf3>
    3336:	872a                	mv	a4,a0
    3338:	87ae                	mv	a5,a1
    333a:	853a                	mv	a0,a4
    333c:	85be                	mv	a1,a5
    333e:	000007b7          	lui	a5,0x0
    3342:	0887a603          	lw	a2,136(a5) # 88 <.LC2>
    3346:	08c7a683          	lw	a3,140(a5)
    334a:	333000ef          	jal	3e7c <__adddf3>
    334e:	872a                	mv	a4,a0
    3350:	87ae                	mv	a5,a1
    3352:	853a                	mv	a0,a4
    3354:	85be                	mv	a1,a5
    3356:	f7ffe0ef          	jal	22d4 <__fixunsdfsi>
    335a:	87aa                	mv	a5,a0
    335c:	d63e                	sw	a5,44(sp)

0000335e <.L84>:
    }
    return freq;
    335e:	57b2                	lw	a5,44(sp)

00003360 <.L81>:
}
    3360:	853e                	mv	a0,a5
    3362:	40b6                	lw	ra,76(sp)
    3364:	4426                	lw	s0,72(sp)
    3366:	4496                	lw	s1,68(sp)
    3368:	4906                	lw	s2,64(sp)
    336a:	59f2                	lw	s3,60(sp)
    336c:	6161                	add	sp,sp,80
    336e:	8082                	ret

Disassembly of section .text.write_pmp_cfg:

00003370 <write_pmp_cfg>:
{
    3370:	1141                	add	sp,sp,-16
    3372:	c62a                	sw	a0,12(sp)
    3374:	c42e                	sw	a1,8(sp)
    switch (idx) {
    3376:	4722                	lw	a4,8(sp)
    3378:	478d                	li	a5,3
    337a:	04f70163          	beq	a4,a5,33bc <.L11>
    337e:	4722                	lw	a4,8(sp)
    3380:	478d                	li	a5,3
    3382:	04e7e163          	bltu	a5,a4,33c4 <.L17>
    3386:	4722                	lw	a4,8(sp)
    3388:	4789                	li	a5,2
    338a:	02f70563          	beq	a4,a5,33b4 <.L13>
    338e:	4722                	lw	a4,8(sp)
    3390:	4789                	li	a5,2
    3392:	02e7e963          	bltu	a5,a4,33c4 <.L17>
    3396:	47a2                	lw	a5,8(sp)
    3398:	c791                	beqz	a5,33a4 <.L14>
    339a:	4722                	lw	a4,8(sp)
    339c:	4785                	li	a5,1
    339e:	00f70763          	beq	a4,a5,33ac <.L15>
        break;
    33a2:	a00d                	j	33c4 <.L17>

000033a4 <.L14>:
        write_csr(CSR_PMPCFG0, value);
    33a4:	47b2                	lw	a5,12(sp)
    33a6:	3a079073          	csrw	pmpcfg0,a5
        break;
    33aa:	a831                	j	33c6 <.L16>

000033ac <.L15>:
        write_csr(CSR_PMPCFG1, value);
    33ac:	47b2                	lw	a5,12(sp)
    33ae:	3a179073          	csrw	pmpcfg1,a5
        break;
    33b2:	a811                	j	33c6 <.L16>

000033b4 <.L13>:
        write_csr(CSR_PMPCFG2, value);
    33b4:	47b2                	lw	a5,12(sp)
    33b6:	3a279073          	csrw	pmpcfg2,a5
        break;
    33ba:	a031                	j	33c6 <.L16>

000033bc <.L11>:
        write_csr(CSR_PMPCFG3, value);
    33bc:	47b2                	lw	a5,12(sp)
    33be:	3a379073          	csrw	pmpcfg3,a5
        break;
    33c2:	a011                	j	33c6 <.L16>

000033c4 <.L17>:
        break;
    33c4:	0001                	nop

000033c6 <.L16>:
}
    33c6:	0001                	nop
    33c8:	0141                	add	sp,sp,16
    33ca:	8082                	ret

Disassembly of section .text.write_pma_cfg:

000033cc <write_pma_cfg>:
{
    33cc:	1141                	add	sp,sp,-16
    33ce:	c62a                	sw	a0,12(sp)
    33d0:	c42e                	sw	a1,8(sp)
    switch (idx) {
    33d2:	4722                	lw	a4,8(sp)
    33d4:	478d                	li	a5,3
    33d6:	04f70163          	beq	a4,a5,3418 <.L81>
    33da:	4722                	lw	a4,8(sp)
    33dc:	478d                	li	a5,3
    33de:	04e7e163          	bltu	a5,a4,3420 <.L87>
    33e2:	4722                	lw	a4,8(sp)
    33e4:	4789                	li	a5,2
    33e6:	02f70563          	beq	a4,a5,3410 <.L83>
    33ea:	4722                	lw	a4,8(sp)
    33ec:	4789                	li	a5,2
    33ee:	02e7e963          	bltu	a5,a4,3420 <.L87>
    33f2:	47a2                	lw	a5,8(sp)
    33f4:	c791                	beqz	a5,3400 <.L84>
    33f6:	4722                	lw	a4,8(sp)
    33f8:	4785                	li	a5,1
    33fa:	00f70763          	beq	a4,a5,3408 <.L85>
        break;
    33fe:	a00d                	j	3420 <.L87>

00003400 <.L84>:
        write_csr(CSR_PMACFG0, value);
    3400:	47b2                	lw	a5,12(sp)
    3402:	bc079073          	csrw	0xbc0,a5
        break;
    3406:	a831                	j	3422 <.L86>

00003408 <.L85>:
        write_csr(CSR_PMACFG1, value);
    3408:	47b2                	lw	a5,12(sp)
    340a:	bc179073          	csrw	0xbc1,a5
        break;
    340e:	a811                	j	3422 <.L86>

00003410 <.L83>:
        write_csr(CSR_PMACFG2, value);
    3410:	47b2                	lw	a5,12(sp)
    3412:	bc279073          	csrw	0xbc2,a5
        break;
    3416:	a031                	j	3422 <.L86>

00003418 <.L81>:
        write_csr(CSR_PMACFG3, value);
    3418:	47b2                	lw	a5,12(sp)
    341a:	bc379073          	csrw	0xbc3,a5
        break;
    341e:	a011                	j	3422 <.L86>

00003420 <.L87>:
        break;
    3420:	0001                	nop

00003422 <.L86>:
}
    3422:	0001                	nop
    3424:	0141                	add	sp,sp,16
    3426:	8082                	ret

Disassembly of section .text.uart_modem_config:

00003428 <uart_modem_config>:
 *
 * @param [in] ptr UART base address
 * @param config Pointer to modem config struct
 */
static inline void uart_modem_config(UART_Type *ptr, uart_modem_config_t *config)
{
    3428:	1141                	add	sp,sp,-16
    342a:	c62a                	sw	a0,12(sp)
    342c:	c42e                	sw	a1,8(sp)
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
    342e:	47a2                	lw	a5,8(sp)
    3430:	0007c783          	lbu	a5,0(a5)
    3434:	0796                	sll	a5,a5,0x5
    3436:	0207f713          	and	a4,a5,32
        | UART_MCR_LOOP_SET(config->loop_back_en)
    343a:	47a2                	lw	a5,8(sp)
    343c:	0017c783          	lbu	a5,1(a5)
    3440:	0792                	sll	a5,a5,0x4
    3442:	8bc1                	and	a5,a5,16
    3444:	8f5d                	or	a4,a4,a5
        | UART_MCR_RTS_SET(!config->set_rts_high);
    3446:	47a2                	lw	a5,8(sp)
    3448:	0027c783          	lbu	a5,2(a5)
    344c:	0017c793          	xor	a5,a5,1
    3450:	0ff7f793          	zext.b	a5,a5
    3454:	0786                	sll	a5,a5,0x1
    3456:	8b89                	and	a5,a5,2
    3458:	8f5d                	or	a4,a4,a5
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
    345a:	47b2                	lw	a5,12(sp)
    345c:	db98                	sw	a4,48(a5)
}
    345e:	0001                	nop
    3460:	0141                	add	sp,sp,16
    3462:	8082                	ret

Disassembly of section .text.uart_calculate_baudrate:

00003464 <uart_calculate_baudrate>:
{
    3464:	7119                	add	sp,sp,-128
    3466:	de86                	sw	ra,124(sp)
    3468:	dca2                	sw	s0,120(sp)
    346a:	daa6                	sw	s1,116(sp)
    346c:	d8ca                	sw	s2,112(sp)
    346e:	d6ce                	sw	s3,108(sp)
    3470:	d4d2                	sw	s4,104(sp)
    3472:	d2d6                	sw	s5,100(sp)
    3474:	d0da                	sw	s6,96(sp)
    3476:	cede                	sw	s7,92(sp)
    3478:	cce2                	sw	s8,88(sp)
    347a:	cae6                	sw	s9,84(sp)
    347c:	c8ea                	sw	s10,80(sp)
    347e:	c6ee                	sw	s11,76(sp)
    3480:	ce2a                	sw	a0,28(sp)
    3482:	cc2e                	sw	a1,24(sp)
    3484:	ca32                	sw	a2,20(sp)
    3486:	c836                	sw	a3,16(sp)
    if ((div_out == NULL) || (!freq) || (!baudrate)
    3488:	46d2                	lw	a3,20(sp)
    348a:	ca85                	beqz	a3,34ba <.L4>
    348c:	46f2                	lw	a3,28(sp)
    348e:	c695                	beqz	a3,34ba <.L4>
    3490:	46e2                	lw	a3,24(sp)
    3492:	c685                	beqz	a3,34ba <.L4>
            || (baudrate < HPM_UART_MINIMUM_BAUDRATE)
    3494:	4662                	lw	a2,24(sp)
    3496:	0c700693          	li	a3,199
    349a:	02c6f063          	bgeu	a3,a2,34ba <.L4>
            || (freq / HPM_UART_BAUDRATE_DIV_MIN < baudrate * HPM_UART_OSC_MIN)
    349e:	46e2                	lw	a3,24(sp)
    34a0:	068e                	sll	a3,a3,0x3
    34a2:	4672                	lw	a2,28(sp)
    34a4:	00d66b63          	bltu	a2,a3,34ba <.L4>
            || (freq / HPM_UART_BAUDRATE_DIV_MAX > (baudrate * HPM_UART_OSC_MAX))) {
    34a8:	4672                	lw	a2,28(sp)
    34aa:	66c1                	lui	a3,0x10
    34ac:	16fd                	add	a3,a3,-1 # ffff <__ILM_segment_used_end__+0xa7b7>
    34ae:	02d65633          	divu	a2,a2,a3
    34b2:	46e2                	lw	a3,24(sp)
    34b4:	0696                	sll	a3,a3,0x5
    34b6:	00c6f463          	bgeu	a3,a2,34be <.L5>

000034ba <.L4>:
        return 0;
    34ba:	4781                	li	a5,0
    34bc:	ac21                	j	36d4 <.L6>

000034be <.L5>:
    tmp = ((uint64_t)freq * HPM_UART_BAUDRATE_SCALE) / baudrate;
    34be:	46f2                	lw	a3,28(sp)
    34c0:	8736                	mv	a4,a3
    34c2:	4781                	li	a5,0
    34c4:	3e800693          	li	a3,1000
    34c8:	02d78633          	mul	a2,a5,a3
    34cc:	4681                	li	a3,0
    34ce:	02d706b3          	mul	a3,a4,a3
    34d2:	9636                	add	a2,a2,a3
    34d4:	3e800693          	li	a3,1000
    34d8:	02d705b3          	mul	a1,a4,a3
    34dc:	02d738b3          	mulhu	a7,a4,a3
    34e0:	882e                	mv	a6,a1
    34e2:	011607b3          	add	a5,a2,a7
    34e6:	88be                	mv	a7,a5
    34e8:	47e2                	lw	a5,24(sp)
    34ea:	833e                	mv	t1,a5
    34ec:	4381                	li	t2,0
    34ee:	861a                	mv	a2,t1
    34f0:	869e                	mv	a3,t2
    34f2:	8542                	mv	a0,a6
    34f4:	85c6                	mv	a1,a7
    34f6:	878ff0ef          	jal	256e <__udivdi3>
    34fa:	872a                	mv	a4,a0
    34fc:	87ae                	mv	a5,a1
    34fe:	d83a                	sw	a4,48(sp)
    3500:	da3e                	sw	a5,52(sp)
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
    3502:	47a1                	li	a5,8
    3504:	02f11f23          	sh	a5,62(sp)
    3508:	aa7d                	j	36c6 <.L7>

0000350a <.L18>:
        delta = 0;
    350a:	02011e23          	sh	zero,60(sp)
        div = (uint16_t)((tmp + osc * (HPM_UART_BAUDRATE_SCALE / 2)) / (osc * HPM_UART_BAUDRATE_SCALE));
    350e:	03e15703          	lhu	a4,62(sp)
    3512:	1f400793          	li	a5,500
    3516:	02f707b3          	mul	a5,a4,a5
    351a:	843e                	mv	s0,a5
    351c:	4481                	li	s1,0
    351e:	5642                	lw	a2,48(sp)
    3520:	56d2                	lw	a3,52(sp)
    3522:	00c40733          	add	a4,s0,a2
    3526:	85ba                	mv	a1,a4
    3528:	0085b5b3          	sltu	a1,a1,s0
    352c:	00d487b3          	add	a5,s1,a3
    3530:	00f586b3          	add	a3,a1,a5
    3534:	87b6                	mv	a5,a3
    3536:	853a                	mv	a0,a4
    3538:	85be                	mv	a1,a5
    353a:	03e15703          	lhu	a4,62(sp)
    353e:	3e800793          	li	a5,1000
    3542:	02f707b3          	mul	a5,a4,a5
    3546:	8d3e                	mv	s10,a5
    3548:	4d81                	li	s11,0
    354a:	866a                	mv	a2,s10
    354c:	86ee                	mv	a3,s11
    354e:	820ff0ef          	jal	256e <__udivdi3>
    3552:	872a                	mv	a4,a0
    3554:	87ae                	mv	a5,a1
    3556:	02e11723          	sh	a4,46(sp)
        if (div < HPM_UART_BAUDRATE_DIV_MIN) {
    355a:	02e15783          	lhu	a5,46(sp)
    355e:	14078c63          	beqz	a5,36b6 <.L21>
        if ((div * osc * HPM_UART_BAUDRATE_SCALE) > tmp) {
    3562:	02e15703          	lhu	a4,46(sp)
    3566:	03e15783          	lhu	a5,62(sp)
    356a:	02f707b3          	mul	a5,a4,a5
    356e:	873e                	mv	a4,a5
    3570:	3e800793          	li	a5,1000
    3574:	02f707b3          	mul	a5,a4,a5
    3578:	8b3e                	mv	s6,a5
    357a:	4b81                	li	s7,0
    357c:	57d2                	lw	a5,52(sp)
    357e:	875e                	mv	a4,s7
    3580:	00e7ea63          	bltu	a5,a4,3594 <.L19>
    3584:	57d2                	lw	a5,52(sp)
    3586:	875e                	mv	a4,s7
    3588:	04e79b63          	bne	a5,a4,35de <.L10>
    358c:	57c2                	lw	a5,48(sp)
    358e:	875a                	mv	a4,s6
    3590:	04e7f763          	bgeu	a5,a4,35de <.L10>

00003594 <.L19>:
            delta = (uint16_t)(((div * osc * HPM_UART_BAUDRATE_SCALE) - tmp) / HPM_UART_BAUDRATE_SCALE);
    3594:	02e15703          	lhu	a4,46(sp)
    3598:	03e15783          	lhu	a5,62(sp)
    359c:	02f707b3          	mul	a5,a4,a5
    35a0:	873e                	mv	a4,a5
    35a2:	3e800793          	li	a5,1000
    35a6:	02f707b3          	mul	a5,a4,a5
    35aa:	893e                	mv	s2,a5
    35ac:	4981                	li	s3,0
    35ae:	5642                	lw	a2,48(sp)
    35b0:	56d2                	lw	a3,52(sp)
    35b2:	40c90733          	sub	a4,s2,a2
    35b6:	85ba                	mv	a1,a4
    35b8:	00b935b3          	sltu	a1,s2,a1
    35bc:	40d987b3          	sub	a5,s3,a3
    35c0:	40b786b3          	sub	a3,a5,a1
    35c4:	87b6                	mv	a5,a3
    35c6:	3e800613          	li	a2,1000
    35ca:	4681                	li	a3,0
    35cc:	853a                	mv	a0,a4
    35ce:	85be                	mv	a1,a5
    35d0:	f9ffe0ef          	jal	256e <__udivdi3>
    35d4:	872a                	mv	a4,a0
    35d6:	87ae                	mv	a5,a1
    35d8:	02e11e23          	sh	a4,60(sp)
    35dc:	a8a5                	j	3654 <.L12>

000035de <.L10>:
        } else if (div * osc < tmp) {
    35de:	02e15703          	lhu	a4,46(sp)
    35e2:	03e15783          	lhu	a5,62(sp)
    35e6:	02f707b3          	mul	a5,a4,a5
    35ea:	8c3e                	mv	s8,a5
    35ec:	87fd                	sra	a5,a5,0x1f
    35ee:	8cbe                	mv	s9,a5
    35f0:	57d2                	lw	a5,52(sp)
    35f2:	8766                	mv	a4,s9
    35f4:	00f76a63          	bltu	a4,a5,3608 <.L20>
    35f8:	57d2                	lw	a5,52(sp)
    35fa:	8766                	mv	a4,s9
    35fc:	04e79c63          	bne	a5,a4,3654 <.L12>
    3600:	57c2                	lw	a5,48(sp)
    3602:	8762                	mv	a4,s8
    3604:	04f77863          	bgeu	a4,a5,3654 <.L12>

00003608 <.L20>:
            delta = (uint16_t)((tmp - (div * osc * HPM_UART_BAUDRATE_SCALE)) / HPM_UART_BAUDRATE_SCALE);
    3608:	02e15703          	lhu	a4,46(sp)
    360c:	03e15783          	lhu	a5,62(sp)
    3610:	02f707b3          	mul	a5,a4,a5
    3614:	873e                	mv	a4,a5
    3616:	3e800793          	li	a5,1000
    361a:	02f707b3          	mul	a5,a4,a5
    361e:	8a3e                	mv	s4,a5
    3620:	4a81                	li	s5,0
    3622:	5742                	lw	a4,48(sp)
    3624:	57d2                	lw	a5,52(sp)
    3626:	41470633          	sub	a2,a4,s4
    362a:	85b2                	mv	a1,a2
    362c:	00b735b3          	sltu	a1,a4,a1
    3630:	415786b3          	sub	a3,a5,s5
    3634:	40b687b3          	sub	a5,a3,a1
    3638:	86be                	mv	a3,a5
    363a:	8732                	mv	a4,a2
    363c:	87b6                	mv	a5,a3
    363e:	3e800613          	li	a2,1000
    3642:	4681                	li	a3,0
    3644:	853a                	mv	a0,a4
    3646:	85be                	mv	a1,a5
    3648:	f27fe0ef          	jal	256e <__udivdi3>
    364c:	872a                	mv	a4,a0
    364e:	87ae                	mv	a5,a1
    3650:	02e11e23          	sh	a4,60(sp)

00003654 <.L12>:
        if (delta && (((delta * 100 * HPM_UART_BAUDRATE_SCALE) / tmp) > HPM_UART_BAUDRATE_TOLERANCE)) {
    3654:	03c15783          	lhu	a5,60(sp)
    3658:	cb8d                	beqz	a5,368a <.L14>
    365a:	03c15703          	lhu	a4,60(sp)
    365e:	67e1                	lui	a5,0x18
    3660:	6a078793          	add	a5,a5,1696 # 186a0 <__NONCACHEABLE_RAM_segment_size__+0x86a0>
    3664:	02f707b3          	mul	a5,a4,a5
    3668:	c43e                	sw	a5,8(sp)
    366a:	c602                	sw	zero,12(sp)
    366c:	5642                	lw	a2,48(sp)
    366e:	56d2                	lw	a3,52(sp)
    3670:	4522                	lw	a0,8(sp)
    3672:	45b2                	lw	a1,12(sp)
    3674:	efbfe0ef          	jal	256e <__udivdi3>
    3678:	872a                	mv	a4,a0
    367a:	87ae                	mv	a5,a1
    367c:	86be                	mv	a3,a5
    367e:	ee95                	bnez	a3,36ba <.L22>
    3680:	86be                	mv	a3,a5
    3682:	e681                	bnez	a3,368a <.L14>
    3684:	478d                	li	a5,3
    3686:	02e7ea63          	bltu	a5,a4,36ba <.L22>

0000368a <.L14>:
            *div_out = div;
    368a:	47d2                	lw	a5,20(sp)
    368c:	02e15703          	lhu	a4,46(sp)
    3690:	00e79023          	sh	a4,0(a5)
            *osc_out = (osc == HPM_UART_OSC_MAX) ? 0 : osc; /* osc == 0 in bitfield, oversample rate is 32 */
    3694:	03e15703          	lhu	a4,62(sp)
    3698:	02000793          	li	a5,32
    369c:	00f70763          	beq	a4,a5,36aa <.L16>
    36a0:	03e15783          	lhu	a5,62(sp)
    36a4:	0ff7f793          	zext.b	a5,a5
    36a8:	a011                	j	36ac <.L17>

000036aa <.L16>:
    36aa:	4781                	li	a5,0

000036ac <.L17>:
    36ac:	4742                	lw	a4,16(sp)
    36ae:	00f70023          	sb	a5,0(a4)
            return true;
    36b2:	4785                	li	a5,1
    36b4:	a005                	j	36d4 <.L6>

000036b6 <.L21>:
            continue;
    36b6:	0001                	nop
    36b8:	a011                	j	36bc <.L9>

000036ba <.L22>:
            continue;
    36ba:	0001                	nop

000036bc <.L9>:
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
    36bc:	03e15783          	lhu	a5,62(sp)
    36c0:	0789                	add	a5,a5,2
    36c2:	02f11f23          	sh	a5,62(sp)

000036c6 <.L7>:
    36c6:	03e15703          	lhu	a4,62(sp)
    36ca:	02000793          	li	a5,32
    36ce:	e2e7fee3          	bgeu	a5,a4,350a <.L18>
    return false;
    36d2:	4781                	li	a5,0

000036d4 <.L6>:
}
    36d4:	853e                	mv	a0,a5
    36d6:	50f6                	lw	ra,124(sp)
    36d8:	5466                	lw	s0,120(sp)
    36da:	54d6                	lw	s1,116(sp)
    36dc:	5946                	lw	s2,112(sp)
    36de:	59b6                	lw	s3,108(sp)
    36e0:	5a26                	lw	s4,104(sp)
    36e2:	5a96                	lw	s5,100(sp)
    36e4:	5b06                	lw	s6,96(sp)
    36e6:	4bf6                	lw	s7,92(sp)
    36e8:	4c66                	lw	s8,88(sp)
    36ea:	4cd6                	lw	s9,84(sp)
    36ec:	4d46                	lw	s10,80(sp)
    36ee:	4db6                	lw	s11,76(sp)
    36f0:	6109                	add	sp,sp,128
    36f2:	8082                	ret

Disassembly of section .text.uart_init:

000036f4 <uart_init>:
{
    36f4:	7179                	add	sp,sp,-48
    36f6:	d606                	sw	ra,44(sp)
    36f8:	c62a                	sw	a0,12(sp)
    36fa:	c42e                	sw	a1,8(sp)
    ptr->IER = 0;
    36fc:	47b2                	lw	a5,12(sp)
    36fe:	0207a223          	sw	zero,36(a5)
    ptr->LCR |= UART_LCR_DLAB_MASK;
    3702:	47b2                	lw	a5,12(sp)
    3704:	57dc                	lw	a5,44(a5)
    3706:	0807e713          	or	a4,a5,128
    370a:	47b2                	lw	a5,12(sp)
    370c:	d7d8                	sw	a4,44(a5)
    if (!uart_calculate_baudrate(config->src_freq_in_hz, config->baudrate, &div, &osc)) {
    370e:	47a2                	lw	a5,8(sp)
    3710:	4398                	lw	a4,0(a5)
    3712:	47a2                	lw	a5,8(sp)
    3714:	43dc                	lw	a5,4(a5)
    3716:	01b10693          	add	a3,sp,27
    371a:	0830                	add	a2,sp,24
    371c:	85be                	mv	a1,a5
    371e:	853a                	mv	a0,a4
    3720:	3391                	jal	3464 <uart_calculate_baudrate>
    3722:	87aa                	mv	a5,a0
    3724:	0017c793          	xor	a5,a5,1
    3728:	0ff7f793          	zext.b	a5,a5
    372c:	c781                	beqz	a5,3734 <.L24>
        return status_uart_no_suitable_baudrate_parameter_found;
    372e:	3e900793          	li	a5,1001
    3732:	aa1d                	j	3868 <.L40>

00003734 <.L24>:
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
    3734:	47b2                	lw	a5,12(sp)
    3736:	4bdc                	lw	a5,20(a5)
    3738:	fe07f713          	and	a4,a5,-32
        | UART_OSCR_OSC_SET(osc);
    373c:	01b14783          	lbu	a5,27(sp)
    3740:	8bfd                	and	a5,a5,31
    3742:	8f5d                	or	a4,a4,a5
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
    3744:	47b2                	lw	a5,12(sp)
    3746:	cbd8                	sw	a4,20(a5)
    ptr->DLL = UART_DLL_DLL_SET(div >> 0);
    3748:	01815783          	lhu	a5,24(sp)
    374c:	0ff7f713          	zext.b	a4,a5
    3750:	47b2                	lw	a5,12(sp)
    3752:	d398                	sw	a4,32(a5)
    ptr->DLM = UART_DLM_DLM_SET(div >> 8);
    3754:	01815783          	lhu	a5,24(sp)
    3758:	83a1                	srl	a5,a5,0x8
    375a:	07c2                	sll	a5,a5,0x10
    375c:	83c1                	srl	a5,a5,0x10
    375e:	0ff7f713          	zext.b	a4,a5
    3762:	47b2                	lw	a5,12(sp)
    3764:	d3d8                	sw	a4,36(a5)
    tmp = ptr->LCR & (~UART_LCR_DLAB_MASK);
    3766:	47b2                	lw	a5,12(sp)
    3768:	57dc                	lw	a5,44(a5)
    376a:	f7f7f793          	and	a5,a5,-129
    376e:	ce3e                	sw	a5,28(sp)
    tmp &= ~(UART_LCR_SPS_MASK | UART_LCR_EPS_MASK | UART_LCR_PEN_MASK);
    3770:	47f2                	lw	a5,28(sp)
    3772:	fc77f793          	and	a5,a5,-57
    3776:	ce3e                	sw	a5,28(sp)
    switch (config->parity) {
    3778:	47a2                	lw	a5,8(sp)
    377a:	00a7c783          	lbu	a5,10(a5)
    377e:	4711                	li	a4,4
    3780:	02f76d63          	bltu	a4,a5,37ba <.L26>
    3784:	00279713          	sll	a4,a5,0x2
    3788:	90c18793          	add	a5,gp,-1780 # 1b0 <.L28>
    378c:	97ba                	add	a5,a5,a4
    378e:	439c                	lw	a5,0(a5)
    3790:	8782                	jr	a5

00003792 <.L31>:
        tmp |= UART_LCR_PEN_MASK;
    3792:	47f2                	lw	a5,28(sp)
    3794:	0087e793          	or	a5,a5,8
    3798:	ce3e                	sw	a5,28(sp)
        break;
    379a:	a01d                	j	37c0 <.L33>

0000379c <.L30>:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_EPS_MASK;
    379c:	47f2                	lw	a5,28(sp)
    379e:	0187e793          	or	a5,a5,24
    37a2:	ce3e                	sw	a5,28(sp)
        break;
    37a4:	a831                	j	37c0 <.L33>

000037a6 <.L29>:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_SPS_MASK;
    37a6:	47f2                	lw	a5,28(sp)
    37a8:	0287e793          	or	a5,a5,40
    37ac:	ce3e                	sw	a5,28(sp)
        break;
    37ae:	a809                	j	37c0 <.L33>

000037b0 <.L27>:
        tmp |= UART_LCR_EPS_MASK | UART_LCR_PEN_MASK
    37b0:	47f2                	lw	a5,28(sp)
    37b2:	0387e793          	or	a5,a5,56
    37b6:	ce3e                	sw	a5,28(sp)
        break;
    37b8:	a021                	j	37c0 <.L33>

000037ba <.L26>:
        return status_invalid_argument;
    37ba:	4789                	li	a5,2
    37bc:	a075                	j	3868 <.L40>

000037be <.L41>:
        break;
    37be:	0001                	nop

000037c0 <.L33>:
    tmp &= ~(UART_LCR_STB_MASK | UART_LCR_WLS_MASK);
    37c0:	47f2                	lw	a5,28(sp)
    37c2:	9be1                	and	a5,a5,-8
    37c4:	ce3e                	sw	a5,28(sp)
    switch (config->num_of_stop_bits) {
    37c6:	47a2                	lw	a5,8(sp)
    37c8:	0087c783          	lbu	a5,8(a5)
    37cc:	4709                	li	a4,2
    37ce:	00e78e63          	beq	a5,a4,37ea <.L34>
    37d2:	4709                	li	a4,2
    37d4:	02f74663          	blt	a4,a5,3800 <.L35>
    37d8:	c795                	beqz	a5,3804 <.L42>
    37da:	4705                	li	a4,1
    37dc:	02e79263          	bne	a5,a4,3800 <.L35>
        tmp |= UART_LCR_STB_MASK;
    37e0:	47f2                	lw	a5,28(sp)
    37e2:	0047e793          	or	a5,a5,4
    37e6:	ce3e                	sw	a5,28(sp)
        break;
    37e8:	a839                	j	3806 <.L38>

000037ea <.L34>:
        if (config->word_length < word_length_6_bits) {
    37ea:	47a2                	lw	a5,8(sp)
    37ec:	0097c783          	lbu	a5,9(a5)
    37f0:	e399                	bnez	a5,37f6 <.L39>
            return status_invalid_argument;
    37f2:	4789                	li	a5,2
    37f4:	a895                	j	3868 <.L40>

000037f6 <.L39>:
        tmp |= UART_LCR_STB_MASK;
    37f6:	47f2                	lw	a5,28(sp)
    37f8:	0047e793          	or	a5,a5,4
    37fc:	ce3e                	sw	a5,28(sp)
        break;
    37fe:	a021                	j	3806 <.L38>

00003800 <.L35>:
        return status_invalid_argument;
    3800:	4789                	li	a5,2
    3802:	a09d                	j	3868 <.L40>

00003804 <.L42>:
        break;
    3804:	0001                	nop

00003806 <.L38>:
    ptr->LCR = tmp | UART_LCR_WLS_SET(config->word_length);
    3806:	47a2                	lw	a5,8(sp)
    3808:	0097c783          	lbu	a5,9(a5)
    380c:	0037f713          	and	a4,a5,3
    3810:	47f2                	lw	a5,28(sp)
    3812:	8f5d                	or	a4,a4,a5
    3814:	47b2                	lw	a5,12(sp)
    3816:	d7d8                	sw	a4,44(a5)
    ptr->FCR = UART_FCR_TFIFORST_MASK | UART_FCR_RFIFORST_MASK;
    3818:	47b2                	lw	a5,12(sp)
    381a:	4719                	li	a4,6
    381c:	d798                	sw	a4,40(a5)
    tmp = UART_FCR_FIFOE_SET(config->fifo_enable)
    381e:	47a2                	lw	a5,8(sp)
    3820:	00e7c783          	lbu	a5,14(a5)
    3824:	873e                	mv	a4,a5
        | UART_FCR_TFIFOT_SET(config->tx_fifo_level)
    3826:	47a2                	lw	a5,8(sp)
    3828:	00b7c783          	lbu	a5,11(a5)
    382c:	0792                	sll	a5,a5,0x4
    382e:	0307f793          	and	a5,a5,48
    3832:	8f5d                	or	a4,a4,a5
        | UART_FCR_RFIFOT_SET(config->rx_fifo_level)
    3834:	47a2                	lw	a5,8(sp)
    3836:	00c7c783          	lbu	a5,12(a5)
    383a:	079a                	sll	a5,a5,0x6
    383c:	0ff7f793          	zext.b	a5,a5
    3840:	8f5d                	or	a4,a4,a5
        | UART_FCR_DMAE_SET(config->dma_enable);
    3842:	47a2                	lw	a5,8(sp)
    3844:	00d7c783          	lbu	a5,13(a5)
    3848:	078e                	sll	a5,a5,0x3
    384a:	8ba1                	and	a5,a5,8
    tmp = UART_FCR_FIFOE_SET(config->fifo_enable)
    384c:	8fd9                	or	a5,a5,a4
    384e:	ce3e                	sw	a5,28(sp)
    ptr->FCR = tmp;
    3850:	47b2                	lw	a5,12(sp)
    3852:	4772                	lw	a4,28(sp)
    3854:	d798                	sw	a4,40(a5)
    ptr->GPR = tmp;
    3856:	47b2                	lw	a5,12(sp)
    3858:	4772                	lw	a4,28(sp)
    385a:	dfd8                	sw	a4,60(a5)
    uart_modem_config(ptr, &config->modem_config);
    385c:	47a2                	lw	a5,8(sp)
    385e:	07bd                	add	a5,a5,15
    3860:	85be                	mv	a1,a5
    3862:	4532                	lw	a0,12(sp)
    3864:	36d1                	jal	3428 <uart_modem_config>
    return status_success;
    3866:	4781                	li	a5,0

00003868 <.L40>:
}
    3868:	853e                	mv	a0,a5
    386a:	50b2                	lw	ra,44(sp)
    386c:	6145                	add	sp,sp,48
    386e:	8082                	ret

Disassembly of section .text.uart_flush:

00003870 <uart_flush>:

hpm_stat_t uart_flush(UART_Type *ptr)
{
    3870:	1101                	add	sp,sp,-32
    3872:	c62a                	sw	a0,12(sp)
    uint32_t retry = 0;
    3874:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
    3876:	a811                	j	388a <.L56>

00003878 <.L59>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
    3878:	4772                	lw	a4,28(sp)
    387a:	6785                	lui	a5,0x1
    387c:	38878793          	add	a5,a5,904 # 1388 <.LC24+0x28>
    3880:	00e7eb63          	bltu	a5,a4,3896 <.L62>
            break;
        }
        retry++;
    3884:	47f2                	lw	a5,28(sp)
    3886:	0785                	add	a5,a5,1
    3888:	ce3e                	sw	a5,28(sp)

0000388a <.L56>:
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
    388a:	47b2                	lw	a5,12(sp)
    388c:	5bdc                	lw	a5,52(a5)
    388e:	0407f793          	and	a5,a5,64
    3892:	d3fd                	beqz	a5,3878 <.L59>
    3894:	a011                	j	3898 <.L58>

00003896 <.L62>:
            break;
    3896:	0001                	nop

00003898 <.L58>:
    }
    if (retry > HPM_UART_DRV_RETRY_COUNT) {
    3898:	4772                	lw	a4,28(sp)
    389a:	6785                	lui	a5,0x1
    389c:	38878793          	add	a5,a5,904 # 1388 <.LC24+0x28>
    38a0:	00e7f463          	bgeu	a5,a4,38a8 <.L60>
        return status_timeout;
    38a4:	478d                	li	a5,3
    38a6:	a011                	j	38aa <.L61>

000038a8 <.L60>:
    }

    return status_success;
    38a8:	4781                	li	a5,0

000038aa <.L61>:
}
    38aa:	853e                	mv	a0,a5
    38ac:	6105                	add	sp,sp,32
    38ae:	8082                	ret

Disassembly of section .text.mbx_disable_intr:

000038b0 <mbx_disable_intr>:
{
    38b0:	1141                	add	sp,sp,-16
    38b2:	c62a                	sw	a0,12(sp)
    38b4:	c42e                	sw	a1,8(sp)
    ptr->CR &= ~mask;
    38b6:	47b2                	lw	a5,12(sp)
    38b8:	4398                	lw	a4,0(a5)
    38ba:	47a2                	lw	a5,8(sp)
    38bc:	fff7c793          	not	a5,a5
    38c0:	8f7d                	and	a4,a4,a5
    38c2:	47b2                	lw	a5,12(sp)
    38c4:	c398                	sw	a4,0(a5)
}
    38c6:	0001                	nop
    38c8:	0141                	add	sp,sp,16
    38ca:	8082                	ret

Disassembly of section .text.mbx_enable_intr:

000038cc <mbx_enable_intr>:
{
    38cc:	1141                	add	sp,sp,-16
    38ce:	c62a                	sw	a0,12(sp)
    38d0:	c42e                	sw	a1,8(sp)
    ptr->CR |= mask;
    38d2:	47b2                	lw	a5,12(sp)
    38d4:	4398                	lw	a4,0(a5)
    38d6:	47a2                	lw	a5,8(sp)
    38d8:	8f5d                	or	a4,a4,a5
    38da:	47b2                	lw	a5,12(sp)
    38dc:	c398                	sw	a4,0(a5)
}
    38de:	0001                	nop
    38e0:	0141                	add	sp,sp,16
    38e2:	8082                	ret

Disassembly of section .text.mbx_disable_intr:

000038e4 <mbx_disable_intr>:
{
    38e4:	1141                	add	sp,sp,-16
    38e6:	c62a                	sw	a0,12(sp)
    38e8:	c42e                	sw	a1,8(sp)
    ptr->CR &= ~mask;
    38ea:	47b2                	lw	a5,12(sp)
    38ec:	4398                	lw	a4,0(a5)
    38ee:	47a2                	lw	a5,8(sp)
    38f0:	fff7c793          	not	a5,a5
    38f4:	8f7d                	and	a4,a4,a5
    38f6:	47b2                	lw	a5,12(sp)
    38f8:	c398                	sw	a4,0(a5)
}
    38fa:	0001                	nop
    38fc:	0141                	add	sp,sp,16
    38fe:	8082                	ret

Disassembly of section .text.mbx_empty_txfifo:

00003900 <mbx_empty_txfifo>:
{
    3900:	1141                	add	sp,sp,-16
    3902:	c62a                	sw	a0,12(sp)
    ptr->CR |= MBX_CR_TXRESET_MASK;
    3904:	47b2                	lw	a5,12(sp)
    3906:	4398                	lw	a4,0(a5)
    3908:	800007b7          	lui	a5,0x80000
    390c:	8f5d                	or	a4,a4,a5
    390e:	47b2                	lw	a5,12(sp)
    3910:	c398                	sw	a4,0(a5)
}
    3912:	0001                	nop
    3914:	0141                	add	sp,sp,16
    3916:	8082                	ret

Disassembly of section .text._clean_up:

00003918 <_clean_up>:
#define MAIN_ENTRY main
#endif
extern int MAIN_ENTRY(void);

__attribute__((weak)) void _clean_up(void)
{
    3918:	7139                	add	sp,sp,-64

0000391a <.LBB18>:
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
    391a:	6785                	lui	a5,0x1
    391c:	80078793          	add	a5,a5,-2048 # 800 <__SEGGER_RTL_fdiv_reciprocal_table+0x34>
    3920:	3047b073          	csrc	mie,a5
}
    3924:	0001                	nop
    3926:	da02                	sw	zero,52(sp)
    3928:	d802                	sw	zero,48(sp)
    392a:	e40007b7          	lui	a5,0xe4000
    392e:	d63e                	sw	a5,44(sp)
    3930:	57d2                	lw	a5,52(sp)
    3932:	d43e                	sw	a5,40(sp)
    3934:	57c2                	lw	a5,48(sp)
    3936:	d23e                	sw	a5,36(sp)

00003938 <.LBB20>:
            (target << HPM_PLIC_THRESHOLD_SHIFT_PER_TARGET));
    3938:	57a2                	lw	a5,40(sp)
    393a:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_THRESHOLD_OFFSET +
    393e:	57b2                	lw	a5,44(sp)
    3940:	973e                	add	a4,a4,a5
    3942:	002007b7          	lui	a5,0x200
    3946:	97ba                	add	a5,a5,a4
    volatile uint32_t *threshold_ptr = (volatile uint32_t *)(base +
    3948:	d03e                	sw	a5,32(sp)
    *threshold_ptr = threshold;
    394a:	5782                	lw	a5,32(sp)
    394c:	5712                	lw	a4,36(sp)
    394e:	c398                	sw	a4,0(a5)
}
    3950:	0001                	nop

00003952 <.LBE22>:
 * @param[in] threshold Threshold of IRQ can be serviced
 */
ATTR_ALWAYS_INLINE static inline void intc_set_threshold(uint32_t target, uint32_t threshold)
{
    __plic_set_threshold(HPM_PLIC_BASE, target, threshold);
}
    3952:	0001                	nop

00003954 <.LBB24>:
    /* clean up plic, it will help while debugging */
    disable_irq_from_intc();
    intc_m_set_threshold(0);
    for (uint32_t irq = 0; irq < 128; irq++) {
    3954:	de02                	sw	zero,60(sp)
    3956:	a82d                	j	3990 <.L2>

00003958 <.L3>:
    3958:	ce02                	sw	zero,28(sp)
    395a:	57f2                	lw	a5,60(sp)
    395c:	cc3e                	sw	a5,24(sp)
    395e:	e40007b7          	lui	a5,0xe4000
    3962:	ca3e                	sw	a5,20(sp)
    3964:	47f2                	lw	a5,28(sp)
    3966:	c83e                	sw	a5,16(sp)
    3968:	47e2                	lw	a5,24(sp)
    396a:	c63e                	sw	a5,12(sp)

0000396c <.LBB25>:
            (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
    396c:	47c2                	lw	a5,16(sp)
    396e:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_CLAIM_OFFSET +
    3972:	47d2                	lw	a5,20(sp)
    3974:	973e                	add	a4,a4,a5
    3976:	002007b7          	lui	a5,0x200
    397a:	0791                	add	a5,a5,4 # 200004 <__DLM_segment_end__+0x140004>
    397c:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
    397e:	c43e                	sw	a5,8(sp)
    *claim_addr = irq;
    3980:	47a2                	lw	a5,8(sp)
    3982:	4732                	lw	a4,12(sp)
    3984:	c398                	sw	a4,0(a5)
}
    3986:	0001                	nop

00003988 <.LBE27>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_complete_irq(uint32_t target, uint32_t irq)
{
    __plic_complete_irq(HPM_PLIC_BASE, target, irq);
}
    3988:	0001                	nop

0000398a <.LBE25>:
    398a:	57f2                	lw	a5,60(sp)
    398c:	0785                	add	a5,a5,1
    398e:	de3e                	sw	a5,60(sp)

00003990 <.L2>:
    3990:	5772                	lw	a4,60(sp)
    3992:	07f00793          	li	a5,127
    3996:	fce7f1e3          	bgeu	a5,a4,3958 <.L3>

0000399a <.LBB29>:
        intc_m_complete_irq(irq);
    }
    /* clear any bits left in plic enable register */
    for (uint32_t i = 0; i < 4; i++) {
    399a:	dc02                	sw	zero,56(sp)
    399c:	a821                	j	39b4 <.L4>

0000399e <.L5>:
        *(volatile uint32_t *)(HPM_PLIC_BASE + HPM_PLIC_ENABLE_OFFSET + (i << 2)) = 0;
    399e:	57e2                	lw	a5,56(sp)
    39a0:	00279713          	sll	a4,a5,0x2
    39a4:	e40027b7          	lui	a5,0xe4002
    39a8:	97ba                	add	a5,a5,a4
    39aa:	0007a023          	sw	zero,0(a5) # e4002000 <__SHARE_RAM_segment_end__+0xe2e82000>
    for (uint32_t i = 0; i < 4; i++) {
    39ae:	57e2                	lw	a5,56(sp)
    39b0:	0785                	add	a5,a5,1
    39b2:	dc3e                	sw	a5,56(sp)

000039b4 <.L4>:
    39b4:	5762                	lw	a4,56(sp)
    39b6:	478d                	li	a5,3
    39b8:	fee7f3e3          	bgeu	a5,a4,399e <.L5>

000039bc <.LBE29>:
    }
}
    39bc:	0001                	nop
    39be:	0001                	nop
    39c0:	6121                	add	sp,sp,64
    39c2:	8082                	ret

Disassembly of section .text.reset_handler:

000039c4 <reset_handler>:
        ;
    }
}

__attribute__((weak)) void reset_handler(void)
{
    39c4:	1141                	add	sp,sp,-16
    39c6:	c606                	sw	ra,12(sp)
    fencei();
    39c8:	0000100f          	fence.i

    /* Call platform specific hardware initialization */
    system_init();
    39cc:	d4cfe0ef          	jal	1f18 <system_init>

    /* Entry function */
    MAIN_ENTRY();
    39d0:	a00fe0ef          	jal	1bd0 <main>
}
    39d4:	0001                	nop
    39d6:	40b2                	lw	ra,12(sp)
    39d8:	0141                	add	sp,sp,16
    39da:	8082                	ret

Disassembly of section .text._init:

000039dc <_init>:
__attribute__((weak)) void *__dso_handle = (void *) &__dso_handle;
#endif

__attribute__((weak)) void _init(void)
{
}
    39dc:	0001                	nop
    39de:	8082                	ret

Disassembly of section .text.mchtmr_isr:

000039e0 <mchtmr_isr>:
}
    39e0:	0001                	nop
    39e2:	8082                	ret

Disassembly of section .text.swi_isr:

000039e4 <swi_isr>:
}
    39e4:	0001                	nop
    39e6:	8082                	ret

Disassembly of section .text.exception_handler:

000039e8 <exception_handler>:
{
    39e8:	1141                	add	sp,sp,-16
    39ea:	c62a                	sw	a0,12(sp)
    39ec:	c42e                	sw	a1,8(sp)
    switch (cause) {
    39ee:	4732                	lw	a4,12(sp)
    39f0:	47bd                	li	a5,15
    39f2:	00e7ea63          	bltu	a5,a4,3a06 <.L23>
    39f6:	47b2                	lw	a5,12(sp)
    39f8:	00279713          	sll	a4,a5,0x2
    39fc:	eb418793          	add	a5,gp,-332 # 758 <.L7>
    3a00:	97ba                	add	a5,a5,a4
    3a02:	439c                	lw	a5,0(a5)
    3a04:	8782                	jr	a5

00003a06 <.L23>:
        break;
    3a06:	0001                	nop
    return epc;
    3a08:	47a2                	lw	a5,8(sp)
}
    3a0a:	853e                	mv	a0,a5
    3a0c:	0141                	add	sp,sp,16
    3a0e:	8082                	ret

Disassembly of section .text.get_frequency_for_source:

00003a10 <get_frequency_for_source>:
{
    3a10:	7179                	add	sp,sp,-48
    3a12:	d606                	sw	ra,44(sp)
    3a14:	87aa                	mv	a5,a0
    3a16:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
    3a1a:	ce02                	sw	zero,28(sp)
    uint32_t div = 1;
    3a1c:	4785                	li	a5,1
    3a1e:	cc3e                	sw	a5,24(sp)
    switch (source) {
    3a20:	00f14783          	lbu	a5,15(sp)
    3a24:	471d                	li	a4,7
    3a26:	0cf76c63          	bltu	a4,a5,3afe <.L45>
    3a2a:	00279713          	sll	a4,a5,0x2
    3a2e:	93818793          	add	a5,gp,-1736 # 1dc <.L47>
    3a32:	97ba                	add	a5,a5,a4
    3a34:	439c                	lw	a5,0(a5)
    3a36:	8782                	jr	a5

00003a38 <.L54>:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
    3a38:	016e37b7          	lui	a5,0x16e3
    3a3c:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
    3a40:	ce3e                	sw	a5,28(sp)
        break;
    3a42:	a0c1                	j	3b02 <.L55>

00003a44 <.L53>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 0U);
    3a44:	4581                	li	a1,0
    3a46:	f4100537          	lui	a0,0xf4100
    3a4a:	fb6ff0ef          	jal	3200 <pllctl_get_pll_freq_in_hz>
    3a4e:	ce2a                	sw	a0,28(sp)
        break;
    3a50:	a84d                	j	3b02 <.L55>

00003a52 <.L52>:
        div = pllctl_get_div(HPM_PLLCTL, 1, 0);
    3a52:	4601                	li	a2,0
    3a54:	4585                	li	a1,1
    3a56:	f4100537          	lui	a0,0xf4100
    3a5a:	a8afe0ef          	jal	1ce4 <pllctl_get_div>
    3a5e:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 1U) / div;
    3a60:	4585                	li	a1,1
    3a62:	f4100537          	lui	a0,0xf4100
    3a66:	f9aff0ef          	jal	3200 <pllctl_get_pll_freq_in_hz>
    3a6a:	872a                	mv	a4,a0
    3a6c:	47e2                	lw	a5,24(sp)
    3a6e:	02f757b3          	divu	a5,a4,a5
    3a72:	ce3e                	sw	a5,28(sp)
        break;
    3a74:	a079                	j	3b02 <.L55>

00003a76 <.L51>:
        div = pllctl_get_div(HPM_PLLCTL, 1, 1);
    3a76:	4605                	li	a2,1
    3a78:	4585                	li	a1,1
    3a7a:	f4100537          	lui	a0,0xf4100
    3a7e:	a66fe0ef          	jal	1ce4 <pllctl_get_div>
    3a82:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 1U) / div;
    3a84:	4585                	li	a1,1
    3a86:	f4100537          	lui	a0,0xf4100
    3a8a:	f76ff0ef          	jal	3200 <pllctl_get_pll_freq_in_hz>
    3a8e:	872a                	mv	a4,a0
    3a90:	47e2                	lw	a5,24(sp)
    3a92:	02f757b3          	divu	a5,a4,a5
    3a96:	ce3e                	sw	a5,28(sp)
        break;
    3a98:	a0ad                	j	3b02 <.L55>

00003a9a <.L50>:
        div = pllctl_get_div(HPM_PLLCTL, 2, 0);
    3a9a:	4601                	li	a2,0
    3a9c:	4589                	li	a1,2
    3a9e:	f4100537          	lui	a0,0xf4100
    3aa2:	a42fe0ef          	jal	1ce4 <pllctl_get_div>
    3aa6:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 2U) / div;
    3aa8:	4589                	li	a1,2
    3aaa:	f4100537          	lui	a0,0xf4100
    3aae:	f52ff0ef          	jal	3200 <pllctl_get_pll_freq_in_hz>
    3ab2:	872a                	mv	a4,a0
    3ab4:	47e2                	lw	a5,24(sp)
    3ab6:	02f757b3          	divu	a5,a4,a5
    3aba:	ce3e                	sw	a5,28(sp)
        break;
    3abc:	a099                	j	3b02 <.L55>

00003abe <.L49>:
        div = pllctl_get_div(HPM_PLLCTL, 2, 1);
    3abe:	4605                	li	a2,1
    3ac0:	4589                	li	a1,2
    3ac2:	f4100537          	lui	a0,0xf4100
    3ac6:	a1efe0ef          	jal	1ce4 <pllctl_get_div>
    3aca:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 2U) / div;
    3acc:	4589                	li	a1,2
    3ace:	f4100537          	lui	a0,0xf4100
    3ad2:	f2eff0ef          	jal	3200 <pllctl_get_pll_freq_in_hz>
    3ad6:	872a                	mv	a4,a0
    3ad8:	47e2                	lw	a5,24(sp)
    3ada:	02f757b3          	divu	a5,a4,a5
    3ade:	ce3e                	sw	a5,28(sp)
        break;
    3ae0:	a00d                	j	3b02 <.L55>

00003ae2 <.L48>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 3U);
    3ae2:	458d                	li	a1,3
    3ae4:	f4100537          	lui	a0,0xf4100
    3ae8:	f18ff0ef          	jal	3200 <pllctl_get_pll_freq_in_hz>
    3aec:	ce2a                	sw	a0,28(sp)
        break;
    3aee:	a811                	j	3b02 <.L55>

00003af0 <.L46>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 4U);
    3af0:	4591                	li	a1,4
    3af2:	f4100537          	lui	a0,0xf4100
    3af6:	f0aff0ef          	jal	3200 <pllctl_get_pll_freq_in_hz>
    3afa:	ce2a                	sw	a0,28(sp)
        break;
    3afc:	a019                	j	3b02 <.L55>

00003afe <.L45>:
        clk_freq = 0UL;
    3afe:	ce02                	sw	zero,28(sp)
        break;
    3b00:	0001                	nop

00003b02 <.L55>:
    return clk_freq;
    3b02:	47f2                	lw	a5,28(sp)
}
    3b04:	853e                	mv	a0,a5
    3b06:	50b2                	lw	ra,44(sp)
    3b08:	6145                	add	sp,sp,48
    3b0a:	8082                	ret

Disassembly of section .text.get_frequency_for_i2s_or_adc:

00003b0c <get_frequency_for_i2s_or_adc>:
{
    3b0c:	7139                	add	sp,sp,-64
    3b0e:	de06                	sw	ra,60(sp)
    3b10:	c62a                	sw	a0,12(sp)
    3b12:	c42e                	sw	a1,8(sp)
    uint32_t clk_freq = 0UL;
    3b14:	d602                	sw	zero,44(sp)
    bool is_mux_valid = false;
    3b16:	020105a3          	sb	zero,43(sp)
    clock_node_t node = clock_node_end;
    3b1a:	04b00793          	li	a5,75
    3b1e:	02f10523          	sb	a5,42(sp)
    if (clk_src_type == CLK_SRC_GROUP_ADC) {
    3b22:	4732                	lw	a4,12(sp)
    3b24:	4785                	li	a5,1
    3b26:	04f71363          	bne	a4,a5,3b6c <.L61>

00003b2a <.LBB7>:
        uint32_t adc_index = instance;
    3b2a:	47a2                	lw	a5,8(sp)
    3b2c:	ce3e                	sw	a5,28(sp)
        if (adc_index < ADC_INSTANCE_NUM) {
    3b2e:	4772                	lw	a4,28(sp)
    3b30:	478d                	li	a5,3
    3b32:	06e7ed63          	bltu	a5,a4,3bac <.L62>

00003b36 <.LBB8>:
            uint32_t mux_in_reg = SYSCTL_ADCCLK_MUX_GET(HPM_SYSCTL->ADCCLK[adc_index]);
    3b36:	f4000737          	lui	a4,0xf4000
    3b3a:	47f2                	lw	a5,28(sp)
    3b3c:	70078793          	add	a5,a5,1792
    3b40:	078a                	sll	a5,a5,0x2
    3b42:	97ba                	add	a5,a5,a4
    3b44:	439c                	lw	a5,0(a5)
    3b46:	83a1                	srl	a5,a5,0x8
    3b48:	8b9d                	and	a5,a5,7
    3b4a:	cc3e                	sw	a5,24(sp)
            if (mux_in_reg < ARRAY_SIZE(s_adc_clk_mux_node)) {
    3b4c:	4762                	lw	a4,24(sp)
    3b4e:	478d                	li	a5,3
    3b50:	04e7ee63          	bltu	a5,a4,3bac <.L62>
                node = s_adc_clk_mux_node[mux_in_reg];
    3b54:	92018713          	add	a4,gp,-1760 # 1c4 <s_adc_clk_mux_node>
    3b58:	47e2                	lw	a5,24(sp)
    3b5a:	97ba                	add	a5,a5,a4
    3b5c:	0007c783          	lbu	a5,0(a5)
    3b60:	02f10523          	sb	a5,42(sp)
                is_mux_valid = true;
    3b64:	4785                	li	a5,1
    3b66:	02f105a3          	sb	a5,43(sp)
    3b6a:	a089                	j	3bac <.L62>

00003b6c <.L61>:
        uint32_t i2s_index = instance;
    3b6c:	47a2                	lw	a5,8(sp)
    3b6e:	d23e                	sw	a5,36(sp)
        if (i2s_index < I2S_INSTANCE_NUM) {
    3b70:	5712                	lw	a4,36(sp)
    3b72:	478d                	li	a5,3
    3b74:	02e7ec63          	bltu	a5,a4,3bac <.L62>

00003b78 <.LBB10>:
            uint32_t mux_in_reg = SYSCTL_I2SCLK_MUX_GET(HPM_SYSCTL->I2SCLK[i2s_index]);
    3b78:	f4000737          	lui	a4,0xf4000
    3b7c:	5792                	lw	a5,36(sp)
    3b7e:	70478793          	add	a5,a5,1796
    3b82:	078a                	sll	a5,a5,0x2
    3b84:	97ba                	add	a5,a5,a4
    3b86:	439c                	lw	a5,0(a5)
    3b88:	83a1                	srl	a5,a5,0x8
    3b8a:	8b9d                	and	a5,a5,7
    3b8c:	d03e                	sw	a5,32(sp)
            if (mux_in_reg < ARRAY_SIZE(s_i2s_clk_mux_node)) {
    3b8e:	5702                	lw	a4,32(sp)
    3b90:	478d                	li	a5,3
    3b92:	00e7ed63          	bltu	a5,a4,3bac <.L62>
                node = s_i2s_clk_mux_node[mux_in_reg];
    3b96:	92418713          	add	a4,gp,-1756 # 1c8 <s_i2s_clk_mux_node>
    3b9a:	5782                	lw	a5,32(sp)
    3b9c:	97ba                	add	a5,a5,a4
    3b9e:	0007c783          	lbu	a5,0(a5)
    3ba2:	02f10523          	sb	a5,42(sp)
                is_mux_valid = true;
    3ba6:	4785                	li	a5,1
    3ba8:	02f105a3          	sb	a5,43(sp)

00003bac <.L62>:
    if (is_mux_valid) {
    3bac:	02b14783          	lbu	a5,43(sp)
    3bb0:	c38d                	beqz	a5,3bd2 <.L63>
        if (node == clock_node_ahb0) {
    3bb2:	02a14703          	lbu	a4,42(sp)
    3bb6:	479d                	li	a5,7
    3bb8:	00f71763          	bne	a4,a5,3bc6 <.L64>
            clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
    3bbc:	451d                	li	a0,7
    3bbe:	a54fe0ef          	jal	1e12 <get_frequency_for_ip_in_common_group>
    3bc2:	d62a                	sw	a0,44(sp)
    3bc4:	a039                	j	3bd2 <.L63>

00003bc6 <.L64>:
            clk_freq = get_frequency_for_ip_in_common_group(node);
    3bc6:	02a14783          	lbu	a5,42(sp)
    3bca:	853e                	mv	a0,a5
    3bcc:	a46fe0ef          	jal	1e12 <get_frequency_for_ip_in_common_group>
    3bd0:	d62a                	sw	a0,44(sp)

00003bd2 <.L63>:
    return clk_freq;
    3bd2:	57b2                	lw	a5,44(sp)
}
    3bd4:	853e                	mv	a0,a5
    3bd6:	50f2                	lw	ra,60(sp)
    3bd8:	6121                	add	sp,sp,64
    3bda:	8082                	ret

Disassembly of section .text.get_frequency_for_wdg:

00003bdc <get_frequency_for_wdg>:
{
    3bdc:	7179                	add	sp,sp,-48
    3bde:	d606                	sw	ra,44(sp)
    3be0:	c62a                	sw	a0,12(sp)
    if (WDG_CTRL_CLKSEL_GET(s_wdgs[instance]->CTRL) == 0) {
    3be2:	92818713          	add	a4,gp,-1752 # 1cc <s_wdgs>
    3be6:	47b2                	lw	a5,12(sp)
    3be8:	078a                	sll	a5,a5,0x2
    3bea:	97ba                	add	a5,a5,a4
    3bec:	439c                	lw	a5,0(a5)
    3bee:	4b9c                	lw	a5,16(a5)
    3bf0:	8b89                	and	a5,a5,2
    3bf2:	e791                	bnez	a5,3bfe <.L67>
        freq_in_hz = get_frequency_for_ip_in_common_group(clock_node_ahb0);
    3bf4:	451d                	li	a0,7
    3bf6:	a1cfe0ef          	jal	1e12 <get_frequency_for_ip_in_common_group>
    3bfa:	ce2a                	sw	a0,28(sp)
    3bfc:	a019                	j	3c02 <.L68>

00003bfe <.L67>:
        freq_in_hz = FREQ_32KHz;
    3bfe:	67a1                	lui	a5,0x8
    3c00:	ce3e                	sw	a5,28(sp)

00003c02 <.L68>:
    return freq_in_hz;
    3c02:	47f2                	lw	a5,28(sp)
}
    3c04:	853e                	mv	a0,a5
    3c06:	50b2                	lw	ra,44(sp)
    3c08:	6145                	add	sp,sp,48
    3c0a:	8082                	ret

Disassembly of section .text.get_frequency_for_pwdg:

00003c0c <get_frequency_for_pwdg>:
{
    3c0c:	1141                	add	sp,sp,-16
    if (WDG_CTRL_CLKSEL_GET(HPM_PWDG->CTRL) == 0) {
    3c0e:	f40e87b7          	lui	a5,0xf40e8
    3c12:	4b9c                	lw	a5,16(a5)
    3c14:	8b89                	and	a5,a5,2
    3c16:	e799                	bnez	a5,3c24 <.L71>
        freq_in_hz = FREQ_PRESET1_OSC0_CLK0;
    3c18:	016e37b7          	lui	a5,0x16e3
    3c1c:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
    3c20:	c63e                	sw	a5,12(sp)
    3c22:	a019                	j	3c28 <.L72>

00003c24 <.L71>:
        freq_in_hz = FREQ_32KHz;
    3c24:	67a1                	lui	a5,0x8
    3c26:	c63e                	sw	a5,12(sp)

00003c28 <.L72>:
    return freq_in_hz;
    3c28:	47b2                	lw	a5,12(sp)
}
    3c2a:	853e                	mv	a0,a5
    3c2c:	0141                	add	sp,sp,16
    3c2e:	8082                	ret

Disassembly of section .text.sysctl_enable_group_resource:

00003c30 <sysctl_enable_group_resource>:

hpm_stat_t sysctl_enable_group_resource(SYSCTL_Type *ptr,
                                        uint8_t group,
                                        sysctl_resource_t resource,
                                        bool enable)
{
    3c30:	7179                	add	sp,sp,-48
    3c32:	d606                	sw	ra,44(sp)
    3c34:	c62a                	sw	a0,12(sp)
    3c36:	87ae                	mv	a5,a1
    3c38:	8736                	mv	a4,a3
    3c3a:	00f105a3          	sb	a5,11(sp)
    3c3e:	87b2                	mv	a5,a2
    3c40:	00f11423          	sh	a5,8(sp)
    3c44:	87ba                	mv	a5,a4
    3c46:	00f10523          	sb	a5,10(sp)
    uint32_t index, offset;
    if (resource < sysctl_resource_linkable_start) {
    3c4a:	00815703          	lhu	a4,8(sp)
    3c4e:	0ff00793          	li	a5,255
    3c52:	00e7e463          	bltu	a5,a4,3c5a <.L60>
        return status_invalid_argument;
    3c56:	4789                	li	a5,2
    3c58:	a8e5                	j	3d50 <.L61>

00003c5a <.L60>:
    }

    index = (resource - sysctl_resource_linkable_start) / 32;
    3c5a:	00815783          	lhu	a5,8(sp)
    3c5e:	f0078793          	add	a5,a5,-256 # 7f00 <__ILM_segment_used_end__+0x26b8>
    3c62:	41f7d713          	sra	a4,a5,0x1f
    3c66:	8b7d                	and	a4,a4,31
    3c68:	97ba                	add	a5,a5,a4
    3c6a:	8795                	sra	a5,a5,0x5
    3c6c:	ce3e                	sw	a5,28(sp)
    offset = (resource - sysctl_resource_linkable_start) % 32;
    3c6e:	00815783          	lhu	a5,8(sp)
    3c72:	f0078713          	add	a4,a5,-256
    3c76:	41f75793          	sra	a5,a4,0x1f
    3c7a:	83ed                	srl	a5,a5,0x1b
    3c7c:	973e                	add	a4,a4,a5
    3c7e:	8b7d                	and	a4,a4,31
    3c80:	40f707b3          	sub	a5,a4,a5
    3c84:	cc3e                	sw	a5,24(sp)
    switch (group) {
    3c86:	00b14783          	lbu	a5,11(sp)
    3c8a:	c789                	beqz	a5,3c94 <.L62>
    3c8c:	4705                	li	a4,1
    3c8e:	04e78f63          	beq	a5,a4,3cec <.L63>
    3c92:	a84d                	j	3d44 <.L74>

00003c94 <.L62>:
    case SYSCTL_RESOURCE_GROUP0:
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset))
    3c94:	4732                	lw	a4,12(sp)
    3c96:	47f2                	lw	a5,28(sp)
    3c98:	08078793          	add	a5,a5,128
    3c9c:	0792                	sll	a5,a5,0x4
    3c9e:	97ba                	add	a5,a5,a4
    3ca0:	4398                	lw	a4,0(a5)
    3ca2:	47e2                	lw	a5,24(sp)
    3ca4:	4685                	li	a3,1
    3ca6:	00f697b3          	sll	a5,a3,a5
    3caa:	fff7c793          	not	a5,a5
    3cae:	8f7d                	and	a4,a4,a5
            | (enable ? (1UL << offset) : 0);
    3cb0:	00a14783          	lbu	a5,10(sp)
    3cb4:	c791                	beqz	a5,3cc0 <.L65>
    3cb6:	47e2                	lw	a5,24(sp)
    3cb8:	4685                	li	a3,1
    3cba:	00f697b3          	sll	a5,a3,a5
    3cbe:	a011                	j	3cc2 <.L66>

00003cc0 <.L65>:
    3cc0:	4781                	li	a5,0

00003cc2 <.L66>:
    3cc2:	8f5d                	or	a4,a4,a5
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset))
    3cc4:	46b2                	lw	a3,12(sp)
    3cc6:	47f2                	lw	a5,28(sp)
    3cc8:	08078793          	add	a5,a5,128
    3ccc:	0792                	sll	a5,a5,0x4
    3cce:	97b6                	add	a5,a5,a3
    3cd0:	c398                	sw	a4,0(a5)
        if (enable) {
    3cd2:	00a14783          	lbu	a5,10(sp)
    3cd6:	cbad                	beqz	a5,3d48 <.L75>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
    3cd8:	0001                	nop

00003cda <.L68>:
    3cda:	00815783          	lhu	a5,8(sp)
    3cde:	85be                	mv	a1,a5
    3ce0:	4532                	lw	a0,12(sp)
    3ce2:	a0cfe0ef          	jal	1eee <sysctl_resource_target_is_busy>
    3ce6:	87aa                	mv	a5,a0
    3ce8:	fbed                	bnez	a5,3cda <.L68>
                ;
            }
        }
        break;
    3cea:	a8b9                	j	3d48 <.L75>

00003cec <.L63>:
    case SYSCTL_RESOURCE_GROUP1:
        ptr->GROUP1[index].VALUE = (ptr->GROUP1[index].VALUE & ~(1UL << offset))
    3cec:	4732                	lw	a4,12(sp)
    3cee:	47f2                	lw	a5,28(sp)
    3cf0:	08478793          	add	a5,a5,132
    3cf4:	0792                	sll	a5,a5,0x4
    3cf6:	97ba                	add	a5,a5,a4
    3cf8:	4398                	lw	a4,0(a5)
    3cfa:	47e2                	lw	a5,24(sp)
    3cfc:	4685                	li	a3,1
    3cfe:	00f697b3          	sll	a5,a3,a5
    3d02:	fff7c793          	not	a5,a5
    3d06:	8f7d                	and	a4,a4,a5
            | (enable ? (1UL << offset) : 0);
    3d08:	00a14783          	lbu	a5,10(sp)
    3d0c:	c791                	beqz	a5,3d18 <.L70>
    3d0e:	47e2                	lw	a5,24(sp)
    3d10:	4685                	li	a3,1
    3d12:	00f697b3          	sll	a5,a3,a5
    3d16:	a011                	j	3d1a <.L71>

00003d18 <.L70>:
    3d18:	4781                	li	a5,0

00003d1a <.L71>:
    3d1a:	8f5d                	or	a4,a4,a5
        ptr->GROUP1[index].VALUE = (ptr->GROUP1[index].VALUE & ~(1UL << offset))
    3d1c:	46b2                	lw	a3,12(sp)
    3d1e:	47f2                	lw	a5,28(sp)
    3d20:	08478793          	add	a5,a5,132
    3d24:	0792                	sll	a5,a5,0x4
    3d26:	97b6                	add	a5,a5,a3
    3d28:	c398                	sw	a4,0(a5)
        if (enable) {
    3d2a:	00a14783          	lbu	a5,10(sp)
    3d2e:	cf99                	beqz	a5,3d4c <.L76>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
    3d30:	0001                	nop

00003d32 <.L73>:
    3d32:	00815783          	lhu	a5,8(sp)
    3d36:	85be                	mv	a1,a5
    3d38:	4532                	lw	a0,12(sp)
    3d3a:	9b4fe0ef          	jal	1eee <sysctl_resource_target_is_busy>
    3d3e:	87aa                	mv	a5,a0
    3d40:	fbed                	bnez	a5,3d32 <.L73>
                ;
            }
        }
        break;
    3d42:	a029                	j	3d4c <.L76>

00003d44 <.L74>:
    default:
        return status_invalid_argument;
    3d44:	4789                	li	a5,2
    3d46:	a029                	j	3d50 <.L61>

00003d48 <.L75>:
        break;
    3d48:	0001                	nop
    3d4a:	a011                	j	3d4e <.L69>

00003d4c <.L76>:
        break;
    3d4c:	0001                	nop

00003d4e <.L69>:
    }

    return status_success;
    3d4e:	4781                	li	a5,0

00003d50 <.L61>:
}
    3d50:	853e                	mv	a0,a5
    3d52:	50b2                	lw	ra,44(sp)
    3d54:	6145                	add	sp,sp,48
    3d56:	8082                	ret

Disassembly of section .text.enable_plic_feature:

00003d58 <enable_plic_feature>:
{
    3d58:	1141                	add	sp,sp,-16
    uint32_t plic_feature = 0;
    3d5a:	c602                	sw	zero,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_VECTORED_MODE;
    3d5c:	47b2                	lw	a5,12(sp)
    3d5e:	0027e793          	or	a5,a5,2
    3d62:	c63e                	sw	a5,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_PREEMPTIVE_PRIORITY_IRQ;
    3d64:	47b2                	lw	a5,12(sp)
    3d66:	0017e793          	or	a5,a5,1
    3d6a:	c63e                	sw	a5,12(sp)
    3d6c:	e40007b7          	lui	a5,0xe4000
    3d70:	c43e                	sw	a5,8(sp)
    3d72:	47b2                	lw	a5,12(sp)
    3d74:	c23e                	sw	a5,4(sp)

00003d76 <.LBB14>:
 * @param[in] feature Specific feature to be set
 *
 */
ATTR_ALWAYS_INLINE static inline void __plic_set_feature(uint32_t base, uint32_t feature)
{
    *(volatile uint32_t *)(base + HPM_PLIC_FEATURE_OFFSET) = feature;
    3d76:	47a2                	lw	a5,8(sp)
    3d78:	4712                	lw	a4,4(sp)
    3d7a:	c398                	sw	a4,0(a5)
}
    3d7c:	0001                	nop

00003d7e <.LBE14>:
}
    3d7e:	0001                	nop
    3d80:	0141                	add	sp,sp,16
    3d82:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_puts_no_nl:

00003d84 <__SEGGER_RTL_puts_no_nl>:
    3d84:	1101                	add	sp,sp,-32
    3d86:	cc22                	sw	s0,24(sp)
    3d88:	84822403          	lw	s0,-1976(tp) # fffff848 <__SHARE_RAM_segment_end__+0xfee7f848>
    3d8c:	ce06                	sw	ra,28(sp)
    3d8e:	c62a                	sw	a0,12(sp)
    3d90:	319000ef          	jal	48a8 <strlen>
    3d94:	862a                	mv	a2,a0
    3d96:	8522                	mv	a0,s0
    3d98:	4462                	lw	s0,24(sp)
    3d9a:	45b2                	lw	a1,12(sp)
    3d9c:	40f2                	lw	ra,28(sp)
    3d9e:	6105                	add	sp,sp,32
    3da0:	bd6ff06f          	j	3176 <__SEGGER_RTL_X_file_write>

Disassembly of section .text.libc.signal:

00003da4 <signal>:
    3da4:	4795                	li	a5,5
    3da6:	02a7e263          	bltu	a5,a0,3dca <.L18>
    3daa:	81420693          	add	a3,tp,-2028 # fffff814 <__SHARE_RAM_segment_end__+0xfee7f814>
    3dae:	00251793          	sll	a5,a0,0x2
    3db2:	96be                	add	a3,a3,a5
    3db4:	4288                	lw	a0,0(a3)
    3db6:	81420713          	add	a4,tp,-2028 # fffff814 <__SHARE_RAM_segment_end__+0xfee7f814>
    3dba:	e509                	bnez	a0,3dc4 <.L17>
    3dbc:	00000537          	lui	a0,0x0
    3dc0:	07650513          	add	a0,a0,118 # 76 <__SEGGER_RTL_SIGNAL_SIG_DFL>

00003dc4 <.L17>:
    3dc4:	973e                	add	a4,a4,a5
    3dc6:	c30c                	sw	a1,0(a4)
    3dc8:	8082                	ret

00003dca <.L18>:
    3dca:	00000537          	lui	a0,0x0
    3dce:	70250513          	add	a0,a0,1794 # 702 <__SEGGER_RTL_SIGNAL_SIG_ERR>
    3dd2:	8082                	ret

Disassembly of section .text.libc.raise:

00003dd4 <raise>:
    3dd4:	1141                	add	sp,sp,-16
    3dd6:	c04a                	sw	s2,0(sp)
    3dd8:	00000937          	lui	s2,0x0
    3ddc:	1fe90593          	add	a1,s2,510 # 1fe <__SEGGER_RTL_SIGNAL_SIG_IGN>
    3de0:	c226                	sw	s1,4(sp)
    3de2:	c606                	sw	ra,12(sp)
    3de4:	c422                	sw	s0,8(sp)
    3de6:	84aa                	mv	s1,a0
    3de8:	3f75                	jal	3da4 <signal>
    3dea:	000007b7          	lui	a5,0x0
    3dee:	70278793          	add	a5,a5,1794 # 702 <__SEGGER_RTL_SIGNAL_SIG_ERR>
    3df2:	02f50d63          	beq	a0,a5,3e2c <.L24>
    3df6:	1fe90913          	add	s2,s2,510
    3dfa:	842a                	mv	s0,a0
    3dfc:	03250163          	beq	a0,s2,3e1e <.L22>
    3e00:	000005b7          	lui	a1,0x0
    3e04:	07658793          	add	a5,a1,118 # 76 <__SEGGER_RTL_SIGNAL_SIG_DFL>
    3e08:	00f51563          	bne	a0,a5,3e12 <.L23>
    3e0c:	4505                	li	a0,1
    3e0e:	a5cfc0ef          	jal	6a <exit>

00003e12 <.L23>:
    3e12:	07658593          	add	a1,a1,118
    3e16:	8526                	mv	a0,s1
    3e18:	3771                	jal	3da4 <signal>
    3e1a:	8526                	mv	a0,s1
    3e1c:	9402                	jalr	s0

00003e1e <.L22>:
    3e1e:	4501                	li	a0,0

00003e20 <.L20>:
    3e20:	40b2                	lw	ra,12(sp)
    3e22:	4422                	lw	s0,8(sp)
    3e24:	4492                	lw	s1,4(sp)
    3e26:	4902                	lw	s2,0(sp)
    3e28:	0141                	add	sp,sp,16
    3e2a:	8082                	ret

00003e2c <.L24>:
    3e2c:	557d                	li	a0,-1
    3e2e:	bfcd                	j	3e20 <.L20>

Disassembly of section .text.libc.abort:

00003e30 <abort>:
    3e30:	1141                	add	sp,sp,-16
    3e32:	c606                	sw	ra,12(sp)

00003e34 <.L27>:
    3e34:	4501                	li	a0,0
    3e36:	3f79                	jal	3dd4 <raise>
    3e38:	bff5                	j	3e34 <.L27>

Disassembly of section .text.libc.__SEGGER_RTL_X_assert:

00003e3a <__SEGGER_RTL_X_assert>:
    3e3a:	1101                	add	sp,sp,-32
    3e3c:	cc22                	sw	s0,24(sp)
    3e3e:	ca26                	sw	s1,20(sp)
    3e40:	842a                	mv	s0,a0
    3e42:	84ae                	mv	s1,a1
    3e44:	8532                	mv	a0,a2
    3e46:	858a                	mv	a1,sp
    3e48:	4629                	li	a2,10
    3e4a:	ce06                	sw	ra,28(sp)
    3e4c:	990fe0ef          	jal	1fdc <itoa>
    3e50:	8526                	mv	a0,s1
    3e52:	3f0d                	jal	3d84 <__SEGGER_RTL_puts_no_nl>
    3e54:	00001537          	lui	a0,0x1
    3e58:	43c50513          	add	a0,a0,1084 # 143c <.LC0>
    3e5c:	3725                	jal	3d84 <__SEGGER_RTL_puts_no_nl>
    3e5e:	850a                	mv	a0,sp
    3e60:	3715                	jal	3d84 <__SEGGER_RTL_puts_no_nl>
    3e62:	00001537          	lui	a0,0x1
    3e66:	44050513          	add	a0,a0,1088 # 1440 <.LC1>
    3e6a:	3f29                	jal	3d84 <__SEGGER_RTL_puts_no_nl>
    3e6c:	8522                	mv	a0,s0
    3e6e:	3f19                	jal	3d84 <__SEGGER_RTL_puts_no_nl>
    3e70:	00001537          	lui	a0,0x1
    3e74:	45850513          	add	a0,a0,1112 # 1458 <.LC2>
    3e78:	3731                	jal	3d84 <__SEGGER_RTL_puts_no_nl>
    3e7a:	3f5d                	jal	3e30 <abort>

Disassembly of section .text.libc.__adddf3:

00003e7c <__adddf3>:
    3e7c:	800007b7          	lui	a5,0x80000
    3e80:	00d5c8b3          	xor	a7,a1,a3
    3e84:	1008c263          	bltz	a7,3f88 <.L__adddf3_subtract>
    3e88:	00b6e863          	bltu	a3,a1,3e98 <.L__adddf3_add_already_ordered>
    3e8c:	8d31                	xor	a0,a0,a2
    3e8e:	8e29                	xor	a2,a2,a0
    3e90:	8d31                	xor	a0,a0,a2
    3e92:	8db5                	xor	a1,a1,a3
    3e94:	8ead                	xor	a3,a3,a1
    3e96:	8db5                	xor	a1,a1,a3

00003e98 <.L__adddf3_add_already_ordered>:
    3e98:	00159813          	sll	a6,a1,0x1
    3e9c:	01585813          	srl	a6,a6,0x15
    3ea0:	00169893          	sll	a7,a3,0x1
    3ea4:	0158d893          	srl	a7,a7,0x15
    3ea8:	0c088063          	beqz	a7,3f68 <.L__adddf3_add_zero>
    3eac:	00180713          	add	a4,a6,1
    3eb0:	0756                	sll	a4,a4,0x15
    3eb2:	c759                	beqz	a4,3f40 <.L__adddf3_done>
    3eb4:	41180733          	sub	a4,a6,a7
    3eb8:	03500293          	li	t0,53
    3ebc:	08e2e263          	bltu	t0,a4,3f40 <.L__adddf3_done>
    3ec0:	0145d813          	srl	a6,a1,0x14
    3ec4:	06ae                	sll	a3,a3,0xb
    3ec6:	8edd                	or	a3,a3,a5
    3ec8:	82ad                	srl	a3,a3,0xb
    3eca:	05ae                	sll	a1,a1,0xb
    3ecc:	8ddd                	or	a1,a1,a5
    3ece:	85ad                	sra	a1,a1,0xb
    3ed0:	02000293          	li	t0,32
    3ed4:	06577763          	bgeu	a4,t0,3f42 <.L__adddf3_add_shifted_word>
    3ed8:	4881                	li	a7,0
    3eda:	cf01                	beqz	a4,3ef2 <.L__adddf3_add_no_shift>
    3edc:	40e002b3          	neg	t0,a4
    3ee0:	005618b3          	sll	a7,a2,t0
    3ee4:	00e65633          	srl	a2,a2,a4
    3ee8:	005692b3          	sll	t0,a3,t0
    3eec:	9616                	add	a2,a2,t0
    3eee:	00e6d6b3          	srl	a3,a3,a4

00003ef2 <.L__adddf3_add_no_shift>:
    3ef2:	9532                	add	a0,a0,a2
    3ef4:	00c532b3          	sltu	t0,a0,a2
    3ef8:	95b6                	add	a1,a1,a3
    3efa:	00d5b333          	sltu	t1,a1,a3
    3efe:	9596                	add	a1,a1,t0
    3f00:	00031463          	bnez	t1,3f08 <.L__adddf3_normalization_required>
    3f04:	0255f163          	bgeu	a1,t0,3f26 <.L__adddf3_already_normalized>

00003f08 <.L__adddf3_normalization_required>:
    3f08:	00280613          	add	a2,a6,2
    3f0c:	0656                	sll	a2,a2,0x15
    3f0e:	c235                	beqz	a2,3f72 <.L__adddf3_inf>
    3f10:	01f51613          	sll	a2,a0,0x1f
    3f14:	011032b3          	snez	t0,a7
    3f18:	005608b3          	add	a7,a2,t0
    3f1c:	8105                	srl	a0,a0,0x1
    3f1e:	01f59693          	sll	a3,a1,0x1f
    3f22:	8d55                	or	a0,a0,a3
    3f24:	8185                	srl	a1,a1,0x1

00003f26 <.L__adddf3_already_normalized>:
    3f26:	0805                	add	a6,a6,1
    3f28:	0852                	sll	a6,a6,0x14

00003f2a <.L__adddf3_perform_rounding>:
    3f2a:	0008da63          	bgez	a7,3f3e <.L__adddf3_add_no_tie>
    3f2e:	0505                	add	a0,a0,1
    3f30:	00153293          	seqz	t0,a0
    3f34:	9596                	add	a1,a1,t0
    3f36:	0886                	sll	a7,a7,0x1
    3f38:	00089363          	bnez	a7,3f3e <.L__adddf3_add_no_tie>
    3f3c:	9979                	and	a0,a0,-2

00003f3e <.L__adddf3_add_no_tie>:
    3f3e:	95c2                	add	a1,a1,a6

00003f40 <.L__adddf3_done>:
    3f40:	8082                	ret

00003f42 <.L__adddf3_add_shifted_word>:
    3f42:	88b2                	mv	a7,a2
    3f44:	1701                	add	a4,a4,-32 # f3ffffe0 <__SHARE_RAM_segment_end__+0xf2e7ffe0>
    3f46:	cb11                	beqz	a4,3f5a <.L__adddf3_already_aligned>
    3f48:	40e008b3          	neg	a7,a4
    3f4c:	011698b3          	sll	a7,a3,a7
    3f50:	00e6d6b3          	srl	a3,a3,a4
    3f54:	00c03733          	snez	a4,a2
    3f58:	98ba                	add	a7,a7,a4

00003f5a <.L__adddf3_already_aligned>:
    3f5a:	9536                	add	a0,a0,a3
    3f5c:	00d532b3          	sltu	t0,a0,a3
    3f60:	9596                	add	a1,a1,t0
    3f62:	fc55f2e3          	bgeu	a1,t0,3f26 <.L__adddf3_already_normalized>
    3f66:	b74d                	j	3f08 <.L__adddf3_normalization_required>

00003f68 <.L__adddf3_add_zero>:
    3f68:	fc081ce3          	bnez	a6,3f40 <.L__adddf3_done>
    3f6c:	8dfd                	and	a1,a1,a5
    3f6e:	4501                	li	a0,0
    3f70:	bfc1                	j	3f40 <.L__adddf3_done>

00003f72 <.L__adddf3_inf>:
    3f72:	0805                	add	a6,a6,1
    3f74:	01481593          	sll	a1,a6,0x14
    3f78:	4501                	li	a0,0
    3f7a:	b7d9                	j	3f40 <.L__adddf3_done>

00003f7c <.L__adddf3_sub_inf_nan>:
    3f7c:	fce892e3          	bne	a7,a4,3f40 <.L__adddf3_done>
    3f80:	7ff805b7          	lui	a1,0x7ff80
    3f84:	4501                	li	a0,0
    3f86:	bf6d                	j	3f40 <.L__adddf3_done>

00003f88 <.L__adddf3_subtract>:
    3f88:	8ebd                	xor	a3,a3,a5
    3f8a:	00b6ed63          	bltu	a3,a1,3fa4 <.L__adddf3_sub_already_ordered>
    3f8e:	00b69463          	bne	a3,a1,3f96 <.L__adddf3_sub_must_exchange>
    3f92:	00a66963          	bltu	a2,a0,3fa4 <.L__adddf3_sub_already_ordered>

00003f96 <.L__adddf3_sub_must_exchange>:
    3f96:	8ebd                	xor	a3,a3,a5
    3f98:	8d31                	xor	a0,a0,a2
    3f9a:	8e29                	xor	a2,a2,a0
    3f9c:	8d31                	xor	a0,a0,a2
    3f9e:	8db5                	xor	a1,a1,a3
    3fa0:	8ead                	xor	a3,a3,a1
    3fa2:	8db5                	xor	a1,a1,a3

00003fa4 <.L__adddf3_sub_already_ordered>:
    3fa4:	00b58833          	add	a6,a1,a1
    3fa8:	00d688b3          	add	a7,a3,a3
    3fac:	ffe00737          	lui	a4,0xffe00
    3fb0:	fce876e3          	bgeu	a6,a4,3f7c <.L__adddf3_sub_inf_nan>
    3fb4:	01585813          	srl	a6,a6,0x15
    3fb8:	0158d893          	srl	a7,a7,0x15
    3fbc:	0a088f63          	beqz	a7,407a <.L__adddf3_subtracting_zero>
    3fc0:	41180733          	sub	a4,a6,a7
    3fc4:	03600293          	li	t0,54
    3fc8:	f6e2ece3          	bltu	t0,a4,3f40 <.L__adddf3_done>
    3fcc:	83c2                	mv	t2,a6
    3fce:	0145d813          	srl	a6,a1,0x14
    3fd2:	06ae                	sll	a3,a3,0xb
    3fd4:	8edd                	or	a3,a3,a5
    3fd6:	82ad                	srl	a3,a3,0xb
    3fd8:	05ae                	sll	a1,a1,0xb
    3fda:	8ddd                	or	a1,a1,a5
    3fdc:	81ad                	srl	a1,a1,0xb
    3fde:	4285                	li	t0,1
    3fe0:	0ae2ef63          	bltu	t0,a4,409e <.L__adddf3_sub_align_far>
    3fe4:	00571a63          	bne	a4,t0,3ff8 <.L__adddf3_sub_already_aligned>
    3fe8:	01f61713          	sll	a4,a2,0x1f
    3fec:	8205                	srl	a2,a2,0x1
    3fee:	01f69893          	sll	a7,a3,0x1f
    3ff2:	01166633          	or	a2,a2,a7
    3ff6:	8285                	srl	a3,a3,0x1

00003ff8 <.L__adddf3_sub_already_aligned>:
    3ff8:	82aa                	mv	t0,a0
    3ffa:	8d11                	sub	a0,a0,a2
    3ffc:	00a2b2b3          	sltu	t0,t0,a0
    4000:	8d95                	sub	a1,a1,a3
    4002:	405585b3          	sub	a1,a1,t0
    4006:	c711                	beqz	a4,4012 <.L__adddf3_sub_single_done>
    4008:	00153293          	seqz	t0,a0
    400c:	157d                	add	a0,a0,-1
    400e:	405585b3          	sub	a1,a1,t0

00004012 <.L__adddf3_sub_single_done>:
    4012:	c9ad                	beqz	a1,4084 <.L__adddf3_high_word_cancelled>
    4014:	00b59293          	sll	t0,a1,0xb
    4018:	1202ca63          	bltz	t0,414c <.L__adddf3_sub_normalized>

0000401c <.L__adddf3_first_normalization_step>:
    401c:	000522b3          	sltz	t0,a0
    4020:	952a                	add	a0,a0,a0
    4022:	95ae                	add	a1,a1,a1
    4024:	9596                	add	a1,a1,t0
    4026:	837d                	srl	a4,a4,0x1f
    4028:	953a                	add	a0,a0,a4
    402a:	4705                	li	a4,1

0000402c <.L__adddf3_try_shift_4>:
    402c:	0115d293          	srl	t0,a1,0x11
    4030:	00029963          	bnez	t0,4042 <.L__adddf3_cant_shift_4>
    4034:	0711                	add	a4,a4,4 # ffe00004 <__SHARE_RAM_segment_end__+0xfec80004>
    4036:	0592                	sll	a1,a1,0x4
    4038:	01c55293          	srl	t0,a0,0x1c
    403c:	0512                	sll	a0,a0,0x4
    403e:	9596                	add	a1,a1,t0
    4040:	b7f5                	j	402c <.L__adddf3_try_shift_4>

00004042 <.L__adddf3_cant_shift_4>:
    4042:	00b59293          	sll	t0,a1,0xb
    4046:	0002cc63          	bltz	t0,405e <.L__adddf3_normalized>

0000404a <.L__adddf3_normalize>:
    404a:	0705                	add	a4,a4,1
    404c:	000522b3          	sltz	t0,a0
    4050:	952a                	add	a0,a0,a0
    4052:	95ae                	add	a1,a1,a1
    4054:	9596                	add	a1,a1,t0

00004056 <.L__adddf3_pre_normalize>:
    4056:	00b59293          	sll	t0,a1,0xb
    405a:	fe02d8e3          	bgez	t0,404a <.L__adddf3_normalize>

0000405e <.L__adddf3_normalized>:
    405e:	861e                	mv	a2,t2
    4060:	00c77863          	bgeu	a4,a2,4070 <.L__adddf3_signed_zero>
    4064:	40e80833          	sub	a6,a6,a4
    4068:	187d                	add	a6,a6,-1
    406a:	0852                	sll	a6,a6,0x14
    406c:	95c2                	add	a1,a1,a6
    406e:	bdc9                	j	3f40 <.L__adddf3_done>

00004070 <.L__adddf3_signed_zero>:
    4070:	00b85593          	srl	a1,a6,0xb
    4074:	05fe                	sll	a1,a1,0x1f
    4076:	4501                	li	a0,0
    4078:	b5e1                	j	3f40 <.L__adddf3_done>

0000407a <.L__adddf3_subtracting_zero>:
    407a:	ec0813e3          	bnez	a6,3f40 <.L__adddf3_done>
    407e:	4501                	li	a0,0
    4080:	4581                	li	a1,0
    4082:	bd7d                	j	3f40 <.L__adddf3_done>

00004084 <.L__adddf3_high_word_cancelled>:
    4084:	00e56633          	or	a2,a0,a4
    4088:	ea060ce3          	beqz	a2,3f40 <.L__adddf3_done>
    408c:	001008b7          	lui	a7,0x100
    4090:	f91576e3          	bgeu	a0,a7,401c <.L__adddf3_first_normalization_step>
    4094:	85aa                	mv	a1,a0
    4096:	853a                	mv	a0,a4
    4098:	02000713          	li	a4,32
    409c:	bf6d                	j	4056 <.L__adddf3_pre_normalize>

0000409e <.L__adddf3_sub_align_far>:
    409e:	02000293          	li	t0,32
    40a2:	04574863          	blt	a4,t0,40f2 <.L__adddf3_aligned_on_top>
    40a6:	04570263          	beq	a4,t0,40ea <.L__adddf3_word_aligned_on_top>
    40aa:	1701                	add	a4,a4,-32
    40ac:	40e002b3          	neg	t0,a4
    40b0:	00e65333          	srl	t1,a2,a4
    40b4:	005618b3          	sll	a7,a2,t0
    40b8:	00569633          	sll	a2,a3,t0
    40bc:	961a                	add	a2,a2,t1
    40be:	00e6d6b3          	srl	a3,a3,a4
    40c2:	011038b3          	snez	a7,a7
    40c6:	00c8e8b3          	or	a7,a7,a2
    40ca:	4601                	li	a2,0
    40cc:	82aa                	mv	t0,a0
    40ce:	8d15                	sub	a0,a0,a3
    40d0:	00a2b2b3          	sltu	t0,t0,a0
    40d4:	405585b3          	sub	a1,a1,t0
    40d8:	41100733          	neg	a4,a7
    40dc:	c729                	beqz	a4,4126 <.L__adddf3_sub_normalize>
    40de:	00153293          	seqz	t0,a0
    40e2:	157d                	add	a0,a0,-1
    40e4:	405585b3          	sub	a1,a1,t0
    40e8:	a83d                	j	4126 <.L__adddf3_sub_normalize>

000040ea <.L__adddf3_word_aligned_on_top>:
    40ea:	88b2                	mv	a7,a2
    40ec:	8636                	mv	a2,a3
    40ee:	4681                	li	a3,0
    40f0:	a821                	j	4108 <.L__adddf3_aligned_subtract>

000040f2 <.L__adddf3_aligned_on_top>:
    40f2:	40e002b3          	neg	t0,a4
    40f6:	00e65333          	srl	t1,a2,a4
    40fa:	005618b3          	sll	a7,a2,t0
    40fe:	00569633          	sll	a2,a3,t0
    4102:	961a                	add	a2,a2,t1
    4104:	00e6d6b3          	srl	a3,a3,a4

00004108 <.L__adddf3_aligned_subtract>:
    4108:	82aa                	mv	t0,a0
    410a:	8d11                	sub	a0,a0,a2
    410c:	00a2b2b3          	sltu	t0,t0,a0
    4110:	8d95                	sub	a1,a1,a3
    4112:	405585b3          	sub	a1,a1,t0
    4116:	41100733          	neg	a4,a7
    411a:	c711                	beqz	a4,4126 <.L__adddf3_sub_normalize>
    411c:	00153293          	seqz	t0,a0
    4120:	157d                	add	a0,a0,-1
    4122:	405585b3          	sub	a1,a1,t0

00004126 <.L__adddf3_sub_normalize>:
    4126:	00c59893          	sll	a7,a1,0xc
    412a:	00b59293          	sll	t0,a1,0xb
    412e:	0002cf63          	bltz	t0,414c <.L__adddf3_sub_normalized>
    4132:	187d                	add	a6,a6,-1
    4134:	000522b3          	sltz	t0,a0
    4138:	952a                	add	a0,a0,a0
    413a:	95ae                	add	a1,a1,a1
    413c:	9596                	add	a1,a1,t0
    413e:	000722b3          	sltz	t0,a4
    4142:	973a                	add	a4,a4,a4
    4144:	9516                	add	a0,a0,t0
    4146:	005532b3          	sltu	t0,a0,t0
    414a:	9596                	add	a1,a1,t0

0000414c <.L__adddf3_sub_normalized>:
    414c:	187d                	add	a6,a6,-1
    414e:	0852                	sll	a6,a6,0x14
    4150:	88ba                	mv	a7,a4
    4152:	bbe1                	j	3f2a <.L__adddf3_perform_rounding>

Disassembly of section .text.libc.__mulsf3:

00004154 <__mulsf3>:
    4154:	80000737          	lui	a4,0x80000
    4158:	0ff00293          	li	t0,255
    415c:	00b547b3          	xor	a5,a0,a1
    4160:	8ff9                	and	a5,a5,a4
    4162:	00151613          	sll	a2,a0,0x1
    4166:	8261                	srl	a2,a2,0x18
    4168:	00159693          	sll	a3,a1,0x1
    416c:	82e1                	srl	a3,a3,0x18
    416e:	ce29                	beqz	a2,41c8 <.L__mulsf3_lhs_zero_or_subnormal>
    4170:	c6bd                	beqz	a3,41de <.L__mulsf3_rhs_zero_or_subnormal>
    4172:	04560f63          	beq	a2,t0,41d0 <.L__mulsf3_lhs_inf_or_nan>
    4176:	06568963          	beq	a3,t0,41e8 <.L__mulsf3_rhs_inf_or_nan>
    417a:	9636                	add	a2,a2,a3
    417c:	0522                	sll	a0,a0,0x8
    417e:	8d59                	or	a0,a0,a4
    4180:	05a2                	sll	a1,a1,0x8
    4182:	8dd9                	or	a1,a1,a4
    4184:	02b506b3          	mul	a3,a0,a1
    4188:	02b53533          	mulhu	a0,a0,a1
    418c:	00d036b3          	snez	a3,a3
    4190:	8d55                	or	a0,a0,a3
    4192:	00054463          	bltz	a0,419a <.L__mulsf3_normalized>
    4196:	0506                	sll	a0,a0,0x1
    4198:	167d                	add	a2,a2,-1

0000419a <.L__mulsf3_normalized>:
    419a:	f8160613          	add	a2,a2,-127
    419e:	04064863          	bltz	a2,41ee <.L__mulsf3_zero_or_underflow>
    41a2:	12fd                	add	t0,t0,-1 # bffff <__heap_end__+0x3bfff>
    41a4:	00565f63          	bge	a2,t0,41c2 <.L__mulsf3_inf>
    41a8:	01851693          	sll	a3,a0,0x18
    41ac:	8121                	srl	a0,a0,0x8
    41ae:	065e                	sll	a2,a2,0x17
    41b0:	9532                	add	a0,a0,a2
    41b2:	0006d663          	bgez	a3,41be <.L__mulsf3_apply_sign>
    41b6:	0505                	add	a0,a0,1
    41b8:	0686                	sll	a3,a3,0x1
    41ba:	e291                	bnez	a3,41be <.L__mulsf3_apply_sign>
    41bc:	9979                	and	a0,a0,-2

000041be <.L__mulsf3_apply_sign>:
    41be:	8d5d                	or	a0,a0,a5
    41c0:	8082                	ret

000041c2 <.L__mulsf3_inf>:
    41c2:	7f800537          	lui	a0,0x7f800
    41c6:	bfe5                	j	41be <.L__mulsf3_apply_sign>

000041c8 <.L__mulsf3_lhs_zero_or_subnormal>:
    41c8:	00568d63          	beq	a3,t0,41e2 <.L__mulsf3_nan>

000041cc <.L__mulsf3_signed_zero>:
    41cc:	853e                	mv	a0,a5
    41ce:	8082                	ret

000041d0 <.L__mulsf3_lhs_inf_or_nan>:
    41d0:	0526                	sll	a0,a0,0x9
    41d2:	e901                	bnez	a0,41e2 <.L__mulsf3_nan>
    41d4:	fe5697e3          	bne	a3,t0,41c2 <.L__mulsf3_inf>
    41d8:	05a6                	sll	a1,a1,0x9
    41da:	e581                	bnez	a1,41e2 <.L__mulsf3_nan>
    41dc:	b7dd                	j	41c2 <.L__mulsf3_inf>

000041de <.L__mulsf3_rhs_zero_or_subnormal>:
    41de:	fe5617e3          	bne	a2,t0,41cc <.L__mulsf3_signed_zero>

000041e2 <.L__mulsf3_nan>:
    41e2:	7fc00537          	lui	a0,0x7fc00
    41e6:	8082                	ret

000041e8 <.L__mulsf3_rhs_inf_or_nan>:
    41e8:	05a6                	sll	a1,a1,0x9
    41ea:	fde5                	bnez	a1,41e2 <.L__mulsf3_nan>
    41ec:	bfd9                	j	41c2 <.L__mulsf3_inf>

000041ee <.L__mulsf3_zero_or_underflow>:
    41ee:	0605                	add	a2,a2,1
    41f0:	fe71                	bnez	a2,41cc <.L__mulsf3_signed_zero>
    41f2:	8521                	sra	a0,a0,0x8
    41f4:	00150293          	add	t0,a0,1 # 7fc00001 <__SHARE_RAM_segment_end__+0x7ea80001>
    41f8:	0509                	add	a0,a0,2
    41fa:	fc0299e3          	bnez	t0,41cc <.L__mulsf3_signed_zero>
    41fe:	00800537          	lui	a0,0x800
    4202:	bf75                	j	41be <.L__mulsf3_apply_sign>

Disassembly of section .text.libc.__muldf3:

00004204 <__muldf3>:
    4204:	800008b7          	lui	a7,0x80000
    4208:	00d5c833          	xor	a6,a1,a3
    420c:	01187eb3          	and	t4,a6,a7
    4210:	00b58733          	add	a4,a1,a1
    4214:	00d687b3          	add	a5,a3,a3
    4218:	ffe00837          	lui	a6,0xffe00
    421c:	0d077363          	bgeu	a4,a6,42e2 <.L__muldf3_lhs_nan_or_inf>
    4220:	0d07ff63          	bgeu	a5,a6,42fe <.L__muldf3_rhs_nan_or_inf>
    4224:	8355                	srl	a4,a4,0x15
    4226:	c76d                	beqz	a4,4310 <.L__muldf3_signed_zero>
    4228:	83d5                	srl	a5,a5,0x15
    422a:	c3fd                	beqz	a5,4310 <.L__muldf3_signed_zero>
    422c:	06ae                	sll	a3,a3,0xb
    422e:	0116e6b3          	or	a3,a3,a7
    4232:	82ad                	srl	a3,a3,0xb
    4234:	05ae                	sll	a1,a1,0xb
    4236:	0115e5b3          	or	a1,a1,a7
    423a:	01555813          	srl	a6,a0,0x15
    423e:	052e                	sll	a0,a0,0xb
    4240:	010582b3          	add	t0,a1,a6
    4244:	00f70333          	add	t1,a4,a5
    4248:	02c50733          	mul	a4,a0,a2
    424c:	02c537b3          	mulhu	a5,a0,a2
    4250:	02d50833          	mul	a6,a0,a3
    4254:	02d538b3          	mulhu	a7,a0,a3
    4258:	983e                	add	a6,a6,a5
    425a:	00f837b3          	sltu	a5,a6,a5
    425e:	98be                	add	a7,a7,a5
    4260:	02c28533          	mul	a0,t0,a2
    4264:	02c2b5b3          	mulhu	a1,t0,a2
    4268:	982a                	add	a6,a6,a0
    426a:	00a83533          	sltu	a0,a6,a0
    426e:	98ae                	add	a7,a7,a1
    4270:	00b8b5b3          	sltu	a1,a7,a1
    4274:	98aa                	add	a7,a7,a0
    4276:	00a8b533          	sltu	a0,a7,a0
    427a:	00b50633          	add	a2,a0,a1
    427e:	02d28533          	mul	a0,t0,a3
    4282:	02d2b5b3          	mulhu	a1,t0,a3
    4286:	9546                	add	a0,a0,a7
    4288:	011538b3          	sltu	a7,a0,a7
    428c:	95c6                	add	a1,a1,a7
    428e:	95b2                	add	a1,a1,a2
    4290:	00e03733          	snez	a4,a4
    4294:	00e86833          	or	a6,a6,a4
    4298:	871a                	mv	a4,t1
    429a:	00b59293          	sll	t0,a1,0xb
    429e:	0002cc63          	bltz	t0,42b6 <.L__muldf3_normalized>
    42a2:	000822b3          	sltz	t0,a6
    42a6:	9842                	add	a6,a6,a6
    42a8:	00052333          	sltz	t1,a0
    42ac:	952a                	add	a0,a0,a0
    42ae:	9516                	add	a0,a0,t0
    42b0:	95ae                	add	a1,a1,a1
    42b2:	959a                	add	a1,a1,t1
    42b4:	177d                	add	a4,a4,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>

000042b6 <.L__muldf3_normalized>:
    42b6:	3ff00793          	li	a5,1023
    42ba:	8f1d                	sub	a4,a4,a5
    42bc:	04074a63          	bltz	a4,4310 <.L__muldf3_signed_zero>
    42c0:	0786                	sll	a5,a5,0x1
    42c2:	04f75363          	bge	a4,a5,4308 <.L__muldf3_inf>
    42c6:	0752                	sll	a4,a4,0x14
    42c8:	95ba                	add	a1,a1,a4
    42ca:	00085a63          	bgez	a6,42de <.L__muldf3_apply_sign>
    42ce:	0505                	add	a0,a0,1 # 800001 <_flash_size+0x1>
    42d0:	00153613          	seqz	a2,a0
    42d4:	95b2                	add	a1,a1,a2
    42d6:	0806                	sll	a6,a6,0x1
    42d8:	00081363          	bnez	a6,42de <.L__muldf3_apply_sign>
    42dc:	9979                	and	a0,a0,-2

000042de <.L__muldf3_apply_sign>:
    42de:	95f6                	add	a1,a1,t4
    42e0:	8082                	ret

000042e2 <.L__muldf3_lhs_nan_or_inf>:
    42e2:	01071a63          	bne	a4,a6,42f6 <.L__muldf3_nan>
    42e6:	e901                	bnez	a0,42f6 <.L__muldf3_nan>
    42e8:	00f86763          	bltu	a6,a5,42f6 <.L__muldf3_nan>
    42ec:	0107e363          	bltu	a5,a6,42f2 <.L__muldf3_rhs_could_be_zero>
    42f0:	e219                	bnez	a2,42f6 <.L__muldf3_nan>

000042f2 <.L__muldf3_rhs_could_be_zero>:
    42f2:	83d5                	srl	a5,a5,0x15
    42f4:	eb91                	bnez	a5,4308 <.L__muldf3_inf>

000042f6 <.L__muldf3_nan>:
    42f6:	7ff805b7          	lui	a1,0x7ff80

000042fa <.L__muldf3_load_zero_lo>:
    42fa:	4501                	li	a0,0
    42fc:	8082                	ret

000042fe <.L__muldf3_rhs_nan_or_inf>:
    42fe:	ff079ce3          	bne	a5,a6,42f6 <.L__muldf3_nan>
    4302:	fa75                	bnez	a2,42f6 <.L__muldf3_nan>
    4304:	8355                	srl	a4,a4,0x15
    4306:	db65                	beqz	a4,42f6 <.L__muldf3_nan>

00004308 <.L__muldf3_inf>:
    4308:	7ff005b7          	lui	a1,0x7ff00
    430c:	4501                	li	a0,0
    430e:	bfc1                	j	42de <.L__muldf3_apply_sign>

00004310 <.L__muldf3_signed_zero>:
    4310:	85f6                	mv	a1,t4
    4312:	b7e5                	j	42fa <.L__muldf3_load_zero_lo>

Disassembly of section .text.libc.__divsf3:

00004314 <__divsf3>:
    4314:	0ff00293          	li	t0,255
    4318:	00151713          	sll	a4,a0,0x1
    431c:	8361                	srl	a4,a4,0x18
    431e:	00159793          	sll	a5,a1,0x1
    4322:	83e1                	srl	a5,a5,0x18
    4324:	00b54333          	xor	t1,a0,a1
    4328:	01f35313          	srl	t1,t1,0x1f
    432c:	037e                	sll	t1,t1,0x1f
    432e:	cf4d                	beqz	a4,43e8 <.L__divsf3_lhs_zero_or_subnormal>
    4330:	cbe9                	beqz	a5,4402 <.L__divsf3_rhs_zero_or_subnormal>
    4332:	0c570363          	beq	a4,t0,43f8 <.L__divsf3_lhs_inf_or_nan>
    4336:	0c578b63          	beq	a5,t0,440c <.L__divsf3_rhs_inf_or_nan>
    433a:	8f1d                	sub	a4,a4,a5
    433c:	f2818293          	add	t0,gp,-216 # 7cc <__SEGGER_RTL_fdiv_reciprocal_table>
    4340:	00f5d693          	srl	a3,a1,0xf
    4344:	0fc6f693          	and	a3,a3,252
    4348:	9696                	add	a3,a3,t0
    434a:	429c                	lw	a5,0(a3)
    434c:	4187d613          	sra	a2,a5,0x18
    4350:	00f59693          	sll	a3,a1,0xf
    4354:	82e1                	srl	a3,a3,0x18
    4356:	0016f293          	and	t0,a3,1
    435a:	8285                	srl	a3,a3,0x1
    435c:	fc068693          	add	a3,a3,-64
    4360:	9696                	add	a3,a3,t0
    4362:	02d60633          	mul	a2,a2,a3
    4366:	07a2                	sll	a5,a5,0x8
    4368:	83a1                	srl	a5,a5,0x8
    436a:	963e                	add	a2,a2,a5
    436c:	05a2                	sll	a1,a1,0x8
    436e:	81a1                	srl	a1,a1,0x8
    4370:	008007b7          	lui	a5,0x800
    4374:	8ddd                	or	a1,a1,a5
    4376:	02c586b3          	mul	a3,a1,a2
    437a:	0522                	sll	a0,a0,0x8
    437c:	8121                	srl	a0,a0,0x8
    437e:	8d5d                	or	a0,a0,a5
    4380:	02c697b3          	mulh	a5,a3,a2
    4384:	00b532b3          	sltu	t0,a0,a1
    4388:	00551533          	sll	a0,a0,t0
    438c:	40570733          	sub	a4,a4,t0
    4390:	01465693          	srl	a3,a2,0x14
    4394:	8a85                	and	a3,a3,1
    4396:	0016c693          	xor	a3,a3,1
    439a:	062e                	sll	a2,a2,0xb
    439c:	8e1d                	sub	a2,a2,a5
    439e:	8e15                	sub	a2,a2,a3
    43a0:	050a                	sll	a0,a0,0x2
    43a2:	02a617b3          	mulh	a5,a2,a0
    43a6:	07e70613          	add	a2,a4,126
    43aa:	055a                	sll	a0,a0,0x16
    43ac:	8d0d                	sub	a0,a0,a1
    43ae:	02b786b3          	mul	a3,a5,a1
    43b2:	0fe00293          	li	t0,254
    43b6:	00567f63          	bgeu	a2,t0,43d4 <.L__divsf3_underflow_or_overflow>
    43ba:	40a68533          	sub	a0,a3,a0
    43be:	000522b3          	sltz	t0,a0
    43c2:	9796                	add	a5,a5,t0
    43c4:	0017f513          	and	a0,a5,1
    43c8:	8385                	srl	a5,a5,0x1
    43ca:	953e                	add	a0,a0,a5
    43cc:	065e                	sll	a2,a2,0x17
    43ce:	9532                	add	a0,a0,a2
    43d0:	951a                	add	a0,a0,t1
    43d2:	8082                	ret

000043d4 <.L__divsf3_underflow_or_overflow>:
    43d4:	851a                	mv	a0,t1
    43d6:	00564563          	blt	a2,t0,43e0 <.L__divsf3_done>
    43da:	7f800337          	lui	t1,0x7f800

000043de <.L__divsf3_apply_sign>:
    43de:	951a                	add	a0,a0,t1

000043e0 <.L__divsf3_done>:
    43e0:	8082                	ret

000043e2 <.L__divsf3_inf>:
    43e2:	7f800537          	lui	a0,0x7f800
    43e6:	bfe5                	j	43de <.L__divsf3_apply_sign>

000043e8 <.L__divsf3_lhs_zero_or_subnormal>:
    43e8:	c789                	beqz	a5,43f2 <.L__divsf3_nan>
    43ea:	02579363          	bne	a5,t0,4410 <.L__divsf3_signed_zero>
    43ee:	05a6                	sll	a1,a1,0x9
    43f0:	c185                	beqz	a1,4410 <.L__divsf3_signed_zero>

000043f2 <.L__divsf3_nan>:
    43f2:	7fc00537          	lui	a0,0x7fc00
    43f6:	8082                	ret

000043f8 <.L__divsf3_lhs_inf_or_nan>:
    43f8:	0526                	sll	a0,a0,0x9
    43fa:	fd65                	bnez	a0,43f2 <.L__divsf3_nan>
    43fc:	fe5793e3          	bne	a5,t0,43e2 <.L__divsf3_inf>
    4400:	bfcd                	j	43f2 <.L__divsf3_nan>

00004402 <.L__divsf3_rhs_zero_or_subnormal>:
    4402:	fe5710e3          	bne	a4,t0,43e2 <.L__divsf3_inf>
    4406:	0526                	sll	a0,a0,0x9
    4408:	f56d                	bnez	a0,43f2 <.L__divsf3_nan>
    440a:	bfe1                	j	43e2 <.L__divsf3_inf>

0000440c <.L__divsf3_rhs_inf_or_nan>:
    440c:	05a6                	sll	a1,a1,0x9
    440e:	f1f5                	bnez	a1,43f2 <.L__divsf3_nan>

00004410 <.L__divsf3_signed_zero>:
    4410:	851a                	mv	a0,t1
    4412:	8082                	ret

Disassembly of section .text.libc.__divdf3:

00004414 <__divdf3>:
    4414:	00169813          	sll	a6,a3,0x1
    4418:	01585813          	srl	a6,a6,0x15
    441c:	00159893          	sll	a7,a1,0x1
    4420:	0158d893          	srl	a7,a7,0x15
    4424:	00d5c3b3          	xor	t2,a1,a3
    4428:	01f3d393          	srl	t2,t2,0x1f
    442c:	03fe                	sll	t2,t2,0x1f
    442e:	7ff00293          	li	t0,2047
    4432:	16588e63          	beq	a7,t0,45ae <.L__divdf3_inf_nan_over>
    4436:	18080a63          	beqz	a6,45ca <.L__divdf3_div_zero>
    443a:	18580263          	beq	a6,t0,45be <.L__divdf3_div_inf_nan>
    443e:	18088263          	beqz	a7,45c2 <.L__divdf3_signed_zero>
    4442:	410888b3          	sub	a7,a7,a6
    4446:	3ff88893          	add	a7,a7,1023 # 800003ff <__SHARE_RAM_segment_end__+0x7ee803ff>
    444a:	05b2                	sll	a1,a1,0xc
    444c:	81b1                	srl	a1,a1,0xc
    444e:	06b2                	sll	a3,a3,0xc
    4450:	82b1                	srl	a3,a3,0xc
    4452:	00100737          	lui	a4,0x100
    4456:	8dd9                	or	a1,a1,a4
    4458:	8ed9                	or	a3,a3,a4
    445a:	00c53733          	sltu	a4,a0,a2
    445e:	9736                	add	a4,a4,a3
    4460:	8d99                	sub	a1,a1,a4
    4462:	8d11                	sub	a0,a0,a2
    4464:	0005dd63          	bgez	a1,447e <.L__divdf3_can_subtract>
    4468:	00052733          	sltz	a4,a0
    446c:	95ae                	add	a1,a1,a1
    446e:	95ba                	add	a1,a1,a4
    4470:	95b6                	add	a1,a1,a3
    4472:	952a                	add	a0,a0,a0
    4474:	9532                	add	a0,a0,a2
    4476:	00c53733          	sltu	a4,a0,a2
    447a:	95ba                	add	a1,a1,a4
    447c:	18fd                	add	a7,a7,-1

0000447e <.L__divdf3_can_subtract>:
    447e:	1258dd63          	bge	a7,t0,45b8 <.L__divdf3_signed_inf>
    4482:	15105063          	blez	a7,45c2 <.L__divdf3_signed_zero>
    4486:	05aa                	sll	a1,a1,0xa
    4488:	01655713          	srl	a4,a0,0x16
    448c:	8dd9                	or	a1,a1,a4
    448e:	052a                	sll	a0,a0,0xa
    4490:	02d5d833          	divu	a6,a1,a3
    4494:	02d80e33          	mul	t3,a6,a3
    4498:	41c585b3          	sub	a1,a1,t3
    449c:	02c80733          	mul	a4,a6,a2
    44a0:	02c837b3          	mulhu	a5,a6,a2
    44a4:	00e53e33          	sltu	t3,a0,a4
    44a8:	97f2                	add	a5,a5,t3
    44aa:	8d19                	sub	a0,a0,a4
    44ac:	8d9d                	sub	a1,a1,a5
    44ae:	0005d863          	bgez	a1,44be <.L__divdf3_qdash_correct_1>
    44b2:	187d                	add	a6,a6,-1 # ffdfffff <__SHARE_RAM_segment_end__+0xfec7ffff>
    44b4:	9532                	add	a0,a0,a2
    44b6:	95b6                	add	a1,a1,a3
    44b8:	00c532b3          	sltu	t0,a0,a2
    44bc:	9596                	add	a1,a1,t0

000044be <.L__divdf3_qdash_correct_1>:
    44be:	05aa                	sll	a1,a1,0xa
    44c0:	01655293          	srl	t0,a0,0x16
    44c4:	9596                	add	a1,a1,t0
    44c6:	052a                	sll	a0,a0,0xa
    44c8:	02d5d2b3          	divu	t0,a1,a3
    44cc:	02d28733          	mul	a4,t0,a3
    44d0:	8d99                	sub	a1,a1,a4
    44d2:	02c28733          	mul	a4,t0,a2
    44d6:	02c2b7b3          	mulhu	a5,t0,a2
    44da:	00e53e33          	sltu	t3,a0,a4
    44de:	97f2                	add	a5,a5,t3
    44e0:	8d19                	sub	a0,a0,a4
    44e2:	8d9d                	sub	a1,a1,a5
    44e4:	0005d863          	bgez	a1,44f4 <.L__divdf3_qdash_correct_2>
    44e8:	12fd                	add	t0,t0,-1
    44ea:	9532                	add	a0,a0,a2
    44ec:	95b6                	add	a1,a1,a3
    44ee:	00c53e33          	sltu	t3,a0,a2
    44f2:	95f2                	add	a1,a1,t3

000044f4 <.L__divdf3_qdash_correct_2>:
    44f4:	082a                	sll	a6,a6,0xa
    44f6:	9816                	add	a6,a6,t0
    44f8:	05ae                	sll	a1,a1,0xb
    44fa:	01555e13          	srl	t3,a0,0x15
    44fe:	95f2                	add	a1,a1,t3
    4500:	052e                	sll	a0,a0,0xb
    4502:	02d5d2b3          	divu	t0,a1,a3
    4506:	02d28733          	mul	a4,t0,a3
    450a:	8d99                	sub	a1,a1,a4
    450c:	02c28733          	mul	a4,t0,a2
    4510:	02c2b7b3          	mulhu	a5,t0,a2
    4514:	00e53e33          	sltu	t3,a0,a4
    4518:	97f2                	add	a5,a5,t3
    451a:	8d19                	sub	a0,a0,a4
    451c:	8d9d                	sub	a1,a1,a5
    451e:	0005d863          	bgez	a1,452e <.L__divdf3_qdash_correct_3>
    4522:	12fd                	add	t0,t0,-1
    4524:	9532                	add	a0,a0,a2
    4526:	95b6                	add	a1,a1,a3
    4528:	00c53e33          	sltu	t3,a0,a2
    452c:	95f2                	add	a1,a1,t3

0000452e <.L__divdf3_qdash_correct_3>:
    452e:	05ae                	sll	a1,a1,0xb
    4530:	01555e13          	srl	t3,a0,0x15
    4534:	95f2                	add	a1,a1,t3
    4536:	052e                	sll	a0,a0,0xb
    4538:	02d5d333          	divu	t1,a1,a3
    453c:	02d30733          	mul	a4,t1,a3
    4540:	8d99                	sub	a1,a1,a4
    4542:	02c30733          	mul	a4,t1,a2
    4546:	02c337b3          	mulhu	a5,t1,a2
    454a:	00e53e33          	sltu	t3,a0,a4
    454e:	97f2                	add	a5,a5,t3
    4550:	8d19                	sub	a0,a0,a4
    4552:	8d9d                	sub	a1,a1,a5
    4554:	0005d863          	bgez	a1,4564 <.L__divdf3_qdash_correct_4>
    4558:	137d                	add	t1,t1,-1 # 7f7fffff <__SHARE_RAM_segment_end__+0x7e67ffff>
    455a:	9532                	add	a0,a0,a2
    455c:	95b6                	add	a1,a1,a3
    455e:	00c53e33          	sltu	t3,a0,a2
    4562:	95f2                	add	a1,a1,t3

00004564 <.L__divdf3_qdash_correct_4>:
    4564:	02d6                	sll	t0,t0,0x15
    4566:	032a                	sll	t1,t1,0xa
    4568:	929a                	add	t0,t0,t1
    456a:	05ae                	sll	a1,a1,0xb
    456c:	01555e13          	srl	t3,a0,0x15
    4570:	95f2                	add	a1,a1,t3
    4572:	052e                	sll	a0,a0,0xb
    4574:	02d5d333          	divu	t1,a1,a3
    4578:	02d30733          	mul	a4,t1,a3
    457c:	8d99                	sub	a1,a1,a4
    457e:	02c30733          	mul	a4,t1,a2
    4582:	02c337b3          	mulhu	a5,t1,a2
    4586:	00e53e33          	sltu	t3,a0,a4
    458a:	97f2                	add	a5,a5,t3
    458c:	8d9d                	sub	a1,a1,a5
    458e:	85fd                	sra	a1,a1,0x1f
    4590:	932e                	add	t1,t1,a1
    4592:	08d2                	sll	a7,a7,0x14
    4594:	011805b3          	add	a1,a6,a7
    4598:	00135513          	srl	a0,t1,0x1
    459c:	9516                	add	a0,a0,t0
    459e:	00137313          	and	t1,t1,1
    45a2:	951a                	add	a0,a0,t1
    45a4:	00653733          	sltu	a4,a0,t1
    45a8:	95ba                	add	a1,a1,a4
    45aa:	959e                	add	a1,a1,t2
    45ac:	8082                	ret

000045ae <.L__divdf3_inf_nan_over>:
    45ae:	05b2                	sll	a1,a1,0xc
    45b0:	00580f63          	beq	a6,t0,45ce <.L__divdf3_return_nan>
    45b4:	8dc9                	or	a1,a1,a0
    45b6:	ed81                	bnez	a1,45ce <.L__divdf3_return_nan>

000045b8 <.L__divdf3_signed_inf>:
    45b8:	7ff005b7          	lui	a1,0x7ff00
    45bc:	a021                	j	45c4 <.L__divdf3_apply_sign>

000045be <.L__divdf3_div_inf_nan>:
    45be:	06b2                	sll	a3,a3,0xc
    45c0:	e699                	bnez	a3,45ce <.L__divdf3_return_nan>

000045c2 <.L__divdf3_signed_zero>:
    45c2:	4581                	li	a1,0

000045c4 <.L__divdf3_apply_sign>:
    45c4:	959e                	add	a1,a1,t2

000045c6 <.L__divdf3_clr_low_ret>:
    45c6:	4501                	li	a0,0
    45c8:	8082                	ret

000045ca <.L__divdf3_div_zero>:
    45ca:	fe0897e3          	bnez	a7,45b8 <.L__divdf3_signed_inf>

000045ce <.L__divdf3_return_nan>:
    45ce:	7ff805b7          	lui	a1,0x7ff80
    45d2:	bfd5                	j	45c6 <.L__divdf3_clr_low_ret>

Disassembly of section .text.libc.__eqsf2:

000045d4 <__eqsf2>:
    45d4:	ff000637          	lui	a2,0xff000
    45d8:	00151693          	sll	a3,a0,0x1
    45dc:	02d66063          	bltu	a2,a3,45fc <.L__eqsf2_one>
    45e0:	00159693          	sll	a3,a1,0x1
    45e4:	00d66c63          	bltu	a2,a3,45fc <.L__eqsf2_one>
    45e8:	00b56633          	or	a2,a0,a1
    45ec:	0606                	sll	a2,a2,0x1
    45ee:	c609                	beqz	a2,45f8 <.L__eqsf2_zero>
    45f0:	8d0d                	sub	a0,a0,a1
    45f2:	00a03533          	snez	a0,a0
    45f6:	8082                	ret

000045f8 <.L__eqsf2_zero>:
    45f8:	4501                	li	a0,0
    45fa:	8082                	ret

000045fc <.L__eqsf2_one>:
    45fc:	4505                	li	a0,1
    45fe:	8082                	ret

Disassembly of section .text.libc.__fixunssfdi:

00004600 <__fixunssfdi>:
    4600:	04054a63          	bltz	a0,4654 <.L__fixunssfdi_zero_result>
    4604:	00151613          	sll	a2,a0,0x1
    4608:	8261                	srl	a2,a2,0x18
    460a:	f8160613          	add	a2,a2,-127 # feffff81 <__SHARE_RAM_segment_end__+0xfde7ff81>
    460e:	04064363          	bltz	a2,4654 <.L__fixunssfdi_zero_result>
    4612:	800006b7          	lui	a3,0x80000
    4616:	02000293          	li	t0,32
    461a:	00565b63          	bge	a2,t0,4630 <.L__fixunssfdi_long_shift>
    461e:	40c00633          	neg	a2,a2
    4622:	067d                	add	a2,a2,31
    4624:	0522                	sll	a0,a0,0x8
    4626:	8d55                	or	a0,a0,a3
    4628:	00c55533          	srl	a0,a0,a2
    462c:	4581                	li	a1,0
    462e:	8082                	ret

00004630 <.L__fixunssfdi_long_shift>:
    4630:	40c00633          	neg	a2,a2
    4634:	03f60613          	add	a2,a2,63
    4638:	02064163          	bltz	a2,465a <.L__fixunssfdi_overflow_result>
    463c:	00851593          	sll	a1,a0,0x8
    4640:	8dd5                	or	a1,a1,a3
    4642:	4501                	li	a0,0
    4644:	c619                	beqz	a2,4652 <.L__fixunssfdi_shift_32>
    4646:	40c006b3          	neg	a3,a2
    464a:	00d59533          	sll	a0,a1,a3
    464e:	00c5d5b3          	srl	a1,a1,a2

00004652 <.L__fixunssfdi_shift_32>:
    4652:	8082                	ret

00004654 <.L__fixunssfdi_zero_result>:
    4654:	4501                	li	a0,0
    4656:	4581                	li	a1,0
    4658:	8082                	ret

0000465a <.L__fixunssfdi_overflow_result>:
    465a:	557d                	li	a0,-1
    465c:	55fd                	li	a1,-1
    465e:	8082                	ret

Disassembly of section .text.libc.__floatunsidf:

00004660 <__floatunsidf>:
    4660:	c131                	beqz	a0,46a4 <.L__floatunsidf_zero>
    4662:	41d00613          	li	a2,1053
    4666:	01055693          	srl	a3,a0,0x10
    466a:	e299                	bnez	a3,4670 <.L1^B9>
    466c:	0542                	sll	a0,a0,0x10
    466e:	1641                	add	a2,a2,-16

00004670 <.L1^B9>:
    4670:	01855693          	srl	a3,a0,0x18
    4674:	e299                	bnez	a3,467a <.L2^B9>
    4676:	0522                	sll	a0,a0,0x8
    4678:	1661                	add	a2,a2,-8

0000467a <.L2^B9>:
    467a:	01c55693          	srl	a3,a0,0x1c
    467e:	e299                	bnez	a3,4684 <.L3^B7>
    4680:	0512                	sll	a0,a0,0x4
    4682:	1671                	add	a2,a2,-4

00004684 <.L3^B7>:
    4684:	01e55693          	srl	a3,a0,0x1e
    4688:	e299                	bnez	a3,468e <.L4^B9>
    468a:	050a                	sll	a0,a0,0x2
    468c:	1679                	add	a2,a2,-2

0000468e <.L4^B9>:
    468e:	00054463          	bltz	a0,4696 <.L5^B7>
    4692:	0506                	sll	a0,a0,0x1
    4694:	167d                	add	a2,a2,-1

00004696 <.L5^B7>:
    4696:	0652                	sll	a2,a2,0x14
    4698:	00b55693          	srl	a3,a0,0xb
    469c:	0556                	sll	a0,a0,0x15
    469e:	00c685b3          	add	a1,a3,a2
    46a2:	8082                	ret

000046a4 <.L__floatunsidf_zero>:
    46a4:	85aa                	mv	a1,a0
    46a6:	8082                	ret

Disassembly of section .text.libc.__trunctfsf2:

000046a8 <__trunctfsf2>:
    46a8:	4110                	lw	a2,0(a0)
    46aa:	4154                	lw	a3,4(a0)
    46ac:	4518                	lw	a4,8(a0)
    46ae:	455c                	lw	a5,12(a0)
    46b0:	1101                	add	sp,sp,-32
    46b2:	850a                	mv	a0,sp
    46b4:	ce06                	sw	ra,28(sp)
    46b6:	c032                	sw	a2,0(sp)
    46b8:	c236                	sw	a3,4(sp)
    46ba:	c43a                	sw	a4,8(sp)
    46bc:	c63e                	sw	a5,12(sp)
    46be:	d79fd0ef          	jal	2436 <__SEGGER_RTL_ldouble_to_double>
    46c2:	ceffd0ef          	jal	23b0 <__truncdfsf2>
    46c6:	40f2                	lw	ra,28(sp)
    46c8:	6105                	add	sp,sp,32
    46ca:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_signbit:

000046cc <__SEGGER_RTL_float32_signbit>:
    46cc:	817d                	srl	a0,a0,0x1f
    46ce:	8082                	ret

Disassembly of section .text.libc.ldexpf:

000046d0 <ldexpf>:
    46d0:	01755713          	srl	a4,a0,0x17
    46d4:	0ff77713          	zext.b	a4,a4
    46d8:	fff70613          	add	a2,a4,-1 # fffff <__DLM_segment_end__+0x3ffff>
    46dc:	0fd00693          	li	a3,253
    46e0:	87aa                	mv	a5,a0
    46e2:	02c6e863          	bltu	a3,a2,4712 <.L780>
    46e6:	95ba                	add	a1,a1,a4
    46e8:	fff58713          	add	a4,a1,-1 # 7ff7ffff <__SHARE_RAM_segment_end__+0x7edfffff>
    46ec:	00e6eb63          	bltu	a3,a4,4702 <.L781>
    46f0:	80800737          	lui	a4,0x80800
    46f4:	177d                	add	a4,a4,-1 # 807fffff <__SHARE_RAM_segment_end__+0x7f67ffff>
    46f6:	00e577b3          	and	a5,a0,a4
    46fa:	05de                	sll	a1,a1,0x17
    46fc:	00f5e533          	or	a0,a1,a5
    4700:	8082                	ret

00004702 <.L781>:
    4702:	80000537          	lui	a0,0x80000
    4706:	8d7d                	and	a0,a0,a5
    4708:	00b05563          	blez	a1,4712 <.L780>
    470c:	7f8007b7          	lui	a5,0x7f800
    4710:	8d5d                	or	a0,a0,a5

00004712 <.L780>:
    4712:	8082                	ret

Disassembly of section .text.libc.frexpf:

00004714 <frexpf>:
    4714:	01755793          	srl	a5,a0,0x17
    4718:	0ff7f793          	zext.b	a5,a5
    471c:	4701                	li	a4,0
    471e:	cf99                	beqz	a5,473c <.L959>
    4720:	0ff00613          	li	a2,255
    4724:	00c78c63          	beq	a5,a2,473c <.L959>
    4728:	f8278713          	add	a4,a5,-126 # 7f7fff82 <__SHARE_RAM_segment_end__+0x7e67ff82>
    472c:	808007b7          	lui	a5,0x80800
    4730:	17fd                	add	a5,a5,-1 # 807fffff <__SHARE_RAM_segment_end__+0x7f67ffff>
    4732:	00f576b3          	and	a3,a0,a5
    4736:	3f000537          	lui	a0,0x3f000
    473a:	8d55                	or	a0,a0,a3

0000473c <.L959>:
    473c:	c198                	sw	a4,0(a1)
    473e:	8082                	ret

Disassembly of section .text.libc.fmodf:

00004740 <fmodf>:
    4740:	01755793          	srl	a5,a0,0x17
    4744:	80000837          	lui	a6,0x80000
    4748:	17fd                	add	a5,a5,-1
    474a:	0fd00713          	li	a4,253
    474e:	86aa                	mv	a3,a0
    4750:	862e                	mv	a2,a1
    4752:	00a87833          	and	a6,a6,a0
    4756:	02f76463          	bltu	a4,a5,477e <.L991>
    475a:	0175d793          	srl	a5,a1,0x17
    475e:	17fd                	add	a5,a5,-1
    4760:	02f77e63          	bgeu	a4,a5,479c <.L992>
    4764:	00151713          	sll	a4,a0,0x1

00004768 <.L993>:
    4768:	00159793          	sll	a5,a1,0x1
    476c:	ff000637          	lui	a2,0xff000
    4770:	0cf66663          	bltu	a2,a5,483c <.L1009>
    4774:	ef01                	bnez	a4,478c <.L995>
    4776:	eb91                	bnez	a5,478a <.L994>

00004778 <.L1011>:
    4778:	6701a503          	lw	a0,1648(gp) # f14 <.Lmerged_single+0x14>
    477c:	8082                	ret

0000477e <.L991>:
    477e:	00151713          	sll	a4,a0,0x1
    4782:	ff0007b7          	lui	a5,0xff000
    4786:	fee7f1e3          	bgeu	a5,a4,4768 <.L993>

0000478a <.L994>:
    478a:	8082                	ret

0000478c <.L995>:
    478c:	fec706e3          	beq	a4,a2,4778 <.L1011>
    4790:	fec78de3          	beq	a5,a2,478a <.L994>
    4794:	d3f5                	beqz	a5,4778 <.L1011>
    4796:	0586                	sll	a1,a1,0x1
    4798:	0015d613          	srl	a2,a1,0x1

0000479c <.L992>:
    479c:	00169793          	sll	a5,a3,0x1
    47a0:	8385                	srl	a5,a5,0x1
    47a2:	00f66663          	bltu	a2,a5,47ae <.L996>
    47a6:	fec792e3          	bne	a5,a2,478a <.L994>

000047aa <.L1018>:
    47aa:	8542                	mv	a0,a6
    47ac:	8082                	ret

000047ae <.L996>:
    47ae:	0177d713          	srl	a4,a5,0x17
    47b2:	cb0d                	beqz	a4,47e4 <.L1012>
    47b4:	008007b7          	lui	a5,0x800
    47b8:	fff78593          	add	a1,a5,-1 # 7fffff <__DLM_segment_end__+0x73ffff>
    47bc:	8eed                	and	a3,a3,a1
    47be:	8fd5                	or	a5,a5,a3

000047c0 <.L998>:
    47c0:	01765593          	srl	a1,a2,0x17
    47c4:	c985                	beqz	a1,47f4 <.L1013>
    47c6:	008006b7          	lui	a3,0x800
    47ca:	fff68513          	add	a0,a3,-1 # 7fffff <__DLM_segment_end__+0x73ffff>
    47ce:	8e69                	and	a2,a2,a0
    47d0:	8e55                	or	a2,a2,a3

000047d2 <.L1002>:
    47d2:	40c786b3          	sub	a3,a5,a2
    47d6:	02e5c763          	blt	a1,a4,4804 <.L1003>
    47da:	0206cc63          	bltz	a3,4812 <.L1015>
    47de:	8542                	mv	a0,a6
    47e0:	ea95                	bnez	a3,4814 <.L1004>
    47e2:	8082                	ret

000047e4 <.L1012>:
    47e4:	4701                	li	a4,0
    47e6:	008006b7          	lui	a3,0x800

000047ea <.L997>:
    47ea:	0786                	sll	a5,a5,0x1
    47ec:	177d                	add	a4,a4,-1
    47ee:	fed7eee3          	bltu	a5,a3,47ea <.L997>
    47f2:	b7f9                	j	47c0 <.L998>

000047f4 <.L1013>:
    47f4:	4581                	li	a1,0
    47f6:	008006b7          	lui	a3,0x800

000047fa <.L999>:
    47fa:	0606                	sll	a2,a2,0x1
    47fc:	15fd                	add	a1,a1,-1
    47fe:	fed66ee3          	bltu	a2,a3,47fa <.L999>
    4802:	bfc1                	j	47d2 <.L1002>

00004804 <.L1003>:
    4804:	0006c463          	bltz	a3,480c <.L1001>
    4808:	d2cd                	beqz	a3,47aa <.L1018>
    480a:	87b6                	mv	a5,a3

0000480c <.L1001>:
    480c:	0786                	sll	a5,a5,0x1
    480e:	177d                	add	a4,a4,-1
    4810:	b7c9                	j	47d2 <.L1002>

00004812 <.L1015>:
    4812:	86be                	mv	a3,a5

00004814 <.L1004>:
    4814:	008007b7          	lui	a5,0x800

00004818 <.L1006>:
    4818:	fff70513          	add	a0,a4,-1
    481c:	00f6ed63          	bltu	a3,a5,4836 <.L1007>
    4820:	00e04763          	bgtz	a4,482e <.L1008>
    4824:	4785                	li	a5,1
    4826:	8f99                	sub	a5,a5,a4
    4828:	00f6d6b3          	srl	a3,a3,a5
    482c:	4501                	li	a0,0

0000482e <.L1008>:
    482e:	9836                	add	a6,a6,a3
    4830:	055e                	sll	a0,a0,0x17
    4832:	9542                	add	a0,a0,a6
    4834:	8082                	ret

00004836 <.L1007>:
    4836:	0686                	sll	a3,a3,0x1
    4838:	872a                	mv	a4,a0
    483a:	bff9                	j	4818 <.L1006>

0000483c <.L1009>:
    483c:	852e                	mv	a0,a1
    483e:	8082                	ret

Disassembly of section .text.libc.memset:

00004840 <memset>:
    4840:	872a                	mv	a4,a0
    4842:	c22d                	beqz	a2,48a4 <.Lmemset_memset_end>

00004844 <.Lmemset_unaligned_byte_set_loop>:
    4844:	01e51693          	sll	a3,a0,0x1e
    4848:	c699                	beqz	a3,4856 <.Lmemset_fast_set>
    484a:	00b50023          	sb	a1,0(a0) # 3f000000 <__SHARE_RAM_segment_end__+0x3de80000>
    484e:	0505                	add	a0,a0,1
    4850:	167d                	add	a2,a2,-1 # feffffff <__SHARE_RAM_segment_end__+0xfde7ffff>
    4852:	fa6d                	bnez	a2,4844 <.Lmemset_unaligned_byte_set_loop>
    4854:	a881                	j	48a4 <.Lmemset_memset_end>

00004856 <.Lmemset_fast_set>:
    4856:	0ff5f593          	zext.b	a1,a1
    485a:	00859693          	sll	a3,a1,0x8
    485e:	8dd5                	or	a1,a1,a3
    4860:	01059693          	sll	a3,a1,0x10
    4864:	8dd5                	or	a1,a1,a3
    4866:	02000693          	li	a3,32
    486a:	00d66f63          	bltu	a2,a3,4888 <.Lmemset_word_set>

0000486e <.Lmemset_fast_set_loop>:
    486e:	c10c                	sw	a1,0(a0)
    4870:	c14c                	sw	a1,4(a0)
    4872:	c50c                	sw	a1,8(a0)
    4874:	c54c                	sw	a1,12(a0)
    4876:	c90c                	sw	a1,16(a0)
    4878:	c94c                	sw	a1,20(a0)
    487a:	cd0c                	sw	a1,24(a0)
    487c:	cd4c                	sw	a1,28(a0)
    487e:	9536                	add	a0,a0,a3
    4880:	8e15                	sub	a2,a2,a3
    4882:	fed676e3          	bgeu	a2,a3,486e <.Lmemset_fast_set_loop>
    4886:	ce19                	beqz	a2,48a4 <.Lmemset_memset_end>

00004888 <.Lmemset_word_set>:
    4888:	4691                	li	a3,4
    488a:	00d66863          	bltu	a2,a3,489a <.Lmemset_byte_set_loop>

0000488e <.Lmemset_word_set_loop>:
    488e:	c10c                	sw	a1,0(a0)
    4890:	9536                	add	a0,a0,a3
    4892:	8e15                	sub	a2,a2,a3
    4894:	fed67de3          	bgeu	a2,a3,488e <.Lmemset_word_set_loop>
    4898:	c611                	beqz	a2,48a4 <.Lmemset_memset_end>

0000489a <.Lmemset_byte_set_loop>:
    489a:	00b50023          	sb	a1,0(a0)
    489e:	0505                	add	a0,a0,1
    48a0:	167d                	add	a2,a2,-1
    48a2:	fe65                	bnez	a2,489a <.Lmemset_byte_set_loop>

000048a4 <.Lmemset_memset_end>:
    48a4:	853a                	mv	a0,a4
    48a6:	8082                	ret

Disassembly of section .text.libc.strlen:

000048a8 <strlen>:
    48a8:	85aa                	mv	a1,a0
    48aa:	00357693          	and	a3,a0,3
    48ae:	c29d                	beqz	a3,48d4 <.Lstrlen_aligned>
    48b0:	00054603          	lbu	a2,0(a0)
    48b4:	ce21                	beqz	a2,490c <.Lstrlen_done>
    48b6:	0505                	add	a0,a0,1
    48b8:	00357693          	and	a3,a0,3
    48bc:	ce81                	beqz	a3,48d4 <.Lstrlen_aligned>
    48be:	00054603          	lbu	a2,0(a0)
    48c2:	c629                	beqz	a2,490c <.Lstrlen_done>
    48c4:	0505                	add	a0,a0,1
    48c6:	00357693          	and	a3,a0,3
    48ca:	c689                	beqz	a3,48d4 <.Lstrlen_aligned>
    48cc:	00054603          	lbu	a2,0(a0)
    48d0:	ce15                	beqz	a2,490c <.Lstrlen_done>
    48d2:	0505                	add	a0,a0,1

000048d4 <.Lstrlen_aligned>:
    48d4:	01010637          	lui	a2,0x1010
    48d8:	10160613          	add	a2,a2,257 # 1010101 <_extram_size+0x10101>
    48dc:	00761693          	sll	a3,a2,0x7

000048e0 <.Lstrlen_wordstrlen>:
    48e0:	4118                	lw	a4,0(a0)
    48e2:	0511                	add	a0,a0,4
    48e4:	40c707b3          	sub	a5,a4,a2
    48e8:	fff74713          	not	a4,a4
    48ec:	8ff9                	and	a5,a5,a4
    48ee:	8ff5                	and	a5,a5,a3
    48f0:	dbe5                	beqz	a5,48e0 <.Lstrlen_wordstrlen>
    48f2:	1571                	add	a0,a0,-4
    48f4:	01879713          	sll	a4,a5,0x18
    48f8:	eb11                	bnez	a4,490c <.Lstrlen_done>
    48fa:	0505                	add	a0,a0,1
    48fc:	01079713          	sll	a4,a5,0x10
    4900:	e711                	bnez	a4,490c <.Lstrlen_done>
    4902:	0505                	add	a0,a0,1
    4904:	00879713          	sll	a4,a5,0x8
    4908:	e311                	bnez	a4,490c <.Lstrlen_done>
    490a:	0505                	add	a0,a0,1

0000490c <.Lstrlen_done>:
    490c:	8d0d                	sub	a0,a0,a1
    490e:	8082                	ret

Disassembly of section .text.libc.strnlen:

00004910 <strnlen>:
    4910:	862a                	mv	a2,a0
    4912:	852e                	mv	a0,a1
    4914:	c9c9                	beqz	a1,49a6 <.L528>
    4916:	00064783          	lbu	a5,0(a2)
    491a:	c7c9                	beqz	a5,49a4 <.L534>
    491c:	00367793          	and	a5,a2,3
    4920:	00379693          	sll	a3,a5,0x3
    4924:	00f58533          	add	a0,a1,a5
    4928:	ffc67713          	and	a4,a2,-4
    492c:	57fd                	li	a5,-1
    492e:	00d797b3          	sll	a5,a5,a3
    4932:	4314                	lw	a3,0(a4)
    4934:	fff7c793          	not	a5,a5
    4938:	feff05b7          	lui	a1,0xfeff0
    493c:	80808837          	lui	a6,0x80808
    4940:	8fd5                	or	a5,a5,a3
    4942:	488d                	li	a7,3
    4944:	eff58593          	add	a1,a1,-257 # fefefeff <__SHARE_RAM_segment_end__+0xfde6feff>
    4948:	08080813          	add	a6,a6,128 # 80808080 <__SHARE_RAM_segment_end__+0x7f688080>

0000494c <.L530>:
    494c:	00a8ff63          	bgeu	a7,a0,496a <.L529>
    4950:	00b786b3          	add	a3,a5,a1
    4954:	fff7c313          	not	t1,a5
    4958:	0066f6b3          	and	a3,a3,t1
    495c:	0106f6b3          	and	a3,a3,a6
    4960:	e689                	bnez	a3,496a <.L529>
    4962:	0711                	add	a4,a4,4
    4964:	1571                	add	a0,a0,-4
    4966:	431c                	lw	a5,0(a4)
    4968:	b7d5                	j	494c <.L530>

0000496a <.L529>:
    496a:	0ff7f593          	zext.b	a1,a5
    496e:	c59d                	beqz	a1,499c <.L531>
    4970:	0087d593          	srl	a1,a5,0x8
    4974:	0ff5f593          	zext.b	a1,a1
    4978:	4685                	li	a3,1
    497a:	cd89                	beqz	a1,4994 <.L532>
    497c:	0107d593          	srl	a1,a5,0x10
    4980:	0ff5f593          	zext.b	a1,a1
    4984:	4689                	li	a3,2
    4986:	c599                	beqz	a1,4994 <.L532>
    4988:	010005b7          	lui	a1,0x1000
    498c:	468d                	li	a3,3
    498e:	00b7e363          	bltu	a5,a1,4994 <.L532>
    4992:	4691                	li	a3,4

00004994 <.L532>:
    4994:	85aa                	mv	a1,a0
    4996:	00a6f363          	bgeu	a3,a0,499c <.L531>
    499a:	85b6                	mv	a1,a3

0000499c <.L531>:
    499c:	8f11                	sub	a4,a4,a2
    499e:	00b70533          	add	a0,a4,a1
    49a2:	8082                	ret

000049a4 <.L534>:
    49a4:	4501                	li	a0,0

000049a6 <.L528>:
    49a6:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_stream_write:

000049a8 <__SEGGER_RTL_stream_write>:
    49a8:	5154                	lw	a3,36(a0)
    49aa:	87ae                	mv	a5,a1
    49ac:	853e                	mv	a0,a5
    49ae:	4585                	li	a1,1
    49b0:	e48fd06f          	j	1ff8 <fwrite>

Disassembly of section .text.libc.__SEGGER_RTL_putc:

000049b4 <__SEGGER_RTL_putc>:
    49b4:	4918                	lw	a4,16(a0)
    49b6:	1101                	add	sp,sp,-32
    49b8:	0ff5f593          	zext.b	a1,a1
    49bc:	cc22                	sw	s0,24(sp)
    49be:	ce06                	sw	ra,28(sp)
    49c0:	00b107a3          	sb	a1,15(sp)
    49c4:	411c                	lw	a5,0(a0)
    49c6:	842a                	mv	s0,a0
    49c8:	cb05                	beqz	a4,49f8 <.L24>
    49ca:	4154                	lw	a3,4(a0)
    49cc:	00d7ff63          	bgeu	a5,a3,49ea <.L26>
    49d0:	495c                	lw	a5,20(a0)
    49d2:	00178693          	add	a3,a5,1 # 800001 <_flash_size+0x1>
    49d6:	973e                	add	a4,a4,a5
    49d8:	c954                	sw	a3,20(a0)
    49da:	00b70023          	sb	a1,0(a4)
    49de:	4958                	lw	a4,20(a0)
    49e0:	4d1c                	lw	a5,24(a0)
    49e2:	00f71463          	bne	a4,a5,49ea <.L26>
    49e6:	c30fe0ef          	jal	2e16 <__SEGGER_RTL_prin_flush>

000049ea <.L26>:
    49ea:	401c                	lw	a5,0(s0)
    49ec:	40f2                	lw	ra,28(sp)
    49ee:	0785                	add	a5,a5,1
    49f0:	c01c                	sw	a5,0(s0)
    49f2:	4462                	lw	s0,24(sp)
    49f4:	6105                	add	sp,sp,32
    49f6:	8082                	ret

000049f8 <.L24>:
    49f8:	4558                	lw	a4,12(a0)
    49fa:	c305                	beqz	a4,4a1a <.L28>
    49fc:	4154                	lw	a3,4(a0)
    49fe:	00178613          	add	a2,a5,1
    4a02:	00d61463          	bne	a2,a3,4a0a <.L29>
    4a06:	000107a3          	sb	zero,15(sp)

00004a0a <.L29>:
    4a0a:	fed7f0e3          	bgeu	a5,a3,49ea <.L26>
    4a0e:	00f14683          	lbu	a3,15(sp)
    4a12:	973e                	add	a4,a4,a5
    4a14:	00d70023          	sb	a3,0(a4)
    4a18:	bfc9                	j	49ea <.L26>

00004a1a <.L28>:
    4a1a:	4518                	lw	a4,8(a0)
    4a1c:	c305                	beqz	a4,4a3c <.L30>
    4a1e:	4154                	lw	a3,4(a0)
    4a20:	00178613          	add	a2,a5,1
    4a24:	00d61463          	bne	a2,a3,4a2c <.L31>
    4a28:	000107a3          	sb	zero,15(sp)

00004a2c <.L31>:
    4a2c:	fad7ffe3          	bgeu	a5,a3,49ea <.L26>
    4a30:	078a                	sll	a5,a5,0x2
    4a32:	973e                	add	a4,a4,a5
    4a34:	00f14783          	lbu	a5,15(sp)
    4a38:	c31c                	sw	a5,0(a4)
    4a3a:	bf45                	j	49ea <.L26>

00004a3c <.L30>:
    4a3c:	5118                	lw	a4,32(a0)
    4a3e:	d755                	beqz	a4,49ea <.L26>
    4a40:	4154                	lw	a3,4(a0)
    4a42:	fad7f4e3          	bgeu	a5,a3,49ea <.L26>
    4a46:	4605                	li	a2,1
    4a48:	00f10593          	add	a1,sp,15
    4a4c:	9702                	jalr	a4
    4a4e:	bf71                	j	49ea <.L26>

Disassembly of section .text.libc.__SEGGER_RTL_print_padding:

00004a50 <__SEGGER_RTL_print_padding>:
    4a50:	1141                	add	sp,sp,-16
    4a52:	c422                	sw	s0,8(sp)
    4a54:	c226                	sw	s1,4(sp)
    4a56:	c04a                	sw	s2,0(sp)
    4a58:	c606                	sw	ra,12(sp)
    4a5a:	84aa                	mv	s1,a0
    4a5c:	892e                	mv	s2,a1
    4a5e:	8432                	mv	s0,a2

00004a60 <.L37>:
    4a60:	147d                	add	s0,s0,-1
    4a62:	00045863          	bgez	s0,4a72 <.L38>
    4a66:	40b2                	lw	ra,12(sp)
    4a68:	4422                	lw	s0,8(sp)
    4a6a:	4492                	lw	s1,4(sp)
    4a6c:	4902                	lw	s2,0(sp)
    4a6e:	0141                	add	sp,sp,16
    4a70:	8082                	ret

00004a72 <.L38>:
    4a72:	85ca                	mv	a1,s2
    4a74:	8526                	mv	a0,s1
    4a76:	3f3d                	jal	49b4 <__SEGGER_RTL_putc>
    4a78:	b7e5                	j	4a60 <.L37>

Disassembly of section .text.libc.vfprintf_l:

00004a7a <vfprintf_l>:
    4a7a:	711d                	add	sp,sp,-96
    4a7c:	ce86                	sw	ra,92(sp)
    4a7e:	cca2                	sw	s0,88(sp)
    4a80:	caa6                	sw	s1,84(sp)
    4a82:	1080                	add	s0,sp,96
    4a84:	c8ca                	sw	s2,80(sp)
    4a86:	c6ce                	sw	s3,76(sp)
    4a88:	8932                	mv	s2,a2
    4a8a:	fad42623          	sw	a3,-84(s0)
    4a8e:	89aa                	mv	s3,a0
    4a90:	fab42423          	sw	a1,-88(s0)
    4a94:	f60fe0ef          	jal	31f4 <__SEGGER_RTL_X_file_bufsize>
    4a98:	fa842583          	lw	a1,-88(s0)
    4a9c:	00f50793          	add	a5,a0,15
    4aa0:	9bc1                	and	a5,a5,-16
    4aa2:	40f10133          	sub	sp,sp,a5
    4aa6:	84aa                	mv	s1,a0
    4aa8:	fb840513          	add	a0,s0,-72
    4aac:	ba6fe0ef          	jal	2e52 <__SEGGER_RTL_init_prin_l>
    4ab0:	800007b7          	lui	a5,0x80000
    4ab4:	fac42603          	lw	a2,-84(s0)
    4ab8:	17fd                	add	a5,a5,-1 # 7fffffff <__SHARE_RAM_segment_end__+0x7ee7ffff>
    4aba:	faf42e23          	sw	a5,-68(s0)
    4abe:	000057b7          	lui	a5,0x5
    4ac2:	9a878793          	add	a5,a5,-1624 # 49a8 <__SEGGER_RTL_stream_write>
    4ac6:	85ca                	mv	a1,s2
    4ac8:	fb840513          	add	a0,s0,-72
    4acc:	fc242423          	sw	sp,-56(s0)
    4ad0:	fc942823          	sw	s1,-48(s0)
    4ad4:	fd342e23          	sw	s3,-36(s0)
    4ad8:	fcf42c23          	sw	a5,-40(s0)
    4adc:	2811                	jal	4af0 <__SEGGER_RTL_vfprintf>
    4ade:	fa040113          	add	sp,s0,-96
    4ae2:	40f6                	lw	ra,92(sp)
    4ae4:	4466                	lw	s0,88(sp)
    4ae6:	44d6                	lw	s1,84(sp)
    4ae8:	4946                	lw	s2,80(sp)
    4aea:	49b6                	lw	s3,76(sp)
    4aec:	6125                	add	sp,sp,96
    4aee:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_vfprintf_short_float_long:

00004af0 <__SEGGER_RTL_vfprintf>:
    4af0:	7175                	add	sp,sp,-144
    4af2:	49018793          	add	a5,gp,1168 # d34 <.L9>
    4af6:	c83e                	sw	a5,16(sp)
    4af8:	dece                	sw	s3,124(sp)
    4afa:	dad6                	sw	s5,116(sp)
    4afc:	ceee                	sw	s11,92(sp)
    4afe:	c706                	sw	ra,140(sp)
    4b00:	c522                	sw	s0,136(sp)
    4b02:	c326                	sw	s1,132(sp)
    4b04:	c14a                	sw	s2,128(sp)
    4b06:	dcd2                	sw	s4,120(sp)
    4b08:	d8da                	sw	s6,112(sp)
    4b0a:	d6de                	sw	s7,108(sp)
    4b0c:	d4e2                	sw	s8,104(sp)
    4b0e:	d2e6                	sw	s9,100(sp)
    4b10:	d0ea                	sw	s10,96(sp)
    4b12:	4d418793          	add	a5,gp,1236 # d78 <.L45>
    4b16:	00020db7          	lui	s11,0x20
    4b1a:	89aa                	mv	s3,a0
    4b1c:	8ab2                	mv	s5,a2
    4b1e:	00052023          	sw	zero,0(a0)
    4b22:	ca3e                	sw	a5,20(sp)
    4b24:	021d8d93          	add	s11,s11,33 # 20021 <__NONCACHEABLE_RAM_segment_size__+0x10021>

00004b28 <.L2>:
    4b28:	00158a13          	add	s4,a1,1 # 1000001 <_extram_size+0x1>
    4b2c:	0005c583          	lbu	a1,0(a1)
    4b30:	e19d                	bnez	a1,4b56 <.L229>
    4b32:	00c9a783          	lw	a5,12(s3)
    4b36:	cb91                	beqz	a5,4b4a <.L230>
    4b38:	0009a703          	lw	a4,0(s3)
    4b3c:	0049a683          	lw	a3,4(s3)
    4b40:	00d77563          	bgeu	a4,a3,4b4a <.L230>
    4b44:	97ba                	add	a5,a5,a4
    4b46:	00078023          	sb	zero,0(a5)

00004b4a <.L230>:
    4b4a:	854e                	mv	a0,s3
    4b4c:	acafe0ef          	jal	2e16 <__SEGGER_RTL_prin_flush>
    4b50:	0009a503          	lw	a0,0(s3)
    4b54:	a2f9                	j	4d22 <.L338>

00004b56 <.L229>:
    4b56:	02500793          	li	a5,37
    4b5a:	00f58563          	beq	a1,a5,4b64 <.L231>

00004b5e <.L362>:
    4b5e:	854e                	mv	a0,s3
    4b60:	3d91                	jal	49b4 <__SEGGER_RTL_putc>
    4b62:	aab9                	j	4cc0 <.L4>

00004b64 <.L231>:
    4b64:	4b81                	li	s7,0
    4b66:	03000613          	li	a2,48
    4b6a:	05e00593          	li	a1,94
    4b6e:	6505                	lui	a0,0x1
    4b70:	487d                	li	a6,31
    4b72:	48c1                	li	a7,16
    4b74:	6321                	lui	t1,0x8
    4b76:	a03d                	j	4ba4 <.L3>

00004b78 <.L5>:
    4b78:	04b78f63          	beq	a5,a1,4bd6 <.L15>

00004b7c <.L232>:
    4b7c:	8a36                	mv	s4,a3
    4b7e:	4b01                	li	s6,0
    4b80:	46a5                	li	a3,9
    4b82:	45a9                	li	a1,10

00004b84 <.L18>:
    4b84:	fd078713          	add	a4,a5,-48
    4b88:	0ff77613          	zext.b	a2,a4
    4b8c:	08c6e363          	bltu	a3,a2,4c12 <.L20>
    4b90:	02bb0b33          	mul	s6,s6,a1
    4b94:	0a05                	add	s4,s4,1
    4b96:	fffa4783          	lbu	a5,-1(s4)
    4b9a:	9b3a                	add	s6,s6,a4
    4b9c:	b7e5                	j	4b84 <.L18>

00004b9e <.L14>:
    4b9e:	040beb93          	or	s7,s7,64

00004ba2 <.L16>:
    4ba2:	8a36                	mv	s4,a3

00004ba4 <.L3>:
    4ba4:	000a4783          	lbu	a5,0(s4)
    4ba8:	001a0693          	add	a3,s4,1
    4bac:	fcf666e3          	bltu	a2,a5,4b78 <.L5>
    4bb0:	fcf876e3          	bgeu	a6,a5,4b7c <.L232>
    4bb4:	fe078713          	add	a4,a5,-32
    4bb8:	0ff77713          	zext.b	a4,a4
    4bbc:	02e8e963          	bltu	a7,a4,4bee <.L7>
    4bc0:	4442                	lw	s0,16(sp)
    4bc2:	070a                	sll	a4,a4,0x2
    4bc4:	9722                	add	a4,a4,s0
    4bc6:	4318                	lw	a4,0(a4)
    4bc8:	8702                	jr	a4

00004bca <.L13>:
    4bca:	080beb93          	or	s7,s7,128
    4bce:	bfd1                	j	4ba2 <.L16>

00004bd0 <.L12>:
    4bd0:	006bebb3          	or	s7,s7,t1
    4bd4:	b7f9                	j	4ba2 <.L16>

00004bd6 <.L15>:
    4bd6:	00abebb3          	or	s7,s7,a0
    4bda:	b7e1                	j	4ba2 <.L16>

00004bdc <.L11>:
    4bdc:	020beb93          	or	s7,s7,32
    4be0:	b7c9                	j	4ba2 <.L16>

00004be2 <.L10>:
    4be2:	010beb93          	or	s7,s7,16
    4be6:	bf75                	j	4ba2 <.L16>

00004be8 <.L8>:
    4be8:	200beb93          	or	s7,s7,512
    4bec:	bf5d                	j	4ba2 <.L16>

00004bee <.L7>:
    4bee:	02a00713          	li	a4,42
    4bf2:	f8e795e3          	bne	a5,a4,4b7c <.L232>
    4bf6:	000aab03          	lw	s6,0(s5)
    4bfa:	004a8713          	add	a4,s5,4
    4bfe:	000b5663          	bgez	s6,4c0a <.L19>
    4c02:	41600b33          	neg	s6,s6
    4c06:	010beb93          	or	s7,s7,16

00004c0a <.L19>:
    4c0a:	0006c783          	lbu	a5,0(a3) # 800000 <_flash_size>
    4c0e:	0a09                	add	s4,s4,2
    4c10:	8aba                	mv	s5,a4

00004c12 <.L20>:
    4c12:	000b5363          	bgez	s6,4c18 <.L22>
    4c16:	4b01                	li	s6,0

00004c18 <.L22>:
    4c18:	02e00713          	li	a4,46
    4c1c:	4481                	li	s1,0
    4c1e:	04e79263          	bne	a5,a4,4c62 <.L23>
    4c22:	000a4783          	lbu	a5,0(s4)
    4c26:	02a00713          	li	a4,42
    4c2a:	02e78263          	beq	a5,a4,4c4e <.L24>
    4c2e:	0a05                	add	s4,s4,1
    4c30:	46a5                	li	a3,9
    4c32:	45a9                	li	a1,10

00004c34 <.L25>:
    4c34:	fd078713          	add	a4,a5,-48
    4c38:	0ff77613          	zext.b	a2,a4
    4c3c:	00c6ef63          	bltu	a3,a2,4c5a <.L26>
    4c40:	02b484b3          	mul	s1,s1,a1
    4c44:	0a05                	add	s4,s4,1
    4c46:	fffa4783          	lbu	a5,-1(s4)
    4c4a:	94ba                	add	s1,s1,a4
    4c4c:	b7e5                	j	4c34 <.L25>

00004c4e <.L24>:
    4c4e:	000aa483          	lw	s1,0(s5)
    4c52:	001a4783          	lbu	a5,1(s4)
    4c56:	0a91                	add	s5,s5,4
    4c58:	0a09                	add	s4,s4,2

00004c5a <.L26>:
    4c5a:	0004c463          	bltz	s1,4c62 <.L23>
    4c5e:	100beb93          	or	s7,s7,256

00004c62 <.L23>:
    4c62:	06c00713          	li	a4,108
    4c66:	06e78263          	beq	a5,a4,4cca <.L28>
    4c6a:	02f76c63          	bltu	a4,a5,4ca2 <.L29>
    4c6e:	06800713          	li	a4,104
    4c72:	06e78a63          	beq	a5,a4,4ce6 <.L30>
    4c76:	06a00713          	li	a4,106
    4c7a:	04e78563          	beq	a5,a4,4cc4 <.L31>

00004c7e <.L32>:
    4c7e:	05700713          	li	a4,87
    4c82:	2af760e3          	bltu	a4,a5,5722 <.L38>
    4c86:	04500713          	li	a4,69
    4c8a:	2ce78563          	beq	a5,a4,4f54 <.L39>
    4c8e:	06f76763          	bltu	a4,a5,4cfc <.L40>
    4c92:	c7c1                	beqz	a5,4d1a <.L41>
    4c94:	02500713          	li	a4,37
    4c98:	02500593          	li	a1,37
    4c9c:	ece781e3          	beq	a5,a4,4b5e <.L362>
    4ca0:	a005                	j	4cc0 <.L4>

00004ca2 <.L29>:
    4ca2:	07400713          	li	a4,116
    4ca6:	00e78663          	beq	a5,a4,4cb2 <.L346>
    4caa:	07a00713          	li	a4,122
    4cae:	26e796e3          	bne	a5,a4,571a <.L34>

00004cb2 <.L346>:
    4cb2:	000a4783          	lbu	a5,0(s4)
    4cb6:	0a05                	add	s4,s4,1

00004cb8 <.L35>:
    4cb8:	07800713          	li	a4,120
    4cbc:	fcf771e3          	bgeu	a4,a5,4c7e <.L32>

00004cc0 <.L4>:
    4cc0:	85d2                	mv	a1,s4
    4cc2:	b59d                	j	4b28 <.L2>

00004cc4 <.L31>:
    4cc4:	002beb93          	or	s7,s7,2
    4cc8:	b7ed                	j	4cb2 <.L346>

00004cca <.L28>:
    4cca:	000a4783          	lbu	a5,0(s4)
    4cce:	00e79863          	bne	a5,a4,4cde <.L36>
    4cd2:	002beb93          	or	s7,s7,2

00004cd6 <.L347>:
    4cd6:	001a4783          	lbu	a5,1(s4)
    4cda:	0a09                	add	s4,s4,2
    4cdc:	bff1                	j	4cb8 <.L35>

00004cde <.L36>:
    4cde:	0a05                	add	s4,s4,1
    4ce0:	001beb93          	or	s7,s7,1
    4ce4:	bfd1                	j	4cb8 <.L35>

00004ce6 <.L30>:
    4ce6:	000a4783          	lbu	a5,0(s4)
    4cea:	00e79563          	bne	a5,a4,4cf4 <.L37>
    4cee:	008beb93          	or	s7,s7,8
    4cf2:	b7d5                	j	4cd6 <.L347>

00004cf4 <.L37>:
    4cf4:	0a05                	add	s4,s4,1
    4cf6:	004beb93          	or	s7,s7,4
    4cfa:	bf7d                	j	4cb8 <.L35>

00004cfc <.L40>:
    4cfc:	04600713          	li	a4,70
    4d00:	2ce78263          	beq	a5,a4,4fc4 <.L57>
    4d04:	04700713          	li	a4,71
    4d08:	fae79ce3          	bne	a5,a4,4cc0 <.L4>
    4d0c:	6789                	lui	a5,0x2
    4d0e:	00fbebb3          	or	s7,s7,a5

00004d12 <.L52>:
    4d12:	6905                	lui	s2,0x1
    4d14:	c0090913          	add	s2,s2,-1024 # c00 <__SEGGER_RTL_Moeller_inverse_lut+0x334>
    4d18:	ac65                	j	4fd0 <.L353>

00004d1a <.L41>:
    4d1a:	854e                	mv	a0,s3
    4d1c:	8fafe0ef          	jal	2e16 <__SEGGER_RTL_prin_flush>
    4d20:	557d                	li	a0,-1

00004d22 <.L338>:
    4d22:	40ba                	lw	ra,140(sp)
    4d24:	442a                	lw	s0,136(sp)
    4d26:	449a                	lw	s1,132(sp)
    4d28:	490a                	lw	s2,128(sp)
    4d2a:	59f6                	lw	s3,124(sp)
    4d2c:	5a66                	lw	s4,120(sp)
    4d2e:	5ad6                	lw	s5,116(sp)
    4d30:	5b46                	lw	s6,112(sp)
    4d32:	5bb6                	lw	s7,108(sp)
    4d34:	5c26                	lw	s8,104(sp)
    4d36:	5c96                	lw	s9,100(sp)
    4d38:	5d06                	lw	s10,96(sp)
    4d3a:	4df6                	lw	s11,92(sp)
    4d3c:	6149                	add	sp,sp,144
    4d3e:	8082                	ret

00004d40 <.L55>:
    4d40:	000aa483          	lw	s1,0(s5)
    4d44:	1b7d                	add	s6,s6,-1
    4d46:	865a                	mv	a2,s6
    4d48:	85de                	mv	a1,s7
    4d4a:	854e                	mv	a0,s3
    4d4c:	8ecfe0ef          	jal	2e38 <__SEGGER_RTL_pre_padding>
    4d50:	004a8413          	add	s0,s5,4
    4d54:	0ff4f593          	zext.b	a1,s1
    4d58:	854e                	mv	a0,s3
    4d5a:	39a9                	jal	49b4 <__SEGGER_RTL_putc>
    4d5c:	8aa2                	mv	s5,s0

00004d5e <.L371>:
    4d5e:	010bfb93          	and	s7,s7,16
    4d62:	f40b8fe3          	beqz	s7,4cc0 <.L4>
    4d66:	865a                	mv	a2,s6
    4d68:	02000593          	li	a1,32
    4d6c:	854e                	mv	a0,s3
    4d6e:	31cd                	jal	4a50 <__SEGGER_RTL_print_padding>
    4d70:	bf81                	j	4cc0 <.L4>

00004d72 <.L50>:
    4d72:	008bf693          	and	a3,s7,8
    4d76:	000aa783          	lw	a5,0(s5)
    4d7a:	0009a703          	lw	a4,0(s3)
    4d7e:	0a91                	add	s5,s5,4
    4d80:	c681                	beqz	a3,4d88 <.L62>
    4d82:	00e78023          	sb	a4,0(a5) # 2000 <fwrite+0x8>
    4d86:	bf2d                	j	4cc0 <.L4>

00004d88 <.L62>:
    4d88:	002bfb93          	and	s7,s7,2
    4d8c:	c398                	sw	a4,0(a5)
    4d8e:	f20b89e3          	beqz	s7,4cc0 <.L4>
    4d92:	0007a223          	sw	zero,4(a5)
    4d96:	b72d                	j	4cc0 <.L4>

00004d98 <.L47>:
    4d98:	000aa403          	lw	s0,0(s5)
    4d9c:	895e                	mv	s2,s7
    4d9e:	0a91                	add	s5,s5,4

00004da0 <.L65>:
    4da0:	e019                	bnez	s0,4da6 <.L66>
    4da2:	46018413          	add	s0,gp,1120 # d04 <.LC0>

00004da6 <.L66>:
    4da6:	dff97b93          	and	s7,s2,-513
    4daa:	10097913          	and	s2,s2,256
    4dae:	02090563          	beqz	s2,4dd8 <.L67>
    4db2:	85a6                	mv	a1,s1
    4db4:	8522                	mv	a0,s0
    4db6:	3ea9                	jal	4910 <strnlen>

00004db8 <.L348>:
    4db8:	40ab0b33          	sub	s6,s6,a0
    4dbc:	84aa                	mv	s1,a0
    4dbe:	865a                	mv	a2,s6
    4dc0:	85de                	mv	a1,s7
    4dc2:	854e                	mv	a0,s3
    4dc4:	874fe0ef          	jal	2e38 <__SEGGER_RTL_pre_padding>

00004dc8 <.L69>:
    4dc8:	d8d9                	beqz	s1,4d5e <.L371>
    4dca:	00044583          	lbu	a1,0(s0)
    4dce:	854e                	mv	a0,s3
    4dd0:	0405                	add	s0,s0,1
    4dd2:	36cd                	jal	49b4 <__SEGGER_RTL_putc>
    4dd4:	14fd                	add	s1,s1,-1
    4dd6:	bfcd                	j	4dc8 <.L69>

00004dd8 <.L67>:
    4dd8:	8522                	mv	a0,s0
    4dda:	34f9                	jal	48a8 <strlen>
    4ddc:	bff1                	j	4db8 <.L348>

00004dde <.L48>:
    4dde:	080bf713          	and	a4,s7,128
    4de2:	000aa403          	lw	s0,0(s5)
    4de6:	004a8693          	add	a3,s5,4
    4dea:	4581                	li	a1,0
    4dec:	02300c93          	li	s9,35
    4df0:	e311                	bnez	a4,4df4 <.L71>
    4df2:	4c81                	li	s9,0

00004df4 <.L71>:
    4df4:	100beb93          	or	s7,s7,256
    4df8:	8ab6                	mv	s5,a3
    4dfa:	44a1                	li	s1,8

00004dfc <.L72>:
    4dfc:	100bf713          	and	a4,s7,256
    4e00:	e311                	bnez	a4,4e04 <.L203>
    4e02:	4485                	li	s1,1

00004e04 <.L203>:
    4e04:	05800713          	li	a4,88
    4e08:	04e78ae3          	beq	a5,a4,565c <.L204>
    4e0c:	f9c78693          	add	a3,a5,-100
    4e10:	4705                	li	a4,1
    4e12:	00d71733          	sll	a4,a4,a3
    4e16:	01b776b3          	and	a3,a4,s11
    4e1a:	7c069c63          	bnez	a3,55f2 <.L205>
    4e1e:	00c75693          	srl	a3,a4,0xc
    4e22:	1016f693          	and	a3,a3,257
    4e26:	02069be3          	bnez	a3,565c <.L204>
    4e2a:	06f00713          	li	a4,111
    4e2e:	4c01                	li	s8,0
    4e30:	04e791e3          	bne	a5,a4,5672 <.L206>

00004e34 <.L207>:
    4e34:	00b467b3          	or	a5,s0,a1
    4e38:	02078de3          	beqz	a5,5672 <.L206>
    4e3c:	183c                	add	a5,sp,56
    4e3e:	01878733          	add	a4,a5,s8
    4e42:	00747793          	and	a5,s0,7
    4e46:	03078793          	add	a5,a5,48
    4e4a:	00f70023          	sb	a5,0(a4)
    4e4e:	800d                	srl	s0,s0,0x3
    4e50:	01d59793          	sll	a5,a1,0x1d
    4e54:	0c05                	add	s8,s8,1
    4e56:	8c5d                	or	s0,s0,a5
    4e58:	818d                	srl	a1,a1,0x3
    4e5a:	bfe9                	j	4e34 <.L207>

00004e5c <.L56>:
    4e5c:	6709                	lui	a4,0x2
    4e5e:	00ebebb3          	or	s7,s7,a4

00004e62 <.L44>:
    4e62:	080bf713          	and	a4,s7,128
    4e66:	4c81                	li	s9,0
    4e68:	cb19                	beqz	a4,4e7e <.L75>
    4e6a:	6c8d                	lui	s9,0x3
    4e6c:	07800713          	li	a4,120
    4e70:	058c8c93          	add	s9,s9,88 # 3058 <.L6+0x14>
    4e74:	00e79563          	bne	a5,a4,4e7e <.L75>
    4e78:	6c8d                	lui	s9,0x3
    4e7a:	078c8c93          	add	s9,s9,120 # 3078 <.L7+0x14>

00004e7e <.L75>:
    4e7e:	100bf713          	and	a4,s7,256

00004e82 <.L365>:
    4e82:	c319                	beqz	a4,4e88 <.L74>
    4e84:	dffbfb93          	and	s7,s7,-513

00004e88 <.L74>:
    4e88:	011b9613          	sll	a2,s7,0x11
    4e8c:	002bf713          	and	a4,s7,2
    4e90:	004bf693          	and	a3,s7,4
    4e94:	08065563          	bgez	a2,4f1e <.L76>
    4e98:	cf31                	beqz	a4,4ef4 <.L77>
    4e9a:	007a8713          	add	a4,s5,7
    4e9e:	9b61                	and	a4,a4,-8
    4ea0:	4300                	lw	s0,0(a4)
    4ea2:	434c                	lw	a1,4(a4)
    4ea4:	00870a93          	add	s5,a4,8 # 2008 <fwrite+0x10>

00004ea8 <.L78>:
    4ea8:	cea1                	beqz	a3,4f00 <.L79>
    4eaa:	0442                	sll	s0,s0,0x10
    4eac:	8441                	sra	s0,s0,0x10

00004eae <.L351>:
    4eae:	41f45593          	sra	a1,s0,0x1f

00004eb2 <.L80>:
    4eb2:	0405dd63          	bgez	a1,4f0c <.L82>
    4eb6:	00803733          	snez	a4,s0
    4eba:	40b005b3          	neg	a1,a1
    4ebe:	8d99                	sub	a1,a1,a4
    4ec0:	40800433          	neg	s0,s0
    4ec4:	02d00c93          	li	s9,45

00004ec8 <.L84>:
    4ec8:	100bf713          	and	a4,s7,256
    4ecc:	db05                	beqz	a4,4dfc <.L72>
    4ece:	dffbfb93          	and	s7,s7,-513
    4ed2:	b72d                	j	4dfc <.L72>

00004ed4 <.L49>:
    4ed4:	080bf713          	and	a4,s7,128
    4ed8:	03000c93          	li	s9,48
    4edc:	f34d                	bnez	a4,4e7e <.L75>
    4ede:	4c81                	li	s9,0
    4ee0:	bf79                	j	4e7e <.L75>

00004ee2 <.L46>:
    4ee2:	100bf713          	and	a4,s7,256
    4ee6:	4c81                	li	s9,0
    4ee8:	bf69                	j	4e82 <.L365>

00004eea <.L51>:
    4eea:	6711                	lui	a4,0x4
    4eec:	00ebebb3          	or	s7,s7,a4
    4ef0:	4c81                	li	s9,0
    4ef2:	bf59                	j	4e88 <.L74>

00004ef4 <.L77>:
    4ef4:	000aa403          	lw	s0,0(s5)
    4ef8:	0a91                	add	s5,s5,4
    4efa:	41f45593          	sra	a1,s0,0x1f
    4efe:	b76d                	j	4ea8 <.L78>

00004f00 <.L79>:
    4f00:	008bf713          	and	a4,s7,8
    4f04:	d75d                	beqz	a4,4eb2 <.L80>
    4f06:	0462                	sll	s0,s0,0x18
    4f08:	8461                	sra	s0,s0,0x18
    4f0a:	b755                	j	4eae <.L351>

00004f0c <.L82>:
    4f0c:	020bf713          	and	a4,s7,32
    4f10:	ef1d                	bnez	a4,4f4e <.L239>
    4f12:	040bf713          	and	a4,s7,64
    4f16:	db4d                	beqz	a4,4ec8 <.L84>
    4f18:	02000c93          	li	s9,32
    4f1c:	b775                	j	4ec8 <.L84>

00004f1e <.L76>:
    4f1e:	cf09                	beqz	a4,4f38 <.L85>
    4f20:	007a8713          	add	a4,s5,7
    4f24:	9b61                	and	a4,a4,-8
    4f26:	4300                	lw	s0,0(a4)
    4f28:	434c                	lw	a1,4(a4)
    4f2a:	00870a93          	add	s5,a4,8 # 4008 <__HEAPSIZE__+0x8>

00004f2e <.L86>:
    4f2e:	ca91                	beqz	a3,4f42 <.L87>
    4f30:	0442                	sll	s0,s0,0x10
    4f32:	8041                	srl	s0,s0,0x10

00004f34 <.L352>:
    4f34:	4581                	li	a1,0
    4f36:	bf49                	j	4ec8 <.L84>

00004f38 <.L85>:
    4f38:	000aa403          	lw	s0,0(s5)
    4f3c:	4581                	li	a1,0
    4f3e:	0a91                	add	s5,s5,4
    4f40:	b7fd                	j	4f2e <.L86>

00004f42 <.L87>:
    4f42:	008bf713          	and	a4,s7,8
    4f46:	d349                	beqz	a4,4ec8 <.L84>
    4f48:	0ff47413          	zext.b	s0,s0
    4f4c:	b7e5                	j	4f34 <.L352>

00004f4e <.L239>:
    4f4e:	02b00c93          	li	s9,43
    4f52:	bf9d                	j	4ec8 <.L84>

00004f54 <.L39>:
    4f54:	6789                	lui	a5,0x2
    4f56:	00fbebb3          	or	s7,s7,a5

00004f5a <.L54>:
    4f5a:	400be913          	or	s2,s7,1024

00004f5e <.L91>:
    4f5e:	00297793          	and	a5,s2,2
    4f62:	cbb5                	beqz	a5,4fd6 <.L92>
    4f64:	000aa783          	lw	a5,0(s5)
    4f68:	1008                	add	a0,sp,32
    4f6a:	004a8413          	add	s0,s5,4
    4f6e:	4398                	lw	a4,0(a5)
    4f70:	8aa2                	mv	s5,s0
    4f72:	d03a                	sw	a4,32(sp)
    4f74:	43d8                	lw	a4,4(a5)
    4f76:	d23a                	sw	a4,36(sp)
    4f78:	4798                	lw	a4,8(a5)
    4f7a:	d43a                	sw	a4,40(sp)
    4f7c:	47dc                	lw	a5,12(a5)
    4f7e:	d63e                	sw	a5,44(sp)
    4f80:	f28ff0ef          	jal	46a8 <__trunctfsf2>
    4f84:	8baa                	mv	s7,a0

00004f86 <.L93>:
    4f86:	10097793          	and	a5,s2,256
    4f8a:	c3ad                	beqz	a5,4fec <.L240>
    4f8c:	e889                	bnez	s1,4f9e <.L94>
    4f8e:	6785                	lui	a5,0x1
    4f90:	c0078793          	add	a5,a5,-1024 # c00 <__SEGGER_RTL_Moeller_inverse_lut+0x334>
    4f94:	00f974b3          	and	s1,s2,a5
    4f98:	8c9d                	sub	s1,s1,a5
    4f9a:	0014b493          	seqz	s1,s1

00004f9e <.L94>:
    4f9e:	855e                	mv	a0,s7
    4fa0:	d22fd0ef          	jal	24c2 <__SEGGER_RTL_float32_isinf>
    4fa4:	c531                	beqz	a0,4ff0 <.L95>

00004fa6 <.L117>:
    4fa6:	6409                	lui	s0,0x2
    4fa8:	00000593          	li	a1,0
    4fac:	855e                	mv	a0,s7
    4fae:	00897433          	and	s0,s2,s0
    4fb2:	a42fd0ef          	jal	21f4 <__ltsf2>
    4fb6:	3e055963          	bgez	a0,53a8 <.L341>
    4fba:	3e040463          	beqz	s0,53a2 <.L244>
    4fbe:	46818413          	add	s0,gp,1128 # d0c <.LC1>
    4fc2:	a089                	j	5004 <.L122>

00004fc4 <.L57>:
    4fc4:	6789                	lui	a5,0x2
    4fc6:	00fbebb3          	or	s7,s7,a5

00004fca <.L53>:
    4fca:	6905                	lui	s2,0x1
    4fcc:	80090913          	add	s2,s2,-2048 # 800 <__SEGGER_RTL_fdiv_reciprocal_table+0x34>

00004fd0 <.L353>:
    4fd0:	012be933          	or	s2,s7,s2
    4fd4:	b769                	j	4f5e <.L91>

00004fd6 <.L92>:
    4fd6:	007a8793          	add	a5,s5,7
    4fda:	9be1                	and	a5,a5,-8
    4fdc:	4388                	lw	a0,0(a5)
    4fde:	43cc                	lw	a1,4(a5)
    4fe0:	00878a93          	add	s5,a5,8 # 2008 <fwrite+0x10>
    4fe4:	bccfd0ef          	jal	23b0 <__truncdfsf2>
    4fe8:	8baa                	mv	s7,a0
    4fea:	bf71                	j	4f86 <.L93>

00004fec <.L240>:
    4fec:	4499                	li	s1,6
    4fee:	bf45                	j	4f9e <.L94>

00004ff0 <.L95>:
    4ff0:	855e                	mv	a0,s7
    4ff2:	cbefd0ef          	jal	24b0 <__SEGGER_RTL_float32_isnan>
    4ff6:	cd09                	beqz	a0,5010 <.L101>
    4ff8:	01291793          	sll	a5,s2,0x12
    4ffc:	0007d763          	bgez	a5,500a <.L243>
    5000:	48818413          	add	s0,gp,1160 # d2c <.LC5>

00005004 <.L122>:
    5004:	eff97913          	and	s2,s2,-257
    5008:	bb61                	j	4da0 <.L65>

0000500a <.L243>:
    500a:	48c18413          	add	s0,gp,1164 # d30 <.LC6>
    500e:	bfdd                	j	5004 <.L122>

00005010 <.L101>:
    5010:	855e                	mv	a0,s7
    5012:	cbefd0ef          	jal	24d0 <__SEGGER_RTL_float32_isnormal>
    5016:	e119                	bnez	a0,501c <.L103>
    5018:	00000b93          	li	s7,0

0000501c <.L103>:
    501c:	855e                	mv	a0,s7
    501e:	845e                	mv	s0,s7
    5020:	eacff0ef          	jal	46cc <__SEGGER_RTL_float32_signbit>
    5024:	c519                	beqz	a0,5032 <.L104>
    5026:	80000437          	lui	s0,0x80000
    502a:	06096913          	or	s2,s2,96
    502e:	01744433          	xor	s0,s0,s7

00005032 <.L104>:
    5032:	184c                	add	a1,sp,52
    5034:	8522                	mv	a0,s0
    5036:	edeff0ef          	jal	4714 <frexpf>
    503a:	5752                	lw	a4,52(sp)
    503c:	478d                	li	a5,3
    503e:	00000593          	li	a1,0
    5042:	02e787b3          	mul	a5,a5,a4
    5046:	4729                	li	a4,10
    5048:	8522                	mv	a0,s0
    504a:	8ba2                	mv	s7,s0
    504c:	02e7c7b3          	div	a5,a5,a4
    5050:	da3e                	sw	a5,52(sp)
    5052:	d82ff0ef          	jal	45d4 <__eqsf2>
    5056:	24051063          	bnez	a0,5296 <.L105>

0000505a <.L111>:
    505a:	6785                	lui	a5,0x1
    505c:	c0078793          	add	a5,a5,-1024 # c00 <__SEGGER_RTL_Moeller_inverse_lut+0x334>
    5060:	00f97c33          	and	s8,s2,a5
    5064:	40000713          	li	a4,1024
    5068:	5552                	lw	a0,52(sp)
    506a:	24ec1d63          	bne	s8,a4,52c4 <.L340>

0000506e <.L106>:
    506e:	02600793          	li	a5,38
    5072:	30f51f63          	bne	a0,a5,5390 <.L113>
    5076:	66c1a583          	lw	a1,1644(gp) # f10 <.Lmerged_single+0x10>
    507a:	855e                	mv	a0,s7
    507c:	a98ff0ef          	jal	4314 <__divsf3>

00005080 <.L354>:
    5080:	00000593          	li	a1,0
    5084:	8baa                	mv	s7,a0
    5086:	842a                	mv	s0,a0
    5088:	d4cff0ef          	jal	45d4 <__eqsf2>
    508c:	cd39                	beqz	a0,50ea <.L116>
    508e:	855e                	mv	a0,s7
    5090:	c32fd0ef          	jal	24c2 <__SEGGER_RTL_float32_isinf>
    5094:	f00519e3          	bnez	a0,4fa6 <.L117>
    5098:	57d2                	lw	a5,52(sp)
    509a:	4701                	li	a4,0

0000509c <.L118>:
    509c:	c63e                	sw	a5,12(sp)
    509e:	00178d13          	add	s10,a5,1
    50a2:	6641a583          	lw	a1,1636(gp) # f08 <.Lmerged_single+0x8>
    50a6:	855e                	mv	a0,s7
    50a8:	cc3a                	sw	a4,24(sp)
    50aa:	9ecfd0ef          	jal	2296 <__gesf2>
    50ae:	47b2                	lw	a5,12(sp)
    50b0:	4762                	lw	a4,24(sp)
    50b2:	30055763          	bgez	a0,53c0 <.L124>
    50b6:	c319                	beqz	a4,50bc <.L125>
    50b8:	845e                	mv	s0,s7
    50ba:	da3e                	sw	a5,52(sp)

000050bc <.L125>:
    50bc:	6601a703          	lw	a4,1632(gp) # f04 <.Lmerged_single+0x4>
    50c0:	5d52                	lw	s10,52(sp)
    50c2:	6641ac83          	lw	s9,1636(gp) # f08 <.Lmerged_single+0x8>
    50c6:	87a2                	mv	a5,s0
    50c8:	4681                	li	a3,0
    50ca:	c63a                	sw	a4,12(sp)

000050cc <.L126>:
    50cc:	45b2                	lw	a1,12(sp)
    50ce:	853e                	mv	a0,a5
    50d0:	ce36                	sw	a3,28(sp)
    50d2:	cc3e                	sw	a5,24(sp)
    50d4:	920fd0ef          	jal	21f4 <__ltsf2>
    50d8:	47e2                	lw	a5,24(sp)
    50da:	46f2                	lw	a3,28(sp)
    50dc:	fffd0b93          	add	s7,s10,-1
    50e0:	2e054963          	bltz	a0,53d2 <.L127>
    50e4:	c299                	beqz	a3,50ea <.L116>
    50e6:	843e                	mv	s0,a5
    50e8:	da6a                	sw	s10,52(sp)

000050ea <.L116>:
    50ea:	c499                	beqz	s1,50f8 <.L129>
    50ec:	6785                	lui	a5,0x1
    50ee:	c0078793          	add	a5,a5,-1024 # c00 <__SEGGER_RTL_Moeller_inverse_lut+0x334>
    50f2:	00fc1363          	bne	s8,a5,50f8 <.L129>
    50f6:	14fd                	add	s1,s1,-1

000050f8 <.L129>:
    50f8:	40900533          	neg	a0,s1
    50fc:	cc9fd0ef          	jal	2dc4 <__SEGGER_RTL_pow10f>
    5100:	55fd                	li	a1,-1
    5102:	dceff0ef          	jal	46d0 <ldexpf>
    5106:	85a2                	mv	a1,s0
    5108:	f3ffc0ef          	jal	2046 <__addsf3>
    510c:	6641a583          	lw	a1,1636(gp) # f08 <.Lmerged_single+0x8>
    5110:	8baa                	mv	s7,a0
    5112:	842a                	mv	s0,a0
    5114:	982fd0ef          	jal	2296 <__gesf2>
    5118:	00054b63          	bltz	a0,512e <.L130>
    511c:	57d2                	lw	a5,52(sp)
    511e:	6641a583          	lw	a1,1636(gp) # f08 <.Lmerged_single+0x8>
    5122:	855e                	mv	a0,s7
    5124:	0785                	add	a5,a5,1
    5126:	da3e                	sw	a5,52(sp)
    5128:	9ecff0ef          	jal	4314 <__divsf3>
    512c:	842a                	mv	s0,a0

0000512e <.L130>:
    512e:	c622                	sw	s0,12(sp)
    5130:	2a049963          	bnez	s1,53e2 <.L132>

00005134 <.L135>:
    5134:	4481                	li	s1,0

00005136 <.L133>:
    5136:	00548793          	add	a5,s1,5
    513a:	7c7d                	lui	s8,0xfffff
    513c:	40fb0b33          	sub	s6,s6,a5
    5140:	08097793          	and	a5,s2,128
    5144:	7ffc0c13          	add	s8,s8,2047 # fffff7ff <__SHARE_RAM_segment_end__+0xfee7f7ff>
    5148:	8fc5                	or	a5,a5,s1
    514a:	01897c33          	and	s8,s2,s8
    514e:	c391                	beqz	a5,5152 <.L139>
    5150:	1b7d                	add	s6,s6,-1

00005152 <.L139>:
    5152:	01391793          	sll	a5,s2,0x13
    5156:	4d05                	li	s10,1
    5158:	0207dc63          	bgez	a5,5190 <.L140>
    515c:	5bd2                	lw	s7,52(sp)
    515e:	470d                	li	a4,3
    5160:	02ebe733          	rem	a4,s7,a4
    5164:	c31d                	beqz	a4,518a <.L141>
    5166:	0709                	add	a4,a4,2
    5168:	56b5                	li	a3,-19
    516a:	40e6d733          	sra	a4,a3,a4
    516e:	8b05                	and	a4,a4,1
    5170:	2c070663          	beqz	a4,543c <.L142>
    5174:	6641a583          	lw	a1,1636(gp) # f08 <.Lmerged_single+0x8>
    5178:	4532                	lw	a0,12(sp)
    517a:	1b7d                	add	s6,s6,-1
    517c:	4d09                	li	s10,2
    517e:	fd7fe0ef          	jal	4154 <__mulsf3>
    5182:	fffb8793          	add	a5,s7,-1
    5186:	842a                	mv	s0,a0
    5188:	da3e                	sw	a5,52(sp)

0000518a <.L141>:
    518a:	0004d363          	bgez	s1,5190 <.L140>
    518e:	4481                	li	s1,0

00005190 <.L140>:
    5190:	06097913          	and	s2,s2,96
    5194:	00090363          	beqz	s2,519a <.L144>
    5198:	1b7d                	add	s6,s6,-1

0000519a <.L144>:
    519a:	5552                	lw	a0,52(sp)
    519c:	c1ffd0ef          	jal	2dba <abs>
    51a0:	06300793          	li	a5,99
    51a4:	00a7d363          	bge	a5,a0,51aa <.L145>
    51a8:	1b7d                	add	s6,s6,-1

000051aa <.L145>:
    51aa:	8522                	mv	a0,s0
    51ac:	c54ff0ef          	jal	4600 <__fixunssfdi>
    51b0:	8bae                	mv	s7,a1
    51b2:	8caa                	mv	s9,a0
    51b4:	952fd0ef          	jal	2306 <__floatundisf>
    51b8:	85aa                	mv	a1,a0
    51ba:	8522                	mv	a0,s0
    51bc:	e83fc0ef          	jal	203e <__subsf3>
    51c0:	842a                	mv	s0,a0

000051c2 <.L146>:
    51c2:	895a                	mv	s2,s6
    51c4:	000b5363          	bgez	s6,51ca <.L165>
    51c8:	4901                	li	s2,0

000051ca <.L165>:
    51ca:	210c7793          	and	a5,s8,528
    51ce:	e399                	bnez	a5,51d4 <.L167>

000051d0 <.L166>:
    51d0:	2e091d63          	bnez	s2,54ca <.L168>

000051d4 <.L167>:
    51d4:	020c7713          	and	a4,s8,32
    51d8:	040c7793          	and	a5,s8,64
    51dc:	2e070e63          	beqz	a4,54d8 <.L169>
    51e0:	02b00593          	li	a1,43
    51e4:	c399                	beqz	a5,51ea <.L358>
    51e6:	02d00593          	li	a1,45

000051ea <.L358>:
    51ea:	854e                	mv	a0,s3
    51ec:	fc8ff0ef          	jal	49b4 <__SEGGER_RTL_putc>

000051f0 <.L171>:
    51f0:	010c7793          	and	a5,s8,16
    51f4:	e399                	bnez	a5,51fa <.L173>

000051f6 <.L172>:
    51f6:	2e091663          	bnez	s2,54e2 <.L174>

000051fa <.L173>:
    51fa:	00000b37          	lui	s6,0x0
    51fe:	090b0b13          	add	s6,s6,144 # 90 <__SEGGER_RTL_ipow10>

00005202 <.L178>:
    5202:	1d7d                	add	s10,s10,-1
    5204:	003d1793          	sll	a5,s10,0x3
    5208:	97da                	add	a5,a5,s6
    520a:	4398                	lw	a4,0(a5)
    520c:	43dc                	lw	a5,4(a5)
    520e:	03000593          	li	a1,48

00005212 <.L175>:
    5212:	00fbe663          	bltu	s7,a5,521e <.L258>
    5216:	2d779d63          	bne	a5,s7,54f0 <.L176>
    521a:	2cecfb63          	bgeu	s9,a4,54f0 <.L176>

0000521e <.L258>:
    521e:	854e                	mv	a0,s3
    5220:	f94ff0ef          	jal	49b4 <__SEGGER_RTL_putc>
    5224:	fc0d1fe3          	bnez	s10,5202 <.L178>
    5228:	6b85                	lui	s7,0x1
    522a:	800b8b93          	add	s7,s7,-2048 # 800 <__SEGGER_RTL_fdiv_reciprocal_table+0x34>
    522e:	017c7bb3          	and	s7,s8,s7
    5232:	2e0b9363          	bnez	s7,5518 <.L179>

00005236 <.L183>:
    5236:	080c7793          	and	a5,s8,128
    523a:	8fc5                	or	a5,a5,s1
    523c:	c3a1                	beqz	a5,527c <.L181>
    523e:	02e00593          	li	a1,46
    5242:	854e                	mv	a0,s3
    5244:	f70ff0ef          	jal	49b4 <__SEGGER_RTL_putc>
    5248:	47c1                	li	a5,16
    524a:	8ca6                	mv	s9,s1
    524c:	2c97da63          	bge	a5,s1,5520 <.L186>
    5250:	4cc1                	li	s9,16

00005252 <.L187>:
    5252:	419484b3          	sub	s1,s1,s9
    5256:	8566                	mv	a0,s9
    5258:	000b8563          	beqz	s7,5262 <.L359>
    525c:	5552                	lw	a0,52(sp)
    525e:	40ac8533          	sub	a0,s9,a0

00005262 <.L359>:
    5262:	b63fd0ef          	jal	2dc4 <__SEGGER_RTL_pow10f>
    5266:	85a2                	mv	a1,s0
    5268:	eedfe0ef          	jal	4154 <__mulsf3>
    526c:	b94ff0ef          	jal	4600 <__fixunssfdi>
    5270:	8baa                	mv	s7,a0
    5272:	842e                	mv	s0,a1

00005274 <.L193>:
    5274:	2a0c9a63          	bnez	s9,5528 <.L194>

00005278 <.L195>:
    5278:	2e049563          	bnez	s1,5562 <.L196>

0000527c <.L181>:
    527c:	400c7793          	and	a5,s8,1024
    5280:	2e079863          	bnez	a5,5570 <.L184>

00005284 <.L201>:
    5284:	a2090ee3          	beqz	s2,4cc0 <.L4>
    5288:	197d                	add	s2,s2,-1
    528a:	02000593          	li	a1,32
    528e:	ae81                	j	55de <.L360>

00005290 <.L108>:
    5290:	57d2                	lw	a5,52(sp)
    5292:	0785                	add	a5,a5,1
    5294:	da3e                	sw	a5,52(sp)

00005296 <.L105>:
    5296:	5552                	lw	a0,52(sp)
    5298:	0505                	add	a0,a0,1 # 1001 <.LC11+0xd>
    529a:	b2bfd0ef          	jal	2dc4 <__SEGGER_RTL_pow10f>
    529e:	85aa                	mv	a1,a0
    52a0:	855e                	mv	a0,s7
    52a2:	fc3fc0ef          	jal	2264 <__gtsf2>
    52a6:	fea045e3          	bgtz	a0,5290 <.L108>

000052aa <.L109>:
    52aa:	5552                	lw	a0,52(sp)
    52ac:	b19fd0ef          	jal	2dc4 <__SEGGER_RTL_pow10f>
    52b0:	85aa                	mv	a1,a0
    52b2:	855e                	mv	a0,s7
    52b4:	f41fc0ef          	jal	21f4 <__ltsf2>
    52b8:	da0551e3          	bgez	a0,505a <.L111>
    52bc:	57d2                	lw	a5,52(sp)
    52be:	17fd                	add	a5,a5,-1
    52c0:	da3e                	sw	a5,52(sp)
    52c2:	b7e5                	j	52aa <.L109>

000052c4 <.L340>:
    52c4:	00fc1763          	bne	s8,a5,52d2 <.L112>
    52c8:	da9553e3          	bge	a0,s1,506e <.L106>
    52cc:	57f1                	li	a5,-4
    52ce:	0cf54163          	blt	a0,a5,5390 <.L113>

000052d2 <.L112>:
    52d2:	08097793          	and	a5,s2,128
    52d6:	c63e                	sw	a5,12(sp)
    52d8:	40097793          	and	a5,s2,1024
    52dc:	c789                	beqz	a5,52e6 <.L147>
    52de:	47b9                	li	a5,14
    52e0:	16a7da63          	bge	a5,a0,5454 <.L148>

000052e4 <.L153>:
    52e4:	4481                	li	s1,0

000052e6 <.L147>:
    52e6:	57d2                	lw	a5,52(sp)
    52e8:	40900533          	neg	a0,s1
    52ec:	bff97c13          	and	s8,s2,-1025
    52f0:	ff178713          	add	a4,a5,-15
    52f4:	00e55463          	bge	a0,a4,52fc <.L154>
    52f8:	ff078513          	add	a0,a5,-16

000052fc <.L154>:
    52fc:	ac9fd0ef          	jal	2dc4 <__SEGGER_RTL_pow10f>
    5300:	55fd                	li	a1,-1
    5302:	bceff0ef          	jal	46d0 <ldexpf>
    5306:	85aa                	mv	a1,a0
    5308:	855e                	mv	a0,s7
    530a:	d3dfc0ef          	jal	2046 <__addsf3>
    530e:	8d2a                	mv	s10,a0
    5310:	842a                	mv	s0,a0
    5312:	5552                	lw	a0,52(sp)
    5314:	0505                	add	a0,a0,1
    5316:	aaffd0ef          	jal	2dc4 <__SEGGER_RTL_pow10f>
    531a:	85ea                	mv	a1,s10
    531c:	f13fc0ef          	jal	222e <__lesf2>
    5320:	00a04563          	bgtz	a0,532a <.L156>
    5324:	57d2                	lw	a5,52(sp)
    5326:	0785                	add	a5,a5,1
    5328:	da3e                	sw	a5,52(sp)

0000532a <.L156>:
    532a:	57d2                	lw	a5,52(sp)
    532c:	1807c963          	bltz	a5,54be <.L158>
    5330:	4541                	li	a0,16
    5332:	16f55863          	bge	a0,a5,54a2 <.L159>
    5336:	ff078713          	add	a4,a5,-16
    533a:	8d1d                	sub	a0,a0,a5
    533c:	da3a                	sw	a4,52(sp)
    533e:	a87fd0ef          	jal	2dc4 <__SEGGER_RTL_pow10f>
    5342:	85ea                	mv	a1,s10
    5344:	e11fe0ef          	jal	4154 <__mulsf3>
    5348:	ab8ff0ef          	jal	4600 <__fixunssfdi>
    534c:	8caa                	mv	s9,a0
    534e:	8bae                	mv	s7,a1
    5350:	00000413          	li	s0,0

00005354 <.L160>:
    5354:	000007b7          	lui	a5,0x0
    5358:	09078793          	add	a5,a5,144 # 90 <__SEGGER_RTL_ipow10>
    535c:	4d05                	li	s10,1

0000535e <.L161>:
    535e:	47d8                	lw	a4,12(a5)
    5360:	07a1                	add	a5,a5,8
    5362:	00ebe763          	bltu	s7,a4,5370 <.L257>
    5366:	17771063          	bne	a4,s7,54c6 <.L162>
    536a:	4398                	lw	a4,0(a5)
    536c:	14ecfd63          	bgeu	s9,a4,54c6 <.L162>

00005370 <.L257>:
    5370:	5752                	lw	a4,52(sp)
    5372:	009d07b3          	add	a5,s10,s1
    5376:	97ba                	add	a5,a5,a4
    5378:	40fb0b33          	sub	s6,s6,a5
    537c:	47b2                	lw	a5,12(sp)
    537e:	8fc5                	or	a5,a5,s1
    5380:	c391                	beqz	a5,5384 <.L164>
    5382:	1b7d                	add	s6,s6,-1

00005384 <.L164>:
    5384:	06097793          	and	a5,s2,96
    5388:	e2078de3          	beqz	a5,51c2 <.L146>
    538c:	1b7d                	add	s6,s6,-1
    538e:	bd15                	j	51c2 <.L146>

00005390 <.L113>:
    5390:	40a00533          	neg	a0,a0
    5394:	a31fd0ef          	jal	2dc4 <__SEGGER_RTL_pow10f>
    5398:	85aa                	mv	a1,a0
    539a:	855e                	mv	a0,s7
    539c:	db9fe0ef          	jal	4154 <__mulsf3>
    53a0:	b1c5                	j	5080 <.L354>

000053a2 <.L244>:
    53a2:	47018413          	add	s0,gp,1136 # d14 <.LC2>
    53a6:	b9b9                	j	5004 <.L122>

000053a8 <.L341>:
    53a8:	c809                	beqz	s0,53ba <.L245>
    53aa:	47818413          	add	s0,gp,1144 # d1c <.LC3>

000053ae <.L123>:
    53ae:	02097793          	and	a5,s2,32
    53b2:	c40799e3          	bnez	a5,5004 <.L122>
    53b6:	0405                	add	s0,s0,1 # 80000001 <__SHARE_RAM_segment_end__+0x7ee80001>
    53b8:	b1b1                	j	5004 <.L122>

000053ba <.L245>:
    53ba:	48018413          	add	s0,gp,1152 # d24 <.LC4>
    53be:	bfc5                	j	53ae <.L123>

000053c0 <.L124>:
    53c0:	6641a583          	lw	a1,1636(gp) # f08 <.Lmerged_single+0x8>
    53c4:	855e                	mv	a0,s7
    53c6:	f4ffe0ef          	jal	4314 <__divsf3>
    53ca:	8baa                	mv	s7,a0
    53cc:	87ea                	mv	a5,s10
    53ce:	4705                	li	a4,1
    53d0:	b1f1                	j	509c <.L118>

000053d2 <.L127>:
    53d2:	853e                	mv	a0,a5
    53d4:	85e6                	mv	a1,s9
    53d6:	d7ffe0ef          	jal	4154 <__mulsf3>
    53da:	87aa                	mv	a5,a0
    53dc:	8d5e                	mv	s10,s7
    53de:	4685                	li	a3,1
    53e0:	b1f5                	j	50cc <.L126>

000053e2 <.L132>:
    53e2:	6785                	lui	a5,0x1
    53e4:	88078793          	add	a5,a5,-1920 # 880 <__SEGGER_RTL_fdiv_reciprocal_table+0xb4>
    53e8:	00f977b3          	and	a5,s2,a5
    53ec:	80078793          	add	a5,a5,-2048
    53f0:	d40793e3          	bnez	a5,5136 <.L133>
    53f4:	47c1                	li	a5,16
    53f6:	0097d363          	bge	a5,s1,53fc <.L134>
    53fa:	44c1                	li	s1,16

000053fc <.L134>:
    53fc:	8526                	mv	a0,s1
    53fe:	9c7fd0ef          	jal	2dc4 <__SEGGER_RTL_pow10f>
    5402:	85a2                	mv	a1,s0
    5404:	d51fe0ef          	jal	4154 <__mulsf3>
    5408:	9f8ff0ef          	jal	4600 <__fixunssfdi>
    540c:	00a5e7b3          	or	a5,a1,a0
    5410:	8c2a                	mv	s8,a0
    5412:	8d2e                	mv	s10,a1
    5414:	d20780e3          	beqz	a5,5134 <.L135>

00005418 <.L357>:
    5418:	4629                	li	a2,10
    541a:	4681                	li	a3,0
    541c:	d6afd0ef          	jal	2986 <__umoddi3>
    5420:	8d4d                	or	a0,a0,a1
    5422:	d0051ae3          	bnez	a0,5136 <.L133>
    5426:	8562                	mv	a0,s8
    5428:	85ea                	mv	a1,s10
    542a:	4629                	li	a2,10
    542c:	4681                	li	a3,0
    542e:	940fd0ef          	jal	256e <__udivdi3>
    5432:	14fd                	add	s1,s1,-1
    5434:	8c2a                	mv	s8,a0
    5436:	8d2e                	mv	s10,a1
    5438:	f0e5                	bnez	s1,5418 <.L357>
    543a:	b9ed                	j	5134 <.L135>

0000543c <.L142>:
    543c:	6681a583          	lw	a1,1640(gp) # f0c <.Lmerged_single+0xc>
    5440:	4532                	lw	a0,12(sp)
    5442:	1b79                	add	s6,s6,-2
    5444:	4d0d                	li	s10,3
    5446:	d0ffe0ef          	jal	4154 <__mulsf3>
    544a:	ffeb8793          	add	a5,s7,-2
    544e:	842a                	mv	s0,a0
    5450:	da3e                	sw	a5,52(sp)
    5452:	bb25                	j	518a <.L141>

00005454 <.L148>:
    5454:	0505                	add	a0,a0,1
    5456:	8c89                	sub	s1,s1,a0
    5458:	47c1                	li	a5,16
    545a:	0097d363          	bge	a5,s1,5460 <.L149>
    545e:	44c1                	li	s1,16

00005460 <.L149>:
    5460:	08097793          	and	a5,s2,128
    5464:	e80791e3          	bnez	a5,52e6 <.L147>
    5468:	65c1ac03          	lw	s8,1628(gp) # f00 <.Lmerged_single>
    546c:	6641a403          	lw	s0,1636(gp) # f08 <.Lmerged_single+0x8>

00005470 <.L150>:
    5470:	e6048ae3          	beqz	s1,52e4 <.L153>
    5474:	8526                	mv	a0,s1
    5476:	94ffd0ef          	jal	2dc4 <__SEGGER_RTL_pow10f>
    547a:	85aa                	mv	a1,a0
    547c:	855e                	mv	a0,s7
    547e:	cd7fe0ef          	jal	4154 <__mulsf3>
    5482:	85e2                	mv	a1,s8
    5484:	bc3fc0ef          	jal	2046 <__addsf3>
    5488:	85afd0ef          	jal	24e2 <floorf>
    548c:	85a2                	mv	a1,s0
    548e:	ab2ff0ef          	jal	4740 <fmodf>
    5492:	00000593          	li	a1,0
    5496:	93eff0ef          	jal	45d4 <__eqsf2>
    549a:	e40516e3          	bnez	a0,52e6 <.L147>
    549e:	14fd                	add	s1,s1,-1
    54a0:	bfc1                	j	5470 <.L150>

000054a2 <.L159>:
    54a2:	856a                	mv	a0,s10
    54a4:	da02                	sw	zero,52(sp)
    54a6:	95aff0ef          	jal	4600 <__fixunssfdi>
    54aa:	8bae                	mv	s7,a1
    54ac:	8caa                	mv	s9,a0
    54ae:	e59fc0ef          	jal	2306 <__floatundisf>
    54b2:	85aa                	mv	a1,a0
    54b4:	856a                	mv	a0,s10
    54b6:	b89fc0ef          	jal	203e <__subsf3>
    54ba:	842a                	mv	s0,a0
    54bc:	bd61                	j	5354 <.L160>

000054be <.L158>:
    54be:	da02                	sw	zero,52(sp)
    54c0:	4c81                	li	s9,0
    54c2:	4b81                	li	s7,0
    54c4:	bd41                	j	5354 <.L160>

000054c6 <.L162>:
    54c6:	0d05                	add	s10,s10,1
    54c8:	bd59                	j	535e <.L161>

000054ca <.L168>:
    54ca:	02000593          	li	a1,32
    54ce:	854e                	mv	a0,s3
    54d0:	197d                	add	s2,s2,-1
    54d2:	ce2ff0ef          	jal	49b4 <__SEGGER_RTL_putc>
    54d6:	b9ed                	j	51d0 <.L166>

000054d8 <.L169>:
    54d8:	d0078ce3          	beqz	a5,51f0 <.L171>
    54dc:	02000593          	li	a1,32
    54e0:	b329                	j	51ea <.L358>

000054e2 <.L174>:
    54e2:	03000593          	li	a1,48
    54e6:	854e                	mv	a0,s3
    54e8:	197d                	add	s2,s2,-1
    54ea:	ccaff0ef          	jal	49b4 <__SEGGER_RTL_putc>
    54ee:	b321                	j	51f6 <.L172>

000054f0 <.L176>:
    54f0:	40ec86b3          	sub	a3,s9,a4
    54f4:	00dcb633          	sltu	a2,s9,a3
    54f8:	0585                	add	a1,a1,1
    54fa:	40fb8bb3          	sub	s7,s7,a5
    54fe:	0ff5f593          	zext.b	a1,a1
    5502:	8cb6                	mv	s9,a3
    5504:	40cb8bb3          	sub	s7,s7,a2
    5508:	b329                	j	5212 <.L175>

0000550a <.L182>:
    550a:	17fd                	add	a5,a5,-1
    550c:	03000593          	li	a1,48
    5510:	854e                	mv	a0,s3
    5512:	da3e                	sw	a5,52(sp)
    5514:	ca0ff0ef          	jal	49b4 <__SEGGER_RTL_putc>

00005518 <.L179>:
    5518:	57d2                	lw	a5,52(sp)
    551a:	fef048e3          	bgtz	a5,550a <.L182>
    551e:	bb21                	j	5236 <.L183>

00005520 <.L186>:
    5520:	d204d9e3          	bgez	s1,5252 <.L187>
    5524:	4c81                	li	s9,0
    5526:	b335                	j	5252 <.L187>

00005528 <.L194>:
    5528:	1cfd                	add	s9,s9,-1
    552a:	003c9793          	sll	a5,s9,0x3
    552e:	97da                	add	a5,a5,s6
    5530:	4398                	lw	a4,0(a5)
    5532:	43dc                	lw	a5,4(a5)
    5534:	03000593          	li	a1,48

00005538 <.L190>:
    5538:	00f46663          	bltu	s0,a5,5544 <.L259>
    553c:	00879863          	bne	a5,s0,554c <.L191>
    5540:	00ebf663          	bgeu	s7,a4,554c <.L191>

00005544 <.L259>:
    5544:	854e                	mv	a0,s3
    5546:	c6eff0ef          	jal	49b4 <__SEGGER_RTL_putc>
    554a:	b32d                	j	5274 <.L193>

0000554c <.L191>:
    554c:	40eb86b3          	sub	a3,s7,a4
    5550:	00dbb633          	sltu	a2,s7,a3
    5554:	0585                	add	a1,a1,1
    5556:	8c1d                	sub	s0,s0,a5
    5558:	0ff5f593          	zext.b	a1,a1
    555c:	8bb6                	mv	s7,a3
    555e:	8c11                	sub	s0,s0,a2
    5560:	bfe1                	j	5538 <.L190>

00005562 <.L196>:
    5562:	03000593          	li	a1,48
    5566:	854e                	mv	a0,s3
    5568:	14fd                	add	s1,s1,-1
    556a:	c4aff0ef          	jal	49b4 <__SEGGER_RTL_putc>
    556e:	b329                	j	5278 <.L195>

00005570 <.L184>:
    5570:	012c1793          	sll	a5,s8,0x12
    5574:	06500593          	li	a1,101
    5578:	0007d463          	bgez	a5,5580 <.L197>
    557c:	04500593          	li	a1,69

00005580 <.L197>:
    5580:	854e                	mv	a0,s3
    5582:	c32ff0ef          	jal	49b4 <__SEGGER_RTL_putc>
    5586:	57d2                	lw	a5,52(sp)
    5588:	0407df63          	bgez	a5,55e6 <.L198>
    558c:	02d00593          	li	a1,45
    5590:	854e                	mv	a0,s3
    5592:	c22ff0ef          	jal	49b4 <__SEGGER_RTL_putc>
    5596:	57d2                	lw	a5,52(sp)
    5598:	40f007b3          	neg	a5,a5
    559c:	da3e                	sw	a5,52(sp)

0000559e <.L199>:
    559e:	55d2                	lw	a1,52(sp)
    55a0:	06300793          	li	a5,99
    55a4:	00b7df63          	bge	a5,a1,55c2 <.L200>
    55a8:	06400413          	li	s0,100
    55ac:	0285c5b3          	div	a1,a1,s0
    55b0:	854e                	mv	a0,s3
    55b2:	03058593          	add	a1,a1,48
    55b6:	bfeff0ef          	jal	49b4 <__SEGGER_RTL_putc>
    55ba:	57d2                	lw	a5,52(sp)
    55bc:	0287e7b3          	rem	a5,a5,s0
    55c0:	da3e                	sw	a5,52(sp)

000055c2 <.L200>:
    55c2:	55d2                	lw	a1,52(sp)
    55c4:	4429                	li	s0,10
    55c6:	854e                	mv	a0,s3
    55c8:	0285c5b3          	div	a1,a1,s0
    55cc:	03058593          	add	a1,a1,48
    55d0:	be4ff0ef          	jal	49b4 <__SEGGER_RTL_putc>
    55d4:	55d2                	lw	a1,52(sp)
    55d6:	0285e5b3          	rem	a1,a1,s0
    55da:	03058593          	add	a1,a1,48

000055de <.L360>:
    55de:	854e                	mv	a0,s3
    55e0:	bd4ff0ef          	jal	49b4 <__SEGGER_RTL_putc>
    55e4:	b145                	j	5284 <.L201>

000055e6 <.L198>:
    55e6:	02b00593          	li	a1,43
    55ea:	854e                	mv	a0,s3
    55ec:	bc8ff0ef          	jal	49b4 <__SEGGER_RTL_putc>
    55f0:	b77d                	j	559e <.L199>

000055f2 <.L205>:
    55f2:	6d21                	lui	s10,0x8
    55f4:	892e                	mv	s2,a1
    55f6:	4c01                	li	s8,0
    55f8:	01abfd33          	and	s10,s7,s10
    55fc:	470d                	li	a4,3
    55fe:	02c00813          	li	a6,44

00005602 <.L208>:
    5602:	012467b3          	or	a5,s0,s2
    5606:	c7b5                	beqz	a5,5672 <.L206>
    5608:	000d0d63          	beqz	s10,5622 <.L214>
    560c:	003c7793          	and	a5,s8,3
    5610:	00e79963          	bne	a5,a4,5622 <.L214>
    5614:	030c0793          	add	a5,s8,48
    5618:	1018                	add	a4,sp,32
    561a:	97ba                	add	a5,a5,a4
    561c:	ff078423          	sb	a6,-24(a5)
    5620:	0c05                	add	s8,s8,1

00005622 <.L214>:
    5622:	1018                	add	a4,sp,32
    5624:	030c0793          	add	a5,s8,48
    5628:	97ba                	add	a5,a5,a4
    562a:	4629                	li	a2,10
    562c:	4681                	li	a3,0
    562e:	8522                	mv	a0,s0
    5630:	85ca                	mv	a1,s2
    5632:	c63e                	sw	a5,12(sp)
    5634:	b52fd0ef          	jal	2986 <__umoddi3>
    5638:	47b2                	lw	a5,12(sp)
    563a:	03050513          	add	a0,a0,48
    563e:	85ca                	mv	a1,s2
    5640:	fea78423          	sb	a0,-24(a5)
    5644:	4629                	li	a2,10
    5646:	8522                	mv	a0,s0
    5648:	4681                	li	a3,0
    564a:	f25fc0ef          	jal	256e <__udivdi3>
    564e:	0c05                	add	s8,s8,1
    5650:	842a                	mv	s0,a0
    5652:	892e                	mv	s2,a1
    5654:	02c00813          	li	a6,44
    5658:	470d                	li	a4,3
    565a:	b765                	j	5602 <.L208>

0000565c <.L204>:
    565c:	6709                	lui	a4,0x2
    565e:	4c01                	li	s8,0
    5660:	00ebf733          	and	a4,s7,a4
    5664:	44018693          	add	a3,gp,1088 # ce4 <__SEGGER_RTL_hex_lc>
    5668:	45018613          	add	a2,gp,1104 # cf4 <__SEGGER_RTL_hex_uc>

0000566c <.L209>:
    566c:	00b467b3          	or	a5,s0,a1
    5670:	e38d                	bnez	a5,5692 <.L212>

00005672 <.L206>:
    5672:	418484b3          	sub	s1,s1,s8
    5676:	0004d363          	bgez	s1,567c <.L216>
    567a:	4481                	li	s1,0

0000567c <.L216>:
    567c:	409b0b33          	sub	s6,s6,s1
    5680:	0ff00793          	li	a5,255
    5684:	418b0b33          	sub	s6,s6,s8
    5688:	0397f863          	bgeu	a5,s9,56b8 <.L217>
    568c:	1b7d                	add	s6,s6,-1

0000568e <.L218>:
    568e:	1b7d                	add	s6,s6,-1
    5690:	a035                	j	56bc <.L219>

00005692 <.L212>:
    5692:	00f47793          	and	a5,s0,15
    5696:	cf19                	beqz	a4,56b4 <.L210>
    5698:	97b2                	add	a5,a5,a2

0000569a <.L361>:
    569a:	0007c783          	lbu	a5,0(a5)
    569e:	1828                	add	a0,sp,56
    56a0:	9562                	add	a0,a0,s8
    56a2:	00f50023          	sb	a5,0(a0)
    56a6:	8011                	srl	s0,s0,0x4
    56a8:	01c59793          	sll	a5,a1,0x1c
    56ac:	0c05                	add	s8,s8,1
    56ae:	8c5d                	or	s0,s0,a5
    56b0:	8191                	srl	a1,a1,0x4
    56b2:	bf6d                	j	566c <.L209>

000056b4 <.L210>:
    56b4:	97b6                	add	a5,a5,a3
    56b6:	b7d5                	j	569a <.L361>

000056b8 <.L217>:
    56b8:	fc0c9be3          	bnez	s9,568e <.L218>

000056bc <.L219>:
    56bc:	200bf793          	and	a5,s7,512
    56c0:	e799                	bnez	a5,56ce <.L220>
    56c2:	865a                	mv	a2,s6
    56c4:	85de                	mv	a1,s7
    56c6:	854e                	mv	a0,s3
    56c8:	f70fd0ef          	jal	2e38 <__SEGGER_RTL_pre_padding>
    56cc:	4b01                	li	s6,0

000056ce <.L220>:
    56ce:	0ff00793          	li	a5,255
    56d2:	0197fc63          	bgeu	a5,s9,56ea <.L221>
    56d6:	03000593          	li	a1,48
    56da:	854e                	mv	a0,s3
    56dc:	ad8ff0ef          	jal	49b4 <__SEGGER_RTL_putc>

000056e0 <.L222>:
    56e0:	85e6                	mv	a1,s9
    56e2:	854e                	mv	a0,s3
    56e4:	ad0ff0ef          	jal	49b4 <__SEGGER_RTL_putc>
    56e8:	a019                	j	56ee <.L223>

000056ea <.L221>:
    56ea:	fe0c9be3          	bnez	s9,56e0 <.L222>

000056ee <.L223>:
    56ee:	865a                	mv	a2,s6
    56f0:	85de                	mv	a1,s7
    56f2:	854e                	mv	a0,s3
    56f4:	f44fd0ef          	jal	2e38 <__SEGGER_RTL_pre_padding>
    56f8:	8626                	mv	a2,s1
    56fa:	03000593          	li	a1,48
    56fe:	854e                	mv	a0,s3
    5700:	b50ff0ef          	jal	4a50 <__SEGGER_RTL_print_padding>

00005704 <.L224>:
    5704:	1c7d                	add	s8,s8,-1
    5706:	e40c4c63          	bltz	s8,4d5e <.L371>
    570a:	183c                	add	a5,sp,56
    570c:	97e2                	add	a5,a5,s8
    570e:	0007c583          	lbu	a1,0(a5)
    5712:	854e                	mv	a0,s3
    5714:	aa0ff0ef          	jal	49b4 <__SEGGER_RTL_putc>
    5718:	b7f5                	j	5704 <.L224>

0000571a <.L34>:
    571a:	07800713          	li	a4,120
    571e:	daf76163          	bltu	a4,a5,4cc0 <.L4>

00005722 <.L38>:
    5722:	fa878713          	add	a4,a5,-88
    5726:	0ff77713          	zext.b	a4,a4
    572a:	02000693          	li	a3,32
    572e:	d8e6e963          	bltu	a3,a4,4cc0 <.L4>
    5732:	46d2                	lw	a3,20(sp)
    5734:	070a                	sll	a4,a4,0x2
    5736:	9736                	add	a4,a4,a3
    5738:	4318                	lw	a4,0(a4)
    573a:	8702                	jr	a4

Disassembly of section .text.libc.__SEGGER_RTL_ascii_isctype:

0000573c <__SEGGER_RTL_ascii_isctype>:
    573c:	07f00793          	li	a5,127
    5740:	02a7e063          	bltu	a5,a0,5760 <.L3>
    5744:	5dc18793          	add	a5,gp,1500 # e80 <__SEGGER_RTL_ascii_ctype_map>
    5748:	953e                	add	a0,a0,a5
    574a:	000027b7          	lui	a5,0x2
    574e:	98478793          	add	a5,a5,-1660 # 1984 <__SEGGER_RTL_ascii_ctype_mask>
    5752:	95be                	add	a1,a1,a5
    5754:	00054503          	lbu	a0,0(a0)
    5758:	0005c783          	lbu	a5,0(a1)
    575c:	8d7d                	and	a0,a0,a5
    575e:	8082                	ret

00005760 <.L3>:
    5760:	4501                	li	a0,0
    5762:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_tolower:

00005764 <__SEGGER_RTL_ascii_tolower>:
    5764:	fbf50713          	add	a4,a0,-65
    5768:	47e5                	li	a5,25
    576a:	00e7e463          	bltu	a5,a4,5772 <.L7>
    576e:	02050513          	add	a0,a0,32

00005772 <.L7>:
    5772:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_iswctype:

00005774 <__SEGGER_RTL_ascii_iswctype>:
    5774:	07f00793          	li	a5,127
    5778:	02a7e063          	bltu	a5,a0,5798 <.L10>
    577c:	5dc18793          	add	a5,gp,1500 # e80 <__SEGGER_RTL_ascii_ctype_map>
    5780:	953e                	add	a0,a0,a5
    5782:	000027b7          	lui	a5,0x2
    5786:	98478793          	add	a5,a5,-1660 # 1984 <__SEGGER_RTL_ascii_ctype_mask>
    578a:	95be                	add	a1,a1,a5
    578c:	00054503          	lbu	a0,0(a0)
    5790:	0005c783          	lbu	a5,0(a1)
    5794:	8d7d                	and	a0,a0,a5
    5796:	8082                	ret

00005798 <.L10>:
    5798:	4501                	li	a0,0
    579a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towlower:

0000579c <__SEGGER_RTL_ascii_towlower>:
    579c:	fbf50713          	add	a4,a0,-65
    57a0:	47e5                	li	a5,25
    57a2:	00e7e463          	bltu	a5,a4,57aa <.L14>
    57a6:	02050513          	add	a0,a0,32

000057aa <.L14>:
    57aa:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_wctomb:

000057ac <__SEGGER_RTL_ascii_wctomb>:
    57ac:	07f00793          	li	a5,127
    57b0:	00b7e663          	bltu	a5,a1,57bc <.L66>
    57b4:	00b50023          	sb	a1,0(a0)
    57b8:	4505                	li	a0,1
    57ba:	8082                	ret

000057bc <.L66>:
    57bc:	5579                	li	a0,-2
    57be:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_current_locale:

000057c0 <__SEGGER_RTL_current_locale>:
    57c0:	83c22503          	lw	a0,-1988(tp) # fffff83c <__SHARE_RAM_segment_end__+0xfee7f83c>
    57c4:	e119                	bnez	a0,57ca <.L155>
    57c6:	80020513          	add	a0,tp,-2048 # fffff800 <__SHARE_RAM_segment_end__+0xfee7f800>

000057ca <.L155>:
    57ca:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_zero:

00005818 <__SEGGER_init_zero>:
    5818:	4008                	lw	a0,0(s0)
    581a:	404c                	lw	a1,4(s0)
    581c:	0421                	add	s0,s0,8
    581e:	c591                	beqz	a1,582a <.L__SEGGER_init_zero_Done>

00005820 <.L__SEGGER_init_zero_Loop>:
    5820:	00050023          	sb	zero,0(a0)
    5824:	0505                	add	a0,a0,1
    5826:	15fd                	add	a1,a1,-1
    5828:	fde5                	bnez	a1,5820 <.L__SEGGER_init_zero_Loop>

0000582a <.L__SEGGER_init_zero_Done>:
    582a:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_copy:

0000582c <__SEGGER_init_copy>:
    582c:	4008                	lw	a0,0(s0)
    582e:	404c                	lw	a1,4(s0)
    5830:	4410                	lw	a2,8(s0)
    5832:	0431                	add	s0,s0,12
    5834:	ca09                	beqz	a2,5846 <.L__SEGGER_init_copy_Done>

00005836 <.L__SEGGER_init_copy_Loop>:
    5836:	00058683          	lb	a3,0(a1)
    583a:	00d50023          	sb	a3,0(a0)
    583e:	0505                	add	a0,a0,1
    5840:	0585                	add	a1,a1,1
    5842:	167d                	add	a2,a2,-1
    5844:	fa6d                	bnez	a2,5836 <.L__SEGGER_init_copy_Loop>

00005846 <.L__SEGGER_init_copy_Done>:
    5846:	8082                	ret
