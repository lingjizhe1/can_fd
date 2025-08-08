
Output/Debug/Exe/demo.elf:     file format elf32-littleriscv


Disassembly of section .init._start:

80003000 <_start>:
#define L(label) .L_start_##label

START_FUNC _start
        .option push
        .option norelax
        lui     gp,     %hi(__global_pointer$)
80003000:	800091b7          	lui	gp,0x80009
        addi    gp, gp, %lo(__global_pointer$)
80003004:	36c18193          	add	gp,gp,876 # 8000936c <__global_pointer$>
        lui     tp,     %hi(__thread_pointer$)
80003008:	01081237          	lui	tp,0x1081
        addi    tp, tp, %lo(__thread_pointer$)
8000300c:	80020213          	add	tp,tp,-2048 # 1080800 <__thread_pointer$>
        .option pop

        csrw    mstatus, zero
80003010:	30001073          	csrw	mstatus,zero
        csrw    mcause, zero
80003014:	34201073          	csrw	mcause,zero
    /* Initialize FCSR */
    fscsr zero
#endif

    /* Enable LMM1 clock */
    la t0, 0xF4000800
80003018:	f40012b7          	lui	t0,0xf4001
8000301c:	80028293          	add	t0,t0,-2048 # f4000800 <__AHB_SRAM_segment_end__+0x3cf8800>
    lw t1, 0(t0)
80003020:	0002a303          	lw	t1,0(t0)
    ori t1, t1, 0x80
80003024:	08036313          	or	t1,t1,128
    sw t1, 0(t0)
80003028:	0062a023          	sw	t1,0(t0)

8000302c <.Lpcrel_hi0>:

#ifdef INIT_EXT_RAM_FOR_DATA
    la t0, _stack_safe
8000302c:	000c02b7          	lui	t0,0xc0
80003030:	00028293          	mv	t0,t0
    mv sp, t0
80003034:	8116                	mv	sp,t0
    call _init_ext_ram
80003036:	5b1090ef          	jal	8000cde6 <_init_ext_ram>
#endif

        lui     t0,     %hi(__stack_end__)
8000303a:	000c02b7          	lui	t0,0xc0
        addi    sp, t0, %lo(__stack_end__)
8000303e:	00028113          	mv	sp,t0

#ifdef CONFIG_NOT_ENABLE_ICACHE
        call    l1c_ic_disable
#else
        call    l1c_ic_enable
80003042:	0b9060ef          	jal	800098fa <l1c_ic_enable>
#endif
#ifdef CONFIG_NOT_ENABLE_DCACHE
        call    l1c_dc_invalidate_all
        call    l1c_dc_disable
#else
        call    l1c_dc_enable
80003046:	061060ef          	jal	800098a6 <l1c_dc_enable>
        call    l1c_dc_invalidate_all
8000304a:	277090ef          	jal	8000cac0 <l1c_dc_invalidate_all>

#ifndef __NO_SYSTEM_INIT
        //
        // Call _init
        //
        call    _init
8000304e:	6bb0b0ef          	jal	8000ef08 <_init>

80003052 <.Lpcrel_hi1>:
        // Call linker init functions which in turn performs the following:
        // * Perform segment init
        // * Perform heap init (if used)
        // * Call constructors of global Objects (if any exist)
        //
        la      s0, __SEGGER_init_table__       // Set table pointer to start of initialization table
80003052:	80011437          	lui	s0,0x80011
80003056:	d4040413          	add	s0,s0,-704 # 80010d40 <.L155+0x2>

8000305a <.L_start_RunInit>:
L(RunInit):
        lw      a0, (s0)                        // Get next initialization function from table
8000305a:	4008                	lw	a0,0(s0)
        add     s0, s0, 4                       // Increment table pointer to point to function arguments
8000305c:	0411                	add	s0,s0,4
        jalr    a0                              // Call initialization function
8000305e:	9502                	jalr	a0
        j       L(RunInit)
80003060:	bfed                	j	8000305a <.L_start_RunInit>

80003062 <__SEGGER_init_done>:
        // Time to call main(), the application entry point.
        //

#ifndef NO_CLEANUP_AT_START
    /* clean up */
    call _clean_up
80003062:	5e50b0ef          	jal	8000ee46 <_clean_up>

80003066 <.Lpcrel_hi2>:
    #define HANDLER_S_TRAP irq_handler_s_trap
#endif

#if !defined(USE_NONVECTOR_MODE) || (USE_NONVECTOR_MODE == 0)
    /* Initial machine trap-vector Base */
    la t0, __vector_table
80003066:	000002b7          	lui	t0,0x0
8000306a:	00028293          	mv	t0,t0
    csrw mtvec, t0
8000306e:	30529073          	csrw	mtvec,t0

    /* Enable vectored external PLIC interrupt */
    csrsi CSR_MMISC_CTL, 2
80003072:	7d016073          	csrs	0x7d0,2

80003076 <start>:
        //
        // In a real embedded application ("Free-standing environment"),
        // main() does not get any arguments,
        // which means it is not necessary to init a0 and a1.
        //
        call    APP_ENTRY_POINT
80003076:	67d0b0ef          	jal	8000eef2 <reset_handler>
        tail    exit
8000307a:	a009                	j	8000307c <exit>

8000307c <exit>:
MARK_FUNC exit
        //
        // In a free-standing environment, if returned from application:
        // Loop forever.
        //
        j       .
8000307c:	a001                	j	8000307c <exit>
        la      a1, args
        call    debug_getargs
        li      a0, ARGSSPACE
        la      a1, args
#else
        li      a0, 0
8000307e:	4501                	li	a0,0
        li      a1, 0
80003080:	4581                	li	a1,0
#endif

        call    APP_ENTRY_POINT
80003082:	6710b0ef          	jal	8000eef2 <reset_handler>
        tail    exit
80003086:	bfdd                	j	8000307c <exit>

Disassembly of section .text.l1c_op:

8000981a <l1c_op>:
                                             assert(address % HPM_L1C_CACHELINE_SIZE == 0); \
                                             assert(size % HPM_L1C_CACHELINE_SIZE == 0); \
                                        } while (0)

static void l1c_op(uint8_t opcode, uint32_t address, uint32_t size)
{
8000981a:	7179                	add	sp,sp,-48
8000981c:	d622                	sw	s0,44(sp)
8000981e:	87aa                	mv	a5,a0
80009820:	c42e                	sw	a1,8(sp)
80009822:	c232                	sw	a2,4(sp)
80009824:	00f107a3          	sb	a5,15(sp)
        l1c_cctl_address_cmd(opcode, address + i * HPM_L1C_CACHELINE_SIZE);
        tmp += HPM_L1C_CACHELINE_SIZE;
    }
#else
    register uint32_t next_address;
    next_address = address;
80009828:	4422                	lw	s0,8(sp)
8000982a:	ce22                	sw	s0,28(sp)

8000982c <.LBB41>:
    (uint32_t)(((x) << HPM_MCCTLBEGINADDR_WAY_SHIFT) & HPM_MCCTLBEGINADDR_WAY_MASK)

/* send IX command */
ATTR_ALWAYS_INLINE static inline void l1c_cctl_address(uint32_t address)
{
    write_csr(CSR_MCCTLBEGINADDR, address);
8000982c:	47f2                	lw	a5,28(sp)
8000982e:	7cb79073          	csrw	0x7cb,a5
}
80009832:	0001                	nop

80009834 <.LBE41>:
    l1c_cctl_address(next_address);
    while ((next_address < (address + size)) && (next_address >= address)) {
80009834:	a005                	j	80009854 <.L2>

80009836 <.L5>:
80009836:	00f14783          	lbu	a5,15(sp)
8000983a:	00f10ba3          	sb	a5,23(sp)

8000983e <.LBB43>:

/* send command */
ATTR_ALWAYS_INLINE static inline void l1c_cctl_cmd(uint8_t cmd)
{
    write_csr(CSR_MCCTLCOMMAND, cmd);
8000983e:	01714783          	lbu	a5,23(sp)
80009842:	7cc79073          	csrw	0x7cc,a5
}
80009846:	0001                	nop

80009848 <.LBB45>:

ATTR_ALWAYS_INLINE static inline uint32_t l1c_cctl_get_address(void)
{
    return read_csr(CSR_MCCTLBEGINADDR);
80009848:	7cb027f3          	csrr	a5,0x7cb
8000984c:	cc3e                	sw	a5,24(sp)
8000984e:	47e2                	lw	a5,24(sp)

80009850 <.LBE47>:
80009850:	0001                	nop

80009852 <.LBE45>:
        l1c_cctl_cmd(opcode);
        next_address = l1c_cctl_get_address();
80009852:	843e                	mv	s0,a5

80009854 <.L2>:
    while ((next_address < (address + size)) && (next_address >= address)) {
80009854:	4722                	lw	a4,8(sp)
80009856:	4792                	lw	a5,4(sp)
80009858:	97ba                	add	a5,a5,a4
8000985a:	00f47563          	bgeu	s0,a5,80009864 <.L6>
8000985e:	47a2                	lw	a5,8(sp)
80009860:	fcf47be3          	bgeu	s0,a5,80009836 <.L5>

80009864 <.L6>:
    }
#endif
}
80009864:	0001                	nop
80009866:	5432                	lw	s0,44(sp)
80009868:	6145                	add	sp,sp,48
8000986a:	8082                	ret

Disassembly of section .text.l1c_dc_enable:

800098a6 <l1c_dc_enable>:

void l1c_dc_enable(void)
{
800098a6:	1101                	add	sp,sp,-32
800098a8:	ce06                	sw	ra,28(sp)

800098aa <.LBB48>:
    return read_csr(CSR_MCACHE_CTL);
800098aa:	7ca027f3          	csrr	a5,0x7ca
800098ae:	c63e                	sw	a5,12(sp)
800098b0:	47b2                	lw	a5,12(sp)

800098b2 <.LBE52>:
800098b2:	0001                	nop

800098b4 <.LBE50>:
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
800098b4:	8b89                	and	a5,a5,2
800098b6:	00f037b3          	snez	a5,a5
800098ba:	0ff7f793          	zext.b	a5,a5

800098be <.LBE48>:
    if (!l1c_dc_is_enabled()) {
800098be:	0017c793          	xor	a5,a5,1
800098c2:	0ff7f793          	zext.b	a5,a5
800098c6:	c791                	beqz	a5,800098d2 <.L11>
#ifdef L1C_DC_DISABLE_WRITEAROUND_ON_ENABLE
        l1c_dc_disable_writearound();
#else
        l1c_dc_enable_writearound();
800098c8:	20d9                	jal	8000998e <l1c_dc_enable_writearound>
#endif
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DPREF_EN_MASK | HPM_MCACHE_CTL_DC_EN_MASK);
800098ca:	40200793          	li	a5,1026
800098ce:	7ca7a073          	csrs	0x7ca,a5

800098d2 <.L11>:
    }
}
800098d2:	0001                	nop
800098d4:	40f2                	lw	ra,28(sp)
800098d6:	6105                	add	sp,sp,32
800098d8:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_DFL:

800098da <__SEGGER_RTL_SIGNAL_SIG_DFL>:
800098da:	8082                	ret

Disassembly of section .text.l1c_ic_enable:

800098fa <l1c_ic_enable>:
        clear_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_EN_MASK);
    }
}

void l1c_ic_enable(void)
{
800098fa:	1141                	add	sp,sp,-16

800098fc <.LBB58>:
    return read_csr(CSR_MCACHE_CTL);
800098fc:	7ca027f3          	csrr	a5,0x7ca
80009900:	c63e                	sw	a5,12(sp)
80009902:	47b2                	lw	a5,12(sp)

80009904 <.LBE62>:
80009904:	0001                	nop

80009906 <.LBE60>:
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
80009906:	8b85                	and	a5,a5,1
80009908:	00f037b3          	snez	a5,a5
8000990c:	0ff7f793          	zext.b	a5,a5

80009910 <.LBE58>:
    if (!l1c_ic_is_enabled()) {
80009910:	0017c793          	xor	a5,a5,1
80009914:	0ff7f793          	zext.b	a5,a5
80009918:	c789                	beqz	a5,80009922 <.L21>
        set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_IPREF_EN_MASK
8000991a:	30100793          	li	a5,769
8000991e:	7ca7a073          	csrs	0x7ca,a5

80009922 <.L21>:
                              | HPM_MCACHE_CTL_CCTL_SUEN_MASK
                              | HPM_MCACHE_CTL_IC_EN_MASK);
    }
}
80009922:	0001                	nop
80009924:	0141                	add	sp,sp,16
80009926:	8082                	ret

Disassembly of section .text.l1c_dc_flush:

80009932 <l1c_dc_flush>:
    ASSERT_ADDR_SIZE(address, size);
    l1c_op(HPM_L1C_CCTL_CMD_L1D_VA_WB, address, size);
}

void l1c_dc_flush(uint32_t address, uint32_t size)
{
80009932:	1101                	add	sp,sp,-32
80009934:	ce06                	sw	ra,28(sp)
80009936:	c62a                	sw	a0,12(sp)
80009938:	c42e                	sw	a1,8(sp)
    ASSERT_ADDR_SIZE(address, size);
8000993a:	47b2                	lw	a5,12(sp)
8000993c:	03f7f793          	and	a5,a5,63
80009940:	cf89                	beqz	a5,8000995a <.L44>
80009942:	07500613          	li	a2,117
80009946:	8000a7b7          	lui	a5,0x8000a
8000994a:	2ec78593          	add	a1,a5,748 # 8000a2ec <.LC0>
8000994e:	8000a7b7          	lui	a5,0x8000a
80009952:	32c78513          	add	a0,a5,812 # 8000a32c <.LC1>
80009956:	265050ef          	jal	8000f3ba <__SEGGER_RTL_X_assert>

8000995a <.L44>:
8000995a:	47a2                	lw	a5,8(sp)
8000995c:	03f7f793          	and	a5,a5,63
80009960:	cf89                	beqz	a5,8000997a <.L45>
80009962:	07500613          	li	a2,117
80009966:	8000a7b7          	lui	a5,0x8000a
8000996a:	2ec78593          	add	a1,a5,748 # 8000a2ec <.LC0>
8000996e:	8000a7b7          	lui	a5,0x8000a
80009972:	35478513          	add	a0,a5,852 # 8000a354 <.LC2>
80009976:	245050ef          	jal	8000f3ba <__SEGGER_RTL_X_assert>

8000997a <.L45>:
    l1c_op(HPM_L1C_CCTL_CMD_L1D_VA_WBINVAL, address, size);
8000997a:	4622                	lw	a2,8(sp)
8000997c:	45b2                	lw	a1,12(sp)
8000997e:	4509                	li	a0,2
80009980:	3d69                	jal	8000981a <l1c_op>
}
80009982:	0001                	nop
80009984:	40f2                	lw	ra,28(sp)
80009986:	6105                	add	sp,sp,32
80009988:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_IGN:

8000998a <__SEGGER_RTL_SIGNAL_SIG_IGN>:
8000998a:	8082                	ret

Disassembly of section .text.l1c_dc_enable_writearound:

8000998e <l1c_dc_enable_writearound>:
    l1c_op(HPM_L1C_CCTL_CMD_L1I_VA_UNLOCK, address, size);
}

void l1c_dc_enable_writearound(void)
{
    set_csr(CSR_MCACHE_CTL, HPM_MCACHE_CTL_DC_WAROUND_MASK);
8000998e:	6799                	lui	a5,0x6
80009990:	7ca7a073          	csrs	0x7ca,a5
}
80009994:	0001                	nop
80009996:	8082                	ret

Disassembly of section .text.pllctl_xtal_set_rampup_time:

800099d2 <pllctl_xtal_set_rampup_time>:
 * @param [in] ptr Base address of the PLLCTL peripheral
 * @param [in] cycles Number of IRC24M clock cycles for ramp-up
 * @note The ramp-up time affects crystal oscillator startup
 */
static inline void pllctl_xtal_set_rampup_time(PLLCTL_Type *ptr, uint32_t cycles)
{
800099d2:	1141                	add	sp,sp,-16
800099d4:	c62a                	sw	a0,12(sp)
800099d6:	c42e                	sw	a1,8(sp)
    ptr->XTAL = (ptr->XTAL & ~PLLCTL_XTAL_RAMP_TIME_MASK) | PLLCTL_XTAL_RAMP_TIME_SET(cycles);
800099d8:	47b2                	lw	a5,12(sp)
800099da:	4398                	lw	a4,0(a5)
800099dc:	fff007b7          	lui	a5,0xfff00
800099e0:	8f7d                	and	a4,a4,a5
800099e2:	46a2                	lw	a3,8(sp)
800099e4:	001007b7          	lui	a5,0x100
800099e8:	17fd                	add	a5,a5,-1 # fffff <__AXI_SRAM_segment_size__+0x3ffff>
800099ea:	8ff5                	and	a5,a5,a3
800099ec:	8f5d                	or	a4,a4,a5
800099ee:	47b2                	lw	a5,12(sp)
800099f0:	c398                	sw	a4,0(a5)
}
800099f2:	0001                	nop
800099f4:	0141                	add	sp,sp,16
800099f6:	8082                	ret

Disassembly of section .text.pcfg_dcdc_switch_to_dcm_mode:

80009b6e <pcfg_dcdc_switch_to_dcm_mode>:
 * @brief dcdc switch to dcm mode
 *
 * @param[in] ptr base address
 */
static inline void pcfg_dcdc_switch_to_dcm_mode(PCFG_Type *ptr)
{
80009b6e:	7139                	add	sp,sp,-64
80009b70:	c62a                	sw	a0,12(sp)
    const uint8_t pcfc_dcdc_min_duty_cycle[] = {
80009b72:	fc418793          	add	a5,gp,-60 # 80009330 <.LC0>
80009b76:	0007a883          	lw	a7,0(a5)
80009b7a:	0047a803          	lw	a6,4(a5)
80009b7e:	4788                	lw	a0,8(a5)
80009b80:	47cc                	lw	a1,12(a5)
80009b82:	4b90                	lw	a2,16(a5)
80009b84:	4bd4                	lw	a3,20(a5)
80009b86:	4f98                	lw	a4,24(a5)
80009b88:	4fdc                	lw	a5,28(a5)
80009b8a:	ce46                	sw	a7,28(sp)
80009b8c:	d042                	sw	a6,32(sp)
80009b8e:	d22a                	sw	a0,36(sp)
80009b90:	d42e                	sw	a1,40(sp)
80009b92:	d632                	sw	a2,44(sp)
80009b94:	d836                	sw	a3,48(sp)
80009b96:	da3a                	sw	a4,52(sp)
80009b98:	dc3e                	sw	a5,56(sp)
        0x76, 0x78, 0x78, 0x78, 0x78, 0x7A, 0x7A, 0x7A,
        0x7A, 0x7C, 0x7C, 0x7C, 0x7E, 0x7E, 0x7E, 0x7E
    };
    uint16_t voltage;

    ptr->DCDC_MODE |= 0x77000u;
80009b9a:	47b2                	lw	a5,12(sp)
80009b9c:	4b98                	lw	a4,16(a5)
80009b9e:	000777b7          	lui	a5,0x77
80009ba2:	8f5d                	or	a4,a4,a5
80009ba4:	47b2                	lw	a5,12(sp)
80009ba6:	cb98                	sw	a4,16(a5)
    ptr->DCDC_ADVMODE = (ptr->DCDC_ADVMODE & ~0x73F0067u) | 0x4120067u;
80009ba8:	47b2                	lw	a5,12(sp)
80009baa:	5398                	lw	a4,32(a5)
80009bac:	f8c107b7          	lui	a5,0xf8c10
80009bb0:	f9878793          	add	a5,a5,-104 # f8c0ff98 <__APB_SRAM_segment_end__+0x4b1df98>
80009bb4:	8f7d                	and	a4,a4,a5
80009bb6:	041207b7          	lui	a5,0x4120
80009bba:	06778793          	add	a5,a5,103 # 4120067 <__SHARE_RAM_segment_end__+0x2fa0067>
80009bbe:	8f5d                	or	a4,a4,a5
80009bc0:	47b2                	lw	a5,12(sp)
80009bc2:	d398                	sw	a4,32(a5)
    ptr->DCDC_PROT &= ~PCFG_DCDC_PROT_SHORT_CURRENT_MASK;
80009bc4:	47b2                	lw	a5,12(sp)
80009bc6:	4f9c                	lw	a5,24(a5)
80009bc8:	fef7f713          	and	a4,a5,-17
80009bcc:	47b2                	lw	a5,12(sp)
80009bce:	cf98                	sw	a4,24(a5)
    ptr->DCDC_PROT |= PCFG_DCDC_PROT_DISABLE_SHORT_MASK;
80009bd0:	47b2                	lw	a5,12(sp)
80009bd2:	4f9c                	lw	a5,24(a5)
80009bd4:	0807e713          	or	a4,a5,128
80009bd8:	47b2                	lw	a5,12(sp)
80009bda:	cf98                	sw	a4,24(a5)
    ptr->DCDC_MISC = 0x100000u;
80009bdc:	47b2                	lw	a5,12(sp)
80009bde:	00100737          	lui	a4,0x100
80009be2:	d798                	sw	a4,40(a5)
    voltage = PCFG_DCDC_MODE_VOLT_GET(ptr->DCDC_MODE);
80009be4:	47b2                	lw	a5,12(sp)
80009be6:	4b9c                	lw	a5,16(a5)
80009be8:	01079713          	sll	a4,a5,0x10
80009bec:	8341                	srl	a4,a4,0x10
80009bee:	6785                	lui	a5,0x1
80009bf0:	17fd                	add	a5,a5,-1 # fff <__NOR_CFG_OPTION_segment_size__+0x3ff>
80009bf2:	8ff9                	and	a5,a5,a4
80009bf4:	02f11f23          	sh	a5,62(sp)
    voltage = (voltage - 600) / 25;
80009bf8:	03e15783          	lhu	a5,62(sp)
80009bfc:	da878713          	add	a4,a5,-600
80009c00:	47e5                	li	a5,25
80009c02:	02f747b3          	div	a5,a4,a5
80009c06:	02f11f23          	sh	a5,62(sp)
    ptr->DCDC_ADVPARAM = (ptr->DCDC_ADVPARAM & ~PCFG_DCDC_ADVPARAM_MIN_DUT_MASK) | PCFG_DCDC_ADVPARAM_MIN_DUT_SET(pcfc_dcdc_min_duty_cycle[voltage]);
80009c0a:	47b2                	lw	a5,12(sp)
80009c0c:	53d8                	lw	a4,36(a5)
80009c0e:	77e1                	lui	a5,0xffff8
80009c10:	0ff78793          	add	a5,a5,255 # ffff80ff <__APB_SRAM_segment_end__+0xbf060ff>
80009c14:	8f7d                	and	a4,a4,a5
80009c16:	03e15783          	lhu	a5,62(sp)
80009c1a:	04078793          	add	a5,a5,64
80009c1e:	978a                	add	a5,a5,sp
80009c20:	fdc7c783          	lbu	a5,-36(a5)
80009c24:	00879693          	sll	a3,a5,0x8
80009c28:	67a1                	lui	a5,0x8
80009c2a:	f0078793          	add	a5,a5,-256 # 7f00 <__DLM_segment_used_size__+0x3f00>
80009c2e:	8ff5                	and	a5,a5,a3
80009c30:	8f5d                	or	a4,a4,a5
80009c32:	47b2                	lw	a5,12(sp)
80009c34:	d3d8                	sw	a4,36(a5)
}
80009c36:	0001                	nop
80009c38:	6121                	add	sp,sp,64
80009c3a:	8082                	ret

Disassembly of section .text.board_print_clock_freq:

80009c3e <board_print_clock_freq>:
#endif
#endif
}

void board_print_clock_freq(void)
{
80009c3e:	1141                	add	sp,sp,-16
80009c40:	c606                	sw	ra,12(sp)
    printf("==============================\n");
80009c42:	fe418513          	add	a0,gp,-28 # 80009350 <.LC1>
80009c46:	5eb020ef          	jal	8000ca30 <printf>
    printf(" %s clock summary\n", BOARD_NAME);
80009c4a:	00418593          	add	a1,gp,4 # 80009370 <.LC2>
80009c4e:	01418513          	add	a0,gp,20 # 80009380 <.LC3>
80009c52:	5df020ef          	jal	8000ca30 <printf>
    printf("==============================\n");
80009c56:	fe418513          	add	a0,gp,-28 # 80009350 <.LC1>
80009c5a:	5d7020ef          	jal	8000ca30 <printf>
    printf("cpu0:\t\t %luHz\n", clock_get_frequency(clock_cpu0));
80009c5e:	4501                	li	a0,0
80009c60:	1e3010ef          	jal	8000b642 <clock_get_frequency>
80009c64:	87aa                	mv	a5,a0
80009c66:	85be                	mv	a1,a5
80009c68:	02818513          	add	a0,gp,40 # 80009394 <.LC4>
80009c6c:	5c5020ef          	jal	8000ca30 <printf>
    printf("cpu1:\t\t %luHz\n", clock_get_frequency(clock_cpu1));
80009c70:	000807b7          	lui	a5,0x80
80009c74:	00278513          	add	a0,a5,2 # 80002 <__DLM_segment_start__+0x2>
80009c78:	1cb010ef          	jal	8000b642 <clock_get_frequency>
80009c7c:	87aa                	mv	a5,a0
80009c7e:	85be                	mv	a1,a5
80009c80:	03818513          	add	a0,gp,56 # 800093a4 <.LC5>
80009c84:	5ad020ef          	jal	8000ca30 <printf>
    printf("axi0:\t\t %luHz\n", clock_get_frequency(clock_axi0));
80009c88:	010107b7          	lui	a5,0x1010
80009c8c:	00478513          	add	a0,a5,4 # 1010004 <_extram_size+0x10004>
80009c90:	1b3010ef          	jal	8000b642 <clock_get_frequency>
80009c94:	87aa                	mv	a5,a0
80009c96:	85be                	mv	a1,a5
80009c98:	04818513          	add	a0,gp,72 # 800093b4 <.LC6>
80009c9c:	595020ef          	jal	8000ca30 <printf>
    printf("axi1:\t\t %luHz\n", clock_get_frequency(clock_axi1));
80009ca0:	010207b7          	lui	a5,0x1020
80009ca4:	00578513          	add	a0,a5,5 # 1020005 <_extram_size+0x20005>
80009ca8:	19b010ef          	jal	8000b642 <clock_get_frequency>
80009cac:	87aa                	mv	a5,a0
80009cae:	85be                	mv	a1,a5
80009cb0:	05818513          	add	a0,gp,88 # 800093c4 <.LC7>
80009cb4:	57d020ef          	jal	8000ca30 <printf>
    printf("axi2:\t\t %luHz\n", clock_get_frequency(clock_axi2));
80009cb8:	010307b7          	lui	a5,0x1030
80009cbc:	00678513          	add	a0,a5,6 # 1030006 <_extram_size+0x30006>
80009cc0:	183010ef          	jal	8000b642 <clock_get_frequency>
80009cc4:	87aa                	mv	a5,a0
80009cc6:	85be                	mv	a1,a5
80009cc8:	06818513          	add	a0,gp,104 # 800093d4 <.LC8>
80009ccc:	565020ef          	jal	8000ca30 <printf>
    printf("ahb:\t\t %luHz\n", clock_get_frequency(clock_ahb));
80009cd0:	010007b7          	lui	a5,0x1000
80009cd4:	00778513          	add	a0,a5,7 # 1000007 <_extram_size+0x7>
80009cd8:	16b010ef          	jal	8000b642 <clock_get_frequency>
80009cdc:	87aa                	mv	a5,a0
80009cde:	85be                	mv	a1,a5
80009ce0:	07818513          	add	a0,gp,120 # 800093e4 <.LC9>
80009ce4:	54d020ef          	jal	8000ca30 <printf>
    printf("mchtmr0:\t %luHz\n", clock_get_frequency(clock_mchtmr0));
80009ce8:	010807b7          	lui	a5,0x1080
80009cec:	00178513          	add	a0,a5,1 # 1080001 <__RAL_global_locale+0x1>
80009cf0:	153010ef          	jal	8000b642 <clock_get_frequency>
80009cf4:	87aa                	mv	a5,a0
80009cf6:	85be                	mv	a1,a5
80009cf8:	08818513          	add	a0,gp,136 # 800093f4 <.LC10>
80009cfc:	535020ef          	jal	8000ca30 <printf>
    printf("mchtmr1:\t %luHz\n", clock_get_frequency(clock_mchtmr1));
80009d00:	010907b7          	lui	a5,0x1090
80009d04:	00378513          	add	a0,a5,3 # 1090003 <__thread_pointer$+0xf803>
80009d08:	13b010ef          	jal	8000b642 <clock_get_frequency>
80009d0c:	87aa                	mv	a5,a0
80009d0e:	85be                	mv	a1,a5
80009d10:	09c18513          	add	a0,gp,156 # 80009408 <.LC11>
80009d14:	51d020ef          	jal	8000ca30 <printf>
    printf("xpi0:\t\t %luHz\n", clock_get_frequency(clock_xpi0));
80009d18:	010c07b7          	lui	a5,0x10c0
80009d1c:	00978513          	add	a0,a5,9 # 10c0009 <__thread_pointer$+0x3f809>
80009d20:	123010ef          	jal	8000b642 <clock_get_frequency>
80009d24:	87aa                	mv	a5,a0
80009d26:	85be                	mv	a1,a5
80009d28:	0b018513          	add	a0,gp,176 # 8000941c <.LC12>
80009d2c:	505020ef          	jal	8000ca30 <printf>
    printf("xpi1:\t\t %luHz\n", clock_get_frequency(clock_xpi1));
80009d30:	010d07b7          	lui	a5,0x10d0
80009d34:	00a78513          	add	a0,a5,10 # 10d000a <__thread_pointer$+0x4f80a>
80009d38:	10b010ef          	jal	8000b642 <clock_get_frequency>
80009d3c:	87aa                	mv	a5,a0
80009d3e:	85be                	mv	a1,a5
80009d40:	0c018513          	add	a0,gp,192 # 8000942c <.LC13>
80009d44:	4ed020ef          	jal	8000ca30 <printf>
    printf("femc:\t\t %luHz\n", clock_get_frequency(clock_femc));
80009d48:	010407b7          	lui	a5,0x1040
80009d4c:	00878513          	add	a0,a5,8 # 1040008 <_extram_size+0x40008>
80009d50:	0f3010ef          	jal	8000b642 <clock_get_frequency>
80009d54:	87aa                	mv	a5,a0
80009d56:	85be                	mv	a1,a5
80009d58:	0d018513          	add	a0,gp,208 # 8000943c <.LC14>
80009d5c:	4d5020ef          	jal	8000ca30 <printf>
    printf("==============================\n");
80009d60:	fe418513          	add	a0,gp,-28 # 80009350 <.LC1>
80009d64:	4cd020ef          	jal	8000ca30 <printf>
}
80009d68:	0001                	nop
80009d6a:	40b2                	lw	ra,12(sp)
80009d6c:	0141                	add	sp,sp,16
80009d6e:	8082                	ret

Disassembly of section .text.board_print_banner:

80009da2 <board_print_banner>:
    init_uart_pins(ptr);
    board_init_uart_clock(ptr);
}

void board_print_banner(void)
{
80009da2:	d8010113          	add	sp,sp,-640
80009da6:	26112e23          	sw	ra,636(sp)
    const uint8_t banner[] = {"\n\
80009daa:	0fc18713          	add	a4,gp,252 # 80009468 <.LC15>
80009dae:	878a                	mv	a5,sp
80009db0:	86ba                	mv	a3,a4
80009db2:	26f00713          	li	a4,623
80009db6:	863a                	mv	a2,a4
80009db8:	85b6                	mv	a1,a3
80009dba:	853e                	mv	a0,a5
80009dbc:	319020ef          	jal	8000c8d4 <memcpy>
$$ |  $$ |$$ |      $$ |\\$  /$$ |$$ |$$ |      $$ |      $$ |  $$ |\n\
$$ |  $$ |$$ |      $$ | \\_/ $$ |$$ |\\$$$$$$$\\ $$ |      \\$$$$$$  |\n\
\\__|  \\__|\\__|      \\__|     \\__|\\__| \\_______|\\__|       \\______/\n\
----------------------------------------------------------------------\n"};
#ifdef SDK_VERSION_STRING
    printf("hpm_sdk: %s\n", SDK_VERSION_STRING);
80009dc0:	0e018593          	add	a1,gp,224 # 8000944c <.LC16>
80009dc4:	0e818513          	add	a0,gp,232 # 80009454 <.LC17>
80009dc8:	469020ef          	jal	8000ca30 <printf>
#endif
    printf("%s", banner);
80009dcc:	878a                	mv	a5,sp
80009dce:	85be                	mv	a1,a5
80009dd0:	0f818513          	add	a0,gp,248 # 80009464 <.LC18>
80009dd4:	45d020ef          	jal	8000ca30 <printf>
}
80009dd8:	0001                	nop
80009dda:	27c12083          	lw	ra,636(sp)
80009dde:	28010113          	add	sp,sp,640
80009de2:	8082                	ret

Disassembly of section .text.board_init_pmp:

80009e02 <board_init_pmp>:
        clock_add_to_group(clock_usb0, 0);
    }
}

void board_init_pmp(void)
{
80009e02:	712d                	add	sp,sp,-288
80009e04:	10112e23          	sw	ra,284(sp)
    uint32_t start_addr;
    uint32_t end_addr;
    uint32_t length;
    pmp_entry_t pmp_entry[16];
    uint8_t index = 0;
80009e08:	100107a3          	sb	zero,271(sp)

    /* Init noncachable memory */
    extern uint32_t __noncacheable_start__[];
    extern uint32_t __noncacheable_end__[];
    start_addr = (uint32_t) __noncacheable_start__;
80009e0c:	40c007b7          	lui	a5,0x40c00
80009e10:	00078793          	mv	a5,a5
80009e14:	10f12423          	sw	a5,264(sp)
    end_addr = (uint32_t) __noncacheable_end__;
80009e18:	410007b7          	lui	a5,0x41000
80009e1c:	00078793          	mv	a5,a5
80009e20:	10f12223          	sw	a5,260(sp)
    length = end_addr - start_addr;
80009e24:	10412703          	lw	a4,260(sp)
80009e28:	10812783          	lw	a5,264(sp)
80009e2c:	40f707b3          	sub	a5,a4,a5
80009e30:	10f12023          	sw	a5,256(sp)
    if (length > 0) {
80009e34:	10012783          	lw	a5,256(sp)
80009e38:	cbe1                	beqz	a5,80009f08 <.L145>
        /* Ensure the address and the length are power of 2 aligned */
        assert((length & (length - 1U)) == 0U);
80009e3a:	10012783          	lw	a5,256(sp)
80009e3e:	fff78713          	add	a4,a5,-1 # 40ffffff <__NONCACHEABLE_RAM_segment_used_end__+0x3fffdf>
80009e42:	10012783          	lw	a5,256(sp)
80009e46:	8ff9                	and	a5,a5,a4
80009e48:	cb89                	beqz	a5,80009e5a <.L146>
80009e4a:	26400613          	li	a2,612
80009e4e:	40818593          	add	a1,gp,1032 # 80009774 <.LC24>
80009e52:	44818513          	add	a0,gp,1096 # 800097b4 <.LC25>
80009e56:	564050ef          	jal	8000f3ba <__SEGGER_RTL_X_assert>

80009e5a <.L146>:
        assert((start_addr & (length - 1U)) == 0U);
80009e5a:	10012783          	lw	a5,256(sp)
80009e5e:	fff78713          	add	a4,a5,-1
80009e62:	10812783          	lw	a5,264(sp)
80009e66:	8ff9                	and	a5,a5,a4
80009e68:	cb89                	beqz	a5,80009e7a <.L147>
80009e6a:	26500613          	li	a2,613
80009e6e:	40818593          	add	a1,gp,1032 # 80009774 <.LC24>
80009e72:	46818513          	add	a0,gp,1128 # 800097d4 <.LC26>
80009e76:	544050ef          	jal	8000f3ba <__SEGGER_RTL_X_assert>

80009e7a <.L147>:
        pmp_entry[index].pmp_addr = PMP_NAPOT_ADDR(start_addr, length);
80009e7a:	10812783          	lw	a5,264(sp)
80009e7e:	0027d713          	srl	a4,a5,0x2
80009e82:	10012783          	lw	a5,256(sp)
80009e86:	17fd                	add	a5,a5,-1
80009e88:	838d                	srl	a5,a5,0x3
80009e8a:	00f766b3          	or	a3,a4,a5
80009e8e:	10012783          	lw	a5,256(sp)
80009e92:	838d                	srl	a5,a5,0x3
80009e94:	fff7c713          	not	a4,a5
80009e98:	10f14783          	lbu	a5,271(sp)
80009e9c:	8f75                	and	a4,a4,a3
80009e9e:	0792                	sll	a5,a5,0x4
80009ea0:	11078793          	add	a5,a5,272
80009ea4:	978a                	add	a5,a5,sp
80009ea6:	eee7aa23          	sw	a4,-268(a5)
        pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
80009eaa:	10f14783          	lbu	a5,271(sp)
80009eae:	0792                	sll	a5,a5,0x4
80009eb0:	11078793          	add	a5,a5,272
80009eb4:	978a                	add	a5,a5,sp
80009eb6:	477d                	li	a4,31
80009eb8:	eee78823          	sb	a4,-272(a5)
        pmp_entry[index].pma_addr = PMA_NAPOT_ADDR(start_addr, length);
80009ebc:	10812783          	lw	a5,264(sp)
80009ec0:	0027d713          	srl	a4,a5,0x2
80009ec4:	10012783          	lw	a5,256(sp)
80009ec8:	17fd                	add	a5,a5,-1
80009eca:	838d                	srl	a5,a5,0x3
80009ecc:	00f766b3          	or	a3,a4,a5
80009ed0:	10012783          	lw	a5,256(sp)
80009ed4:	838d                	srl	a5,a5,0x3
80009ed6:	fff7c713          	not	a4,a5
80009eda:	10f14783          	lbu	a5,271(sp)
80009ede:	8f75                	and	a4,a4,a3
80009ee0:	0792                	sll	a5,a5,0x4
80009ee2:	11078793          	add	a5,a5,272
80009ee6:	978a                	add	a5,a5,sp
80009ee8:	eee7ae23          	sw	a4,-260(a5)
        pmp_entry[index].pma_cfg.val = PMA_CFG(ADDR_MATCH_NAPOT, MEM_TYPE_MEM_NON_CACHE_BUF, AMO_EN);
80009eec:	10f14783          	lbu	a5,271(sp)
80009ef0:	0792                	sll	a5,a5,0x4
80009ef2:	11078793          	add	a5,a5,272
80009ef6:	978a                	add	a5,a5,sp
80009ef8:	473d                	li	a4,15
80009efa:	eee78c23          	sb	a4,-264(a5)
        index++;
80009efe:	10f14783          	lbu	a5,271(sp)
80009f02:	0785                	add	a5,a5,1
80009f04:	10f107a3          	sb	a5,271(sp)

80009f08 <.L145>:
    }

    /* Init share memory */
    extern uint32_t __share_mem_start__[];
    extern uint32_t __share_mem_end__[];
    start_addr = (uint32_t)__share_mem_start__;
80009f08:	0117c7b7          	lui	a5,0x117c
80009f0c:	00078793          	mv	a5,a5
80009f10:	10f12423          	sw	a5,264(sp)
    end_addr = (uint32_t)__share_mem_end__;
80009f14:	011807b7          	lui	a5,0x1180
80009f18:	00078793          	mv	a5,a5
80009f1c:	10f12223          	sw	a5,260(sp)
    length = end_addr - start_addr;
80009f20:	10412703          	lw	a4,260(sp)
80009f24:	10812783          	lw	a5,264(sp)
80009f28:	40f707b3          	sub	a5,a4,a5
80009f2c:	10f12023          	sw	a5,256(sp)
    if (length > 0) {
80009f30:	10012783          	lw	a5,256(sp)
80009f34:	cbe1                	beqz	a5,8000a004 <.L148>
        /* Ensure the address and the length are power of 2 aligned */
        assert((length & (length - 1U)) == 0U);
80009f36:	10012783          	lw	a5,256(sp)
80009f3a:	fff78713          	add	a4,a5,-1 # 117ffff <__SHARE_RAM_segment_used_end__+0xff>
80009f3e:	10012783          	lw	a5,256(sp)
80009f42:	8ff9                	and	a5,a5,a4
80009f44:	cb89                	beqz	a5,80009f56 <.L149>
80009f46:	27500613          	li	a2,629
80009f4a:	40818593          	add	a1,gp,1032 # 80009774 <.LC24>
80009f4e:	44818513          	add	a0,gp,1096 # 800097b4 <.LC25>
80009f52:	468050ef          	jal	8000f3ba <__SEGGER_RTL_X_assert>

80009f56 <.L149>:
        assert((start_addr & (length - 1U)) == 0U);
80009f56:	10012783          	lw	a5,256(sp)
80009f5a:	fff78713          	add	a4,a5,-1
80009f5e:	10812783          	lw	a5,264(sp)
80009f62:	8ff9                	and	a5,a5,a4
80009f64:	cb89                	beqz	a5,80009f76 <.L150>
80009f66:	27600613          	li	a2,630
80009f6a:	40818593          	add	a1,gp,1032 # 80009774 <.LC24>
80009f6e:	46818513          	add	a0,gp,1128 # 800097d4 <.LC26>
80009f72:	448050ef          	jal	8000f3ba <__SEGGER_RTL_X_assert>

80009f76 <.L150>:
        pmp_entry[index].pmp_addr = PMP_NAPOT_ADDR(start_addr, length);
80009f76:	10812783          	lw	a5,264(sp)
80009f7a:	0027d713          	srl	a4,a5,0x2
80009f7e:	10012783          	lw	a5,256(sp)
80009f82:	17fd                	add	a5,a5,-1
80009f84:	838d                	srl	a5,a5,0x3
80009f86:	00f766b3          	or	a3,a4,a5
80009f8a:	10012783          	lw	a5,256(sp)
80009f8e:	838d                	srl	a5,a5,0x3
80009f90:	fff7c713          	not	a4,a5
80009f94:	10f14783          	lbu	a5,271(sp)
80009f98:	8f75                	and	a4,a4,a3
80009f9a:	0792                	sll	a5,a5,0x4
80009f9c:	11078793          	add	a5,a5,272
80009fa0:	978a                	add	a5,a5,sp
80009fa2:	eee7aa23          	sw	a4,-268(a5)
        pmp_entry[index].pmp_cfg.val = PMP_CFG(READ_EN, WRITE_EN, EXECUTE_EN, ADDR_MATCH_NAPOT, REG_UNLOCK);
80009fa6:	10f14783          	lbu	a5,271(sp)
80009faa:	0792                	sll	a5,a5,0x4
80009fac:	11078793          	add	a5,a5,272
80009fb0:	978a                	add	a5,a5,sp
80009fb2:	477d                	li	a4,31
80009fb4:	eee78823          	sb	a4,-272(a5)
        pmp_entry[index].pma_addr = PMA_NAPOT_ADDR(start_addr, length);
80009fb8:	10812783          	lw	a5,264(sp)
80009fbc:	0027d713          	srl	a4,a5,0x2
80009fc0:	10012783          	lw	a5,256(sp)
80009fc4:	17fd                	add	a5,a5,-1
80009fc6:	838d                	srl	a5,a5,0x3
80009fc8:	00f766b3          	or	a3,a4,a5
80009fcc:	10012783          	lw	a5,256(sp)
80009fd0:	838d                	srl	a5,a5,0x3
80009fd2:	fff7c713          	not	a4,a5
80009fd6:	10f14783          	lbu	a5,271(sp)
80009fda:	8f75                	and	a4,a4,a3
80009fdc:	0792                	sll	a5,a5,0x4
80009fde:	11078793          	add	a5,a5,272
80009fe2:	978a                	add	a5,a5,sp
80009fe4:	eee7ae23          	sw	a4,-260(a5)
        pmp_entry[index].pma_cfg.val = PMA_CFG(ADDR_MATCH_NAPOT, MEM_TYPE_MEM_NON_CACHE_BUF, AMO_EN);
80009fe8:	10f14783          	lbu	a5,271(sp)
80009fec:	0792                	sll	a5,a5,0x4
80009fee:	11078793          	add	a5,a5,272
80009ff2:	978a                	add	a5,a5,sp
80009ff4:	473d                	li	a4,15
80009ff6:	eee78c23          	sb	a4,-264(a5)
        index++;
80009ffa:	10f14783          	lbu	a5,271(sp)
80009ffe:	0785                	add	a5,a5,1
8000a000:	10f107a3          	sb	a5,271(sp)

8000a004 <.L148>:
    }

    pmp_config(&pmp_entry[0], index);
8000a004:	10f14703          	lbu	a4,271(sp)
8000a008:	878a                	mv	a5,sp
8000a00a:	85ba                	mv	a1,a4
8000a00c:	853e                	mv	a0,a5
8000a00e:	138010ef          	jal	8000b146 <pmp_config>
}
8000a012:	0001                	nop
8000a014:	11c12083          	lw	ra,284(sp)
8000a018:	6115                	add	sp,sp,288
8000a01a:	8082                	ret

Disassembly of section .text.board_init_clock:

8000a02a <board_init_clock>:

void board_init_clock(void)
{
8000a02a:	1101                	add	sp,sp,-32
8000a02c:	ce06                	sw	ra,28(sp)
    uint32_t cpu0_freq = clock_get_frequency(clock_cpu0);
8000a02e:	4501                	li	a0,0
8000a030:	612010ef          	jal	8000b642 <clock_get_frequency>
8000a034:	c62a                	sw	a0,12(sp)
    if (cpu0_freq == PLLCTL_SOC_PLL_REFCLK_FREQ) {
8000a036:	4732                	lw	a4,12(sp)
8000a038:	016e37b7          	lui	a5,0x16e3
8000a03c:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000a040:	00f71e63          	bne	a4,a5,8000a05c <.L152>
        /* Configure the External OSC ramp-up time: ~9ms */
        pllctl_xtal_set_rampup_time(HPM_PLLCTL, 32UL * 1000UL * 9U);
8000a044:	000467b7          	lui	a5,0x46
8000a048:	50078593          	add	a1,a5,1280 # 46500 <__DLM_segment_size__+0x6500>
8000a04c:	f4100537          	lui	a0,0xf4100
8000a050:	3249                	jal	800099d2 <pllctl_xtal_set_rampup_time>

        /* Select clock setting preset1 */
        sysctl_clock_set_preset(HPM_SYSCTL, sysctl_preset_1);
8000a052:	4589                	li	a1,2
8000a054:	f4000537          	lui	a0,0xf4000
8000a058:	281020ef          	jal	8000cad8 <sysctl_clock_set_preset>

8000a05c <.L152>:
    }

    /* Add clocks to group 0 */
    clock_add_to_group(clock_cpu0, 0);
8000a05c:	4581                	li	a1,0
8000a05e:	4501                	li	a0,0
8000a060:	7f0010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_mchtmr0, 0);
8000a064:	4581                	li	a1,0
8000a066:	010807b7          	lui	a5,0x1080
8000a06a:	00178513          	add	a0,a5,1 # 1080001 <__RAL_global_locale+0x1>
8000a06e:	7e2010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_axi0, 0);
8000a072:	4581                	li	a1,0
8000a074:	010107b7          	lui	a5,0x1010
8000a078:	00478513          	add	a0,a5,4 # 1010004 <_extram_size+0x10004>
8000a07c:	7d4010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_axi1, 0);
8000a080:	4581                	li	a1,0
8000a082:	010207b7          	lui	a5,0x1020
8000a086:	00578513          	add	a0,a5,5 # 1020005 <_extram_size+0x20005>
8000a08a:	7c6010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_axi2, 0);
8000a08e:	4581                	li	a1,0
8000a090:	010307b7          	lui	a5,0x1030
8000a094:	00678513          	add	a0,a5,6 # 1030006 <_extram_size+0x30006>
8000a098:	7b8010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_ahb, 0);
8000a09c:	4581                	li	a1,0
8000a09e:	010007b7          	lui	a5,0x1000
8000a0a2:	00778513          	add	a0,a5,7 # 1000007 <_extram_size+0x7>
8000a0a6:	7aa010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_xdma, 0);
8000a0aa:	4581                	li	a1,0
8000a0ac:	011207b7          	lui	a5,0x1120
8000a0b0:	60178513          	add	a0,a5,1537 # 1120601 <__thread_pointer$+0x9fe01>
8000a0b4:	79c010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_hdma, 0);
8000a0b8:	4581                	li	a1,0
8000a0ba:	011107b7          	lui	a5,0x1110
8000a0be:	50478513          	add	a0,a5,1284 # 1110504 <__thread_pointer$+0x8fd04>
8000a0c2:	78e010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_xpi0, 0);
8000a0c6:	4581                	li	a1,0
8000a0c8:	010c07b7          	lui	a5,0x10c0
8000a0cc:	00978513          	add	a0,a5,9 # 10c0009 <__thread_pointer$+0x3f809>
8000a0d0:	780010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_xpi1, 0);
8000a0d4:	4581                	li	a1,0
8000a0d6:	010d07b7          	lui	a5,0x10d0
8000a0da:	00a78513          	add	a0,a5,10 # 10d000a <__thread_pointer$+0x4f80a>
8000a0de:	772010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_ram0, 0);
8000a0e2:	4581                	li	a1,0
8000a0e4:	010a07b7          	lui	a5,0x10a0
8000a0e8:	60378513          	add	a0,a5,1539 # 10a0603 <__thread_pointer$+0x1fe03>
8000a0ec:	764010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_ram1, 0);
8000a0f0:	4581                	li	a1,0
8000a0f2:	010b07b7          	lui	a5,0x10b0
8000a0f6:	60478513          	add	a0,a5,1540 # 10b0604 <__thread_pointer$+0x2fe04>
8000a0fa:	756010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_lmm0, 0);
8000a0fe:	4581                	li	a1,0
8000a100:	010617b7          	lui	a5,0x1061
8000a104:	90078513          	add	a0,a5,-1792 # 1060900 <_extram_size+0x60900>
8000a108:	748010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_lmm1, 0);
8000a10c:	4581                	li	a1,0
8000a10e:	010717b7          	lui	a5,0x1071
8000a112:	a0078513          	add	a0,a5,-1536 # 1070a00 <_extram_size+0x70a00>
8000a116:	73a010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_gpio, 0);
8000a11a:	4581                	li	a1,0
8000a11c:	011307b7          	lui	a5,0x1130
8000a120:	50178513          	add	a0,a5,1281 # 1130501 <__thread_pointer$+0xafd01>
8000a124:	72c010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_mot0, 0);
8000a128:	4581                	li	a1,0
8000a12a:	014b07b7          	lui	a5,0x14b0
8000a12e:	50678513          	add	a0,a5,1286 # 14b0506 <__SHARE_RAM_segment_end__+0x330506>
8000a132:	71e010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_mot1, 0);
8000a136:	4581                	li	a1,0
8000a138:	014c07b7          	lui	a5,0x14c0
8000a13c:	50778513          	add	a0,a5,1287 # 14c0507 <__SHARE_RAM_segment_end__+0x340507>
8000a140:	710010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_mot2, 0);
8000a144:	4581                	li	a1,0
8000a146:	014d07b7          	lui	a5,0x14d0
8000a14a:	50878513          	add	a0,a5,1288 # 14d0508 <__SHARE_RAM_segment_end__+0x350508>
8000a14e:	702010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_mot3, 0);
8000a152:	4581                	li	a1,0
8000a154:	014e07b7          	lui	a5,0x14e0
8000a158:	50978513          	add	a0,a5,1289 # 14e0509 <__SHARE_RAM_segment_end__+0x360509>
8000a15c:	6f4010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_synt, 0);
8000a160:	4581                	li	a1,0
8000a162:	014a07b7          	lui	a5,0x14a0
8000a166:	50c78513          	add	a0,a5,1292 # 14a050c <__SHARE_RAM_segment_end__+0x32050c>
8000a16a:	6e6010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_ptpc, 0);
8000a16e:	4581                	li	a1,0
8000a170:	013e07b7          	lui	a5,0x13e0
8000a174:	02f78513          	add	a0,a5,47 # 13e002f <__SHARE_RAM_segment_end__+0x26002f>
8000a178:	6d8010ef          	jal	8000b850 <clock_add_to_group>
    /* Connect Group0 to CPU0 */
    clock_connect_group_to_cpu(0, 0);
8000a17c:	4581                	li	a1,0
8000a17e:	4501                	li	a0,0
8000a180:	7ed040ef          	jal	8000f16c <clock_connect_group_to_cpu>

    /* Add clocks to Group1 */
    clock_add_to_group(clock_cpu1, 1);
8000a184:	4585                	li	a1,1
8000a186:	000807b7          	lui	a5,0x80
8000a18a:	00278513          	add	a0,a5,2 # 80002 <__DLM_segment_start__+0x2>
8000a18e:	6c2010ef          	jal	8000b850 <clock_add_to_group>
    clock_add_to_group(clock_mchtmr1, 1);
8000a192:	4585                	li	a1,1
8000a194:	010907b7          	lui	a5,0x1090
8000a198:	00378513          	add	a0,a5,3 # 1090003 <__thread_pointer$+0xf803>
8000a19c:	6b4010ef          	jal	8000b850 <clock_add_to_group>
    /* Connect Group1 to CPU1 */
    clock_connect_group_to_cpu(1, 1);
8000a1a0:	4585                	li	a1,1
8000a1a2:	4505                	li	a0,1
8000a1a4:	7c9040ef          	jal	8000f16c <clock_connect_group_to_cpu>

    /* Bump up DCDC voltage to 1275mv */
    pcfg_dcdc_set_voltage(HPM_PCFG, 1275);
8000a1a8:	4fb00593          	li	a1,1275
8000a1ac:	f40c4537          	lui	a0,0xf40c4
8000a1b0:	597030ef          	jal	8000df46 <pcfg_dcdc_set_voltage>
    pcfg_dcdc_switch_to_dcm_mode(HPM_PCFG);
8000a1b4:	f40c4537          	lui	a0,0xf40c4
8000a1b8:	3a5d                	jal	80009b6e <pcfg_dcdc_switch_to_dcm_mode>

    if (status_success != pllctl_init_int_pll_with_freq(HPM_PLLCTL, 0, BOARD_CPU_FREQ)) {
8000a1ba:	30a337b7          	lui	a5,0x30a33
8000a1be:	c0078613          	add	a2,a5,-1024 # 30a32c00 <__SHARE_RAM_segment_end__+0x2f8b2c00>
8000a1c2:	4581                	li	a1,0
8000a1c4:	f4100537          	lui	a0,0xf4100
8000a1c8:	667030ef          	jal	8000e02e <pllctl_init_int_pll_with_freq>
8000a1cc:	87aa                	mv	a5,a0
8000a1ce:	cb91                	beqz	a5,8000a1e2 <.L153>
        printf("Failed to set pll0_clk0 to %ldHz\n", BOARD_CPU_FREQ);
8000a1d0:	30a337b7          	lui	a5,0x30a33
8000a1d4:	c0078593          	add	a1,a5,-1024 # 30a32c00 <__SHARE_RAM_segment_end__+0x2f8b2c00>
8000a1d8:	48c18513          	add	a0,gp,1164 # 800097f8 <.LC27>
8000a1dc:	055020ef          	jal	8000ca30 <printf>

8000a1e0 <.L154>:
        while (1) {
8000a1e0:	a001                	j	8000a1e0 <.L154>

8000a1e2 <.L153>:
        }
    }

    clock_set_source_divider(clock_cpu0, clk_src_pll0_clk0, 1);
8000a1e2:	4605                	li	a2,1
8000a1e4:	4585                	li	a1,1
8000a1e6:	4501                	li	a0,0
8000a1e8:	590010ef          	jal	8000b778 <clock_set_source_divider>
    clock_set_source_divider(clock_cpu1, clk_src_pll0_clk0, 1);
8000a1ec:	4605                	li	a2,1
8000a1ee:	4585                	li	a1,1
8000a1f0:	000807b7          	lui	a5,0x80
8000a1f4:	00278513          	add	a0,a5,2 # 80002 <__DLM_segment_start__+0x2>
8000a1f8:	580010ef          	jal	8000b778 <clock_set_source_divider>
    clock_update_core_clock();
8000a1fc:	68e010ef          	jal	8000b88a <clock_update_core_clock>

    clock_set_source_divider(clock_ahb, clk_src_pll1_clk1, 2); /*200m hz*/
8000a200:	4609                	li	a2,2
8000a202:	458d                	li	a1,3
8000a204:	010007b7          	lui	a5,0x1000
8000a208:	00778513          	add	a0,a5,7 # 1000007 <_extram_size+0x7>
8000a20c:	56c010ef          	jal	8000b778 <clock_set_source_divider>
    clock_set_source_divider(clock_mchtmr0, clk_src_osc24m, 1);
8000a210:	4605                	li	a2,1
8000a212:	4581                	li	a1,0
8000a214:	010807b7          	lui	a5,0x1080
8000a218:	00178513          	add	a0,a5,1 # 1080001 <__RAL_global_locale+0x1>
8000a21c:	55c010ef          	jal	8000b778 <clock_set_source_divider>
    clock_set_source_divider(clock_mchtmr1, clk_src_osc24m, 1);
8000a220:	4605                	li	a2,1
8000a222:	4581                	li	a1,0
8000a224:	010907b7          	lui	a5,0x1090
8000a228:	00378513          	add	a0,a5,3 # 1090003 <__thread_pointer$+0xf803>
8000a22c:	54c010ef          	jal	8000b778 <clock_set_source_divider>
}
8000a230:	0001                	nop
8000a232:	40f2                	lw	ra,28(sp)
8000a234:	6105                	add	sp,sp,32
8000a236:	8082                	ret

Disassembly of section .text.can_set_node_mode:

8000a242 <can_set_node_mode>:
 *  @arg can_mode_loopback_internal internal loopback mode
 *  @arg can_mode_loopback_external external loopback mode
 *  @arg can_mode_listen_only CAN listen-only mode
 */
static inline void can_set_node_mode(CAN_Type *base, can_node_mode_t mode)
{
8000a242:	1101                	add	sp,sp,-32
8000a244:	c62a                	sw	a0,12(sp)
8000a246:	87ae                	mv	a5,a1
8000a248:	00f105a3          	sb	a5,11(sp)
    uint32_t cfg_stat = base->CMD_STA_CMD_CTRL & ~(CAN_CMD_STA_CMD_CTRL_LBME_MASK | CAN_CMD_STA_CMD_CTRL_LBMI_MASK | CAN_CMD_STA_CMD_CTRL_LOM_MASK);
8000a24c:	47b2                	lw	a5,12(sp)
8000a24e:	0a07a703          	lw	a4,160(a5)
8000a252:	77f1                	lui	a5,0xffffc
8000a254:	f9f78793          	add	a5,a5,-97 # ffffbf9f <__APB_SRAM_segment_end__+0xbf09f9f>
8000a258:	8ff9                	and	a5,a5,a4
8000a25a:	ce3e                	sw	a5,28(sp)
    if (mode == can_mode_loopback_internal) {
8000a25c:	00b14703          	lbu	a4,11(sp)
8000a260:	4785                	li	a5,1
8000a262:	00f71763          	bne	a4,a5,8000a270 <.L7>
        cfg_stat |= CAN_CMD_STA_CMD_CTRL_LBMI_MASK;
8000a266:	47f2                	lw	a5,28(sp)
8000a268:	0207e793          	or	a5,a5,32
8000a26c:	ce3e                	sw	a5,28(sp)
8000a26e:	a025                	j	8000a296 <.L8>

8000a270 <.L7>:
    } else if (mode == can_mode_loopback_external) {
8000a270:	00b14703          	lbu	a4,11(sp)
8000a274:	4789                	li	a5,2
8000a276:	00f71763          	bne	a4,a5,8000a284 <.L9>
        cfg_stat |= CAN_CMD_STA_CMD_CTRL_LBME_MASK;
8000a27a:	47f2                	lw	a5,28(sp)
8000a27c:	0407e793          	or	a5,a5,64
8000a280:	ce3e                	sw	a5,28(sp)
8000a282:	a811                	j	8000a296 <.L8>

8000a284 <.L9>:
    } else if (mode == can_mode_listen_only) {
8000a284:	00b14703          	lbu	a4,11(sp)
8000a288:	478d                	li	a5,3
8000a28a:	00f71663          	bne	a4,a5,8000a296 <.L8>
        cfg_stat |= CAN_CMD_STA_CMD_CTRL_LOM_MASK;
8000a28e:	4772                	lw	a4,28(sp)
8000a290:	6791                	lui	a5,0x4
8000a292:	8fd9                	or	a5,a5,a4
8000a294:	ce3e                	sw	a5,28(sp)

8000a296 <.L8>:
    } else {
        /* CAN normal work mode, no change needed here */
    }
    base->CMD_STA_CMD_CTRL = cfg_stat;
8000a296:	47b2                	lw	a5,12(sp)
8000a298:	4772                	lw	a4,28(sp)
8000a29a:	0ae7a023          	sw	a4,160(a5) # 40a0 <__DLM_segment_used_size__+0xa0>
}
8000a29e:	0001                	nop
8000a2a0:	6105                	add	sp,sp,32
8000a2a2:	8082                	ret

Disassembly of section .text.can_select_tx_buffer_priority_mode:

8000a2ae <can_select_tx_buffer_priority_mode>:
 * @param [in] enable_priority_decision CAN tx buffer priority mode selection flag
 *  @arg true priority decision mode
 *  @arg false FIFO mode
 */
static inline void can_select_tx_buffer_priority_mode(CAN_Type *base, bool enable_priority_decision)
{
8000a2ae:	1141                	add	sp,sp,-16
8000a2b0:	c62a                	sw	a0,12(sp)
8000a2b2:	87ae                	mv	a5,a1
8000a2b4:	00f105a3          	sb	a5,11(sp)
    if (enable_priority_decision) {
8000a2b8:	00b14783          	lbu	a5,11(sp)
8000a2bc:	cb99                	beqz	a5,8000a2d2 <.L19>
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_TSMODE_MASK;
8000a2be:	47b2                	lw	a5,12(sp)
8000a2c0:	0a07a703          	lw	a4,160(a5)
8000a2c4:	002007b7          	lui	a5,0x200
8000a2c8:	8f5d                	or	a4,a4,a5
8000a2ca:	47b2                	lw	a5,12(sp)
8000a2cc:	0ae7a023          	sw	a4,160(a5) # 2000a0 <__AXI_SRAM_segment_size__+0x1400a0>
    } else {
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_TSMODE_MASK;
    }
}
8000a2d0:	a819                	j	8000a2e6 <.L21>

8000a2d2 <.L19>:
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_TSMODE_MASK;
8000a2d2:	47b2                	lw	a5,12(sp)
8000a2d4:	0a07a703          	lw	a4,160(a5)
8000a2d8:	ffe007b7          	lui	a5,0xffe00
8000a2dc:	17fd                	add	a5,a5,-1 # ffdfffff <__APB_SRAM_segment_end__+0xbd0dfff>
8000a2de:	8f7d                	and	a4,a4,a5
8000a2e0:	47b2                	lw	a5,12(sp)
8000a2e2:	0ae7a023          	sw	a4,160(a5)

8000a2e6 <.L21>:
}
8000a2e6:	0001                	nop
8000a2e8:	0141                	add	sp,sp,16
8000a2ea:	8082                	ret

Disassembly of section .text.can_enable_self_ack:

8000a404 <can_enable_self_ack>:
 * @param [in] base CAN base address
 * @param [in] enable Self-ack enable flag, true or false
 *
 */
static inline void can_enable_self_ack(CAN_Type *base, bool enable)
{
8000a404:	1141                	add	sp,sp,-16
8000a406:	c62a                	sw	a0,12(sp)
8000a408:	87ae                	mv	a5,a1
8000a40a:	00f105a3          	sb	a5,11(sp)
    if (enable) {
8000a40e:	00b14783          	lbu	a5,11(sp)
8000a412:	cb99                	beqz	a5,8000a428 <.L23>
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_SACK_MASK;
8000a414:	47b2                	lw	a5,12(sp)
8000a416:	0a07a703          	lw	a4,160(a5)
8000a41a:	800007b7          	lui	a5,0x80000
8000a41e:	8f5d                	or	a4,a4,a5
8000a420:	47b2                	lw	a5,12(sp)
8000a422:	0ae7a023          	sw	a4,160(a5) # 800000a0 <__NONCACHEABLE_RAM_segment_end__+0x3f0000a0>
    } else {
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_SACK_MASK;
    }
}
8000a426:	a819                	j	8000a43c <.L25>

8000a428 <.L23>:
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_SACK_MASK;
8000a428:	47b2                	lw	a5,12(sp)
8000a42a:	0a07a703          	lw	a4,160(a5)
8000a42e:	800007b7          	lui	a5,0x80000
8000a432:	17fd                	add	a5,a5,-1 # 7fffffff <__NONCACHEABLE_RAM_segment_end__+0x3effffff>
8000a434:	8f7d                	and	a4,a4,a5
8000a436:	47b2                	lw	a5,12(sp)
8000a438:	0ae7a023          	sw	a4,160(a5)

8000a43c <.L25>:
}
8000a43c:	0001                	nop
8000a43e:	0141                	add	sp,sp,16
8000a440:	8082                	ret

Disassembly of section .text.can_enable_can_fd_iso_mode:

8000a442 <can_enable_can_fd_iso_mode>:
 * @brief Enable CAN FD ISO mode
 * @param [in] base CAN base address
 * @param enable CAN-FD ISO mode enable flag
 */
static inline void can_enable_can_fd_iso_mode(CAN_Type *base, bool enable)
{
8000a442:	1141                	add	sp,sp,-16
8000a444:	c62a                	sw	a0,12(sp)
8000a446:	87ae                	mv	a5,a1
8000a448:	00f105a3          	sb	a5,11(sp)
    if (enable) {
8000a44c:	00b14783          	lbu	a5,11(sp)
8000a450:	cb99                	beqz	a5,8000a466 <.L27>
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_FD_ISO_MASK;
8000a452:	47b2                	lw	a5,12(sp)
8000a454:	0a07a703          	lw	a4,160(a5)
8000a458:	008007b7          	lui	a5,0x800
8000a45c:	8f5d                	or	a4,a4,a5
8000a45e:	47b2                	lw	a5,12(sp)
8000a460:	0ae7a023          	sw	a4,160(a5) # 8000a0 <_flash_size+0xa0>
    } else {
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_FD_ISO_MASK;
    }
}
8000a464:	a819                	j	8000a47a <.L29>

8000a466 <.L27>:
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_FD_ISO_MASK;
8000a466:	47b2                	lw	a5,12(sp)
8000a468:	0a07a703          	lw	a4,160(a5)
8000a46c:	ff8007b7          	lui	a5,0xff800
8000a470:	17fd                	add	a5,a5,-1 # ff7fffff <__APB_SRAM_segment_end__+0xb70dfff>
8000a472:	8f7d                	and	a4,a4,a5
8000a474:	47b2                	lw	a5,12(sp)
8000a476:	0ae7a023          	sw	a4,160(a5)

8000a47a <.L29>:
}
8000a47a:	0001                	nop
8000a47c:	0141                	add	sp,sp,16
8000a47e:	8082                	ret

Disassembly of section .text.can_enable_tx_rx_irq:

8000a480 <can_enable_tx_rx_irq>:
 * @brief Enable CAN TX/RX interrupt
 * @param [in] base CAN base address
 * @param [in] mask CAN interrupt mask
 */
static inline void can_enable_tx_rx_irq(CAN_Type *base, uint8_t mask)
{
8000a480:	1141                	add	sp,sp,-16
8000a482:	c62a                	sw	a0,12(sp)
8000a484:	87ae                	mv	a5,a1
8000a486:	00f105a3          	sb	a5,11(sp)
    base->RTIE |= mask;
8000a48a:	47b2                	lw	a5,12(sp)
8000a48c:	0a47c783          	lbu	a5,164(a5)
8000a490:	0ff7f793          	zext.b	a5,a5
8000a494:	00b14703          	lbu	a4,11(sp)
8000a498:	8fd9                	or	a5,a5,a4
8000a49a:	0ff7f713          	zext.b	a4,a5
8000a49e:	47b2                	lw	a5,12(sp)
8000a4a0:	0ae78223          	sb	a4,164(a5)
}
8000a4a4:	0001                	nop
8000a4a6:	0141                	add	sp,sp,16
8000a4a8:	8082                	ret

Disassembly of section .text.can_enable_error_irq:

8000a4aa <can_enable_error_irq>:
 * @brief Enable CAN error interrupt
 * @param [in] base CAN base address
 * @param [in] mask CAN error interrupt mask
 */
static inline void can_enable_error_irq(CAN_Type *base, uint8_t mask)
{
8000a4aa:	1141                	add	sp,sp,-16
8000a4ac:	c62a                	sw	a0,12(sp)
8000a4ae:	87ae                	mv	a5,a1
8000a4b0:	00f105a3          	sb	a5,11(sp)
    base->ERRINT |= mask;
8000a4b4:	47b2                	lw	a5,12(sp)
8000a4b6:	0a67c783          	lbu	a5,166(a5)
8000a4ba:	0ff7f793          	zext.b	a5,a5
8000a4be:	00b14703          	lbu	a4,11(sp)
8000a4c2:	8fd9                	or	a5,a5,a4
8000a4c4:	0ff7f713          	zext.b	a4,a5
8000a4c8:	47b2                	lw	a5,12(sp)
8000a4ca:	0ae78323          	sb	a4,166(a5)
}
8000a4ce:	0001                	nop
8000a4d0:	0141                	add	sp,sp,16
8000a4d2:	8082                	ret

Disassembly of section .text.can_disable_filter:

8000a4d4 <can_disable_filter>:
 *
 * @param [in] base CAN base address
 * @param index  CAN filter index
 */
static inline void can_disable_filter(CAN_Type *base, uint32_t index)
{
8000a4d4:	1141                	add	sp,sp,-16
8000a4d6:	c62a                	sw	a0,12(sp)
8000a4d8:	c42e                	sw	a1,8(sp)
    base->ACF_EN &= (uint16_t) ~(1U << index);
8000a4da:	47b2                	lw	a5,12(sp)
8000a4dc:	0b67d783          	lhu	a5,182(a5)
8000a4e0:	01079713          	sll	a4,a5,0x10
8000a4e4:	8341                	srl	a4,a4,0x10
8000a4e6:	47a2                	lw	a5,8(sp)
8000a4e8:	4685                	li	a3,1
8000a4ea:	00f697b3          	sll	a5,a3,a5
8000a4ee:	07c2                	sll	a5,a5,0x10
8000a4f0:	83c1                	srl	a5,a5,0x10
8000a4f2:	fff7c793          	not	a5,a5
8000a4f6:	07c2                	sll	a5,a5,0x10
8000a4f8:	83c1                	srl	a5,a5,0x10
8000a4fa:	8ff9                	and	a5,a5,a4
8000a4fc:	01079713          	sll	a4,a5,0x10
8000a500:	8341                	srl	a4,a4,0x10
8000a502:	47b2                	lw	a5,12(sp)
8000a504:	0ae79b23          	sh	a4,182(a5)
}
8000a508:	0001                	nop
8000a50a:	0141                	add	sp,sp,16
8000a50c:	8082                	ret

Disassembly of section .text.can_set_slow_speed_timing:

8000a50e <can_set_slow_speed_timing>:
 * @brief Configure the Slow Speed Bit timing using low-level interface
 * @param [in] base CAN base address
 * @param [in] param CAN bit timing parameter
 */
static inline void can_set_slow_speed_timing(CAN_Type *base, const can_bit_timing_param_t *param)
{
8000a50e:	1141                	add	sp,sp,-16
8000a510:	c62a                	sw	a0,12(sp)
8000a512:	c42e                	sw	a1,8(sp)
    base->S_PRESC = CAN_S_PRESC_S_PRESC_SET(param->prescaler - 1U) | CAN_S_PRESC_S_SEG_1_SET(param->num_seg1 - 2U) |
8000a514:	47a2                	lw	a5,8(sp)
8000a516:	0007d783          	lhu	a5,0(a5)
8000a51a:	17fd                	add	a5,a5,-1
8000a51c:	01879713          	sll	a4,a5,0x18
8000a520:	47a2                	lw	a5,8(sp)
8000a522:	0027d783          	lhu	a5,2(a5)
8000a526:	17f9                	add	a5,a5,-2
8000a528:	0ff7f793          	zext.b	a5,a5
8000a52c:	8f5d                	or	a4,a4,a5
                                CAN_S_PRESC_S_SEG_2_SET(param->num_seg2 - 1U) | CAN_S_PRESC_S_SJW_SET(param->num_sjw - 1U);
8000a52e:	47a2                	lw	a5,8(sp)
8000a530:	0047d783          	lhu	a5,4(a5)
8000a534:	17fd                	add	a5,a5,-1
8000a536:	00879693          	sll	a3,a5,0x8
8000a53a:	67a1                	lui	a5,0x8
8000a53c:	f0078793          	add	a5,a5,-256 # 7f00 <__DLM_segment_used_size__+0x3f00>
8000a540:	8ff5                	and	a5,a5,a3
    base->S_PRESC = CAN_S_PRESC_S_PRESC_SET(param->prescaler - 1U) | CAN_S_PRESC_S_SEG_1_SET(param->num_seg1 - 2U) |
8000a542:	8f5d                	or	a4,a4,a5
                                CAN_S_PRESC_S_SEG_2_SET(param->num_seg2 - 1U) | CAN_S_PRESC_S_SJW_SET(param->num_sjw - 1U);
8000a544:	47a2                	lw	a5,8(sp)
8000a546:	0067d783          	lhu	a5,6(a5)
8000a54a:	17fd                	add	a5,a5,-1
8000a54c:	01079693          	sll	a3,a5,0x10
8000a550:	007f07b7          	lui	a5,0x7f0
8000a554:	8ff5                	and	a5,a5,a3
8000a556:	8f5d                	or	a4,a4,a5
    base->S_PRESC = CAN_S_PRESC_S_PRESC_SET(param->prescaler - 1U) | CAN_S_PRESC_S_SEG_1_SET(param->num_seg1 - 2U) |
8000a558:	47b2                	lw	a5,12(sp)
8000a55a:	0ae7a423          	sw	a4,168(a5) # 7f00a8 <__NONCACHEABLE_RAM_segment_size__+0x3f00a8>
}
8000a55e:	0001                	nop
8000a560:	0141                	add	sp,sp,16
8000a562:	8082                	ret

Disassembly of section .text.is_can_bit_timing_param_valid:

8000a564 <is_can_bit_timing_param_valid>:

    return status;
}

static bool is_can_bit_timing_param_valid(can_bit_timing_option_t option, const can_bit_timing_param_t *param)
{
8000a564:	1101                	add	sp,sp,-32
8000a566:	87aa                	mv	a5,a0
8000a568:	c42e                	sw	a1,8(sp)
8000a56a:	00f107a3          	sb	a5,15(sp)
    bool result = false;
8000a56e:	00010fa3          	sb	zero,31(sp)
    const can_bit_timing_table_t *tbl = &s_can_bit_timing_tbl[(uint8_t) option];
8000a572:	00f14703          	lbu	a4,15(sp)
8000a576:	87ba                	mv	a5,a4
8000a578:	078e                	sll	a5,a5,0x3
8000a57a:	97ba                	add	a5,a5,a4
8000a57c:	8000a737          	lui	a4,0x8000a
8000a580:	37870713          	add	a4,a4,888 # 8000a378 <s_can_bit_timing_tbl>
8000a584:	97ba                	add	a5,a5,a4
8000a586:	cc3e                	sw	a5,24(sp)
    do {
        if ((param->num_seg1 < tbl->seg1_min) || (param->num_seg1 > tbl->seg1_max)) {
8000a588:	47a2                	lw	a5,8(sp)
8000a58a:	0027d783          	lhu	a5,2(a5)
8000a58e:	4762                	lw	a4,24(sp)
8000a590:	00274703          	lbu	a4,2(a4)
8000a594:	06e7e663          	bltu	a5,a4,8000a600 <.L66>
8000a598:	47a2                	lw	a5,8(sp)
8000a59a:	0027d783          	lhu	a5,2(a5)
8000a59e:	4762                	lw	a4,24(sp)
8000a5a0:	00374703          	lbu	a4,3(a4)
8000a5a4:	04f76e63          	bltu	a4,a5,8000a600 <.L66>
            break;
        }
        if ((param->num_seg2 < tbl->seg2_min) || (param->num_seg2 > tbl->seg2_max)) {
8000a5a8:	47a2                	lw	a5,8(sp)
8000a5aa:	0047d783          	lhu	a5,4(a5)
8000a5ae:	4762                	lw	a4,24(sp)
8000a5b0:	00474703          	lbu	a4,4(a4)
8000a5b4:	04e7e663          	bltu	a5,a4,8000a600 <.L66>
8000a5b8:	47a2                	lw	a5,8(sp)
8000a5ba:	0047d783          	lhu	a5,4(a5)
8000a5be:	4762                	lw	a4,24(sp)
8000a5c0:	00574703          	lbu	a4,5(a4)
8000a5c4:	02f76e63          	bltu	a4,a5,8000a600 <.L66>
            break;
        }
        if ((param->num_sjw < tbl->sjw_min) || (param->num_sjw > tbl->sjw_max)) {
8000a5c8:	47a2                	lw	a5,8(sp)
8000a5ca:	0067d783          	lhu	a5,6(a5)
8000a5ce:	4762                	lw	a4,24(sp)
8000a5d0:	00674703          	lbu	a4,6(a4)
8000a5d4:	02e7e663          	bltu	a5,a4,8000a600 <.L66>
8000a5d8:	47a2                	lw	a5,8(sp)
8000a5da:	0067d783          	lhu	a5,6(a5)
8000a5de:	4762                	lw	a4,24(sp)
8000a5e0:	00774703          	lbu	a4,7(a4)
8000a5e4:	00f76e63          	bltu	a4,a5,8000a600 <.L66>
            break;
        }
        if (param->prescaler > NUM_PRESCALE_MAX) {
8000a5e8:	47a2                	lw	a5,8(sp)
8000a5ea:	0007d703          	lhu	a4,0(a5)
8000a5ee:	10000793          	li	a5,256
8000a5f2:	00e7e663          	bltu	a5,a4,8000a5fe <.L69>
            break;
        }
        result = true;
8000a5f6:	4785                	li	a5,1
8000a5f8:	00f10fa3          	sb	a5,31(sp)
8000a5fc:	a011                	j	8000a600 <.L66>

8000a5fe <.L69>:
            break;
8000a5fe:	0001                	nop

8000a600 <.L66>:
    } while (false);

    return result;
8000a600:	01f14783          	lbu	a5,31(sp)
}
8000a604:	853e                	mv	a0,a5
8000a606:	6105                	add	sp,sp,32
8000a608:	8082                	ret

Disassembly of section .text.can_set_bit_timing:

8000a60a <can_set_bit_timing>:

hpm_stat_t can_set_bit_timing(CAN_Type *base, can_bit_timing_option_t option,
                              uint32_t src_clk_freq, uint32_t baudrate,
                              uint16_t samplepoint_min, uint16_t samplepoint_max)
{
8000a60a:	7139                	add	sp,sp,-64
8000a60c:	de06                	sw	ra,60(sp)
8000a60e:	ce2a                	sw	a0,28(sp)
8000a610:	ca32                	sw	a2,20(sp)
8000a612:	c836                	sw	a3,16(sp)
8000a614:	86ba                	mv	a3,a4
8000a616:	873e                	mv	a4,a5
8000a618:	87ae                	mv	a5,a1
8000a61a:	00f10da3          	sb	a5,27(sp)
8000a61e:	87b6                	mv	a5,a3
8000a620:	00f11c23          	sh	a5,24(sp)
8000a624:	87ba                	mv	a5,a4
8000a626:	00f11723          	sh	a5,14(sp)
    hpm_stat_t status = status_invalid_argument;
8000a62a:	4789                	li	a5,2
8000a62c:	d63e                	sw	a5,44(sp)

8000a62e <.LBB7>:

    do {
        if (base == NULL) {
8000a62e:	47f2                	lw	a5,28(sp)
8000a630:	cbc5                	beqz	a5,8000a6e0 <.L77>
            break;
        }

        can_bit_timing_param_t timing_param;
        status = can_calculate_bit_timing(src_clk_freq, option, baudrate, samplepoint_min, samplepoint_max, &timing_param);
8000a632:	105c                	add	a5,sp,36
8000a634:	00e15703          	lhu	a4,14(sp)
8000a638:	01815683          	lhu	a3,24(sp)
8000a63c:	01b14583          	lbu	a1,27(sp)
8000a640:	4642                	lw	a2,16(sp)
8000a642:	4552                	lw	a0,20(sp)
8000a644:	753020ef          	jal	8000d596 <can_calculate_bit_timing>
8000a648:	d62a                	sw	a0,44(sp)

        if (status == status_success) {
8000a64a:	57b2                	lw	a5,44(sp)
8000a64c:	ebd9                	bnez	a5,8000a6e2 <.L72>
            if (option < can_bit_timing_canfd_data) {
8000a64e:	01b14703          	lbu	a4,27(sp)
8000a652:	4785                	li	a5,1
8000a654:	04e7e463          	bltu	a5,a4,8000a69c <.L74>
                base->S_PRESC = CAN_S_PRESC_S_PRESC_SET(timing_param.prescaler - 1U) | CAN_S_PRESC_S_SEG_1_SET(timing_param.num_seg1 - 2U) |
8000a658:	02415783          	lhu	a5,36(sp)
8000a65c:	17fd                	add	a5,a5,-1
8000a65e:	01879713          	sll	a4,a5,0x18
8000a662:	02615783          	lhu	a5,38(sp)
8000a666:	17f9                	add	a5,a5,-2
8000a668:	0ff7f793          	zext.b	a5,a5
8000a66c:	8f5d                	or	a4,a4,a5
                                CAN_S_PRESC_S_SEG_2_SET(timing_param.num_seg2 - 1U) | CAN_S_PRESC_S_SJW_SET(timing_param.num_sjw - 1U);
8000a66e:	02815783          	lhu	a5,40(sp)
8000a672:	17fd                	add	a5,a5,-1
8000a674:	00879693          	sll	a3,a5,0x8
8000a678:	67a1                	lui	a5,0x8
8000a67a:	f0078793          	add	a5,a5,-256 # 7f00 <__DLM_segment_used_size__+0x3f00>
8000a67e:	8ff5                	and	a5,a5,a3
                base->S_PRESC = CAN_S_PRESC_S_PRESC_SET(timing_param.prescaler - 1U) | CAN_S_PRESC_S_SEG_1_SET(timing_param.num_seg1 - 2U) |
8000a680:	8f5d                	or	a4,a4,a5
                                CAN_S_PRESC_S_SEG_2_SET(timing_param.num_seg2 - 1U) | CAN_S_PRESC_S_SJW_SET(timing_param.num_sjw - 1U);
8000a682:	02a15783          	lhu	a5,42(sp)
8000a686:	17fd                	add	a5,a5,-1
8000a688:	01079693          	sll	a3,a5,0x10
8000a68c:	007f07b7          	lui	a5,0x7f0
8000a690:	8ff5                	and	a5,a5,a3
8000a692:	8f5d                	or	a4,a4,a5
                base->S_PRESC = CAN_S_PRESC_S_PRESC_SET(timing_param.prescaler - 1U) | CAN_S_PRESC_S_SEG_1_SET(timing_param.num_seg1 - 2U) |
8000a694:	47f2                	lw	a5,28(sp)
8000a696:	0ae7a423          	sw	a4,168(a5) # 7f00a8 <__NONCACHEABLE_RAM_segment_size__+0x3f00a8>
8000a69a:	a089                	j	8000a6dc <.L75>

8000a69c <.L74>:
            } else {
                base->F_PRESC = CAN_F_PRESC_F_PRESC_SET(timing_param.prescaler - 1U) | CAN_F_PRESC_F_SEG_1_SET(timing_param.num_seg1 - 2U) |
8000a69c:	02415783          	lhu	a5,36(sp)
8000a6a0:	17fd                	add	a5,a5,-1
8000a6a2:	01879713          	sll	a4,a5,0x18
8000a6a6:	02615783          	lhu	a5,38(sp)
8000a6aa:	17f9                	add	a5,a5,-2
8000a6ac:	8bbd                	and	a5,a5,15
8000a6ae:	8f5d                	or	a4,a4,a5
                                CAN_F_PRESC_F_SEG_2_SET(timing_param.num_seg2 - 1U) | CAN_F_PRESC_F_SJW_SET(timing_param.num_sjw - 1U);
8000a6b0:	02815783          	lhu	a5,40(sp)
8000a6b4:	17fd                	add	a5,a5,-1
8000a6b6:	00879693          	sll	a3,a5,0x8
8000a6ba:	6785                	lui	a5,0x1
8000a6bc:	f0078793          	add	a5,a5,-256 # f00 <__NOR_CFG_OPTION_segment_size__+0x300>
8000a6c0:	8ff5                	and	a5,a5,a3
                base->F_PRESC = CAN_F_PRESC_F_PRESC_SET(timing_param.prescaler - 1U) | CAN_F_PRESC_F_SEG_1_SET(timing_param.num_seg1 - 2U) |
8000a6c2:	8f5d                	or	a4,a4,a5
                                CAN_F_PRESC_F_SEG_2_SET(timing_param.num_seg2 - 1U) | CAN_F_PRESC_F_SJW_SET(timing_param.num_sjw - 1U);
8000a6c4:	02a15783          	lhu	a5,42(sp)
8000a6c8:	17fd                	add	a5,a5,-1
8000a6ca:	01079693          	sll	a3,a5,0x10
8000a6ce:	000f07b7          	lui	a5,0xf0
8000a6d2:	8ff5                	and	a5,a5,a3
8000a6d4:	8f5d                	or	a4,a4,a5
                base->F_PRESC = CAN_F_PRESC_F_PRESC_SET(timing_param.prescaler - 1U) | CAN_F_PRESC_F_SEG_1_SET(timing_param.num_seg1 - 2U) |
8000a6d6:	47f2                	lw	a5,28(sp)
8000a6d8:	0ae7a623          	sw	a4,172(a5) # f00ac <__AXI_SRAM_segment_size__+0x300ac>

8000a6dc <.L75>:

            }
            status = status_success;
8000a6dc:	d602                	sw	zero,44(sp)
8000a6de:	a011                	j	8000a6e2 <.L72>

8000a6e0 <.L77>:
            break;
8000a6e0:	0001                	nop

8000a6e2 <.L72>:
        }

    } while (false);

    return status;
8000a6e2:	57b2                	lw	a5,44(sp)
}
8000a6e4:	853e                	mv	a0,a5
8000a6e6:	50f2                	lw	ra,60(sp)
8000a6e8:	6121                	add	sp,sp,64
8000a6ea:	8082                	ret

Disassembly of section .text.can_set_filter:

8000a6ec <can_set_filter>:

hpm_stat_t can_set_filter(CAN_Type *base, const can_filter_config_t *config)
{
8000a6ec:	1101                	add	sp,sp,-32
8000a6ee:	c62a                	sw	a0,12(sp)
8000a6f0:	c42e                	sw	a1,8(sp)
    hpm_stat_t status = status_invalid_argument;
8000a6f2:	4789                	li	a5,2
8000a6f4:	ce3e                	sw	a5,28(sp)

8000a6f6 <.LBB8>:

    do {
        if ((base == NULL) || (config == NULL)) {
8000a6f6:	47b2                	lw	a5,12(sp)
8000a6f8:	10078b63          	beqz	a5,8000a80e <.L79>
8000a6fc:	47a2                	lw	a5,8(sp)
8000a6fe:	10078863          	beqz	a5,8000a80e <.L79>
            break;
        }
        if (config->index > CAN_FILTER_INDEX_MAX) {
8000a702:	47a2                	lw	a5,8(sp)
8000a704:	0007d703          	lhu	a4,0(a5)
8000a708:	47bd                	li	a5,15
8000a70a:	00e7f763          	bgeu	a5,a4,8000a718 <.L80>
            status = status_can_filter_index_invalid;
8000a70e:	6795                	lui	a5,0x5
8000a710:	a3f78793          	add	a5,a5,-1473 # 4a3f <__DLM_segment_used_size__+0xa3f>
8000a714:	ce3e                	sw	a5,28(sp)
            break;
8000a716:	a8e5                	j	8000a80e <.L79>

8000a718 <.L80>:
        }

        /* Configure acceptance code */
        base->ACFCTRL = CAN_ACFCTRL_ACFADR_SET(config->index);
8000a718:	47a2                	lw	a5,8(sp)
8000a71a:	0007d783          	lhu	a5,0(a5)
8000a71e:	0ff7f793          	zext.b	a5,a5
8000a722:	8bbd                	and	a5,a5,15
8000a724:	0ff7f713          	zext.b	a4,a5
8000a728:	47b2                	lw	a5,12(sp)
8000a72a:	0ae78a23          	sb	a4,180(a5)
        base->ACF = CAN_ACF_CODE_MASK_SET(config->code);
8000a72e:	47a2                	lw	a5,8(sp)
8000a730:	43d8                	lw	a4,4(a5)
8000a732:	200007b7          	lui	a5,0x20000
8000a736:	17fd                	add	a5,a5,-1 # 1fffffff <__SHARE_RAM_segment_end__+0x1ee7ffff>
8000a738:	8f7d                	and	a4,a4,a5
8000a73a:	47b2                	lw	a5,12(sp)
8000a73c:	0ae7ac23          	sw	a4,184(a5)

        /* Configure acceptance mask */
        uint32_t acf_value = CAN_ACF_CODE_MASK_SET(config->mask);
8000a740:	47a2                	lw	a5,8(sp)
8000a742:	4798                	lw	a4,8(a5)
8000a744:	200007b7          	lui	a5,0x20000
8000a748:	17fd                	add	a5,a5,-1 # 1fffffff <__SHARE_RAM_segment_end__+0x1ee7ffff>
8000a74a:	8ff9                	and	a5,a5,a4
8000a74c:	cc3e                	sw	a5,24(sp)
        if (config->id_mode == can_filter_id_mode_standard_frames) {
8000a74e:	47a2                	lw	a5,8(sp)
8000a750:	0027c703          	lbu	a4,2(a5)
8000a754:	4785                	li	a5,1
8000a756:	00f71863          	bne	a4,a5,8000a766 <.L81>
            acf_value |= CAN_ACF_AIDEE_MASK;
8000a75a:	4762                	lw	a4,24(sp)
8000a75c:	400007b7          	lui	a5,0x40000
8000a760:	8fd9                	or	a5,a5,a4
8000a762:	cc3e                	sw	a5,24(sp)
8000a764:	a821                	j	8000a77c <.L82>

8000a766 <.L81>:
        } else if (config->id_mode == can_filter_id_mode_extended_frames) {
8000a766:	47a2                	lw	a5,8(sp)
8000a768:	0027c703          	lbu	a4,2(a5) # 40000002 <__SDRAM_segment_start__+0x2>
8000a76c:	4789                	li	a5,2
8000a76e:	00f71763          	bne	a4,a5,8000a77c <.L82>
            acf_value |= CAN_ACF_AIDEE_MASK | CAN_ACF_AIDE_MASK;
8000a772:	4762                	lw	a4,24(sp)
8000a774:	600007b7          	lui	a5,0x60000
8000a778:	8fd9                	or	a5,a5,a4
8000a77a:	cc3e                	sw	a5,24(sp)

8000a77c <.L82>:
        } else {
            /* Treat it as the default mode */
            acf_value |= 0;
        }

        base->ACFCTRL = CAN_ACFCTRL_SELMASK_MASK | CAN_ACFCTRL_ACFADR_SET(config->index);
8000a77c:	47a2                	lw	a5,8(sp)
8000a77e:	0007d783          	lhu	a5,0(a5) # 60000000 <__NONCACHEABLE_RAM_segment_end__+0x1f000000>
8000a782:	0ff7f793          	zext.b	a5,a5
8000a786:	8bbd                	and	a5,a5,15
8000a788:	0ff7f793          	zext.b	a5,a5
8000a78c:	0207e793          	or	a5,a5,32
8000a790:	0ff7f713          	zext.b	a4,a5
8000a794:	47b2                	lw	a5,12(sp)
8000a796:	0ae78a23          	sb	a4,180(a5)
        base->ACF = acf_value;
8000a79a:	47b2                	lw	a5,12(sp)
8000a79c:	4762                	lw	a4,24(sp)
8000a79e:	0ae7ac23          	sw	a4,184(a5)

        if (config->enable) {
8000a7a2:	47a2                	lw	a5,8(sp)
8000a7a4:	0037c783          	lbu	a5,3(a5)
8000a7a8:	cb85                	beqz	a5,8000a7d8 <.L84>
            base->ACF_EN |= (1U << config->index);
8000a7aa:	47b2                	lw	a5,12(sp)
8000a7ac:	0b67d783          	lhu	a5,182(a5)
8000a7b0:	01079713          	sll	a4,a5,0x10
8000a7b4:	8341                	srl	a4,a4,0x10
8000a7b6:	47a2                	lw	a5,8(sp)
8000a7b8:	0007d783          	lhu	a5,0(a5)
8000a7bc:	86be                	mv	a3,a5
8000a7be:	4785                	li	a5,1
8000a7c0:	00d797b3          	sll	a5,a5,a3
8000a7c4:	07c2                	sll	a5,a5,0x10
8000a7c6:	83c1                	srl	a5,a5,0x10
8000a7c8:	8fd9                	or	a5,a5,a4
8000a7ca:	01079713          	sll	a4,a5,0x10
8000a7ce:	8341                	srl	a4,a4,0x10
8000a7d0:	47b2                	lw	a5,12(sp)
8000a7d2:	0ae79b23          	sh	a4,182(a5)
8000a7d6:	a81d                	j	8000a80c <.L85>

8000a7d8 <.L84>:
        } else {
            base->ACF_EN &= (uint16_t) ~(1U << config->index);
8000a7d8:	47b2                	lw	a5,12(sp)
8000a7da:	0b67d783          	lhu	a5,182(a5)
8000a7de:	01079713          	sll	a4,a5,0x10
8000a7e2:	8341                	srl	a4,a4,0x10
8000a7e4:	47a2                	lw	a5,8(sp)
8000a7e6:	0007d783          	lhu	a5,0(a5)
8000a7ea:	86be                	mv	a3,a5
8000a7ec:	4785                	li	a5,1
8000a7ee:	00d797b3          	sll	a5,a5,a3
8000a7f2:	07c2                	sll	a5,a5,0x10
8000a7f4:	83c1                	srl	a5,a5,0x10
8000a7f6:	fff7c793          	not	a5,a5
8000a7fa:	07c2                	sll	a5,a5,0x10
8000a7fc:	83c1                	srl	a5,a5,0x10
8000a7fe:	8ff9                	and	a5,a5,a4
8000a800:	01079713          	sll	a4,a5,0x10
8000a804:	8341                	srl	a4,a4,0x10
8000a806:	47b2                	lw	a5,12(sp)
8000a808:	0ae79b23          	sh	a4,182(a5)

8000a80c <.L85>:
        }
        status = status_success;
8000a80c:	ce02                	sw	zero,28(sp)

8000a80e <.L79>:
    } while (false);

    return status;
8000a80e:	47f2                	lw	a5,28(sp)
}
8000a810:	853e                	mv	a0,a5
8000a812:	6105                	add	sp,sp,32
8000a814:	8082                	ret

Disassembly of section .text.can_get_data_words_from_dlc:

8000a816 <can_get_data_words_from_dlc>:

static uint8_t can_get_data_words_from_dlc(uint32_t dlc)
{
8000a816:	1101                	add	sp,sp,-32
8000a818:	c62a                	sw	a0,12(sp)
    uint32_t copy_words = 0;
8000a81a:	ce02                	sw	zero,28(sp)

    dlc &= 0xFU;
8000a81c:	47b2                	lw	a5,12(sp)
8000a81e:	8bbd                	and	a5,a5,15
8000a820:	c63e                	sw	a5,12(sp)
    if (dlc <= 8U) {
8000a822:	4732                	lw	a4,12(sp)
8000a824:	47a1                	li	a5,8
8000a826:	00e7e763          	bltu	a5,a4,8000a834 <.L88>
        copy_words = (dlc + 3U) / sizeof(uint32_t);
8000a82a:	47b2                	lw	a5,12(sp)
8000a82c:	078d                	add	a5,a5,3
8000a82e:	8389                	srl	a5,a5,0x2
8000a830:	ce3e                	sw	a5,28(sp)
8000a832:	a0a9                	j	8000a87c <.L89>

8000a834 <.L88>:
    } else {
        switch (dlc) {
8000a834:	47b2                	lw	a5,12(sp)
8000a836:	17dd                	add	a5,a5,-9
8000a838:	4719                	li	a4,6
8000a83a:	04f76063          	bltu	a4,a5,8000a87a <.L100>
8000a83e:	00279713          	sll	a4,a5,0x2
8000a842:	800037b7          	lui	a5,0x80003
8000a846:	14078793          	add	a5,a5,320 # 80003140 <.L92>
8000a84a:	97ba                	add	a5,a5,a4
8000a84c:	439c                	lw	a5,0(a5)
8000a84e:	8782                	jr	a5

8000a850 <.L98>:
        case can_payload_size_12:
            copy_words = 3U;
8000a850:	478d                	li	a5,3
8000a852:	ce3e                	sw	a5,28(sp)
            break;
8000a854:	a025                	j	8000a87c <.L89>

8000a856 <.L97>:
        case can_payload_size_16:
            copy_words = 4U;
8000a856:	4791                	li	a5,4
8000a858:	ce3e                	sw	a5,28(sp)
            break;
8000a85a:	a00d                	j	8000a87c <.L89>

8000a85c <.L96>:
        case can_payload_size_20:
            copy_words = 5U;
8000a85c:	4795                	li	a5,5
8000a85e:	ce3e                	sw	a5,28(sp)
            break;
8000a860:	a831                	j	8000a87c <.L89>

8000a862 <.L95>:
        case can_payload_size_24:
            copy_words = 6U;
8000a862:	4799                	li	a5,6
8000a864:	ce3e                	sw	a5,28(sp)
            break;
8000a866:	a819                	j	8000a87c <.L89>

8000a868 <.L94>:
        case can_payload_size_32:
            copy_words = 8U;
8000a868:	47a1                	li	a5,8
8000a86a:	ce3e                	sw	a5,28(sp)
            break;
8000a86c:	a801                	j	8000a87c <.L89>

8000a86e <.L93>:
        case can_payload_size_48:
            copy_words = 12U;
8000a86e:	47b1                	li	a5,12
8000a870:	ce3e                	sw	a5,28(sp)
            break;
8000a872:	a029                	j	8000a87c <.L89>

8000a874 <.L91>:
        case can_payload_size_64:
            copy_words = 16U;
8000a874:	47c1                	li	a5,16
8000a876:	ce3e                	sw	a5,28(sp)
            break;
8000a878:	a011                	j	8000a87c <.L89>

8000a87a <.L100>:
        default:
            /* Code should never touch here */
            break;
8000a87a:	0001                	nop

8000a87c <.L89>:
        }
    }

    return copy_words;
8000a87c:	47f2                	lw	a5,28(sp)
8000a87e:	0ff7f793          	zext.b	a5,a5
}
8000a882:	853e                	mv	a0,a5
8000a884:	6105                	add	sp,sp,32
8000a886:	8082                	ret

Disassembly of section .text.can_init:

8000a888 <can_init>:

    return status;
}

hpm_stat_t can_init(CAN_Type *base, can_config_t *config, uint32_t src_clk_freq)
{
8000a888:	715d                	add	sp,sp,-80
8000a88a:	c686                	sw	ra,76(sp)
8000a88c:	c62a                	sw	a0,12(sp)
8000a88e:	c42e                	sw	a1,8(sp)
8000a890:	c232                	sw	a2,4(sp)
    hpm_stat_t status = status_invalid_argument;
8000a892:	4789                	li	a5,2
8000a894:	de3e                	sw	a5,60(sp)

8000a896 <.LBB16>:

    do {

        HPM_BREAK_IF((base == NULL) || (config == NULL) || (src_clk_freq == 0U) || (config->filter_list_num > 16U));
8000a896:	47b2                	lw	a5,12(sp)
8000a898:	2a078863          	beqz	a5,8000ab48 <.L164>
8000a89c:	47a2                	lw	a5,8(sp)
8000a89e:	2a078563          	beqz	a5,8000ab48 <.L164>
8000a8a2:	4792                	lw	a5,4(sp)
8000a8a4:	2a078263          	beqz	a5,8000ab48 <.L164>
8000a8a8:	47a2                	lw	a5,8(sp)
8000a8aa:	0177c703          	lbu	a4,23(a5)
8000a8ae:	47c1                	li	a5,16
8000a8b0:	28e7ec63          	bltu	a5,a4,8000ab48 <.L164>

        can_reset(base, true);
8000a8b4:	4585                	li	a1,1
8000a8b6:	4532                	lw	a0,12(sp)
8000a8b8:	2bb020ef          	jal	8000d372 <can_reset>

        base->TTCFG &= ~CAN_TTCFG_TTEN_MASK;
8000a8bc:	47b2                	lw	a5,12(sp)
8000a8be:	0bf7c783          	lbu	a5,191(a5)
8000a8c2:	0ff7f793          	zext.b	a5,a5
8000a8c6:	9bf9                	and	a5,a5,-2
8000a8c8:	0ff7f713          	zext.b	a4,a5
8000a8cc:	47b2                	lw	a5,12(sp)
8000a8ce:	0ae78fa3          	sb	a4,191(a5)
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_TTTBM_MASK;
8000a8d2:	47b2                	lw	a5,12(sp)
8000a8d4:	0a07a703          	lw	a4,160(a5)
8000a8d8:	fff007b7          	lui	a5,0xfff00
8000a8dc:	17fd                	add	a5,a5,-1 # ffefffff <__APB_SRAM_segment_end__+0xbe0dfff>
8000a8de:	8f7d                	and	a4,a4,a5
8000a8e0:	47b2                	lw	a5,12(sp)
8000a8e2:	0ae7a023          	sw	a4,160(a5)

        if (!config->use_lowlevel_timing_setting) {
8000a8e6:	47a2                	lw	a5,8(sp)
8000a8e8:	0117c783          	lbu	a5,17(a5)
8000a8ec:	0017c793          	xor	a5,a5,1
8000a8f0:	0ff7f793          	zext.b	a5,a5
8000a8f4:	c3ad                	beqz	a5,8000a956 <.L165>
            if (config->enable_canfd) {
8000a8f6:	47a2                	lw	a5,8(sp)
8000a8f8:	0127c783          	lbu	a5,18(a5)
8000a8fc:	cf9d                	beqz	a5,8000a93a <.L166>
                status = can_set_bit_timing(base,
8000a8fe:	47a2                	lw	a5,8(sp)
8000a900:	4394                	lw	a3,0(a5)
8000a902:	47a2                	lw	a5,8(sp)
8000a904:	0087d703          	lhu	a4,8(a5)
8000a908:	47a2                	lw	a5,8(sp)
8000a90a:	00a7d783          	lhu	a5,10(a5)
8000a90e:	4612                	lw	a2,4(sp)
8000a910:	4585                	li	a1,1
8000a912:	4532                	lw	a0,12(sp)
8000a914:	39dd                	jal	8000a60a <can_set_bit_timing>
8000a916:	de2a                	sw	a0,60(sp)
                                            can_bit_timing_canfd_nominal,
                                            src_clk_freq,
                                            config->baudrate,
                                            config->can20_samplepoint_min,
                                            config->can20_samplepoint_max);
                HPM_BREAK_IF(status != status_success);
8000a918:	57f2                	lw	a5,60(sp)
8000a91a:	22079763          	bnez	a5,8000ab48 <.L164>
                status = can_set_bit_timing(base,
8000a91e:	47a2                	lw	a5,8(sp)
8000a920:	43d4                	lw	a3,4(a5)
8000a922:	47a2                	lw	a5,8(sp)
8000a924:	00c7d703          	lhu	a4,12(a5)
8000a928:	47a2                	lw	a5,8(sp)
8000a92a:	00e7d783          	lhu	a5,14(a5)
8000a92e:	4612                	lw	a2,4(sp)
8000a930:	4589                	li	a1,2
8000a932:	4532                	lw	a0,12(sp)
8000a934:	39d9                	jal	8000a60a <can_set_bit_timing>
8000a936:	de2a                	sw	a0,60(sp)
8000a938:	a86d                	j	8000a9f2 <.L168>

8000a93a <.L166>:
                                            src_clk_freq,
                                            config->baudrate_fd,
                                            config->canfd_samplepoint_min,
                                            config->canfd_samplepoint_max);
            } else {
                status = can_set_bit_timing(base,
8000a93a:	47a2                	lw	a5,8(sp)
8000a93c:	4394                	lw	a3,0(a5)
8000a93e:	47a2                	lw	a5,8(sp)
8000a940:	0087d703          	lhu	a4,8(a5)
8000a944:	47a2                	lw	a5,8(sp)
8000a946:	00a7d783          	lhu	a5,10(a5)
8000a94a:	4612                	lw	a2,4(sp)
8000a94c:	4581                	li	a1,0
8000a94e:	4532                	lw	a0,12(sp)
8000a950:	396d                	jal	8000a60a <can_set_bit_timing>
8000a952:	de2a                	sw	a0,60(sp)
8000a954:	a879                	j	8000a9f2 <.L168>

8000a956 <.L165>:
                                            config->baudrate,
                                            config->can20_samplepoint_min,
                                            config->can20_samplepoint_max);
            }
        } else {
            if (config->enable_canfd) {
8000a956:	47a2                	lw	a5,8(sp)
8000a958:	0127c783          	lbu	a5,18(a5)
8000a95c:	c3bd                	beqz	a5,8000a9c2 <.L169>

8000a95e <.LBB17>:
                bool param_valid = is_can_bit_timing_param_valid(can_bit_timing_canfd_nominal, &config->can_timing);
8000a95e:	47a2                	lw	a5,8(sp)
8000a960:	85be                	mv	a1,a5
8000a962:	4505                	li	a0,1
8000a964:	3101                	jal	8000a564 <is_can_bit_timing_param_valid>
8000a966:	87aa                	mv	a5,a0
8000a968:	02f10723          	sb	a5,46(sp)
                if (!param_valid) {
8000a96c:	02e14783          	lbu	a5,46(sp)
8000a970:	0017c793          	xor	a5,a5,1
8000a974:	0ff7f793          	zext.b	a5,a5
8000a978:	c791                	beqz	a5,8000a984 <.L170>
                    status = status_can_invalid_bit_timing;
8000a97a:	6795                	lui	a5,0x5
8000a97c:	a4178793          	add	a5,a5,-1471 # 4a41 <__DLM_segment_used_size__+0xa41>
8000a980:	de3e                	sw	a5,60(sp)
                    break;
8000a982:	a2d9                	j	8000ab48 <.L164>

8000a984 <.L170>:
                }
                param_valid = is_can_bit_timing_param_valid(can_bit_timing_canfd_data, &config->canfd_timing);
8000a984:	47a2                	lw	a5,8(sp)
8000a986:	07a1                	add	a5,a5,8
8000a988:	85be                	mv	a1,a5
8000a98a:	4509                	li	a0,2
8000a98c:	3ee1                	jal	8000a564 <is_can_bit_timing_param_valid>
8000a98e:	87aa                	mv	a5,a0
8000a990:	02f10723          	sb	a5,46(sp)
                if (!param_valid) {
8000a994:	02e14783          	lbu	a5,46(sp)
8000a998:	0017c793          	xor	a5,a5,1
8000a99c:	0ff7f793          	zext.b	a5,a5
8000a9a0:	c791                	beqz	a5,8000a9ac <.L171>
                    status = status_can_invalid_bit_timing;
8000a9a2:	6795                	lui	a5,0x5
8000a9a4:	a4178793          	add	a5,a5,-1471 # 4a41 <__DLM_segment_used_size__+0xa41>
8000a9a8:	de3e                	sw	a5,60(sp)
                    break;
8000a9aa:	aa79                	j	8000ab48 <.L164>

8000a9ac <.L171>:
                }
                can_set_slow_speed_timing(base, &config->can_timing);
8000a9ac:	47a2                	lw	a5,8(sp)
8000a9ae:	85be                	mv	a1,a5
8000a9b0:	4532                	lw	a0,12(sp)
8000a9b2:	3eb1                	jal	8000a50e <can_set_slow_speed_timing>
                can_set_fast_speed_timing(base, &config->canfd_timing);
8000a9b4:	47a2                	lw	a5,8(sp)
8000a9b6:	07a1                	add	a5,a5,8
8000a9b8:	85be                	mv	a1,a5
8000a9ba:	4532                	lw	a0,12(sp)
8000a9bc:	2ff020ef          	jal	8000d4ba <can_set_fast_speed_timing>

8000a9c0 <.LBE17>:
8000a9c0:	a805                	j	8000a9f0 <.L172>

8000a9c2 <.L169>:
            } else {
                bool param_valid = is_can_bit_timing_param_valid(can_bit_timing_can2_0, &config->can_timing);
8000a9c2:	47a2                	lw	a5,8(sp)
8000a9c4:	85be                	mv	a1,a5
8000a9c6:	4501                	li	a0,0
8000a9c8:	3e71                	jal	8000a564 <is_can_bit_timing_param_valid>
8000a9ca:	87aa                	mv	a5,a0
8000a9cc:	02f107a3          	sb	a5,47(sp)
                if (!param_valid) {
8000a9d0:	02f14783          	lbu	a5,47(sp)
8000a9d4:	0017c793          	xor	a5,a5,1
8000a9d8:	0ff7f793          	zext.b	a5,a5
8000a9dc:	c791                	beqz	a5,8000a9e8 <.L173>
                    status = status_can_invalid_bit_timing;
8000a9de:	6795                	lui	a5,0x5
8000a9e0:	a4178793          	add	a5,a5,-1471 # 4a41 <__DLM_segment_used_size__+0xa41>
8000a9e4:	de3e                	sw	a5,60(sp)
                    break;
8000a9e6:	a28d                	j	8000ab48 <.L164>

8000a9e8 <.L173>:
                }
                can_set_slow_speed_timing(base, &config->can_timing);
8000a9e8:	47a2                	lw	a5,8(sp)
8000a9ea:	85be                	mv	a1,a5
8000a9ec:	4532                	lw	a0,12(sp)
8000a9ee:	3605                	jal	8000a50e <can_set_slow_speed_timing>

8000a9f0 <.L172>:
            }
            status = status_success;
8000a9f0:	de02                	sw	zero,60(sp)

8000a9f2 <.L168>:
        }

        /* Enable Transmitter Delay Compensation as needed */
        uint32_t ssp_offset = CAN_F_PRESC_F_SEG_1_GET(base->F_PRESC) + 2U;
8000a9f2:	47b2                	lw	a5,12(sp)
8000a9f4:	0ac7a783          	lw	a5,172(a5)
8000a9f8:	8bbd                	and	a5,a5,15
8000a9fa:	0789                	add	a5,a5,2
8000a9fc:	d43e                	sw	a5,40(sp)
        can_set_transmitter_delay_compensation(base, ssp_offset, config->enable_tdc);
8000a9fe:	57a2                	lw	a5,40(sp)
8000aa00:	0ff7f713          	zext.b	a4,a5
8000aa04:	47a2                	lw	a5,8(sp)
8000aa06:	0167c783          	lbu	a5,22(a5)
8000aa0a:	863e                	mv	a2,a5
8000aa0c:	85ba                	mv	a1,a4
8000aa0e:	4532                	lw	a0,12(sp)
8000aa10:	283020ef          	jal	8000d492 <can_set_transmitter_delay_compensation>

        HPM_BREAK_IF(status != status_success);
8000aa14:	57f2                	lw	a5,60(sp)
8000aa16:	12079963          	bnez	a5,8000ab48 <.L164>


        /* Configure the CAN filters */
        if (config->filter_list_num > CAN_FILTER_NUM_MAX) {
8000aa1a:	47a2                	lw	a5,8(sp)
8000aa1c:	0177c703          	lbu	a4,23(a5)
8000aa20:	47c1                	li	a5,16
8000aa22:	00e7f763          	bgeu	a5,a4,8000aa30 <.L175>
            status = status_can_filter_num_invalid;
8000aa26:	6795                	lui	a5,0x5
8000aa28:	a4078793          	add	a5,a5,-1472 # 4a40 <__DLM_segment_used_size__+0xa40>
8000aa2c:	de3e                	sw	a5,60(sp)
            break;
8000aa2e:	aa29                	j	8000ab48 <.L164>

8000aa30 <.L175>:
        } else if (config->filter_list_num == 0) {
8000aa30:	47a2                	lw	a5,8(sp)
8000aa32:	0177c783          	lbu	a5,23(a5)
8000aa36:	ef95                	bnez	a5,8000aa72 <.L176>

8000aa38 <.LBB19>:
            can_filter_config_t default_filter = CAN_DEFAULT_FILTER_SETTING;
8000aa38:	00011e23          	sh	zero,28(sp)
8000aa3c:	00010f23          	sb	zero,30(sp)
8000aa40:	4785                	li	a5,1
8000aa42:	00f10fa3          	sb	a5,31(sp)
8000aa46:	d002                	sw	zero,32(sp)
8000aa48:	200007b7          	lui	a5,0x20000
8000aa4c:	17fd                	add	a5,a5,-1 # 1fffffff <__SHARE_RAM_segment_end__+0x1ee7ffff>
8000aa4e:	d23e                	sw	a5,36(sp)

8000aa50 <.LBB20>:
            for (uint32_t i = 0; i < CAN_FILTER_NUM_MAX; i++) {
8000aa50:	dc02                	sw	zero,56(sp)
8000aa52:	a039                	j	8000aa60 <.L177>

8000aa54 <.L178>:
                can_disable_filter(base, i);
8000aa54:	55e2                	lw	a1,56(sp)
8000aa56:	4532                	lw	a0,12(sp)
8000aa58:	3cb5                	jal	8000a4d4 <can_disable_filter>
            for (uint32_t i = 0; i < CAN_FILTER_NUM_MAX; i++) {
8000aa5a:	57e2                	lw	a5,56(sp)
8000aa5c:	0785                	add	a5,a5,1
8000aa5e:	dc3e                	sw	a5,56(sp)

8000aa60 <.L177>:
8000aa60:	5762                	lw	a4,56(sp)
8000aa62:	47bd                	li	a5,15
8000aa64:	fee7f8e3          	bgeu	a5,a4,8000aa54 <.L178>

8000aa68 <.LBE20>:
            }
            (void) can_set_filter(base, &default_filter);
8000aa68:	087c                	add	a5,sp,28
8000aa6a:	85be                	mv	a1,a5
8000aa6c:	4532                	lw	a0,12(sp)
8000aa6e:	39bd                	jal	8000a6ec <can_set_filter>

8000aa70 <.LBE19>:
8000aa70:	a889                	j	8000aac2 <.L179>

8000aa72 <.L176>:
        } else {
            for (uint32_t i = 0; i < CAN_FILTER_NUM_MAX; i++) {
8000aa72:	da02                	sw	zero,52(sp)
8000aa74:	a039                	j	8000aa82 <.L180>

8000aa76 <.L181>:
                can_disable_filter(base, i);
8000aa76:	55d2                	lw	a1,52(sp)
8000aa78:	4532                	lw	a0,12(sp)
8000aa7a:	3ca9                	jal	8000a4d4 <can_disable_filter>
            for (uint32_t i = 0; i < CAN_FILTER_NUM_MAX; i++) {
8000aa7c:	57d2                	lw	a5,52(sp)
8000aa7e:	0785                	add	a5,a5,1
8000aa80:	da3e                	sw	a5,52(sp)

8000aa82 <.L180>:
8000aa82:	5752                	lw	a4,52(sp)
8000aa84:	47bd                	li	a5,15
8000aa86:	fee7f8e3          	bgeu	a5,a4,8000aa76 <.L181>

8000aa8a <.LBB22>:
            }
            for (uint32_t i = 0; i < config->filter_list_num; i++) {
8000aa8a:	d802                	sw	zero,48(sp)
8000aa8c:	a025                	j	8000aab4 <.L182>

8000aa8e <.L185>:
                status = can_set_filter(base, &config->filter_list[i]);
8000aa8e:	47a2                	lw	a5,8(sp)
8000aa90:	4f94                	lw	a3,24(a5)
8000aa92:	5742                	lw	a4,48(sp)
8000aa94:	87ba                	mv	a5,a4
8000aa96:	0786                	sll	a5,a5,0x1
8000aa98:	97ba                	add	a5,a5,a4
8000aa9a:	078a                	sll	a5,a5,0x2
8000aa9c:	97b6                	add	a5,a5,a3
8000aa9e:	85be                	mv	a1,a5
8000aaa0:	4532                	lw	a0,12(sp)
8000aaa2:	31a9                	jal	8000a6ec <can_set_filter>
8000aaa4:	de2a                	sw	a0,60(sp)
                if (status != status_success) {
8000aaa6:	57f2                	lw	a5,60(sp)
8000aaa8:	c399                	beqz	a5,8000aaae <.L183>
                    return status;
8000aaaa:	57f2                	lw	a5,60(sp)
8000aaac:	a879                	j	8000ab4a <.L184>

8000aaae <.L183>:
            for (uint32_t i = 0; i < config->filter_list_num; i++) {
8000aaae:	57c2                	lw	a5,48(sp)
8000aab0:	0785                	add	a5,a5,1
8000aab2:	d83e                	sw	a5,48(sp)

8000aab4 <.L182>:
8000aab4:	47a2                	lw	a5,8(sp)
8000aab6:	0177c783          	lbu	a5,23(a5)
8000aaba:	873e                	mv	a4,a5
8000aabc:	57c2                	lw	a5,48(sp)
8000aabe:	fce7e8e3          	bltu	a5,a4,8000aa8e <.L185>

8000aac2 <.L179>:
                }
            }
        }

        /* Set CAN FD standard */
        can_enable_can_fd_iso_mode(base, config->enable_can_fd_iso_mode);
8000aac2:	47a2                	lw	a5,8(sp)
8000aac4:	01f7c783          	lbu	a5,31(a5)
8000aac8:	85be                	mv	a1,a5
8000aaca:	4532                	lw	a0,12(sp)
8000aacc:	3a9d                	jal	8000a442 <can_enable_can_fd_iso_mode>

        can_reset(base, false);
8000aace:	4581                	li	a1,0
8000aad0:	4532                	lw	a0,12(sp)
8000aad2:	0a1020ef          	jal	8000d372 <can_reset>

        /* The following mode must be set when the CAN controller is not in reset mode */

        /* Disable re-transmission on PTB on demand */
        can_disable_ptb_retransmission(base, config->disable_ptb_retransmission);
8000aad6:	47a2                	lw	a5,8(sp)
8000aad8:	0147c783          	lbu	a5,20(a5)
8000aadc:	85be                	mv	a1,a5
8000aade:	4532                	lw	a0,12(sp)
8000aae0:	0cb020ef          	jal	8000d3aa <can_disable_ptb_retransmission>
        /* Disable re-transmission on STB on demand */
        can_disable_stb_retransmission(base, config->disable_stb_retransmission);
8000aae4:	47a2                	lw	a5,8(sp)
8000aae6:	0157c783          	lbu	a5,21(a5)
8000aaea:	85be                	mv	a1,a5
8000aaec:	4532                	lw	a0,12(sp)
8000aaee:	0f5020ef          	jal	8000d3e2 <can_disable_stb_retransmission>

        /* Set Self-ack mode*/
        can_enable_self_ack(base, config->enable_self_ack);
8000aaf2:	47a2                	lw	a5,8(sp)
8000aaf4:	0137c783          	lbu	a5,19(a5)
8000aaf8:	85be                	mv	a1,a5
8000aafa:	4532                	lw	a0,12(sp)
8000aafc:	3221                	jal	8000a404 <can_enable_self_ack>

        /* Set CAN work mode */
        can_set_node_mode(base, config->mode);
8000aafe:	47a2                	lw	a5,8(sp)
8000ab00:	0107c783          	lbu	a5,16(a5)
8000ab04:	85be                	mv	a1,a5
8000ab06:	4532                	lw	a0,12(sp)
8000ab08:	f3aff0ef          	jal	8000a242 <can_set_node_mode>

        /* Configure TX Buffer priority mode */
        can_select_tx_buffer_priority_mode(base, config->enable_tx_buffer_priority_mode);
8000ab0c:	47a2                	lw	a5,8(sp)
8000ab0e:	01e7c783          	lbu	a5,30(a5)
8000ab12:	85be                	mv	a1,a5
8000ab14:	4532                	lw	a0,12(sp)
8000ab16:	f98ff0ef          	jal	8000a2ae <can_select_tx_buffer_priority_mode>

        /* Configure interrupt */
        can_disable_tx_rx_irq(base, 0xFFU);
8000ab1a:	0ff00593          	li	a1,255
8000ab1e:	4532                	lw	a0,12(sp)
8000ab20:	0fb020ef          	jal	8000d41a <can_disable_tx_rx_irq>
        can_disable_error_irq(base, 0xFFU);
8000ab24:	0ff00593          	li	a1,255
8000ab28:	4532                	lw	a0,12(sp)
8000ab2a:	12d020ef          	jal	8000d456 <can_disable_error_irq>
        can_enable_tx_rx_irq(base, config->irq_txrx_enable_mask);
8000ab2e:	47a2                	lw	a5,8(sp)
8000ab30:	01c7c783          	lbu	a5,28(a5)
8000ab34:	85be                	mv	a1,a5
8000ab36:	4532                	lw	a0,12(sp)
8000ab38:	32a1                	jal	8000a480 <can_enable_tx_rx_irq>
        can_enable_error_irq(base, config->irq_error_enable_mask);
8000ab3a:	47a2                	lw	a5,8(sp)
8000ab3c:	01d7c783          	lbu	a5,29(a5)
8000ab40:	85be                	mv	a1,a5
8000ab42:	4532                	lw	a0,12(sp)
8000ab44:	329d                	jal	8000a4aa <can_enable_error_irq>

        status = status_success;
8000ab46:	de02                	sw	zero,60(sp)

8000ab48 <.L164>:
    } while (false);

    return status;
8000ab48:	57f2                	lw	a5,60(sp)

8000ab4a <.L184>:
}
8000ab4a:	853e                	mv	a0,a5
8000ab4c:	40b6                	lw	ra,76(sp)
8000ab4e:	6161                	add	sp,sp,80
8000ab50:	8082                	ret

Disassembly of section .text.femc_enable:

8000ab52 <femc_enable>:
 * Enable FEMC
 *
 * @param[in] ptr FEMC base address
 */
static inline void femc_enable(FEMC_Type *ptr)
{
8000ab52:	1141                	add	sp,sp,-16
8000ab54:	c62a                	sw	a0,12(sp)
    ptr->CTRL &= ~FEMC_CTRL_DIS_MASK;
8000ab56:	47b2                	lw	a5,12(sp)
8000ab58:	439c                	lw	a5,0(a5)
8000ab5a:	ffd7f713          	and	a4,a5,-3
8000ab5e:	47b2                	lw	a5,12(sp)
8000ab60:	c398                	sw	a4,0(a5)
}
8000ab62:	0001                	nop
8000ab64:	0141                	add	sp,sp,16
8000ab66:	8082                	ret

Disassembly of section .text.femc_disable:

8000ab68 <femc_disable>:
 * Disable FEMC
 *
 * @param[in] ptr FEMC base address
 */
static inline void femc_disable(FEMC_Type *ptr)
{
8000ab68:	1141                	add	sp,sp,-16
8000ab6a:	c62a                	sw	a0,12(sp)
    while ((ptr->STAT0 & (uint32_t) FEMC_STAT0_IDLE_MASK) == 0) {
8000ab6c:	0001                	nop

8000ab6e <.L3>:
8000ab6e:	47b2                	lw	a5,12(sp)
8000ab70:	0c07a783          	lw	a5,192(a5)
8000ab74:	8b85                	and	a5,a5,1
8000ab76:	dfe5                	beqz	a5,8000ab6e <.L3>
    }
    ptr->CTRL |= FEMC_CTRL_DIS_MASK;
8000ab78:	47b2                	lw	a5,12(sp)
8000ab7a:	439c                	lw	a5,0(a5)
8000ab7c:	0027e713          	or	a4,a5,2
8000ab80:	47b2                	lw	a5,12(sp)
8000ab82:	c398                	sw	a4,0(a5)
}
8000ab84:	0001                	nop
8000ab86:	0141                	add	sp,sp,16
8000ab88:	8082                	ret

Disassembly of section .text.femc_make_cmd:

8000ab8a <femc_make_cmd>:
    }
    return status_success;
}

static uint32_t femc_make_cmd(uint32_t opcode)
{
8000ab8a:	1141                	add	sp,sp,-16
8000ab8c:	c62a                	sw	a0,12(sp)
    return (opcode & ~FEMC_CMD_WRITE_FLAG) | FEMC_CMD_KEY;
8000ab8e:	4732                	lw	a4,12(sp)
8000ab90:	a55a07b7          	lui	a5,0xa55a0
8000ab94:	8fd9                	or	a5,a5,a4
}
8000ab96:	853e                	mv	a0,a5
8000ab98:	0141                	add	sp,sp,16
8000ab9a:	8082                	ret

Disassembly of section .text.femc_is_write_cmd:

8000ab9c <femc_is_write_cmd>:

static bool femc_is_write_cmd(uint32_t opcode)
{
8000ab9c:	1141                	add	sp,sp,-16
8000ab9e:	c62a                	sw	a0,12(sp)
    return ((opcode & FEMC_CMD_WRITE_FLAG) == FEMC_CMD_WRITE_FLAG);
8000aba0:	47b2                	lw	a5,12(sp)
8000aba2:	83fd                	srl	a5,a5,0x1f
8000aba4:	0ff7f793          	zext.b	a5,a5
}
8000aba8:	853e                	mv	a0,a5
8000abaa:	0141                	add	sp,sp,16
8000abac:	8082                	ret

Disassembly of section .text.femc_issue_ip_cmd:

8000abae <femc_issue_ip_cmd>:

uint32_t femc_issue_ip_cmd(FEMC_Type *ptr, uint32_t base_address, femc_cmd_t *cmd)
{
8000abae:	7179                	add	sp,sp,-48
8000abb0:	d606                	sw	ra,44(sp)
8000abb2:	c62a                	sw	a0,12(sp)
8000abb4:	c42e                	sw	a1,8(sp)
8000abb6:	c232                	sw	a2,4(sp)
    bool read_data = !femc_is_write_cmd(cmd->opcode);
8000abb8:	4792                	lw	a5,4(sp)
8000abba:	439c                	lw	a5,0(a5)
8000abbc:	853e                	mv	a0,a5
8000abbe:	3ff9                	jal	8000ab9c <femc_is_write_cmd>
8000abc0:	87aa                	mv	a5,a0
8000abc2:	00f037b3          	snez	a5,a5
8000abc6:	0ff7f793          	zext.b	a5,a5
8000abca:	0017c793          	xor	a5,a5,1
8000abce:	0ff7f793          	zext.b	a5,a5
8000abd2:	00f10fa3          	sb	a5,31(sp)
8000abd6:	01f14783          	lbu	a5,31(sp)
8000abda:	8b85                	and	a5,a5,1
8000abdc:	00f10fa3          	sb	a5,31(sp)
    ptr->SADDR = base_address;
8000abe0:	47b2                	lw	a5,12(sp)
8000abe2:	4722                	lw	a4,8(sp)
8000abe4:	08e7a823          	sw	a4,144(a5) # a55a0090 <__FLASH_segment_end__+0x24da0090>
    if (!read_data) {
8000abe8:	01f14783          	lbu	a5,31(sp)
8000abec:	0017c793          	xor	a5,a5,1
8000abf0:	0ff7f793          	zext.b	a5,a5
8000abf4:	c791                	beqz	a5,8000ac00 <.L20>
        ptr->IPTX = cmd->data;
8000abf6:	4792                	lw	a5,4(sp)
8000abf8:	43d8                	lw	a4,4(a5)
8000abfa:	47b2                	lw	a5,12(sp)
8000abfc:	0ae7a023          	sw	a4,160(a5)

8000ac00 <.L20>:
    }
    ptr->IPCMD = femc_make_cmd(cmd->opcode);
8000ac00:	4792                	lw	a5,4(sp)
8000ac02:	439c                	lw	a5,0(a5)
8000ac04:	853e                	mv	a0,a5
8000ac06:	3751                	jal	8000ab8a <femc_make_cmd>
8000ac08:	872a                	mv	a4,a0
8000ac0a:	47b2                	lw	a5,12(sp)
8000ac0c:	08e7ae23          	sw	a4,156(a5)

    if (femc_ip_cmd_done(ptr) != status_success) {
8000ac10:	4532                	lw	a0,12(sp)
8000ac12:	641020ef          	jal	8000da52 <femc_ip_cmd_done>
8000ac16:	87aa                	mv	a5,a0
8000ac18:	c789                	beqz	a5,8000ac22 <.L21>
        return status_femc_cmd_err;
8000ac1a:	6789                	lui	a5,0x2
8000ac1c:	32978793          	add	a5,a5,809 # 2329 <__APB_SRAM_segment_size__+0x329>
8000ac20:	a811                	j	8000ac34 <.L22>

8000ac22 <.L21>:
    }

    if (read_data) {
8000ac22:	01f14783          	lbu	a5,31(sp)
8000ac26:	c791                	beqz	a5,8000ac32 <.L23>
        cmd->data = ptr->IPRX;
8000ac28:	47b2                	lw	a5,12(sp)
8000ac2a:	0b07a703          	lw	a4,176(a5)
8000ac2e:	4792                	lw	a5,4(sp)
8000ac30:	c3d8                	sw	a4,4(a5)

8000ac32 <.L23>:
    }
    return status_success;
8000ac32:	4781                	li	a5,0

8000ac34 <.L22>:
}
8000ac34:	853e                	mv	a0,a5
8000ac36:	50b2                	lw	ra,44(sp)
8000ac38:	6145                	add	sp,sp,48
8000ac3a:	8082                	ret

Disassembly of section .text.femc_default_config:

8000ac3c <femc_default_config>:

void femc_default_config(FEMC_Type *ptr, femc_config_t *config)
{
8000ac3c:	1101                	add	sp,sp,-32
8000ac3e:	c62a                	sw	a0,12(sp)
8000ac40:	c42e                	sw	a1,8(sp)
    (void) ptr;
    femc_axi_q_weight_t *q;
    config->dqs = FEMC_DQS_FROM_PAD;
8000ac42:	47a2                	lw	a5,8(sp)
8000ac44:	4705                	li	a4,1
8000ac46:	00e78023          	sb	a4,0(a5)
    config->cmd_timeout = 0;
8000ac4a:	47a2                	lw	a5,8(sp)
8000ac4c:	000780a3          	sb	zero,1(a5)
    config->bus_timeout = 0x10;
8000ac50:	47a2                	lw	a5,8(sp)
8000ac52:	4741                	li	a4,16
8000ac54:	00e78123          	sb	a4,2(a5)
    q = &config->axi_q_weight[FEMC_AXI_Q_A];
8000ac58:	47a2                	lw	a5,8(sp)
8000ac5a:	078d                	add	a5,a5,3
8000ac5c:	ce3e                	sw	a5,28(sp)
    q->enable = true;
8000ac5e:	47f2                	lw	a5,28(sp)
8000ac60:	4705                	li	a4,1
8000ac62:	00e78023          	sb	a4,0(a5)
    q->qos = 4;
8000ac66:	47f2                	lw	a5,28(sp)
8000ac68:	4711                	li	a4,4
8000ac6a:	00e780a3          	sb	a4,1(a5)
    q->age = 2;
8000ac6e:	47f2                	lw	a5,28(sp)
8000ac70:	4709                	li	a4,2
8000ac72:	00e78123          	sb	a4,2(a5)
    q->slave_hit = 0x5;
8000ac76:	47f2                	lw	a5,28(sp)
8000ac78:	4715                	li	a4,5
8000ac7a:	00e78223          	sb	a4,4(a5)
    q->slave_hit_wo_rw = 0x3;
8000ac7e:	47f2                	lw	a5,28(sp)
8000ac80:	470d                	li	a4,3
8000ac82:	00e781a3          	sb	a4,3(a5)

    q = &config->axi_q_weight[FEMC_AXI_Q_B];
8000ac86:	47a2                	lw	a5,8(sp)
8000ac88:	07a9                	add	a5,a5,10
8000ac8a:	ce3e                	sw	a5,28(sp)
    q->enable = true;
8000ac8c:	47f2                	lw	a5,28(sp)
8000ac8e:	4705                	li	a4,1
8000ac90:	00e78023          	sb	a4,0(a5)
    q->qos = 4;
8000ac94:	47f2                	lw	a5,28(sp)
8000ac96:	4711                	li	a4,4
8000ac98:	00e780a3          	sb	a4,1(a5)
    q->age = 2;
8000ac9c:	47f2                	lw	a5,28(sp)
8000ac9e:	4709                	li	a4,2
8000aca0:	00e78123          	sb	a4,2(a5)
    q->page_hit = 0x5;
8000aca4:	47f2                	lw	a5,28(sp)
8000aca6:	4715                	li	a4,5
8000aca8:	00e782a3          	sb	a4,5(a5)
    q->slave_hit_wo_rw = 0x3;
8000acac:	47f2                	lw	a5,28(sp)
8000acae:	470d                	li	a4,3
8000acb0:	00e781a3          	sb	a4,3(a5)
    q->bank_rotation = 0x6;
8000acb4:	47f2                	lw	a5,28(sp)
8000acb6:	4719                	li	a4,6
8000acb8:	00e78323          	sb	a4,6(a5)
}
8000acbc:	0001                	nop
8000acbe:	6105                	add	sp,sp,32
8000acc0:	8082                	ret

Disassembly of section .text.femc_init:

8000acc2 <femc_init>:
    config->cmd_data_width = 4;
    config->auto_refresh_cmd_count = 8;
}

void femc_init(FEMC_Type *ptr, femc_config_t *config)
{
8000acc2:	7179                	add	sp,sp,-48
8000acc4:	d606                	sw	ra,44(sp)
8000acc6:	c62a                	sw	a0,12(sp)
8000acc8:	c42e                	sw	a1,8(sp)
    femc_axi_q_weight_t *q;

    ptr->BR[FEMC_BR_BASE0] = 0;
8000acca:	47b2                	lw	a5,12(sp)
8000accc:	0007a823          	sw	zero,16(a5)
    ptr->BR[FEMC_BR_BASE1] = 0;
8000acd0:	47b2                	lw	a5,12(sp)
8000acd2:	0007aa23          	sw	zero,20(a5)
    ptr->BR[FEMC_BR_BASE6] = 0;
8000acd6:	47b2                	lw	a5,12(sp)
8000acd8:	0207a423          	sw	zero,40(a5)
#if defined (HPM_IP_FEATURE_FEMC_SRAM_CS1_CS2) && HPM_IP_FEATURE_FEMC_SRAM_CS1_CS2
    ptr->BR2[FEMC_BR2_BASE0] = 0;
    ptr->BR2[FEMC_BR2_BASE1] = 0;
#endif
    femc_sw_reset(ptr);
8000acdc:	4532                	lw	a0,12(sp)
8000acde:	4f9020ef          	jal	8000d9d6 <femc_sw_reset>
    femc_disable(ptr);
8000ace2:	4532                	lw	a0,12(sp)
8000ace4:	3551                	jal	8000ab68 <femc_disable>
    ptr->CTRL |= FEMC_CTRL_BTO_SET(config->bus_timeout)
8000ace6:	47b2                	lw	a5,12(sp)
8000ace8:	4398                	lw	a4,0(a5)
8000acea:	47a2                	lw	a5,8(sp)
8000acec:	0027c783          	lbu	a5,2(a5)
8000acf0:	01879693          	sll	a3,a5,0x18
8000acf4:	1f0007b7          	lui	a5,0x1f000
8000acf8:	8efd                	and	a3,a3,a5
        | FEMC_CTRL_CTO_SET(config->cmd_timeout)
8000acfa:	47a2                	lw	a5,8(sp)
8000acfc:	0017c783          	lbu	a5,1(a5) # 1f000001 <__SHARE_RAM_segment_end__+0x1de80001>
8000ad00:	01079613          	sll	a2,a5,0x10
8000ad04:	00ff07b7          	lui	a5,0xff0
8000ad08:	8ff1                	and	a5,a5,a2
8000ad0a:	8edd                	or	a3,a3,a5
        | FEMC_CTRL_DQS_SET(config->dqs);
8000ad0c:	47a2                	lw	a5,8(sp)
8000ad0e:	0007c783          	lbu	a5,0(a5) # ff0000 <__SDRAM_segment_size__+0x3f0000>
8000ad12:	078a                	sll	a5,a5,0x2
8000ad14:	8b91                	and	a5,a5,4
8000ad16:	8fd5                	or	a5,a5,a3
    ptr->CTRL |= FEMC_CTRL_BTO_SET(config->bus_timeout)
8000ad18:	8f5d                	or	a4,a4,a5
8000ad1a:	47b2                	lw	a5,12(sp)
8000ad1c:	c398                	sw	a4,0(a5)

    q = &config->axi_q_weight[FEMC_AXI_Q_A];
8000ad1e:	47a2                	lw	a5,8(sp)
8000ad20:	078d                	add	a5,a5,3
8000ad22:	ce3e                	sw	a5,28(sp)
    if (q->enable) {
8000ad24:	47f2                	lw	a5,28(sp)
8000ad26:	0007c783          	lbu	a5,0(a5)
8000ad2a:	c3b1                	beqz	a5,8000ad6e <.L27>
        ptr->BMW0 = FEMC_BMW0_QOS_SET(q->qos)
8000ad2c:	47f2                	lw	a5,28(sp)
8000ad2e:	0017c783          	lbu	a5,1(a5)
8000ad32:	00f7f713          	and	a4,a5,15
            | FEMC_BMW0_AGE_SET(q->age)
8000ad36:	47f2                	lw	a5,28(sp)
8000ad38:	0027c783          	lbu	a5,2(a5)
8000ad3c:	0792                	sll	a5,a5,0x4
8000ad3e:	0ff7f793          	zext.b	a5,a5
8000ad42:	8f5d                	or	a4,a4,a5
            | FEMC_BMW0_SH_SET(q->slave_hit)
8000ad44:	47f2                	lw	a5,28(sp)
8000ad46:	0047c783          	lbu	a5,4(a5)
8000ad4a:	00879693          	sll	a3,a5,0x8
8000ad4e:	67c1                	lui	a5,0x10
8000ad50:	17fd                	add	a5,a5,-1 # ffff <__FLASH_segment_used_size__+0x1b37>
8000ad52:	8ff5                	and	a5,a5,a3
8000ad54:	8f5d                	or	a4,a4,a5
            | FEMC_BMW0_RWS_SET(q->slave_hit_wo_rw);
8000ad56:	47f2                	lw	a5,28(sp)
8000ad58:	0037c783          	lbu	a5,3(a5)
8000ad5c:	01079693          	sll	a3,a5,0x10
8000ad60:	00ff07b7          	lui	a5,0xff0
8000ad64:	8ff5                	and	a5,a5,a3
8000ad66:	8f5d                	or	a4,a4,a5
        ptr->BMW0 = FEMC_BMW0_QOS_SET(q->qos)
8000ad68:	47b2                	lw	a5,12(sp)
8000ad6a:	c798                	sw	a4,8(a5)
8000ad6c:	a021                	j	8000ad74 <.L28>

8000ad6e <.L27>:
    } else {
        ptr->BMW0 = 0;
8000ad6e:	47b2                	lw	a5,12(sp)
8000ad70:	0007a423          	sw	zero,8(a5) # ff0008 <__SDRAM_segment_size__+0x3f0008>

8000ad74 <.L28>:
    }

    q = &config->axi_q_weight[FEMC_AXI_Q_B];
8000ad74:	47a2                	lw	a5,8(sp)
8000ad76:	07a9                	add	a5,a5,10
8000ad78:	ce3e                	sw	a5,28(sp)
    if (q->enable) {
8000ad7a:	47f2                	lw	a5,28(sp)
8000ad7c:	0007c783          	lbu	a5,0(a5)
8000ad80:	c7b9                	beqz	a5,8000adce <.L29>
        ptr->BMW1 = FEMC_BMW1_QOS_SET(q->qos)
8000ad82:	47f2                	lw	a5,28(sp)
8000ad84:	0017c783          	lbu	a5,1(a5)
8000ad88:	00f7f713          	and	a4,a5,15
            | FEMC_BMW1_AGE_SET(q->age)
8000ad8c:	47f2                	lw	a5,28(sp)
8000ad8e:	0027c783          	lbu	a5,2(a5)
8000ad92:	0792                	sll	a5,a5,0x4
8000ad94:	0ff7f793          	zext.b	a5,a5
8000ad98:	8f5d                	or	a4,a4,a5
            | FEMC_BMW1_PH_SET(q->page_hit)
8000ad9a:	47f2                	lw	a5,28(sp)
8000ad9c:	0057c783          	lbu	a5,5(a5)
8000ada0:	00879693          	sll	a3,a5,0x8
8000ada4:	67c1                	lui	a5,0x10
8000ada6:	17fd                	add	a5,a5,-1 # ffff <__FLASH_segment_used_size__+0x1b37>
8000ada8:	8ff5                	and	a5,a5,a3
8000adaa:	8f5d                	or	a4,a4,a5
            | FEMC_BMW1_BR_SET(q->bank_rotation)
8000adac:	47f2                	lw	a5,28(sp)
8000adae:	0067c783          	lbu	a5,6(a5)
8000adb2:	07e2                	sll	a5,a5,0x18
8000adb4:	8f5d                	or	a4,a4,a5
            | FEMC_BMW1_RWS_SET(q->slave_hit_wo_rw);
8000adb6:	47f2                	lw	a5,28(sp)
8000adb8:	0037c783          	lbu	a5,3(a5)
8000adbc:	01079693          	sll	a3,a5,0x10
8000adc0:	00ff07b7          	lui	a5,0xff0
8000adc4:	8ff5                	and	a5,a5,a3
8000adc6:	8f5d                	or	a4,a4,a5
        ptr->BMW1 = FEMC_BMW1_QOS_SET(q->qos)
8000adc8:	47b2                	lw	a5,12(sp)
8000adca:	c7d8                	sw	a4,12(a5)
8000adcc:	a021                	j	8000add4 <.L30>

8000adce <.L29>:
    } else {
        ptr->BMW1 = 0;
8000adce:	47b2                	lw	a5,12(sp)
8000add0:	0007a623          	sw	zero,12(a5) # ff000c <__SDRAM_segment_size__+0x3f000c>

8000add4 <.L30>:
    }

    femc_enable(ptr);
8000add4:	4532                	lw	a0,12(sp)
8000add6:	3bb5                	jal	8000ab52 <femc_enable>
}
8000add8:	0001                	nop
8000adda:	50b2                	lw	ra,44(sp)
8000addc:	6145                	add	sp,sp,48
8000adde:	8082                	ret

Disassembly of section .text.femc_convert_actual_size_to_memory_size:

8000ade0 <femc_convert_actual_size_to_memory_size>:

static uint8_t femc_convert_actual_size_to_memory_size(uint32_t size_in_kb)
{
8000ade0:	1101                	add	sp,sp,-32
8000ade2:	c62a                	sw	a0,12(sp)
    uint8_t size = 0;
8000ade4:	00010fa3          	sb	zero,31(sp)
    if (size_in_kb == 4) {
8000ade8:	4732                	lw	a4,12(sp)
8000adea:	4791                	li	a5,4
8000adec:	00f71463          	bne	a4,a5,8000adf4 <.L32>
        return 0;
8000adf0:	4781                	li	a5,0
8000adf2:	a82d                	j	8000ae2c <.L33>

8000adf4 <.L32>:
    }

    if (size_in_kb > 2 * 1 << 20) {
8000adf4:	4732                	lw	a4,12(sp)
8000adf6:	002007b7          	lui	a5,0x200
8000adfa:	00e7f463          	bgeu	a5,a4,8000ae02 <.L34>
        return 0x1F;
8000adfe:	47fd                	li	a5,31
8000ae00:	a035                	j	8000ae2c <.L33>

8000ae02 <.L34>:
    }

    size = 1;
8000ae02:	4785                	li	a5,1
8000ae04:	00f10fa3          	sb	a5,31(sp)
    size_in_kb >>= 3;
8000ae08:	47b2                	lw	a5,12(sp)
8000ae0a:	838d                	srl	a5,a5,0x3
8000ae0c:	c63e                	sw	a5,12(sp)
    while (size_in_kb > 1) {
8000ae0e:	a809                	j	8000ae20 <.L35>

8000ae10 <.L36>:
        size_in_kb >>= 1;
8000ae10:	47b2                	lw	a5,12(sp)
8000ae12:	8385                	srl	a5,a5,0x1
8000ae14:	c63e                	sw	a5,12(sp)
        size++;
8000ae16:	01f14783          	lbu	a5,31(sp)
8000ae1a:	0785                	add	a5,a5,1 # 200001 <__AXI_SRAM_segment_size__+0x140001>
8000ae1c:	00f10fa3          	sb	a5,31(sp)

8000ae20 <.L35>:
    while (size_in_kb > 1) {
8000ae20:	4732                	lw	a4,12(sp)
8000ae22:	4785                	li	a5,1
8000ae24:	fee7e6e3          	bltu	a5,a4,8000ae10 <.L36>
    }
    return size;
8000ae28:	01f14783          	lbu	a5,31(sp)

8000ae2c <.L33>:
}
8000ae2c:	853e                	mv	a0,a5
8000ae2e:	6105                	add	sp,sp,32
8000ae30:	8082                	ret

Disassembly of section .text.ns2cycle:

8000ae32 <ns2cycle>:
        return FEMC_SDRAM_MAX_BURST_LENGTH_IN_BYTE + 1;
    }
}

static uint32_t ns2cycle(uint32_t freq_in_hz, uint32_t ns, uint32_t max_cycle)
{
8000ae32:	1101                	add	sp,sp,-32
8000ae34:	c62a                	sw	a0,12(sp)
8000ae36:	c42e                	sw	a1,8(sp)
8000ae38:	c232                	sw	a2,4(sp)
    uint32_t ns_per_cycle;
    uint32_t cycle;

    ns_per_cycle = 1000000000 / freq_in_hz;
8000ae3a:	3b9ad7b7          	lui	a5,0x3b9ad
8000ae3e:	a0078713          	add	a4,a5,-1536 # 3b9aca00 <__SHARE_RAM_segment_end__+0x3a82ca00>
8000ae42:	47b2                	lw	a5,12(sp)
8000ae44:	02f757b3          	divu	a5,a4,a5
8000ae48:	cc3e                	sw	a5,24(sp)
    cycle = ns / ns_per_cycle;
8000ae4a:	4722                	lw	a4,8(sp)
8000ae4c:	47e2                	lw	a5,24(sp)
8000ae4e:	02f757b3          	divu	a5,a4,a5
8000ae52:	ce3e                	sw	a5,28(sp)
    if (cycle > max_cycle) {
8000ae54:	4772                	lw	a4,28(sp)
8000ae56:	4792                	lw	a5,4(sp)
8000ae58:	00e7f463          	bgeu	a5,a4,8000ae60 <.L46>
        cycle = max_cycle;
8000ae5c:	4792                	lw	a5,4(sp)
8000ae5e:	ce3e                	sw	a5,28(sp)

8000ae60 <.L46>:
    }
    return cycle;
8000ae60:	47f2                	lw	a5,28(sp)
}
8000ae62:	853e                	mv	a0,a5
8000ae64:	6105                	add	sp,sp,32
8000ae66:	8082                	ret

Disassembly of section .text.pllctl_pll_poweron:

8000ae68 <pllctl_pll_poweron>:
{
8000ae68:	1101                	add	sp,sp,-32
8000ae6a:	c62a                	sw	a0,12(sp)
8000ae6c:	87ae                	mv	a5,a1
8000ae6e:	00f105a3          	sb	a5,11(sp)
    if (pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1)) {
8000ae72:	00b14703          	lbu	a4,11(sp)
8000ae76:	4791                	li	a5,4
8000ae78:	00e7f463          	bgeu	a5,a4,8000ae80 <.L8>
        return status_invalid_argument;
8000ae7c:	4789                	li	a5,2
8000ae7e:	a849                	j	8000af10 <.L9>

8000ae80 <.L8>:
    cfg = ptr->PLL[pll].CFG1;
8000ae80:	00b14783          	lbu	a5,11(sp)
8000ae84:	4732                	lw	a4,12(sp)
8000ae86:	0785                	add	a5,a5,1
8000ae88:	079e                	sll	a5,a5,0x7
8000ae8a:	97ba                	add	a5,a5,a4
8000ae8c:	43dc                	lw	a5,4(a5)
8000ae8e:	ce3e                	sw	a5,28(sp)
    if (!(cfg & PLLCTL_PLL_CFG1_PLLPD_SW_MASK)) {
8000ae90:	4772                	lw	a4,28(sp)
8000ae92:	020007b7          	lui	a5,0x2000
8000ae96:	8ff9                	and	a5,a5,a4
8000ae98:	e399                	bnez	a5,8000ae9e <.L10>
        return status_success;
8000ae9a:	4781                	li	a5,0
8000ae9c:	a895                	j	8000af10 <.L9>

8000ae9e <.L10>:
    if (cfg & PLLCTL_PLL_CFG1_PLLCTRL_HW_EN_MASK) {
8000ae9e:	47f2                	lw	a5,28(sp)
8000aea0:	0207d463          	bgez	a5,8000aec8 <.L11>
        ptr->PLL[pll].CFG1 &= ~PLLCTL_PLL_CFG1_PLLCTRL_HW_EN_MASK;
8000aea4:	00b14783          	lbu	a5,11(sp)
8000aea8:	4732                	lw	a4,12(sp)
8000aeaa:	0785                	add	a5,a5,1 # 2000001 <__SHARE_RAM_segment_end__+0xe80001>
8000aeac:	079e                	sll	a5,a5,0x7
8000aeae:	97ba                	add	a5,a5,a4
8000aeb0:	43d4                	lw	a3,4(a5)
8000aeb2:	00b14783          	lbu	a5,11(sp)
8000aeb6:	80000737          	lui	a4,0x80000
8000aeba:	177d                	add	a4,a4,-1 # 7fffffff <__NONCACHEABLE_RAM_segment_end__+0x3effffff>
8000aebc:	8f75                	and	a4,a4,a3
8000aebe:	46b2                	lw	a3,12(sp)
8000aec0:	0785                	add	a5,a5,1
8000aec2:	079e                	sll	a5,a5,0x7
8000aec4:	97b6                	add	a5,a5,a3
8000aec6:	c3d8                	sw	a4,4(a5)

8000aec8 <.L11>:
    ptr->PLL[pll].CFG1 &= ~PLLCTL_PLL_CFG1_PLLPD_SW_MASK;
8000aec8:	00b14783          	lbu	a5,11(sp)
8000aecc:	4732                	lw	a4,12(sp)
8000aece:	0785                	add	a5,a5,1
8000aed0:	079e                	sll	a5,a5,0x7
8000aed2:	97ba                	add	a5,a5,a4
8000aed4:	43d4                	lw	a3,4(a5)
8000aed6:	00b14783          	lbu	a5,11(sp)
8000aeda:	fe000737          	lui	a4,0xfe000
8000aede:	177d                	add	a4,a4,-1 # fdffffff <__APB_SRAM_segment_end__+0x9f0dfff>
8000aee0:	8f75                	and	a4,a4,a3
8000aee2:	46b2                	lw	a3,12(sp)
8000aee4:	0785                	add	a5,a5,1
8000aee6:	079e                	sll	a5,a5,0x7
8000aee8:	97b6                	add	a5,a5,a3
8000aeea:	c3d8                	sw	a4,4(a5)
    ptr->PLL[pll].CFG1 |= PLLCTL_PLL_CFG1_PLLCTRL_HW_EN_MASK;
8000aeec:	00b14783          	lbu	a5,11(sp)
8000aef0:	4732                	lw	a4,12(sp)
8000aef2:	0785                	add	a5,a5,1
8000aef4:	079e                	sll	a5,a5,0x7
8000aef6:	97ba                	add	a5,a5,a4
8000aef8:	43d4                	lw	a3,4(a5)
8000aefa:	00b14783          	lbu	a5,11(sp)
8000aefe:	80000737          	lui	a4,0x80000
8000af02:	8f55                	or	a4,a4,a3
8000af04:	46b2                	lw	a3,12(sp)
8000af06:	0785                	add	a5,a5,1
8000af08:	079e                	sll	a5,a5,0x7
8000af0a:	97b6                	add	a5,a5,a3
8000af0c:	c3d8                	sw	a4,4(a5)
    return status_success;
8000af0e:	4781                	li	a5,0

8000af10 <.L9>:
}
8000af10:	853e                	mv	a0,a5
8000af12:	6105                	add	sp,sp,32
8000af14:	8082                	ret

Disassembly of section .text.read_pmp_cfg:

8000af16 <read_pmp_cfg>:

#define PMP_ENTRY_MAX 16
#define PMA_ENTRY_MAX 16

uint32_t read_pmp_cfg(uint32_t idx)
{
8000af16:	7179                	add	sp,sp,-48
8000af18:	c62a                	sw	a0,12(sp)
    uint32_t pmp_cfg = 0;
8000af1a:	d602                	sw	zero,44(sp)
    switch (idx) {
8000af1c:	4732                	lw	a4,12(sp)
8000af1e:	478d                	li	a5,3
8000af20:	04f70763          	beq	a4,a5,8000af6e <.L2>
8000af24:	4732                	lw	a4,12(sp)
8000af26:	478d                	li	a5,3
8000af28:	04e7e963          	bltu	a5,a4,8000af7a <.L9>
8000af2c:	4732                	lw	a4,12(sp)
8000af2e:	4789                	li	a5,2
8000af30:	02f70963          	beq	a4,a5,8000af62 <.L4>
8000af34:	4732                	lw	a4,12(sp)
8000af36:	4789                	li	a5,2
8000af38:	04e7e163          	bltu	a5,a4,8000af7a <.L9>
8000af3c:	47b2                	lw	a5,12(sp)
8000af3e:	c791                	beqz	a5,8000af4a <.L5>
8000af40:	4732                	lw	a4,12(sp)
8000af42:	4785                	li	a5,1
8000af44:	00f70963          	beq	a4,a5,8000af56 <.L6>
    case 3:
        pmp_cfg = read_csr(CSR_PMPCFG3);
        break;
    default:
        /* Do nothing */
        break;
8000af48:	a80d                	j	8000af7a <.L9>

8000af4a <.L5>:
        pmp_cfg = read_csr(CSR_PMPCFG0);
8000af4a:	3a0027f3          	csrr	a5,pmpcfg0
8000af4e:	ce3e                	sw	a5,28(sp)
8000af50:	47f2                	lw	a5,28(sp)

8000af52 <.LBE2>:
8000af52:	d63e                	sw	a5,44(sp)
        break;
8000af54:	a025                	j	8000af7c <.L7>

8000af56 <.L6>:
        pmp_cfg = read_csr(CSR_PMPCFG1);
8000af56:	3a1027f3          	csrr	a5,pmpcfg1
8000af5a:	d03e                	sw	a5,32(sp)
8000af5c:	5782                	lw	a5,32(sp)

8000af5e <.LBE3>:
8000af5e:	d63e                	sw	a5,44(sp)
        break;
8000af60:	a831                	j	8000af7c <.L7>

8000af62 <.L4>:
        pmp_cfg = read_csr(CSR_PMPCFG2);
8000af62:	3a2027f3          	csrr	a5,pmpcfg2
8000af66:	d23e                	sw	a5,36(sp)
8000af68:	5792                	lw	a5,36(sp)

8000af6a <.LBE4>:
8000af6a:	d63e                	sw	a5,44(sp)
        break;
8000af6c:	a801                	j	8000af7c <.L7>

8000af6e <.L2>:
        pmp_cfg = read_csr(CSR_PMPCFG3);
8000af6e:	3a3027f3          	csrr	a5,pmpcfg3
8000af72:	d43e                	sw	a5,40(sp)
8000af74:	57a2                	lw	a5,40(sp)

8000af76 <.LBE5>:
8000af76:	d63e                	sw	a5,44(sp)
        break;
8000af78:	a011                	j	8000af7c <.L7>

8000af7a <.L9>:
        break;
8000af7a:	0001                	nop

8000af7c <.L7>:
    }
    return pmp_cfg;
8000af7c:	57b2                	lw	a5,44(sp)
}
8000af7e:	853e                	mv	a0,a5
8000af80:	6145                	add	sp,sp,48
8000af82:	8082                	ret

Disassembly of section .text.write_pmp_addr:

8000af84 <write_pmp_addr>:
        break;
    }
}

void write_pmp_addr(uint32_t value, uint32_t idx)
{
8000af84:	1141                	add	sp,sp,-16
8000af86:	c62a                	sw	a0,12(sp)
8000af88:	c42e                	sw	a1,8(sp)
    switch (idx) {
8000af8a:	4722                	lw	a4,8(sp)
8000af8c:	47bd                	li	a5,15
8000af8e:	08e7ec63          	bltu	a5,a4,8000b026 <.L38>
8000af92:	47a2                	lw	a5,8(sp)
8000af94:	00279713          	sll	a4,a5,0x2
8000af98:	800037b7          	lui	a5,0x80003
8000af9c:	1d478793          	add	a5,a5,468 # 800031d4 <.L21>
8000afa0:	97ba                	add	a5,a5,a4
8000afa2:	439c                	lw	a5,0(a5)
8000afa4:	8782                	jr	a5

8000afa6 <.L36>:
    case 0:
        write_csr(CSR_PMPADDR0, value);
8000afa6:	47b2                	lw	a5,12(sp)
8000afa8:	3b079073          	csrw	pmpaddr0,a5
        break;
8000afac:	a8b5                	j	8000b028 <.L37>

8000afae <.L35>:
    case 1:
        write_csr(CSR_PMPADDR1, value);
8000afae:	47b2                	lw	a5,12(sp)
8000afb0:	3b179073          	csrw	pmpaddr1,a5
        break;
8000afb4:	a895                	j	8000b028 <.L37>

8000afb6 <.L34>:
    case 2:
        write_csr(CSR_PMPADDR2, value);
8000afb6:	47b2                	lw	a5,12(sp)
8000afb8:	3b279073          	csrw	pmpaddr2,a5
        break;
8000afbc:	a0b5                	j	8000b028 <.L37>

8000afbe <.L33>:
    case 3:
        write_csr(CSR_PMPADDR3, value);
8000afbe:	47b2                	lw	a5,12(sp)
8000afc0:	3b379073          	csrw	pmpaddr3,a5
        break;
8000afc4:	a095                	j	8000b028 <.L37>

8000afc6 <.L32>:
    case 4:
        write_csr(CSR_PMPADDR4, value);
8000afc6:	47b2                	lw	a5,12(sp)
8000afc8:	3b479073          	csrw	pmpaddr4,a5
        break;
8000afcc:	a8b1                	j	8000b028 <.L37>

8000afce <.L31>:
    case 5:
        write_csr(CSR_PMPADDR5, value);
8000afce:	47b2                	lw	a5,12(sp)
8000afd0:	3b579073          	csrw	pmpaddr5,a5
        break;
8000afd4:	a891                	j	8000b028 <.L37>

8000afd6 <.L30>:
    case 6:
        write_csr(CSR_PMPADDR6, value);
8000afd6:	47b2                	lw	a5,12(sp)
8000afd8:	3b679073          	csrw	pmpaddr6,a5
        break;
8000afdc:	a0b1                	j	8000b028 <.L37>

8000afde <.L29>:
    case 7:
        write_csr(CSR_PMPADDR7, value);
8000afde:	47b2                	lw	a5,12(sp)
8000afe0:	3b779073          	csrw	pmpaddr7,a5
        break;
8000afe4:	a091                	j	8000b028 <.L37>

8000afe6 <.L28>:
    case 8:
        write_csr(CSR_PMPADDR8, value);
8000afe6:	47b2                	lw	a5,12(sp)
8000afe8:	3b879073          	csrw	pmpaddr8,a5
        break;
8000afec:	a835                	j	8000b028 <.L37>

8000afee <.L27>:
    case 9:
        write_csr(CSR_PMPADDR9, value);
8000afee:	47b2                	lw	a5,12(sp)
8000aff0:	3b979073          	csrw	pmpaddr9,a5
        break;
8000aff4:	a815                	j	8000b028 <.L37>

8000aff6 <.L26>:
    case 10:
        write_csr(CSR_PMPADDR10, value);
8000aff6:	47b2                	lw	a5,12(sp)
8000aff8:	3ba79073          	csrw	pmpaddr10,a5
        break;
8000affc:	a035                	j	8000b028 <.L37>

8000affe <.L25>:
    case 11:
        write_csr(CSR_PMPADDR11, value);
8000affe:	47b2                	lw	a5,12(sp)
8000b000:	3bb79073          	csrw	pmpaddr11,a5
        break;
8000b004:	a015                	j	8000b028 <.L37>

8000b006 <.L24>:
    case 12:
        write_csr(CSR_PMPADDR12, value);
8000b006:	47b2                	lw	a5,12(sp)
8000b008:	3bc79073          	csrw	pmpaddr12,a5
        break;
8000b00c:	a831                	j	8000b028 <.L37>

8000b00e <.L23>:
    case 13:
        write_csr(CSR_PMPADDR13, value);
8000b00e:	47b2                	lw	a5,12(sp)
8000b010:	3bd79073          	csrw	pmpaddr13,a5
        break;
8000b014:	a811                	j	8000b028 <.L37>

8000b016 <.L22>:
    case 14:
        write_csr(CSR_PMPADDR14, value);
8000b016:	47b2                	lw	a5,12(sp)
8000b018:	3be79073          	csrw	pmpaddr14,a5
        break;
8000b01c:	a031                	j	8000b028 <.L37>

8000b01e <.L20>:
    case 15:
        write_csr(CSR_PMPADDR15, value);
8000b01e:	47b2                	lw	a5,12(sp)
8000b020:	3bf79073          	csrw	pmpaddr15,a5
        break;
8000b024:	a011                	j	8000b028 <.L37>

8000b026 <.L38>:
    default:
        /* Do nothing */
        break;
8000b026:	0001                	nop

8000b028 <.L37>:
    }
}
8000b028:	0001                	nop
8000b02a:	0141                	add	sp,sp,16
8000b02c:	8082                	ret

Disassembly of section .text.read_pma_cfg:

8000b02e <read_pma_cfg>:
    return status_success;
}

#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
uint32_t read_pma_cfg(uint32_t idx)
{
8000b02e:	7179                	add	sp,sp,-48
8000b030:	c62a                	sw	a0,12(sp)
    uint32_t pma_cfg = 0;
8000b032:	d602                	sw	zero,44(sp)
    switch (idx) {
8000b034:	4732                	lw	a4,12(sp)
8000b036:	478d                	li	a5,3
8000b038:	04f70763          	beq	a4,a5,8000b086 <.L72>
8000b03c:	4732                	lw	a4,12(sp)
8000b03e:	478d                	li	a5,3
8000b040:	04e7e963          	bltu	a5,a4,8000b092 <.L79>
8000b044:	4732                	lw	a4,12(sp)
8000b046:	4789                	li	a5,2
8000b048:	02f70963          	beq	a4,a5,8000b07a <.L74>
8000b04c:	4732                	lw	a4,12(sp)
8000b04e:	4789                	li	a5,2
8000b050:	04e7e163          	bltu	a5,a4,8000b092 <.L79>
8000b054:	47b2                	lw	a5,12(sp)
8000b056:	c791                	beqz	a5,8000b062 <.L75>
8000b058:	4732                	lw	a4,12(sp)
8000b05a:	4785                	li	a5,1
8000b05c:	00f70963          	beq	a4,a5,8000b06e <.L76>
    case 3:
        pma_cfg = read_csr(CSR_PMACFG3);
        break;
    default:
        /* Do nothing */
        break;
8000b060:	a80d                	j	8000b092 <.L79>

8000b062 <.L75>:
        pma_cfg = read_csr(CSR_PMACFG0);
8000b062:	bc0027f3          	csrr	a5,0xbc0
8000b066:	ce3e                	sw	a5,28(sp)
8000b068:	47f2                	lw	a5,28(sp)

8000b06a <.LBE24>:
8000b06a:	d63e                	sw	a5,44(sp)
        break;
8000b06c:	a025                	j	8000b094 <.L77>

8000b06e <.L76>:
        pma_cfg = read_csr(CSR_PMACFG1);
8000b06e:	bc1027f3          	csrr	a5,0xbc1
8000b072:	d03e                	sw	a5,32(sp)
8000b074:	5782                	lw	a5,32(sp)

8000b076 <.LBE25>:
8000b076:	d63e                	sw	a5,44(sp)
        break;
8000b078:	a831                	j	8000b094 <.L77>

8000b07a <.L74>:
        pma_cfg = read_csr(CSR_PMACFG2);
8000b07a:	bc2027f3          	csrr	a5,0xbc2
8000b07e:	d23e                	sw	a5,36(sp)
8000b080:	5792                	lw	a5,36(sp)

8000b082 <.LBE26>:
8000b082:	d63e                	sw	a5,44(sp)
        break;
8000b084:	a801                	j	8000b094 <.L77>

8000b086 <.L72>:
        pma_cfg = read_csr(CSR_PMACFG3);
8000b086:	bc3027f3          	csrr	a5,0xbc3
8000b08a:	d43e                	sw	a5,40(sp)
8000b08c:	57a2                	lw	a5,40(sp)

8000b08e <.LBE27>:
8000b08e:	d63e                	sw	a5,44(sp)
        break;
8000b090:	a011                	j	8000b094 <.L77>

8000b092 <.L79>:
        break;
8000b092:	0001                	nop

8000b094 <.L77>:
    }
    return pma_cfg;
8000b094:	57b2                	lw	a5,44(sp)
}
8000b096:	853e                	mv	a0,a5
8000b098:	6145                	add	sp,sp,48
8000b09a:	8082                	ret

Disassembly of section .text.write_pma_addr:

8000b09c <write_pma_addr>:
        /* Do nothing */
        break;
    }
}
void write_pma_addr(uint32_t value, uint32_t idx)
{
8000b09c:	1141                	add	sp,sp,-16
8000b09e:	c62a                	sw	a0,12(sp)
8000b0a0:	c42e                	sw	a1,8(sp)
    switch (idx) {
8000b0a2:	4722                	lw	a4,8(sp)
8000b0a4:	47bd                	li	a5,15
8000b0a6:	08e7ec63          	bltu	a5,a4,8000b13e <.L108>
8000b0aa:	47a2                	lw	a5,8(sp)
8000b0ac:	00279713          	sll	a4,a5,0x2
8000b0b0:	800037b7          	lui	a5,0x80003
8000b0b4:	21478793          	add	a5,a5,532 # 80003214 <.L91>
8000b0b8:	97ba                	add	a5,a5,a4
8000b0ba:	439c                	lw	a5,0(a5)
8000b0bc:	8782                	jr	a5

8000b0be <.L106>:
    case 0:
        write_csr(CSR_PMAADDR0, value);
8000b0be:	47b2                	lw	a5,12(sp)
8000b0c0:	bd079073          	csrw	0xbd0,a5
        break;
8000b0c4:	a8b5                	j	8000b140 <.L107>

8000b0c6 <.L105>:
    case 1:
        write_csr(CSR_PMAADDR1, value);
8000b0c6:	47b2                	lw	a5,12(sp)
8000b0c8:	bd179073          	csrw	0xbd1,a5
        break;
8000b0cc:	a895                	j	8000b140 <.L107>

8000b0ce <.L104>:
    case 2:
        write_csr(CSR_PMAADDR2, value);
8000b0ce:	47b2                	lw	a5,12(sp)
8000b0d0:	bd279073          	csrw	0xbd2,a5
        break;
8000b0d4:	a0b5                	j	8000b140 <.L107>

8000b0d6 <.L103>:
    case 3:
        write_csr(CSR_PMAADDR3, value);
8000b0d6:	47b2                	lw	a5,12(sp)
8000b0d8:	bd379073          	csrw	0xbd3,a5
        break;
8000b0dc:	a095                	j	8000b140 <.L107>

8000b0de <.L102>:
    case 4:
        write_csr(CSR_PMAADDR4, value);
8000b0de:	47b2                	lw	a5,12(sp)
8000b0e0:	bd479073          	csrw	0xbd4,a5
        break;
8000b0e4:	a8b1                	j	8000b140 <.L107>

8000b0e6 <.L101>:
    case 5:
        write_csr(CSR_PMAADDR5, value);
8000b0e6:	47b2                	lw	a5,12(sp)
8000b0e8:	bd579073          	csrw	0xbd5,a5
        break;
8000b0ec:	a891                	j	8000b140 <.L107>

8000b0ee <.L100>:
    case 6:
        write_csr(CSR_PMAADDR6, value);
8000b0ee:	47b2                	lw	a5,12(sp)
8000b0f0:	bd679073          	csrw	0xbd6,a5
        break;
8000b0f4:	a0b1                	j	8000b140 <.L107>

8000b0f6 <.L99>:
    case 7:
        write_csr(CSR_PMAADDR7, value);
8000b0f6:	47b2                	lw	a5,12(sp)
8000b0f8:	bd779073          	csrw	0xbd7,a5
        break;
8000b0fc:	a091                	j	8000b140 <.L107>

8000b0fe <.L98>:
    case 8:
        write_csr(CSR_PMAADDR8, value);
8000b0fe:	47b2                	lw	a5,12(sp)
8000b100:	bd879073          	csrw	0xbd8,a5
        break;
8000b104:	a835                	j	8000b140 <.L107>

8000b106 <.L97>:
    case 9:
        write_csr(CSR_PMAADDR9, value);
8000b106:	47b2                	lw	a5,12(sp)
8000b108:	bd979073          	csrw	0xbd9,a5
        break;
8000b10c:	a815                	j	8000b140 <.L107>

8000b10e <.L96>:
    case 10:
        write_csr(CSR_PMAADDR10, value);
8000b10e:	47b2                	lw	a5,12(sp)
8000b110:	bda79073          	csrw	0xbda,a5
        break;
8000b114:	a035                	j	8000b140 <.L107>

8000b116 <.L95>:
    case 11:
        write_csr(CSR_PMAADDR11, value);
8000b116:	47b2                	lw	a5,12(sp)
8000b118:	bdb79073          	csrw	0xbdb,a5
        break;
8000b11c:	a015                	j	8000b140 <.L107>

8000b11e <.L94>:
    case 12:
        write_csr(CSR_PMAADDR12, value);
8000b11e:	47b2                	lw	a5,12(sp)
8000b120:	bdc79073          	csrw	0xbdc,a5
        break;
8000b124:	a831                	j	8000b140 <.L107>

8000b126 <.L93>:
    case 13:
        write_csr(CSR_PMAADDR13, value);
8000b126:	47b2                	lw	a5,12(sp)
8000b128:	bdd79073          	csrw	0xbdd,a5
        break;
8000b12c:	a811                	j	8000b140 <.L107>

8000b12e <.L92>:
    case 14:
        write_csr(CSR_PMAADDR14, value);
8000b12e:	47b2                	lw	a5,12(sp)
8000b130:	bde79073          	csrw	0xbde,a5
        break;
8000b134:	a031                	j	8000b140 <.L107>

8000b136 <.L90>:
    case 15:
        write_csr(CSR_PMAADDR15, value);
8000b136:	47b2                	lw	a5,12(sp)
8000b138:	bdf79073          	csrw	0xbdf,a5
        break;
8000b13c:	a011                	j	8000b140 <.L107>

8000b13e <.L108>:
    default:
        /* Do nothing */
        break;
8000b13e:	0001                	nop

8000b140 <.L107>:
    }
}
8000b140:	0001                	nop
8000b142:	0141                	add	sp,sp,16
8000b144:	8082                	ret

Disassembly of section .text.pmp_config:

8000b146 <pmp_config>:

    return status;
}

hpm_stat_t pmp_config(const pmp_entry_t *entry, uint32_t num_of_entries)
{
8000b146:	7139                	add	sp,sp,-64
8000b148:	de06                	sw	ra,60(sp)
8000b14a:	c62a                	sw	a0,12(sp)
8000b14c:	c42e                	sw	a1,8(sp)
    hpm_stat_t status = status_invalid_argument;
8000b14e:	4789                	li	a5,2
8000b150:	d63e                	sw	a5,44(sp)
    do {
        HPM_BREAK_IF((entry == NULL) || (num_of_entries < 1U) || (num_of_entries > 15U));
8000b152:	47b2                	lw	a5,12(sp)
8000b154:	cfcd                	beqz	a5,8000b20e <.L140>
8000b156:	47a2                	lw	a5,8(sp)
8000b158:	cbdd                	beqz	a5,8000b20e <.L140>
8000b15a:	4722                	lw	a4,8(sp)
8000b15c:	47bd                	li	a5,15
8000b15e:	0ae7e863          	bltu	a5,a4,8000b20e <.L140>

8000b162 <.LBB47>:

        for (uint32_t i = 0; i < num_of_entries; i++) {
8000b162:	d402                	sw	zero,40(sp)
8000b164:	a871                	j	8000b200 <.L141>

8000b166 <.L142>:
            uint32_t idx = i / 4;
8000b166:	57a2                	lw	a5,40(sp)
8000b168:	8389                	srl	a5,a5,0x2
8000b16a:	d23e                	sw	a5,36(sp)
            uint32_t offset = (i * 8) & 0x1F;
8000b16c:	57a2                	lw	a5,40(sp)
8000b16e:	078e                	sll	a5,a5,0x3
8000b170:	8be1                	and	a5,a5,24
8000b172:	d03e                	sw	a5,32(sp)
            uint32_t pmp_cfg = read_pmp_cfg(idx);
8000b174:	5512                	lw	a0,36(sp)
8000b176:	3345                	jal	8000af16 <read_pmp_cfg>
8000b178:	ce2a                	sw	a0,28(sp)
            pmp_cfg &= ~(0xFFUL << offset);
8000b17a:	5782                	lw	a5,32(sp)
8000b17c:	0ff00713          	li	a4,255
8000b180:	00f717b3          	sll	a5,a4,a5
8000b184:	fff7c793          	not	a5,a5
8000b188:	4772                	lw	a4,28(sp)
8000b18a:	8ff9                	and	a5,a5,a4
8000b18c:	ce3e                	sw	a5,28(sp)
            pmp_cfg |= ((uint32_t)entry->pmp_cfg.val) << offset;
8000b18e:	47b2                	lw	a5,12(sp)
8000b190:	0007c783          	lbu	a5,0(a5)
8000b194:	873e                	mv	a4,a5
8000b196:	5782                	lw	a5,32(sp)
8000b198:	00f717b3          	sll	a5,a4,a5
8000b19c:	4772                	lw	a4,28(sp)
8000b19e:	8fd9                	or	a5,a5,a4
8000b1a0:	ce3e                	sw	a5,28(sp)
            write_pmp_addr(entry->pmp_addr, i);
8000b1a2:	47b2                	lw	a5,12(sp)
8000b1a4:	43dc                	lw	a5,4(a5)
8000b1a6:	55a2                	lw	a1,40(sp)
8000b1a8:	853e                	mv	a0,a5
8000b1aa:	3be9                	jal	8000af84 <write_pmp_addr>
            write_pmp_cfg(pmp_cfg, idx);
8000b1ac:	5592                	lw	a1,36(sp)
8000b1ae:	4572                	lw	a0,28(sp)
8000b1b0:	24e030ef          	jal	8000e3fe <write_pmp_cfg>
#if (!defined(PMP_SUPPORT_PMA)) || (defined(PMP_SUPPORT_PMA) && (PMP_SUPPORT_PMA == 1))
            uint32_t pma_cfg = read_pma_cfg(idx);
8000b1b4:	5512                	lw	a0,36(sp)
8000b1b6:	3da5                	jal	8000b02e <read_pma_cfg>
8000b1b8:	cc2a                	sw	a0,24(sp)
            pma_cfg &= ~(0xFFUL << offset);
8000b1ba:	5782                	lw	a5,32(sp)
8000b1bc:	0ff00713          	li	a4,255
8000b1c0:	00f717b3          	sll	a5,a4,a5
8000b1c4:	fff7c793          	not	a5,a5
8000b1c8:	4762                	lw	a4,24(sp)
8000b1ca:	8ff9                	and	a5,a5,a4
8000b1cc:	cc3e                	sw	a5,24(sp)
            pma_cfg |= ((uint32_t)entry->pma_cfg.val) << offset;
8000b1ce:	47b2                	lw	a5,12(sp)
8000b1d0:	0087c783          	lbu	a5,8(a5)
8000b1d4:	873e                	mv	a4,a5
8000b1d6:	5782                	lw	a5,32(sp)
8000b1d8:	00f717b3          	sll	a5,a4,a5
8000b1dc:	4762                	lw	a4,24(sp)
8000b1de:	8fd9                	or	a5,a5,a4
8000b1e0:	cc3e                	sw	a5,24(sp)
            write_pma_cfg(pma_cfg, idx);
8000b1e2:	5592                	lw	a1,36(sp)
8000b1e4:	4562                	lw	a0,24(sp)
8000b1e6:	274030ef          	jal	8000e45a <write_pma_cfg>
            write_pma_addr(entry->pma_addr, i);
8000b1ea:	47b2                	lw	a5,12(sp)
8000b1ec:	47dc                	lw	a5,12(a5)
8000b1ee:	55a2                	lw	a1,40(sp)
8000b1f0:	853e                	mv	a0,a5
8000b1f2:	356d                	jal	8000b09c <write_pma_addr>
#endif
            ++entry;
8000b1f4:	47b2                	lw	a5,12(sp)
8000b1f6:	07c1                	add	a5,a5,16
8000b1f8:	c63e                	sw	a5,12(sp)

8000b1fa <.LBE48>:
        for (uint32_t i = 0; i < num_of_entries; i++) {
8000b1fa:	57a2                	lw	a5,40(sp)
8000b1fc:	0785                	add	a5,a5,1
8000b1fe:	d43e                	sw	a5,40(sp)

8000b200 <.L141>:
8000b200:	5722                	lw	a4,40(sp)
8000b202:	47a2                	lw	a5,8(sp)
8000b204:	f6f761e3          	bltu	a4,a5,8000b166 <.L142>

8000b208 <.LBE47>:
        }
        fencei();
8000b208:	0000100f          	fence.i

        status = status_success;
8000b20c:	d602                	sw	zero,44(sp)

8000b20e <.L140>:

    } while (false);

    return status;
8000b20e:	57b2                	lw	a5,44(sp)
}
8000b210:	853e                	mv	a0,a5
8000b212:	50f2                	lw	ra,60(sp)
8000b214:	6121                	add	sp,sp,64
8000b216:	8082                	ret

Disassembly of section .text.uart_default_config:

8000b218 <uart_default_config>:
#endif

#define HPM_UART_BAUDRATE_SCALE (1000U)

void uart_default_config(UART_Type *ptr, uart_config_t *config)
{
8000b218:	1141                	add	sp,sp,-16
8000b21a:	c62a                	sw	a0,12(sp)
8000b21c:	c42e                	sw	a1,8(sp)
    (void) ptr;
    config->baudrate = 115200;
8000b21e:	47a2                	lw	a5,8(sp)
8000b220:	6771                	lui	a4,0x1c
8000b222:	20070713          	add	a4,a4,512 # 1c200 <__FLASH_segment_used_size__+0xdd38>
8000b226:	c3d8                	sw	a4,4(a5)
    config->word_length = word_length_8_bits;
8000b228:	47a2                	lw	a5,8(sp)
8000b22a:	470d                	li	a4,3
8000b22c:	00e784a3          	sb	a4,9(a5)
    config->parity = parity_none;
8000b230:	47a2                	lw	a5,8(sp)
8000b232:	00078523          	sb	zero,10(a5)
    config->num_of_stop_bits = stop_bits_1;
8000b236:	47a2                	lw	a5,8(sp)
8000b238:	00078423          	sb	zero,8(a5)
    config->fifo_enable = true;
8000b23c:	47a2                	lw	a5,8(sp)
8000b23e:	4705                	li	a4,1
8000b240:	00e78723          	sb	a4,14(a5)
    config->rx_fifo_level = uart_rx_fifo_trg_not_empty;
8000b244:	47a2                	lw	a5,8(sp)
8000b246:	00078623          	sb	zero,12(a5)
    config->tx_fifo_level = uart_tx_fifo_trg_not_full;
8000b24a:	47a2                	lw	a5,8(sp)
8000b24c:	000785a3          	sb	zero,11(a5)
    config->dma_enable = false;
8000b250:	47a2                	lw	a5,8(sp)
8000b252:	000786a3          	sb	zero,13(a5)
    config->modem_config.auto_flow_ctrl_en = false;
8000b256:	47a2                	lw	a5,8(sp)
8000b258:	000787a3          	sb	zero,15(a5)
    config->modem_config.loop_back_en = false;
8000b25c:	47a2                	lw	a5,8(sp)
8000b25e:	00078823          	sb	zero,16(a5)
    config->modem_config.set_rts_high = false;
8000b262:	47a2                	lw	a5,8(sp)
8000b264:	000788a3          	sb	zero,17(a5)
    config->txidle_config.threshold = 10; /* 10-bit for typical UART configuration (8-N-1) */
#endif
#if defined(HPM_IP_FEATURE_UART_RX_EN) && (HPM_IP_FEATURE_UART_RX_EN == 1)
    config->rx_enable = true;
#endif
}
8000b268:	0001                	nop
8000b26a:	0141                	add	sp,sp,16
8000b26c:	8082                	ret

Disassembly of section .text.uart_send_byte:

8000b26e <uart_send_byte>:

    return status_success;
}

hpm_stat_t uart_send_byte(UART_Type *ptr, uint8_t c)
{
8000b26e:	1101                	add	sp,sp,-32
8000b270:	c62a                	sw	a0,12(sp)
8000b272:	87ae                	mv	a5,a1
8000b274:	00f105a3          	sb	a5,11(sp)
    uint32_t retry = 0;
8000b278:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
8000b27a:	a811                	j	8000b28e <.L48>

8000b27c <.L51>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000b27c:	4772                	lw	a4,28(sp)
8000b27e:	6785                	lui	a5,0x1
8000b280:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
8000b284:	00e7eb63          	bltu	a5,a4,8000b29a <.L54>
            break;
        }
        retry++;
8000b288:	47f2                	lw	a5,28(sp)
8000b28a:	0785                	add	a5,a5,1
8000b28c:	ce3e                	sw	a5,28(sp)

8000b28e <.L48>:
    while (!(ptr->LSR & UART_LSR_THRE_MASK)) {
8000b28e:	47b2                	lw	a5,12(sp)
8000b290:	5bdc                	lw	a5,52(a5)
8000b292:	0207f793          	and	a5,a5,32
8000b296:	d3fd                	beqz	a5,8000b27c <.L51>
8000b298:	a011                	j	8000b29c <.L50>

8000b29a <.L54>:
            break;
8000b29a:	0001                	nop

8000b29c <.L50>:
    }

    if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000b29c:	4772                	lw	a4,28(sp)
8000b29e:	6785                	lui	a5,0x1
8000b2a0:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
8000b2a4:	00e7f463          	bgeu	a5,a4,8000b2ac <.L52>
        return status_timeout;
8000b2a8:	478d                	li	a5,3
8000b2aa:	a031                	j	8000b2b6 <.L53>

8000b2ac <.L52>:
    }

    ptr->THR = UART_THR_THR_SET(c);
8000b2ac:	00b14703          	lbu	a4,11(sp)
8000b2b0:	47b2                	lw	a5,12(sp)
8000b2b2:	d398                	sw	a4,32(a5)
    return status_success;
8000b2b4:	4781                	li	a5,0

8000b2b6 <.L53>:
}
8000b2b6:	853e                	mv	a0,a5
8000b2b8:	6105                	add	sp,sp,32
8000b2ba:	8082                	ret

Disassembly of section .text.sysctl_release_cpu:

8000b2bc <sysctl_release_cpu>:
 *
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] cpu_index CPU index
 */
static inline void sysctl_release_cpu(SYSCTL_Type *ptr, uint8_t cpu_index)
{
8000b2bc:	1141                	add	sp,sp,-16
8000b2be:	c62a                	sw	a0,12(sp)
8000b2c0:	87ae                	mv	a5,a1
8000b2c2:	00f105a3          	sb	a5,11(sp)
    ptr->CPU[cpu_index].LP &= ~SYSCTL_CPU_LP_HALT_MASK;
8000b2c6:	00b14783          	lbu	a5,11(sp)
8000b2ca:	4732                	lw	a4,12(sp)
8000b2cc:	07a9                	add	a5,a5,10
8000b2ce:	07aa                	sll	a5,a5,0xa
8000b2d0:	97ba                	add	a5,a5,a4
8000b2d2:	4394                	lw	a3,0(a5)
8000b2d4:	00b14783          	lbu	a5,11(sp)
8000b2d8:	7741                	lui	a4,0xffff0
8000b2da:	177d                	add	a4,a4,-1 # fffeffff <__APB_SRAM_segment_end__+0xbefdfff>
8000b2dc:	8f75                	and	a4,a4,a3
8000b2de:	46b2                	lw	a3,12(sp)
8000b2e0:	07a9                	add	a5,a5,10
8000b2e2:	07aa                	sll	a5,a5,0xa
8000b2e4:	97b6                	add	a5,a5,a3
8000b2e6:	c398                	sw	a4,0(a5)
}
8000b2e8:	0001                	nop
8000b2ea:	0141                	add	sp,sp,16
8000b2ec:	8082                	ret

Disassembly of section .text.sysctl_is_cpu_released:

8000b2ee <sysctl_is_cpu_released>:
 * @param[in] cpu_index CPU index
 * @retval true CPU is released
 * @retval false CPU is on-hold
 */
static inline bool sysctl_is_cpu_released(SYSCTL_Type *ptr, uint8_t cpu_index)
{
8000b2ee:	1141                	add	sp,sp,-16
8000b2f0:	c62a                	sw	a0,12(sp)
8000b2f2:	87ae                	mv	a5,a1
8000b2f4:	00f105a3          	sb	a5,11(sp)
    return ((ptr->CPU[cpu_index].LP & SYSCTL_CPU_LP_HALT_MASK) == 0U);
8000b2f8:	00b14783          	lbu	a5,11(sp)
8000b2fc:	4732                	lw	a4,12(sp)
8000b2fe:	07a9                	add	a5,a5,10
8000b300:	07aa                	sll	a5,a5,0xa
8000b302:	97ba                	add	a5,a5,a4
8000b304:	4398                	lw	a4,0(a5)
8000b306:	67c1                	lui	a5,0x10
8000b308:	8ff9                	and	a5,a5,a4
8000b30a:	0017b793          	seqz	a5,a5
8000b30e:	0ff7f793          	zext.b	a5,a5
}
8000b312:	853e                	mv	a0,a5
8000b314:	0141                	add	sp,sp,16
8000b316:	8082                	ret

Disassembly of section .text.multicore_release_cpu:

8000b318 <multicore_release_cpu>:
#include "multicore_common.h"

ATTR_PLACE_AT_NONCACHEABLE static sdp_dma_ctx_t s_dma_ctx;

void multicore_release_cpu(uint8_t cpu_id, uint32_t start_addr)
{
8000b318:	7139                	add	sp,sp,-64
8000b31a:	de06                	sw	ra,60(sp)
8000b31c:	87aa                	mv	a5,a0
8000b31e:	c42e                	sw	a1,8(sp)
8000b320:	00f107a3          	sb	a5,15(sp)
    sdp_dma_ctx_t *p_sdp_ctx = (sdp_dma_ctx_t *) core_local_mem_to_sys_address(HPM_CORE0, (uint32_t) &s_dma_ctx);
8000b324:	40c007b7          	lui	a5,0x40c00
8000b328:	00078793          	mv	a5,a5
8000b32c:	85be                	mv	a1,a5
8000b32e:	4501                	li	a0,0
8000b330:	612030ef          	jal	8000e942 <core_local_mem_to_sys_address>
8000b334:	87aa                	mv	a5,a0
8000b336:	d63e                	sw	a5,44(sp)
    uint32_t sec_core_app_sys_addr = core_local_mem_to_sys_address(cpu_id, (uint32_t)start_addr);
8000b338:	00f14783          	lbu	a5,15(sp)
8000b33c:	45a2                	lw	a1,8(sp)
8000b33e:	853e                	mv	a0,a5
8000b340:	602030ef          	jal	8000e942 <core_local_mem_to_sys_address>
8000b344:	d42a                	sw	a0,40(sp)
    uint32_t sec_core_img_sys_addr = core_local_mem_to_sys_address(0, (uint32_t)sec_core_img);
8000b346:	800037b7          	lui	a5,0x80003
8000b34a:	2b878793          	add	a5,a5,696 # 800032b8 <sec_core_img>
8000b34e:	85be                	mv	a1,a5
8000b350:	4501                	li	a0,0
8000b352:	5f0030ef          	jal	8000e942 <core_local_mem_to_sys_address>
8000b356:	d22a                	sw	a0,36(sp)
    uint32_t aligned_start;
    uint32_t aligned_end;
    uint32_t aligned_size;

    if (!sysctl_is_cpu_released(HPM_SYSCTL, cpu_id)) {
8000b358:	00f14783          	lbu	a5,15(sp)
8000b35c:	85be                	mv	a1,a5
8000b35e:	f4000537          	lui	a0,0xf4000
8000b362:	3771                	jal	8000b2ee <sysctl_is_cpu_released>
8000b364:	87aa                	mv	a5,a0
8000b366:	0017c793          	xor	a5,a5,1
8000b36a:	0ff7f793          	zext.b	a5,a5
8000b36e:	c3d5                	beqz	a5,8000b412 <.L20>
        printf("\nCopying secondary core image to destination memory: %#x\n", sec_core_img_sys_addr);
8000b370:	5592                	lw	a1,36(sp)
8000b372:	50018513          	add	a0,gp,1280 # 8000986c <.LC0>
8000b376:	6ba010ef          	jal	8000ca30 <printf>
        clock_add_to_group(clock_sdp, 0);
8000b37a:	4581                	li	a1,0
8000b37c:	010e07b7          	lui	a5,0x10e0
8000b380:	60078513          	add	a0,a5,1536 # 10e0600 <__thread_pointer$+0x5fe00>
8000b384:	21f1                	jal	8000b850 <clock_add_to_group>
        rom_sdp_memcpy(p_sdp_ctx, (void *)sec_core_app_sys_addr, (void *)sec_core_img_sys_addr, sec_core_img_size);
8000b386:	5722                	lw	a4,40(sp)
8000b388:	5612                	lw	a2,36(sp)
8000b38a:	800037b7          	lui	a5,0x80003
8000b38e:	2b47a783          	lw	a5,692(a5) # 800032b4 <sec_core_img_size>
8000b392:	86be                	mv	a3,a5
8000b394:	85ba                	mv	a1,a4
8000b396:	5532                	lw	a0,44(sp)
8000b398:	60a030ef          	jal	8000e9a2 <rom_sdp_memcpy>

8000b39c <.LBB18>:
#endif

/* get cache control register value */
ATTR_ALWAYS_INLINE static inline uint32_t l1c_get_control(void)
{
    return read_csr(CSR_MCACHE_CTL);
8000b39c:	7ca027f3          	csrr	a5,0x7ca
8000b3a0:	ca3e                	sw	a5,20(sp)
8000b3a2:	47d2                	lw	a5,20(sp)

8000b3a4 <.LBE22>:
8000b3a4:	0001                	nop

8000b3a6 <.LBE20>:
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
}

ATTR_ALWAYS_INLINE static inline bool l1c_ic_is_enabled(void)
{
    return l1c_get_control() & HPM_MCACHE_CTL_IC_EN_MASK;
8000b3a6:	8b85                	and	a5,a5,1
8000b3a8:	00f037b3          	snez	a5,a5
8000b3ac:	0ff7f793          	zext.b	a5,a5

8000b3b0 <.LBE18>:
        if (l1c_ic_is_enabled() || l1c_dc_is_enabled()) {
8000b3b0:	ef81                	bnez	a5,8000b3c8 <.L16>

8000b3b2 <.LBB23>:
    return read_csr(CSR_MCACHE_CTL);
8000b3b2:	7ca027f3          	csrr	a5,0x7ca
8000b3b6:	c83e                	sw	a5,16(sp)
8000b3b8:	47c2                	lw	a5,16(sp)

8000b3ba <.LBE27>:
8000b3ba:	0001                	nop

8000b3bc <.LBE25>:
    return l1c_get_control() & HPM_MCACHE_CTL_DC_EN_MASK;
8000b3bc:	8b89                	and	a5,a5,2
8000b3be:	00f037b3          	snez	a5,a5
8000b3c2:	0ff7f793          	zext.b	a5,a5

8000b3c6 <.LBE23>:
8000b3c6:	cb8d                	beqz	a5,8000b3f8 <.L19>

8000b3c8 <.L16>:
            aligned_start = HPM_L1C_CACHELINE_ALIGN_DOWN(sec_core_img_sys_addr);
8000b3c8:	5792                	lw	a5,36(sp)
8000b3ca:	fc07f793          	and	a5,a5,-64
8000b3ce:	d03e                	sw	a5,32(sp)
            aligned_end = HPM_L1C_CACHELINE_ALIGN_UP(sec_core_img_sys_addr + sec_core_img_size);
8000b3d0:	800037b7          	lui	a5,0x80003
8000b3d4:	2b47a703          	lw	a4,692(a5) # 800032b4 <sec_core_img_size>
8000b3d8:	5792                	lw	a5,36(sp)
8000b3da:	97ba                	add	a5,a5,a4
8000b3dc:	03f78793          	add	a5,a5,63
8000b3e0:	fc07f793          	and	a5,a5,-64
8000b3e4:	ce3e                	sw	a5,28(sp)
            aligned_size = aligned_end - aligned_start;
8000b3e6:	4772                	lw	a4,28(sp)
8000b3e8:	5782                	lw	a5,32(sp)
8000b3ea:	40f707b3          	sub	a5,a4,a5
8000b3ee:	cc3e                	sw	a5,24(sp)
            l1c_dc_flush(aligned_start, aligned_size);
8000b3f0:	45e2                	lw	a1,24(sp)
8000b3f2:	5502                	lw	a0,32(sp)
8000b3f4:	d3efe0ef          	jal	80009932 <l1c_dc_flush>

8000b3f8 <.L19>:
        }

        sysctl_set_cpu_entry(HPM_SYSCTL, cpu_id, (uint32_t)start_addr);
8000b3f8:	00f14783          	lbu	a5,15(sp)
8000b3fc:	4622                	lw	a2,8(sp)
8000b3fe:	85be                	mv	a1,a5
8000b400:	f4000537          	lui	a0,0xf4000
8000b404:	2b09                	jal	8000b916 <sysctl_set_cpu_entry>
        sysctl_release_cpu(HPM_SYSCTL, cpu_id);
8000b406:	00f14783          	lbu	a5,15(sp)
8000b40a:	85be                	mv	a1,a5
8000b40c:	f4000537          	lui	a0,0xf4000
8000b410:	3575                	jal	8000b2bc <sysctl_release_cpu>

8000b412 <.L20>:
    }
}
8000b412:	0001                	nop
8000b414:	50f2                	lw	ra,60(sp)
8000b416:	6121                	add	sp,sp,64
8000b418:	8082                	ret

Disassembly of section .text.mbx_init:

8000b41a <mbx_init>:
 * @brief   Initialization
 *
 * @param[in] ptr MBX base address
 */
static inline void mbx_init(MBX_Type *ptr)
{
8000b41a:	1101                	add	sp,sp,-32
8000b41c:	ce06                	sw	ra,28(sp)
8000b41e:	c62a                	sw	a0,12(sp)
    mbx_empty_txfifo(ptr);
8000b420:	4532                	lw	a0,12(sp)
8000b422:	5c8030ef          	jal	8000e9ea <mbx_empty_txfifo>
    mbx_disable_intr(ptr, MBX_CR_ALL_INTERRUPTS_MASK);
8000b426:	0b200593          	li	a1,178
8000b42a:	4532                	lw	a0,12(sp)
8000b42c:	5a2030ef          	jal	8000e9ce <mbx_disable_intr>
}
8000b430:	0001                	nop
8000b432:	40f2                	lw	ra,28(sp)
8000b434:	6105                	add	sp,sp,32
8000b436:	8082                	ret

Disassembly of section .text.mbx_interrupt_init:

8000b438 <mbx_interrupt_init>:



// MBX中断优先级设置为1，高于CAN中断的优先级2
void mbx_interrupt_init(void)
{
8000b438:	715d                	add	sp,sp,-80
8000b43a:	c686                	sw	ra,76(sp)
    mbx_init(MBX);  // 初始化MBX
8000b43c:	f00a0537          	lui	a0,0xf00a0
8000b440:	3fe9                	jal	8000b41a <mbx_init>
8000b442:	03800793          	li	a5,56
8000b446:	d03e                	sw	a5,32(sp)
8000b448:	4789                	li	a5,2
8000b44a:	ce3e                	sw	a5,28(sp)
8000b44c:	e40007b7          	lui	a5,0xe4000
8000b450:	cc3e                	sw	a5,24(sp)
8000b452:	5782                	lw	a5,32(sp)
8000b454:	ca3e                	sw	a5,20(sp)
8000b456:	47f2                	lw	a5,28(sp)
8000b458:	c83e                	sw	a5,16(sp)

8000b45a <.LBB14>:
ATTR_ALWAYS_INLINE static inline void __plic_set_irq_priority(uint32_t base,
                                               uint32_t irq,
                                               uint32_t priority)
{
    volatile uint32_t *priority_ptr = (volatile uint32_t *)(base +
            HPM_PLIC_PRIORITY_OFFSET + ((irq-1) << HPM_PLIC_PRIORITY_SHIFT_PER_SOURCE));
8000b45a:	47d2                	lw	a5,20(sp)
8000b45c:	17fd                	add	a5,a5,-1 # e3ffffff <__FLASH_segment_end__+0x637fffff>
8000b45e:	00279713          	sll	a4,a5,0x2
8000b462:	47e2                	lw	a5,24(sp)
8000b464:	97ba                	add	a5,a5,a4
8000b466:	0791                	add	a5,a5,4
    volatile uint32_t *priority_ptr = (volatile uint32_t *)(base +
8000b468:	c63e                	sw	a5,12(sp)
    *priority_ptr = priority;
8000b46a:	47b2                	lw	a5,12(sp)
8000b46c:	4742                	lw	a4,16(sp)
8000b46e:	c398                	sw	a4,0(a5)
}
8000b470:	0001                	nop

8000b472 <.LBE16>:
 * @param[in] priority Priority of interrupt
 */
ATTR_ALWAYS_INLINE static inline void intc_set_irq_priority(uint32_t irq, uint32_t priority)
{
    __plic_set_irq_priority(HPM_PLIC_BASE, irq, priority);
}
8000b472:	0001                	nop
8000b474:	de02                	sw	zero,60(sp)
8000b476:	03800793          	li	a5,56
8000b47a:	dc3e                	sw	a5,56(sp)
8000b47c:	e40007b7          	lui	a5,0xe4000
8000b480:	da3e                	sw	a5,52(sp)
8000b482:	57f2                	lw	a5,60(sp)
8000b484:	d83e                	sw	a5,48(sp)
8000b486:	57e2                	lw	a5,56(sp)
8000b488:	d63e                	sw	a5,44(sp)

8000b48a <.LBB18>:
                                                        uint32_t target,
                                                        uint32_t irq)
{
    volatile uint32_t *current_ptr = (volatile uint32_t *)(base +
            HPM_PLIC_ENABLE_OFFSET +
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
8000b48a:	57c2                	lw	a5,48(sp)
8000b48c:	00779713          	sll	a4,a5,0x7
            HPM_PLIC_ENABLE_OFFSET +
8000b490:	57d2                	lw	a5,52(sp)
8000b492:	973e                	add	a4,a4,a5
            ((irq >> 5) << 2));
8000b494:	57b2                	lw	a5,44(sp)
8000b496:	8395                	srl	a5,a5,0x5
8000b498:	078a                	sll	a5,a5,0x2
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
8000b49a:	973e                	add	a4,a4,a5
8000b49c:	6789                	lui	a5,0x2
8000b49e:	97ba                	add	a5,a5,a4
    volatile uint32_t *current_ptr = (volatile uint32_t *)(base +
8000b4a0:	d43e                	sw	a5,40(sp)
    uint32_t current = *current_ptr;
8000b4a2:	57a2                	lw	a5,40(sp)
8000b4a4:	439c                	lw	a5,0(a5)
8000b4a6:	d23e                	sw	a5,36(sp)
    current = current | (1 << (irq & 0x1F));
8000b4a8:	57b2                	lw	a5,44(sp)
8000b4aa:	8bfd                	and	a5,a5,31
8000b4ac:	4705                	li	a4,1
8000b4ae:	00f717b3          	sll	a5,a4,a5
8000b4b2:	873e                	mv	a4,a5
8000b4b4:	5792                	lw	a5,36(sp)
8000b4b6:	8fd9                	or	a5,a5,a4
8000b4b8:	d23e                	sw	a5,36(sp)
    *current_ptr = current;
8000b4ba:	57a2                	lw	a5,40(sp)
8000b4bc:	5712                	lw	a4,36(sp)
8000b4be:	c398                	sw	a4,0(a5)
}
8000b4c0:	0001                	nop

8000b4c2 <.LBE20>:
}
8000b4c2:	0001                	nop

8000b4c4 <.LBE18>:
    intc_m_enable_irq_with_priority(MBX_IRQ, 2);  // MBX中断优先级为1，可以嵌套CAN中断
}
8000b4c4:	0001                	nop
8000b4c6:	40b6                	lw	ra,76(sp)
8000b4c8:	6161                	add	sp,sp,80
8000b4ca:	8082                	ret

Disassembly of section .text.can_clear_tx_rx_flags:

8000b4cc <can_clear_tx_rx_flags>:
{
8000b4cc:	1141                	add	sp,sp,-16
8000b4ce:	c62a                	sw	a0,12(sp)
8000b4d0:	87ae                	mv	a5,a1
8000b4d2:	00f105a3          	sb	a5,11(sp)
    base->RTIF = flags;
8000b4d6:	47b2                	lw	a5,12(sp)
8000b4d8:	00b14703          	lbu	a4,11(sp)
8000b4dc:	0ae782a3          	sb	a4,165(a5) # 20a5 <__APB_SRAM_segment_size__+0xa5>
}
8000b4e0:	0001                	nop
8000b4e2:	0141                	add	sp,sp,16
8000b4e4:	8082                	ret

Disassembly of section .text.can_clear_error_interrupt_flags:

8000b4e6 <can_clear_error_interrupt_flags>:
{
8000b4e6:	1141                	add	sp,sp,-16
8000b4e8:	c62a                	sw	a0,12(sp)
8000b4ea:	87ae                	mv	a5,a1
8000b4ec:	00f105a3          	sb	a5,11(sp)
    flags &= (uint8_t)~(CAN_ERRINT_EPIE_MASK | CAN_ERRINT_ALIE_MASK | CAN_ERRINT_BEIE_MASK);
8000b4f0:	00b14783          	lbu	a5,11(sp)
8000b4f4:	fd57f793          	and	a5,a5,-43
8000b4f8:	00f105a3          	sb	a5,11(sp)
    base->ERRINT |= flags;
8000b4fc:	47b2                	lw	a5,12(sp)
8000b4fe:	0a67c783          	lbu	a5,166(a5)
8000b502:	0ff7f793          	zext.b	a5,a5
8000b506:	00b14703          	lbu	a4,11(sp)
8000b50a:	8fd9                	or	a5,a5,a4
8000b50c:	0ff7f713          	zext.b	a4,a5
8000b510:	47b2                	lw	a5,12(sp)
8000b512:	0ae78323          	sb	a4,166(a5)
}
8000b516:	0001                	nop
8000b518:	0141                	add	sp,sp,16
8000b51a:	8082                	ret

Disassembly of section .text.get_writeable_ram:

8000b51c <get_writeable_ram>:
    can_clear_error_interrupt_flags(BOARD_APP_CAN_BASE, error_flags);
}

/* 获取可用的共享内存 */
can_receive_buf_t* get_writeable_ram(share_buffer_t* block)
{
8000b51c:	7179                	add	sp,sp,-48
8000b51e:	d606                	sw	ra,44(sp)
8000b520:	c62a                	sw	a0,12(sp)
    int8_t ret = 0;
8000b522:	00010fa3          	sb	zero,31(sp)
    
 
    block->write_head->status = SHARE_BUFFER_STATUS_WRITING;
8000b526:	47b2                	lw	a5,12(sp)
8000b528:	47dc                	lw	a5,12(a5)
8000b52a:	4705                	li	a4,1
8000b52c:	00e78223          	sb	a4,4(a5)
            
              
            
    /* item 满了*/
    if(block->write_head->current_index + 1> block->write_head->max_index){
8000b530:	47b2                	lw	a5,12(sp)
8000b532:	47dc                	lw	a5,12(a5)
8000b534:	0057c703          	lbu	a4,5(a5)
8000b538:	47b2                	lw	a5,12(sp)
8000b53a:	47dc                	lw	a5,12(a5)
8000b53c:	0067c783          	lbu	a5,6(a5)
8000b540:	04f76763          	bltu	a4,a5,8000b58e <.L36>

8000b544 <.LBB28>:
        block->write_head->status = SHARE_BUFFER_STATUS_FULL;
8000b544:	47b2                	lw	a5,12(sp)
8000b546:	47dc                	lw	a5,12(a5)
8000b548:	470d                	li	a4,3
8000b54a:	00e78223          	sb	a4,4(a5)
        uint8_t index = block->write_head->current_index;
8000b54e:	47b2                	lw	a5,12(sp)
8000b550:	47dc                	lw	a5,12(a5)
8000b552:	0057c783          	lbu	a5,5(a5)
8000b556:	00f10f23          	sb	a5,30(sp)
            
        //printf("get_writeable_ram():write_head is full,switch to next item\n");
                     
        //item_full_notice();
        ret = write_head_switch(block);
8000b55a:	4532                	lw	a0,12(sp)
8000b55c:	06f030ef          	jal	8000edca <write_head_switch>
8000b560:	87aa                	mv	a5,a0
8000b562:	00f10fa3          	sb	a5,31(sp)
        if(ret == -1)
8000b566:	01f10703          	lb	a4,31(sp)
8000b56a:	57fd                	li	a5,-1
8000b56c:	00f71663          	bne	a4,a5,8000b578 <.L37>
        {   
            //printf("get_writeable_ram():next item is not available\n");
            block->is_full = true;
8000b570:	47b2                	lw	a5,12(sp)
8000b572:	4705                	li	a4,1
8000b574:	00e78a23          	sb	a4,20(a5)

8000b578 <.L37>:
        }
      
        return (can_receive_buf_t*)(block->write_head->data + index ); /* 返回当前item的data*/
8000b578:	47b2                	lw	a5,12(sp)
8000b57a:	47dc                	lw	a5,12(a5)
8000b57c:	4394                	lw	a3,0(a5)
8000b57e:	01e14703          	lbu	a4,30(sp)
8000b582:	87ba                	mv	a5,a4
8000b584:	078a                	sll	a5,a5,0x2
8000b586:	97ba                	add	a5,a5,a4
8000b588:	0792                	sll	a5,a5,0x4
8000b58a:	97b6                	add	a5,a5,a3
8000b58c:	a80d                	j	8000b5be <.L38>

8000b58e <.L36>:
    }else{                                                           /* item 未满*/
        
        block->write_head->current_index++;
8000b58e:	47b2                	lw	a5,12(sp)
8000b590:	47dc                	lw	a5,12(a5)
8000b592:	0057c703          	lbu	a4,5(a5)
8000b596:	0705                	add	a4,a4,1
8000b598:	0ff77713          	zext.b	a4,a4
8000b59c:	00e782a3          	sb	a4,5(a5)
        return (can_receive_buf_t*)(block->write_head->data + block->write_head->current_index - 1); /* 返回当前item的data*/
8000b5a0:	47b2                	lw	a5,12(sp)
8000b5a2:	47dc                	lw	a5,12(a5)
8000b5a4:	4398                	lw	a4,0(a5)
8000b5a6:	47b2                	lw	a5,12(sp)
8000b5a8:	47dc                	lw	a5,12(a5)
8000b5aa:	0057c783          	lbu	a5,5(a5)
8000b5ae:	86be                	mv	a3,a5
8000b5b0:	87b6                	mv	a5,a3
8000b5b2:	078a                	sll	a5,a5,0x2
8000b5b4:	97b6                	add	a5,a5,a3
8000b5b6:	0792                	sll	a5,a5,0x4
8000b5b8:	fb078793          	add	a5,a5,-80
8000b5bc:	97ba                	add	a5,a5,a4

8000b5be <.L38>:
    }


}
8000b5be:	853e                	mv	a0,a5
8000b5c0:	50b2                	lw	ra,44(sp)
8000b5c2:	6145                	add	sp,sp,48
8000b5c4:	8082                	ret

Disassembly of section .text.syscall_handler:

8000b5c6 <syscall_handler>:
__attribute__((weak)) void swi_isr(void)
{
}

__attribute__((weak)) void syscall_handler(long n, long a0, long a1, long a2, long a3)
{
8000b5c6:	1101                	add	sp,sp,-32
8000b5c8:	ce2a                	sw	a0,28(sp)
8000b5ca:	cc2e                	sw	a1,24(sp)
8000b5cc:	ca32                	sw	a2,20(sp)
8000b5ce:	c836                	sw	a3,16(sp)
8000b5d0:	c63a                	sw	a4,12(sp)
    (void) n;
    (void) a0;
    (void) a1;
    (void) a2;
    (void) a3;
}
8000b5d2:	0001                	nop
8000b5d4:	6105                	add	sp,sp,32
8000b5d6:	8082                	ret

Disassembly of section .text.pllctl_get_div:

8000b5d8 <pllctl_get_div>:
{
8000b5d8:	1141                	add	sp,sp,-16
8000b5da:	c62a                	sw	a0,12(sp)
8000b5dc:	87ae                	mv	a5,a1
8000b5de:	8732                	mv	a4,a2
8000b5e0:	00f105a3          	sb	a5,11(sp)
8000b5e4:	87ba                	mv	a5,a4
8000b5e6:	00f10523          	sb	a5,10(sp)
    if ((pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1))
8000b5ea:	00b14703          	lbu	a4,11(sp)
8000b5ee:	4791                	li	a5,4
8000b5f0:	00e7ec63          	bltu	a5,a4,8000b608 <.L6>
            || !(PLLCTL_SOC_PLL_HAS_DIV0(pll))) {
8000b5f4:	00b14703          	lbu	a4,11(sp)
8000b5f8:	4785                	li	a5,1
8000b5fa:	00f70963          	beq	a4,a5,8000b60c <.L7>
8000b5fe:	00b14703          	lbu	a4,11(sp)
8000b602:	4789                	li	a5,2
8000b604:	00f70463          	beq	a4,a5,8000b60c <.L7>

8000b608 <.L6>:
        return status_invalid_argument;
8000b608:	4789                	li	a5,2
8000b60a:	a80d                	j	8000b63c <.L8>

8000b60c <.L7>:
    if (div_index) {
8000b60c:	00a14783          	lbu	a5,10(sp)
8000b610:	cf81                	beqz	a5,8000b628 <.L9>
        return PLLCTL_PLL_DIV0_DIV_GET(ptr->PLL[pll].DIV1) + 1;
8000b612:	00b14783          	lbu	a5,11(sp)
8000b616:	4732                	lw	a4,12(sp)
8000b618:	079e                	sll	a5,a5,0x7
8000b61a:	97ba                	add	a5,a5,a4
8000b61c:	0c47a783          	lw	a5,196(a5)
8000b620:	0ff7f793          	zext.b	a5,a5
8000b624:	0785                	add	a5,a5,1
8000b626:	a819                	j	8000b63c <.L8>

8000b628 <.L9>:
        return PLLCTL_PLL_DIV0_DIV_GET(ptr->PLL[pll].DIV0) + 1;
8000b628:	00b14783          	lbu	a5,11(sp)
8000b62c:	4732                	lw	a4,12(sp)
8000b62e:	079e                	sll	a5,a5,0x7
8000b630:	97ba                	add	a5,a5,a4
8000b632:	0c07a783          	lw	a5,192(a5)
8000b636:	0ff7f793          	zext.b	a5,a5
8000b63a:	0785                	add	a5,a5,1

8000b63c <.L8>:
}
8000b63c:	853e                	mv	a0,a5
8000b63e:	0141                	add	sp,sp,16
8000b640:	8082                	ret

Disassembly of section .text.clock_get_frequency:

8000b642 <clock_get_frequency>:

/***********************************************************************************************************************
 * Codes
 **********************************************************************************************************************/
uint32_t clock_get_frequency(clock_name_t clock_name)
{
8000b642:	7179                	add	sp,sp,-48
8000b644:	d606                	sw	ra,44(sp)
8000b646:	c62a                	sw	a0,12(sp)
    uint32_t clk_freq = 0UL;
8000b648:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
8000b64a:	47b2                	lw	a5,12(sp)
8000b64c:	83a1                	srl	a5,a5,0x8
8000b64e:	0ff7f793          	zext.b	a5,a5
8000b652:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
8000b654:	47b2                	lw	a5,12(sp)
8000b656:	0ff7f793          	zext.b	a5,a5
8000b65a:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
8000b65c:	4762                	lw	a4,24(sp)
8000b65e:	47b1                	li	a5,12
8000b660:	08e7ee63          	bltu	a5,a4,8000b6fc <.L27>
8000b664:	47e2                	lw	a5,24(sp)
8000b666:	00279713          	sll	a4,a5,0x2
8000b66a:	800097b7          	lui	a5,0x80009
8000b66e:	b5878793          	add	a5,a5,-1192 # 80008b58 <.L29>
8000b672:	97ba                	add	a5,a5,a4
8000b674:	439c                	lw	a5,0(a5)
8000b676:	8782                	jr	a5

8000b678 <.L41>:
    case CLK_SRC_GROUP_COMMON:
        clk_freq = get_frequency_for_ip_in_common_group((clock_node_t) node_or_instance);
8000b678:	47d2                	lw	a5,20(sp)
8000b67a:	0ff7f793          	zext.b	a5,a5
8000b67e:	853e                	mv	a0,a5
8000b680:	2069                	jal	8000b70a <.LFE131>
8000b682:	ce2a                	sw	a0,28(sp)
        break;
8000b684:	a8b5                	j	8000b700 <.L42>

8000b686 <.L40>:
    case CLK_SRC_GROUP_ADC:
        clk_freq = get_frequency_for_i2s_or_adc(CLK_SRC_GROUP_ADC, node_or_instance);
8000b686:	45d2                	lw	a1,20(sp)
8000b688:	4505                	li	a0,1
8000b68a:	1b3030ef          	jal	8000f03c <get_frequency_for_i2s_or_adc>
8000b68e:	ce2a                	sw	a0,28(sp)
        break;
8000b690:	a885                	j	8000b700 <.L42>

8000b692 <.L39>:
    case CLK_SRC_GROUP_I2S:
        clk_freq = get_frequency_for_i2s_or_adc(CLK_SRC_GROUP_I2S, node_or_instance);
8000b692:	45d2                	lw	a1,20(sp)
8000b694:	4509                	li	a0,2
8000b696:	1a7030ef          	jal	8000f03c <get_frequency_for_i2s_or_adc>
8000b69a:	ce2a                	sw	a0,28(sp)
        break;
8000b69c:	a095                	j	8000b700 <.L42>

8000b69e <.L38>:
    case CLK_SRC_GROUP_WDG:
        clk_freq = get_frequency_for_wdg(node_or_instance);
8000b69e:	4552                	lw	a0,20(sp)
8000b6a0:	275030ef          	jal	8000f114 <get_frequency_for_wdg>
8000b6a4:	ce2a                	sw	a0,28(sp)
        break;
8000b6a6:	a8a9                	j	8000b700 <.L42>

8000b6a8 <.L28>:
    case CLK_SRC_GROUP_PWDG:
        clk_freq = get_frequency_for_pwdg();
8000b6a8:	2a1030ef          	jal	8000f148 <get_frequency_for_pwdg>
8000b6ac:	ce2a                	sw	a0,28(sp)
        break;
8000b6ae:	a889                	j	8000b700 <.L42>

8000b6b0 <.L37>:
    case CLK_SRC_GROUP_PMIC:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
8000b6b0:	016e37b7          	lui	a5,0x16e3
8000b6b4:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000b6b8:	ce3e                	sw	a5,28(sp)
        break;
8000b6ba:	a099                	j	8000b700 <.L42>

8000b6bc <.L36>:
    case CLK_SRC_GROUP_AHB:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
8000b6bc:	451d                	li	a0,7
8000b6be:	20b1                	jal	8000b70a <.LFE131>
8000b6c0:	ce2a                	sw	a0,28(sp)
        break;
8000b6c2:	a83d                	j	8000b700 <.L42>

8000b6c4 <.L35>:
    case CLK_SRC_GROUP_AXI0:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi0);
8000b6c4:	4511                	li	a0,4
8000b6c6:	2091                	jal	8000b70a <.LFE131>
8000b6c8:	ce2a                	sw	a0,28(sp)
        break;
8000b6ca:	a81d                	j	8000b700 <.L42>

8000b6cc <.L34>:
    case CLK_SRC_GROUP_AXI1:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi1);
8000b6cc:	4515                	li	a0,5
8000b6ce:	2835                	jal	8000b70a <.LFE131>
8000b6d0:	ce2a                	sw	a0,28(sp)
        break;
8000b6d2:	a03d                	j	8000b700 <.L42>

8000b6d4 <.L33>:
    case CLK_SRC_GROUP_AXI2:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_axi2);
8000b6d4:	4519                	li	a0,6
8000b6d6:	2815                	jal	8000b70a <.LFE131>
8000b6d8:	ce2a                	sw	a0,28(sp)
        break;
8000b6da:	a01d                	j	8000b700 <.L42>

8000b6dc <.L32>:
    case CLK_SRC_GROUP_CPU0:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu0);
8000b6dc:	4501                	li	a0,0
8000b6de:	2035                	jal	8000b70a <.LFE131>
8000b6e0:	ce2a                	sw	a0,28(sp)
        break;
8000b6e2:	a839                	j	8000b700 <.L42>

8000b6e4 <.L31>:
    case CLK_SRC_GROUP_CPU1:
        clk_freq = get_frequency_for_ip_in_common_group(clock_node_cpu1);
8000b6e4:	4509                	li	a0,2
8000b6e6:	2015                	jal	8000b70a <.LFE131>
8000b6e8:	ce2a                	sw	a0,28(sp)
        break;
8000b6ea:	a819                	j	8000b700 <.L42>

8000b6ec <.L30>:
    case CLK_SRC_GROUP_SRC:
        clk_freq = get_frequency_for_source((clock_source_t) node_or_instance);
8000b6ec:	47d2                	lw	a5,20(sp)
8000b6ee:	0ff7f793          	zext.b	a5,a5
8000b6f2:	853e                	mv	a0,a5
8000b6f4:	04d030ef          	jal	8000ef40 <get_frequency_for_source>
8000b6f8:	ce2a                	sw	a0,28(sp)
        break;
8000b6fa:	a019                	j	8000b700 <.L42>

8000b6fc <.L27>:
    default:
        clk_freq = 0UL;
8000b6fc:	ce02                	sw	zero,28(sp)
        break;
8000b6fe:	0001                	nop

8000b700 <.L42>:
    }
    return clk_freq;
8000b700:	47f2                	lw	a5,28(sp)
}
8000b702:	853e                	mv	a0,a5
8000b704:	50b2                	lw	ra,44(sp)
8000b706:	6145                	add	sp,sp,48
8000b708:	8082                	ret

Disassembly of section .text.get_frequency_for_ip_in_common_group:

8000b70a <get_frequency_for_ip_in_common_group>:

    return clk_freq;
}

static uint32_t get_frequency_for_ip_in_common_group(clock_node_t node)
{
8000b70a:	7139                	add	sp,sp,-64
8000b70c:	de06                	sw	ra,60(sp)
8000b70e:	87aa                	mv	a5,a0
8000b710:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
8000b714:	d602                	sw	zero,44(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(node);
8000b716:	00f14783          	lbu	a5,15(sp)
8000b71a:	d43e                	sw	a5,40(sp)

    if (node_or_instance < clock_node_end) {
8000b71c:	5722                	lw	a4,40(sp)
8000b71e:	04a00793          	li	a5,74
8000b722:	04e7e663          	bltu	a5,a4,8000b76e <.L58>

8000b726 <.LBB6>:
        uint32_t clk_node = (uint32_t) node_or_instance;
8000b726:	57a2                	lw	a5,40(sp)
8000b728:	d23e                	sw	a5,36(sp)

        uint32_t clk_div = 1UL + SYSCTL_CLOCK_DIV_GET(HPM_SYSCTL->CLOCK[clk_node]);
8000b72a:	f4000737          	lui	a4,0xf4000
8000b72e:	5792                	lw	a5,36(sp)
8000b730:	60078793          	add	a5,a5,1536
8000b734:	078a                	sll	a5,a5,0x2
8000b736:	97ba                	add	a5,a5,a4
8000b738:	439c                	lw	a5,0(a5)
8000b73a:	0ff7f793          	zext.b	a5,a5
8000b73e:	0785                	add	a5,a5,1
8000b740:	d03e                	sw	a5,32(sp)
        clock_source_t clk_mux = (clock_source_t) SYSCTL_CLOCK_MUX_GET(HPM_SYSCTL->CLOCK[clk_node]);
8000b742:	f4000737          	lui	a4,0xf4000
8000b746:	5792                	lw	a5,36(sp)
8000b748:	60078793          	add	a5,a5,1536
8000b74c:	078a                	sll	a5,a5,0x2
8000b74e:	97ba                	add	a5,a5,a4
8000b750:	439c                	lw	a5,0(a5)
8000b752:	83a1                	srl	a5,a5,0x8
8000b754:	8bbd                	and	a5,a5,15
8000b756:	00f10fa3          	sb	a5,31(sp)
        clk_freq = get_frequency_for_source(clk_mux) / clk_div;
8000b75a:	01f14783          	lbu	a5,31(sp)
8000b75e:	853e                	mv	a0,a5
8000b760:	7e0030ef          	jal	8000ef40 <get_frequency_for_source>
8000b764:	872a                	mv	a4,a0
8000b766:	5782                	lw	a5,32(sp)
8000b768:	02f757b3          	divu	a5,a4,a5
8000b76c:	d63e                	sw	a5,44(sp)

8000b76e <.L58>:
    }
    return clk_freq;
8000b76e:	57b2                	lw	a5,44(sp)
}
8000b770:	853e                	mv	a0,a5
8000b772:	50f2                	lw	ra,60(sp)
8000b774:	6121                	add	sp,sp,64
8000b776:	8082                	ret

Disassembly of section .text.clock_set_source_divider:

8000b778 <clock_set_source_divider>:
    }
    return status_success;
}

hpm_stat_t clock_set_source_divider(clock_name_t clock_name, clk_src_t src, uint32_t div)
{
8000b778:	7179                	add	sp,sp,-48
8000b77a:	d606                	sw	ra,44(sp)
8000b77c:	c62a                	sw	a0,12(sp)
8000b77e:	87ae                	mv	a5,a1
8000b780:	c232                	sw	a2,4(sp)
8000b782:	00f105a3          	sb	a5,11(sp)
    hpm_stat_t status = status_success;
8000b786:	ce02                	sw	zero,28(sp)
    uint32_t clk_src_type = GET_CLK_SRC_GROUP_FROM_NAME(clock_name);
8000b788:	47b2                	lw	a5,12(sp)
8000b78a:	83a1                	srl	a5,a5,0x8
8000b78c:	0ff7f793          	zext.b	a5,a5
8000b790:	cc3e                	sw	a5,24(sp)
    uint32_t node_or_instance = GET_CLK_NODE_FROM_NAME(clock_name);
8000b792:	47b2                	lw	a5,12(sp)
8000b794:	0ff7f793          	zext.b	a5,a5
8000b798:	ca3e                	sw	a5,20(sp)
    switch (clk_src_type) {
8000b79a:	4762                	lw	a4,24(sp)
8000b79c:	47b1                	li	a5,12
8000b79e:	08e7ef63          	bltu	a5,a4,8000b83c <.L150>
8000b7a2:	47e2                	lw	a5,24(sp)
8000b7a4:	00279713          	sll	a4,a5,0x2
8000b7a8:	84018793          	add	a5,gp,-1984 # 80008bac <.L152>
8000b7ac:	97ba                	add	a5,a5,a4
8000b7ae:	439c                	lw	a5,0(a5)
8000b7b0:	8782                	jr	a5

8000b7b2 <.L160>:
    case CLK_SRC_GROUP_COMMON:
        if ((div < 1U) || (div > 256U)) {
8000b7b2:	4792                	lw	a5,4(sp)
8000b7b4:	c791                	beqz	a5,8000b7c0 <.L161>
8000b7b6:	4712                	lw	a4,4(sp)
8000b7b8:	10000793          	li	a5,256
8000b7bc:	00e7f763          	bgeu	a5,a4,8000b7ca <.L162>

8000b7c0 <.L161>:
            status = status_clk_div_invalid;
8000b7c0:	6795                	lui	a5,0x5
8000b7c2:	5f078793          	add	a5,a5,1520 # 55f0 <__DLM_segment_used_size__+0x15f0>
8000b7c6:	ce3e                	sw	a5,28(sp)
        } else {
            clock_source_t clk_src = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, clk_src, div);
        }
        break;
8000b7c8:	a8bd                	j	8000b846 <.L164>

8000b7ca <.L162>:
            clock_source_t clk_src = GET_CLOCK_SOURCE_FROM_CLK_SRC(src);
8000b7ca:	00b14783          	lbu	a5,11(sp)
8000b7ce:	8bbd                	and	a5,a5,15
8000b7d0:	00f109a3          	sb	a5,19(sp)
            sysctl_config_clock(HPM_SYSCTL, (clock_node_t) node_or_instance, clk_src, div);
8000b7d4:	47d2                	lw	a5,20(sp)
8000b7d6:	0ff7f793          	zext.b	a5,a5
8000b7da:	01314703          	lbu	a4,19(sp)
8000b7de:	4692                	lw	a3,4(sp)
8000b7e0:	863a                	mv	a2,a4
8000b7e2:	85be                	mv	a1,a5
8000b7e4:	f4000537          	lui	a0,0xf4000
8000b7e8:	2a71                	jal	8000b984 <sysctl_config_clock>

8000b7ea <.LBE15>:
        break;
8000b7ea:	a8b1                	j	8000b846 <.L164>

8000b7ec <.L151>:
    case CLK_SRC_GROUP_ADC:
    case CLK_SRC_GROUP_I2S:
    case CLK_SRC_GROUP_WDG:
    case CLK_SRC_GROUP_PWDG:
    case CLK_SRC_GROUP_SRC:
        status = status_clk_operation_unsupported;
8000b7ec:	6795                	lui	a5,0x5
8000b7ee:	5f378793          	add	a5,a5,1523 # 55f3 <__DLM_segment_used_size__+0x15f3>
8000b7f2:	ce3e                	sw	a5,28(sp)
        break;
8000b7f4:	a889                	j	8000b846 <.L164>

8000b7f6 <.L159>:
    case CLK_SRC_GROUP_PMIC:
        status = status_clk_fixed;
8000b7f6:	6795                	lui	a5,0x5
8000b7f8:	5fa78793          	add	a5,a5,1530 # 55fa <__DLM_segment_used_size__+0x15fa>
8000b7fc:	ce3e                	sw	a5,28(sp)
        break;
8000b7fe:	a0a1                	j	8000b846 <.L164>

8000b800 <.L158>:
    case CLK_SRC_GROUP_AHB:
        status = status_clk_shared_ahb;
8000b800:	6795                	lui	a5,0x5
8000b802:	5f478793          	add	a5,a5,1524 # 55f4 <__DLM_segment_used_size__+0x15f4>
8000b806:	ce3e                	sw	a5,28(sp)
        break;
8000b808:	a83d                	j	8000b846 <.L164>

8000b80a <.L157>:
    case CLK_SRC_GROUP_AXI0:
        status = status_clk_shared_axi0;
8000b80a:	6795                	lui	a5,0x5
8000b80c:	5f578793          	add	a5,a5,1525 # 55f5 <__DLM_segment_used_size__+0x15f5>
8000b810:	ce3e                	sw	a5,28(sp)
        break;
8000b812:	a815                	j	8000b846 <.L164>

8000b814 <.L156>:
    case CLK_SRC_GROUP_AXI1:
        status = status_clk_shared_axi1;
8000b814:	6795                	lui	a5,0x5
8000b816:	5f678793          	add	a5,a5,1526 # 55f6 <__DLM_segment_used_size__+0x15f6>
8000b81a:	ce3e                	sw	a5,28(sp)
        break;
8000b81c:	a02d                	j	8000b846 <.L164>

8000b81e <.L155>:
    case CLK_SRC_GROUP_AXI2:
        status = status_clk_shared_axi2;
8000b81e:	6795                	lui	a5,0x5
8000b820:	5f778793          	add	a5,a5,1527 # 55f7 <__DLM_segment_used_size__+0x15f7>
8000b824:	ce3e                	sw	a5,28(sp)
        break;
8000b826:	a005                	j	8000b846 <.L164>

8000b828 <.L154>:
    case CLK_SRC_GROUP_CPU0:
        status = status_clk_shared_cpu0;
8000b828:	6795                	lui	a5,0x5
8000b82a:	5f878793          	add	a5,a5,1528 # 55f8 <__DLM_segment_used_size__+0x15f8>
8000b82e:	ce3e                	sw	a5,28(sp)
        break;
8000b830:	a819                	j	8000b846 <.L164>

8000b832 <.L153>:
    case CLK_SRC_GROUP_CPU1:
        status = status_clk_shared_cpu1;
8000b832:	6795                	lui	a5,0x5
8000b834:	5f978793          	add	a5,a5,1529 # 55f9 <__DLM_segment_used_size__+0x15f9>
8000b838:	ce3e                	sw	a5,28(sp)
        break;
8000b83a:	a031                	j	8000b846 <.L164>

8000b83c <.L150>:
    default:
        status = status_clk_src_invalid;
8000b83c:	6795                	lui	a5,0x5
8000b83e:	5f178793          	add	a5,a5,1521 # 55f1 <__DLM_segment_used_size__+0x15f1>
8000b842:	ce3e                	sw	a5,28(sp)
        break;
8000b844:	0001                	nop

8000b846 <.L164>:
    }

    return status;
8000b846:	47f2                	lw	a5,28(sp)
}
8000b848:	853e                	mv	a0,a5
8000b84a:	50b2                	lw	ra,44(sp)
8000b84c:	6145                	add	sp,sp,48
8000b84e:	8082                	ret

Disassembly of section .text.clock_add_to_group:

8000b850 <clock_add_to_group>:
{
    switch_ip_clock(clock_name, CLOCK_OFF);
}

void clock_add_to_group(clock_name_t clock_name, uint32_t group)
{
8000b850:	7179                	add	sp,sp,-48
8000b852:	d606                	sw	ra,44(sp)
8000b854:	c62a                	sw	a0,12(sp)
8000b856:	c42e                	sw	a1,8(sp)
    uint32_t resource = GET_CLK_RESOURCE_FROM_NAME(clock_name);
8000b858:	47b2                	lw	a5,12(sp)
8000b85a:	83c1                	srl	a5,a5,0x10
8000b85c:	ce3e                	sw	a5,28(sp)

    if (resource < sysctl_resource_end) {
8000b85e:	4772                	lw	a4,28(sp)
8000b860:	15d00793          	li	a5,349
8000b864:	00e7ef63          	bltu	a5,a4,8000b882 <.L175>
        sysctl_enable_group_resource(HPM_SYSCTL, group, resource, true);
8000b868:	47a2                	lw	a5,8(sp)
8000b86a:	0ff7f793          	zext.b	a5,a5
8000b86e:	4772                	lw	a4,28(sp)
8000b870:	0742                	sll	a4,a4,0x10
8000b872:	8341                	srl	a4,a4,0x10
8000b874:	4685                	li	a3,1
8000b876:	863a                	mv	a2,a4
8000b878:	85be                	mv	a1,a5
8000b87a:	f4000537          	lui	a0,0xf4000
8000b87e:	13f030ef          	jal	8000f1bc <sysctl_enable_group_resource>

8000b882 <.L175>:
    }
}
8000b882:	0001                	nop
8000b884:	50b2                	lw	ra,44(sp)
8000b886:	6145                	add	sp,sp,48
8000b888:	8082                	ret

Disassembly of section .text.clock_update_core_clock:

8000b88a <clock_update_core_clock>:
    while (hpm_csr_get_core_cycle() < expected_ticks) {
    }
}

void clock_update_core_clock(void)
{
8000b88a:	1101                	add	sp,sp,-32
8000b88c:	ce06                	sw	ra,28(sp)

8000b88e <.LBB17>:
    uint32_t hart_id = read_csr(CSR_MHARTID);
8000b88e:	f14027f3          	csrr	a5,mhartid
8000b892:	c63e                	sw	a5,12(sp)
8000b894:	47b2                	lw	a5,12(sp)

8000b896 <.LBE17>:
8000b896:	c43e                	sw	a5,8(sp)
    clock_name_t cpu_clk_name = (hart_id == 1U) ? clock_cpu1 : clock_cpu0;
8000b898:	4722                	lw	a4,8(sp)
8000b89a:	4785                	li	a5,1
8000b89c:	00f71663          	bne	a4,a5,8000b8a8 <.L202>
8000b8a0:	000807b7          	lui	a5,0x80
8000b8a4:	0789                	add	a5,a5,2 # 80002 <__DLM_segment_start__+0x2>
8000b8a6:	a011                	j	8000b8aa <.L203>

8000b8a8 <.L202>:
8000b8a8:	4781                	li	a5,0

8000b8aa <.L203>:
8000b8aa:	c23e                	sw	a5,4(sp)
    hpm_core_clock = clock_get_frequency(cpu_clk_name);
8000b8ac:	4512                	lw	a0,4(sp)
8000b8ae:	3b51                	jal	8000b642 <clock_get_frequency>
8000b8b0:	872a                	mv	a4,a0
8000b8b2:	82e22823          	sw	a4,-2000(tp) # fffff830 <__APB_SRAM_segment_end__+0xbf0d830>
8000b8b6:	0001                	nop
8000b8b8:	40f2                	lw	ra,28(sp)
8000b8ba:	6105                	add	sp,sp,32
8000b8bc:	8082                	ret

Disassembly of section .text.sysctl_resource_target_is_busy:

8000b8be <sysctl_resource_target_is_busy>:
 * @param[in] ptr SYSCTL_Type base address
 * @param[in] resource target resource index
 * @return true if target resource is busy
 */
static inline bool sysctl_resource_target_is_busy(SYSCTL_Type *ptr, sysctl_resource_t resource)
{
8000b8be:	1141                	add	sp,sp,-16
8000b8c0:	c62a                	sw	a0,12(sp)
8000b8c2:	87ae                	mv	a5,a1
8000b8c4:	00f11523          	sh	a5,10(sp)
    return ptr->RESOURCE[resource] & SYSCTL_RESOURCE_LOC_BUSY_MASK;
8000b8c8:	00a15783          	lhu	a5,10(sp)
8000b8cc:	4732                	lw	a4,12(sp)
8000b8ce:	078a                	sll	a5,a5,0x2
8000b8d0:	97ba                	add	a5,a5,a4
8000b8d2:	4398                	lw	a4,0(a5)
8000b8d4:	400007b7          	lui	a5,0x40000
8000b8d8:	8ff9                	and	a5,a5,a4
8000b8da:	00f037b3          	snez	a5,a5
8000b8de:	0ff7f793          	zext.b	a5,a5
}
8000b8e2:	853e                	mv	a0,a5
8000b8e4:	0141                	add	sp,sp,16
8000b8e6:	8082                	ret

Disassembly of section .text.sysctl_clock_target_is_busy:

8000b8e8 <sysctl_clock_target_is_busy>:
 * @param[in] clock target clock
 * @return true if target clock is busy
 */
static inline bool sysctl_clock_target_is_busy(SYSCTL_Type *ptr,
                                               clock_node_t clock)
{
8000b8e8:	1141                	add	sp,sp,-16
8000b8ea:	c62a                	sw	a0,12(sp)
8000b8ec:	87ae                	mv	a5,a1
8000b8ee:	00f105a3          	sb	a5,11(sp)
    return ptr->CLOCK[clock] & SYSCTL_CLOCK_LOC_BUSY_MASK;
8000b8f2:	00b14783          	lbu	a5,11(sp)
8000b8f6:	4732                	lw	a4,12(sp)
8000b8f8:	60078793          	add	a5,a5,1536 # 40000600 <__SDRAM_segment_start__+0x600>
8000b8fc:	078a                	sll	a5,a5,0x2
8000b8fe:	97ba                	add	a5,a5,a4
8000b900:	4398                	lw	a4,0(a5)
8000b902:	400007b7          	lui	a5,0x40000
8000b906:	8ff9                	and	a5,a5,a4
8000b908:	00f037b3          	snez	a5,a5
8000b90c:	0ff7f793          	zext.b	a5,a5
}
8000b910:	853e                	mv	a0,a5
8000b912:	0141                	add	sp,sp,16
8000b914:	8082                	ret

Disassembly of section .text.sysctl_set_cpu_entry:

8000b916 <sysctl_set_cpu_entry>:
    }
    return frequency;
}

hpm_stat_t sysctl_set_cpu_entry(SYSCTL_Type *ptr, uint8_t cpu, uint32_t entry)
{
8000b916:	1101                	add	sp,sp,-32
8000b918:	ce06                	sw	ra,28(sp)
8000b91a:	c62a                	sw	a0,12(sp)
8000b91c:	87ae                	mv	a5,a1
8000b91e:	c232                	sw	a2,4(sp)
8000b920:	00f105a3          	sb	a5,11(sp)
    if (!sysctl_valid_cpu_index(cpu)) {
8000b924:	00b14783          	lbu	a5,11(sp)
8000b928:	853e                	mv	a0,a5
8000b92a:	06f030ef          	jal	8000f198 <sysctl_valid_cpu_index>
8000b92e:	87aa                	mv	a5,a0
8000b930:	0017c793          	xor	a5,a5,1
8000b934:	0ff7f793          	zext.b	a5,a5
8000b938:	c399                	beqz	a5,8000b93e <.L53>
        return status_invalid_argument;
8000b93a:	4789                	li	a5,2
8000b93c:	a081                	j	8000b97c <.L54>

8000b93e <.L53>:
    }
    ptr->CPU[cpu].GPR[0] = entry;
8000b93e:	00b14783          	lbu	a5,11(sp)
8000b942:	4732                	lw	a4,12(sp)
8000b944:	07a9                	add	a5,a5,10 # 4000000a <__SDRAM_segment_start__+0xa>
8000b946:	07aa                	sll	a5,a5,0xa
8000b948:	97ba                	add	a5,a5,a4
8000b94a:	4712                	lw	a4,4(sp)
8000b94c:	c798                	sw	a4,8(a5)
    ptr->CPU[cpu].GPR[1] = SYSCTL_CPU_RELEASE_KEY(cpu);
8000b94e:	00b14783          	lbu	a5,11(sp)
8000b952:	01879713          	sll	a4,a5,0x18
8000b956:	010007b7          	lui	a5,0x1000
8000b95a:	00f776b3          	and	a3,a4,a5
8000b95e:	00b14783          	lbu	a5,11(sp)
8000b962:	c0bef737          	lui	a4,0xc0bef
8000b966:	1a970713          	add	a4,a4,425 # c0bef1a9 <__FLASH_segment_end__+0x403ef1a9>
8000b96a:	8f55                	or	a4,a4,a3
8000b96c:	46b2                	lw	a3,12(sp)
8000b96e:	07aa                	sll	a5,a5,0xa
8000b970:	97b6                	add	a5,a5,a3
8000b972:	668d                	lui	a3,0x3
8000b974:	97b6                	add	a5,a5,a3
8000b976:	80e7a623          	sw	a4,-2036(a5) # fff80c <__SDRAM_segment_size__+0x3ff80c>
    return status_success;
8000b97a:	4781                	li	a5,0

8000b97c <.L54>:
}
8000b97c:	853e                	mv	a0,a5
8000b97e:	40f2                	lw	ra,28(sp)
8000b980:	6105                	add	sp,sp,32
8000b982:	8082                	ret

Disassembly of section .text.sysctl_config_clock:

8000b984 <sysctl_config_clock>:
    return status_success;
}

hpm_stat_t sysctl_config_clock(SYSCTL_Type *ptr, clock_node_t node,
                                clock_source_t source, uint32_t divide_by)
{
8000b984:	1101                	add	sp,sp,-32
8000b986:	ce06                	sw	ra,28(sp)
8000b988:	c62a                	sw	a0,12(sp)
8000b98a:	87ae                	mv	a5,a1
8000b98c:	8732                	mv	a4,a2
8000b98e:	c236                	sw	a3,4(sp)
8000b990:	00f105a3          	sb	a5,11(sp)
8000b994:	87ba                	mv	a5,a4
8000b996:	00f10523          	sb	a5,10(sp)
    if (node >= clock_node_adc_i2s_start) {
8000b99a:	00b14703          	lbu	a4,11(sp)
8000b99e:	04200793          	li	a5,66
8000b9a2:	00e7f463          	bgeu	a5,a4,8000b9aa <.L114>
        return status_invalid_argument;
8000b9a6:	4789                	li	a5,2
8000b9a8:	a89d                	j	8000ba1e <.L115>

8000b9aa <.L114>:
    }

    if (source >= clock_source_general_source_end) {
8000b9aa:	00a14703          	lbu	a4,10(sp)
8000b9ae:	479d                	li	a5,7
8000b9b0:	00e7f463          	bgeu	a5,a4,8000b9b8 <.L116>
        return status_invalid_argument;
8000b9b4:	4789                	li	a5,2
8000b9b6:	a0a5                	j	8000ba1e <.L115>

8000b9b8 <.L116>:
    }
    ptr->CLOCK[node] = (ptr->CLOCK[node] &
8000b9b8:	00b14783          	lbu	a5,11(sp)
8000b9bc:	4732                	lw	a4,12(sp)
8000b9be:	60078793          	add	a5,a5,1536
8000b9c2:	078a                	sll	a5,a5,0x2
8000b9c4:	97ba                	add	a5,a5,a4
8000b9c6:	4398                	lw	a4,0(a5)
8000b9c8:	77fd                	lui	a5,0xfffff
8000b9ca:	00f776b3          	and	a3,a4,a5
            ~(SYSCTL_CLOCK_MUX_MASK | SYSCTL_CLOCK_DIV_MASK))
            | (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
8000b9ce:	00a14783          	lbu	a5,10(sp)
8000b9d2:	00879713          	sll	a4,a5,0x8
8000b9d6:	6785                	lui	a5,0x1
8000b9d8:	f0078793          	add	a5,a5,-256 # f00 <__NOR_CFG_OPTION_segment_size__+0x300>
8000b9dc:	8f7d                	and	a4,a4,a5
8000b9de:	4792                	lw	a5,4(sp)
8000b9e0:	17fd                	add	a5,a5,-1
8000b9e2:	0ff7f793          	zext.b	a5,a5
8000b9e6:	8f5d                	or	a4,a4,a5
    ptr->CLOCK[node] = (ptr->CLOCK[node] &
8000b9e8:	00b14783          	lbu	a5,11(sp)
            | (SYSCTL_CLOCK_MUX_SET(source) | SYSCTL_CLOCK_DIV_SET(divide_by - 1));
8000b9ec:	8f55                	or	a4,a4,a3
    ptr->CLOCK[node] = (ptr->CLOCK[node] &
8000b9ee:	46b2                	lw	a3,12(sp)
8000b9f0:	60078793          	add	a5,a5,1536
8000b9f4:	078a                	sll	a5,a5,0x2
8000b9f6:	97b6                	add	a5,a5,a3
8000b9f8:	c398                	sw	a4,0(a5)
    while (sysctl_clock_target_is_busy(ptr, node)) {
8000b9fa:	0001                	nop

8000b9fc <.L117>:
8000b9fc:	00b14783          	lbu	a5,11(sp)
8000ba00:	85be                	mv	a1,a5
8000ba02:	4532                	lw	a0,12(sp)
8000ba04:	35d5                	jal	8000b8e8 <sysctl_clock_target_is_busy>
8000ba06:	87aa                	mv	a5,a0
8000ba08:	fbf5                	bnez	a5,8000b9fc <.L117>
    }

    if ((node == clock_node_cpu0) || (node == clock_node_cpu1)) {
8000ba0a:	00b14783          	lbu	a5,11(sp)
8000ba0e:	c791                	beqz	a5,8000ba1a <.L118>
8000ba10:	00b14703          	lbu	a4,11(sp)
8000ba14:	4789                	li	a5,2
8000ba16:	00f71363          	bne	a4,a5,8000ba1c <.L119>

8000ba1a <.L118>:
        clock_update_core_clock();
8000ba1a:	3d85                	jal	8000b88a <clock_update_core_clock>

8000ba1c <.L119>:
    }
    return status_success;
8000ba1c:	4781                	li	a5,0

8000ba1e <.L115>:
}
8000ba1e:	853e                	mv	a0,a5
8000ba20:	40f2                	lw	ra,28(sp)
8000ba22:	6105                	add	sp,sp,32
8000ba24:	8082                	ret

Disassembly of section .text.system_init:

8000ba26 <system_init>:
#endif
    __plic_set_feature(HPM_PLIC_BASE, plic_feature);
}

__attribute__((weak)) void system_init(void)
{
8000ba26:	7179                	add	sp,sp,-48
8000ba28:	d606                	sw	ra,44(sp)
8000ba2a:	47a1                	li	a5,8
8000ba2c:	c83e                	sw	a5,16(sp)

8000ba2e <.LBB16>:
 * @param[in] mask interrupt mask to be disabled
 * @retval current mstatus value before irq mask is disabled
 */
ATTR_ALWAYS_INLINE static inline uint32_t disable_global_irq(uint32_t mask)
{
    return read_clear_csr(CSR_MSTATUS, mask);
8000ba2e:	c602                	sw	zero,12(sp)
8000ba30:	47c2                	lw	a5,16(sp)
8000ba32:	3007b7f3          	csrrc	a5,mstatus,a5
8000ba36:	c63e                	sw	a5,12(sp)
8000ba38:	47b2                	lw	a5,12(sp)

8000ba3a <.LBE18>:
8000ba3a:	0001                	nop

8000ba3c <.LBB19>:
 * @brief   Disable IRQ from interrupt controller
 *
 */
ATTR_ALWAYS_INLINE static inline void disable_irq_from_intc(void)
{
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
8000ba3c:	6785                	lui	a5,0x1
8000ba3e:	80078793          	add	a5,a5,-2048 # 800 <__ILM_segment_used_end__+0x13a>
8000ba42:	3047b073          	csrc	mie,a5
}
8000ba46:	0001                	nop

8000ba48 <.LBE19>:
    disable_global_irq(CSR_MSTATUS_MIE_MASK);
    disable_irq_from_intc();
    enable_plic_feature();
8000ba48:	09d030ef          	jal	8000f2e4 <enable_plic_feature>

8000ba4c <.LBB21>:
    set_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
8000ba4c:	6785                	lui	a5,0x1
8000ba4e:	80078793          	add	a5,a5,-2048 # 800 <__ILM_segment_used_end__+0x13a>
8000ba52:	3047a073          	csrs	mie,a5
}
8000ba56:	0001                	nop
8000ba58:	47a1                	li	a5,8
8000ba5a:	ca3e                	sw	a5,20(sp)

8000ba5c <.LBB23>:
    set_csr(CSR_MSTATUS, mask);
8000ba5c:	47d2                	lw	a5,20(sp)
8000ba5e:	3007a073          	csrs	mstatus,a5
}
8000ba62:	0001                	nop

8000ba64 <.LBB25>:
#if !CONFIG_DISABLE_GLOBAL_IRQ_ON_STARTUP
    enable_global_irq(CSR_MSTATUS_MIE_MASK);
#endif

#ifndef CONFIG_NOT_ENALBE_ACCESS_TO_CYCLE_CSR
    uint32_t mcounteren = read_csr(CSR_MCOUNTEREN);
8000ba64:	306027f3          	csrr	a5,mcounteren
8000ba68:	ce3e                	sw	a5,28(sp)
8000ba6a:	47f2                	lw	a5,28(sp)

8000ba6c <.LBE25>:
8000ba6c:	cc3e                	sw	a5,24(sp)
    write_csr(CSR_MCOUNTEREN, mcounteren | 1); /* Enable MCYCLE */
8000ba6e:	47e2                	lw	a5,24(sp)
8000ba70:	0017e793          	or	a5,a5,1
8000ba74:	30679073          	csrw	mcounteren,a5
#endif

#if defined(CONFIG_ENABLE_BPOR_RETENTION) && CONFIG_ENABLE_BPOR_RETENTION
    bpor_enable_reg_value_retention(HPM_BPOR);
#endif
}
8000ba78:	0001                	nop
8000ba7a:	50b2                	lw	ra,44(sp)
8000ba7c:	6145                	add	sp,sp,48
8000ba7e:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_xtoa:

8000ba80 <__SEGGER_RTL_xltoa>:
8000ba80:	882a                	mv	a6,a0
8000ba82:	88ae                	mv	a7,a1
8000ba84:	852e                	mv	a0,a1
8000ba86:	ca89                	beqz	a3,8000ba98 <.L2>
8000ba88:	02d00793          	li	a5,45
8000ba8c:	00158893          	add	a7,a1,1
8000ba90:	00f58023          	sb	a5,0(a1)
8000ba94:	41000833          	neg	a6,a6

8000ba98 <.L2>:
8000ba98:	8746                	mv	a4,a7
8000ba9a:	4325                	li	t1,9

8000ba9c <.L5>:
8000ba9c:	02c876b3          	remu	a3,a6,a2
8000baa0:	85c2                	mv	a1,a6
8000baa2:	0ff6f793          	zext.b	a5,a3
8000baa6:	02c85833          	divu	a6,a6,a2
8000baaa:	02d37d63          	bgeu	t1,a3,8000bae4 <.L3>
8000baae:	05778793          	add	a5,a5,87

8000bab2 <.L11>:
8000bab2:	0ff7f793          	zext.b	a5,a5
8000bab6:	00f70023          	sb	a5,0(a4)
8000baba:	00170693          	add	a3,a4,1
8000babe:	02c5f163          	bgeu	a1,a2,8000bae0 <.L8>
8000bac2:	000700a3          	sb	zero,1(a4)

8000bac6 <.L6>:
8000bac6:	0008c683          	lbu	a3,0(a7)
8000baca:	00074783          	lbu	a5,0(a4)
8000bace:	0885                	add	a7,a7,1
8000bad0:	177d                	add	a4,a4,-1
8000bad2:	00d700a3          	sb	a3,1(a4)
8000bad6:	fef88fa3          	sb	a5,-1(a7)
8000bada:	fee8e6e3          	bltu	a7,a4,8000bac6 <.L6>
8000bade:	8082                	ret

8000bae0 <.L8>:
8000bae0:	8736                	mv	a4,a3
8000bae2:	bf6d                	j	8000ba9c <.L5>

8000bae4 <.L3>:
8000bae4:	03078793          	add	a5,a5,48
8000bae8:	b7e9                	j	8000bab2 <.L11>

Disassembly of section .text.libc.itoa:

8000baea <itoa>:
8000baea:	46a9                	li	a3,10
8000baec:	87aa                	mv	a5,a0
8000baee:	882e                	mv	a6,a1
8000baf0:	8732                	mv	a4,a2
8000baf2:	00d61563          	bne	a2,a3,8000bafc <.L301>
8000baf6:	4685                	li	a3,1
8000baf8:	00054663          	bltz	a0,8000bb04 <.L302>

8000bafc <.L301>:
8000bafc:	4681                	li	a3,0
8000bafe:	863a                	mv	a2,a4
8000bb00:	85c2                	mv	a1,a6
8000bb02:	853e                	mv	a0,a5

8000bb04 <.L302>:
8000bb04:	bfb5                	j	8000ba80 <__SEGGER_RTL_xltoa>

Disassembly of section .text.libc.__SEGGER_RTL_SIGNAL_SIG_ERR:

8000bb06 <__SEGGER_RTL_SIGNAL_SIG_ERR>:
8000bb06:	8082                	ret

Disassembly of section .text.libc.fwrite:

8000bb08 <fwrite>:
8000bb08:	1101                	add	sp,sp,-32
8000bb0a:	c64e                	sw	s3,12(sp)
8000bb0c:	89aa                	mv	s3,a0
8000bb0e:	8536                	mv	a0,a3
8000bb10:	cc22                	sw	s0,24(sp)
8000bb12:	ca26                	sw	s1,20(sp)
8000bb14:	c84a                	sw	s2,16(sp)
8000bb16:	ce06                	sw	ra,28(sp)
8000bb18:	84ae                	mv	s1,a1
8000bb1a:	8432                	mv	s0,a2
8000bb1c:	8936                	mv	s2,a3
8000bb1e:	03d010ef          	jal	8000d35a <__SEGGER_RTL_X_file_stat>
8000bb22:	02054463          	bltz	a0,8000bb4a <.L43>
8000bb26:	02848633          	mul	a2,s1,s0
8000bb2a:	4501                	li	a0,0
8000bb2c:	00966863          	bltu	a2,s1,8000bb3c <.L41>
8000bb30:	85ce                	mv	a1,s3
8000bb32:	854a                	mv	a0,s2
8000bb34:	7b2010ef          	jal	8000d2e6 <__SEGGER_RTL_X_file_write>
8000bb38:	02955533          	divu	a0,a0,s1

8000bb3c <.L41>:
8000bb3c:	40f2                	lw	ra,28(sp)
8000bb3e:	4462                	lw	s0,24(sp)
8000bb40:	44d2                	lw	s1,20(sp)
8000bb42:	4942                	lw	s2,16(sp)
8000bb44:	49b2                	lw	s3,12(sp)
8000bb46:	6105                	add	sp,sp,32
8000bb48:	8082                	ret

8000bb4a <.L43>:
8000bb4a:	4501                	li	a0,0
8000bb4c:	bfc5                	j	8000bb3c <.L41>

Disassembly of section .text.libc.__subsf3:

8000bb4e <__subsf3>:
8000bb4e:	80000637          	lui	a2,0x80000
8000bb52:	8db1                	xor	a1,a1,a2
8000bb54:	a009                	j	8000bb56 <__addsf3>

Disassembly of section .text.libc.__addsf3:

8000bb56 <__addsf3>:
8000bb56:	80000637          	lui	a2,0x80000
8000bb5a:	00b546b3          	xor	a3,a0,a1
8000bb5e:	0806ca63          	bltz	a3,8000bbf2 <.L__addsf3_subtract>
8000bb62:	00b57563          	bgeu	a0,a1,8000bb6c <.L__addsf3_add_already_ordered>
8000bb66:	86aa                	mv	a3,a0
8000bb68:	852e                	mv	a0,a1
8000bb6a:	85b6                	mv	a1,a3

8000bb6c <.L__addsf3_add_already_ordered>:
8000bb6c:	00151713          	sll	a4,a0,0x1
8000bb70:	8361                	srl	a4,a4,0x18
8000bb72:	00159693          	sll	a3,a1,0x1
8000bb76:	82e1                	srl	a3,a3,0x18
8000bb78:	0ff00293          	li	t0,255
8000bb7c:	06570563          	beq	a4,t0,8000bbe6 <.L__addsf3_add_inf_or_nan>
8000bb80:	c325                	beqz	a4,8000bbe0 <.L__addsf3_zero>
8000bb82:	ceb1                	beqz	a3,8000bbde <.L__addsf3_add_done>
8000bb84:	40d706b3          	sub	a3,a4,a3
8000bb88:	42e1                	li	t0,24
8000bb8a:	04d2ca63          	blt	t0,a3,8000bbde <.L__addsf3_add_done>
8000bb8e:	05a2                	sll	a1,a1,0x8
8000bb90:	8dd1                	or	a1,a1,a2
8000bb92:	01755713          	srl	a4,a0,0x17
8000bb96:	0522                	sll	a0,a0,0x8
8000bb98:	8d51                	or	a0,a0,a2
8000bb9a:	47e5                	li	a5,25
8000bb9c:	8f95                	sub	a5,a5,a3
8000bb9e:	00f59633          	sll	a2,a1,a5
8000bba2:	821d                	srl	a2,a2,0x7
8000bba4:	00d5d5b3          	srl	a1,a1,a3
8000bba8:	00b507b3          	add	a5,a0,a1
8000bbac:	00a7f463          	bgeu	a5,a0,8000bbb4 <.L__addsf3_add_no_normalization>
8000bbb0:	8385                	srl	a5,a5,0x1
8000bbb2:	0709                	add	a4,a4,2

8000bbb4 <.L__addsf3_add_no_normalization>:
8000bbb4:	177d                	add	a4,a4,-1
8000bbb6:	0ff77593          	zext.b	a1,a4
8000bbba:	f0158593          	add	a1,a1,-255
8000bbbe:	cd91                	beqz	a1,8000bbda <.L__addsf3_inf>
8000bbc0:	075e                	sll	a4,a4,0x17
8000bbc2:	0087d513          	srl	a0,a5,0x8
8000bbc6:	07e2                	sll	a5,a5,0x18
8000bbc8:	8fd1                	or	a5,a5,a2
8000bbca:	0007d663          	bgez	a5,8000bbd6 <.L__addsf3_no_tie>
8000bbce:	0786                	sll	a5,a5,0x1
8000bbd0:	0505                	add	a0,a0,1 # f4000001 <__AHB_SRAM_segment_end__+0x3cf8001>
8000bbd2:	e391                	bnez	a5,8000bbd6 <.L__addsf3_no_tie>
8000bbd4:	9979                	and	a0,a0,-2

8000bbd6 <.L__addsf3_no_tie>:
8000bbd6:	953a                	add	a0,a0,a4
8000bbd8:	8082                	ret

8000bbda <.L__addsf3_inf>:
8000bbda:	01771513          	sll	a0,a4,0x17

8000bbde <.L__addsf3_add_done>:
8000bbde:	8082                	ret

8000bbe0 <.L__addsf3_zero>:
8000bbe0:	817d                	srl	a0,a0,0x1f
8000bbe2:	057e                	sll	a0,a0,0x1f
8000bbe4:	8082                	ret

8000bbe6 <.L__addsf3_add_inf_or_nan>:
8000bbe6:	00951613          	sll	a2,a0,0x9
8000bbea:	da75                	beqz	a2,8000bbde <.L__addsf3_add_done>

8000bbec <.L__addsf3_return_nan>:
8000bbec:	7fc00537          	lui	a0,0x7fc00
8000bbf0:	8082                	ret

8000bbf2 <.L__addsf3_subtract>:
8000bbf2:	8db1                	xor	a1,a1,a2
8000bbf4:	40b506b3          	sub	a3,a0,a1
8000bbf8:	00b57563          	bgeu	a0,a1,8000bc02 <.L__addsf3_sub_already_ordered>
8000bbfc:	8eb1                	xor	a3,a3,a2
8000bbfe:	8d15                	sub	a0,a0,a3
8000bc00:	95b6                	add	a1,a1,a3

8000bc02 <.L__addsf3_sub_already_ordered>:
8000bc02:	00159693          	sll	a3,a1,0x1
8000bc06:	82e1                	srl	a3,a3,0x18
8000bc08:	00151713          	sll	a4,a0,0x1
8000bc0c:	8361                	srl	a4,a4,0x18
8000bc0e:	05a2                	sll	a1,a1,0x8
8000bc10:	8dd1                	or	a1,a1,a2
8000bc12:	0ff00293          	li	t0,255
8000bc16:	0c570c63          	beq	a4,t0,8000bcee <.L__addsf3_sub_inf_or_nan>
8000bc1a:	c2f5                	beqz	a3,8000bcfe <.L__addsf3_sub_zero>
8000bc1c:	40d706b3          	sub	a3,a4,a3
8000bc20:	c695                	beqz	a3,8000bc4c <.L__addsf3_exponents_equal>
8000bc22:	4285                	li	t0,1
8000bc24:	08569063          	bne	a3,t0,8000bca4 <.L__addsf3_exponents_differ_by_more_than_1>
8000bc28:	01755693          	srl	a3,a0,0x17
8000bc2c:	0526                	sll	a0,a0,0x9
8000bc2e:	00b532b3          	sltu	t0,a0,a1
8000bc32:	8d0d                	sub	a0,a0,a1
8000bc34:	02029263          	bnez	t0,8000bc58 <.L__addsf3_normalization_steps>
8000bc38:	06de                	sll	a3,a3,0x17
8000bc3a:	01751593          	sll	a1,a0,0x17
8000bc3e:	8125                	srl	a0,a0,0x9
8000bc40:	0005d463          	bgez	a1,8000bc48 <.L__addsf3_sub_no_tie_single>
8000bc44:	0505                	add	a0,a0,1 # 7fc00001 <__NONCACHEABLE_RAM_segment_end__+0x3ec00001>
8000bc46:	9979                	and	a0,a0,-2

8000bc48 <.L__addsf3_sub_no_tie_single>:
8000bc48:	9536                	add	a0,a0,a3

8000bc4a <.L__addsf3_sub_done>:
8000bc4a:	8082                	ret

8000bc4c <.L__addsf3_exponents_equal>:
8000bc4c:	01755693          	srl	a3,a0,0x17
8000bc50:	0526                	sll	a0,a0,0x9
8000bc52:	0586                	sll	a1,a1,0x1
8000bc54:	8d0d                	sub	a0,a0,a1
8000bc56:	d975                	beqz	a0,8000bc4a <.L__addsf3_sub_done>

8000bc58 <.L__addsf3_normalization_steps>:
8000bc58:	4581                	li	a1,0
8000bc5a:	01055793          	srl	a5,a0,0x10
8000bc5e:	e399                	bnez	a5,8000bc64 <.L1^B1>
8000bc60:	0542                	sll	a0,a0,0x10
8000bc62:	05c1                	add	a1,a1,16

8000bc64 <.L1^B1>:
8000bc64:	01855793          	srl	a5,a0,0x18
8000bc68:	e399                	bnez	a5,8000bc6e <.L2^B1>
8000bc6a:	0522                	sll	a0,a0,0x8
8000bc6c:	05a1                	add	a1,a1,8

8000bc6e <.L2^B1>:
8000bc6e:	01c55793          	srl	a5,a0,0x1c
8000bc72:	e399                	bnez	a5,8000bc78 <.L3^B1>
8000bc74:	0512                	sll	a0,a0,0x4
8000bc76:	0591                	add	a1,a1,4

8000bc78 <.L3^B1>:
8000bc78:	01e55793          	srl	a5,a0,0x1e
8000bc7c:	e399                	bnez	a5,8000bc82 <.L4^B1>
8000bc7e:	050a                	sll	a0,a0,0x2
8000bc80:	0589                	add	a1,a1,2

8000bc82 <.L4^B1>:
8000bc82:	00054463          	bltz	a0,8000bc8a <.L5^B1>
8000bc86:	0506                	sll	a0,a0,0x1
8000bc88:	0585                	add	a1,a1,1

8000bc8a <.L5^B1>:
8000bc8a:	0585                	add	a1,a1,1
8000bc8c:	0506                	sll	a0,a0,0x1
8000bc8e:	00e5f763          	bgeu	a1,a4,8000bc9c <.L__addsf3_underflow>
8000bc92:	8e8d                	sub	a3,a3,a1
8000bc94:	06de                	sll	a3,a3,0x17
8000bc96:	8125                	srl	a0,a0,0x9
8000bc98:	9536                	add	a0,a0,a3
8000bc9a:	8082                	ret

8000bc9c <.L__addsf3_underflow>:
8000bc9c:	0086d513          	srl	a0,a3,0x8
8000bca0:	057e                	sll	a0,a0,0x1f
8000bca2:	8082                	ret

8000bca4 <.L__addsf3_exponents_differ_by_more_than_1>:
8000bca4:	42e5                	li	t0,25
8000bca6:	fad2e2e3          	bltu	t0,a3,8000bc4a <.L__addsf3_sub_done>
8000bcaa:	0685                	add	a3,a3,1 # 3001 <__APB_SRAM_segment_size__+0x1001>
8000bcac:	40d00733          	neg	a4,a3
8000bcb0:	00e59733          	sll	a4,a1,a4
8000bcb4:	00d5d5b3          	srl	a1,a1,a3
8000bcb8:	00e03733          	snez	a4,a4
8000bcbc:	95ae                	add	a1,a1,a1
8000bcbe:	95ba                	add	a1,a1,a4
8000bcc0:	01755693          	srl	a3,a0,0x17
8000bcc4:	0522                	sll	a0,a0,0x8
8000bcc6:	8d51                	or	a0,a0,a2
8000bcc8:	40b50733          	sub	a4,a0,a1
8000bccc:	00074463          	bltz	a4,8000bcd4 <.L__addsf3_sub_already_normalized>
8000bcd0:	070a                	sll	a4,a4,0x2
8000bcd2:	8305                	srl	a4,a4,0x1

8000bcd4 <.L__addsf3_sub_already_normalized>:
8000bcd4:	16fd                	add	a3,a3,-1
8000bcd6:	06de                	sll	a3,a3,0x17
8000bcd8:	00875513          	srl	a0,a4,0x8
8000bcdc:	0762                	sll	a4,a4,0x18
8000bcde:	00075663          	bgez	a4,8000bcea <.L__addsf3_sub_no_tie>
8000bce2:	0706                	sll	a4,a4,0x1
8000bce4:	0505                	add	a0,a0,1
8000bce6:	e311                	bnez	a4,8000bcea <.L__addsf3_sub_no_tie>
8000bce8:	9979                	and	a0,a0,-2

8000bcea <.L__addsf3_sub_no_tie>:
8000bcea:	9536                	add	a0,a0,a3
8000bcec:	8082                	ret

8000bcee <.L__addsf3_sub_inf_or_nan>:
8000bcee:	0ff00293          	li	t0,255
8000bcf2:	ee568de3          	beq	a3,t0,8000bbec <.L__addsf3_return_nan>
8000bcf6:	00951593          	sll	a1,a0,0x9
8000bcfa:	d9a1                	beqz	a1,8000bc4a <.L__addsf3_sub_done>
8000bcfc:	bdc5                	j	8000bbec <.L__addsf3_return_nan>

8000bcfe <.L__addsf3_sub_zero>:
8000bcfe:	f731                	bnez	a4,8000bc4a <.L__addsf3_sub_done>
8000bd00:	4501                	li	a0,0
8000bd02:	8082                	ret

Disassembly of section .text.libc.__ltsf2:

8000bd04 <__ltsf2>:
8000bd04:	ff000637          	lui	a2,0xff000
8000bd08:	00151693          	sll	a3,a0,0x1
8000bd0c:	02d66763          	bltu	a2,a3,8000bd3a <.L__ltsf2_zero>
8000bd10:	00159693          	sll	a3,a1,0x1
8000bd14:	02d66363          	bltu	a2,a3,8000bd3a <.L__ltsf2_zero>
8000bd18:	00b56633          	or	a2,a0,a1
8000bd1c:	00161693          	sll	a3,a2,0x1
8000bd20:	ce89                	beqz	a3,8000bd3a <.L__ltsf2_zero>
8000bd22:	00064763          	bltz	a2,8000bd30 <.L__ltsf2_negative>
8000bd26:	00b53533          	sltu	a0,a0,a1
8000bd2a:	40a00533          	neg	a0,a0
8000bd2e:	8082                	ret

8000bd30 <.L__ltsf2_negative>:
8000bd30:	00a5b533          	sltu	a0,a1,a0
8000bd34:	40a00533          	neg	a0,a0
8000bd38:	8082                	ret

8000bd3a <.L__ltsf2_zero>:
8000bd3a:	4501                	li	a0,0
8000bd3c:	8082                	ret

Disassembly of section .text.libc.__lesf2:

8000bd3e <__lesf2>:
8000bd3e:	ff000637          	lui	a2,0xff000
8000bd42:	00151693          	sll	a3,a0,0x1
8000bd46:	02d66363          	bltu	a2,a3,8000bd6c <.L__lesf2_nan>
8000bd4a:	00159693          	sll	a3,a1,0x1
8000bd4e:	00d66f63          	bltu	a2,a3,8000bd6c <.L__lesf2_nan>
8000bd52:	00b56633          	or	a2,a0,a1
8000bd56:	00161693          	sll	a3,a2,0x1
8000bd5a:	ca99                	beqz	a3,8000bd70 <.L__lesf2_zero>
8000bd5c:	00064563          	bltz	a2,8000bd66 <.L__lesf2_negative>
8000bd60:	00a5b533          	sltu	a0,a1,a0
8000bd64:	8082                	ret

8000bd66 <.L__lesf2_negative>:
8000bd66:	00b53533          	sltu	a0,a0,a1
8000bd6a:	8082                	ret

8000bd6c <.L__lesf2_nan>:
8000bd6c:	4505                	li	a0,1
8000bd6e:	8082                	ret

8000bd70 <.L__lesf2_zero>:
8000bd70:	4501                	li	a0,0
8000bd72:	8082                	ret

Disassembly of section .text.libc.__gtsf2:

8000bd74 <__gtsf2>:
8000bd74:	ff000637          	lui	a2,0xff000
8000bd78:	00151693          	sll	a3,a0,0x1
8000bd7c:	02d66363          	bltu	a2,a3,8000bda2 <.L__gtsf2_zero>
8000bd80:	00159693          	sll	a3,a1,0x1
8000bd84:	00d66f63          	bltu	a2,a3,8000bda2 <.L__gtsf2_zero>
8000bd88:	00b56633          	or	a2,a0,a1
8000bd8c:	00161693          	sll	a3,a2,0x1
8000bd90:	ca89                	beqz	a3,8000bda2 <.L__gtsf2_zero>
8000bd92:	00064563          	bltz	a2,8000bd9c <.L__gtsf2_negative>
8000bd96:	00a5b533          	sltu	a0,a1,a0
8000bd9a:	8082                	ret

8000bd9c <.L__gtsf2_negative>:
8000bd9c:	00b53533          	sltu	a0,a0,a1
8000bda0:	8082                	ret

8000bda2 <.L__gtsf2_zero>:
8000bda2:	4501                	li	a0,0
8000bda4:	8082                	ret

Disassembly of section .text.libc.__gesf2:

8000bda6 <__gesf2>:
8000bda6:	ff000637          	lui	a2,0xff000
8000bdaa:	00151693          	sll	a3,a0,0x1
8000bdae:	02d66763          	bltu	a2,a3,8000bddc <.L__gesf2_nan>
8000bdb2:	00159693          	sll	a3,a1,0x1
8000bdb6:	02d66363          	bltu	a2,a3,8000bddc <.L__gesf2_nan>
8000bdba:	00b56633          	or	a2,a0,a1
8000bdbe:	00161693          	sll	a3,a2,0x1
8000bdc2:	ce99                	beqz	a3,8000bde0 <.L__gesf2_zero>
8000bdc4:	00064763          	bltz	a2,8000bdd2 <.L__gesf2_negative>
8000bdc8:	00b53533          	sltu	a0,a0,a1
8000bdcc:	40a00533          	neg	a0,a0
8000bdd0:	8082                	ret

8000bdd2 <.L__gesf2_negative>:
8000bdd2:	00a5b533          	sltu	a0,a1,a0
8000bdd6:	40a00533          	neg	a0,a0
8000bdda:	8082                	ret

8000bddc <.L__gesf2_nan>:
8000bddc:	557d                	li	a0,-1
8000bdde:	8082                	ret

8000bde0 <.L__gesf2_zero>:
8000bde0:	4501                	li	a0,0
8000bde2:	8082                	ret

Disassembly of section .text.libc.__fixunsdfsi:

8000bde4 <__fixunsdfsi>:
8000bde4:	0205c563          	bltz	a1,8000be0e <.L__fixunsdfsi_zero_result>
8000bde8:	0145d613          	srl	a2,a1,0x14
8000bdec:	c0160613          	add	a2,a2,-1023 # fefffc01 <__APB_SRAM_segment_end__+0xaf0dc01>
8000bdf0:	00064f63          	bltz	a2,8000be0e <.L__fixunsdfsi_zero_result>
8000bdf4:	477d                	li	a4,31
8000bdf6:	8f11                	sub	a4,a4,a2
8000bdf8:	00074d63          	bltz	a4,8000be12 <.L__fixunsdfsi_overflow_result>
8000bdfc:	8155                	srl	a0,a0,0x15
8000bdfe:	05ae                	sll	a1,a1,0xb
8000be00:	8d4d                	or	a0,a0,a1
8000be02:	800006b7          	lui	a3,0x80000
8000be06:	8d55                	or	a0,a0,a3
8000be08:	00e55533          	srl	a0,a0,a4
8000be0c:	8082                	ret

8000be0e <.L__fixunsdfsi_zero_result>:
8000be0e:	4501                	li	a0,0
8000be10:	8082                	ret

8000be12 <.L__fixunsdfsi_overflow_result>:
8000be12:	557d                	li	a0,-1
8000be14:	8082                	ret

Disassembly of section .text.libc.__floatundisf:

8000be16 <__floatundisf>:
8000be16:	c5bd                	beqz	a1,8000be84 <.L__floatundisf_high_word_zero>
8000be18:	4701                	li	a4,0
8000be1a:	0105d693          	srl	a3,a1,0x10
8000be1e:	e299                	bnez	a3,8000be24 <.L8^B3>
8000be20:	0741                	add	a4,a4,16
8000be22:	05c2                	sll	a1,a1,0x10

8000be24 <.L8^B3>:
8000be24:	0185d693          	srl	a3,a1,0x18
8000be28:	e299                	bnez	a3,8000be2e <.L4^B10>
8000be2a:	0721                	add	a4,a4,8
8000be2c:	05a2                	sll	a1,a1,0x8

8000be2e <.L4^B10>:
8000be2e:	01c5d693          	srl	a3,a1,0x1c
8000be32:	e299                	bnez	a3,8000be38 <.L2^B10>
8000be34:	0711                	add	a4,a4,4
8000be36:	0592                	sll	a1,a1,0x4

8000be38 <.L2^B10>:
8000be38:	01e5d693          	srl	a3,a1,0x1e
8000be3c:	e299                	bnez	a3,8000be42 <.L1^B10>
8000be3e:	0709                	add	a4,a4,2
8000be40:	058a                	sll	a1,a1,0x2

8000be42 <.L1^B10>:
8000be42:	0005c463          	bltz	a1,8000be4a <.L0^B3>
8000be46:	0705                	add	a4,a4,1
8000be48:	0586                	sll	a1,a1,0x1

8000be4a <.L0^B3>:
8000be4a:	fff74613          	not	a2,a4
8000be4e:	00c556b3          	srl	a3,a0,a2
8000be52:	8285                	srl	a3,a3,0x1
8000be54:	8dd5                	or	a1,a1,a3
8000be56:	00e51533          	sll	a0,a0,a4
8000be5a:	0be60613          	add	a2,a2,190
8000be5e:	00a03533          	snez	a0,a0
8000be62:	8dc9                	or	a1,a1,a0

8000be64 <.L__floatundisf_round_and_pack>:
8000be64:	065e                	sll	a2,a2,0x17
8000be66:	0085d513          	srl	a0,a1,0x8
8000be6a:	05de                	sll	a1,a1,0x17
8000be6c:	0005a333          	sltz	t1,a1
8000be70:	95ae                	add	a1,a1,a1
8000be72:	959a                	add	a1,a1,t1
8000be74:	0005d663          	bgez	a1,8000be80 <.L__floatundisf_round_down>
8000be78:	95ae                	add	a1,a1,a1
8000be7a:	00b035b3          	snez	a1,a1
8000be7e:	952e                	add	a0,a0,a1

8000be80 <.L__floatundisf_round_down>:
8000be80:	9532                	add	a0,a0,a2

8000be82 <.L__floatundisf_done>:
8000be82:	8082                	ret

8000be84 <.L__floatundisf_high_word_zero>:
8000be84:	dd7d                	beqz	a0,8000be82 <.L__floatundisf_done>
8000be86:	09d00613          	li	a2,157
8000be8a:	01055693          	srl	a3,a0,0x10
8000be8e:	e299                	bnez	a3,8000be94 <.L1^B11>
8000be90:	0542                	sll	a0,a0,0x10
8000be92:	1641                	add	a2,a2,-16

8000be94 <.L1^B11>:
8000be94:	01855693          	srl	a3,a0,0x18
8000be98:	e299                	bnez	a3,8000be9e <.L2^B11>
8000be9a:	0522                	sll	a0,a0,0x8
8000be9c:	1661                	add	a2,a2,-8

8000be9e <.L2^B11>:
8000be9e:	01c55693          	srl	a3,a0,0x1c
8000bea2:	e299                	bnez	a3,8000bea8 <.L3^B8>
8000bea4:	0512                	sll	a0,a0,0x4
8000bea6:	1671                	add	a2,a2,-4

8000bea8 <.L3^B8>:
8000bea8:	01e55693          	srl	a3,a0,0x1e
8000beac:	e299                	bnez	a3,8000beb2 <.L4^B11>
8000beae:	050a                	sll	a0,a0,0x2
8000beb0:	1679                	add	a2,a2,-2

8000beb2 <.L4^B11>:
8000beb2:	00054463          	bltz	a0,8000beba <.L5^B8>
8000beb6:	0506                	sll	a0,a0,0x1
8000beb8:	167d                	add	a2,a2,-1

8000beba <.L5^B8>:
8000beba:	85aa                	mv	a1,a0
8000bebc:	4501                	li	a0,0
8000bebe:	b75d                	j	8000be64 <.L__floatundisf_round_and_pack>

Disassembly of section .text.libc.__truncdfsf2:

8000bec0 <__truncdfsf2>:
8000bec0:	00159693          	sll	a3,a1,0x1
8000bec4:	82d5                	srl	a3,a3,0x15
8000bec6:	7ff00613          	li	a2,2047
8000beca:	04c68663          	beq	a3,a2,8000bf16 <.L__truncdfsf2_inf_nan>
8000bece:	c8068693          	add	a3,a3,-896 # 7ffffc80 <__NONCACHEABLE_RAM_segment_end__+0x3efffc80>
8000bed2:	02d05e63          	blez	a3,8000bf0e <.L__truncdfsf2_underflow>
8000bed6:	0ff00613          	li	a2,255
8000beda:	04c6f263          	bgeu	a3,a2,8000bf1e <.L__truncdfsf2_inf>
8000bede:	06de                	sll	a3,a3,0x17
8000bee0:	01f5d613          	srl	a2,a1,0x1f
8000bee4:	067e                	sll	a2,a2,0x1f
8000bee6:	8ed1                	or	a3,a3,a2
8000bee8:	05b2                	sll	a1,a1,0xc
8000beea:	01455613          	srl	a2,a0,0x14
8000beee:	8dd1                	or	a1,a1,a2
8000bef0:	81a5                	srl	a1,a1,0x9
8000bef2:	00251613          	sll	a2,a0,0x2
8000bef6:	00062733          	sltz	a4,a2
8000befa:	9632                	add	a2,a2,a2
8000befc:	000627b3          	sltz	a5,a2
8000bf00:	9632                	add	a2,a2,a2
8000bf02:	963a                	add	a2,a2,a4
8000bf04:	c211                	beqz	a2,8000bf08 <.L__truncdfsf2_no_round_tie>
8000bf06:	95be                	add	a1,a1,a5

8000bf08 <.L__truncdfsf2_no_round_tie>:
8000bf08:	00d58533          	add	a0,a1,a3
8000bf0c:	8082                	ret

8000bf0e <.L__truncdfsf2_underflow>:
8000bf0e:	01f5d513          	srl	a0,a1,0x1f
8000bf12:	057e                	sll	a0,a0,0x1f
8000bf14:	8082                	ret

8000bf16 <.L__truncdfsf2_inf_nan>:
8000bf16:	00c59693          	sll	a3,a1,0xc
8000bf1a:	8ec9                	or	a3,a3,a0
8000bf1c:	ea81                	bnez	a3,8000bf2c <.L__truncdfsf2_nan>

8000bf1e <.L__truncdfsf2_inf>:
8000bf1e:	81fd                	srl	a1,a1,0x1f
8000bf20:	05fe                	sll	a1,a1,0x1f
8000bf22:	7f800537          	lui	a0,0x7f800
8000bf26:	8d4d                	or	a0,a0,a1
8000bf28:	4581                	li	a1,0
8000bf2a:	8082                	ret

8000bf2c <.L__truncdfsf2_nan>:
8000bf2c:	800006b7          	lui	a3,0x80000
8000bf30:	00d5f633          	and	a2,a1,a3
8000bf34:	058e                	sll	a1,a1,0x3
8000bf36:	8175                	srl	a0,a0,0x1d
8000bf38:	8d4d                	or	a0,a0,a1
8000bf3a:	0506                	sll	a0,a0,0x1
8000bf3c:	8105                	srl	a0,a0,0x1
8000bf3e:	8d51                	or	a0,a0,a2
8000bf40:	82a5                	srl	a3,a3,0x9
8000bf42:	8d55                	or	a0,a0,a3
8000bf44:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ldouble_to_double:

8000bf46 <__SEGGER_RTL_ldouble_to_double>:
8000bf46:	4158                	lw	a4,4(a0)
8000bf48:	451c                	lw	a5,8(a0)
8000bf4a:	4554                	lw	a3,12(a0)
8000bf4c:	1141                	add	sp,sp,-16
8000bf4e:	c23a                	sw	a4,4(sp)
8000bf50:	c43e                	sw	a5,8(sp)
8000bf52:	7771                	lui	a4,0xffffc
8000bf54:	00169793          	sll	a5,a3,0x1
8000bf58:	83c5                	srl	a5,a5,0x11
8000bf5a:	40070713          	add	a4,a4,1024 # ffffc400 <__APB_SRAM_segment_end__+0xbf0a400>
8000bf5e:	c636                	sw	a3,12(sp)
8000bf60:	97ba                	add	a5,a5,a4
8000bf62:	00f04a63          	bgtz	a5,8000bf76 <.L27>
8000bf66:	800007b7          	lui	a5,0x80000
8000bf6a:	4701                	li	a4,0
8000bf6c:	8ff5                	and	a5,a5,a3

8000bf6e <.L28>:
8000bf6e:	853a                	mv	a0,a4
8000bf70:	85be                	mv	a1,a5
8000bf72:	0141                	add	sp,sp,16
8000bf74:	8082                	ret

8000bf76 <.L27>:
8000bf76:	6711                	lui	a4,0x4
8000bf78:	3ff70713          	add	a4,a4,1023 # 43ff <__DLM_segment_used_size__+0x3ff>
8000bf7c:	00e78c63          	beq	a5,a4,8000bf94 <.L29>
8000bf80:	7ff00713          	li	a4,2047
8000bf84:	00f75a63          	bge	a4,a5,8000bf98 <.L30>
8000bf88:	4781                	li	a5,0
8000bf8a:	4801                	li	a6,0
8000bf8c:	c43e                	sw	a5,8(sp)
8000bf8e:	c642                	sw	a6,12(sp)
8000bf90:	c03e                	sw	a5,0(sp)
8000bf92:	c242                	sw	a6,4(sp)

8000bf94 <.L29>:
8000bf94:	7ff00793          	li	a5,2047

8000bf98 <.L30>:
8000bf98:	45a2                	lw	a1,8(sp)
8000bf9a:	4732                	lw	a4,12(sp)
8000bf9c:	80000637          	lui	a2,0x80000
8000bfa0:	01c5d513          	srl	a0,a1,0x1c
8000bfa4:	8e79                	and	a2,a2,a4
8000bfa6:	0712                	sll	a4,a4,0x4
8000bfa8:	4692                	lw	a3,4(sp)
8000bfaa:	8f49                	or	a4,a4,a0
8000bfac:	0732                	sll	a4,a4,0xc
8000bfae:	8331                	srl	a4,a4,0xc
8000bfb0:	8e59                	or	a2,a2,a4
8000bfb2:	82f1                	srl	a3,a3,0x1c
8000bfb4:	0592                	sll	a1,a1,0x4
8000bfb6:	07d2                	sll	a5,a5,0x14
8000bfb8:	00b6e733          	or	a4,a3,a1
8000bfbc:	8fd1                	or	a5,a5,a2
8000bfbe:	bf45                	j	8000bf6e <.L28>

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnan:

8000bfc0 <__SEGGER_RTL_float32_isnan>:
8000bfc0:	ff0007b7          	lui	a5,0xff000
8000bfc4:	0785                	add	a5,a5,1 # ff000001 <__APB_SRAM_segment_end__+0xaf0e001>
8000bfc6:	0506                	sll	a0,a0,0x1
8000bfc8:	00f53533          	sltu	a0,a0,a5
8000bfcc:	00154513          	xor	a0,a0,1
8000bfd0:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isinf:

8000bfd2 <__SEGGER_RTL_float32_isinf>:
8000bfd2:	010007b7          	lui	a5,0x1000
8000bfd6:	0506                	sll	a0,a0,0x1
8000bfd8:	953e                	add	a0,a0,a5
8000bfda:	00153513          	seqz	a0,a0
8000bfde:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_isnormal:

8000bfe0 <__SEGGER_RTL_float32_isnormal>:
8000bfe0:	ff0007b7          	lui	a5,0xff000
8000bfe4:	0506                	sll	a0,a0,0x1
8000bfe6:	953e                	add	a0,a0,a5
8000bfe8:	fe0007b7          	lui	a5,0xfe000
8000bfec:	00f53533          	sltu	a0,a0,a5
8000bff0:	8082                	ret

Disassembly of section .text.libc.floorf:

8000bff2 <floorf>:
8000bff2:	00151693          	sll	a3,a0,0x1
8000bff6:	82e1                	srl	a3,a3,0x18
8000bff8:	01755793          	srl	a5,a0,0x17
8000bffc:	16fd                	add	a3,a3,-1 # 7fffffff <__NONCACHEABLE_RAM_segment_end__+0x3effffff>
8000bffe:	0fd00613          	li	a2,253
8000c002:	872a                	mv	a4,a0
8000c004:	0ff7f793          	zext.b	a5,a5
8000c008:	00d67963          	bgeu	a2,a3,8000c01a <.L1240>
8000c00c:	e789                	bnez	a5,8000c016 <.L1241>
8000c00e:	800007b7          	lui	a5,0x80000
8000c012:	00f57733          	and	a4,a0,a5

8000c016 <.L1241>:
8000c016:	853a                	mv	a0,a4
8000c018:	8082                	ret

8000c01a <.L1240>:
8000c01a:	f8178793          	add	a5,a5,-127 # 7fffff81 <__NONCACHEABLE_RAM_segment_end__+0x3effff81>
8000c01e:	0007d963          	bgez	a5,8000c030 <.L1243>
8000c022:	00000513          	li	a0,0
8000c026:	02075863          	bgez	a4,8000c056 <.L1242>
8000c02a:	fc01a503          	lw	a0,-64(gp) # 8000932c <.Lmerged_single+0x18>
8000c02e:	8082                	ret

8000c030 <.L1243>:
8000c030:	46d9                	li	a3,22
8000c032:	02f6c263          	blt	a3,a5,8000c056 <.L1242>
8000c036:	008006b7          	lui	a3,0x800
8000c03a:	fff68613          	add	a2,a3,-1 # 7fffff <__FLASH_segment_size__+0x2fff>
8000c03e:	00f65633          	srl	a2,a2,a5
8000c042:	fff64513          	not	a0,a2
8000c046:	8d79                	and	a0,a0,a4
8000c048:	8f71                	and	a4,a4,a2
8000c04a:	c711                	beqz	a4,8000c056 <.L1242>
8000c04c:	00055563          	bgez	a0,8000c056 <.L1242>
8000c050:	00f6d6b3          	srl	a3,a3,a5
8000c054:	9536                	add	a0,a0,a3

8000c056 <.L1242>:
8000c056:	8082                	ret

Disassembly of section .text.libc.__ashldi3:

8000c058 <__ashldi3>:
8000c058:	02067793          	and	a5,a2,32
8000c05c:	ef89                	bnez	a5,8000c076 <.L__ashldi3LongShift>
8000c05e:	00155793          	srl	a5,a0,0x1
8000c062:	fff64713          	not	a4,a2
8000c066:	00e7d7b3          	srl	a5,a5,a4
8000c06a:	00c595b3          	sll	a1,a1,a2
8000c06e:	8ddd                	or	a1,a1,a5
8000c070:	00c51533          	sll	a0,a0,a2
8000c074:	8082                	ret

8000c076 <.L__ashldi3LongShift>:
8000c076:	00c515b3          	sll	a1,a0,a2
8000c07a:	4501                	li	a0,0
8000c07c:	8082                	ret

Disassembly of section .text.libc.__udivdi3:

8000c07e <__udivdi3>:
8000c07e:	1101                	add	sp,sp,-32
8000c080:	cc22                	sw	s0,24(sp)
8000c082:	ca26                	sw	s1,20(sp)
8000c084:	c84a                	sw	s2,16(sp)
8000c086:	c64e                	sw	s3,12(sp)
8000c088:	ce06                	sw	ra,28(sp)
8000c08a:	c452                	sw	s4,8(sp)
8000c08c:	c256                	sw	s5,4(sp)
8000c08e:	c05a                	sw	s6,0(sp)
8000c090:	842a                	mv	s0,a0
8000c092:	892e                	mv	s2,a1
8000c094:	89b2                	mv	s3,a2
8000c096:	84b6                	mv	s1,a3
8000c098:	2e069063          	bnez	a3,8000c378 <.L47>
8000c09c:	ed99                	bnez	a1,8000c0ba <.L48>
8000c09e:	02c55433          	divu	s0,a0,a2

8000c0a2 <.L49>:
8000c0a2:	40f2                	lw	ra,28(sp)
8000c0a4:	8522                	mv	a0,s0
8000c0a6:	4462                	lw	s0,24(sp)
8000c0a8:	44d2                	lw	s1,20(sp)
8000c0aa:	49b2                	lw	s3,12(sp)
8000c0ac:	4a22                	lw	s4,8(sp)
8000c0ae:	4a92                	lw	s5,4(sp)
8000c0b0:	4b02                	lw	s6,0(sp)
8000c0b2:	85ca                	mv	a1,s2
8000c0b4:	4942                	lw	s2,16(sp)
8000c0b6:	6105                	add	sp,sp,32
8000c0b8:	8082                	ret

8000c0ba <.L48>:
8000c0ba:	010007b7          	lui	a5,0x1000
8000c0be:	12f67863          	bgeu	a2,a5,8000c1ee <.L50>
8000c0c2:	4791                	li	a5,4
8000c0c4:	08c7e763          	bltu	a5,a2,8000c152 <.L52>
8000c0c8:	470d                	li	a4,3
8000c0ca:	02e60263          	beq	a2,a4,8000c0ee <.L54>
8000c0ce:	06f60a63          	beq	a2,a5,8000c142 <.L55>
8000c0d2:	4785                	li	a5,1
8000c0d4:	fcf607e3          	beq	a2,a5,8000c0a2 <.L49>
8000c0d8:	4789                	li	a5,2
8000c0da:	3af61c63          	bne	a2,a5,8000c492 <.L88>
8000c0de:	01f59793          	sll	a5,a1,0x1f
8000c0e2:	00155413          	srl	s0,a0,0x1
8000c0e6:	8c5d                	or	s0,s0,a5
8000c0e8:	0015d913          	srl	s2,a1,0x1
8000c0ec:	bf5d                	j	8000c0a2 <.L49>

8000c0ee <.L54>:
8000c0ee:	555557b7          	lui	a5,0x55555
8000c0f2:	55578793          	add	a5,a5,1365 # 55555555 <__NONCACHEABLE_RAM_segment_end__+0x14555555>
8000c0f6:	02b7b6b3          	mulhu	a3,a5,a1
8000c0fa:	02a7b633          	mulhu	a2,a5,a0
8000c0fe:	02a78733          	mul	a4,a5,a0
8000c102:	02b787b3          	mul	a5,a5,a1
8000c106:	97b2                	add	a5,a5,a2
8000c108:	00c7b633          	sltu	a2,a5,a2
8000c10c:	9636                	add	a2,a2,a3
8000c10e:	00f706b3          	add	a3,a4,a5
8000c112:	00e6b733          	sltu	a4,a3,a4
8000c116:	9732                	add	a4,a4,a2
8000c118:	97ba                	add	a5,a5,a4
8000c11a:	00e7b5b3          	sltu	a1,a5,a4
8000c11e:	9736                	add	a4,a4,a3
8000c120:	00d736b3          	sltu	a3,a4,a3
8000c124:	0705                	add	a4,a4,1
8000c126:	97b6                	add	a5,a5,a3
8000c128:	00173713          	seqz	a4,a4
8000c12c:	00d7b6b3          	sltu	a3,a5,a3
8000c130:	962e                	add	a2,a2,a1
8000c132:	97ba                	add	a5,a5,a4
8000c134:	00c68933          	add	s2,a3,a2
8000c138:	00e7b733          	sltu	a4,a5,a4
8000c13c:	843e                	mv	s0,a5
8000c13e:	993a                	add	s2,s2,a4
8000c140:	b78d                	j	8000c0a2 <.L49>

8000c142 <.L55>:
8000c142:	01e59793          	sll	a5,a1,0x1e
8000c146:	00255413          	srl	s0,a0,0x2
8000c14a:	8c5d                	or	s0,s0,a5
8000c14c:	0025d913          	srl	s2,a1,0x2
8000c150:	bf89                	j	8000c0a2 <.L49>

8000c152 <.L52>:
8000c152:	67c1                	lui	a5,0x10
8000c154:	02c5d6b3          	divu	a3,a1,a2
8000c158:	01055713          	srl	a4,a0,0x10
8000c15c:	02f67a63          	bgeu	a2,a5,8000c190 <.L62>
8000c160:	01051413          	sll	s0,a0,0x10
8000c164:	8041                	srl	s0,s0,0x10
8000c166:	02c687b3          	mul	a5,a3,a2
8000c16a:	40f587b3          	sub	a5,a1,a5
8000c16e:	07c2                	sll	a5,a5,0x10
8000c170:	97ba                	add	a5,a5,a4
8000c172:	02c7d933          	divu	s2,a5,a2
8000c176:	02c90733          	mul	a4,s2,a2
8000c17a:	0942                	sll	s2,s2,0x10
8000c17c:	8f99                	sub	a5,a5,a4
8000c17e:	07c2                	sll	a5,a5,0x10
8000c180:	943e                	add	s0,s0,a5
8000c182:	02c45433          	divu	s0,s0,a2
8000c186:	944a                	add	s0,s0,s2
8000c188:	01243933          	sltu	s2,s0,s2
8000c18c:	9936                	add	s2,s2,a3
8000c18e:	bf11                	j	8000c0a2 <.L49>

8000c190 <.L62>:
8000c190:	02c687b3          	mul	a5,a3,a2
8000c194:	01855613          	srl	a2,a0,0x18
8000c198:	0ff77713          	zext.b	a4,a4
8000c19c:	0ff47413          	zext.b	s0,s0
8000c1a0:	8936                	mv	s2,a3
8000c1a2:	40f587b3          	sub	a5,a1,a5
8000c1a6:	07a2                	sll	a5,a5,0x8
8000c1a8:	963e                	add	a2,a2,a5
8000c1aa:	033657b3          	divu	a5,a2,s3
8000c1ae:	033785b3          	mul	a1,a5,s3
8000c1b2:	07a2                	sll	a5,a5,0x8
8000c1b4:	8e0d                	sub	a2,a2,a1
8000c1b6:	0622                	sll	a2,a2,0x8
8000c1b8:	9732                	add	a4,a4,a2
8000c1ba:	033755b3          	divu	a1,a4,s3
8000c1be:	97ae                	add	a5,a5,a1
8000c1c0:	07a2                	sll	a5,a5,0x8
8000c1c2:	03358633          	mul	a2,a1,s3
8000c1c6:	8f11                	sub	a4,a4,a2
8000c1c8:	00855613          	srl	a2,a0,0x8
8000c1cc:	0ff67613          	zext.b	a2,a2
8000c1d0:	0722                	sll	a4,a4,0x8
8000c1d2:	9732                	add	a4,a4,a2
8000c1d4:	03375633          	divu	a2,a4,s3
8000c1d8:	97b2                	add	a5,a5,a2
8000c1da:	07a2                	sll	a5,a5,0x8
8000c1dc:	03360533          	mul	a0,a2,s3
8000c1e0:	8f09                	sub	a4,a4,a0
8000c1e2:	0722                	sll	a4,a4,0x8
8000c1e4:	943a                	add	s0,s0,a4
8000c1e6:	03345433          	divu	s0,s0,s3
8000c1ea:	943e                	add	s0,s0,a5
8000c1ec:	bd5d                	j	8000c0a2 <.L49>

8000c1ee <.L50>:
8000c1ee:	97418a93          	add	s5,gp,-1676 # 80008ce0 <__SEGGER_RTL_Moeller_inverse_lut>
8000c1f2:	0cc5f063          	bgeu	a1,a2,8000c2b2 <.L64>
8000c1f6:	10000737          	lui	a4,0x10000
8000c1fa:	87b2                	mv	a5,a2
8000c1fc:	00e67563          	bgeu	a2,a4,8000c206 <.L65>
8000c200:	00461793          	sll	a5,a2,0x4
8000c204:	4491                	li	s1,4

8000c206 <.L65>:
8000c206:	40000737          	lui	a4,0x40000
8000c20a:	00e7f463          	bgeu	a5,a4,8000c212 <.L66>
8000c20e:	0489                	add	s1,s1,2
8000c210:	078a                	sll	a5,a5,0x2

8000c212 <.L66>:
8000c212:	0007c363          	bltz	a5,8000c218 <.L67>
8000c216:	0485                	add	s1,s1,1

8000c218 <.L67>:
8000c218:	8626                	mv	a2,s1
8000c21a:	8522                	mv	a0,s0
8000c21c:	85ca                	mv	a1,s2
8000c21e:	3d2d                	jal	8000c058 <__ashldi3>
8000c220:	009994b3          	sll	s1,s3,s1
8000c224:	0164d793          	srl	a5,s1,0x16
8000c228:	e0078793          	add	a5,a5,-512 # fe00 <__FLASH_segment_used_size__+0x1938>
8000c22c:	0786                	sll	a5,a5,0x1
8000c22e:	97d6                	add	a5,a5,s5
8000c230:	0007d783          	lhu	a5,0(a5)
8000c234:	00b4d813          	srl	a6,s1,0xb
8000c238:	0014f713          	and	a4,s1,1
8000c23c:	02f78633          	mul	a2,a5,a5
8000c240:	0792                	sll	a5,a5,0x4
8000c242:	0014d693          	srl	a3,s1,0x1
8000c246:	0805                	add	a6,a6,1
8000c248:	03063633          	mulhu	a2,a2,a6
8000c24c:	8f91                	sub	a5,a5,a2
8000c24e:	96ba                	add	a3,a3,a4
8000c250:	17fd                	add	a5,a5,-1
8000c252:	c319                	beqz	a4,8000c258 <.L68>
8000c254:	0017d713          	srl	a4,a5,0x1

8000c258 <.L68>:
8000c258:	02f686b3          	mul	a3,a3,a5
8000c25c:	8f15                	sub	a4,a4,a3
8000c25e:	02e7b733          	mulhu	a4,a5,a4
8000c262:	07be                	sll	a5,a5,0xf
8000c264:	8305                	srl	a4,a4,0x1
8000c266:	97ba                	add	a5,a5,a4
8000c268:	8726                	mv	a4,s1
8000c26a:	029786b3          	mul	a3,a5,s1
8000c26e:	9736                	add	a4,a4,a3
8000c270:	00d736b3          	sltu	a3,a4,a3
8000c274:	8726                	mv	a4,s1
8000c276:	9736                	add	a4,a4,a3
8000c278:	0297b6b3          	mulhu	a3,a5,s1
8000c27c:	9736                	add	a4,a4,a3
8000c27e:	8f99                	sub	a5,a5,a4
8000c280:	02b7b733          	mulhu	a4,a5,a1
8000c284:	02b787b3          	mul	a5,a5,a1
8000c288:	00a786b3          	add	a3,a5,a0
8000c28c:	00f6b7b3          	sltu	a5,a3,a5
8000c290:	95be                	add	a1,a1,a5
8000c292:	00b707b3          	add	a5,a4,a1
8000c296:	00178413          	add	s0,a5,1
8000c29a:	02848733          	mul	a4,s1,s0
8000c29e:	8d19                	sub	a0,a0,a4
8000c2a0:	00a6f463          	bgeu	a3,a0,8000c2a8 <.L69>
8000c2a4:	9526                	add	a0,a0,s1
8000c2a6:	843e                	mv	s0,a5

8000c2a8 <.L69>:
8000c2a8:	00956363          	bltu	a0,s1,8000c2ae <.L109>
8000c2ac:	0405                	add	s0,s0,1

8000c2ae <.L109>:
8000c2ae:	4901                	li	s2,0
8000c2b0:	bbcd                	j	8000c0a2 <.L49>

8000c2b2 <.L64>:
8000c2b2:	02c5da33          	divu	s4,a1,a2
8000c2b6:	10000737          	lui	a4,0x10000
8000c2ba:	87b2                	mv	a5,a2
8000c2bc:	02ca05b3          	mul	a1,s4,a2
8000c2c0:	40b905b3          	sub	a1,s2,a1
8000c2c4:	00e67563          	bgeu	a2,a4,8000c2ce <.L71>
8000c2c8:	00461793          	sll	a5,a2,0x4
8000c2cc:	4491                	li	s1,4

8000c2ce <.L71>:
8000c2ce:	40000737          	lui	a4,0x40000
8000c2d2:	00e7f463          	bgeu	a5,a4,8000c2da <.L72>
8000c2d6:	0489                	add	s1,s1,2
8000c2d8:	078a                	sll	a5,a5,0x2

8000c2da <.L72>:
8000c2da:	0007c363          	bltz	a5,8000c2e0 <.L73>
8000c2de:	0485                	add	s1,s1,1

8000c2e0 <.L73>:
8000c2e0:	8626                	mv	a2,s1
8000c2e2:	8522                	mv	a0,s0
8000c2e4:	3b95                	jal	8000c058 <__ashldi3>
8000c2e6:	009994b3          	sll	s1,s3,s1
8000c2ea:	0164d793          	srl	a5,s1,0x16
8000c2ee:	e0078793          	add	a5,a5,-512
8000c2f2:	0786                	sll	a5,a5,0x1
8000c2f4:	9abe                	add	s5,s5,a5
8000c2f6:	000ad783          	lhu	a5,0(s5)
8000c2fa:	00b4d813          	srl	a6,s1,0xb
8000c2fe:	0014f713          	and	a4,s1,1
8000c302:	02f78633          	mul	a2,a5,a5
8000c306:	0792                	sll	a5,a5,0x4
8000c308:	0014d693          	srl	a3,s1,0x1
8000c30c:	0805                	add	a6,a6,1
8000c30e:	03063633          	mulhu	a2,a2,a6
8000c312:	8f91                	sub	a5,a5,a2
8000c314:	96ba                	add	a3,a3,a4
8000c316:	17fd                	add	a5,a5,-1
8000c318:	c319                	beqz	a4,8000c31e <.L74>
8000c31a:	0017d713          	srl	a4,a5,0x1

8000c31e <.L74>:
8000c31e:	02f686b3          	mul	a3,a3,a5
8000c322:	8f15                	sub	a4,a4,a3
8000c324:	02e7b733          	mulhu	a4,a5,a4
8000c328:	07be                	sll	a5,a5,0xf
8000c32a:	8305                	srl	a4,a4,0x1
8000c32c:	97ba                	add	a5,a5,a4
8000c32e:	8726                	mv	a4,s1
8000c330:	029786b3          	mul	a3,a5,s1
8000c334:	9736                	add	a4,a4,a3
8000c336:	00d736b3          	sltu	a3,a4,a3
8000c33a:	8726                	mv	a4,s1
8000c33c:	9736                	add	a4,a4,a3
8000c33e:	0297b6b3          	mulhu	a3,a5,s1
8000c342:	9736                	add	a4,a4,a3
8000c344:	8f99                	sub	a5,a5,a4
8000c346:	02b7b733          	mulhu	a4,a5,a1
8000c34a:	02b787b3          	mul	a5,a5,a1
8000c34e:	00a786b3          	add	a3,a5,a0
8000c352:	00f6b7b3          	sltu	a5,a3,a5
8000c356:	95be                	add	a1,a1,a5
8000c358:	00b707b3          	add	a5,a4,a1
8000c35c:	00178413          	add	s0,a5,1
8000c360:	02848733          	mul	a4,s1,s0
8000c364:	8d19                	sub	a0,a0,a4
8000c366:	00a6f463          	bgeu	a3,a0,8000c36e <.L75>
8000c36a:	9526                	add	a0,a0,s1
8000c36c:	843e                	mv	s0,a5

8000c36e <.L75>:
8000c36e:	00956363          	bltu	a0,s1,8000c374 <.L76>
8000c372:	0405                	add	s0,s0,1

8000c374 <.L76>:
8000c374:	8952                	mv	s2,s4
8000c376:	b335                	j	8000c0a2 <.L49>

8000c378 <.L47>:
8000c378:	67c1                	lui	a5,0x10
8000c37a:	8ab6                	mv	s5,a3
8000c37c:	4a01                	li	s4,0
8000c37e:	00f6f563          	bgeu	a3,a5,8000c388 <.L77>
8000c382:	01069493          	sll	s1,a3,0x10
8000c386:	4a41                	li	s4,16

8000c388 <.L77>:
8000c388:	010007b7          	lui	a5,0x1000
8000c38c:	00f4f463          	bgeu	s1,a5,8000c394 <.L78>
8000c390:	0a21                	add	s4,s4,8
8000c392:	04a2                	sll	s1,s1,0x8

8000c394 <.L78>:
8000c394:	100007b7          	lui	a5,0x10000
8000c398:	00f4f463          	bgeu	s1,a5,8000c3a0 <.L79>
8000c39c:	0a11                	add	s4,s4,4
8000c39e:	0492                	sll	s1,s1,0x4

8000c3a0 <.L79>:
8000c3a0:	400007b7          	lui	a5,0x40000
8000c3a4:	00f4f463          	bgeu	s1,a5,8000c3ac <.L80>
8000c3a8:	0a09                	add	s4,s4,2
8000c3aa:	048a                	sll	s1,s1,0x2

8000c3ac <.L80>:
8000c3ac:	0004c363          	bltz	s1,8000c3b2 <.L81>
8000c3b0:	0a05                	add	s4,s4,1

8000c3b2 <.L81>:
8000c3b2:	01f91793          	sll	a5,s2,0x1f
8000c3b6:	8652                	mv	a2,s4
8000c3b8:	00145493          	srl	s1,s0,0x1
8000c3bc:	854e                	mv	a0,s3
8000c3be:	85d6                	mv	a1,s5
8000c3c0:	8cdd                	or	s1,s1,a5
8000c3c2:	3959                	jal	8000c058 <__ashldi3>
8000c3c4:	0165d613          	srl	a2,a1,0x16
8000c3c8:	e0060613          	add	a2,a2,-512 # 7ffffe00 <__NONCACHEABLE_RAM_segment_end__+0x3efffe00>
8000c3cc:	0606                	sll	a2,a2,0x1
8000c3ce:	97418793          	add	a5,gp,-1676 # 80008ce0 <__SEGGER_RTL_Moeller_inverse_lut>
8000c3d2:	97b2                	add	a5,a5,a2
8000c3d4:	0007d783          	lhu	a5,0(a5) # 40000000 <__SDRAM_segment_start__>
8000c3d8:	00b5d513          	srl	a0,a1,0xb
8000c3dc:	0015f713          	and	a4,a1,1
8000c3e0:	02f78633          	mul	a2,a5,a5
8000c3e4:	0792                	sll	a5,a5,0x4
8000c3e6:	0015d693          	srl	a3,a1,0x1
8000c3ea:	0505                	add	a0,a0,1 # 7f800001 <__NONCACHEABLE_RAM_segment_end__+0x3e800001>
8000c3ec:	02a63633          	mulhu	a2,a2,a0
8000c3f0:	8f91                	sub	a5,a5,a2
8000c3f2:	00195b13          	srl	s6,s2,0x1
8000c3f6:	96ba                	add	a3,a3,a4
8000c3f8:	17fd                	add	a5,a5,-1
8000c3fa:	c319                	beqz	a4,8000c400 <.L82>
8000c3fc:	0017d713          	srl	a4,a5,0x1

8000c400 <.L82>:
8000c400:	02f686b3          	mul	a3,a3,a5
8000c404:	8f15                	sub	a4,a4,a3
8000c406:	02e7b733          	mulhu	a4,a5,a4
8000c40a:	07be                	sll	a5,a5,0xf
8000c40c:	8305                	srl	a4,a4,0x1
8000c40e:	97ba                	add	a5,a5,a4
8000c410:	872e                	mv	a4,a1
8000c412:	02b786b3          	mul	a3,a5,a1
8000c416:	9736                	add	a4,a4,a3
8000c418:	00d736b3          	sltu	a3,a4,a3
8000c41c:	872e                	mv	a4,a1
8000c41e:	9736                	add	a4,a4,a3
8000c420:	02b7b6b3          	mulhu	a3,a5,a1
8000c424:	9736                	add	a4,a4,a3
8000c426:	8f99                	sub	a5,a5,a4
8000c428:	0367b733          	mulhu	a4,a5,s6
8000c42c:	036787b3          	mul	a5,a5,s6
8000c430:	009786b3          	add	a3,a5,s1
8000c434:	00f6b7b3          	sltu	a5,a3,a5
8000c438:	97da                	add	a5,a5,s6
8000c43a:	973e                	add	a4,a4,a5
8000c43c:	00170793          	add	a5,a4,1 # 40000001 <__SDRAM_segment_start__+0x1>
8000c440:	02f58633          	mul	a2,a1,a5
8000c444:	8c91                	sub	s1,s1,a2
8000c446:	0096f463          	bgeu	a3,s1,8000c44e <.L83>
8000c44a:	94ae                	add	s1,s1,a1
8000c44c:	87ba                	mv	a5,a4

8000c44e <.L83>:
8000c44e:	00b4e363          	bltu	s1,a1,8000c454 <.L84>
8000c452:	0785                	add	a5,a5,1

8000c454 <.L84>:
8000c454:	477d                	li	a4,31
8000c456:	41470733          	sub	a4,a4,s4
8000c45a:	00e7d633          	srl	a2,a5,a4
8000c45e:	c211                	beqz	a2,8000c462 <.L85>
8000c460:	167d                	add	a2,a2,-1

8000c462 <.L85>:
8000c462:	02ca87b3          	mul	a5,s5,a2
8000c466:	03360733          	mul	a4,a2,s3
8000c46a:	033636b3          	mulhu	a3,a2,s3
8000c46e:	40e40733          	sub	a4,s0,a4
8000c472:	00e43433          	sltu	s0,s0,a4
8000c476:	97b6                	add	a5,a5,a3
8000c478:	40f907b3          	sub	a5,s2,a5
8000c47c:	40878433          	sub	s0,a5,s0
8000c480:	01546763          	bltu	s0,s5,8000c48e <.L86>
8000c484:	008a9463          	bne	s5,s0,8000c48c <.L95>
8000c488:	01376363          	bltu	a4,s3,8000c48e <.L86>

8000c48c <.L95>:
8000c48c:	0605                	add	a2,a2,1

8000c48e <.L86>:
8000c48e:	8432                	mv	s0,a2
8000c490:	bd39                	j	8000c2ae <.L109>

8000c492 <.L88>:
8000c492:	4401                	li	s0,0
8000c494:	bd29                	j	8000c2ae <.L109>

Disassembly of section .text.libc.__umoddi3:

8000c496 <__umoddi3>:
8000c496:	1101                	add	sp,sp,-32
8000c498:	cc22                	sw	s0,24(sp)
8000c49a:	ca26                	sw	s1,20(sp)
8000c49c:	c84a                	sw	s2,16(sp)
8000c49e:	c64e                	sw	s3,12(sp)
8000c4a0:	c452                	sw	s4,8(sp)
8000c4a2:	ce06                	sw	ra,28(sp)
8000c4a4:	c256                	sw	s5,4(sp)
8000c4a6:	c05a                	sw	s6,0(sp)
8000c4a8:	892a                	mv	s2,a0
8000c4aa:	84ae                	mv	s1,a1
8000c4ac:	8432                	mv	s0,a2
8000c4ae:	89b6                	mv	s3,a3
8000c4b0:	8a36                	mv	s4,a3
8000c4b2:	2e069c63          	bnez	a3,8000c7aa <.L111>
8000c4b6:	e589                	bnez	a1,8000c4c0 <.L112>
8000c4b8:	02c557b3          	divu	a5,a0,a2

8000c4bc <.L174>:
8000c4bc:	4701                	li	a4,0
8000c4be:	a815                	j	8000c4f2 <.L113>

8000c4c0 <.L112>:
8000c4c0:	010007b7          	lui	a5,0x1000
8000c4c4:	16f67163          	bgeu	a2,a5,8000c626 <.L114>
8000c4c8:	4791                	li	a5,4
8000c4ca:	0cc7e063          	bltu	a5,a2,8000c58a <.L116>
8000c4ce:	470d                	li	a4,3
8000c4d0:	04e60d63          	beq	a2,a4,8000c52a <.L118>
8000c4d4:	0af60363          	beq	a2,a5,8000c57a <.L119>
8000c4d8:	4785                	li	a5,1
8000c4da:	3ef60363          	beq	a2,a5,8000c8c0 <.L152>
8000c4de:	4789                	li	a5,2
8000c4e0:	3ef61363          	bne	a2,a5,8000c8c6 <.L153>
8000c4e4:	01f59713          	sll	a4,a1,0x1f
8000c4e8:	00155793          	srl	a5,a0,0x1
8000c4ec:	8fd9                	or	a5,a5,a4
8000c4ee:	0015d713          	srl	a4,a1,0x1

8000c4f2 <.L113>:
8000c4f2:	02870733          	mul	a4,a4,s0
8000c4f6:	40f2                	lw	ra,28(sp)
8000c4f8:	4a22                	lw	s4,8(sp)
8000c4fa:	4a92                	lw	s5,4(sp)
8000c4fc:	4b02                	lw	s6,0(sp)
8000c4fe:	02f989b3          	mul	s3,s3,a5
8000c502:	02f40533          	mul	a0,s0,a5
8000c506:	99ba                	add	s3,s3,a4
8000c508:	02f43433          	mulhu	s0,s0,a5
8000c50c:	40a90533          	sub	a0,s2,a0
8000c510:	00a935b3          	sltu	a1,s2,a0
8000c514:	4942                	lw	s2,16(sp)
8000c516:	99a2                	add	s3,s3,s0
8000c518:	4462                	lw	s0,24(sp)
8000c51a:	413484b3          	sub	s1,s1,s3
8000c51e:	40b485b3          	sub	a1,s1,a1
8000c522:	49b2                	lw	s3,12(sp)
8000c524:	44d2                	lw	s1,20(sp)
8000c526:	6105                	add	sp,sp,32
8000c528:	8082                	ret

8000c52a <.L118>:
8000c52a:	555557b7          	lui	a5,0x55555
8000c52e:	55578793          	add	a5,a5,1365 # 55555555 <__NONCACHEABLE_RAM_segment_end__+0x14555555>
8000c532:	02b7b6b3          	mulhu	a3,a5,a1
8000c536:	02a7b633          	mulhu	a2,a5,a0
8000c53a:	02a78733          	mul	a4,a5,a0
8000c53e:	02b787b3          	mul	a5,a5,a1
8000c542:	97b2                	add	a5,a5,a2
8000c544:	00c7b633          	sltu	a2,a5,a2
8000c548:	9636                	add	a2,a2,a3
8000c54a:	00f706b3          	add	a3,a4,a5
8000c54e:	00e6b733          	sltu	a4,a3,a4
8000c552:	9732                	add	a4,a4,a2
8000c554:	97ba                	add	a5,a5,a4
8000c556:	00e7b5b3          	sltu	a1,a5,a4
8000c55a:	9736                	add	a4,a4,a3
8000c55c:	00d736b3          	sltu	a3,a4,a3
8000c560:	0705                	add	a4,a4,1
8000c562:	97b6                	add	a5,a5,a3
8000c564:	00173713          	seqz	a4,a4
8000c568:	00d7b6b3          	sltu	a3,a5,a3
8000c56c:	962e                	add	a2,a2,a1
8000c56e:	97ba                	add	a5,a5,a4
8000c570:	96b2                	add	a3,a3,a2
8000c572:	00e7b733          	sltu	a4,a5,a4
8000c576:	9736                	add	a4,a4,a3
8000c578:	bfad                	j	8000c4f2 <.L113>

8000c57a <.L119>:
8000c57a:	01e59713          	sll	a4,a1,0x1e
8000c57e:	00255793          	srl	a5,a0,0x2
8000c582:	8fd9                	or	a5,a5,a4
8000c584:	0025d713          	srl	a4,a1,0x2
8000c588:	b7ad                	j	8000c4f2 <.L113>

8000c58a <.L116>:
8000c58a:	67c1                	lui	a5,0x10
8000c58c:	02c5d733          	divu	a4,a1,a2
8000c590:	01055693          	srl	a3,a0,0x10
8000c594:	02f67b63          	bgeu	a2,a5,8000c5ca <.L126>
8000c598:	02c707b3          	mul	a5,a4,a2
8000c59c:	40f587b3          	sub	a5,a1,a5
8000c5a0:	07c2                	sll	a5,a5,0x10
8000c5a2:	97b6                	add	a5,a5,a3
8000c5a4:	02c7d633          	divu	a2,a5,a2
8000c5a8:	028606b3          	mul	a3,a2,s0
8000c5ac:	0642                	sll	a2,a2,0x10
8000c5ae:	8f95                	sub	a5,a5,a3
8000c5b0:	01079693          	sll	a3,a5,0x10
8000c5b4:	01051793          	sll	a5,a0,0x10
8000c5b8:	83c1                	srl	a5,a5,0x10
8000c5ba:	97b6                	add	a5,a5,a3
8000c5bc:	0287d7b3          	divu	a5,a5,s0
8000c5c0:	97b2                	add	a5,a5,a2
8000c5c2:	00c7b633          	sltu	a2,a5,a2
8000c5c6:	9732                	add	a4,a4,a2
8000c5c8:	b72d                	j	8000c4f2 <.L113>

8000c5ca <.L126>:
8000c5ca:	02c707b3          	mul	a5,a4,a2
8000c5ce:	01855613          	srl	a2,a0,0x18
8000c5d2:	0ff6f693          	zext.b	a3,a3
8000c5d6:	40f587b3          	sub	a5,a1,a5
8000c5da:	07a2                	sll	a5,a5,0x8
8000c5dc:	963e                	add	a2,a2,a5
8000c5de:	028657b3          	divu	a5,a2,s0
8000c5e2:	028785b3          	mul	a1,a5,s0
8000c5e6:	07a2                	sll	a5,a5,0x8
8000c5e8:	8e0d                	sub	a2,a2,a1
8000c5ea:	0622                	sll	a2,a2,0x8
8000c5ec:	96b2                	add	a3,a3,a2
8000c5ee:	0286d5b3          	divu	a1,a3,s0
8000c5f2:	97ae                	add	a5,a5,a1
8000c5f4:	07a2                	sll	a5,a5,0x8
8000c5f6:	02858633          	mul	a2,a1,s0
8000c5fa:	8e91                	sub	a3,a3,a2
8000c5fc:	00855613          	srl	a2,a0,0x8
8000c600:	0ff67613          	zext.b	a2,a2
8000c604:	06a2                	sll	a3,a3,0x8
8000c606:	96b2                	add	a3,a3,a2
8000c608:	0286d633          	divu	a2,a3,s0
8000c60c:	97b2                	add	a5,a5,a2
8000c60e:	07a2                	sll	a5,a5,0x8
8000c610:	02860533          	mul	a0,a2,s0
8000c614:	0ff97613          	zext.b	a2,s2
8000c618:	8e89                	sub	a3,a3,a0
8000c61a:	06a2                	sll	a3,a3,0x8
8000c61c:	96b2                	add	a3,a3,a2
8000c61e:	0286d6b3          	divu	a3,a3,s0
8000c622:	97b6                	add	a5,a5,a3
8000c624:	b5f9                	j	8000c4f2 <.L113>

8000c626 <.L114>:
8000c626:	97418b13          	add	s6,gp,-1676 # 80008ce0 <__SEGGER_RTL_Moeller_inverse_lut>
8000c62a:	0ac5fe63          	bgeu	a1,a2,8000c6e6 <.L128>
8000c62e:	10000737          	lui	a4,0x10000
8000c632:	87b2                	mv	a5,a2
8000c634:	00e67563          	bgeu	a2,a4,8000c63e <.L129>
8000c638:	00461793          	sll	a5,a2,0x4
8000c63c:	4a11                	li	s4,4

8000c63e <.L129>:
8000c63e:	40000737          	lui	a4,0x40000
8000c642:	00e7f463          	bgeu	a5,a4,8000c64a <.L130>
8000c646:	0a09                	add	s4,s4,2
8000c648:	078a                	sll	a5,a5,0x2

8000c64a <.L130>:
8000c64a:	0007c363          	bltz	a5,8000c650 <.L131>
8000c64e:	0a05                	add	s4,s4,1

8000c650 <.L131>:
8000c650:	8652                	mv	a2,s4
8000c652:	854a                	mv	a0,s2
8000c654:	85a6                	mv	a1,s1
8000c656:	3409                	jal	8000c058 <__ashldi3>
8000c658:	01441a33          	sll	s4,s0,s4
8000c65c:	016a5793          	srl	a5,s4,0x16
8000c660:	e0078793          	add	a5,a5,-512 # fe00 <__FLASH_segment_used_size__+0x1938>
8000c664:	0786                	sll	a5,a5,0x1
8000c666:	97da                	add	a5,a5,s6
8000c668:	0007d783          	lhu	a5,0(a5)
8000c66c:	00ba5813          	srl	a6,s4,0xb
8000c670:	001a7713          	and	a4,s4,1
8000c674:	02f78633          	mul	a2,a5,a5
8000c678:	0792                	sll	a5,a5,0x4
8000c67a:	001a5693          	srl	a3,s4,0x1
8000c67e:	0805                	add	a6,a6,1
8000c680:	03063633          	mulhu	a2,a2,a6
8000c684:	8f91                	sub	a5,a5,a2
8000c686:	96ba                	add	a3,a3,a4
8000c688:	17fd                	add	a5,a5,-1
8000c68a:	c319                	beqz	a4,8000c690 <.L132>
8000c68c:	0017d713          	srl	a4,a5,0x1

8000c690 <.L132>:
8000c690:	02f686b3          	mul	a3,a3,a5
8000c694:	8f15                	sub	a4,a4,a3
8000c696:	02e7b733          	mulhu	a4,a5,a4
8000c69a:	07be                	sll	a5,a5,0xf
8000c69c:	8305                	srl	a4,a4,0x1
8000c69e:	97ba                	add	a5,a5,a4
8000c6a0:	8752                	mv	a4,s4
8000c6a2:	034786b3          	mul	a3,a5,s4
8000c6a6:	9736                	add	a4,a4,a3
8000c6a8:	00d736b3          	sltu	a3,a4,a3
8000c6ac:	8752                	mv	a4,s4
8000c6ae:	9736                	add	a4,a4,a3
8000c6b0:	0347b6b3          	mulhu	a3,a5,s4
8000c6b4:	9736                	add	a4,a4,a3
8000c6b6:	8f99                	sub	a5,a5,a4
8000c6b8:	02b7b733          	mulhu	a4,a5,a1
8000c6bc:	02b787b3          	mul	a5,a5,a1
8000c6c0:	00a786b3          	add	a3,a5,a0
8000c6c4:	00f6b7b3          	sltu	a5,a3,a5
8000c6c8:	95be                	add	a1,a1,a5
8000c6ca:	972e                	add	a4,a4,a1
8000c6cc:	00170793          	add	a5,a4,1 # 40000001 <__SDRAM_segment_start__+0x1>
8000c6d0:	02fa0633          	mul	a2,s4,a5
8000c6d4:	8d11                	sub	a0,a0,a2
8000c6d6:	00a6f463          	bgeu	a3,a0,8000c6de <.L133>
8000c6da:	9552                	add	a0,a0,s4
8000c6dc:	87ba                	mv	a5,a4

8000c6de <.L133>:
8000c6de:	dd456fe3          	bltu	a0,s4,8000c4bc <.L174>

8000c6e2 <.L160>:
8000c6e2:	0785                	add	a5,a5,1
8000c6e4:	bbe1                	j	8000c4bc <.L174>

8000c6e6 <.L128>:
8000c6e6:	02c5dab3          	divu	s5,a1,a2
8000c6ea:	10000737          	lui	a4,0x10000
8000c6ee:	87b2                	mv	a5,a2
8000c6f0:	02ca85b3          	mul	a1,s5,a2
8000c6f4:	40b485b3          	sub	a1,s1,a1
8000c6f8:	00e67563          	bgeu	a2,a4,8000c702 <.L135>
8000c6fc:	00461793          	sll	a5,a2,0x4
8000c700:	4a11                	li	s4,4

8000c702 <.L135>:
8000c702:	40000737          	lui	a4,0x40000
8000c706:	00e7f463          	bgeu	a5,a4,8000c70e <.L136>
8000c70a:	0a09                	add	s4,s4,2
8000c70c:	078a                	sll	a5,a5,0x2

8000c70e <.L136>:
8000c70e:	0007c363          	bltz	a5,8000c714 <.L137>
8000c712:	0a05                	add	s4,s4,1

8000c714 <.L137>:
8000c714:	8652                	mv	a2,s4
8000c716:	854a                	mv	a0,s2
8000c718:	3281                	jal	8000c058 <__ashldi3>
8000c71a:	01441a33          	sll	s4,s0,s4
8000c71e:	016a5793          	srl	a5,s4,0x16
8000c722:	e0078793          	add	a5,a5,-512
8000c726:	0786                	sll	a5,a5,0x1
8000c728:	9b3e                	add	s6,s6,a5
8000c72a:	000b5783          	lhu	a5,0(s6)
8000c72e:	00ba5813          	srl	a6,s4,0xb
8000c732:	001a7713          	and	a4,s4,1
8000c736:	02f78633          	mul	a2,a5,a5
8000c73a:	0792                	sll	a5,a5,0x4
8000c73c:	001a5693          	srl	a3,s4,0x1
8000c740:	0805                	add	a6,a6,1
8000c742:	03063633          	mulhu	a2,a2,a6
8000c746:	8f91                	sub	a5,a5,a2
8000c748:	96ba                	add	a3,a3,a4
8000c74a:	17fd                	add	a5,a5,-1
8000c74c:	c319                	beqz	a4,8000c752 <.L138>
8000c74e:	0017d713          	srl	a4,a5,0x1

8000c752 <.L138>:
8000c752:	02f686b3          	mul	a3,a3,a5
8000c756:	8f15                	sub	a4,a4,a3
8000c758:	02e7b733          	mulhu	a4,a5,a4
8000c75c:	07be                	sll	a5,a5,0xf
8000c75e:	8305                	srl	a4,a4,0x1
8000c760:	97ba                	add	a5,a5,a4
8000c762:	8752                	mv	a4,s4
8000c764:	034786b3          	mul	a3,a5,s4
8000c768:	9736                	add	a4,a4,a3
8000c76a:	00d736b3          	sltu	a3,a4,a3
8000c76e:	8752                	mv	a4,s4
8000c770:	9736                	add	a4,a4,a3
8000c772:	0347b6b3          	mulhu	a3,a5,s4
8000c776:	9736                	add	a4,a4,a3
8000c778:	8f99                	sub	a5,a5,a4
8000c77a:	02b7b733          	mulhu	a4,a5,a1
8000c77e:	02b787b3          	mul	a5,a5,a1
8000c782:	00a786b3          	add	a3,a5,a0
8000c786:	00f6b7b3          	sltu	a5,a3,a5
8000c78a:	95be                	add	a1,a1,a5
8000c78c:	972e                	add	a4,a4,a1
8000c78e:	00170793          	add	a5,a4,1 # 40000001 <__SDRAM_segment_start__+0x1>
8000c792:	02fa0633          	mul	a2,s4,a5
8000c796:	8d11                	sub	a0,a0,a2
8000c798:	00a6f463          	bgeu	a3,a0,8000c7a0 <.L139>
8000c79c:	9552                	add	a0,a0,s4
8000c79e:	87ba                	mv	a5,a4

8000c7a0 <.L139>:
8000c7a0:	01456363          	bltu	a0,s4,8000c7a6 <.L140>
8000c7a4:	0785                	add	a5,a5,1

8000c7a6 <.L140>:
8000c7a6:	8756                	mv	a4,s5
8000c7a8:	b3a9                	j	8000c4f2 <.L113>

8000c7aa <.L111>:
8000c7aa:	67c1                	lui	a5,0x10
8000c7ac:	4a81                	li	s5,0
8000c7ae:	00f6f563          	bgeu	a3,a5,8000c7b8 <.L141>
8000c7b2:	01069a13          	sll	s4,a3,0x10
8000c7b6:	4ac1                	li	s5,16

8000c7b8 <.L141>:
8000c7b8:	010007b7          	lui	a5,0x1000
8000c7bc:	00fa7463          	bgeu	s4,a5,8000c7c4 <.L142>
8000c7c0:	0aa1                	add	s5,s5,8
8000c7c2:	0a22                	sll	s4,s4,0x8

8000c7c4 <.L142>:
8000c7c4:	100007b7          	lui	a5,0x10000
8000c7c8:	00fa7463          	bgeu	s4,a5,8000c7d0 <.L143>
8000c7cc:	0a91                	add	s5,s5,4
8000c7ce:	0a12                	sll	s4,s4,0x4

8000c7d0 <.L143>:
8000c7d0:	400007b7          	lui	a5,0x40000
8000c7d4:	00fa7463          	bgeu	s4,a5,8000c7dc <.L144>
8000c7d8:	0a89                	add	s5,s5,2
8000c7da:	0a0a                	sll	s4,s4,0x2

8000c7dc <.L144>:
8000c7dc:	000a4363          	bltz	s4,8000c7e2 <.L145>
8000c7e0:	0a85                	add	s5,s5,1

8000c7e2 <.L145>:
8000c7e2:	01f49793          	sll	a5,s1,0x1f
8000c7e6:	8656                	mv	a2,s5
8000c7e8:	00195a13          	srl	s4,s2,0x1
8000c7ec:	8522                	mv	a0,s0
8000c7ee:	85ce                	mv	a1,s3
8000c7f0:	0147ea33          	or	s4,a5,s4
8000c7f4:	3095                	jal	8000c058 <__ashldi3>
8000c7f6:	0165d613          	srl	a2,a1,0x16
8000c7fa:	e0060613          	add	a2,a2,-512
8000c7fe:	0606                	sll	a2,a2,0x1
8000c800:	97418793          	add	a5,gp,-1676 # 80008ce0 <__SEGGER_RTL_Moeller_inverse_lut>
8000c804:	97b2                	add	a5,a5,a2
8000c806:	0007d783          	lhu	a5,0(a5) # 40000000 <__SDRAM_segment_start__>
8000c80a:	00b5d513          	srl	a0,a1,0xb
8000c80e:	0015f713          	and	a4,a1,1
8000c812:	02f78633          	mul	a2,a5,a5
8000c816:	0792                	sll	a5,a5,0x4
8000c818:	0015d693          	srl	a3,a1,0x1
8000c81c:	0505                	add	a0,a0,1
8000c81e:	02a63633          	mulhu	a2,a2,a0
8000c822:	8f91                	sub	a5,a5,a2
8000c824:	0014db13          	srl	s6,s1,0x1
8000c828:	96ba                	add	a3,a3,a4
8000c82a:	17fd                	add	a5,a5,-1
8000c82c:	c319                	beqz	a4,8000c832 <.L146>
8000c82e:	0017d713          	srl	a4,a5,0x1

8000c832 <.L146>:
8000c832:	02f686b3          	mul	a3,a3,a5
8000c836:	8f15                	sub	a4,a4,a3
8000c838:	02e7b733          	mulhu	a4,a5,a4
8000c83c:	07be                	sll	a5,a5,0xf
8000c83e:	8305                	srl	a4,a4,0x1
8000c840:	97ba                	add	a5,a5,a4
8000c842:	872e                	mv	a4,a1
8000c844:	02b786b3          	mul	a3,a5,a1
8000c848:	9736                	add	a4,a4,a3
8000c84a:	00d736b3          	sltu	a3,a4,a3
8000c84e:	872e                	mv	a4,a1
8000c850:	9736                	add	a4,a4,a3
8000c852:	02b7b6b3          	mulhu	a3,a5,a1
8000c856:	9736                	add	a4,a4,a3
8000c858:	8f99                	sub	a5,a5,a4
8000c85a:	0367b733          	mulhu	a4,a5,s6
8000c85e:	036787b3          	mul	a5,a5,s6
8000c862:	014786b3          	add	a3,a5,s4
8000c866:	00f6b7b3          	sltu	a5,a3,a5
8000c86a:	97da                	add	a5,a5,s6
8000c86c:	973e                	add	a4,a4,a5
8000c86e:	00170793          	add	a5,a4,1
8000c872:	02f58633          	mul	a2,a1,a5
8000c876:	40ca0a33          	sub	s4,s4,a2
8000c87a:	0146f463          	bgeu	a3,s4,8000c882 <.L147>
8000c87e:	9a2e                	add	s4,s4,a1
8000c880:	87ba                	mv	a5,a4

8000c882 <.L147>:
8000c882:	00ba6363          	bltu	s4,a1,8000c888 <.L148>
8000c886:	0785                	add	a5,a5,1

8000c888 <.L148>:
8000c888:	477d                	li	a4,31
8000c88a:	41570733          	sub	a4,a4,s5
8000c88e:	00e7d7b3          	srl	a5,a5,a4
8000c892:	c391                	beqz	a5,8000c896 <.L149>
8000c894:	17fd                	add	a5,a5,-1

8000c896 <.L149>:
8000c896:	0287b633          	mulhu	a2,a5,s0
8000c89a:	02f98733          	mul	a4,s3,a5
8000c89e:	028786b3          	mul	a3,a5,s0
8000c8a2:	9732                	add	a4,a4,a2
8000c8a4:	40e48733          	sub	a4,s1,a4
8000c8a8:	40d906b3          	sub	a3,s2,a3
8000c8ac:	00d93633          	sltu	a2,s2,a3
8000c8b0:	8f11                	sub	a4,a4,a2
8000c8b2:	c13765e3          	bltu	a4,s3,8000c4bc <.L174>
8000c8b6:	e2e996e3          	bne	s3,a4,8000c6e2 <.L160>
8000c8ba:	c086e1e3          	bltu	a3,s0,8000c4bc <.L174>
8000c8be:	b515                	j	8000c6e2 <.L160>

8000c8c0 <.L152>:
8000c8c0:	87aa                	mv	a5,a0
8000c8c2:	872e                	mv	a4,a1
8000c8c4:	b13d                	j	8000c4f2 <.L113>

8000c8c6 <.L153>:
8000c8c6:	4781                	li	a5,0
8000c8c8:	bed5                	j	8000c4bc <.L174>

Disassembly of section .text.libc.abs:

8000c8ca <abs>:
8000c8ca:	41f55793          	sra	a5,a0,0x1f
8000c8ce:	8d3d                	xor	a0,a0,a5
8000c8d0:	8d1d                	sub	a0,a0,a5
8000c8d2:	8082                	ret

Disassembly of section .text.libc.memcpy:

8000c8d4 <memcpy>:
8000c8d4:	c251                	beqz	a2,8000c958 <.Lmemcpy_done>
8000c8d6:	87aa                	mv	a5,a0
8000c8d8:	00b546b3          	xor	a3,a0,a1
8000c8dc:	06fa                	sll	a3,a3,0x1e
8000c8de:	e2bd                	bnez	a3,8000c944 <.Lmemcpy_byte_copy>
8000c8e0:	01e51693          	sll	a3,a0,0x1e
8000c8e4:	ce81                	beqz	a3,8000c8fc <.Lmemcpy_aligned>

8000c8e6 <.Lmemcpy_word_align>:
8000c8e6:	00058683          	lb	a3,0(a1)
8000c8ea:	00d50023          	sb	a3,0(a0)
8000c8ee:	0585                	add	a1,a1,1
8000c8f0:	0505                	add	a0,a0,1
8000c8f2:	167d                	add	a2,a2,-1
8000c8f4:	c22d                	beqz	a2,8000c956 <.Lmemcpy_memcpy_end>
8000c8f6:	01e51693          	sll	a3,a0,0x1e
8000c8fa:	f6f5                	bnez	a3,8000c8e6 <.Lmemcpy_word_align>

8000c8fc <.Lmemcpy_aligned>:
8000c8fc:	02000693          	li	a3,32
8000c900:	02d66763          	bltu	a2,a3,8000c92e <.Lmemcpy_word_copy>

8000c904 <.Lmemcpy_aligned_block_copy_loop>:
8000c904:	4198                	lw	a4,0(a1)
8000c906:	c118                	sw	a4,0(a0)
8000c908:	41d8                	lw	a4,4(a1)
8000c90a:	c158                	sw	a4,4(a0)
8000c90c:	4598                	lw	a4,8(a1)
8000c90e:	c518                	sw	a4,8(a0)
8000c910:	45d8                	lw	a4,12(a1)
8000c912:	c558                	sw	a4,12(a0)
8000c914:	4998                	lw	a4,16(a1)
8000c916:	c918                	sw	a4,16(a0)
8000c918:	49d8                	lw	a4,20(a1)
8000c91a:	c958                	sw	a4,20(a0)
8000c91c:	4d98                	lw	a4,24(a1)
8000c91e:	cd18                	sw	a4,24(a0)
8000c920:	4dd8                	lw	a4,28(a1)
8000c922:	cd58                	sw	a4,28(a0)
8000c924:	9536                	add	a0,a0,a3
8000c926:	95b6                	add	a1,a1,a3
8000c928:	8e15                	sub	a2,a2,a3
8000c92a:	fcd67de3          	bgeu	a2,a3,8000c904 <.Lmemcpy_aligned_block_copy_loop>

8000c92e <.Lmemcpy_word_copy>:
8000c92e:	c605                	beqz	a2,8000c956 <.Lmemcpy_memcpy_end>
8000c930:	4691                	li	a3,4
8000c932:	00d66963          	bltu	a2,a3,8000c944 <.Lmemcpy_byte_copy>

8000c936 <.Lmemcpy_word_copy_loop>:
8000c936:	4198                	lw	a4,0(a1)
8000c938:	c118                	sw	a4,0(a0)
8000c93a:	9536                	add	a0,a0,a3
8000c93c:	95b6                	add	a1,a1,a3
8000c93e:	8e15                	sub	a2,a2,a3
8000c940:	fed67be3          	bgeu	a2,a3,8000c936 <.Lmemcpy_word_copy_loop>

8000c944 <.Lmemcpy_byte_copy>:
8000c944:	ca09                	beqz	a2,8000c956 <.Lmemcpy_memcpy_end>

8000c946 <.Lmemcpy_byte_copy_loop>:
8000c946:	00058703          	lb	a4,0(a1)
8000c94a:	00e50023          	sb	a4,0(a0)
8000c94e:	0585                	add	a1,a1,1
8000c950:	0505                	add	a0,a0,1
8000c952:	167d                	add	a2,a2,-1
8000c954:	fa6d                	bnez	a2,8000c946 <.Lmemcpy_byte_copy_loop>

8000c956 <.Lmemcpy_memcpy_end>:
8000c956:	853e                	mv	a0,a5

8000c958 <.Lmemcpy_done>:
8000c958:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pow10f:

8000c95a <__SEGGER_RTL_pow10f>:
8000c95a:	1101                	add	sp,sp,-32
8000c95c:	cc22                	sw	s0,24(sp)
8000c95e:	c64e                	sw	s3,12(sp)
8000c960:	ce06                	sw	ra,28(sp)
8000c962:	ca26                	sw	s1,20(sp)
8000c964:	c84a                	sw	s2,16(sp)
8000c966:	842a                	mv	s0,a0
8000c968:	4981                	li	s3,0
8000c96a:	00055563          	bgez	a0,8000c974 <.L17>
8000c96e:	40a00433          	neg	s0,a0
8000c972:	4985                	li	s3,1

8000c974 <.L17>:
8000c974:	fac1a503          	lw	a0,-84(gp) # 80009318 <.Lmerged_single+0x4>
8000c978:	d7418493          	add	s1,gp,-652 # 800090e0 <__SEGGER_RTL_aPower2f>

8000c97c <.L18>:
8000c97c:	ec19                	bnez	s0,8000c99a <.L20>
8000c97e:	00098763          	beqz	s3,8000c98c <.L16>
8000c982:	85aa                	mv	a1,a0
8000c984:	fac1a503          	lw	a0,-84(gp) # 80009318 <.Lmerged_single+0x4>
8000c988:	701020ef          	jal	8000f888 <__divsf3>

8000c98c <.L16>:
8000c98c:	40f2                	lw	ra,28(sp)
8000c98e:	4462                	lw	s0,24(sp)
8000c990:	44d2                	lw	s1,20(sp)
8000c992:	4942                	lw	s2,16(sp)
8000c994:	49b2                	lw	s3,12(sp)
8000c996:	6105                	add	sp,sp,32
8000c998:	8082                	ret

8000c99a <.L20>:
8000c99a:	00147793          	and	a5,s0,1
8000c99e:	c781                	beqz	a5,8000c9a6 <.L19>
8000c9a0:	408c                	lw	a1,0(s1)
8000c9a2:	527020ef          	jal	8000f6c8 <__mulsf3>

8000c9a6 <.L19>:
8000c9a6:	8405                	sra	s0,s0,0x1
8000c9a8:	0491                	add	s1,s1,4
8000c9aa:	bfc9                	j	8000c97c <.L18>

Disassembly of section .text.libc.__SEGGER_RTL_prin_flush:

8000c9ac <__SEGGER_RTL_prin_flush>:
8000c9ac:	4950                	lw	a2,20(a0)
8000c9ae:	ce19                	beqz	a2,8000c9cc <.L20>
8000c9b0:	511c                	lw	a5,32(a0)
8000c9b2:	1141                	add	sp,sp,-16
8000c9b4:	c422                	sw	s0,8(sp)
8000c9b6:	c606                	sw	ra,12(sp)
8000c9b8:	842a                	mv	s0,a0
8000c9ba:	c399                	beqz	a5,8000c9c0 <.L12>
8000c9bc:	490c                	lw	a1,16(a0)
8000c9be:	9782                	jalr	a5

8000c9c0 <.L12>:
8000c9c0:	40b2                	lw	ra,12(sp)
8000c9c2:	00042a23          	sw	zero,20(s0)
8000c9c6:	4422                	lw	s0,8(sp)
8000c9c8:	0141                	add	sp,sp,16
8000c9ca:	8082                	ret

8000c9cc <.L20>:
8000c9cc:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_pre_padding:

8000c9ce <__SEGGER_RTL_pre_padding>:
8000c9ce:	0105f793          	and	a5,a1,16
8000c9d2:	eb91                	bnez	a5,8000c9e6 <.L40>
8000c9d4:	2005f793          	and	a5,a1,512
8000c9d8:	02000593          	li	a1,32
8000c9dc:	c399                	beqz	a5,8000c9e2 <.L42>
8000c9de:	03000593          	li	a1,48

8000c9e2 <.L42>:
8000c9e2:	5e20306f          	j	8000ffc4 <__SEGGER_RTL_print_padding>

8000c9e6 <.L40>:
8000c9e6:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_init_prin_l:

8000c9e8 <__SEGGER_RTL_init_prin_l>:
8000c9e8:	1141                	add	sp,sp,-16
8000c9ea:	c226                	sw	s1,4(sp)
8000c9ec:	02400613          	li	a2,36
8000c9f0:	84ae                	mv	s1,a1
8000c9f2:	4581                	li	a1,0
8000c9f4:	c422                	sw	s0,8(sp)
8000c9f6:	c606                	sw	ra,12(sp)
8000c9f8:	842a                	mv	s0,a0
8000c9fa:	3ba030ef          	jal	8000fdb4 <memset>
8000c9fe:	40b2                	lw	ra,12(sp)
8000ca00:	cc44                	sw	s1,28(s0)
8000ca02:	4422                	lw	s0,8(sp)
8000ca04:	4492                	lw	s1,4(sp)
8000ca06:	0141                	add	sp,sp,16
8000ca08:	8082                	ret

Disassembly of section .text.libc.vfprintf:

8000ca0a <vfprintf>:
8000ca0a:	1101                	add	sp,sp,-32
8000ca0c:	cc22                	sw	s0,24(sp)
8000ca0e:	ca26                	sw	s1,20(sp)
8000ca10:	ce06                	sw	ra,28(sp)
8000ca12:	84ae                	mv	s1,a1
8000ca14:	842a                	mv	s0,a0
8000ca16:	c632                	sw	a2,12(sp)
8000ca18:	31c040ef          	jal	80010d34 <__SEGGER_RTL_current_locale>
8000ca1c:	85aa                	mv	a1,a0
8000ca1e:	8522                	mv	a0,s0
8000ca20:	4462                	lw	s0,24(sp)
8000ca22:	46b2                	lw	a3,12(sp)
8000ca24:	40f2                	lw	ra,28(sp)
8000ca26:	8626                	mv	a2,s1
8000ca28:	44d2                	lw	s1,20(sp)
8000ca2a:	6105                	add	sp,sp,32
8000ca2c:	5c20306f          	j	8000ffee <vfprintf_l>

Disassembly of section .text.libc.printf:

8000ca30 <printf>:
8000ca30:	7139                	add	sp,sp,-64
8000ca32:	da3e                	sw	a5,52(sp)
8000ca34:	d22e                	sw	a1,36(sp)
8000ca36:	85aa                	mv	a1,a0
8000ca38:	85022503          	lw	a0,-1968(tp) # fffff850 <__APB_SRAM_segment_end__+0xbf0d850>
8000ca3c:	d432                	sw	a2,40(sp)
8000ca3e:	1050                	add	a2,sp,36
8000ca40:	ce06                	sw	ra,28(sp)
8000ca42:	d636                	sw	a3,44(sp)
8000ca44:	d83a                	sw	a4,48(sp)
8000ca46:	dc42                	sw	a6,56(sp)
8000ca48:	de46                	sw	a7,60(sp)
8000ca4a:	c632                	sw	a2,12(sp)
8000ca4c:	3f7d                	jal	8000ca0a <vfprintf>
8000ca4e:	40f2                	lw	ra,28(sp)
8000ca50:	6121                	add	sp,sp,64
8000ca52:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_heap:

8000ca54 <__SEGGER_init_heap>:
8000ca54:	40000537          	lui	a0,0x40000
8000ca58:	00050513          	mv	a0,a0
8000ca5c:	400045b7          	lui	a1,0x40004
8000ca60:	00058593          	mv	a1,a1
8000ca64:	8d89                	sub	a1,a1,a0
8000ca66:	a009                	j	8000ca68 <__SEGGER_RTL_init_heap>

Disassembly of section .text.libc.__SEGGER_RTL_init_heap:

8000ca68 <__SEGGER_RTL_init_heap>:
8000ca68:	479d                	li	a5,7
8000ca6a:	00b7f763          	bgeu	a5,a1,8000ca78 <.L68>
8000ca6e:	84a22223          	sw	a0,-1980(tp) # fffff844 <__APB_SRAM_segment_end__+0xbf0d844>
8000ca72:	00052023          	sw	zero,0(a0) # 40000000 <__SDRAM_segment_start__>
8000ca76:	c14c                	sw	a1,4(a0)

8000ca78 <.L68>:
8000ca78:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_toupper:

8000ca7a <__SEGGER_RTL_ascii_toupper>:
8000ca7a:	f9f50713          	add	a4,a0,-97
8000ca7e:	47e5                	li	a5,25
8000ca80:	00e7e363          	bltu	a5,a4,8000ca86 <.L5>
8000ca84:	1501                	add	a0,a0,-32

8000ca86 <.L5>:
8000ca86:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towupper:

8000ca88 <__SEGGER_RTL_ascii_towupper>:
8000ca88:	f9f50713          	add	a4,a0,-97
8000ca8c:	47e5                	li	a5,25
8000ca8e:	00e7e363          	bltu	a5,a4,8000ca94 <.L12>
8000ca92:	1501                	add	a0,a0,-32

8000ca94 <.L12>:
8000ca94:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_mbtowc:

8000ca96 <__SEGGER_RTL_ascii_mbtowc>:
8000ca96:	87aa                	mv	a5,a0
8000ca98:	4501                	li	a0,0
8000ca9a:	c195                	beqz	a1,8000cabe <.L55>
8000ca9c:	c20d                	beqz	a2,8000cabe <.L55>
8000ca9e:	0005c703          	lbu	a4,0(a1) # 40004000 <__SDRAM_segment_used_end__>
8000caa2:	07f00613          	li	a2,127
8000caa6:	5579                	li	a0,-2
8000caa8:	00e66b63          	bltu	a2,a4,8000cabe <.L55>
8000caac:	c391                	beqz	a5,8000cab0 <.L57>
8000caae:	c398                	sw	a4,0(a5)

8000cab0 <.L57>:
8000cab0:	0006a023          	sw	zero,0(a3)
8000cab4:	0006a223          	sw	zero,4(a3)
8000cab8:	00e03533          	snez	a0,a4
8000cabc:	8082                	ret

8000cabe <.L55>:
8000cabe:	8082                	ret

Disassembly of section .text.l1c_dc_invalidate_all:

8000cac0 <l1c_dc_invalidate_all>:
{
8000cac0:	1141                	add	sp,sp,-16
8000cac2:	47dd                	li	a5,23
8000cac4:	00f107a3          	sb	a5,15(sp)

8000cac8 <.LBB68>:
    write_csr(CSR_MCCTLCOMMAND, cmd);
8000cac8:	00f14783          	lbu	a5,15(sp)
8000cacc:	7cc79073          	csrw	0x7cc,a5
}
8000cad0:	0001                	nop

8000cad2 <.LBE68>:
}
8000cad2:	0001                	nop
8000cad4:	0141                	add	sp,sp,16
8000cad6:	8082                	ret

Disassembly of section .text.sysctl_clock_set_preset:

8000cad8 <sysctl_clock_set_preset>:
{
8000cad8:	1141                	add	sp,sp,-16
8000cada:	c62a                	sw	a0,12(sp)
8000cadc:	87ae                	mv	a5,a1
8000cade:	00f105a3          	sb	a5,11(sp)
    ptr->GLOBAL00 = (ptr->GLOBAL00 & ~SYSCTL_GLOBAL00_PRESET_MASK)
8000cae2:	4732                	lw	a4,12(sp)
8000cae4:	6789                	lui	a5,0x2
8000cae6:	97ba                	add	a5,a5,a4
8000cae8:	439c                	lw	a5,0(a5)
8000caea:	ff07f713          	and	a4,a5,-16
                | SYSCTL_GLOBAL00_PRESET_SET(preset);
8000caee:	00b14783          	lbu	a5,11(sp)
8000caf2:	8bbd                	and	a5,a5,15
8000caf4:	8f5d                	or	a4,a4,a5
    ptr->GLOBAL00 = (ptr->GLOBAL00 & ~SYSCTL_GLOBAL00_PRESET_MASK)
8000caf6:	46b2                	lw	a3,12(sp)
8000caf8:	6789                	lui	a5,0x2
8000cafa:	97b6                	add	a5,a5,a3
8000cafc:	c398                	sw	a4,0(a5)
}
8000cafe:	0001                	nop
8000cb00:	0141                	add	sp,sp,16
8000cb02:	8082                	ret

Disassembly of section .text.gptmr_check_status:

8000cb04 <gptmr_check_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline bool gptmr_check_status(GPTMR_Type *ptr, uint32_t mask)
{
8000cb04:	1141                	add	sp,sp,-16
8000cb06:	c62a                	sw	a0,12(sp)
8000cb08:	c42e                	sw	a1,8(sp)
    return (ptr->SR & mask) == mask;
8000cb0a:	47b2                	lw	a5,12(sp)
8000cb0c:	2007a703          	lw	a4,512(a5) # 2200 <__APB_SRAM_segment_size__+0x200>
8000cb10:	47a2                	lw	a5,8(sp)
8000cb12:	8ff9                	and	a5,a5,a4
8000cb14:	4722                	lw	a4,8(sp)
8000cb16:	40f707b3          	sub	a5,a4,a5
8000cb1a:	0017b793          	seqz	a5,a5
8000cb1e:	0ff7f793          	zext.b	a5,a5
}
8000cb22:	853e                	mv	a0,a5
8000cb24:	0141                	add	sp,sp,16
8000cb26:	8082                	ret

Disassembly of section .text.gptmr_clear_status:

8000cb28 <gptmr_clear_status>:
 *
 * @param [in] ptr GPTMR base address
 * @param [in] mask channel flag mask
 */
static inline void gptmr_clear_status(GPTMR_Type *ptr, uint32_t mask)
{
8000cb28:	1141                	add	sp,sp,-16
8000cb2a:	c62a                	sw	a0,12(sp)
8000cb2c:	c42e                	sw	a1,8(sp)
    ptr->SR = mask;
8000cb2e:	47b2                	lw	a5,12(sp)
8000cb30:	4722                	lw	a4,8(sp)
8000cb32:	20e7a023          	sw	a4,512(a5)
}
8000cb36:	0001                	nop
8000cb38:	0141                	add	sp,sp,16
8000cb3a:	8082                	ret

Disassembly of section .text.gpio_read_pin:

8000cb3c <gpio_read_pin>:
 * @param pin Pin index
 *
 * @return Pin status mask
 */
static inline uint8_t gpio_read_pin(GPIO_Type *ptr, uint32_t port, uint8_t pin)
{
8000cb3c:	1141                	add	sp,sp,-16
8000cb3e:	c62a                	sw	a0,12(sp)
8000cb40:	c42e                	sw	a1,8(sp)
8000cb42:	87b2                	mv	a5,a2
8000cb44:	00f103a3          	sb	a5,7(sp)
    return (ptr->DI[port].VALUE & (1 << pin)) >> pin;
8000cb48:	4732                	lw	a4,12(sp)
8000cb4a:	47a2                	lw	a5,8(sp)
8000cb4c:	0792                	sll	a5,a5,0x4
8000cb4e:	97ba                	add	a5,a5,a4
8000cb50:	439c                	lw	a5,0(a5)
8000cb52:	00714703          	lbu	a4,7(sp)
8000cb56:	4685                	li	a3,1
8000cb58:	00e69733          	sll	a4,a3,a4
8000cb5c:	8f7d                	and	a4,a4,a5
8000cb5e:	00714783          	lbu	a5,7(sp)
8000cb62:	00f757b3          	srl	a5,a4,a5
8000cb66:	0ff7f793          	zext.b	a5,a5
}
8000cb6a:	853e                	mv	a0,a5
8000cb6c:	0141                	add	sp,sp,16
8000cb6e:	8082                	ret

Disassembly of section .text.board_init_console:

8000cb70 <board_init_console>:
{
8000cb70:	1101                	add	sp,sp,-32
8000cb72:	ce06                	sw	ra,28(sp)
    init_uart_pins((UART_Type *) BOARD_CONSOLE_UART_BASE);
8000cb74:	f0040537          	lui	a0,0xf0040
8000cb78:	2e99                	jal	8000cece <init_uart_pins>
    clock_add_to_group(BOARD_CONSOLE_UART_CLK_NAME, 0);
8000cb7a:	4581                	li	a1,0
8000cb7c:	012207b7          	lui	a5,0x1220
8000cb80:	01378513          	add	a0,a5,19 # 1220013 <__SHARE_RAM_segment_end__+0xa0013>
8000cb84:	ccdfe0ef          	jal	8000b850 <clock_add_to_group>
    cfg.type = BOARD_CONSOLE_TYPE;
8000cb88:	c002                	sw	zero,0(sp)
    cfg.base = (uint32_t) BOARD_CONSOLE_UART_BASE;
8000cb8a:	f00407b7          	lui	a5,0xf0040
8000cb8e:	c23e                	sw	a5,4(sp)
    cfg.src_freq_in_hz = clock_get_frequency(BOARD_CONSOLE_UART_CLK_NAME);
8000cb90:	012207b7          	lui	a5,0x1220
8000cb94:	01378513          	add	a0,a5,19 # 1220013 <__SHARE_RAM_segment_end__+0xa0013>
8000cb98:	aabfe0ef          	jal	8000b642 <clock_get_frequency>
8000cb9c:	87aa                	mv	a5,a0
8000cb9e:	c43e                	sw	a5,8(sp)
    cfg.baudrate = BOARD_CONSOLE_UART_BAUDRATE;
8000cba0:	67f1                	lui	a5,0x1c
8000cba2:	20078793          	add	a5,a5,512 # 1c200 <__FLASH_segment_used_size__+0xdd38>
8000cba6:	c63e                	sw	a5,12(sp)
    if (status_success != console_init(&cfg)) {
8000cba8:	878a                	mv	a5,sp
8000cbaa:	853e                	mv	a0,a5
8000cbac:	2de9                	jal	8000d286 <console_init>
8000cbae:	87aa                	mv	a5,a0
8000cbb0:	c391                	beqz	a5,8000cbb4 <.L74>

8000cbb2 <.L73>:
        while (1) {
8000cbb2:	a001                	j	8000cbb2 <.L73>

8000cbb4 <.L74>:
}
8000cbb4:	0001                	nop
8000cbb6:	40f2                	lw	ra,28(sp)
8000cbb8:	6105                	add	sp,sp,32
8000cbba:	8082                	ret

Disassembly of section .text.board_turnoff_rgb_led:

8000cbbc <board_turnoff_rgb_led>:
{
8000cbbc:	1101                	add	sp,sp,-32
8000cbbe:	ce06                	sw	ra,28(sp)
    uint32_t pad_ctl = IOC_PAD_PAD_CTL_PE_SET(1) | IOC_PAD_PAD_CTL_PS_SET(1);
8000cbc0:	6785                	lui	a5,0x1
8000cbc2:	81078793          	add	a5,a5,-2032 # 810 <__ILM_segment_used_end__+0x14a>
8000cbc6:	c63e                	sw	a5,12(sp)
    HPM_IOC->PAD[IOC_PAD_PB18].FUNC_CTL = IOC_PB18_FUNC_CTL_GPIO_B_18;
8000cbc8:	f40407b7          	lui	a5,0xf4040
8000cbcc:	1807a823          	sw	zero,400(a5) # f4040190 <__AHB_SRAM_segment_end__+0x3d38190>
    HPM_IOC->PAD[IOC_PAD_PB19].FUNC_CTL = IOC_PB19_FUNC_CTL_GPIO_B_19;
8000cbd0:	f40407b7          	lui	a5,0xf4040
8000cbd4:	1807ac23          	sw	zero,408(a5) # f4040198 <__AHB_SRAM_segment_end__+0x3d38198>
    HPM_IOC->PAD[IOC_PAD_PB20].FUNC_CTL = IOC_PB20_FUNC_CTL_GPIO_B_20;
8000cbd8:	f40407b7          	lui	a5,0xf4040
8000cbdc:	1a07a023          	sw	zero,416(a5) # f40401a0 <__AHB_SRAM_segment_end__+0x3d381a0>
    HPM_IOC->PAD[IOC_PAD_PB18].PAD_CTL = pad_ctl;
8000cbe0:	f40407b7          	lui	a5,0xf4040
8000cbe4:	4732                	lw	a4,12(sp)
8000cbe6:	18e7aa23          	sw	a4,404(a5) # f4040194 <__AHB_SRAM_segment_end__+0x3d38194>
    HPM_IOC->PAD[IOC_PAD_PB19].PAD_CTL = pad_ctl;
8000cbea:	f40407b7          	lui	a5,0xf4040
8000cbee:	4732                	lw	a4,12(sp)
8000cbf0:	18e7ae23          	sw	a4,412(a5) # f404019c <__AHB_SRAM_segment_end__+0x3d3819c>
    HPM_IOC->PAD[IOC_PAD_PB20].PAD_CTL = pad_ctl;
8000cbf4:	f40407b7          	lui	a5,0xf4040
8000cbf8:	4732                	lw	a4,12(sp)
8000cbfa:	1ae7a223          	sw	a4,420(a5) # f40401a4 <__AHB_SRAM_segment_end__+0x3d381a4>
    port_pin18_status = gpio_read_pin(BOARD_G_GPIO_CTRL, GPIO_DI_GPIOB, 18);
8000cbfe:	4649                	li	a2,18
8000cc00:	4585                	li	a1,1
8000cc02:	f0000537          	lui	a0,0xf0000
8000cc06:	3f1d                	jal	8000cb3c <gpio_read_pin>
8000cc08:	87aa                	mv	a5,a0
8000cc0a:	00f105a3          	sb	a5,11(sp)
    port_pin19_status = gpio_read_pin(BOARD_G_GPIO_CTRL, GPIO_DI_GPIOB, 19);
8000cc0e:	464d                	li	a2,19
8000cc10:	4585                	li	a1,1
8000cc12:	f0000537          	lui	a0,0xf0000
8000cc16:	371d                	jal	8000cb3c <gpio_read_pin>
8000cc18:	87aa                	mv	a5,a0
8000cc1a:	00f10523          	sb	a5,10(sp)
    port_pin20_status = gpio_read_pin(BOARD_G_GPIO_CTRL, GPIO_DI_GPIOB, 20);
8000cc1e:	4651                	li	a2,20
8000cc20:	4585                	li	a1,1
8000cc22:	f0000537          	lui	a0,0xf0000
8000cc26:	3f19                	jal	8000cb3c <gpio_read_pin>
8000cc28:	87aa                	mv	a5,a0
8000cc2a:	00f104a3          	sb	a5,9(sp)
    invert_led_level = false;
8000cc2e:	84020423          	sb	zero,-1976(tp) # fffff848 <__APB_SRAM_segment_end__+0xbf0d848>
    if ((port_pin18_status & port_pin19_status & port_pin20_status) == 0) {
8000cc32:	00b14783          	lbu	a5,11(sp)
8000cc36:	873e                	mv	a4,a5
8000cc38:	00a14783          	lbu	a5,10(sp)
8000cc3c:	8ff9                	and	a5,a5,a4
8000cc3e:	0ff7f793          	zext.b	a5,a5
8000cc42:	00914703          	lbu	a4,9(sp)
8000cc46:	8ff9                	and	a5,a5,a4
8000cc48:	0ff7f793          	zext.b	a5,a5
8000cc4c:	e78d                	bnez	a5,8000cc76 <.L80>
        invert_led_level = true;
8000cc4e:	4705                	li	a4,1
8000cc50:	84e20423          	sb	a4,-1976(tp) # fffff848 <__APB_SRAM_segment_end__+0xbf0d848>
        pad_ctl = IOC_PAD_PAD_CTL_PE_SET(1) | IOC_PAD_PAD_CTL_PS_SET(0);
8000cc54:	47c1                	li	a5,16
8000cc56:	c63e                	sw	a5,12(sp)
        HPM_IOC->PAD[IOC_PAD_PB18].PAD_CTL = pad_ctl;
8000cc58:	f40407b7          	lui	a5,0xf4040
8000cc5c:	4732                	lw	a4,12(sp)
8000cc5e:	18e7aa23          	sw	a4,404(a5) # f4040194 <__AHB_SRAM_segment_end__+0x3d38194>
        HPM_IOC->PAD[IOC_PAD_PB19].PAD_CTL = pad_ctl;
8000cc62:	f40407b7          	lui	a5,0xf4040
8000cc66:	4732                	lw	a4,12(sp)
8000cc68:	18e7ae23          	sw	a4,412(a5) # f404019c <__AHB_SRAM_segment_end__+0x3d3819c>
        HPM_IOC->PAD[IOC_PAD_PB20].PAD_CTL = pad_ctl;
8000cc6c:	f40407b7          	lui	a5,0xf4040
8000cc70:	4732                	lw	a4,12(sp)
8000cc72:	1ae7a223          	sw	a4,420(a5) # f40401a4 <__AHB_SRAM_segment_end__+0x3d381a4>

8000cc76 <.L80>:
}
8000cc76:	0001                	nop
8000cc78:	40f2                	lw	ra,28(sp)
8000cc7a:	6105                	add	sp,sp,32
8000cc7c:	8082                	ret

Disassembly of section .text.board_init:

8000cc7e <board_init>:
{
8000cc7e:	1141                	add	sp,sp,-16
8000cc80:	c606                	sw	ra,12(sp)
    board_turnoff_rgb_led();
8000cc82:	3f2d                	jal	8000cbbc <board_turnoff_rgb_led>
    board_init_clock();
8000cc84:	ba6fd0ef          	jal	8000a02a <board_init_clock>
    board_init_console();
8000cc88:	35e5                	jal	8000cb70 <board_init_console>
    board_init_pmp();
8000cc8a:	978fd0ef          	jal	80009e02 <board_init_pmp>
    board_print_clock_freq();
8000cc8e:	fb1fc0ef          	jal	80009c3e <board_print_clock_freq>
    board_print_banner();
8000cc92:	910fd0ef          	jal	80009da2 <board_print_banner>
}
8000cc96:	0001                	nop
8000cc98:	40b2                	lw	ra,12(sp)
8000cc9a:	0141                	add	sp,sp,16
8000cc9c:	8082                	ret

Disassembly of section .text.board_init_sdram_pins:

8000cc9e <board_init_sdram_pins>:
{
8000cc9e:	1141                	add	sp,sp,-16
8000cca0:	c606                	sw	ra,12(sp)
    init_femc_pins();
8000cca2:	26a5                	jal	8000d00a <init_femc_pins>
}
8000cca4:	0001                	nop
8000cca6:	40b2                	lw	ra,12(sp)
8000cca8:	0141                	add	sp,sp,16
8000ccaa:	8082                	ret

Disassembly of section .text.board_init_femc_clock:

8000ccac <board_init_femc_clock>:
{
8000ccac:	1141                	add	sp,sp,-16
8000ccae:	c606                	sw	ra,12(sp)
    clock_add_to_group(clock_femc, 0);
8000ccb0:	4581                	li	a1,0
8000ccb2:	010407b7          	lui	a5,0x1040
8000ccb6:	00878513          	add	a0,a5,8 # 1040008 <_extram_size+0x40008>
8000ccba:	b97fe0ef          	jal	8000b850 <clock_add_to_group>
    clock_set_source_divider(clock_femc, clk_src_pll2_clk0, 2U); /* 166Mhz */
8000ccbe:	4609                	li	a2,2
8000ccc0:	4591                	li	a1,4
8000ccc2:	010407b7          	lui	a5,0x1040
8000ccc6:	00878513          	add	a0,a5,8 # 1040008 <_extram_size+0x40008>
8000ccca:	aaffe0ef          	jal	8000b778 <clock_set_source_divider>
    return clock_get_frequency(clock_femc);
8000ccce:	010407b7          	lui	a5,0x1040
8000ccd2:	00878513          	add	a0,a5,8 # 1040008 <_extram_size+0x40008>
8000ccd6:	96dfe0ef          	jal	8000b642 <clock_get_frequency>
8000ccda:	87aa                	mv	a5,a0
}
8000ccdc:	853e                	mv	a0,a5
8000ccde:	40b2                	lw	ra,12(sp)
8000cce0:	0141                	add	sp,sp,16
8000cce2:	8082                	ret

Disassembly of section .text.board_init_can:

8000cce4 <board_init_can>:
    (void)ptr;
    clock_add_to_group(BOARD_ACMP_CLK, BOARD_RUNNING_CORE & 0x1);
}

void board_init_can(CAN_Type *ptr)
{
8000cce4:	1101                	add	sp,sp,-32
8000cce6:	ce06                	sw	ra,28(sp)
8000cce8:	c62a                	sw	a0,12(sp)
    init_can_pins(ptr);
8000ccea:	4532                	lw	a0,12(sp)
8000ccec:	2b8d                	jal	8000d25e <init_can_pins>
}
8000ccee:	0001                	nop
8000ccf0:	40f2                	lw	ra,28(sp)
8000ccf2:	6105                	add	sp,sp,32
8000ccf4:	8082                	ret

Disassembly of section .text.board_init_can_clock:

8000ccf6 <board_init_can_clock>:

uint32_t board_init_can_clock(CAN_Type *ptr)
{
8000ccf6:	7179                	add	sp,sp,-48
8000ccf8:	d606                	sw	ra,44(sp)
8000ccfa:	c62a                	sw	a0,12(sp)
    uint32_t freq = 0;
8000ccfc:	ce02                	sw	zero,28(sp)
    if (ptr == HPM_CAN0) {
8000ccfe:	4732                	lw	a4,12(sp)
8000cd00:	f00807b7          	lui	a5,0xf0080
8000cd04:	02f71963          	bne	a4,a5,8000cd36 <.L194>
        /* Set the CAN0 peripheral clock to 80MHz */
        clock_set_source_divider(clock_can0, clk_src_pll1_clk1, 5);
8000cd08:	4615                	li	a2,5
8000cd0a:	458d                	li	a1,3
8000cd0c:	013a07b7          	lui	a5,0x13a0
8000cd10:	02b78513          	add	a0,a5,43 # 13a002b <__SHARE_RAM_segment_end__+0x22002b>
8000cd14:	a65fe0ef          	jal	8000b778 <clock_set_source_divider>
        clock_add_to_group(clock_can0, 0);
8000cd18:	4581                	li	a1,0
8000cd1a:	013a07b7          	lui	a5,0x13a0
8000cd1e:	02b78513          	add	a0,a5,43 # 13a002b <__SHARE_RAM_segment_end__+0x22002b>
8000cd22:	b2ffe0ef          	jal	8000b850 <clock_add_to_group>
        freq = clock_get_frequency(clock_can0);
8000cd26:	013a07b7          	lui	a5,0x13a0
8000cd2a:	02b78513          	add	a0,a5,43 # 13a002b <__SHARE_RAM_segment_end__+0x22002b>
8000cd2e:	915fe0ef          	jal	8000b642 <clock_get_frequency>
8000cd32:	ce2a                	sw	a0,28(sp)
8000cd34:	a065                	j	8000cddc <.L195>

8000cd36 <.L194>:
    } else if (ptr == HPM_CAN1) {
8000cd36:	4732                	lw	a4,12(sp)
8000cd38:	f00847b7          	lui	a5,0xf0084
8000cd3c:	02f71963          	bne	a4,a5,8000cd6e <.L196>
        /* Set the CAN1 peripheral clock to 80MHz */
        clock_set_source_divider(clock_can1, clk_src_pll1_clk1, 5);
8000cd40:	4615                	li	a2,5
8000cd42:	458d                	li	a1,3
8000cd44:	013b07b7          	lui	a5,0x13b0
8000cd48:	02c78513          	add	a0,a5,44 # 13b002c <__SHARE_RAM_segment_end__+0x23002c>
8000cd4c:	a2dfe0ef          	jal	8000b778 <clock_set_source_divider>
        clock_add_to_group(clock_can1, 0);
8000cd50:	4581                	li	a1,0
8000cd52:	013b07b7          	lui	a5,0x13b0
8000cd56:	02c78513          	add	a0,a5,44 # 13b002c <__SHARE_RAM_segment_end__+0x23002c>
8000cd5a:	af7fe0ef          	jal	8000b850 <clock_add_to_group>
        freq = clock_get_frequency(clock_can1);
8000cd5e:	013b07b7          	lui	a5,0x13b0
8000cd62:	02c78513          	add	a0,a5,44 # 13b002c <__SHARE_RAM_segment_end__+0x23002c>
8000cd66:	8ddfe0ef          	jal	8000b642 <clock_get_frequency>
8000cd6a:	ce2a                	sw	a0,28(sp)
8000cd6c:	a885                	j	8000cddc <.L195>

8000cd6e <.L196>:
    } else if (ptr == HPM_CAN2) {
8000cd6e:	4732                	lw	a4,12(sp)
8000cd70:	f00887b7          	lui	a5,0xf0088
8000cd74:	02f71963          	bne	a4,a5,8000cda6 <.L197>
        /* Set the CAN2 peripheral clock to 80MHz */
        clock_set_source_divider(clock_can2, clk_src_pll1_clk1, 5);
8000cd78:	4615                	li	a2,5
8000cd7a:	458d                	li	a1,3
8000cd7c:	013c07b7          	lui	a5,0x13c0
8000cd80:	02d78513          	add	a0,a5,45 # 13c002d <__SHARE_RAM_segment_end__+0x24002d>
8000cd84:	9f5fe0ef          	jal	8000b778 <clock_set_source_divider>
        clock_add_to_group(clock_can2, 0);
8000cd88:	4581                	li	a1,0
8000cd8a:	013c07b7          	lui	a5,0x13c0
8000cd8e:	02d78513          	add	a0,a5,45 # 13c002d <__SHARE_RAM_segment_end__+0x24002d>
8000cd92:	abffe0ef          	jal	8000b850 <clock_add_to_group>
        freq = clock_get_frequency(clock_can2);
8000cd96:	013c07b7          	lui	a5,0x13c0
8000cd9a:	02d78513          	add	a0,a5,45 # 13c002d <__SHARE_RAM_segment_end__+0x24002d>
8000cd9e:	8a5fe0ef          	jal	8000b642 <clock_get_frequency>
8000cda2:	ce2a                	sw	a0,28(sp)
8000cda4:	a825                	j	8000cddc <.L195>

8000cda6 <.L197>:
    } else if (ptr == HPM_CAN3) {
8000cda6:	4732                	lw	a4,12(sp)
8000cda8:	f008c7b7          	lui	a5,0xf008c
8000cdac:	02f71863          	bne	a4,a5,8000cddc <.L195>
        /* Set the CAN3 peripheral clock to 80MHz */
        clock_set_source_divider(clock_can3, clk_src_pll1_clk1, 5);
8000cdb0:	4615                	li	a2,5
8000cdb2:	458d                	li	a1,3
8000cdb4:	013d07b7          	lui	a5,0x13d0
8000cdb8:	02e78513          	add	a0,a5,46 # 13d002e <__SHARE_RAM_segment_end__+0x25002e>
8000cdbc:	9bdfe0ef          	jal	8000b778 <clock_set_source_divider>
        clock_add_to_group(clock_can3, 0);
8000cdc0:	4581                	li	a1,0
8000cdc2:	013d07b7          	lui	a5,0x13d0
8000cdc6:	02e78513          	add	a0,a5,46 # 13d002e <__SHARE_RAM_segment_end__+0x25002e>
8000cdca:	a87fe0ef          	jal	8000b850 <clock_add_to_group>
        freq = clock_get_frequency(clock_can3);
8000cdce:	013d07b7          	lui	a5,0x13d0
8000cdd2:	02e78513          	add	a0,a5,46 # 13d002e <__SHARE_RAM_segment_end__+0x25002e>
8000cdd6:	86dfe0ef          	jal	8000b642 <clock_get_frequency>
8000cdda:	ce2a                	sw	a0,28(sp)

8000cddc <.L195>:
    } else {
        /* Invalid CAN instance */
    }
    return freq;
8000cddc:	47f2                	lw	a5,28(sp)
}
8000cdde:	853e                	mv	a0,a5
8000cde0:	50b2                	lw	ra,44(sp)
8000cde2:	6145                	add	sp,sp,48
8000cde4:	8082                	ret

Disassembly of section .text._init_ext_ram:

8000cde6 <_init_ext_ram>:
#ifdef INIT_EXT_RAM_FOR_DATA
/*
 * this function will be called during startup to initialize external memory for data use
 */
void _init_ext_ram(void)
{
8000cde6:	715d                	add	sp,sp,-80
8000cde8:	c686                	sw	ra,76(sp)
    uint32_t femc_clk_in_hz;
    femc_config_t config = {0};
8000cdea:	d402                	sw	zero,40(sp)
8000cdec:	d602                	sw	zero,44(sp)
8000cdee:	d802                	sw	zero,48(sp)
8000cdf0:	da02                	sw	zero,52(sp)
8000cdf2:	02010c23          	sb	zero,56(sp)
    femc_sdram_config_t sdram_config = {0};
8000cdf6:	c202                	sw	zero,4(sp)
8000cdf8:	c402                	sw	zero,8(sp)
8000cdfa:	c602                	sw	zero,12(sp)
8000cdfc:	c802                	sw	zero,16(sp)
8000cdfe:	ca02                	sw	zero,20(sp)
8000ce00:	cc02                	sw	zero,24(sp)
8000ce02:	ce02                	sw	zero,28(sp)
8000ce04:	d002                	sw	zero,32(sp)
8000ce06:	d202                	sw	zero,36(sp)

    board_init_sdram_pins();
8000ce08:	3d59                	jal	8000cc9e <board_init_sdram_pins>
    femc_clk_in_hz = board_init_femc_clock();
8000ce0a:	354d                	jal	8000ccac <board_init_femc_clock>
8000ce0c:	de2a                	sw	a0,60(sp)
    femc_default_config(HPM_FEMC, &config);
8000ce0e:	103c                	add	a5,sp,40
8000ce10:	85be                	mv	a1,a5
8000ce12:	f3050537          	lui	a0,0xf3050
8000ce16:	e27fd0ef          	jal	8000ac3c <femc_default_config>
    femc_init(HPM_FEMC, &config);
8000ce1a:	103c                	add	a5,sp,40
8000ce1c:	85be                	mv	a1,a5
8000ce1e:	f3050537          	lui	a0,0xf3050
8000ce22:	ea1fd0ef          	jal	8000acc2 <femc_init>

    femc_get_typical_sdram_config(HPM_FEMC, &sdram_config);
8000ce26:	005c                	add	a5,sp,4
8000ce28:	85be                	mv	a1,a5
8000ce2a:	f3050537          	lui	a0,0xf3050
8000ce2e:	481000ef          	jal	8000daae <femc_get_typical_sdram_config>

    sdram_config.bank_num = FEMC_SDRAM_BANK_NUM_4;
8000ce32:	000109a3          	sb	zero,19(sp)
    sdram_config.prescaler = 0x3;
8000ce36:	478d                	li	a5,3
8000ce38:	00f10a23          	sb	a5,20(sp)
    sdram_config.burst_len_in_byte = 8;
8000ce3c:	47a1                	li	a5,8
8000ce3e:	00f10b23          	sb	a5,22(sp)
    sdram_config.auto_refresh_count_in_one_burst = 1;
8000ce42:	4785                	li	a5,1
8000ce44:	02f101a3          	sb	a5,35(sp)
    sdram_config.col_addr_bits = BOARD_SDRAM_COLUMN_ADDR_BITS;
8000ce48:	478d                	li	a5,3
8000ce4a:	00f10823          	sb	a5,16(sp)
    sdram_config.cas_latency = FEMC_SDRAM_CAS_LATENCY_3;
8000ce4e:	478d                	li	a5,3
8000ce50:	00f108a3          	sb	a5,17(sp)

    sdram_config.refresh_to_refresh_in_ns = 60;     /* Trc */
8000ce54:	03c00793          	li	a5,60
8000ce58:	00f10e23          	sb	a5,28(sp)
    sdram_config.refresh_recover_in_ns = 60;        /* Trc */
8000ce5c:	03c00793          	li	a5,60
8000ce60:	00f10fa3          	sb	a5,31(sp)
    sdram_config.act_to_precharge_in_ns = 42;       /* Tras */
8000ce64:	02a00793          	li	a5,42
8000ce68:	00f10c23          	sb	a5,24(sp)
    sdram_config.act_to_rw_in_ns = 18;              /* Trcd */
8000ce6c:	47c9                	li	a5,18
8000ce6e:	00f10d23          	sb	a5,26(sp)
    sdram_config.precharge_to_act_in_ns = 18;       /* Trp */
8000ce72:	47c9                	li	a5,18
8000ce74:	00f10ca3          	sb	a5,25(sp)
    sdram_config.act_to_act_in_ns = 12;             /* Trrd */
8000ce78:	47b1                	li	a5,12
8000ce7a:	00f10da3          	sb	a5,27(sp)
    sdram_config.write_recover_in_ns = 12;          /* Twr/Tdpl */
8000ce7e:	47b1                	li	a5,12
8000ce80:	00f10ea3          	sb	a5,29(sp)
    sdram_config.self_refresh_recover_in_ns = 72;   /* Txsr */
8000ce84:	04800793          	li	a5,72
8000ce88:	00f10f23          	sb	a5,30(sp)

    sdram_config.cs = BOARD_SDRAM_CS;
8000ce8c:	00010923          	sb	zero,18(sp)
    sdram_config.base_address = BOARD_SDRAM_ADDRESS;
8000ce90:	400007b7          	lui	a5,0x40000
8000ce94:	c23e                	sw	a5,4(sp)
    sdram_config.size_in_byte = BOARD_SDRAM_SIZE;
8000ce96:	010007b7          	lui	a5,0x1000
8000ce9a:	c43e                	sw	a5,8(sp)
    sdram_config.port_size = BOARD_SDRAM_PORT_SIZE;
8000ce9c:	4785                	li	a5,1
8000ce9e:	00f10aa3          	sb	a5,21(sp)
    sdram_config.refresh_count = BOARD_SDRAM_REFRESH_COUNT;
8000cea2:	6785                	lui	a5,0x1
8000cea4:	c63e                	sw	a5,12(sp)
    sdram_config.refresh_in_ms = BOARD_SDRAM_REFRESH_IN_MS;
8000cea6:	04000793          	li	a5,64
8000ceaa:	02f10023          	sb	a5,32(sp)
    sdram_config.delay_cell_disable = true;
8000ceae:	4785                	li	a5,1
8000ceb0:	02f10223          	sb	a5,36(sp)
    sdram_config.delay_cell_value = 0;
8000ceb4:	020102a3          	sb	zero,37(sp)

    femc_config_sdram(HPM_FEMC, femc_clk_in_hz, &sdram_config);
8000ceb8:	005c                	add	a5,sp,4
8000ceba:	863e                	mv	a2,a5
8000cebc:	55f2                	lw	a1,60(sp)
8000cebe:	f3050537          	lui	a0,0xf3050
8000cec2:	4f1000ef          	jal	8000dbb2 <femc_config_sdram>
}
8000cec6:	0001                	nop
8000cec8:	40b6                	lw	ra,76(sp)
8000ceca:	6161                	add	sp,sp,80
8000cecc:	8082                	ret

Disassembly of section .text.init_uart_pins:

8000cece <init_uart_pins>:
 */

#include "board.h"

void init_uart_pins(UART_Type *ptr)
{
8000cece:	1141                	add	sp,sp,-16
8000ced0:	c62a                	sw	a0,12(sp)
    if (ptr == HPM_UART0) {
8000ced2:	4732                	lw	a4,12(sp)
8000ced4:	f00407b7          	lui	a5,0xf0040
8000ced8:	02f71f63          	bne	a4,a5,8000cf16 <.L4>
        HPM_IOC->PAD[IOC_PAD_PY07].FUNC_CTL = IOC_PY07_FUNC_CTL_UART0_RXD;
8000cedc:	f4040737          	lui	a4,0xf4040
8000cee0:	6785                	lui	a5,0x1
8000cee2:	97ba                	add	a5,a5,a4
8000cee4:	4709                	li	a4,2
8000cee6:	e2e7ac23          	sw	a4,-456(a5) # e38 <__NOR_CFG_OPTION_segment_size__+0x238>
        HPM_IOC->PAD[IOC_PAD_PY06].FUNC_CTL = IOC_PY06_FUNC_CTL_UART0_TXD;
8000ceea:	f4040737          	lui	a4,0xf4040
8000ceee:	6785                	lui	a5,0x1
8000cef0:	97ba                	add	a5,a5,a4
8000cef2:	4709                	li	a4,2
8000cef4:	e2e7a823          	sw	a4,-464(a5) # e30 <__NOR_CFG_OPTION_segment_size__+0x230>
        /* PY port IO needs to configure PIOC as well */
        HPM_PIOC->PAD[IOC_PAD_PY07].FUNC_CTL = PIOC_PY07_FUNC_CTL_SOC_PY_07;
8000cef8:	f40d8737          	lui	a4,0xf40d8
8000cefc:	6785                	lui	a5,0x1
8000cefe:	97ba                	add	a5,a5,a4
8000cf00:	470d                	li	a4,3
8000cf02:	e2e7ac23          	sw	a4,-456(a5) # e38 <__NOR_CFG_OPTION_segment_size__+0x238>
        HPM_PIOC->PAD[IOC_PAD_PY06].FUNC_CTL = PIOC_PY06_FUNC_CTL_SOC_PY_06;
8000cf06:	f40d8737          	lui	a4,0xf40d8
8000cf0a:	6785                	lui	a5,0x1
8000cf0c:	97ba                	add	a5,a5,a4
8000cf0e:	470d                	li	a4,3
8000cf10:	e2e7a823          	sw	a4,-464(a5) # e30 <__NOR_CFG_OPTION_segment_size__+0x230>
        HPM_BIOC->PAD[IOC_PAD_PZ11].FUNC_CTL = BIOC_PZ11_FUNC_CTL_SOC_PZ_11;
    } else if (ptr == HPM_PUART) {
        HPM_PIOC->PAD[IOC_PAD_PY07].FUNC_CTL = PIOC_PY07_FUNC_CTL_PUART_RXD;
        HPM_PIOC->PAD[IOC_PAD_PY06].FUNC_CTL = PIOC_PY06_FUNC_CTL_PUART_TXD;
    }
}
8000cf14:	a8c5                	j	8000d004 <.L10>

8000cf16 <.L4>:
    } else if (ptr == HPM_UART6) {
8000cf16:	4732                	lw	a4,12(sp)
8000cf18:	f00587b7          	lui	a5,0xf0058
8000cf1c:	00f71d63          	bne	a4,a5,8000cf36 <.L6>
        HPM_IOC->PAD[IOC_PAD_PE27].FUNC_CTL = IOC_PE27_FUNC_CTL_UART6_RXD;
8000cf20:	f40407b7          	lui	a5,0xf4040
8000cf24:	4709                	li	a4,2
8000cf26:	4ce7ac23          	sw	a4,1240(a5) # f40404d8 <__AHB_SRAM_segment_end__+0x3d384d8>
        HPM_IOC->PAD[IOC_PAD_PE28].FUNC_CTL = IOC_PE28_FUNC_CTL_UART6_TXD;
8000cf2a:	f40407b7          	lui	a5,0xf4040
8000cf2e:	4709                	li	a4,2
8000cf30:	4ee7a023          	sw	a4,1248(a5) # f40404e0 <__AHB_SRAM_segment_end__+0x3d384e0>
}
8000cf34:	a8c1                	j	8000d004 <.L10>

8000cf36 <.L6>:
    } else if (ptr == HPM_UART7) {
8000cf36:	4732                	lw	a4,12(sp)
8000cf38:	f005c7b7          	lui	a5,0xf005c
8000cf3c:	00f71d63          	bne	a4,a5,8000cf56 <.L7>
        HPM_IOC->PAD[IOC_PAD_PC02].FUNC_CTL = IOC_PC02_FUNC_CTL_UART7_RXD;
8000cf40:	f40407b7          	lui	a5,0xf4040
8000cf44:	4709                	li	a4,2
8000cf46:	20e7a823          	sw	a4,528(a5) # f4040210 <__AHB_SRAM_segment_end__+0x3d38210>
        HPM_IOC->PAD[IOC_PAD_PC03].FUNC_CTL = IOC_PC03_FUNC_CTL_UART7_TXD;
8000cf4a:	f40407b7          	lui	a5,0xf4040
8000cf4e:	4709                	li	a4,2
8000cf50:	20e7ac23          	sw	a4,536(a5) # f4040218 <__AHB_SRAM_segment_end__+0x3d38218>
}
8000cf54:	a845                	j	8000d004 <.L10>

8000cf56 <.L7>:
    } else if (ptr == HPM_UART13) {
8000cf56:	4732                	lw	a4,12(sp)
8000cf58:	f00747b7          	lui	a5,0xf0074
8000cf5c:	02f71f63          	bne	a4,a5,8000cf9a <.L8>
        HPM_IOC->PAD[IOC_PAD_PZ08].FUNC_CTL = IOC_PZ08_FUNC_CTL_UART13_RXD;
8000cf60:	f4040737          	lui	a4,0xf4040
8000cf64:	6785                	lui	a5,0x1
8000cf66:	97ba                	add	a5,a5,a4
8000cf68:	4709                	li	a4,2
8000cf6a:	f4e7a023          	sw	a4,-192(a5) # f40 <__NOR_CFG_OPTION_segment_size__+0x340>
        HPM_IOC->PAD[IOC_PAD_PZ09].FUNC_CTL = IOC_PZ09_FUNC_CTL_UART13_TXD;
8000cf6e:	f4040737          	lui	a4,0xf4040
8000cf72:	6785                	lui	a5,0x1
8000cf74:	97ba                	add	a5,a5,a4
8000cf76:	4709                	li	a4,2
8000cf78:	f4e7a423          	sw	a4,-184(a5) # f48 <__NOR_CFG_OPTION_segment_size__+0x348>
        HPM_BIOC->PAD[IOC_PAD_PZ08].FUNC_CTL = BIOC_PZ08_FUNC_CTL_SOC_PZ_08;
8000cf7c:	f5010737          	lui	a4,0xf5010
8000cf80:	6785                	lui	a5,0x1
8000cf82:	97ba                	add	a5,a5,a4
8000cf84:	470d                	li	a4,3
8000cf86:	f4e7a023          	sw	a4,-192(a5) # f40 <__NOR_CFG_OPTION_segment_size__+0x340>
        HPM_BIOC->PAD[IOC_PAD_PZ09].FUNC_CTL = BIOC_PZ09_FUNC_CTL_SOC_PZ_09;
8000cf8a:	f5010737          	lui	a4,0xf5010
8000cf8e:	6785                	lui	a5,0x1
8000cf90:	97ba                	add	a5,a5,a4
8000cf92:	470d                	li	a4,3
8000cf94:	f4e7a423          	sw	a4,-184(a5) # f48 <__NOR_CFG_OPTION_segment_size__+0x348>
}
8000cf98:	a0b5                	j	8000d004 <.L10>

8000cf9a <.L8>:
    } else if (ptr == HPM_UART14) {
8000cf9a:	4732                	lw	a4,12(sp)
8000cf9c:	f00787b7          	lui	a5,0xf0078
8000cfa0:	02f71f63          	bne	a4,a5,8000cfde <.L9>
        HPM_IOC->PAD[IOC_PAD_PZ10].FUNC_CTL = IOC_PZ10_FUNC_CTL_UART14_RXD;
8000cfa4:	f4040737          	lui	a4,0xf4040
8000cfa8:	6785                	lui	a5,0x1
8000cfaa:	97ba                	add	a5,a5,a4
8000cfac:	4709                	li	a4,2
8000cfae:	f4e7a823          	sw	a4,-176(a5) # f50 <__NOR_CFG_OPTION_segment_size__+0x350>
        HPM_IOC->PAD[IOC_PAD_PZ11].FUNC_CTL = IOC_PZ11_FUNC_CTL_UART14_TXD;
8000cfb2:	f4040737          	lui	a4,0xf4040
8000cfb6:	6785                	lui	a5,0x1
8000cfb8:	97ba                	add	a5,a5,a4
8000cfba:	4709                	li	a4,2
8000cfbc:	f4e7ac23          	sw	a4,-168(a5) # f58 <__NOR_CFG_OPTION_segment_size__+0x358>
        HPM_BIOC->PAD[IOC_PAD_PZ10].FUNC_CTL = BIOC_PZ10_FUNC_CTL_SOC_PZ_10;
8000cfc0:	f5010737          	lui	a4,0xf5010
8000cfc4:	6785                	lui	a5,0x1
8000cfc6:	97ba                	add	a5,a5,a4
8000cfc8:	470d                	li	a4,3
8000cfca:	f4e7a823          	sw	a4,-176(a5) # f50 <__NOR_CFG_OPTION_segment_size__+0x350>
        HPM_BIOC->PAD[IOC_PAD_PZ11].FUNC_CTL = BIOC_PZ11_FUNC_CTL_SOC_PZ_11;
8000cfce:	f5010737          	lui	a4,0xf5010
8000cfd2:	6785                	lui	a5,0x1
8000cfd4:	97ba                	add	a5,a5,a4
8000cfd6:	470d                	li	a4,3
8000cfd8:	f4e7ac23          	sw	a4,-168(a5) # f58 <__NOR_CFG_OPTION_segment_size__+0x358>
}
8000cfdc:	a025                	j	8000d004 <.L10>

8000cfde <.L9>:
    } else if (ptr == HPM_PUART) {
8000cfde:	4732                	lw	a4,12(sp)
8000cfe0:	f40e47b7          	lui	a5,0xf40e4
8000cfe4:	02f71063          	bne	a4,a5,8000d004 <.L10>
        HPM_PIOC->PAD[IOC_PAD_PY07].FUNC_CTL = PIOC_PY07_FUNC_CTL_PUART_RXD;
8000cfe8:	f40d8737          	lui	a4,0xf40d8
8000cfec:	6785                	lui	a5,0x1
8000cfee:	97ba                	add	a5,a5,a4
8000cff0:	4705                	li	a4,1
8000cff2:	e2e7ac23          	sw	a4,-456(a5) # e38 <__NOR_CFG_OPTION_segment_size__+0x238>
        HPM_PIOC->PAD[IOC_PAD_PY06].FUNC_CTL = PIOC_PY06_FUNC_CTL_PUART_TXD;
8000cff6:	f40d8737          	lui	a4,0xf40d8
8000cffa:	6785                	lui	a5,0x1
8000cffc:	97ba                	add	a5,a5,a4
8000cffe:	4705                	li	a4,1
8000d000:	e2e7a823          	sw	a4,-464(a5) # e30 <__NOR_CFG_OPTION_segment_size__+0x230>

8000d004 <.L10>:
}
8000d004:	0001                	nop
8000d006:	0141                	add	sp,sp,16
8000d008:	8082                	ret

Disassembly of section .text.init_femc_pins:

8000d00a <init_femc_pins>:
        }
    }
}
void init_femc_pins(void)
{
    HPM_IOC->PAD[IOC_PAD_PC01].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d00a:	f40407b7          	lui	a5,0xf4040
8000d00e:	4731                	li	a4,12
8000d010:	20e7a423          	sw	a4,520(a5) # f4040208 <__AHB_SRAM_segment_end__+0x3d38208>
    HPM_IOC->PAD[IOC_PAD_PC00].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d014:	f40407b7          	lui	a5,0xf4040
8000d018:	4731                	li	a4,12
8000d01a:	20e7a023          	sw	a4,512(a5) # f4040200 <__AHB_SRAM_segment_end__+0x3d38200>
    HPM_IOC->PAD[IOC_PAD_PB31].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d01e:	f40407b7          	lui	a5,0xf4040
8000d022:	4731                	li	a4,12
8000d024:	1ee7ac23          	sw	a4,504(a5) # f40401f8 <__AHB_SRAM_segment_end__+0x3d381f8>
    HPM_IOC->PAD[IOC_PAD_PB30].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d028:	f40407b7          	lui	a5,0xf4040
8000d02c:	4731                	li	a4,12
8000d02e:	1ee7a823          	sw	a4,496(a5) # f40401f0 <__AHB_SRAM_segment_end__+0x3d381f0>
    HPM_IOC->PAD[IOC_PAD_PB29].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d032:	f40407b7          	lui	a5,0xf4040
8000d036:	4731                	li	a4,12
8000d038:	1ee7a423          	sw	a4,488(a5) # f40401e8 <__AHB_SRAM_segment_end__+0x3d381e8>
    HPM_IOC->PAD[IOC_PAD_PB28].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d03c:	f40407b7          	lui	a5,0xf4040
8000d040:	4731                	li	a4,12
8000d042:	1ee7a023          	sw	a4,480(a5) # f40401e0 <__AHB_SRAM_segment_end__+0x3d381e0>
    HPM_IOC->PAD[IOC_PAD_PB27].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d046:	f40407b7          	lui	a5,0xf4040
8000d04a:	4731                	li	a4,12
8000d04c:	1ce7ac23          	sw	a4,472(a5) # f40401d8 <__AHB_SRAM_segment_end__+0x3d381d8>
    HPM_IOC->PAD[IOC_PAD_PB26].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d050:	f40407b7          	lui	a5,0xf4040
8000d054:	4731                	li	a4,12
8000d056:	1ce7a823          	sw	a4,464(a5) # f40401d0 <__AHB_SRAM_segment_end__+0x3d381d0>
    HPM_IOC->PAD[IOC_PAD_PB25].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d05a:	f40407b7          	lui	a5,0xf4040
8000d05e:	4731                	li	a4,12
8000d060:	1ce7a423          	sw	a4,456(a5) # f40401c8 <__AHB_SRAM_segment_end__+0x3d381c8>
    HPM_IOC->PAD[IOC_PAD_PB24].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d064:	f40407b7          	lui	a5,0xf4040
8000d068:	4731                	li	a4,12
8000d06a:	1ce7a023          	sw	a4,448(a5) # f40401c0 <__AHB_SRAM_segment_end__+0x3d381c0>
    HPM_IOC->PAD[IOC_PAD_PB23].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d06e:	f40407b7          	lui	a5,0xf4040
8000d072:	4731                	li	a4,12
8000d074:	1ae7ac23          	sw	a4,440(a5) # f40401b8 <__AHB_SRAM_segment_end__+0x3d381b8>
    HPM_IOC->PAD[IOC_PAD_PB22].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d078:	f40407b7          	lui	a5,0xf4040
8000d07c:	4731                	li	a4,12
8000d07e:	1ae7a823          	sw	a4,432(a5) # f40401b0 <__AHB_SRAM_segment_end__+0x3d381b0>
    HPM_IOC->PAD[IOC_PAD_PB21].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d082:	f40407b7          	lui	a5,0xf4040
8000d086:	4731                	li	a4,12
8000d088:	1ae7a423          	sw	a4,424(a5) # f40401a8 <__AHB_SRAM_segment_end__+0x3d381a8>
    HPM_IOC->PAD[IOC_PAD_PB20].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d08c:	f40407b7          	lui	a5,0xf4040
8000d090:	4731                	li	a4,12
8000d092:	1ae7a023          	sw	a4,416(a5) # f40401a0 <__AHB_SRAM_segment_end__+0x3d381a0>
    HPM_IOC->PAD[IOC_PAD_PB19].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d096:	f40407b7          	lui	a5,0xf4040
8000d09a:	4731                	li	a4,12
8000d09c:	18e7ac23          	sw	a4,408(a5) # f4040198 <__AHB_SRAM_segment_end__+0x3d38198>
    HPM_IOC->PAD[IOC_PAD_PB18].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d0a0:	f40407b7          	lui	a5,0xf4040
8000d0a4:	4731                	li	a4,12
8000d0a6:	18e7a823          	sw	a4,400(a5) # f4040190 <__AHB_SRAM_segment_end__+0x3d38190>

    HPM_IOC->PAD[IOC_PAD_PD13].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d0aa:	f40407b7          	lui	a5,0xf4040
8000d0ae:	4731                	li	a4,12
8000d0b0:	36e7a423          	sw	a4,872(a5) # f4040368 <__AHB_SRAM_segment_end__+0x3d38368>
    HPM_IOC->PAD[IOC_PAD_PD12].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d0b4:	f40407b7          	lui	a5,0xf4040
8000d0b8:	4731                	li	a4,12
8000d0ba:	36e7a023          	sw	a4,864(a5) # f4040360 <__AHB_SRAM_segment_end__+0x3d38360>
    HPM_IOC->PAD[IOC_PAD_PD10].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d0be:	f40407b7          	lui	a5,0xf4040
8000d0c2:	4731                	li	a4,12
8000d0c4:	34e7a823          	sw	a4,848(a5) # f4040350 <__AHB_SRAM_segment_end__+0x3d38350>
    HPM_IOC->PAD[IOC_PAD_PD09].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d0c8:	f40407b7          	lui	a5,0xf4040
8000d0cc:	4731                	li	a4,12
8000d0ce:	34e7a423          	sw	a4,840(a5) # f4040348 <__AHB_SRAM_segment_end__+0x3d38348>
    HPM_IOC->PAD[IOC_PAD_PD08].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d0d2:	f40407b7          	lui	a5,0xf4040
8000d0d6:	4731                	li	a4,12
8000d0d8:	34e7a023          	sw	a4,832(a5) # f4040340 <__AHB_SRAM_segment_end__+0x3d38340>
    HPM_IOC->PAD[IOC_PAD_PD07].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d0dc:	f40407b7          	lui	a5,0xf4040
8000d0e0:	4731                	li	a4,12
8000d0e2:	32e7ac23          	sw	a4,824(a5) # f4040338 <__AHB_SRAM_segment_end__+0x3d38338>
    HPM_IOC->PAD[IOC_PAD_PD06].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d0e6:	f40407b7          	lui	a5,0xf4040
8000d0ea:	4731                	li	a4,12
8000d0ec:	32e7a823          	sw	a4,816(a5) # f4040330 <__AHB_SRAM_segment_end__+0x3d38330>
    HPM_IOC->PAD[IOC_PAD_PD05].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d0f0:	f40407b7          	lui	a5,0xf4040
8000d0f4:	4731                	li	a4,12
8000d0f6:	32e7a423          	sw	a4,808(a5) # f4040328 <__AHB_SRAM_segment_end__+0x3d38328>
    HPM_IOC->PAD[IOC_PAD_PD04].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d0fa:	f40407b7          	lui	a5,0xf4040
8000d0fe:	4731                	li	a4,12
8000d100:	32e7a023          	sw	a4,800(a5) # f4040320 <__AHB_SRAM_segment_end__+0x3d38320>
    HPM_IOC->PAD[IOC_PAD_PD03].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d104:	f40407b7          	lui	a5,0xf4040
8000d108:	4731                	li	a4,12
8000d10a:	30e7ac23          	sw	a4,792(a5) # f4040318 <__AHB_SRAM_segment_end__+0x3d38318>
    HPM_IOC->PAD[IOC_PAD_PD02].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d10e:	f40407b7          	lui	a5,0xf4040
8000d112:	4731                	li	a4,12
8000d114:	30e7a823          	sw	a4,784(a5) # f4040310 <__AHB_SRAM_segment_end__+0x3d38310>
    HPM_IOC->PAD[IOC_PAD_PD01].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d118:	f40407b7          	lui	a5,0xf4040
8000d11c:	4731                	li	a4,12
8000d11e:	30e7a423          	sw	a4,776(a5) # f4040308 <__AHB_SRAM_segment_end__+0x3d38308>
    HPM_IOC->PAD[IOC_PAD_PD00].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d122:	f40407b7          	lui	a5,0xf4040
8000d126:	4731                	li	a4,12
8000d128:	30e7a023          	sw	a4,768(a5) # f4040300 <__AHB_SRAM_segment_end__+0x3d38300>
    HPM_IOC->PAD[IOC_PAD_PC29].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d12c:	f40407b7          	lui	a5,0xf4040
8000d130:	4731                	li	a4,12
8000d132:	2ee7a423          	sw	a4,744(a5) # f40402e8 <__AHB_SRAM_segment_end__+0x3d382e8>
    HPM_IOC->PAD[IOC_PAD_PC28].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d136:	f40407b7          	lui	a5,0xf4040
8000d13a:	4731                	li	a4,12
8000d13c:	2ee7a023          	sw	a4,736(a5) # f40402e0 <__AHB_SRAM_segment_end__+0x3d382e0>
    HPM_IOC->PAD[IOC_PAD_PC27].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d140:	f40407b7          	lui	a5,0xf4040
8000d144:	4731                	li	a4,12
8000d146:	2ce7ac23          	sw	a4,728(a5) # f40402d8 <__AHB_SRAM_segment_end__+0x3d382d8>

    HPM_IOC->PAD[IOC_PAD_PC21].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);    /* SRAM #WE */
8000d14a:	f40407b7          	lui	a5,0xf4040
8000d14e:	4731                	li	a4,12
8000d150:	2ae7a423          	sw	a4,680(a5) # f40402a8 <__AHB_SRAM_segment_end__+0x3d382a8>
    HPM_IOC->PAD[IOC_PAD_PC17].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d154:	f40407b7          	lui	a5,0xf4040
8000d158:	4731                	li	a4,12
8000d15a:	28e7a423          	sw	a4,648(a5) # f4040288 <__AHB_SRAM_segment_end__+0x3d38288>
    HPM_IOC->PAD[IOC_PAD_PC15].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d15e:	f40407b7          	lui	a5,0xf4040
8000d162:	4731                	li	a4,12
8000d164:	26e7ac23          	sw	a4,632(a5) # f4040278 <__AHB_SRAM_segment_end__+0x3d38278>
    HPM_IOC->PAD[IOC_PAD_PC12].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d168:	f40407b7          	lui	a5,0xf4040
8000d16c:	4731                	li	a4,12
8000d16e:	26e7a023          	sw	a4,608(a5) # f4040260 <__AHB_SRAM_segment_end__+0x3d38260>
    HPM_IOC->PAD[IOC_PAD_PC11].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d172:	f40407b7          	lui	a5,0xf4040
8000d176:	4731                	li	a4,12
8000d178:	24e7ac23          	sw	a4,600(a5) # f4040258 <__AHB_SRAM_segment_end__+0x3d38258>
    HPM_IOC->PAD[IOC_PAD_PC10].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d17c:	f40407b7          	lui	a5,0xf4040
8000d180:	4731                	li	a4,12
8000d182:	24e7a823          	sw	a4,592(a5) # f4040250 <__AHB_SRAM_segment_end__+0x3d38250>
    HPM_IOC->PAD[IOC_PAD_PC09].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d186:	f40407b7          	lui	a5,0xf4040
8000d18a:	4731                	li	a4,12
8000d18c:	24e7a423          	sw	a4,584(a5) # f4040248 <__AHB_SRAM_segment_end__+0x3d38248>
    HPM_IOC->PAD[IOC_PAD_PC08].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d190:	f40407b7          	lui	a5,0xf4040
8000d194:	4731                	li	a4,12
8000d196:	24e7a023          	sw	a4,576(a5) # f4040240 <__AHB_SRAM_segment_end__+0x3d38240>
    HPM_IOC->PAD[IOC_PAD_PC07].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d19a:	f40407b7          	lui	a5,0xf4040
8000d19e:	4731                	li	a4,12
8000d1a0:	22e7ac23          	sw	a4,568(a5) # f4040238 <__AHB_SRAM_segment_end__+0x3d38238>
    HPM_IOC->PAD[IOC_PAD_PC06].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d1a4:	f40407b7          	lui	a5,0xf4040
8000d1a8:	4731                	li	a4,12
8000d1aa:	22e7a823          	sw	a4,560(a5) # f4040230 <__AHB_SRAM_segment_end__+0x3d38230>
    HPM_IOC->PAD[IOC_PAD_PC05].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d1ae:	f40407b7          	lui	a5,0xf4040
8000d1b2:	4731                	li	a4,12
8000d1b4:	22e7a423          	sw	a4,552(a5) # f4040228 <__AHB_SRAM_segment_end__+0x3d38228>
    HPM_IOC->PAD[IOC_PAD_PC04].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d1b8:	f40407b7          	lui	a5,0xf4040
8000d1bc:	4731                	li	a4,12
8000d1be:	22e7a023          	sw	a4,544(a5) # f4040220 <__AHB_SRAM_segment_end__+0x3d38220>

    HPM_IOC->PAD[IOC_PAD_PC14].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);    /* SRAM #ADV */
8000d1c2:	f40407b7          	lui	a5,0xf4040
8000d1c6:	4731                	li	a4,12
8000d1c8:	26e7a823          	sw	a4,624(a5) # f4040270 <__AHB_SRAM_segment_end__+0x3d38270>
    HPM_IOC->PAD[IOC_PAD_PC13].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d1cc:	f40407b7          	lui	a5,0xf4040
8000d1d0:	4731                	li	a4,12
8000d1d2:	26e7a423          	sw	a4,616(a5) # f4040268 <__AHB_SRAM_segment_end__+0x3d38268>
    HPM_IOC->PAD[IOC_PAD_PC16].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12) | IOC_PAD_FUNC_CTL_LOOP_BACK_MASK;
8000d1d6:	f40407b7          	lui	a5,0xf4040
8000d1da:	6741                	lui	a4,0x10
8000d1dc:	0731                	add	a4,a4,12 # 1000c <__FLASH_segment_used_size__+0x1b44>
8000d1de:	28e7a023          	sw	a4,640(a5) # f4040280 <__AHB_SRAM_segment_end__+0x3d38280>
    HPM_IOC->PAD[IOC_PAD_PC26].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d1e2:	f40407b7          	lui	a5,0xf4040
8000d1e6:	4731                	li	a4,12
8000d1e8:	2ce7a823          	sw	a4,720(a5) # f40402d0 <__AHB_SRAM_segment_end__+0x3d382d0>
    HPM_IOC->PAD[IOC_PAD_PC25].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d1ec:	f40407b7          	lui	a5,0xf4040
8000d1f0:	4731                	li	a4,12
8000d1f2:	2ce7a423          	sw	a4,712(a5) # f40402c8 <__AHB_SRAM_segment_end__+0x3d382c8>
    HPM_IOC->PAD[IOC_PAD_PC19].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d1f6:	f40407b7          	lui	a5,0xf4040
8000d1fa:	4731                	li	a4,12
8000d1fc:	28e7ac23          	sw	a4,664(a5) # f4040298 <__AHB_SRAM_segment_end__+0x3d38298>
    HPM_IOC->PAD[IOC_PAD_PC18].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d200:	f40407b7          	lui	a5,0xf4040
8000d204:	4731                	li	a4,12
8000d206:	28e7a823          	sw	a4,656(a5) # f4040290 <__AHB_SRAM_segment_end__+0x3d38290>
    HPM_IOC->PAD[IOC_PAD_PC23].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d20a:	f40407b7          	lui	a5,0xf4040
8000d20e:	4731                	li	a4,12
8000d210:	2ae7ac23          	sw	a4,696(a5) # f40402b8 <__AHB_SRAM_segment_end__+0x3d382b8>
    HPM_IOC->PAD[IOC_PAD_PC24].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d214:	f40407b7          	lui	a5,0xf4040
8000d218:	4731                	li	a4,12
8000d21a:	2ce7a023          	sw	a4,704(a5) # f40402c0 <__AHB_SRAM_segment_end__+0x3d382c0>
    HPM_IOC->PAD[IOC_PAD_PC30].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);    /* SRAM #LB */
8000d21e:	f40407b7          	lui	a5,0xf4040
8000d222:	4731                	li	a4,12
8000d224:	2ee7a823          	sw	a4,752(a5) # f40402f0 <__AHB_SRAM_segment_end__+0x3d382f0>
    HPM_IOC->PAD[IOC_PAD_PC31].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);    /* SRAM #UB */
8000d228:	f40407b7          	lui	a5,0xf4040
8000d22c:	4731                	li	a4,12
8000d22e:	2ee7ac23          	sw	a4,760(a5) # f40402f8 <__AHB_SRAM_segment_end__+0x3d382f8>
    HPM_IOC->PAD[IOC_PAD_PC02].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d232:	f40407b7          	lui	a5,0xf4040
8000d236:	4731                	li	a4,12
8000d238:	20e7a823          	sw	a4,528(a5) # f4040210 <__AHB_SRAM_segment_end__+0x3d38210>
    HPM_IOC->PAD[IOC_PAD_PC03].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);
8000d23c:	f40407b7          	lui	a5,0xf4040
8000d240:	4731                	li	a4,12
8000d242:	20e7ac23          	sw	a4,536(a5) # f4040218 <__AHB_SRAM_segment_end__+0x3d38218>

    HPM_IOC->PAD[IOC_PAD_PC20].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);    /* SRAM #CE */
8000d246:	f40407b7          	lui	a5,0xf4040
8000d24a:	4731                	li	a4,12
8000d24c:	2ae7a023          	sw	a4,672(a5) # f40402a0 <__AHB_SRAM_segment_end__+0x3d382a0>
    HPM_IOC->PAD[IOC_PAD_PC22].FUNC_CTL = IOC_PAD_FUNC_CTL_ALT_SELECT_SET(12);    /* SRAM #OE */
8000d250:	f40407b7          	lui	a5,0xf4040
8000d254:	4731                	li	a4,12
8000d256:	2ae7a823          	sw	a4,688(a5) # f40402b0 <__AHB_SRAM_segment_end__+0x3d382b0>
}
8000d25a:	0001                	nop
8000d25c:	8082                	ret

Disassembly of section .text.init_can_pins:

8000d25e <init_can_pins>:
        HPM_IOC->PAD[IOC_PAD_PF08].FUNC_CTL = IOC_PF08_FUNC_CTL_USB0_OC;
    }
}

void init_can_pins(CAN_Type *ptr)
{
8000d25e:	1141                	add	sp,sp,-16
8000d260:	c62a                	sw	a0,12(sp)
    if (ptr == HPM_CAN1) {
8000d262:	4732                	lw	a4,12(sp)
8000d264:	f00847b7          	lui	a5,0xf0084
8000d268:	00f71c63          	bne	a4,a5,8000d280 <.L71>
        HPM_IOC->PAD[IOC_PAD_PE31].FUNC_CTL = IOC_PE31_FUNC_CTL_CAN1_TXD;
8000d26c:	f40407b7          	lui	a5,0xf4040
8000d270:	471d                	li	a4,7
8000d272:	4ee7ac23          	sw	a4,1272(a5) # f40404f8 <__AHB_SRAM_segment_end__+0x3d384f8>
        HPM_IOC->PAD[IOC_PAD_PE30].FUNC_CTL = IOC_PE30_FUNC_CTL_CAN1_RXD;
8000d276:	f40407b7          	lui	a5,0xf4040
8000d27a:	471d                	li	a4,7
8000d27c:	4ee7a823          	sw	a4,1264(a5) # f40404f0 <__AHB_SRAM_segment_end__+0x3d384f0>

8000d280 <.L71>:
    }
}
8000d280:	0001                	nop
8000d282:	0141                	add	sp,sp,16
8000d284:	8082                	ret

Disassembly of section .text.console_init:

8000d286 <console_init>:
#include "hpm_uart_drv.h"

static UART_Type* g_console_uart = NULL;

hpm_stat_t console_init(console_config_t *cfg)
{
8000d286:	7139                	add	sp,sp,-64
8000d288:	de06                	sw	ra,60(sp)
8000d28a:	c62a                	sw	a0,12(sp)
    hpm_stat_t stat = status_fail;
8000d28c:	4785                	li	a5,1
8000d28e:	d63e                	sw	a5,44(sp)

    if (cfg->type == CONSOLE_TYPE_UART) {
8000d290:	47b2                	lw	a5,12(sp)
8000d292:	439c                	lw	a5,0(a5)
8000d294:	e7a1                	bnez	a5,8000d2dc <.L2>

8000d296 <.LBB2>:
        uart_config_t config = {0};
8000d296:	cc02                	sw	zero,24(sp)
8000d298:	ce02                	sw	zero,28(sp)
8000d29a:	d002                	sw	zero,32(sp)
8000d29c:	d202                	sw	zero,36(sp)
8000d29e:	d402                	sw	zero,40(sp)
        uart_default_config((UART_Type *)cfg->base, &config);
8000d2a0:	47b2                	lw	a5,12(sp)
8000d2a2:	43dc                	lw	a5,4(a5)
8000d2a4:	873e                	mv	a4,a5
8000d2a6:	083c                	add	a5,sp,24
8000d2a8:	85be                	mv	a1,a5
8000d2aa:	853a                	mv	a0,a4
8000d2ac:	f6dfd0ef          	jal	8000b218 <uart_default_config>
        config.src_freq_in_hz = cfg->src_freq_in_hz;
8000d2b0:	47b2                	lw	a5,12(sp)
8000d2b2:	479c                	lw	a5,8(a5)
8000d2b4:	cc3e                	sw	a5,24(sp)
        config.baudrate = cfg->baudrate;
8000d2b6:	47b2                	lw	a5,12(sp)
8000d2b8:	47dc                	lw	a5,12(a5)
8000d2ba:	ce3e                	sw	a5,28(sp)
        stat = uart_init((UART_Type *)cfg->base, &config);
8000d2bc:	47b2                	lw	a5,12(sp)
8000d2be:	43dc                	lw	a5,4(a5)
8000d2c0:	873e                	mv	a4,a5
8000d2c2:	083c                	add	a5,sp,24
8000d2c4:	85be                	mv	a1,a5
8000d2c6:	853a                	mv	a0,a4
8000d2c8:	4ba010ef          	jal	8000e782 <uart_init>
8000d2cc:	d62a                	sw	a0,44(sp)
        if (status_success == stat) {
8000d2ce:	57b2                	lw	a5,44(sp)
8000d2d0:	e791                	bnez	a5,8000d2dc <.L2>
            g_console_uart = (UART_Type *)cfg->base;
8000d2d2:	47b2                	lw	a5,12(sp)
8000d2d4:	43dc                	lw	a5,4(a5)
8000d2d6:	873e                	mv	a4,a5
8000d2d8:	82e22a23          	sw	a4,-1996(tp) # fffff834 <__APB_SRAM_segment_end__+0xbf0d834>

8000d2dc <.L2>:
        }
    }

    return stat;
8000d2dc:	57b2                	lw	a5,44(sp)
}
8000d2de:	853e                	mv	a0,a5
8000d2e0:	50f2                	lw	ra,60(sp)
8000d2e2:	6121                	add	sp,sp,64
8000d2e4:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_write:

8000d2e6 <__SEGGER_RTL_X_file_write>:
__attribute__((used)) FILE *stdin  = &__SEGGER_RTL_stdin_file;  /* NOTE: Provide implementation of stdin for RTL. */
__attribute__((used)) FILE *stdout = &__SEGGER_RTL_stdout_file; /* NOTE: Provide implementation of stdout for RTL. */
__attribute__((used)) FILE *stderr = &__SEGGER_RTL_stderr_file; /* NOTE: Provide implementation of stderr for RTL. */

__attribute__((used)) int __SEGGER_RTL_X_file_write(__SEGGER_RTL_FILE *file, const char *data, unsigned int size)
{
8000d2e6:	7179                	add	sp,sp,-48
8000d2e8:	d606                	sw	ra,44(sp)
8000d2ea:	c62a                	sw	a0,12(sp)
8000d2ec:	c42e                	sw	a1,8(sp)
8000d2ee:	c232                	sw	a2,4(sp)
    unsigned int count;
    (void)file;
    for (count = 0; count < size; count++) {
8000d2f0:	ce02                	sw	zero,28(sp)
8000d2f2:	a099                	j	8000d338 <.L13>

8000d2f4 <.L17>:
        if (data[count] == '\n') {
8000d2f4:	4722                	lw	a4,8(sp)
8000d2f6:	47f2                	lw	a5,28(sp)
8000d2f8:	97ba                	add	a5,a5,a4
8000d2fa:	0007c703          	lbu	a4,0(a5)
8000d2fe:	47a9                	li	a5,10
8000d300:	00f71b63          	bne	a4,a5,8000d316 <.L20>
            while (status_success != uart_send_byte(g_console_uart, '\r')) {
8000d304:	0001                	nop

8000d306 <.L15>:
8000d306:	83422783          	lw	a5,-1996(tp) # fffff834 <__APB_SRAM_segment_end__+0xbf0d834>
8000d30a:	45b5                	li	a1,13
8000d30c:	853e                	mv	a0,a5
8000d30e:	f61fd0ef          	jal	8000b26e <uart_send_byte>
8000d312:	87aa                	mv	a5,a0
8000d314:	fbed                	bnez	a5,8000d306 <.L15>

8000d316 <.L20>:
            }
        }
        while (status_success != uart_send_byte(g_console_uart, data[count])) {
8000d316:	0001                	nop

8000d318 <.L16>:
8000d318:	83422683          	lw	a3,-1996(tp) # fffff834 <__APB_SRAM_segment_end__+0xbf0d834>
8000d31c:	4722                	lw	a4,8(sp)
8000d31e:	47f2                	lw	a5,28(sp)
8000d320:	97ba                	add	a5,a5,a4
8000d322:	0007c783          	lbu	a5,0(a5)
8000d326:	85be                	mv	a1,a5
8000d328:	8536                	mv	a0,a3
8000d32a:	f45fd0ef          	jal	8000b26e <uart_send_byte>
8000d32e:	87aa                	mv	a5,a0
8000d330:	f7e5                	bnez	a5,8000d318 <.L16>
    for (count = 0; count < size; count++) {
8000d332:	47f2                	lw	a5,28(sp)
8000d334:	0785                	add	a5,a5,1
8000d336:	ce3e                	sw	a5,28(sp)

8000d338 <.L13>:
8000d338:	4772                	lw	a4,28(sp)
8000d33a:	4792                	lw	a5,4(sp)
8000d33c:	faf76ce3          	bltu	a4,a5,8000d2f4 <.L17>
        }
    }
    while (status_success != uart_flush(g_console_uart)) {
8000d340:	0001                	nop

8000d342 <.L18>:
8000d342:	83422783          	lw	a5,-1996(tp) # fffff834 <__APB_SRAM_segment_end__+0xbf0d834>
8000d346:	853e                	mv	a0,a5
8000d348:	5ba010ef          	jal	8000e902 <uart_flush>
8000d34c:	87aa                	mv	a5,a0
8000d34e:	fbf5                	bnez	a5,8000d342 <.L18>
    }
    return count;
8000d350:	47f2                	lw	a5,28(sp)

}
8000d352:	853e                	mv	a0,a5
8000d354:	50b2                	lw	ra,44(sp)
8000d356:	6145                	add	sp,sp,48
8000d358:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_stat:

8000d35a <__SEGGER_RTL_X_file_stat>:
    }
    return 1;
}

__attribute__((used)) int __SEGGER_RTL_X_file_stat(__SEGGER_RTL_FILE *stream)
{
8000d35a:	1141                	add	sp,sp,-16
8000d35c:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 0;
8000d35e:	4781                	li	a5,0
}
8000d360:	853e                	mv	a0,a5
8000d362:	0141                	add	sp,sp,16
8000d364:	8082                	ret

Disassembly of section .text.__SEGGER_RTL_X_file_bufsize:

8000d366 <__SEGGER_RTL_X_file_bufsize>:

__attribute__((used)) int __SEGGER_RTL_X_file_bufsize(__SEGGER_RTL_FILE *stream)
{
8000d366:	1141                	add	sp,sp,-16
8000d368:	c62a                	sw	a0,12(sp)
    (void) stream;
    return 1;
8000d36a:	4785                	li	a5,1
}
8000d36c:	853e                	mv	a0,a5
8000d36e:	0141                	add	sp,sp,16
8000d370:	8082                	ret

Disassembly of section .text.can_reset:

8000d372 <can_reset>:
{
8000d372:	1141                	add	sp,sp,-16
8000d374:	c62a                	sw	a0,12(sp)
8000d376:	87ae                	mv	a5,a1
8000d378:	00f105a3          	sb	a5,11(sp)
    if (enable) {
8000d37c:	00b14783          	lbu	a5,11(sp)
8000d380:	cb91                	beqz	a5,8000d394 <.L2>
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_RESET_MASK;
8000d382:	47b2                	lw	a5,12(sp)
8000d384:	0a07a783          	lw	a5,160(a5)
8000d388:	0807e713          	or	a4,a5,128
8000d38c:	47b2                	lw	a5,12(sp)
8000d38e:	0ae7a023          	sw	a4,160(a5)
}
8000d392:	a809                	j	8000d3a4 <.L4>

8000d394 <.L2>:
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_RESET_MASK;
8000d394:	47b2                	lw	a5,12(sp)
8000d396:	0a07a783          	lw	a5,160(a5)
8000d39a:	f7f7f713          	and	a4,a5,-129
8000d39e:	47b2                	lw	a5,12(sp)
8000d3a0:	0ae7a023          	sw	a4,160(a5)

8000d3a4 <.L4>:
}
8000d3a4:	0001                	nop
8000d3a6:	0141                	add	sp,sp,16
8000d3a8:	8082                	ret

Disassembly of section .text.can_disable_ptb_retransmission:

8000d3aa <can_disable_ptb_retransmission>:
{
8000d3aa:	1141                	add	sp,sp,-16
8000d3ac:	c62a                	sw	a0,12(sp)
8000d3ae:	87ae                	mv	a5,a1
8000d3b0:	00f105a3          	sb	a5,11(sp)
    if (enable) {
8000d3b4:	00b14783          	lbu	a5,11(sp)
8000d3b8:	cb91                	beqz	a5,8000d3cc <.L11>
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_TPSS_MASK;
8000d3ba:	47b2                	lw	a5,12(sp)
8000d3bc:	0a07a783          	lw	a5,160(a5)
8000d3c0:	0107e713          	or	a4,a5,16
8000d3c4:	47b2                	lw	a5,12(sp)
8000d3c6:	0ae7a023          	sw	a4,160(a5)
}
8000d3ca:	a809                	j	8000d3dc <.L13>

8000d3cc <.L11>:
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_TPSS_MASK;
8000d3cc:	47b2                	lw	a5,12(sp)
8000d3ce:	0a07a783          	lw	a5,160(a5)
8000d3d2:	fef7f713          	and	a4,a5,-17
8000d3d6:	47b2                	lw	a5,12(sp)
8000d3d8:	0ae7a023          	sw	a4,160(a5)

8000d3dc <.L13>:
}
8000d3dc:	0001                	nop
8000d3de:	0141                	add	sp,sp,16
8000d3e0:	8082                	ret

Disassembly of section .text.can_disable_stb_retransmission:

8000d3e2 <can_disable_stb_retransmission>:
{
8000d3e2:	1141                	add	sp,sp,-16
8000d3e4:	c62a                	sw	a0,12(sp)
8000d3e6:	87ae                	mv	a5,a1
8000d3e8:	00f105a3          	sb	a5,11(sp)
    if (enable) {
8000d3ec:	00b14783          	lbu	a5,11(sp)
8000d3f0:	cb91                	beqz	a5,8000d404 <.L15>
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_TSSS_MASK;
8000d3f2:	47b2                	lw	a5,12(sp)
8000d3f4:	0a07a783          	lw	a5,160(a5)
8000d3f8:	0087e713          	or	a4,a5,8
8000d3fc:	47b2                	lw	a5,12(sp)
8000d3fe:	0ae7a023          	sw	a4,160(a5)
}
8000d402:	a809                	j	8000d414 <.L17>

8000d404 <.L15>:
        base->CMD_STA_CMD_CTRL &= ~CAN_CMD_STA_CMD_CTRL_TSSS_MASK;
8000d404:	47b2                	lw	a5,12(sp)
8000d406:	0a07a783          	lw	a5,160(a5)
8000d40a:	ff77f713          	and	a4,a5,-9
8000d40e:	47b2                	lw	a5,12(sp)
8000d410:	0ae7a023          	sw	a4,160(a5)

8000d414 <.L17>:
}
8000d414:	0001                	nop
8000d416:	0141                	add	sp,sp,16
8000d418:	8082                	ret

Disassembly of section .text.can_disable_tx_rx_irq:

8000d41a <can_disable_tx_rx_irq>:
{
8000d41a:	1141                	add	sp,sp,-16
8000d41c:	c62a                	sw	a0,12(sp)
8000d41e:	87ae                	mv	a5,a1
8000d420:	00f105a3          	sb	a5,11(sp)
    base->RTIE &= ~mask;
8000d424:	47b2                	lw	a5,12(sp)
8000d426:	0a47c783          	lbu	a5,164(a5)
8000d42a:	0ff7f793          	zext.b	a5,a5
8000d42e:	01879713          	sll	a4,a5,0x18
8000d432:	8761                	sra	a4,a4,0x18
8000d434:	00b10783          	lb	a5,11(sp)
8000d438:	fff7c793          	not	a5,a5
8000d43c:	07e2                	sll	a5,a5,0x18
8000d43e:	87e1                	sra	a5,a5,0x18
8000d440:	8ff9                	and	a5,a5,a4
8000d442:	07e2                	sll	a5,a5,0x18
8000d444:	87e1                	sra	a5,a5,0x18
8000d446:	0ff7f713          	zext.b	a4,a5
8000d44a:	47b2                	lw	a5,12(sp)
8000d44c:	0ae78223          	sb	a4,164(a5)
}
8000d450:	0001                	nop
8000d452:	0141                	add	sp,sp,16
8000d454:	8082                	ret

Disassembly of section .text.can_disable_error_irq:

8000d456 <can_disable_error_irq>:
{
8000d456:	1141                	add	sp,sp,-16
8000d458:	c62a                	sw	a0,12(sp)
8000d45a:	87ae                	mv	a5,a1
8000d45c:	00f105a3          	sb	a5,11(sp)
    base->ERRINT &= ~mask;
8000d460:	47b2                	lw	a5,12(sp)
8000d462:	0a67c783          	lbu	a5,166(a5)
8000d466:	0ff7f793          	zext.b	a5,a5
8000d46a:	01879713          	sll	a4,a5,0x18
8000d46e:	8761                	sra	a4,a4,0x18
8000d470:	00b10783          	lb	a5,11(sp)
8000d474:	fff7c793          	not	a5,a5
8000d478:	07e2                	sll	a5,a5,0x18
8000d47a:	87e1                	sra	a5,a5,0x18
8000d47c:	8ff9                	and	a5,a5,a4
8000d47e:	07e2                	sll	a5,a5,0x18
8000d480:	87e1                	sra	a5,a5,0x18
8000d482:	0ff7f713          	zext.b	a4,a5
8000d486:	47b2                	lw	a5,12(sp)
8000d488:	0ae78323          	sb	a4,166(a5)
}
8000d48c:	0001                	nop
8000d48e:	0141                	add	sp,sp,16
8000d490:	8082                	ret

Disassembly of section .text.can_set_transmitter_delay_compensation:

8000d492 <can_set_transmitter_delay_compensation>:
{
8000d492:	1141                	add	sp,sp,-16
8000d494:	c62a                	sw	a0,12(sp)
8000d496:	87ae                	mv	a5,a1
8000d498:	8732                	mv	a4,a2
8000d49a:	00f105a3          	sb	a5,11(sp)
8000d49e:	87ba                	mv	a5,a4
8000d4a0:	00f10523          	sb	a5,10(sp)
    base->TDC = CAN_TDC_TDCEN_SET((uint8_t) enable);
8000d4a4:	00a14783          	lbu	a5,10(sp)
8000d4a8:	079e                	sll	a5,a5,0x7
8000d4aa:	0ff7f713          	zext.b	a4,a5
8000d4ae:	47b2                	lw	a5,12(sp)
8000d4b0:	0ae788a3          	sb	a4,177(a5)
}
8000d4b4:	0001                	nop
8000d4b6:	0141                	add	sp,sp,16
8000d4b8:	8082                	ret

Disassembly of section .text.can_set_fast_speed_timing:

8000d4ba <can_set_fast_speed_timing>:
 * @brief Configure the Fast Speed Bit timing using low-level interface
 * @param [in] base CAN base address
 * @param [in] param CAN bit timing parameter
 */
static inline void can_set_fast_speed_timing(CAN_Type *base, const can_bit_timing_param_t *param)
{
8000d4ba:	1141                	add	sp,sp,-16
8000d4bc:	c62a                	sw	a0,12(sp)
8000d4be:	c42e                	sw	a1,8(sp)
    base->F_PRESC = CAN_F_PRESC_F_PRESC_SET(param->prescaler - 1U) | CAN_F_PRESC_F_SEG_1_SET(param->num_seg1 - 2U) |
8000d4c0:	47a2                	lw	a5,8(sp)
8000d4c2:	0007d783          	lhu	a5,0(a5)
8000d4c6:	17fd                	add	a5,a5,-1
8000d4c8:	01879713          	sll	a4,a5,0x18
8000d4cc:	47a2                	lw	a5,8(sp)
8000d4ce:	0027d783          	lhu	a5,2(a5)
8000d4d2:	17f9                	add	a5,a5,-2
8000d4d4:	8bbd                	and	a5,a5,15
8000d4d6:	8f5d                	or	a4,a4,a5
                                CAN_F_PRESC_F_SEG_2_SET(param->num_seg2 - 1U) | CAN_F_PRESC_F_SJW_SET(param->num_sjw - 1U);
8000d4d8:	47a2                	lw	a5,8(sp)
8000d4da:	0047d783          	lhu	a5,4(a5)
8000d4de:	17fd                	add	a5,a5,-1
8000d4e0:	00879693          	sll	a3,a5,0x8
8000d4e4:	6785                	lui	a5,0x1
8000d4e6:	f0078793          	add	a5,a5,-256 # f00 <__NOR_CFG_OPTION_segment_size__+0x300>
8000d4ea:	8ff5                	and	a5,a5,a3
    base->F_PRESC = CAN_F_PRESC_F_PRESC_SET(param->prescaler - 1U) | CAN_F_PRESC_F_SEG_1_SET(param->num_seg1 - 2U) |
8000d4ec:	8f5d                	or	a4,a4,a5
                                CAN_F_PRESC_F_SEG_2_SET(param->num_seg2 - 1U) | CAN_F_PRESC_F_SJW_SET(param->num_sjw - 1U);
8000d4ee:	47a2                	lw	a5,8(sp)
8000d4f0:	0067d783          	lhu	a5,6(a5)
8000d4f4:	17fd                	add	a5,a5,-1
8000d4f6:	01079693          	sll	a3,a5,0x10
8000d4fa:	000f07b7          	lui	a5,0xf0
8000d4fe:	8ff5                	and	a5,a5,a3
8000d500:	8f5d                	or	a4,a4,a5
    base->F_PRESC = CAN_F_PRESC_F_PRESC_SET(param->prescaler - 1U) | CAN_F_PRESC_F_SEG_1_SET(param->num_seg1 - 2U) |
8000d502:	47b2                	lw	a5,12(sp)
8000d504:	0ae7a623          	sw	a4,172(a5) # f00ac <__AXI_SRAM_segment_size__+0x300ac>
}
8000d508:	0001                	nop
8000d50a:	0141                	add	sp,sp,16
8000d50c:	8082                	ret

Disassembly of section .text.find_optimal_prescaler:

8000d50e <find_optimal_prescaler>:
{
8000d50e:	1101                	add	sp,sp,-32
8000d510:	c62a                	sw	a0,12(sp)
8000d512:	c42e                	sw	a1,8(sp)
8000d514:	c232                	sw	a2,4(sp)
8000d516:	c036                	sw	a3,0(sp)
    bool has_found = false;
8000d518:	00010fa3          	sb	zero,31(sp)
    uint32_t prescaler = start_prescaler;
8000d51c:	47a2                	lw	a5,8(sp)
8000d51e:	cc3e                	sw	a5,24(sp)
    while (!has_found) {
8000d520:	a899                	j	8000d576 <.L39>

8000d522 <.L45>:
        if ((num_tq_mul_prescaler / prescaler > max_tq) || (num_tq_mul_prescaler % prescaler != 0)) {
8000d522:	4732                	lw	a4,12(sp)
8000d524:	47e2                	lw	a5,24(sp)
8000d526:	02f757b3          	divu	a5,a4,a5
8000d52a:	4712                	lw	a4,4(sp)
8000d52c:	00f76763          	bltu	a4,a5,8000d53a <.L40>
8000d530:	4732                	lw	a4,12(sp)
8000d532:	47e2                	lw	a5,24(sp)
8000d534:	02f777b3          	remu	a5,a4,a5
8000d538:	c789                	beqz	a5,8000d542 <.L41>

8000d53a <.L40>:
            ++prescaler;
8000d53a:	47e2                	lw	a5,24(sp)
8000d53c:	0785                	add	a5,a5,1
8000d53e:	cc3e                	sw	a5,24(sp)
            continue;
8000d540:	a81d                	j	8000d576 <.L39>

8000d542 <.L41>:
            uint32_t tq = num_tq_mul_prescaler / prescaler;
8000d542:	4732                	lw	a4,12(sp)
8000d544:	47e2                	lw	a5,24(sp)
8000d546:	02f757b3          	divu	a5,a4,a5
8000d54a:	ca3e                	sw	a5,20(sp)
            if (tq * prescaler == num_tq_mul_prescaler) {
8000d54c:	4752                	lw	a4,20(sp)
8000d54e:	47e2                	lw	a5,24(sp)
8000d550:	02f707b3          	mul	a5,a4,a5
8000d554:	4732                	lw	a4,12(sp)
8000d556:	00f71663          	bne	a4,a5,8000d562 <.L42>
                has_found = true;
8000d55a:	4785                	li	a5,1
8000d55c:	00f10fa3          	sb	a5,31(sp)
                break;
8000d560:	a015                	j	8000d584 <.L43>

8000d562 <.L42>:
            } else if (tq < min_tq) {
8000d562:	4752                	lw	a4,20(sp)
8000d564:	4782                	lw	a5,0(sp)
8000d566:	00f77563          	bgeu	a4,a5,8000d570 <.L44>
                has_found = false;
8000d56a:	00010fa3          	sb	zero,31(sp)
                break;
8000d56e:	a819                	j	8000d584 <.L43>

8000d570 <.L44>:
                ++prescaler;
8000d570:	47e2                	lw	a5,24(sp)
8000d572:	0785                	add	a5,a5,1
8000d574:	cc3e                	sw	a5,24(sp)

8000d576 <.L39>:
    while (!has_found) {
8000d576:	01f14783          	lbu	a5,31(sp)
8000d57a:	0017c793          	xor	a5,a5,1
8000d57e:	0ff7f793          	zext.b	a5,a5
8000d582:	f3c5                	bnez	a5,8000d522 <.L45>

8000d584 <.L43>:
    return has_found ? prescaler : 0U;
8000d584:	01f14783          	lbu	a5,31(sp)
8000d588:	c399                	beqz	a5,8000d58e <.L46>
8000d58a:	47e2                	lw	a5,24(sp)
8000d58c:	a011                	j	8000d590 <.L48>

8000d58e <.L46>:
8000d58e:	4781                	li	a5,0

8000d590 <.L48>:
}
8000d590:	853e                	mv	a0,a5
8000d592:	6105                	add	sp,sp,32
8000d594:	8082                	ret

Disassembly of section .text.can_calculate_bit_timing:

8000d596 <can_calculate_bit_timing>:
{
8000d596:	711d                	add	sp,sp,-96
8000d598:	ce86                	sw	ra,92(sp)
8000d59a:	ce2a                	sw	a0,28(sp)
8000d59c:	ca32                	sw	a2,20(sp)
8000d59e:	c63e                	sw	a5,12(sp)
8000d5a0:	87ae                	mv	a5,a1
8000d5a2:	00f10da3          	sb	a5,27(sp)
8000d5a6:	87b6                	mv	a5,a3
8000d5a8:	00f11c23          	sh	a5,24(sp)
8000d5ac:	87ba                	mv	a5,a4
8000d5ae:	00f11923          	sh	a5,18(sp)
    hpm_stat_t status = status_invalid_argument;
8000d5b2:	4789                	li	a5,2
8000d5b4:	c6be                	sw	a5,76(sp)

8000d5b6 <.LBB3>:
        if ((option > can_bit_timing_canfd_data) || (baudrate == 0U) ||
8000d5b6:	01b14703          	lbu	a4,27(sp)
8000d5ba:	4789                	li	a5,2
8000d5bc:	18e7eb63          	bltu	a5,a4,8000d752 <.L50>
8000d5c0:	47d2                	lw	a5,20(sp)
8000d5c2:	18078863          	beqz	a5,8000d752 <.L50>
            (src_clk_freq / baudrate < MIN_TQ_MUL_PRESCALE) || (timing_param == NULL)) {
8000d5c6:	4772                	lw	a4,28(sp)
8000d5c8:	47d2                	lw	a5,20(sp)
8000d5ca:	02f75733          	divu	a4,a4,a5
        if ((option > can_bit_timing_canfd_data) || (baudrate == 0U) ||
8000d5ce:	47a5                	li	a5,9
8000d5d0:	18e7f163          	bgeu	a5,a4,8000d752 <.L50>
            (src_clk_freq / baudrate < MIN_TQ_MUL_PRESCALE) || (timing_param == NULL)) {
8000d5d4:	47b2                	lw	a5,12(sp)
8000d5d6:	16078e63          	beqz	a5,8000d752 <.L50>
        const can_bit_timing_table_t *tbl = &s_can_bit_timing_tbl[(uint8_t) option];
8000d5da:	01b14703          	lbu	a4,27(sp)
8000d5de:	87ba                	mv	a5,a4
8000d5e0:	078e                	sll	a5,a5,0x3
8000d5e2:	97ba                	add	a5,a5,a4
8000d5e4:	8000a737          	lui	a4,0x8000a
8000d5e8:	37870713          	add	a4,a4,888 # 8000a378 <s_can_bit_timing_tbl>
8000d5ec:	97ba                	add	a5,a5,a4
8000d5ee:	da3e                	sw	a5,52(sp)
        if (src_clk_freq / baudrate < tbl->tq_min) {
8000d5f0:	4772                	lw	a4,28(sp)
8000d5f2:	47d2                	lw	a5,20(sp)
8000d5f4:	02f757b3          	divu	a5,a4,a5
8000d5f8:	5752                	lw	a4,52(sp)
8000d5fa:	00074703          	lbu	a4,0(a4)
8000d5fe:	14e7e963          	bltu	a5,a4,8000d750 <.L63>
        uint32_t num_tq_mul_prescaler = src_clk_freq / baudrate;
8000d602:	4772                	lw	a4,28(sp)
8000d604:	47d2                	lw	a5,20(sp)
8000d606:	02f757b3          	divu	a5,a4,a5
8000d60a:	d83e                	sw	a5,48(sp)
        uint32_t start_prescaler = 1U;
8000d60c:	4785                	li	a5,1
8000d60e:	c4be                	sw	a5,72(sp)
        bool has_found = false;
8000d610:	02010fa3          	sb	zero,63(sp)
        while (!has_found) {
8000d614:	a8d9                	j	8000d6ea <.L52>

8000d616 <.L60>:
                                                       tbl->tq_max,
8000d616:	57d2                	lw	a5,52(sp)
8000d618:	0017c783          	lbu	a5,1(a5)
            current_prescaler = find_optimal_prescaler(num_tq_mul_prescaler, start_prescaler,
8000d61c:	873e                	mv	a4,a5
                                                       tbl->tq_min);
8000d61e:	57d2                	lw	a5,52(sp)
8000d620:	0007c783          	lbu	a5,0(a5)
            current_prescaler = find_optimal_prescaler(num_tq_mul_prescaler, start_prescaler,
8000d624:	86be                	mv	a3,a5
8000d626:	863a                	mv	a2,a4
8000d628:	45a6                	lw	a1,72(sp)
8000d62a:	5542                	lw	a0,48(sp)
8000d62c:	35cd                	jal	8000d50e <find_optimal_prescaler>
8000d62e:	dc2a                	sw	a0,56(sp)
            if ((current_prescaler < start_prescaler) || (current_prescaler > NUM_PRESCALE_MAX)) {
8000d630:	5762                	lw	a4,56(sp)
8000d632:	47a6                	lw	a5,72(sp)
8000d634:	0cf76463          	bltu	a4,a5,8000d6fc <.L53>
8000d638:	5762                	lw	a4,56(sp)
8000d63a:	10000793          	li	a5,256
8000d63e:	0ae7ef63          	bltu	a5,a4,8000d6fc <.L53>
            uint32_t num_tq = num_tq_mul_prescaler / current_prescaler;
8000d642:	5742                	lw	a4,48(sp)
8000d644:	57e2                	lw	a5,56(sp)
8000d646:	02f757b3          	divu	a5,a4,a5
8000d64a:	d63e                	sw	a5,44(sp)
            num_seg2 = (num_tq - tbl->min_diff_seg1_minus_seg2) / 2U;
8000d64c:	57d2                	lw	a5,52(sp)
8000d64e:	0087c783          	lbu	a5,8(a5)
8000d652:	873e                	mv	a4,a5
8000d654:	57b2                	lw	a5,44(sp)
8000d656:	8f99                	sub	a5,a5,a4
8000d658:	8385                	srl	a5,a5,0x1
8000d65a:	c0be                	sw	a5,64(sp)
            num_seg1 = num_tq - num_seg2;
8000d65c:	5732                	lw	a4,44(sp)
8000d65e:	4786                	lw	a5,64(sp)
8000d660:	40f707b3          	sub	a5,a4,a5
8000d664:	c2be                	sw	a5,68(sp)
            while (num_seg2 > tbl->seg2_max) {
8000d666:	a039                	j	8000d674 <.L54>

8000d668 <.L55>:
                num_seg2--;
8000d668:	4786                	lw	a5,64(sp)
8000d66a:	17fd                	add	a5,a5,-1
8000d66c:	c0be                	sw	a5,64(sp)
                num_seg1++;
8000d66e:	4796                	lw	a5,68(sp)
8000d670:	0785                	add	a5,a5,1
8000d672:	c2be                	sw	a5,68(sp)

8000d674 <.L54>:
            while (num_seg2 > tbl->seg2_max) {
8000d674:	57d2                	lw	a5,52(sp)
8000d676:	0057c783          	lbu	a5,5(a5)
8000d67a:	873e                	mv	a4,a5
8000d67c:	4786                	lw	a5,64(sp)
8000d67e:	fef765e3          	bltu	a4,a5,8000d668 <.L55>
            while ((num_seg1 * 1000U) / num_tq < samplepoint_min) {
8000d682:	a039                	j	8000d690 <.L56>

8000d684 <.L57>:
                ++num_seg1;
8000d684:	4796                	lw	a5,68(sp)
8000d686:	0785                	add	a5,a5,1
8000d688:	c2be                	sw	a5,68(sp)
                --num_seg2;
8000d68a:	4786                	lw	a5,64(sp)
8000d68c:	17fd                	add	a5,a5,-1
8000d68e:	c0be                	sw	a5,64(sp)

8000d690 <.L56>:
            while ((num_seg1 * 1000U) / num_tq < samplepoint_min) {
8000d690:	4716                	lw	a4,68(sp)
8000d692:	3e800793          	li	a5,1000
8000d696:	02f70733          	mul	a4,a4,a5
8000d69a:	57b2                	lw	a5,44(sp)
8000d69c:	02f75733          	divu	a4,a4,a5
8000d6a0:	01815783          	lhu	a5,24(sp)
8000d6a4:	fef760e3          	bltu	a4,a5,8000d684 <.L57>
            if ((num_seg1 * 1000U) / num_tq > samplepoint_max) {
8000d6a8:	4716                	lw	a4,68(sp)
8000d6aa:	3e800793          	li	a5,1000
8000d6ae:	02f70733          	mul	a4,a4,a5
8000d6b2:	57b2                	lw	a5,44(sp)
8000d6b4:	02f75733          	divu	a4,a4,a5
8000d6b8:	01215783          	lhu	a5,18(sp)
8000d6bc:	02e7ef63          	bltu	a5,a4,8000d6fa <.L64>
            if ((num_seg2 >= tbl->seg2_min) && (num_seg1 <= tbl->seg1_max)) {
8000d6c0:	57d2                	lw	a5,52(sp)
8000d6c2:	0047c783          	lbu	a5,4(a5)
8000d6c6:	873e                	mv	a4,a5
8000d6c8:	4786                	lw	a5,64(sp)
8000d6ca:	00e7ed63          	bltu	a5,a4,8000d6e4 <.L59>
8000d6ce:	57d2                	lw	a5,52(sp)
8000d6d0:	0037c783          	lbu	a5,3(a5)
8000d6d4:	873e                	mv	a4,a5
8000d6d6:	4796                	lw	a5,68(sp)
8000d6d8:	00f76663          	bltu	a4,a5,8000d6e4 <.L59>
                has_found = true;
8000d6dc:	4785                	li	a5,1
8000d6de:	02f10fa3          	sb	a5,63(sp)
8000d6e2:	a021                	j	8000d6ea <.L52>

8000d6e4 <.L59>:
                start_prescaler = current_prescaler + 1U;
8000d6e4:	57e2                	lw	a5,56(sp)
8000d6e6:	0785                	add	a5,a5,1
8000d6e8:	c4be                	sw	a5,72(sp)

8000d6ea <.L52>:
        while (!has_found) {
8000d6ea:	03f14783          	lbu	a5,63(sp)
8000d6ee:	0017c793          	xor	a5,a5,1
8000d6f2:	0ff7f793          	zext.b	a5,a5
8000d6f6:	f385                	bnez	a5,8000d616 <.L60>
8000d6f8:	a011                	j	8000d6fc <.L53>

8000d6fa <.L64>:
                break;
8000d6fa:	0001                	nop

8000d6fc <.L53>:
        if (has_found) {
8000d6fc:	03f14783          	lbu	a5,63(sp)
8000d700:	cba9                	beqz	a5,8000d752 <.L50>

8000d702 <.LBB6>:
            uint32_t num_sjw = MIN(tbl->sjw_max, num_seg2);
8000d702:	57d2                	lw	a5,52(sp)
8000d704:	0077c783          	lbu	a5,7(a5)
8000d708:	873e                	mv	a4,a5
8000d70a:	4786                	lw	a5,64(sp)
8000d70c:	00f77363          	bgeu	a4,a5,8000d712 <.L61>
8000d710:	87ba                	mv	a5,a4

8000d712 <.L61>:
8000d712:	d43e                	sw	a5,40(sp)
            timing_param->num_seg1 = num_seg1;
8000d714:	4796                	lw	a5,68(sp)
8000d716:	01079713          	sll	a4,a5,0x10
8000d71a:	8341                	srl	a4,a4,0x10
8000d71c:	47b2                	lw	a5,12(sp)
8000d71e:	00e79123          	sh	a4,2(a5)
            timing_param->num_seg2 = num_seg2;
8000d722:	4786                	lw	a5,64(sp)
8000d724:	01079713          	sll	a4,a5,0x10
8000d728:	8341                	srl	a4,a4,0x10
8000d72a:	47b2                	lw	a5,12(sp)
8000d72c:	00e79223          	sh	a4,4(a5)
            timing_param->num_sjw = num_sjw;
8000d730:	57a2                	lw	a5,40(sp)
8000d732:	01079713          	sll	a4,a5,0x10
8000d736:	8341                	srl	a4,a4,0x10
8000d738:	47b2                	lw	a5,12(sp)
8000d73a:	00e79323          	sh	a4,6(a5)
            timing_param->prescaler = current_prescaler;
8000d73e:	57e2                	lw	a5,56(sp)
8000d740:	01079713          	sll	a4,a5,0x10
8000d744:	8341                	srl	a4,a4,0x10
8000d746:	47b2                	lw	a5,12(sp)
8000d748:	00e79023          	sh	a4,0(a5)
            status = status_success;
8000d74c:	c682                	sw	zero,76(sp)
8000d74e:	a011                	j	8000d752 <.L50>

8000d750 <.L63>:
            break;
8000d750:	0001                	nop

8000d752 <.L50>:
    return status;
8000d752:	47b6                	lw	a5,76(sp)
}
8000d754:	853e                	mv	a0,a5
8000d756:	40f6                	lw	ra,92(sp)
8000d758:	6125                	add	sp,sp,96
8000d75a:	8082                	ret

Disassembly of section .text.can_fill_tx_buffer:

8000d75c <can_fill_tx_buffer>:
{
8000d75c:	7179                	add	sp,sp,-48
8000d75e:	d606                	sw	ra,44(sp)
8000d760:	c62a                	sw	a0,12(sp)
8000d762:	c42e                	sw	a1,8(sp)
    base->TBUF[0] = message->buffer[0];
8000d764:	47a2                	lw	a5,8(sp)
8000d766:	4398                	lw	a4,0(a5)
8000d768:	47b2                	lw	a5,12(sp)
8000d76a:	cbb8                	sw	a4,80(a5)
    base->TBUF[1] = message->buffer[1];
8000d76c:	47a2                	lw	a5,8(sp)
8000d76e:	43d8                	lw	a4,4(a5)
8000d770:	47b2                	lw	a5,12(sp)
8000d772:	cbf8                	sw	a4,84(a5)
    uint32_t copy_words = can_get_data_words_from_dlc(message->dlc);
8000d774:	47a2                	lw	a5,8(sp)
8000d776:	43dc                	lw	a5,4(a5)
8000d778:	8bbd                	and	a5,a5,15
8000d77a:	0ff7f793          	zext.b	a5,a5
8000d77e:	853e                	mv	a0,a5
8000d780:	896fd0ef          	jal	8000a816 <can_get_data_words_from_dlc>
8000d784:	87aa                	mv	a5,a0
8000d786:	cc3e                	sw	a5,24(sp)

8000d788 <.LBB9>:
    for (uint32_t i = 0U; i < copy_words; i++) {
8000d788:	ce02                	sw	zero,28(sp)
8000d78a:	a015                	j	8000d7ae <.L102>

8000d78c <.L103>:
        base->TBUF[2U + i] = message->buffer[2U + i];
8000d78c:	47f2                	lw	a5,28(sp)
8000d78e:	00278713          	add	a4,a5,2
8000d792:	47f2                	lw	a5,28(sp)
8000d794:	0789                	add	a5,a5,2
8000d796:	46a2                	lw	a3,8(sp)
8000d798:	070a                	sll	a4,a4,0x2
8000d79a:	9736                	add	a4,a4,a3
8000d79c:	4318                	lw	a4,0(a4)
8000d79e:	46b2                	lw	a3,12(sp)
8000d7a0:	07d1                	add	a5,a5,20
8000d7a2:	078a                	sll	a5,a5,0x2
8000d7a4:	97b6                	add	a5,a5,a3
8000d7a6:	c398                	sw	a4,0(a5)
    for (uint32_t i = 0U; i < copy_words; i++) {
8000d7a8:	47f2                	lw	a5,28(sp)
8000d7aa:	0785                	add	a5,a5,1
8000d7ac:	ce3e                	sw	a5,28(sp)

8000d7ae <.L102>:
8000d7ae:	4772                	lw	a4,28(sp)
8000d7b0:	47e2                	lw	a5,24(sp)
8000d7b2:	fcf76de3          	bltu	a4,a5,8000d78c <.L103>

8000d7b6 <.LBE9>:
}
8000d7b6:	0001                	nop
8000d7b8:	0001                	nop
8000d7ba:	50b2                	lw	ra,44(sp)
8000d7bc:	6145                	add	sp,sp,48
8000d7be:	8082                	ret

Disassembly of section .text.can_send_message_nonblocking:

8000d7c0 <can_send_message_nonblocking>:
{
8000d7c0:	7179                	add	sp,sp,-48
8000d7c2:	d606                	sw	ra,44(sp)
8000d7c4:	c62a                	sw	a0,12(sp)
8000d7c6:	c42e                	sw	a1,8(sp)
    hpm_stat_t status = status_invalid_argument;
8000d7c8:	4789                	li	a5,2
8000d7ca:	ce3e                	sw	a5,28(sp)
        if ((base == NULL) || (message == NULL)) {
8000d7cc:	47b2                	lw	a5,12(sp)
8000d7ce:	cba9                	beqz	a5,8000d820 <.L120>
8000d7d0:	47a2                	lw	a5,8(sp)
8000d7d2:	c7b9                	beqz	a5,8000d820 <.L120>
        if (CAN_CMD_STA_CMD_CTRL_TSSTAT_GET(base->CMD_STA_CMD_CTRL) == CAN_STB_IS_FULL) {
8000d7d4:	47b2                	lw	a5,12(sp)
8000d7d6:	0a07a703          	lw	a4,160(a5)
8000d7da:	000307b7          	lui	a5,0x30
8000d7de:	8f7d                	and	a4,a4,a5
8000d7e0:	000307b7          	lui	a5,0x30
8000d7e4:	00f71763          	bne	a4,a5,8000d7f2 <.L121>
            status = status_can_tx_fifo_full;
8000d7e8:	6795                	lui	a5,0x5
8000d7ea:	a3e78793          	add	a5,a5,-1474 # 4a3e <__DLM_segment_used_size__+0xa3e>
8000d7ee:	ce3e                	sw	a5,28(sp)
            break;
8000d7f0:	a805                	j	8000d820 <.L120>

8000d7f2 <.L121>:
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_TBSEL_MASK;
8000d7f2:	47b2                	lw	a5,12(sp)
8000d7f4:	0a07a703          	lw	a4,160(a5)
8000d7f8:	67a1                	lui	a5,0x8
8000d7fa:	8f5d                	or	a4,a4,a5
8000d7fc:	47b2                	lw	a5,12(sp)
8000d7fe:	0ae7a023          	sw	a4,160(a5) # 80a0 <__AHB_SRAM_segment_size__+0xa0>
        can_fill_tx_buffer(base, message);
8000d802:	45a2                	lw	a1,8(sp)
8000d804:	4532                	lw	a0,12(sp)
8000d806:	3f99                	jal	8000d75c <can_fill_tx_buffer>
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_TSNEXT_MASK | CAN_CMD_STA_CMD_CTRL_TSONE_MASK;
8000d808:	47b2                	lw	a5,12(sp)
8000d80a:	0a07a703          	lw	a4,160(a5)
8000d80e:	004007b7          	lui	a5,0x400
8000d812:	40078793          	add	a5,a5,1024 # 400400 <__NONCACHEABLE_RAM_segment_size__+0x400>
8000d816:	8f5d                	or	a4,a4,a5
8000d818:	47b2                	lw	a5,12(sp)
8000d81a:	0ae7a023          	sw	a4,160(a5)
        status = status_success;
8000d81e:	ce02                	sw	zero,28(sp)

8000d820 <.L120>:
    return status;
8000d820:	47f2                	lw	a5,28(sp)
}
8000d822:	853e                	mv	a0,a5
8000d824:	50b2                	lw	ra,44(sp)
8000d826:	6145                	add	sp,sp,48
8000d828:	8082                	ret

Disassembly of section .text.can_read_received_message:

8000d82a <can_read_received_message>:
{
8000d82a:	7179                	add	sp,sp,-48
8000d82c:	d606                	sw	ra,44(sp)
8000d82e:	c62a                	sw	a0,12(sp)
8000d830:	c42e                	sw	a1,8(sp)
    assert((base != NULL) && (message != NULL));
8000d832:	47b2                	lw	a5,12(sp)
8000d834:	c399                	beqz	a5,8000d83a <.L144>
8000d836:	47a2                	lw	a5,8(sp)
8000d838:	ef89                	bnez	a5,8000d852 <.L145>

8000d83a <.L144>:
8000d83a:	23a00613          	li	a2,570
8000d83e:	800037b7          	lui	a5,0x80003
8000d842:	15c78593          	add	a1,a5,348 # 8000315c <.LC0>
8000d846:	800037b7          	lui	a5,0x80003
8000d84a:	19878513          	add	a0,a5,408 # 80003198 <.LC1>
8000d84e:	36d010ef          	jal	8000f3ba <__SEGGER_RTL_X_assert>

8000d852 <.L145>:
        message->buffer[0] = base->RBUF[0];
8000d852:	47b2                	lw	a5,12(sp)
8000d854:	4398                	lw	a4,0(a5)
8000d856:	47a2                	lw	a5,8(sp)
8000d858:	c398                	sw	a4,0(a5)
        message->buffer[1] = base->RBUF[1];
8000d85a:	47b2                	lw	a5,12(sp)
8000d85c:	43d8                	lw	a4,4(a5)
8000d85e:	47a2                	lw	a5,8(sp)
8000d860:	c3d8                	sw	a4,4(a5)
        if (message->error_type != 0U) {
8000d862:	47a2                	lw	a5,8(sp)
8000d864:	43d8                	lw	a4,4(a5)
8000d866:	67b9                	lui	a5,0xe
8000d868:	8ff9                	and	a5,a5,a4
8000d86a:	c3b5                	beqz	a5,8000d8ce <.L146>
            switch (message->error_type) {
8000d86c:	47a2                	lw	a5,8(sp)
8000d86e:	43dc                	lw	a5,4(a5)
8000d870:	83b5                	srl	a5,a5,0xd
8000d872:	8b9d                	and	a5,a5,7
8000d874:	0ff7f793          	zext.b	a5,a5
8000d878:	4715                	li	a4,5
8000d87a:	04f76463          	bltu	a4,a5,8000d8c2 <.L147>
8000d87e:	00279713          	sll	a4,a5,0x2
8000d882:	800037b7          	lui	a5,0x80003
8000d886:	1bc78793          	add	a5,a5,444 # 800031bc <.L149>
8000d88a:	97ba                	add	a5,a5,a4
8000d88c:	439c                	lw	a5,0(a5)
8000d88e:	8782                	jr	a5

8000d890 <.L153>:
                status = status_can_bit_error;
8000d890:	6795                	lui	a5,0x5
8000d892:	a3878793          	add	a5,a5,-1480 # 4a38 <__DLM_segment_used_size__+0xa38>
8000d896:	ce3e                	sw	a5,28(sp)
                break;
8000d898:	a815                	j	8000d8cc <.L154>

8000d89a <.L152>:
                status = status_can_form_error;
8000d89a:	6795                	lui	a5,0x5
8000d89c:	a3978793          	add	a5,a5,-1479 # 4a39 <__DLM_segment_used_size__+0xa39>
8000d8a0:	ce3e                	sw	a5,28(sp)
                break;
8000d8a2:	a02d                	j	8000d8cc <.L154>

8000d8a4 <.L151>:
                status = status_can_stuff_error;
8000d8a4:	6795                	lui	a5,0x5
8000d8a6:	a3a78793          	add	a5,a5,-1478 # 4a3a <__DLM_segment_used_size__+0xa3a>
8000d8aa:	ce3e                	sw	a5,28(sp)
                break;
8000d8ac:	a005                	j	8000d8cc <.L154>

8000d8ae <.L150>:
                status = status_can_ack_error;
8000d8ae:	6795                	lui	a5,0x5
8000d8b0:	a3b78793          	add	a5,a5,-1477 # 4a3b <__DLM_segment_used_size__+0xa3b>
8000d8b4:	ce3e                	sw	a5,28(sp)
                break;
8000d8b6:	a819                	j	8000d8cc <.L154>

8000d8b8 <.L148>:
                status = status_can_crc_error;
8000d8b8:	6795                	lui	a5,0x5
8000d8ba:	a3c78793          	add	a5,a5,-1476 # 4a3c <__DLM_segment_used_size__+0xa3c>
8000d8be:	ce3e                	sw	a5,28(sp)
                break;
8000d8c0:	a031                	j	8000d8cc <.L154>

8000d8c2 <.L147>:
                status = status_can_other_error;
8000d8c2:	6795                	lui	a5,0x5
8000d8c4:	a3d78793          	add	a5,a5,-1475 # 4a3d <__DLM_segment_used_size__+0xa3d>
8000d8c8:	ce3e                	sw	a5,28(sp)
                break;
8000d8ca:	0001                	nop

8000d8cc <.L154>:
            break;
8000d8cc:	a085                	j	8000d92c <.L155>

8000d8ce <.L146>:
        if (message->remote_frame == 0U) {
8000d8ce:	47a2                	lw	a5,8(sp)
8000d8d0:	43dc                	lw	a5,4(a5)
8000d8d2:	0407f793          	and	a5,a5,64
8000d8d6:	e3a9                	bnez	a5,8000d918 <.L156>

8000d8d8 <.LBB14>:
            uint32_t copy_words = can_get_data_words_from_dlc(message->dlc);
8000d8d8:	47a2                	lw	a5,8(sp)
8000d8da:	43dc                	lw	a5,4(a5)
8000d8dc:	8bbd                	and	a5,a5,15
8000d8de:	0ff7f793          	zext.b	a5,a5
8000d8e2:	853e                	mv	a0,a5
8000d8e4:	f33fc0ef          	jal	8000a816 <can_get_data_words_from_dlc>
8000d8e8:	87aa                	mv	a5,a0
8000d8ea:	ca3e                	sw	a5,20(sp)

8000d8ec <.LBB15>:
            for (uint32_t i = 0; i < copy_words; i++) {
8000d8ec:	cc02                	sw	zero,24(sp)
8000d8ee:	a00d                	j	8000d910 <.L157>

8000d8f0 <.L158>:
                message->buffer[2U + i] = base->RBUF[2U + i];
8000d8f0:	47e2                	lw	a5,24(sp)
8000d8f2:	00278713          	add	a4,a5,2
8000d8f6:	47e2                	lw	a5,24(sp)
8000d8f8:	0789                	add	a5,a5,2
8000d8fa:	46b2                	lw	a3,12(sp)
8000d8fc:	070a                	sll	a4,a4,0x2
8000d8fe:	9736                	add	a4,a4,a3
8000d900:	4318                	lw	a4,0(a4)
8000d902:	46a2                	lw	a3,8(sp)
8000d904:	078a                	sll	a5,a5,0x2
8000d906:	97b6                	add	a5,a5,a3
8000d908:	c398                	sw	a4,0(a5)
            for (uint32_t i = 0; i < copy_words; i++) {
8000d90a:	47e2                	lw	a5,24(sp)
8000d90c:	0785                	add	a5,a5,1
8000d90e:	cc3e                	sw	a5,24(sp)

8000d910 <.L157>:
8000d910:	4762                	lw	a4,24(sp)
8000d912:	47d2                	lw	a5,20(sp)
8000d914:	fcf76ee3          	bltu	a4,a5,8000d8f0 <.L158>

8000d918 <.L156>:
        base->CMD_STA_CMD_CTRL |= CAN_CMD_STA_CMD_CTRL_RREL_MASK;
8000d918:	47b2                	lw	a5,12(sp)
8000d91a:	0a07a703          	lw	a4,160(a5)
8000d91e:	100007b7          	lui	a5,0x10000
8000d922:	8f5d                	or	a4,a4,a5
8000d924:	47b2                	lw	a5,12(sp)
8000d926:	0ae7a023          	sw	a4,160(a5) # 100000a0 <__SHARE_RAM_segment_end__+0xee800a0>
        status = status_success;
8000d92a:	ce02                	sw	zero,28(sp)

8000d92c <.L155>:
    return status;
8000d92c:	47f2                	lw	a5,28(sp)
}
8000d92e:	853e                	mv	a0,a5
8000d930:	50b2                	lw	ra,44(sp)
8000d932:	6145                	add	sp,sp,48
8000d934:	8082                	ret

Disassembly of section .text.can_get_default_config:

8000d936 <can_get_default_config>:
{
8000d936:	1101                	add	sp,sp,-32
8000d938:	c62a                	sw	a0,12(sp)
    hpm_stat_t status = status_invalid_argument;
8000d93a:	4789                	li	a5,2
8000d93c:	ce3e                	sw	a5,28(sp)
    if (config != NULL) {
8000d93e:	47b2                	lw	a5,12(sp)
8000d940:	c7d9                	beqz	a5,8000d9ce <.L161>
        config->baudrate = 1000000UL; /* 1Mbit/s */
8000d942:	47b2                	lw	a5,12(sp)
8000d944:	000f4737          	lui	a4,0xf4
8000d948:	24070713          	add	a4,a4,576 # f4240 <__AXI_SRAM_segment_size__+0x34240>
8000d94c:	c398                	sw	a4,0(a5)
        config->baudrate_fd = 0U;
8000d94e:	47b2                	lw	a5,12(sp)
8000d950:	0007a223          	sw	zero,4(a5)
        config->use_lowlevel_timing_setting = false;
8000d954:	47b2                	lw	a5,12(sp)
8000d956:	000788a3          	sb	zero,17(a5)
        config->can20_samplepoint_min = CAN_SAMPLEPOINT_MIN;
8000d95a:	47b2                	lw	a5,12(sp)
8000d95c:	2ee00713          	li	a4,750
8000d960:	00e79423          	sh	a4,8(a5)
        config->can20_samplepoint_max = CAN_SAMPLEPOINT_MAX;
8000d964:	47b2                	lw	a5,12(sp)
8000d966:	36b00713          	li	a4,875
8000d96a:	00e79523          	sh	a4,10(a5)
        config->canfd_samplepoint_min = CAN_SAMPLEPOINT_MIN;
8000d96e:	47b2                	lw	a5,12(sp)
8000d970:	2ee00713          	li	a4,750
8000d974:	00e79623          	sh	a4,12(a5)
        config->canfd_samplepoint_max = CAN_SAMPLEPOINT_MAX;
8000d978:	47b2                	lw	a5,12(sp)
8000d97a:	36b00713          	li	a4,875
8000d97e:	00e79723          	sh	a4,14(a5)
        config->enable_canfd = false;
8000d982:	47b2                	lw	a5,12(sp)
8000d984:	00078923          	sb	zero,18(a5)
        config->enable_can_fd_iso_mode = true;
8000d988:	47b2                	lw	a5,12(sp)
8000d98a:	4705                	li	a4,1
8000d98c:	00e78fa3          	sb	a4,31(a5)
        config->mode = can_mode_normal;
8000d990:	47b2                	lw	a5,12(sp)
8000d992:	00078823          	sb	zero,16(a5)
        config->enable_self_ack = false;
8000d996:	47b2                	lw	a5,12(sp)
8000d998:	000789a3          	sb	zero,19(a5)
        config->disable_stb_retransmission = false;
8000d99c:	47b2                	lw	a5,12(sp)
8000d99e:	00078aa3          	sb	zero,21(a5)
        config->disable_ptb_retransmission = false;
8000d9a2:	47b2                	lw	a5,12(sp)
8000d9a4:	00078a23          	sb	zero,20(a5)
        config->enable_tx_buffer_priority_mode = false;
8000d9a8:	47b2                	lw	a5,12(sp)
8000d9aa:	00078f23          	sb	zero,30(a5)
        config->enable_tdc = false;
8000d9ae:	47b2                	lw	a5,12(sp)
8000d9b0:	00078b23          	sb	zero,22(a5)
        config->filter_list_num = 0;
8000d9b4:	47b2                	lw	a5,12(sp)
8000d9b6:	00078ba3          	sb	zero,23(a5)
        config->filter_list = NULL;
8000d9ba:	47b2                	lw	a5,12(sp)
8000d9bc:	0007ac23          	sw	zero,24(a5)
        config->irq_txrx_enable_mask = 0;
8000d9c0:	47b2                	lw	a5,12(sp)
8000d9c2:	00078e23          	sb	zero,28(a5)
        config->irq_error_enable_mask = 0;
8000d9c6:	47b2                	lw	a5,12(sp)
8000d9c8:	00078ea3          	sb	zero,29(a5)
        status = status_success;
8000d9cc:	ce02                	sw	zero,28(sp)

8000d9ce <.L161>:
    return status;
8000d9ce:	47f2                	lw	a5,28(sp)
}
8000d9d0:	853e                	mv	a0,a5
8000d9d2:	6105                	add	sp,sp,32
8000d9d4:	8082                	ret

Disassembly of section .text.femc_sw_reset:

8000d9d6 <femc_sw_reset>:
 * Perform software reset
 *
 * @param[in] ptr FEMC base address
 */
static inline void femc_sw_reset(FEMC_Type *ptr)
{
8000d9d6:	1141                	add	sp,sp,-16
8000d9d8:	c62a                	sw	a0,12(sp)
    ptr->CTRL = FEMC_CTRL_RST_MASK;
8000d9da:	47b2                	lw	a5,12(sp)
8000d9dc:	4705                	li	a4,1
8000d9de:	c398                	sw	a4,0(a5)
    while ((ptr->CTRL & (uint32_t) FEMC_CTRL_RST_MASK) != 0) {
8000d9e0:	0001                	nop

8000d9e2 <.L5>:
8000d9e2:	47b2                	lw	a5,12(sp)
8000d9e4:	439c                	lw	a5,0(a5)
8000d9e6:	8b85                	and	a5,a5,1
8000d9e8:	ffed                	bnez	a5,8000d9e2 <.L5>
    }
}
8000d9ea:	0001                	nop
8000d9ec:	0001                	nop
8000d9ee:	0141                	add	sp,sp,16
8000d9f0:	8082                	ret

Disassembly of section .text.femc_config_delay_cell:

8000d9f2 <femc_config_delay_cell>:
{
8000d9f2:	1101                	add	sp,sp,-32
8000d9f4:	c62a                	sw	a0,12(sp)
8000d9f6:	87ae                	mv	a5,a1
8000d9f8:	c232                	sw	a2,4(sp)
8000d9fa:	00f105a3          	sb	a5,11(sp)
    delay_config = (FEMC_DLYCFG_DLYSEL_SET(delay_cell_value) | FEMC_DLYCFG_DLYEN_SET(delay_cell_en));
8000d9fe:	4792                	lw	a5,4(sp)
8000da00:	0786                	sll	a5,a5,0x1
8000da02:	03e7f713          	and	a4,a5,62
8000da06:	00b14783          	lbu	a5,11(sp)
8000da0a:	8fd9                	or	a5,a5,a4
8000da0c:	ce3e                	sw	a5,28(sp)
    ptr->DLYCFG &= ~FEMC_DLYCFG_OE_MASK;
8000da0e:	47b2                	lw	a5,12(sp)
8000da10:	1507a703          	lw	a4,336(a5)
8000da14:	77f9                	lui	a5,0xffffe
8000da16:	17fd                	add	a5,a5,-1 # ffffdfff <__APB_SRAM_segment_end__+0xbf0bfff>
8000da18:	8f7d                	and	a4,a4,a5
8000da1a:	47b2                	lw	a5,12(sp)
8000da1c:	14e7a823          	sw	a4,336(a5)
    ptr->DLYCFG = delay_config | (delay_config << 8u) | (delay_config << 16u) | (delay_config << 24u);
8000da20:	47f2                	lw	a5,28(sp)
8000da22:	00879713          	sll	a4,a5,0x8
8000da26:	47f2                	lw	a5,28(sp)
8000da28:	8f5d                	or	a4,a4,a5
8000da2a:	47f2                	lw	a5,28(sp)
8000da2c:	07c2                	sll	a5,a5,0x10
8000da2e:	8f5d                	or	a4,a4,a5
8000da30:	47f2                	lw	a5,28(sp)
8000da32:	07e2                	sll	a5,a5,0x18
8000da34:	8f5d                	or	a4,a4,a5
8000da36:	47b2                	lw	a5,12(sp)
8000da38:	14e7a823          	sw	a4,336(a5)
    ptr->DLYCFG |= FEMC_DLYCFG_OE_MASK;
8000da3c:	47b2                	lw	a5,12(sp)
8000da3e:	1507a703          	lw	a4,336(a5)
8000da42:	6789                	lui	a5,0x2
8000da44:	8f5d                	or	a4,a4,a5
8000da46:	47b2                	lw	a5,12(sp)
8000da48:	14e7a823          	sw	a4,336(a5) # 2150 <__APB_SRAM_segment_size__+0x150>
}
8000da4c:	0001                	nop
8000da4e:	6105                	add	sp,sp,32
8000da50:	8082                	ret

Disassembly of section .text.femc_ip_cmd_done:

8000da52 <femc_ip_cmd_done>:
{
8000da52:	1101                	add	sp,sp,-32
8000da54:	c62a                	sw	a0,12(sp)
    uint32_t intr_status = 0;
8000da56:	ce02                	sw	zero,28(sp)
    uint32_t retry = 0;
8000da58:	cc02                	sw	zero,24(sp)

8000da5a <.L10>:
        if (retry > HPM_FEMC_DRV_RETRY_COUNT) {
8000da5a:	4762                	lw	a4,24(sp)
8000da5c:	6785                	lui	a5,0x1
8000da5e:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
8000da62:	00e7ec63          	bltu	a5,a4,8000da7a <.L14>
        retry++;
8000da66:	47e2                	lw	a5,24(sp)
8000da68:	0785                	add	a5,a5,1
8000da6a:	cc3e                	sw	a5,24(sp)
        intr_status = ptr->INTR
8000da6c:	47b2                	lw	a5,12(sp)
8000da6e:	5fdc                	lw	a5,60(a5)
8000da70:	8b8d                	and	a5,a5,3
8000da72:	ce3e                	sw	a5,28(sp)
    } while (intr_status == 0);
8000da74:	47f2                	lw	a5,28(sp)
8000da76:	d3f5                	beqz	a5,8000da5a <.L10>
8000da78:	a011                	j	8000da7c <.L9>

8000da7a <.L14>:
            break;
8000da7a:	0001                	nop

8000da7c <.L9>:
    if (retry > HPM_FEMC_DRV_RETRY_COUNT) {
8000da7c:	4762                	lw	a4,24(sp)
8000da7e:	6785                	lui	a5,0x1
8000da80:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
8000da84:	00e7f463          	bgeu	a5,a4,8000da8c <.L11>
        return status_timeout;
8000da88:	478d                	li	a5,3
8000da8a:	a839                	j	8000daa8 <.L12>

8000da8c <.L11>:
    ptr->INTR |= FEMC_INTR_IPCMDDONE_MASK | FEMC_INTR_IPCMDERR_MASK;
8000da8c:	47b2                	lw	a5,12(sp)
8000da8e:	5fdc                	lw	a5,60(a5)
8000da90:	0037e713          	or	a4,a5,3
8000da94:	47b2                	lw	a5,12(sp)
8000da96:	dfd8                	sw	a4,60(a5)
    if (intr_status & FEMC_INTR_IPCMDERR_MASK) {
8000da98:	47f2                	lw	a5,28(sp)
8000da9a:	8b89                	and	a5,a5,2
8000da9c:	c789                	beqz	a5,8000daa6 <.L13>
        return status_femc_cmd_err;
8000da9e:	6789                	lui	a5,0x2
8000daa0:	32978793          	add	a5,a5,809 # 2329 <__APB_SRAM_segment_size__+0x329>
8000daa4:	a011                	j	8000daa8 <.L12>

8000daa6 <.L13>:
    return status_success;
8000daa6:	4781                	li	a5,0

8000daa8 <.L12>:
}
8000daa8:	853e                	mv	a0,a5
8000daaa:	6105                	add	sp,sp,32
8000daac:	8082                	ret

Disassembly of section .text.femc_get_typical_sdram_config:

8000daae <femc_get_typical_sdram_config>:
{
8000daae:	1141                	add	sp,sp,-16
8000dab0:	c62a                	sw	a0,12(sp)
8000dab2:	c42e                	sw	a1,8(sp)
    config->col_addr_bits = FEMC_SDRAM_COLUMN_ADDR_9_BITS;
8000dab4:	47a2                	lw	a5,8(sp)
8000dab6:	470d                	li	a4,3
8000dab8:	00e78623          	sb	a4,12(a5)
    config->cas_latency = FEMC_SDRAM_CAS_LATENCY_3;
8000dabc:	47a2                	lw	a5,8(sp)
8000dabe:	470d                	li	a4,3
8000dac0:	00e786a3          	sb	a4,13(a5)
    config->bank_num = FEMC_SDRAM_BANK_NUM_4;
8000dac4:	47a2                	lw	a5,8(sp)
8000dac6:	000787a3          	sb	zero,15(a5)
    config->prescaler = HPM_FEMC_DRV_DEFAULT_PRESCALER;
8000daca:	47a2                	lw	a5,8(sp)
8000dacc:	470d                	li	a4,3
8000dace:	00e78823          	sb	a4,16(a5)
    config->burst_len_in_byte = 8;
8000dad2:	47a2                	lw	a5,8(sp)
8000dad4:	4721                	li	a4,8
8000dad6:	00e78923          	sb	a4,18(a5)
    config->auto_refresh_count_in_one_burst = 1;
8000dada:	47a2                	lw	a5,8(sp)
8000dadc:	4705                	li	a4,1
8000dade:	00e78fa3          	sb	a4,31(a5)
    config->precharge_to_act_in_ns = 18;
8000dae2:	47a2                	lw	a5,8(sp)
8000dae4:	4749                	li	a4,18
8000dae6:	00e78aa3          	sb	a4,21(a5)
    config->act_to_rw_in_ns = 18;
8000daea:	47a2                	lw	a5,8(sp)
8000daec:	4749                	li	a4,18
8000daee:	00e78b23          	sb	a4,22(a5)
    config->refresh_recover_in_ns = 60;
8000daf2:	47a2                	lw	a5,8(sp)
8000daf4:	03c00713          	li	a4,60
8000daf8:	00e78da3          	sb	a4,27(a5)
    config->write_recover_in_ns = 12;
8000dafc:	47a2                	lw	a5,8(sp)
8000dafe:	4731                	li	a4,12
8000db00:	00e78ca3          	sb	a4,25(a5)
    config->cke_off_in_ns = 42;
8000db04:	47a2                	lw	a5,8(sp)
8000db06:	02a00713          	li	a4,42
8000db0a:	00e789a3          	sb	a4,19(a5)
    config->act_to_precharge_in_ns = 42;
8000db0e:	47a2                	lw	a5,8(sp)
8000db10:	02a00713          	li	a4,42
8000db14:	00e78a23          	sb	a4,20(a5)
    config->self_refresh_recover_in_ns = 72;
8000db18:	47a2                	lw	a5,8(sp)
8000db1a:	04800713          	li	a4,72
8000db1e:	00e78d23          	sb	a4,26(a5)
    config->refresh_to_refresh_in_ns = 60;
8000db22:	47a2                	lw	a5,8(sp)
8000db24:	03c00713          	li	a4,60
8000db28:	00e78c23          	sb	a4,24(a5)
    config->act_to_act_in_ns = 12;
8000db2c:	47a2                	lw	a5,8(sp)
8000db2e:	4731                	li	a4,12
8000db30:	00e78ba3          	sb	a4,23(a5)
    config->idle_timeout_in_ns = 6;
8000db34:	47a2                	lw	a5,8(sp)
8000db36:	4719                	li	a4,6
8000db38:	00e78ea3          	sb	a4,29(a5)
    config->cmd_data_width = 4;
8000db3c:	47a2                	lw	a5,8(sp)
8000db3e:	4711                	li	a4,4
8000db40:	00e78f23          	sb	a4,30(a5)
    config->auto_refresh_cmd_count = 8;
8000db44:	47a2                	lw	a5,8(sp)
8000db46:	4721                	li	a4,8
8000db48:	02e78123          	sb	a4,34(a5)
}
8000db4c:	0001                	nop
8000db4e:	0141                	add	sp,sp,16
8000db50:	8082                	ret

Disassembly of section .text.femc_convert_burst_len:

8000db52 <femc_convert_burst_len>:
{
8000db52:	1141                	add	sp,sp,-16
8000db54:	87aa                	mv	a5,a0
8000db56:	00f107a3          	sb	a5,15(sp)
    if ((burst_len_in_byte == 0)
8000db5a:	00f14783          	lbu	a5,15(sp)
8000db5e:	c791                	beqz	a5,8000db6a <.L38>
            || (burst_len_in_byte > FEMC_SDRAM_MAX_BURST_LENGTH_IN_BYTE)) {
8000db60:	00f14703          	lbu	a4,15(sp)
8000db64:	47a1                	li	a5,8
8000db66:	00e7f463          	bgeu	a5,a4,8000db6e <.L39>

8000db6a <.L38>:
        return FEMC_SDRAM_MAX_BURST_LENGTH_IN_BYTE + 1;
8000db6a:	47a5                	li	a5,9
8000db6c:	a081                	j	8000dbac <.L40>

8000db6e <.L39>:
    switch (burst_len_in_byte) {
8000db6e:	00f14783          	lbu	a5,15(sp)
8000db72:	4721                	li	a4,8
8000db74:	02e78463          	beq	a5,a4,8000db9c <.L41>
8000db78:	4721                	li	a4,8
8000db7a:	02f74863          	blt	a4,a5,8000dbaa <.L42>
8000db7e:	4709                	li	a4,2
8000db80:	00f74563          	blt	a4,a5,8000db8a <.L43>
8000db84:	00f04663          	bgtz	a5,8000db90 <.L44>
8000db88:	a00d                	j	8000dbaa <.L42>

8000db8a <.L43>:
8000db8a:	4711                	li	a4,4
8000db8c:	00e79f63          	bne	a5,a4,8000dbaa <.L42>

8000db90 <.L44>:
        return burst_len_in_byte >> 1;
8000db90:	00f14783          	lbu	a5,15(sp)
8000db94:	8385                	srl	a5,a5,0x1
8000db96:	0ff7f793          	zext.b	a5,a5
8000db9a:	a809                	j	8000dbac <.L40>

8000db9c <.L41>:
        return (burst_len_in_byte - 1) >> 1;
8000db9c:	00f14783          	lbu	a5,15(sp)
8000dba0:	17fd                	add	a5,a5,-1
8000dba2:	8785                	sra	a5,a5,0x1
8000dba4:	0ff7f793          	zext.b	a5,a5
8000dba8:	a011                	j	8000dbac <.L40>

8000dbaa <.L42>:
        return FEMC_SDRAM_MAX_BURST_LENGTH_IN_BYTE + 1;
8000dbaa:	47a5                	li	a5,9

8000dbac <.L40>:
}
8000dbac:	853e                	mv	a0,a5
8000dbae:	0141                	add	sp,sp,16
8000dbb0:	8082                	ret

Disassembly of section .text.femc_config_sdram:

8000dbb2 <femc_config_sdram>:

hpm_stat_t femc_config_sdram(FEMC_Type *ptr, uint32_t clk_in_hz, femc_sdram_config_t *config)
{
8000dbb2:	7139                	add	sp,sp,-64
8000dbb4:	de06                	sw	ra,60(sp)
8000dbb6:	dc22                	sw	s0,56(sp)
8000dbb8:	c62a                	sw	a0,12(sp)
8000dbba:	c42e                	sw	a1,8(sp)
8000dbbc:	c232                	sw	a2,4(sp)
    hpm_stat_t err;
    uint32_t prescaler;
    uint32_t refresh_cycle;
    uint32_t clk_in_khz = clk_in_hz / 1000;
8000dbbe:	4722                	lw	a4,8(sp)
8000dbc0:	3e800793          	li	a5,1000
8000dbc4:	02f757b3          	divu	a5,a4,a5
8000dbc8:	d03e                	sw	a5,32(sp)
    femc_cmd_t cmd = {0};
8000dbca:	c802                	sw	zero,16(sp)
8000dbcc:	ca02                	sw	zero,20(sp)
    uint8_t size = femc_convert_actual_size_to_memory_size(config->size_in_byte >> 10);
8000dbce:	4792                	lw	a5,4(sp)
8000dbd0:	43dc                	lw	a5,4(a5)
8000dbd2:	83a9                	srl	a5,a5,0xa
8000dbd4:	853e                	mv	a0,a5
8000dbd6:	a0afd0ef          	jal	8000ade0 <femc_convert_actual_size_to_memory_size>
8000dbda:	87aa                	mv	a5,a0
8000dbdc:	00f10fa3          	sb	a5,31(sp)
    uint8_t burst_len = femc_convert_burst_len(config->burst_len_in_byte);
8000dbe0:	4792                	lw	a5,4(sp)
8000dbe2:	0127c783          	lbu	a5,18(a5)
8000dbe6:	853e                	mv	a0,a5
8000dbe8:	37ad                	jal	8000db52 <femc_convert_burst_len>
8000dbea:	87aa                	mv	a5,a0
8000dbec:	00f10f23          	sb	a5,30(sp)

    prescaler = ((config->prescaler == 0) ? FEMC_PRESCALER_MAX : config->prescaler);
8000dbf0:	4792                	lw	a5,4(sp)
8000dbf2:	0107c783          	lbu	a5,16(a5)
8000dbf6:	c789                	beqz	a5,8000dc00 <.L49>
8000dbf8:	4792                	lw	a5,4(sp)
8000dbfa:	0107c783          	lbu	a5,16(a5)
8000dbfe:	a019                	j	8000dc04 <.L50>

8000dc00 <.L49>:
8000dc00:	10000793          	li	a5,256

8000dc04 <.L50>:
8000dc04:	d63e                	sw	a5,44(sp)
    refresh_cycle = clk_in_khz * config->refresh_in_ms / config->refresh_count / (prescaler << 4);
8000dc06:	4792                	lw	a5,4(sp)
8000dc08:	01c7c783          	lbu	a5,28(a5)
8000dc0c:	873e                	mv	a4,a5
8000dc0e:	5782                	lw	a5,32(sp)
8000dc10:	02f70733          	mul	a4,a4,a5
8000dc14:	4792                	lw	a5,4(sp)
8000dc16:	479c                	lw	a5,8(a5)
8000dc18:	02f75733          	divu	a4,a4,a5
8000dc1c:	57b2                	lw	a5,44(sp)
8000dc1e:	0792                	sll	a5,a5,0x4
8000dc20:	02f757b3          	divu	a5,a4,a5
8000dc24:	d43e                	sw	a5,40(sp)

    if ((prescaler == 0) || (prescaler > FEMC_PRESCALER_MAX)
8000dc26:	57b2                	lw	a5,44(sp)
8000dc28:	cf89                	beqz	a5,8000dc42 <.L51>
8000dc2a:	5732                	lw	a4,44(sp)
8000dc2c:	10000793          	li	a5,256
8000dc30:	00e7e963          	bltu	a5,a4,8000dc42 <.L51>
            || (refresh_cycle == 0) || (refresh_cycle > FEMC_PRESCALER_MAX)) {
8000dc34:	57a2                	lw	a5,40(sp)
8000dc36:	c791                	beqz	a5,8000dc42 <.L51>
8000dc38:	5722                	lw	a4,40(sp)
8000dc3a:	10000793          	li	a5,256
8000dc3e:	00e7f463          	bgeu	a5,a4,8000dc46 <.L52>

8000dc42 <.L51>:
        return status_invalid_argument;
8000dc42:	4789                	li	a5,2
8000dc44:	ace5                	j	8000df3c <.L64>

8000dc46 <.L52>:
    }

    if (prescaler == FEMC_PRESCALER_MAX) {
8000dc46:	5732                	lw	a4,44(sp)
8000dc48:	10000793          	li	a5,256
8000dc4c:	00f71363          	bne	a4,a5,8000dc52 <.L54>
        prescaler = 0;
8000dc50:	d602                	sw	zero,44(sp)

8000dc52 <.L54>:
    }

    if (refresh_cycle == FEMC_PRESCALER_MAX) {
8000dc52:	5722                	lw	a4,40(sp)
8000dc54:	10000793          	li	a5,256
8000dc58:	00f71363          	bne	a4,a5,8000dc5e <.L55>
        refresh_cycle = 0;
8000dc5c:	d402                	sw	zero,40(sp)

8000dc5e <.L55>:
    }

    if (config->cs == 1) {
8000dc5e:	4792                	lw	a5,4(sp)
8000dc60:	00e7c703          	lbu	a4,14(a5)
8000dc64:	4785                	li	a5,1
8000dc66:	00f71a63          	bne	a4,a5,8000dc7a <.L56>
        ptr->IOCTRL = (ptr->IOCTRL & ~FEMC_IOCTRL_IO_CSX_MASK) | FEMC_IOCTRL_IO_CSX_SET(FEMC_IO_CSX_SDRAM_CS1);
8000dc6a:	47b2                	lw	a5,12(sp)
8000dc6c:	43dc                	lw	a5,4(a5)
8000dc6e:	f0f7f793          	and	a5,a5,-241
8000dc72:	0107e713          	or	a4,a5,16
8000dc76:	47b2                	lw	a5,12(sp)
8000dc78:	c3d8                	sw	a4,4(a5)

8000dc7a <.L56>:
    }

    ptr->SDRCTRL0 = FEMC_SDRCTRL0_PORTSZ_SET(config->port_size)
8000dc7a:	4792                	lw	a5,4(sp)
8000dc7c:	0117c783          	lbu	a5,17(a5)
8000dc80:	0037f713          	and	a4,a5,3
                  | FEMC_SDRCTRL0_BURSTLEN_SET(burst_len)
8000dc84:	01e14783          	lbu	a5,30(sp)
8000dc88:	0792                	sll	a5,a5,0x4
8000dc8a:	0707f793          	and	a5,a5,112
8000dc8e:	8f5d                	or	a4,a4,a5
                  | FEMC_SDRCTRL0_COL_SET(config->col_addr_bits)
8000dc90:	4792                	lw	a5,4(sp)
8000dc92:	00c7c783          	lbu	a5,12(a5)
8000dc96:	07a2                	sll	a5,a5,0x8
8000dc98:	3007f793          	and	a5,a5,768
8000dc9c:	8f5d                	or	a4,a4,a5
                  | FEMC_SDRCTRL0_COL8_SET(config->col_addr_bits == FEMC_SDRAM_COLUMN_ADDR_8_BITS)
8000dc9e:	4792                	lw	a5,4(sp)
8000dca0:	00c7c683          	lbu	a3,12(a5)
8000dca4:	4791                	li	a5,4
8000dca6:	00f69563          	bne	a3,a5,8000dcb0 <.L57>
8000dcaa:	08000793          	li	a5,128
8000dcae:	a011                	j	8000dcb2 <.L58>

8000dcb0 <.L57>:
8000dcb0:	4781                	li	a5,0

8000dcb2 <.L58>:
8000dcb2:	8f5d                	or	a4,a4,a5
                  | FEMC_SDRCTRL0_CAS_SET(config->cas_latency)
8000dcb4:	4792                	lw	a5,4(sp)
8000dcb6:	00d7c783          	lbu	a5,13(a5)
8000dcba:	00a79693          	sll	a3,a5,0xa
8000dcbe:	6785                	lui	a5,0x1
8000dcc0:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8000dcc4:	8ff5                	and	a5,a5,a3
8000dcc6:	8f5d                	or	a4,a4,a5
                  | FEMC_SDRCTRL0_BANK2_SET(config->bank_num);
8000dcc8:	4792                	lw	a5,4(sp)
8000dcca:	00f7c783          	lbu	a5,15(a5)
8000dcce:	00e79693          	sll	a3,a5,0xe
8000dcd2:	6791                	lui	a5,0x4
8000dcd4:	8ff5                	and	a5,a5,a3
8000dcd6:	8f5d                	or	a4,a4,a5
    ptr->SDRCTRL0 = FEMC_SDRCTRL0_PORTSZ_SET(config->port_size)
8000dcd8:	47b2                	lw	a5,12(sp)
8000dcda:	c3b8                	sw	a4,64(a5)

    ptr->SDRCTRL1 = FEMC_SDRCTRL1_PRE2ACT_SET(ns2cycle(clk_in_hz, config->precharge_to_act_in_ns, FEMC_SDRCTRL1_PRE2ACT_MASK >> FEMC_SDRCTRL1_PRE2ACT_SHIFT))
8000dcdc:	4792                	lw	a5,4(sp)
8000dcde:	0157c783          	lbu	a5,21(a5) # 4015 <__DLM_segment_used_size__+0x15>
8000dce2:	463d                	li	a2,15
8000dce4:	85be                	mv	a1,a5
8000dce6:	4522                	lw	a0,8(sp)
8000dce8:	94afd0ef          	jal	8000ae32 <ns2cycle>
8000dcec:	87aa                	mv	a5,a0
8000dcee:	00f7f413          	and	s0,a5,15
                  | FEMC_SDRCTRL1_ACT2RW_SET(ns2cycle(clk_in_hz, config->act_to_rw_in_ns, FEMC_SDRCTRL1_ACT2RW_MASK >> FEMC_SDRCTRL1_ACT2RW_SHIFT))
8000dcf2:	4792                	lw	a5,4(sp)
8000dcf4:	0167c783          	lbu	a5,22(a5)
8000dcf8:	463d                	li	a2,15
8000dcfa:	85be                	mv	a1,a5
8000dcfc:	4522                	lw	a0,8(sp)
8000dcfe:	934fd0ef          	jal	8000ae32 <ns2cycle>
8000dd02:	87aa                	mv	a5,a0
8000dd04:	0792                	sll	a5,a5,0x4
8000dd06:	0f07f793          	and	a5,a5,240
8000dd0a:	8c5d                	or	s0,s0,a5
                  | FEMC_SDRCTRL1_RFRC_SET(ns2cycle(clk_in_hz, config->refresh_recover_in_ns, FEMC_SDRCTRL1_RFRC_MASK >> FEMC_SDRCTRL1_RFRC_SHIFT))
8000dd0c:	4792                	lw	a5,4(sp)
8000dd0e:	01b7c783          	lbu	a5,27(a5)
8000dd12:	467d                	li	a2,31
8000dd14:	85be                	mv	a1,a5
8000dd16:	4522                	lw	a0,8(sp)
8000dd18:	91afd0ef          	jal	8000ae32 <ns2cycle>
8000dd1c:	87aa                	mv	a5,a0
8000dd1e:	00879713          	sll	a4,a5,0x8
8000dd22:	6789                	lui	a5,0x2
8000dd24:	f0078793          	add	a5,a5,-256 # 1f00 <__NOR_CFG_OPTION_segment_size__+0x1300>
8000dd28:	8ff9                	and	a5,a5,a4
8000dd2a:	8c5d                	or	s0,s0,a5
                  | FEMC_SDRCTRL1_WRC_SET(ns2cycle(clk_in_hz, config->write_recover_in_ns, FEMC_SDRCTRL1_WRC_MASK >> FEMC_SDRCTRL1_WRC_SHIFT))
8000dd2c:	4792                	lw	a5,4(sp)
8000dd2e:	0197c783          	lbu	a5,25(a5)
8000dd32:	461d                	li	a2,7
8000dd34:	85be                	mv	a1,a5
8000dd36:	4522                	lw	a0,8(sp)
8000dd38:	8fafd0ef          	jal	8000ae32 <ns2cycle>
8000dd3c:	87aa                	mv	a5,a0
8000dd3e:	00d79713          	sll	a4,a5,0xd
8000dd42:	67b9                	lui	a5,0xe
8000dd44:	8ff9                	and	a5,a5,a4
8000dd46:	8c5d                	or	s0,s0,a5
                  | FEMC_SDRCTRL1_CKEOFF_SET(ns2cycle(clk_in_hz, config->cke_off_in_ns, FEMC_SDRCTRL1_CKEOFF_MASK >> FEMC_SDRCTRL1_CKEOFF_SHIFT))
8000dd48:	4792                	lw	a5,4(sp)
8000dd4a:	0137c783          	lbu	a5,19(a5) # e013 <__AHB_SRAM_segment_size__+0x6013>
8000dd4e:	463d                	li	a2,15
8000dd50:	85be                	mv	a1,a5
8000dd52:	4522                	lw	a0,8(sp)
8000dd54:	8defd0ef          	jal	8000ae32 <ns2cycle>
8000dd58:	87aa                	mv	a5,a0
8000dd5a:	01079713          	sll	a4,a5,0x10
8000dd5e:	000f07b7          	lui	a5,0xf0
8000dd62:	8ff9                	and	a5,a5,a4
8000dd64:	8c5d                	or	s0,s0,a5
                  | FEMC_SDRCTRL1_ACT2PRE_SET(ns2cycle(clk_in_hz, config->act_to_precharge_in_ns, FEMC_SDRCTRL1_ACT2PRE_MASK >> FEMC_SDRCTRL1_ACT2PRE_SHIFT));
8000dd66:	4792                	lw	a5,4(sp)
8000dd68:	0147c783          	lbu	a5,20(a5) # f0014 <__AXI_SRAM_segment_size__+0x30014>
8000dd6c:	463d                	li	a2,15
8000dd6e:	85be                	mv	a1,a5
8000dd70:	4522                	lw	a0,8(sp)
8000dd72:	8c0fd0ef          	jal	8000ae32 <ns2cycle>
8000dd76:	87aa                	mv	a5,a0
8000dd78:	01479713          	sll	a4,a5,0x14
8000dd7c:	00f007b7          	lui	a5,0xf00
8000dd80:	8ff9                	and	a5,a5,a4
8000dd82:	00f46733          	or	a4,s0,a5
    ptr->SDRCTRL1 = FEMC_SDRCTRL1_PRE2ACT_SET(ns2cycle(clk_in_hz, config->precharge_to_act_in_ns, FEMC_SDRCTRL1_PRE2ACT_MASK >> FEMC_SDRCTRL1_PRE2ACT_SHIFT))
8000dd86:	47b2                	lw	a5,12(sp)
8000dd88:	c3f8                	sw	a4,68(a5)

    ptr->SDRCTRL2 = FEMC_SDRCTRL2_SRRC_SET(ns2cycle(clk_in_hz, config->self_refresh_recover_in_ns, FEMC_SDRCTRL2_SRRC_MASK >> FEMC_SDRCTRL2_SRRC_SHIFT))
8000dd8a:	4792                	lw	a5,4(sp)
8000dd8c:	01a7c783          	lbu	a5,26(a5) # f0001a <__SDRAM_segment_size__+0x30001a>
8000dd90:	0ff00613          	li	a2,255
8000dd94:	85be                	mv	a1,a5
8000dd96:	4522                	lw	a0,8(sp)
8000dd98:	89afd0ef          	jal	8000ae32 <ns2cycle>
8000dd9c:	87aa                	mv	a5,a0
8000dd9e:	0ff7f413          	zext.b	s0,a5
                  | FEMC_SDRCTRL2_REF2REF_SET(ns2cycle(clk_in_hz, config->refresh_to_refresh_in_ns, FEMC_SDRCTRL2_REF2REF_MASK >> FEMC_SDRCTRL2_REF2REF_SHIFT))
8000dda2:	4792                	lw	a5,4(sp)
8000dda4:	0187c783          	lbu	a5,24(a5)
8000dda8:	0ff00613          	li	a2,255
8000ddac:	85be                	mv	a1,a5
8000ddae:	4522                	lw	a0,8(sp)
8000ddb0:	882fd0ef          	jal	8000ae32 <ns2cycle>
8000ddb4:	87aa                	mv	a5,a0
8000ddb6:	00879713          	sll	a4,a5,0x8
8000ddba:	67c1                	lui	a5,0x10
8000ddbc:	f0078793          	add	a5,a5,-256 # ff00 <__FLASH_segment_used_size__+0x1a38>
8000ddc0:	8ff9                	and	a5,a5,a4
8000ddc2:	8c5d                	or	s0,s0,a5
                  | FEMC_SDRCTRL2_ACT2ACT_SET(ns2cycle(clk_in_hz, config->act_to_act_in_ns, FEMC_SDRCTRL2_ACT2ACT_MASK >> FEMC_SDRCTRL2_ACT2ACT_SHIFT))
8000ddc4:	4792                	lw	a5,4(sp)
8000ddc6:	0177c783          	lbu	a5,23(a5)
8000ddca:	0ff00613          	li	a2,255
8000ddce:	85be                	mv	a1,a5
8000ddd0:	4522                	lw	a0,8(sp)
8000ddd2:	860fd0ef          	jal	8000ae32 <ns2cycle>
8000ddd6:	87aa                	mv	a5,a0
8000ddd8:	01079713          	sll	a4,a5,0x10
8000dddc:	00ff07b7          	lui	a5,0xff0
8000dde0:	8ff9                	and	a5,a5,a4
8000dde2:	8c5d                	or	s0,s0,a5
                  | FEMC_SDRCTRL2_ITO_SET(ns2cycle(clk_in_hz, config->idle_timeout_in_ns, FEMC_SDRCTRL2_ITO_MASK >> FEMC_SDRCTRL2_ITO_SHIFT));
8000dde4:	4792                	lw	a5,4(sp)
8000dde6:	01d7c783          	lbu	a5,29(a5) # ff001d <__SDRAM_segment_size__+0x3f001d>
8000ddea:	0ff00613          	li	a2,255
8000ddee:	85be                	mv	a1,a5
8000ddf0:	4522                	lw	a0,8(sp)
8000ddf2:	840fd0ef          	jal	8000ae32 <ns2cycle>
8000ddf6:	87aa                	mv	a5,a0
8000ddf8:	07e2                	sll	a5,a5,0x18
8000ddfa:	00f46733          	or	a4,s0,a5
    ptr->SDRCTRL2 = FEMC_SDRCTRL2_SRRC_SET(ns2cycle(clk_in_hz, config->self_refresh_recover_in_ns, FEMC_SDRCTRL2_SRRC_MASK >> FEMC_SDRCTRL2_SRRC_SHIFT))
8000ddfe:	47b2                	lw	a5,12(sp)
8000de00:	c7b8                	sw	a4,72(a5)

    ptr->SDRCTRL3 = FEMC_SDRCTRL3_PRESCALE_SET(prescaler)
8000de02:	57b2                	lw	a5,44(sp)
8000de04:	00879713          	sll	a4,a5,0x8
8000de08:	67c1                	lui	a5,0x10
8000de0a:	17fd                	add	a5,a5,-1 # ffff <__FLASH_segment_used_size__+0x1b37>
8000de0c:	8f7d                	and	a4,a4,a5
                  | FEMC_SDRCTRL3_RT_SET(refresh_cycle)
8000de0e:	57a2                	lw	a5,40(sp)
8000de10:	01079693          	sll	a3,a5,0x10
8000de14:	00ff07b7          	lui	a5,0xff0
8000de18:	8ff5                	and	a5,a5,a3
8000de1a:	8f5d                	or	a4,a4,a5
                  | FEMC_SDRCTRL3_UT_SET(refresh_cycle)
8000de1c:	57a2                	lw	a5,40(sp)
8000de1e:	07e2                	sll	a5,a5,0x18
8000de20:	8f5d                	or	a4,a4,a5
                  | FEMC_SDRCTRL3_REBL_SET(config->auto_refresh_count_in_one_burst - 1);
8000de22:	4792                	lw	a5,4(sp)
8000de24:	01f7c783          	lbu	a5,31(a5) # ff001f <__SDRAM_segment_size__+0x3f001f>
8000de28:	17fd                	add	a5,a5,-1
8000de2a:	0786                	sll	a5,a5,0x1
8000de2c:	8bb9                	and	a5,a5,14
8000de2e:	8f5d                	or	a4,a4,a5
    ptr->SDRCTRL3 = FEMC_SDRCTRL3_PRESCALE_SET(prescaler)
8000de30:	47b2                	lw	a5,12(sp)
8000de32:	c7f8                	sw	a4,76(a5)

    ptr->BR[config->cs] = FEMC_BR_BASE_SET(config->base_address >> FEMC_BR_BASE_SHIFT) | FEMC_BR_SIZE_SET(size) | FEMC_BR_VLD_MASK;
8000de34:	4792                	lw	a5,4(sp)
8000de36:	4398                	lw	a4,0(a5)
8000de38:	77fd                	lui	a5,0xfffff
8000de3a:	8f7d                	and	a4,a4,a5
8000de3c:	01f14783          	lbu	a5,31(sp)
8000de40:	0786                	sll	a5,a5,0x1
8000de42:	03e7f793          	and	a5,a5,62
8000de46:	8fd9                	or	a5,a5,a4
8000de48:	4712                	lw	a4,4(sp)
8000de4a:	00e74703          	lbu	a4,14(a4)
8000de4e:	863a                	mv	a2,a4
8000de50:	0017e713          	or	a4,a5,1
8000de54:	46b2                	lw	a3,12(sp)
8000de56:	00460793          	add	a5,a2,4
8000de5a:	078a                	sll	a5,a5,0x2
8000de5c:	97b6                	add	a5,a5,a3
8000de5e:	c398                	sw	a4,0(a5)

    /*
     * config delay cell
     */
    femc_config_delay_cell(ptr, !config->delay_cell_disable, config->delay_cell_value);
8000de60:	4792                	lw	a5,4(sp)
8000de62:	0207c783          	lbu	a5,32(a5) # fffff020 <__APB_SRAM_segment_end__+0xbf0d020>
8000de66:	00f037b3          	snez	a5,a5
8000de6a:	0ff7f793          	zext.b	a5,a5
8000de6e:	0017c793          	xor	a5,a5,1
8000de72:	0ff7f793          	zext.b	a5,a5
8000de76:	8b85                	and	a5,a5,1
8000de78:	0ff7f713          	zext.b	a4,a5
8000de7c:	4792                	lw	a5,4(sp)
8000de7e:	0217c783          	lbu	a5,33(a5)
8000de82:	863e                	mv	a2,a5
8000de84:	85ba                	mv	a1,a4
8000de86:	4532                	lw	a0,12(sp)
8000de88:	36ad                	jal	8000d9f2 <femc_config_delay_cell>
     *     0b - 4
     *     1b - 1
     *     2b - 2
     *     3b - 3
     */
    ptr->DATSZ = FEMC_DATSZ_DATSZ_SET((config->cmd_data_width & (0x3UL)));
8000de8a:	4792                	lw	a5,4(sp)
8000de8c:	01e7c783          	lbu	a5,30(a5)
8000de90:	0037f713          	and	a4,a5,3
8000de94:	47b2                	lw	a5,12(sp)
8000de96:	08e7aa23          	sw	a4,148(a5)
    ptr->BYTEMSK = 0;
8000de9a:	47b2                	lw	a5,12(sp)
8000de9c:	0807ac23          	sw	zero,152(a5)

    cmd.opcode = FEMC_CMD_SDRAM_PRECHARGE_ALL;
8000dea0:	47bd                	li	a5,15
8000dea2:	c83e                	sw	a5,16(sp)
    cmd.data = 0;
8000dea4:	ca02                	sw	zero,20(sp)
    err = femc_issue_ip_cmd(ptr, config->base_address, &cmd);
8000dea6:	4792                	lw	a5,4(sp)
8000dea8:	439c                	lw	a5,0(a5)
8000deaa:	0818                	add	a4,sp,16
8000deac:	863a                	mv	a2,a4
8000deae:	85be                	mv	a1,a5
8000deb0:	4532                	lw	a0,12(sp)
8000deb2:	cfdfc0ef          	jal	8000abae <femc_issue_ip_cmd>
8000deb6:	cc2a                	sw	a0,24(sp)
    if (status_success != err) {
8000deb8:	47e2                	lw	a5,24(sp)
8000deba:	c399                	beqz	a5,8000dec0 <.L59>
        return err;
8000debc:	47e2                	lw	a5,24(sp)
8000debe:	a8bd                	j	8000df3c <.L64>

8000dec0 <.L59>:
    }

    cmd.opcode = FEMC_CMD_SDRAM_AUTO_REFRESH;
8000dec0:	47b1                	li	a5,12
8000dec2:	c83e                	sw	a5,16(sp)

8000dec4 <.LBB2>:
    for (uint8_t i = 0; i < config->auto_refresh_cmd_count; i++) {
8000dec4:	020103a3          	sb	zero,39(sp)
8000dec8:	a01d                	j	8000deee <.L60>

8000deca <.L62>:
        err = femc_issue_ip_cmd(ptr, config->base_address, &cmd);
8000deca:	4792                	lw	a5,4(sp)
8000decc:	439c                	lw	a5,0(a5)
8000dece:	0818                	add	a4,sp,16
8000ded0:	863a                	mv	a2,a4
8000ded2:	85be                	mv	a1,a5
8000ded4:	4532                	lw	a0,12(sp)
8000ded6:	cd9fc0ef          	jal	8000abae <femc_issue_ip_cmd>
8000deda:	cc2a                	sw	a0,24(sp)
        if (status_success != err) {
8000dedc:	47e2                	lw	a5,24(sp)
8000dede:	c399                	beqz	a5,8000dee4 <.L61>
            return err;
8000dee0:	47e2                	lw	a5,24(sp)
8000dee2:	a8a9                	j	8000df3c <.L64>

8000dee4 <.L61>:
    for (uint8_t i = 0; i < config->auto_refresh_cmd_count; i++) {
8000dee4:	02714783          	lbu	a5,39(sp)
8000dee8:	0785                	add	a5,a5,1
8000deea:	02f103a3          	sb	a5,39(sp)

8000deee <.L60>:
8000deee:	4792                	lw	a5,4(sp)
8000def0:	0227c783          	lbu	a5,34(a5)
8000def4:	02714703          	lbu	a4,39(sp)
8000def8:	fcf769e3          	bltu	a4,a5,8000deca <.L62>

8000defc <.LBE2>:
        }
    }

    cmd.opcode = FEMC_CMD_SDRAM_MODE_SET;
8000defc:	800007b7          	lui	a5,0x80000
8000df00:	07a9                	add	a5,a5,10 # 8000000a <__NONCACHEABLE_RAM_segment_end__+0x3f00000a>
8000df02:	c83e                	sw	a5,16(sp)
    /* FIXME: the mode register layout definition better to be passed in? */
    cmd.data = (uint32_t)(burst_len | config->cas_latency << 4);
8000df04:	01e14703          	lbu	a4,30(sp)
8000df08:	4792                	lw	a5,4(sp)
8000df0a:	00d7c783          	lbu	a5,13(a5)
8000df0e:	0792                	sll	a5,a5,0x4
8000df10:	8fd9                	or	a5,a5,a4
8000df12:	ca3e                	sw	a5,20(sp)
    err = femc_issue_ip_cmd(ptr, config->base_address, &cmd);
8000df14:	4792                	lw	a5,4(sp)
8000df16:	439c                	lw	a5,0(a5)
8000df18:	0818                	add	a4,sp,16
8000df1a:	863a                	mv	a2,a4
8000df1c:	85be                	mv	a1,a5
8000df1e:	4532                	lw	a0,12(sp)
8000df20:	c8ffc0ef          	jal	8000abae <femc_issue_ip_cmd>
8000df24:	cc2a                	sw	a0,24(sp)
    if (status_success != err) {
8000df26:	47e2                	lw	a5,24(sp)
8000df28:	c399                	beqz	a5,8000df2e <.L63>
        return err;
8000df2a:	47e2                	lw	a5,24(sp)
8000df2c:	a801                	j	8000df3c <.L64>

8000df2e <.L63>:
    }
    ptr->SDRCTRL3 |= FEMC_SDRCTRL3_REN_MASK;
8000df2e:	47b2                	lw	a5,12(sp)
8000df30:	47fc                	lw	a5,76(a5)
8000df32:	0017e713          	or	a4,a5,1
8000df36:	47b2                	lw	a5,12(sp)
8000df38:	c7f8                	sw	a4,76(a5)

    return status_success;
8000df3a:	4781                	li	a5,0

8000df3c <.L64>:
}
8000df3c:	853e                	mv	a0,a5
8000df3e:	50f2                	lw	ra,60(sp)
8000df40:	5462                	lw	s0,56(sp)
8000df42:	6121                	add	sp,sp,64
8000df44:	8082                	ret

Disassembly of section .text.pcfg_dcdc_set_voltage:

8000df46 <pcfg_dcdc_set_voltage>:

    return PCFG_DCDC_CURRENT_LEVEL_GET(ptr->DCDC_CURRENT) * PCFG_CURRENT_MEASUREMENT_STEP;
}

hpm_stat_t pcfg_dcdc_set_voltage(PCFG_Type *ptr, uint16_t mv)
{
8000df46:	1101                	add	sp,sp,-32
8000df48:	c62a                	sw	a0,12(sp)
8000df4a:	87ae                	mv	a5,a1
8000df4c:	00f11523          	sh	a5,10(sp)
    hpm_stat_t stat = status_success;
8000df50:	ce02                	sw	zero,28(sp)
    if ((mv < PCFG_SOC_DCDC_MIN_VOLTAGE_IN_MV) || (mv > PCFG_SOC_DCDC_MAX_VOLTAGE_IN_MV)) {
8000df52:	00a15703          	lhu	a4,10(sp)
8000df56:	25700793          	li	a5,599
8000df5a:	00e7f863          	bgeu	a5,a4,8000df6a <.L26>
8000df5e:	00a15703          	lhu	a4,10(sp)
8000df62:	55f00793          	li	a5,1375
8000df66:	00e7f463          	bgeu	a5,a4,8000df6e <.L27>

8000df6a <.L26>:
        return status_invalid_argument;
8000df6a:	4789                	li	a5,2
8000df6c:	a831                	j	8000df88 <.L28>

8000df6e <.L27>:
    }
    ptr->DCDC_MODE = (ptr->DCDC_MODE & ~PCFG_DCDC_MODE_VOLT_MASK) | PCFG_DCDC_MODE_VOLT_SET(mv);
8000df6e:	47b2                	lw	a5,12(sp)
8000df70:	4b98                	lw	a4,16(a5)
8000df72:	77fd                	lui	a5,0xfffff
8000df74:	8f7d                	and	a4,a4,a5
8000df76:	00a15683          	lhu	a3,10(sp)
8000df7a:	6785                	lui	a5,0x1
8000df7c:	17fd                	add	a5,a5,-1 # fff <__NOR_CFG_OPTION_segment_size__+0x3ff>
8000df7e:	8ff5                	and	a5,a5,a3
8000df80:	8f5d                	or	a4,a4,a5
8000df82:	47b2                	lw	a5,12(sp)
8000df84:	cb98                	sw	a4,16(a5)
    return stat;
8000df86:	47f2                	lw	a5,28(sp)

8000df88 <.L28>:
}
8000df88:	853e                	mv	a0,a5
8000df8a:	6105                	add	sp,sp,32
8000df8c:	8082                	ret

Disassembly of section .text.pllctl_pll_powerdown:

8000df8e <pllctl_pll_powerdown>:
{
8000df8e:	1141                	add	sp,sp,-16
8000df90:	c62a                	sw	a0,12(sp)
8000df92:	87ae                	mv	a5,a1
8000df94:	00f105a3          	sb	a5,11(sp)
    if (pll > (PLLCTL_SOC_PLL_MAX_COUNT - 1)) {
8000df98:	00b14703          	lbu	a4,11(sp)
8000df9c:	4791                	li	a5,4
8000df9e:	00e7f463          	bgeu	a5,a4,8000dfa6 <.L5>
        return status_invalid_argument;
8000dfa2:	4789                	li	a5,2
8000dfa4:	a805                	j	8000dfd4 <.L6>

8000dfa6 <.L5>:
    ptr->PLL[pll].CFG1 = (ptr->PLL[pll].CFG1 &
8000dfa6:	00b14783          	lbu	a5,11(sp)
8000dfaa:	4732                	lw	a4,12(sp)
8000dfac:	0785                	add	a5,a5,1
8000dfae:	079e                	sll	a5,a5,0x7
8000dfb0:	97ba                	add	a5,a5,a4
8000dfb2:	43d8                	lw	a4,4(a5)
            | PLLCTL_PLL_CFG1_PLLPD_SW_MASK;
8000dfb4:	7a0007b7          	lui	a5,0x7a000
8000dfb8:	17fd                	add	a5,a5,-1 # 79ffffff <__NONCACHEABLE_RAM_segment_end__+0x38ffffff>
8000dfba:	00f776b3          	and	a3,a4,a5
    ptr->PLL[pll].CFG1 = (ptr->PLL[pll].CFG1 &
8000dfbe:	00b14783          	lbu	a5,11(sp)
            | PLLCTL_PLL_CFG1_PLLPD_SW_MASK;
8000dfc2:	02000737          	lui	a4,0x2000
8000dfc6:	8f55                	or	a4,a4,a3
    ptr->PLL[pll].CFG1 = (ptr->PLL[pll].CFG1 &
8000dfc8:	46b2                	lw	a3,12(sp)
8000dfca:	0785                	add	a5,a5,1
8000dfcc:	079e                	sll	a5,a5,0x7
8000dfce:	97b6                	add	a5,a5,a3
8000dfd0:	c3d8                	sw	a4,4(a5)
    return status_success;
8000dfd2:	4781                	li	a5,0

8000dfd4 <.L6>:
}
8000dfd4:	853e                	mv	a0,a5
8000dfd6:	0141                	add	sp,sp,16
8000dfd8:	8082                	ret

Disassembly of section .text.pllctl_pll_is_enabled:

8000dfda <pllctl_pll_is_enabled>:
{
8000dfda:	1141                	add	sp,sp,-16
8000dfdc:	c62a                	sw	a0,12(sp)
8000dfde:	87ae                	mv	a5,a1
8000dfe0:	00f105a3          	sb	a5,11(sp)
    return (ptr->PLL[pll].STATUS & PLLCTL_PLL_STATUS_ENABLE_MASK);
8000dfe4:	00b14783          	lbu	a5,11(sp)
8000dfe8:	4732                	lw	a4,12(sp)
8000dfea:	079e                	sll	a5,a5,0x7
8000dfec:	97ba                	add	a5,a5,a4
8000dfee:	0a07a703          	lw	a4,160(a5)
8000dff2:	080007b7          	lui	a5,0x8000
8000dff6:	8ff9                	and	a5,a5,a4
8000dff8:	00f037b3          	snez	a5,a5
8000dffc:	0ff7f793          	zext.b	a5,a5
}
8000e000:	853e                	mv	a0,a5
8000e002:	0141                	add	sp,sp,16
8000e004:	8082                	ret

Disassembly of section .text.pllctl_pll_is_locked:

8000e006 <pllctl_pll_is_locked>:
 * @param [in] ptr Base address of the PLLCTL peripheral
 * @param [in] pll Index of the PLL to check
 * @return true if PLL is locked, false otherwise
 */
static inline bool pllctl_pll_is_locked(PLLCTL_Type *ptr, uint8_t pll)
{
8000e006:	1141                	add	sp,sp,-16
8000e008:	c62a                	sw	a0,12(sp)
8000e00a:	87ae                	mv	a5,a1
8000e00c:	00f105a3          	sb	a5,11(sp)
    return ((ptr->PLL[pll].STATUS & PLLCTL_PLL_STATUS_PLL_LOCK_COMB_MASK));
8000e010:	00b14783          	lbu	a5,11(sp)
8000e014:	4732                	lw	a4,12(sp)
8000e016:	079e                	sll	a5,a5,0x7
8000e018:	97ba                	add	a5,a5,a4
8000e01a:	0a07a783          	lw	a5,160(a5) # 80000a0 <__SHARE_RAM_segment_end__+0x6e800a0>
8000e01e:	8b89                	and	a5,a5,2
8000e020:	00f037b3          	snez	a5,a5
8000e024:	0ff7f793          	zext.b	a5,a5
}
8000e028:	853e                	mv	a0,a5
8000e02a:	0141                	add	sp,sp,16
8000e02c:	8082                	ret

Disassembly of section .text.pllctl_init_int_pll_with_freq:

8000e02e <pllctl_init_int_pll_with_freq>:
    return status_success;
}

hpm_stat_t pllctl_init_int_pll_with_freq(PLLCTL_Type *ptr, uint8_t pll,
                                    uint32_t freq_in_hz)
{
8000e02e:	7179                	add	sp,sp,-48
8000e030:	d606                	sw	ra,44(sp)
8000e032:	c62a                	sw	a0,12(sp)
8000e034:	87ae                	mv	a5,a1
8000e036:	c232                	sw	a2,4(sp)
8000e038:	00f105a3          	sb	a5,11(sp)
    if ((ptr == NULL) || (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
8000e03c:	47b2                	lw	a5,12(sp)
8000e03e:	c791                	beqz	a5,8000e04a <.L33>
8000e040:	00b14703          	lbu	a4,11(sp)
8000e044:	4791                	li	a5,4
8000e046:	00e7f463          	bgeu	a5,a4,8000e04e <.L34>

8000e04a <.L33>:
        return status_invalid_argument;
8000e04a:	4789                	li	a5,2
8000e04c:	ac2d                	j	8000e286 <.L35>

8000e04e <.L34>:
    }
    uint32_t freq, fbdiv, refdiv, postdiv;
    if ((freq_in_hz < PLLCTL_PLL_VCO_FREQ_MIN)
8000e04e:	4712                	lw	a4,4(sp)
8000e050:	165a17b7          	lui	a5,0x165a1
8000e054:	bbf78793          	add	a5,a5,-1089 # 165a0bbf <__SHARE_RAM_segment_end__+0x15420bbf>
8000e058:	00e7f963          	bgeu	a5,a4,8000e06a <.L36>
            || (freq_in_hz > PLLCTL_PLL_VCO_FREQ_MAX)) {
8000e05c:	4712                	lw	a4,4(sp)
8000e05e:	832157b7          	lui	a5,0x83215
8000e062:	60078793          	add	a5,a5,1536 # 83215600 <__FLASH_segment_end__+0x2a15600>
8000e066:	00e7f463          	bgeu	a5,a4,8000e06e <.L37>

8000e06a <.L36>:
        return status_invalid_argument;
8000e06a:	4789                	li	a5,2
8000e06c:	ac29                	j	8000e286 <.L35>

8000e06e <.L37>:
    }

    freq = freq_in_hz;
8000e06e:	4792                	lw	a5,4(sp)
8000e070:	ca3e                	sw	a5,20(sp)
    refdiv = PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0);
8000e072:	00b14783          	lbu	a5,11(sp)
8000e076:	4732                	lw	a4,12(sp)
8000e078:	0785                	add	a5,a5,1
8000e07a:	079e                	sll	a5,a5,0x7
8000e07c:	97ba                	add	a5,a5,a4
8000e07e:	439c                	lw	a5,0(a5)
8000e080:	83e1                	srl	a5,a5,0x18
8000e082:	03f7f793          	and	a5,a5,63
8000e086:	cc3e                	sw	a5,24(sp)
    postdiv = PLLCTL_PLL_CFG0_POSTDIV1_GET(ptr->PLL[pll].CFG0);
8000e088:	00b14783          	lbu	a5,11(sp)
8000e08c:	4732                	lw	a4,12(sp)
8000e08e:	0785                	add	a5,a5,1
8000e090:	079e                	sll	a5,a5,0x7
8000e092:	97ba                	add	a5,a5,a4
8000e094:	439c                	lw	a5,0(a5)
8000e096:	83d1                	srl	a5,a5,0x14
8000e098:	8b9d                	and	a5,a5,7
8000e09a:	c83e                	sw	a5,16(sp)
    fbdiv = freq / (PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv));
8000e09c:	4762                	lw	a4,24(sp)
8000e09e:	47c2                	lw	a5,16(sp)
8000e0a0:	02f707b3          	mul	a5,a4,a5
8000e0a4:	016e3737          	lui	a4,0x16e3
8000e0a8:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000e0ac:	02f757b3          	divu	a5,a4,a5
8000e0b0:	4752                	lw	a4,20(sp)
8000e0b2:	02f757b3          	divu	a5,a4,a5
8000e0b6:	ce3e                	sw	a5,28(sp)
    if (fbdiv > PLLCTL_INT_PLL_MAX_FBDIV) {
8000e0b8:	4772                	lw	a4,28(sp)
8000e0ba:	6785                	lui	a5,0x1
8000e0bc:	96078793          	add	a5,a5,-1696 # 960 <__ILM_segment_used_end__+0x29a>
8000e0c0:	04e7f163          	bgeu	a5,a4,8000e102 <.L38>
        /* current refdiv can't be used for the given frequency */
        refdiv--;
8000e0c4:	47e2                	lw	a5,24(sp)
8000e0c6:	17fd                	add	a5,a5,-1
8000e0c8:	cc3e                	sw	a5,24(sp)

8000e0ca <.L42>:
        do {
            fbdiv = freq / (PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv));
8000e0ca:	4762                	lw	a4,24(sp)
8000e0cc:	47c2                	lw	a5,16(sp)
8000e0ce:	02f707b3          	mul	a5,a4,a5
8000e0d2:	016e3737          	lui	a4,0x16e3
8000e0d6:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000e0da:	02f757b3          	divu	a5,a4,a5
8000e0de:	4752                	lw	a4,20(sp)
8000e0e0:	02f757b3          	divu	a5,a4,a5
8000e0e4:	ce3e                	sw	a5,28(sp)
            if (fbdiv > PLLCTL_INT_PLL_MAX_FBDIV) {
8000e0e6:	4772                	lw	a4,28(sp)
8000e0e8:	6785                	lui	a5,0x1
8000e0ea:	96078793          	add	a5,a5,-1696 # 960 <__ILM_segment_used_end__+0x29a>
8000e0ee:	04e7fc63          	bgeu	a5,a4,8000e146 <.L54>
                refdiv--;
8000e0f2:	47e2                	lw	a5,24(sp)
8000e0f4:	17fd                	add	a5,a5,-1
8000e0f6:	cc3e                	sw	a5,24(sp)
            } else {
                break;
            }
        } while (refdiv > PLLCTL_PLL_MIN_REFDIV);
8000e0f8:	4762                	lw	a4,24(sp)
8000e0fa:	4785                	li	a5,1
8000e0fc:	fce7e7e3          	bltu	a5,a4,8000e0ca <.L42>
8000e100:	a0b1                	j	8000e14c <.L43>

8000e102 <.L38>:
    } else if (fbdiv < PLLCTL_INT_PLL_MIN_FBDIV) {
8000e102:	4772                	lw	a4,28(sp)
8000e104:	47bd                	li	a5,15
8000e106:	04e7e363          	bltu	a5,a4,8000e14c <.L43>
        /* current refdiv can't be used for the given frequency */
        refdiv++;
8000e10a:	47e2                	lw	a5,24(sp)
8000e10c:	0785                	add	a5,a5,1
8000e10e:	cc3e                	sw	a5,24(sp)

8000e110 <.L46>:
        do {
            fbdiv = freq / (PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv));
8000e110:	4762                	lw	a4,24(sp)
8000e112:	47c2                	lw	a5,16(sp)
8000e114:	02f707b3          	mul	a5,a4,a5
8000e118:	016e3737          	lui	a4,0x16e3
8000e11c:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000e120:	02f757b3          	divu	a5,a4,a5
8000e124:	4752                	lw	a4,20(sp)
8000e126:	02f757b3          	divu	a5,a4,a5
8000e12a:	ce3e                	sw	a5,28(sp)
            if (fbdiv < PLLCTL_INT_PLL_MIN_FBDIV) {
8000e12c:	4772                	lw	a4,28(sp)
8000e12e:	47bd                	li	a5,15
8000e130:	00e7ed63          	bltu	a5,a4,8000e14a <.L55>
                refdiv++;
8000e134:	47e2                	lw	a5,24(sp)
8000e136:	0785                	add	a5,a5,1
8000e138:	cc3e                	sw	a5,24(sp)
            } else {
                break;
            }
        } while (refdiv < PLLCTL_PLL_MAX_REFDIV);
8000e13a:	4762                	lw	a4,24(sp)
8000e13c:	03e00793          	li	a5,62
8000e140:	fce7f8e3          	bgeu	a5,a4,8000e110 <.L46>
8000e144:	a021                	j	8000e14c <.L43>

8000e146 <.L54>:
                break;
8000e146:	0001                	nop
8000e148:	a011                	j	8000e14c <.L43>

8000e14a <.L55>:
                break;
8000e14a:	0001                	nop

8000e14c <.L43>:
    }

    if ((refdiv > PLLCTL_PLL_MAX_REFDIV)
8000e14c:	4762                	lw	a4,24(sp)
8000e14e:	03f00793          	li	a5,63
8000e152:	02e7eb63          	bltu	a5,a4,8000e188 <.L47>
            || (refdiv < PLLCTL_PLL_MIN_REFDIV)
8000e156:	47e2                	lw	a5,24(sp)
8000e158:	cb85                	beqz	a5,8000e188 <.L47>
            || (fbdiv > PLLCTL_INT_PLL_MAX_FBDIV)
8000e15a:	4772                	lw	a4,28(sp)
8000e15c:	6785                	lui	a5,0x1
8000e15e:	96078793          	add	a5,a5,-1696 # 960 <__ILM_segment_used_end__+0x29a>
8000e162:	02e7e363          	bltu	a5,a4,8000e188 <.L47>
            || (fbdiv < PLLCTL_INT_PLL_MIN_FBDIV)
8000e166:	4772                	lw	a4,28(sp)
8000e168:	47bd                	li	a5,15
8000e16a:	00e7ff63          	bgeu	a5,a4,8000e188 <.L47>
            || (((PLLCTL_SOC_PLL_REFCLK_FREQ / refdiv) < PLLCTL_INT_PLL_MIN_REF))) {
8000e16e:	016e37b7          	lui	a5,0x16e3
8000e172:	60078713          	add	a4,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000e176:	47e2                	lw	a5,24(sp)
8000e178:	02f75733          	divu	a4,a4,a5
8000e17c:	000f47b7          	lui	a5,0xf4
8000e180:	23f78793          	add	a5,a5,575 # f423f <__AXI_SRAM_segment_size__+0x3423f>
8000e184:	00e7e663          	bltu	a5,a4,8000e190 <.L48>

8000e188 <.L47>:
        return status_pllctl_out_of_range;
8000e188:	6799                	lui	a5,0x6
8000e18a:	9da78793          	add	a5,a5,-1574 # 59da <__DLM_segment_used_size__+0x19da>
8000e18e:	a8e5                	j	8000e286 <.L35>

8000e190 <.L48>:
    }

    if (!(ptr->PLL[pll].CFG0 & PLLCTL_PLL_CFG0_DSMPD_MASK)) {
8000e190:	00b14783          	lbu	a5,11(sp)
8000e194:	4732                	lw	a4,12(sp)
8000e196:	0785                	add	a5,a5,1
8000e198:	079e                	sll	a5,a5,0x7
8000e19a:	97ba                	add	a5,a5,a4
8000e19c:	439c                	lw	a5,0(a5)
8000e19e:	8ba1                	and	a5,a5,8
8000e1a0:	e795                	bnez	a5,8000e1cc <.L49>
        /* it was at frac mode, then it needs to be power down */
        pllctl_pll_powerdown(ptr, pll);
8000e1a2:	00b14783          	lbu	a5,11(sp)
8000e1a6:	85be                	mv	a1,a5
8000e1a8:	4532                	lw	a0,12(sp)
8000e1aa:	33d5                	jal	8000df8e <pllctl_pll_powerdown>
        ptr->PLL[pll].CFG0 |= PLLCTL_PLL_CFG0_DSMPD_MASK;
8000e1ac:	00b14783          	lbu	a5,11(sp)
8000e1b0:	4732                	lw	a4,12(sp)
8000e1b2:	0785                	add	a5,a5,1
8000e1b4:	079e                	sll	a5,a5,0x7
8000e1b6:	97ba                	add	a5,a5,a4
8000e1b8:	4398                	lw	a4,0(a5)
8000e1ba:	00b14783          	lbu	a5,11(sp)
8000e1be:	00876713          	or	a4,a4,8
8000e1c2:	46b2                	lw	a3,12(sp)
8000e1c4:	0785                	add	a5,a5,1
8000e1c6:	079e                	sll	a5,a5,0x7
8000e1c8:	97b6                	add	a5,a5,a3
8000e1ca:	c398                	sw	a4,0(a5)

8000e1cc <.L49>:
    }

    if (PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0) != refdiv) {
8000e1cc:	00b14783          	lbu	a5,11(sp)
8000e1d0:	4732                	lw	a4,12(sp)
8000e1d2:	0785                	add	a5,a5,1
8000e1d4:	079e                	sll	a5,a5,0x7
8000e1d6:	97ba                	add	a5,a5,a4
8000e1d8:	439c                	lw	a5,0(a5)
8000e1da:	83e1                	srl	a5,a5,0x18
8000e1dc:	03f7f793          	and	a5,a5,63
8000e1e0:	4762                	lw	a4,24(sp)
8000e1e2:	04f70163          	beq	a4,a5,8000e224 <.L50>
        /* if refdiv is different, it needs to be power down */
        pllctl_pll_powerdown(ptr, pll);
8000e1e6:	00b14783          	lbu	a5,11(sp)
8000e1ea:	85be                	mv	a1,a5
8000e1ec:	4532                	lw	a0,12(sp)
8000e1ee:	3345                	jal	8000df8e <pllctl_pll_powerdown>
        ptr->PLL[pll].CFG0 = (ptr->PLL[pll].CFG0 & ~PLLCTL_PLL_CFG0_REFDIV_MASK)
8000e1f0:	00b14783          	lbu	a5,11(sp)
8000e1f4:	4732                	lw	a4,12(sp)
8000e1f6:	0785                	add	a5,a5,1
8000e1f8:	079e                	sll	a5,a5,0x7
8000e1fa:	97ba                	add	a5,a5,a4
8000e1fc:	4398                	lw	a4,0(a5)
8000e1fe:	c10007b7          	lui	a5,0xc1000
8000e202:	17fd                	add	a5,a5,-1 # c0ffffff <__FLASH_segment_end__+0x407fffff>
8000e204:	00f776b3          	and	a3,a4,a5
            | PLLCTL_PLL_CFG0_REFDIV_SET(refdiv);
8000e208:	47e2                	lw	a5,24(sp)
8000e20a:	01879713          	sll	a4,a5,0x18
8000e20e:	3f0007b7          	lui	a5,0x3f000
8000e212:	8f7d                	and	a4,a4,a5
        ptr->PLL[pll].CFG0 = (ptr->PLL[pll].CFG0 & ~PLLCTL_PLL_CFG0_REFDIV_MASK)
8000e214:	00b14783          	lbu	a5,11(sp)
            | PLLCTL_PLL_CFG0_REFDIV_SET(refdiv);
8000e218:	8f55                	or	a4,a4,a3
        ptr->PLL[pll].CFG0 = (ptr->PLL[pll].CFG0 & ~PLLCTL_PLL_CFG0_REFDIV_MASK)
8000e21a:	46b2                	lw	a3,12(sp)
8000e21c:	0785                	add	a5,a5,1 # 3f000001 <__SHARE_RAM_segment_end__+0x3de80001>
8000e21e:	079e                	sll	a5,a5,0x7
8000e220:	97b6                	add	a5,a5,a3
8000e222:	c398                	sw	a4,0(a5)

8000e224 <.L50>:
    }

    ptr->PLL[pll].CFG2 = (ptr->PLL[pll].CFG2 & ~(PLLCTL_PLL_CFG2_FBDIV_INT_MASK)) | PLLCTL_PLL_CFG2_FBDIV_INT_SET(fbdiv);
8000e224:	00b14783          	lbu	a5,11(sp)
8000e228:	4732                	lw	a4,12(sp)
8000e22a:	0785                	add	a5,a5,1
8000e22c:	079e                	sll	a5,a5,0x7
8000e22e:	97ba                	add	a5,a5,a4
8000e230:	4798                	lw	a4,8(a5)
8000e232:	77fd                	lui	a5,0xfffff
8000e234:	00f776b3          	and	a3,a4,a5
8000e238:	4772                	lw	a4,28(sp)
8000e23a:	6785                	lui	a5,0x1
8000e23c:	17fd                	add	a5,a5,-1 # fff <__NOR_CFG_OPTION_segment_size__+0x3ff>
8000e23e:	8f7d                	and	a4,a4,a5
8000e240:	00b14783          	lbu	a5,11(sp)
8000e244:	8f55                	or	a4,a4,a3
8000e246:	46b2                	lw	a3,12(sp)
8000e248:	0785                	add	a5,a5,1
8000e24a:	079e                	sll	a5,a5,0x7
8000e24c:	97b6                	add	a5,a5,a3
8000e24e:	c798                	sw	a4,8(a5)

    pllctl_pll_poweron(ptr, pll);
8000e250:	00b14783          	lbu	a5,11(sp)
8000e254:	85be                	mv	a1,a5
8000e256:	4532                	lw	a0,12(sp)
8000e258:	c11fc0ef          	jal	8000ae68 <pllctl_pll_poweron>

    while (pllctl_pll_is_enabled(ptr, pll) && !pllctl_pll_is_locked(ptr, pll)) {
8000e25c:	a011                	j	8000e260 <.L51>

8000e25e <.L53>:
        NOP();
8000e25e:	0001                	nop

8000e260 <.L51>:
    while (pllctl_pll_is_enabled(ptr, pll) && !pllctl_pll_is_locked(ptr, pll)) {
8000e260:	00b14783          	lbu	a5,11(sp)
8000e264:	85be                	mv	a1,a5
8000e266:	4532                	lw	a0,12(sp)
8000e268:	3b8d                	jal	8000dfda <pllctl_pll_is_enabled>
8000e26a:	87aa                	mv	a5,a0
8000e26c:	cf81                	beqz	a5,8000e284 <.L52>
8000e26e:	00b14783          	lbu	a5,11(sp)
8000e272:	85be                	mv	a1,a5
8000e274:	4532                	lw	a0,12(sp)
8000e276:	3b41                	jal	8000e006 <pllctl_pll_is_locked>
8000e278:	87aa                	mv	a5,a0
8000e27a:	0017c793          	xor	a5,a5,1
8000e27e:	0ff7f793          	zext.b	a5,a5
8000e282:	fff1                	bnez	a5,8000e25e <.L53>

8000e284 <.L52>:
    }
    return status_success;
8000e284:	4781                	li	a5,0

8000e286 <.L35>:
}
8000e286:	853e                	mv	a0,a5
8000e288:	50b2                	lw	ra,44(sp)
8000e28a:	6145                	add	sp,sp,48
8000e28c:	8082                	ret

Disassembly of section .text.pllctl_get_pll_freq_in_hz:

8000e28e <pllctl_get_pll_freq_in_hz>:
    }
    return status_success;
}

uint32_t pllctl_get_pll_freq_in_hz(PLLCTL_Type *ptr, uint8_t pll)
{
8000e28e:	715d                	add	sp,sp,-80
8000e290:	c686                	sw	ra,76(sp)
8000e292:	c4a2                	sw	s0,72(sp)
8000e294:	c2a6                	sw	s1,68(sp)
8000e296:	c0ca                	sw	s2,64(sp)
8000e298:	de4e                	sw	s3,60(sp)
8000e29a:	c62a                	sw	a0,12(sp)
8000e29c:	87ae                	mv	a5,a1
8000e29e:	00f105a3          	sb	a5,11(sp)
    if ((ptr == NULL) || (pll >= PLLCTL_SOC_PLL_MAX_COUNT)) {
8000e2a2:	47b2                	lw	a5,12(sp)
8000e2a4:	c791                	beqz	a5,8000e2b0 <.L79>
8000e2a6:	00b14703          	lbu	a4,11(sp)
8000e2aa:	4791                	li	a5,4
8000e2ac:	00e7f463          	bgeu	a5,a4,8000e2b4 <.L80>

8000e2b0 <.L79>:
        return status_invalid_argument;
8000e2b0:	4789                	li	a5,2
8000e2b2:	aa35                	j	8000e3ee <.L81>

8000e2b4 <.L80>:
    }
    uint32_t fbdiv, frac, refdiv, postdiv, refclk, freq;
    if (ptr->PLL[pll].CFG1 & PLLCTL_PLL_CFG1_PLLPD_SW_MASK) {
8000e2b4:	00b14783          	lbu	a5,11(sp)
8000e2b8:	4732                	lw	a4,12(sp)
8000e2ba:	0785                	add	a5,a5,1
8000e2bc:	079e                	sll	a5,a5,0x7
8000e2be:	97ba                	add	a5,a5,a4
8000e2c0:	43d8                	lw	a4,4(a5)
8000e2c2:	020007b7          	lui	a5,0x2000
8000e2c6:	8ff9                	and	a5,a5,a4
8000e2c8:	c399                	beqz	a5,8000e2ce <.L82>
        /* pll is powered down */
        return 0;
8000e2ca:	4781                	li	a5,0
8000e2cc:	a20d                	j	8000e3ee <.L81>

8000e2ce <.L82>:
    }

    refdiv = PLLCTL_PLL_CFG0_REFDIV_GET(ptr->PLL[pll].CFG0);
8000e2ce:	00b14783          	lbu	a5,11(sp)
8000e2d2:	4732                	lw	a4,12(sp)
8000e2d4:	0785                	add	a5,a5,1 # 2000001 <__SHARE_RAM_segment_end__+0xe80001>
8000e2d6:	079e                	sll	a5,a5,0x7
8000e2d8:	97ba                	add	a5,a5,a4
8000e2da:	439c                	lw	a5,0(a5)
8000e2dc:	83e1                	srl	a5,a5,0x18
8000e2de:	03f7f793          	and	a5,a5,63
8000e2e2:	d43e                	sw	a5,40(sp)
    postdiv = PLLCTL_PLL_CFG0_POSTDIV1_GET(ptr->PLL[pll].CFG0);
8000e2e4:	00b14783          	lbu	a5,11(sp)
8000e2e8:	4732                	lw	a4,12(sp)
8000e2ea:	0785                	add	a5,a5,1
8000e2ec:	079e                	sll	a5,a5,0x7
8000e2ee:	97ba                	add	a5,a5,a4
8000e2f0:	439c                	lw	a5,0(a5)
8000e2f2:	83d1                	srl	a5,a5,0x14
8000e2f4:	8b9d                	and	a5,a5,7
8000e2f6:	d23e                	sw	a5,36(sp)
    refclk = PLLCTL_SOC_PLL_REFCLK_FREQ / (refdiv * postdiv);
8000e2f8:	5722                	lw	a4,40(sp)
8000e2fa:	5792                	lw	a5,36(sp)
8000e2fc:	02f707b3          	mul	a5,a4,a5
8000e300:	016e3737          	lui	a4,0x16e3
8000e304:	60070713          	add	a4,a4,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000e308:	02f757b3          	divu	a5,a4,a5
8000e30c:	d03e                	sw	a5,32(sp)

    if (ptr->PLL[pll].CFG0 & PLLCTL_PLL_CFG0_DSMPD_MASK) {
8000e30e:	00b14783          	lbu	a5,11(sp)
8000e312:	4732                	lw	a4,12(sp)
8000e314:	0785                	add	a5,a5,1
8000e316:	079e                	sll	a5,a5,0x7
8000e318:	97ba                	add	a5,a5,a4
8000e31a:	439c                	lw	a5,0(a5)
8000e31c:	8ba1                	and	a5,a5,8
8000e31e:	c395                	beqz	a5,8000e342 <.L83>
        /* pll int mode */
        fbdiv = PLLCTL_PLL_CFG2_FBDIV_INT_GET(ptr->PLL[pll].CFG2);
8000e320:	00b14783          	lbu	a5,11(sp)
8000e324:	4732                	lw	a4,12(sp)
8000e326:	0785                	add	a5,a5,1
8000e328:	079e                	sll	a5,a5,0x7
8000e32a:	97ba                	add	a5,a5,a4
8000e32c:	4798                	lw	a4,8(a5)
8000e32e:	6785                	lui	a5,0x1
8000e330:	17fd                	add	a5,a5,-1 # fff <__NOR_CFG_OPTION_segment_size__+0x3ff>
8000e332:	8ff9                	and	a5,a5,a4
8000e334:	ce3e                	sw	a5,28(sp)
        freq = refclk * fbdiv;
8000e336:	5702                	lw	a4,32(sp)
8000e338:	47f2                	lw	a5,28(sp)
8000e33a:	02f707b3          	mul	a5,a4,a5
8000e33e:	d63e                	sw	a5,44(sp)
8000e340:	a075                	j	8000e3ec <.L84>

8000e342 <.L83>:
    } else {
        /* pll frac mode */
        fbdiv = PLLCTL_PLL_FREQ_FBDIV_FRAC_GET(ptr->PLL[pll].FREQ);
8000e342:	00b14783          	lbu	a5,11(sp)
8000e346:	4732                	lw	a4,12(sp)
8000e348:	0785                	add	a5,a5,1
8000e34a:	079e                	sll	a5,a5,0x7
8000e34c:	97ba                	add	a5,a5,a4
8000e34e:	47dc                	lw	a5,12(a5)
8000e350:	0ff7f793          	zext.b	a5,a5
8000e354:	ce3e                	sw	a5,28(sp)
        frac = PLLCTL_PLL_FREQ_FRAC_GET(ptr->PLL[pll].FREQ);
8000e356:	00b14783          	lbu	a5,11(sp)
8000e35a:	4732                	lw	a4,12(sp)
8000e35c:	0785                	add	a5,a5,1
8000e35e:	079e                	sll	a5,a5,0x7
8000e360:	97ba                	add	a5,a5,a4
8000e362:	47dc                	lw	a5,12(a5)
8000e364:	0087d713          	srl	a4,a5,0x8
8000e368:	010007b7          	lui	a5,0x1000
8000e36c:	17fd                	add	a5,a5,-1 # ffffff <__SDRAM_segment_size__+0x3fffff>
8000e36e:	8ff9                	and	a5,a5,a4
8000e370:	cc3e                	sw	a5,24(sp)
        freq = (uint32_t)((refclk * (fbdiv + ((double) frac / (1 << 24)))) + 0.5);
8000e372:	5502                	lw	a0,32(sp)
8000e374:	061010ef          	jal	8000fbd4 <__floatunsidf>
8000e378:	842a                	mv	s0,a0
8000e37a:	84ae                	mv	s1,a1
8000e37c:	4572                	lw	a0,28(sp)
8000e37e:	057010ef          	jal	8000fbd4 <__floatunsidf>
8000e382:	892a                	mv	s2,a0
8000e384:	89ae                	mv	s3,a1
8000e386:	4562                	lw	a0,24(sp)
8000e388:	04d010ef          	jal	8000fbd4 <__floatunsidf>
8000e38c:	872a                	mv	a4,a0
8000e38e:	87ae                	mv	a5,a1
8000e390:	800036b7          	lui	a3,0x80003
8000e394:	0906a603          	lw	a2,144(a3) # 80003090 <.LC1>
8000e398:	0946a683          	lw	a3,148(a3)
8000e39c:	853a                	mv	a0,a4
8000e39e:	85be                	mv	a1,a5
8000e3a0:	5e8010ef          	jal	8000f988 <__divdf3>
8000e3a4:	872a                	mv	a4,a0
8000e3a6:	87ae                	mv	a5,a1
8000e3a8:	863a                	mv	a2,a4
8000e3aa:	86be                	mv	a3,a5
8000e3ac:	854a                	mv	a0,s2
8000e3ae:	85ce                	mv	a1,s3
8000e3b0:	040010ef          	jal	8000f3f0 <__adddf3>
8000e3b4:	872a                	mv	a4,a0
8000e3b6:	87ae                	mv	a5,a1
8000e3b8:	863a                	mv	a2,a4
8000e3ba:	86be                	mv	a3,a5
8000e3bc:	8522                	mv	a0,s0
8000e3be:	85a6                	mv	a1,s1
8000e3c0:	3b8010ef          	jal	8000f778 <__muldf3>
8000e3c4:	872a                	mv	a4,a0
8000e3c6:	87ae                	mv	a5,a1
8000e3c8:	853a                	mv	a0,a4
8000e3ca:	85be                	mv	a1,a5
8000e3cc:	800037b7          	lui	a5,0x80003
8000e3d0:	0987a603          	lw	a2,152(a5) # 80003098 <.LC2>
8000e3d4:	09c7a683          	lw	a3,156(a5)
8000e3d8:	018010ef          	jal	8000f3f0 <__adddf3>
8000e3dc:	872a                	mv	a4,a0
8000e3de:	87ae                	mv	a5,a1
8000e3e0:	853a                	mv	a0,a4
8000e3e2:	85be                	mv	a1,a5
8000e3e4:	a01fd0ef          	jal	8000bde4 <__fixunsdfsi>
8000e3e8:	87aa                	mv	a5,a0
8000e3ea:	d63e                	sw	a5,44(sp)

8000e3ec <.L84>:
    }
    return freq;
8000e3ec:	57b2                	lw	a5,44(sp)

8000e3ee <.L81>:
}
8000e3ee:	853e                	mv	a0,a5
8000e3f0:	40b6                	lw	ra,76(sp)
8000e3f2:	4426                	lw	s0,72(sp)
8000e3f4:	4496                	lw	s1,68(sp)
8000e3f6:	4906                	lw	s2,64(sp)
8000e3f8:	59f2                	lw	s3,60(sp)
8000e3fa:	6161                	add	sp,sp,80
8000e3fc:	8082                	ret

Disassembly of section .text.write_pmp_cfg:

8000e3fe <write_pmp_cfg>:
{
8000e3fe:	1141                	add	sp,sp,-16
8000e400:	c62a                	sw	a0,12(sp)
8000e402:	c42e                	sw	a1,8(sp)
    switch (idx) {
8000e404:	4722                	lw	a4,8(sp)
8000e406:	478d                	li	a5,3
8000e408:	04f70163          	beq	a4,a5,8000e44a <.L11>
8000e40c:	4722                	lw	a4,8(sp)
8000e40e:	478d                	li	a5,3
8000e410:	04e7e163          	bltu	a5,a4,8000e452 <.L17>
8000e414:	4722                	lw	a4,8(sp)
8000e416:	4789                	li	a5,2
8000e418:	02f70563          	beq	a4,a5,8000e442 <.L13>
8000e41c:	4722                	lw	a4,8(sp)
8000e41e:	4789                	li	a5,2
8000e420:	02e7e963          	bltu	a5,a4,8000e452 <.L17>
8000e424:	47a2                	lw	a5,8(sp)
8000e426:	c791                	beqz	a5,8000e432 <.L14>
8000e428:	4722                	lw	a4,8(sp)
8000e42a:	4785                	li	a5,1
8000e42c:	00f70763          	beq	a4,a5,8000e43a <.L15>
        break;
8000e430:	a00d                	j	8000e452 <.L17>

8000e432 <.L14>:
        write_csr(CSR_PMPCFG0, value);
8000e432:	47b2                	lw	a5,12(sp)
8000e434:	3a079073          	csrw	pmpcfg0,a5
        break;
8000e438:	a831                	j	8000e454 <.L16>

8000e43a <.L15>:
        write_csr(CSR_PMPCFG1, value);
8000e43a:	47b2                	lw	a5,12(sp)
8000e43c:	3a179073          	csrw	pmpcfg1,a5
        break;
8000e440:	a811                	j	8000e454 <.L16>

8000e442 <.L13>:
        write_csr(CSR_PMPCFG2, value);
8000e442:	47b2                	lw	a5,12(sp)
8000e444:	3a279073          	csrw	pmpcfg2,a5
        break;
8000e448:	a031                	j	8000e454 <.L16>

8000e44a <.L11>:
        write_csr(CSR_PMPCFG3, value);
8000e44a:	47b2                	lw	a5,12(sp)
8000e44c:	3a379073          	csrw	pmpcfg3,a5
        break;
8000e450:	a011                	j	8000e454 <.L16>

8000e452 <.L17>:
        break;
8000e452:	0001                	nop

8000e454 <.L16>:
}
8000e454:	0001                	nop
8000e456:	0141                	add	sp,sp,16
8000e458:	8082                	ret

Disassembly of section .text.write_pma_cfg:

8000e45a <write_pma_cfg>:
{
8000e45a:	1141                	add	sp,sp,-16
8000e45c:	c62a                	sw	a0,12(sp)
8000e45e:	c42e                	sw	a1,8(sp)
    switch (idx) {
8000e460:	4722                	lw	a4,8(sp)
8000e462:	478d                	li	a5,3
8000e464:	04f70163          	beq	a4,a5,8000e4a6 <.L81>
8000e468:	4722                	lw	a4,8(sp)
8000e46a:	478d                	li	a5,3
8000e46c:	04e7e163          	bltu	a5,a4,8000e4ae <.L87>
8000e470:	4722                	lw	a4,8(sp)
8000e472:	4789                	li	a5,2
8000e474:	02f70563          	beq	a4,a5,8000e49e <.L83>
8000e478:	4722                	lw	a4,8(sp)
8000e47a:	4789                	li	a5,2
8000e47c:	02e7e963          	bltu	a5,a4,8000e4ae <.L87>
8000e480:	47a2                	lw	a5,8(sp)
8000e482:	c791                	beqz	a5,8000e48e <.L84>
8000e484:	4722                	lw	a4,8(sp)
8000e486:	4785                	li	a5,1
8000e488:	00f70763          	beq	a4,a5,8000e496 <.L85>
        break;
8000e48c:	a00d                	j	8000e4ae <.L87>

8000e48e <.L84>:
        write_csr(CSR_PMACFG0, value);
8000e48e:	47b2                	lw	a5,12(sp)
8000e490:	bc079073          	csrw	0xbc0,a5
        break;
8000e494:	a831                	j	8000e4b0 <.L86>

8000e496 <.L85>:
        write_csr(CSR_PMACFG1, value);
8000e496:	47b2                	lw	a5,12(sp)
8000e498:	bc179073          	csrw	0xbc1,a5
        break;
8000e49c:	a811                	j	8000e4b0 <.L86>

8000e49e <.L83>:
        write_csr(CSR_PMACFG2, value);
8000e49e:	47b2                	lw	a5,12(sp)
8000e4a0:	bc279073          	csrw	0xbc2,a5
        break;
8000e4a4:	a031                	j	8000e4b0 <.L86>

8000e4a6 <.L81>:
        write_csr(CSR_PMACFG3, value);
8000e4a6:	47b2                	lw	a5,12(sp)
8000e4a8:	bc379073          	csrw	0xbc3,a5
        break;
8000e4ac:	a011                	j	8000e4b0 <.L86>

8000e4ae <.L87>:
        break;
8000e4ae:	0001                	nop

8000e4b0 <.L86>:
}
8000e4b0:	0001                	nop
8000e4b2:	0141                	add	sp,sp,16
8000e4b4:	8082                	ret

Disassembly of section .text.uart_modem_config:

8000e4b6 <uart_modem_config>:
 *
 * @param [in] ptr UART base address
 * @param config Pointer to modem config struct
 */
static inline void uart_modem_config(UART_Type *ptr, uart_modem_config_t *config)
{
8000e4b6:	1141                	add	sp,sp,-16
8000e4b8:	c62a                	sw	a0,12(sp)
8000e4ba:	c42e                	sw	a1,8(sp)
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
8000e4bc:	47a2                	lw	a5,8(sp)
8000e4be:	0007c783          	lbu	a5,0(a5)
8000e4c2:	0796                	sll	a5,a5,0x5
8000e4c4:	0207f713          	and	a4,a5,32
        | UART_MCR_LOOP_SET(config->loop_back_en)
8000e4c8:	47a2                	lw	a5,8(sp)
8000e4ca:	0017c783          	lbu	a5,1(a5)
8000e4ce:	0792                	sll	a5,a5,0x4
8000e4d0:	8bc1                	and	a5,a5,16
8000e4d2:	8f5d                	or	a4,a4,a5
        | UART_MCR_RTS_SET(!config->set_rts_high);
8000e4d4:	47a2                	lw	a5,8(sp)
8000e4d6:	0027c783          	lbu	a5,2(a5)
8000e4da:	0017c793          	xor	a5,a5,1
8000e4de:	0ff7f793          	zext.b	a5,a5
8000e4e2:	0786                	sll	a5,a5,0x1
8000e4e4:	8b89                	and	a5,a5,2
8000e4e6:	8f5d                	or	a4,a4,a5
    ptr->MCR = UART_MCR_AFE_SET(config->auto_flow_ctrl_en)
8000e4e8:	47b2                	lw	a5,12(sp)
8000e4ea:	db98                	sw	a4,48(a5)
}
8000e4ec:	0001                	nop
8000e4ee:	0141                	add	sp,sp,16
8000e4f0:	8082                	ret

Disassembly of section .text.uart_calculate_baudrate:

8000e4f2 <uart_calculate_baudrate>:
{
8000e4f2:	7119                	add	sp,sp,-128
8000e4f4:	de86                	sw	ra,124(sp)
8000e4f6:	dca2                	sw	s0,120(sp)
8000e4f8:	daa6                	sw	s1,116(sp)
8000e4fa:	d8ca                	sw	s2,112(sp)
8000e4fc:	d6ce                	sw	s3,108(sp)
8000e4fe:	d4d2                	sw	s4,104(sp)
8000e500:	d2d6                	sw	s5,100(sp)
8000e502:	d0da                	sw	s6,96(sp)
8000e504:	cede                	sw	s7,92(sp)
8000e506:	cce2                	sw	s8,88(sp)
8000e508:	cae6                	sw	s9,84(sp)
8000e50a:	c8ea                	sw	s10,80(sp)
8000e50c:	c6ee                	sw	s11,76(sp)
8000e50e:	ce2a                	sw	a0,28(sp)
8000e510:	cc2e                	sw	a1,24(sp)
8000e512:	ca32                	sw	a2,20(sp)
8000e514:	c836                	sw	a3,16(sp)
    if ((div_out == NULL) || (!freq) || (!baudrate)
8000e516:	46d2                	lw	a3,20(sp)
8000e518:	ca85                	beqz	a3,8000e548 <.L4>
8000e51a:	46f2                	lw	a3,28(sp)
8000e51c:	c695                	beqz	a3,8000e548 <.L4>
8000e51e:	46e2                	lw	a3,24(sp)
8000e520:	c685                	beqz	a3,8000e548 <.L4>
            || (baudrate < HPM_UART_MINIMUM_BAUDRATE)
8000e522:	4662                	lw	a2,24(sp)
8000e524:	0c700693          	li	a3,199
8000e528:	02c6f063          	bgeu	a3,a2,8000e548 <.L4>
            || (freq / HPM_UART_BAUDRATE_DIV_MIN < baudrate * HPM_UART_OSC_MIN)
8000e52c:	46e2                	lw	a3,24(sp)
8000e52e:	068e                	sll	a3,a3,0x3
8000e530:	4672                	lw	a2,28(sp)
8000e532:	00d66b63          	bltu	a2,a3,8000e548 <.L4>
            || (freq / HPM_UART_BAUDRATE_DIV_MAX > (baudrate * HPM_UART_OSC_MAX))) {
8000e536:	4672                	lw	a2,28(sp)
8000e538:	66c1                	lui	a3,0x10
8000e53a:	16fd                	add	a3,a3,-1 # ffff <__FLASH_segment_used_size__+0x1b37>
8000e53c:	02d65633          	divu	a2,a2,a3
8000e540:	46e2                	lw	a3,24(sp)
8000e542:	0696                	sll	a3,a3,0x5
8000e544:	00c6f463          	bgeu	a3,a2,8000e54c <.L5>

8000e548 <.L4>:
        return 0;
8000e548:	4781                	li	a5,0
8000e54a:	ac21                	j	8000e762 <.L6>

8000e54c <.L5>:
    tmp = ((uint64_t)freq * HPM_UART_BAUDRATE_SCALE) / baudrate;
8000e54c:	46f2                	lw	a3,28(sp)
8000e54e:	8736                	mv	a4,a3
8000e550:	4781                	li	a5,0
8000e552:	3e800693          	li	a3,1000
8000e556:	02d78633          	mul	a2,a5,a3
8000e55a:	4681                	li	a3,0
8000e55c:	02d706b3          	mul	a3,a4,a3
8000e560:	9636                	add	a2,a2,a3
8000e562:	3e800693          	li	a3,1000
8000e566:	02d705b3          	mul	a1,a4,a3
8000e56a:	02d738b3          	mulhu	a7,a4,a3
8000e56e:	882e                	mv	a6,a1
8000e570:	011607b3          	add	a5,a2,a7
8000e574:	88be                	mv	a7,a5
8000e576:	47e2                	lw	a5,24(sp)
8000e578:	833e                	mv	t1,a5
8000e57a:	4381                	li	t2,0
8000e57c:	861a                	mv	a2,t1
8000e57e:	869e                	mv	a3,t2
8000e580:	8542                	mv	a0,a6
8000e582:	85c6                	mv	a1,a7
8000e584:	afbfd0ef          	jal	8000c07e <__udivdi3>
8000e588:	872a                	mv	a4,a0
8000e58a:	87ae                	mv	a5,a1
8000e58c:	d83a                	sw	a4,48(sp)
8000e58e:	da3e                	sw	a5,52(sp)
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
8000e590:	47a1                	li	a5,8
8000e592:	02f11f23          	sh	a5,62(sp)
8000e596:	aa7d                	j	8000e754 <.L7>

8000e598 <.L18>:
        delta = 0;
8000e598:	02011e23          	sh	zero,60(sp)
        div = (uint16_t)((tmp + osc * (HPM_UART_BAUDRATE_SCALE / 2)) / (osc * HPM_UART_BAUDRATE_SCALE));
8000e59c:	03e15703          	lhu	a4,62(sp)
8000e5a0:	1f400793          	li	a5,500
8000e5a4:	02f707b3          	mul	a5,a4,a5
8000e5a8:	843e                	mv	s0,a5
8000e5aa:	4481                	li	s1,0
8000e5ac:	5642                	lw	a2,48(sp)
8000e5ae:	56d2                	lw	a3,52(sp)
8000e5b0:	00c40733          	add	a4,s0,a2
8000e5b4:	85ba                	mv	a1,a4
8000e5b6:	0085b5b3          	sltu	a1,a1,s0
8000e5ba:	00d487b3          	add	a5,s1,a3
8000e5be:	00f586b3          	add	a3,a1,a5
8000e5c2:	87b6                	mv	a5,a3
8000e5c4:	853a                	mv	a0,a4
8000e5c6:	85be                	mv	a1,a5
8000e5c8:	03e15703          	lhu	a4,62(sp)
8000e5cc:	3e800793          	li	a5,1000
8000e5d0:	02f707b3          	mul	a5,a4,a5
8000e5d4:	8d3e                	mv	s10,a5
8000e5d6:	4d81                	li	s11,0
8000e5d8:	866a                	mv	a2,s10
8000e5da:	86ee                	mv	a3,s11
8000e5dc:	aa3fd0ef          	jal	8000c07e <__udivdi3>
8000e5e0:	872a                	mv	a4,a0
8000e5e2:	87ae                	mv	a5,a1
8000e5e4:	02e11723          	sh	a4,46(sp)
        if (div < HPM_UART_BAUDRATE_DIV_MIN) {
8000e5e8:	02e15783          	lhu	a5,46(sp)
8000e5ec:	14078c63          	beqz	a5,8000e744 <.L21>
        if ((div * osc * HPM_UART_BAUDRATE_SCALE) > tmp) {
8000e5f0:	02e15703          	lhu	a4,46(sp)
8000e5f4:	03e15783          	lhu	a5,62(sp)
8000e5f8:	02f707b3          	mul	a5,a4,a5
8000e5fc:	873e                	mv	a4,a5
8000e5fe:	3e800793          	li	a5,1000
8000e602:	02f707b3          	mul	a5,a4,a5
8000e606:	8b3e                	mv	s6,a5
8000e608:	4b81                	li	s7,0
8000e60a:	57d2                	lw	a5,52(sp)
8000e60c:	875e                	mv	a4,s7
8000e60e:	00e7ea63          	bltu	a5,a4,8000e622 <.L19>
8000e612:	57d2                	lw	a5,52(sp)
8000e614:	875e                	mv	a4,s7
8000e616:	04e79b63          	bne	a5,a4,8000e66c <.L10>
8000e61a:	57c2                	lw	a5,48(sp)
8000e61c:	875a                	mv	a4,s6
8000e61e:	04e7f763          	bgeu	a5,a4,8000e66c <.L10>

8000e622 <.L19>:
            delta = (uint16_t)(((div * osc * HPM_UART_BAUDRATE_SCALE) - tmp) / HPM_UART_BAUDRATE_SCALE);
8000e622:	02e15703          	lhu	a4,46(sp)
8000e626:	03e15783          	lhu	a5,62(sp)
8000e62a:	02f707b3          	mul	a5,a4,a5
8000e62e:	873e                	mv	a4,a5
8000e630:	3e800793          	li	a5,1000
8000e634:	02f707b3          	mul	a5,a4,a5
8000e638:	893e                	mv	s2,a5
8000e63a:	4981                	li	s3,0
8000e63c:	5642                	lw	a2,48(sp)
8000e63e:	56d2                	lw	a3,52(sp)
8000e640:	40c90733          	sub	a4,s2,a2
8000e644:	85ba                	mv	a1,a4
8000e646:	00b935b3          	sltu	a1,s2,a1
8000e64a:	40d987b3          	sub	a5,s3,a3
8000e64e:	40b786b3          	sub	a3,a5,a1
8000e652:	87b6                	mv	a5,a3
8000e654:	3e800613          	li	a2,1000
8000e658:	4681                	li	a3,0
8000e65a:	853a                	mv	a0,a4
8000e65c:	85be                	mv	a1,a5
8000e65e:	a21fd0ef          	jal	8000c07e <__udivdi3>
8000e662:	872a                	mv	a4,a0
8000e664:	87ae                	mv	a5,a1
8000e666:	02e11e23          	sh	a4,60(sp)
8000e66a:	a8a5                	j	8000e6e2 <.L12>

8000e66c <.L10>:
        } else if (div * osc < tmp) {
8000e66c:	02e15703          	lhu	a4,46(sp)
8000e670:	03e15783          	lhu	a5,62(sp)
8000e674:	02f707b3          	mul	a5,a4,a5
8000e678:	8c3e                	mv	s8,a5
8000e67a:	87fd                	sra	a5,a5,0x1f
8000e67c:	8cbe                	mv	s9,a5
8000e67e:	57d2                	lw	a5,52(sp)
8000e680:	8766                	mv	a4,s9
8000e682:	00f76a63          	bltu	a4,a5,8000e696 <.L20>
8000e686:	57d2                	lw	a5,52(sp)
8000e688:	8766                	mv	a4,s9
8000e68a:	04e79c63          	bne	a5,a4,8000e6e2 <.L12>
8000e68e:	57c2                	lw	a5,48(sp)
8000e690:	8762                	mv	a4,s8
8000e692:	04f77863          	bgeu	a4,a5,8000e6e2 <.L12>

8000e696 <.L20>:
            delta = (uint16_t)((tmp - (div * osc * HPM_UART_BAUDRATE_SCALE)) / HPM_UART_BAUDRATE_SCALE);
8000e696:	02e15703          	lhu	a4,46(sp)
8000e69a:	03e15783          	lhu	a5,62(sp)
8000e69e:	02f707b3          	mul	a5,a4,a5
8000e6a2:	873e                	mv	a4,a5
8000e6a4:	3e800793          	li	a5,1000
8000e6a8:	02f707b3          	mul	a5,a4,a5
8000e6ac:	8a3e                	mv	s4,a5
8000e6ae:	4a81                	li	s5,0
8000e6b0:	5742                	lw	a4,48(sp)
8000e6b2:	57d2                	lw	a5,52(sp)
8000e6b4:	41470633          	sub	a2,a4,s4
8000e6b8:	85b2                	mv	a1,a2
8000e6ba:	00b735b3          	sltu	a1,a4,a1
8000e6be:	415786b3          	sub	a3,a5,s5
8000e6c2:	40b687b3          	sub	a5,a3,a1
8000e6c6:	86be                	mv	a3,a5
8000e6c8:	8732                	mv	a4,a2
8000e6ca:	87b6                	mv	a5,a3
8000e6cc:	3e800613          	li	a2,1000
8000e6d0:	4681                	li	a3,0
8000e6d2:	853a                	mv	a0,a4
8000e6d4:	85be                	mv	a1,a5
8000e6d6:	9a9fd0ef          	jal	8000c07e <__udivdi3>
8000e6da:	872a                	mv	a4,a0
8000e6dc:	87ae                	mv	a5,a1
8000e6de:	02e11e23          	sh	a4,60(sp)

8000e6e2 <.L12>:
        if (delta && (((delta * 100 * HPM_UART_BAUDRATE_SCALE) / tmp) > HPM_UART_BAUDRATE_TOLERANCE)) {
8000e6e2:	03c15783          	lhu	a5,60(sp)
8000e6e6:	cb8d                	beqz	a5,8000e718 <.L14>
8000e6e8:	03c15703          	lhu	a4,60(sp)
8000e6ec:	67e1                	lui	a5,0x18
8000e6ee:	6a078793          	add	a5,a5,1696 # 186a0 <__FLASH_segment_used_size__+0xa1d8>
8000e6f2:	02f707b3          	mul	a5,a4,a5
8000e6f6:	c43e                	sw	a5,8(sp)
8000e6f8:	c602                	sw	zero,12(sp)
8000e6fa:	5642                	lw	a2,48(sp)
8000e6fc:	56d2                	lw	a3,52(sp)
8000e6fe:	4522                	lw	a0,8(sp)
8000e700:	45b2                	lw	a1,12(sp)
8000e702:	97dfd0ef          	jal	8000c07e <__udivdi3>
8000e706:	872a                	mv	a4,a0
8000e708:	87ae                	mv	a5,a1
8000e70a:	86be                	mv	a3,a5
8000e70c:	ee95                	bnez	a3,8000e748 <.L22>
8000e70e:	86be                	mv	a3,a5
8000e710:	e681                	bnez	a3,8000e718 <.L14>
8000e712:	478d                	li	a5,3
8000e714:	02e7ea63          	bltu	a5,a4,8000e748 <.L22>

8000e718 <.L14>:
            *div_out = div;
8000e718:	47d2                	lw	a5,20(sp)
8000e71a:	02e15703          	lhu	a4,46(sp)
8000e71e:	00e79023          	sh	a4,0(a5)
            *osc_out = (osc == HPM_UART_OSC_MAX) ? 0 : osc; /* osc == 0 in bitfield, oversample rate is 32 */
8000e722:	03e15703          	lhu	a4,62(sp)
8000e726:	02000793          	li	a5,32
8000e72a:	00f70763          	beq	a4,a5,8000e738 <.L16>
8000e72e:	03e15783          	lhu	a5,62(sp)
8000e732:	0ff7f793          	zext.b	a5,a5
8000e736:	a011                	j	8000e73a <.L17>

8000e738 <.L16>:
8000e738:	4781                	li	a5,0

8000e73a <.L17>:
8000e73a:	4742                	lw	a4,16(sp)
8000e73c:	00f70023          	sb	a5,0(a4)
            return true;
8000e740:	4785                	li	a5,1
8000e742:	a005                	j	8000e762 <.L6>

8000e744 <.L21>:
            continue;
8000e744:	0001                	nop
8000e746:	a011                	j	8000e74a <.L9>

8000e748 <.L22>:
            continue;
8000e748:	0001                	nop

8000e74a <.L9>:
    for (osc = HPM_UART_OSC_MIN; osc <= UART_SOC_OVERSAMPLE_MAX; osc += 2) {
8000e74a:	03e15783          	lhu	a5,62(sp)
8000e74e:	0789                	add	a5,a5,2
8000e750:	02f11f23          	sh	a5,62(sp)

8000e754 <.L7>:
8000e754:	03e15703          	lhu	a4,62(sp)
8000e758:	02000793          	li	a5,32
8000e75c:	e2e7fee3          	bgeu	a5,a4,8000e598 <.L18>
    return false;
8000e760:	4781                	li	a5,0

8000e762 <.L6>:
}
8000e762:	853e                	mv	a0,a5
8000e764:	50f6                	lw	ra,124(sp)
8000e766:	5466                	lw	s0,120(sp)
8000e768:	54d6                	lw	s1,116(sp)
8000e76a:	5946                	lw	s2,112(sp)
8000e76c:	59b6                	lw	s3,108(sp)
8000e76e:	5a26                	lw	s4,104(sp)
8000e770:	5a96                	lw	s5,100(sp)
8000e772:	5b06                	lw	s6,96(sp)
8000e774:	4bf6                	lw	s7,92(sp)
8000e776:	4c66                	lw	s8,88(sp)
8000e778:	4cd6                	lw	s9,84(sp)
8000e77a:	4d46                	lw	s10,80(sp)
8000e77c:	4db6                	lw	s11,76(sp)
8000e77e:	6109                	add	sp,sp,128
8000e780:	8082                	ret

Disassembly of section .text.uart_init:

8000e782 <uart_init>:
{
8000e782:	7179                	add	sp,sp,-48
8000e784:	d606                	sw	ra,44(sp)
8000e786:	c62a                	sw	a0,12(sp)
8000e788:	c42e                	sw	a1,8(sp)
    ptr->IER = 0;
8000e78a:	47b2                	lw	a5,12(sp)
8000e78c:	0207a223          	sw	zero,36(a5)
    ptr->LCR |= UART_LCR_DLAB_MASK;
8000e790:	47b2                	lw	a5,12(sp)
8000e792:	57dc                	lw	a5,44(a5)
8000e794:	0807e713          	or	a4,a5,128
8000e798:	47b2                	lw	a5,12(sp)
8000e79a:	d7d8                	sw	a4,44(a5)
    if (!uart_calculate_baudrate(config->src_freq_in_hz, config->baudrate, &div, &osc)) {
8000e79c:	47a2                	lw	a5,8(sp)
8000e79e:	4398                	lw	a4,0(a5)
8000e7a0:	47a2                	lw	a5,8(sp)
8000e7a2:	43dc                	lw	a5,4(a5)
8000e7a4:	01b10693          	add	a3,sp,27
8000e7a8:	0830                	add	a2,sp,24
8000e7aa:	85be                	mv	a1,a5
8000e7ac:	853a                	mv	a0,a4
8000e7ae:	3391                	jal	8000e4f2 <uart_calculate_baudrate>
8000e7b0:	87aa                	mv	a5,a0
8000e7b2:	0017c793          	xor	a5,a5,1
8000e7b6:	0ff7f793          	zext.b	a5,a5
8000e7ba:	c781                	beqz	a5,8000e7c2 <.L24>
        return status_uart_no_suitable_baudrate_parameter_found;
8000e7bc:	3e900793          	li	a5,1001
8000e7c0:	aa2d                	j	8000e8fa <.L40>

8000e7c2 <.L24>:
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
8000e7c2:	47b2                	lw	a5,12(sp)
8000e7c4:	4bdc                	lw	a5,20(a5)
8000e7c6:	fe07f713          	and	a4,a5,-32
        | UART_OSCR_OSC_SET(osc);
8000e7ca:	01b14783          	lbu	a5,27(sp)
8000e7ce:	8bfd                	and	a5,a5,31
8000e7d0:	8f5d                	or	a4,a4,a5
    ptr->OSCR = (ptr->OSCR & ~UART_OSCR_OSC_MASK)
8000e7d2:	47b2                	lw	a5,12(sp)
8000e7d4:	cbd8                	sw	a4,20(a5)
    ptr->DLL = UART_DLL_DLL_SET(div >> 0);
8000e7d6:	01815783          	lhu	a5,24(sp)
8000e7da:	0ff7f713          	zext.b	a4,a5
8000e7de:	47b2                	lw	a5,12(sp)
8000e7e0:	d398                	sw	a4,32(a5)
    ptr->DLM = UART_DLM_DLM_SET(div >> 8);
8000e7e2:	01815783          	lhu	a5,24(sp)
8000e7e6:	83a1                	srl	a5,a5,0x8
8000e7e8:	07c2                	sll	a5,a5,0x10
8000e7ea:	83c1                	srl	a5,a5,0x10
8000e7ec:	0ff7f713          	zext.b	a4,a5
8000e7f0:	47b2                	lw	a5,12(sp)
8000e7f2:	d3d8                	sw	a4,36(a5)
    tmp = ptr->LCR & (~UART_LCR_DLAB_MASK);
8000e7f4:	47b2                	lw	a5,12(sp)
8000e7f6:	57dc                	lw	a5,44(a5)
8000e7f8:	f7f7f793          	and	a5,a5,-129
8000e7fc:	ce3e                	sw	a5,28(sp)
    tmp &= ~(UART_LCR_SPS_MASK | UART_LCR_EPS_MASK | UART_LCR_PEN_MASK);
8000e7fe:	47f2                	lw	a5,28(sp)
8000e800:	fc77f793          	and	a5,a5,-57
8000e804:	ce3e                	sw	a5,28(sp)
    switch (config->parity) {
8000e806:	47a2                	lw	a5,8(sp)
8000e808:	00a7c783          	lbu	a5,10(a5)
8000e80c:	4711                	li	a4,4
8000e80e:	02f76f63          	bltu	a4,a5,8000e84c <.L26>
8000e812:	00279713          	sll	a4,a5,0x2
8000e816:	800037b7          	lui	a5,0x80003
8000e81a:	25478793          	add	a5,a5,596 # 80003254 <.L28>
8000e81e:	97ba                	add	a5,a5,a4
8000e820:	439c                	lw	a5,0(a5)
8000e822:	8782                	jr	a5

8000e824 <.L31>:
        tmp |= UART_LCR_PEN_MASK;
8000e824:	47f2                	lw	a5,28(sp)
8000e826:	0087e793          	or	a5,a5,8
8000e82a:	ce3e                	sw	a5,28(sp)
        break;
8000e82c:	a01d                	j	8000e852 <.L33>

8000e82e <.L30>:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_EPS_MASK;
8000e82e:	47f2                	lw	a5,28(sp)
8000e830:	0187e793          	or	a5,a5,24
8000e834:	ce3e                	sw	a5,28(sp)
        break;
8000e836:	a831                	j	8000e852 <.L33>

8000e838 <.L29>:
        tmp |= UART_LCR_PEN_MASK | UART_LCR_SPS_MASK;
8000e838:	47f2                	lw	a5,28(sp)
8000e83a:	0287e793          	or	a5,a5,40
8000e83e:	ce3e                	sw	a5,28(sp)
        break;
8000e840:	a809                	j	8000e852 <.L33>

8000e842 <.L27>:
        tmp |= UART_LCR_EPS_MASK | UART_LCR_PEN_MASK
8000e842:	47f2                	lw	a5,28(sp)
8000e844:	0387e793          	or	a5,a5,56
8000e848:	ce3e                	sw	a5,28(sp)
        break;
8000e84a:	a021                	j	8000e852 <.L33>

8000e84c <.L26>:
        return status_invalid_argument;
8000e84c:	4789                	li	a5,2
8000e84e:	a075                	j	8000e8fa <.L40>

8000e850 <.L41>:
        break;
8000e850:	0001                	nop

8000e852 <.L33>:
    tmp &= ~(UART_LCR_STB_MASK | UART_LCR_WLS_MASK);
8000e852:	47f2                	lw	a5,28(sp)
8000e854:	9be1                	and	a5,a5,-8
8000e856:	ce3e                	sw	a5,28(sp)
    switch (config->num_of_stop_bits) {
8000e858:	47a2                	lw	a5,8(sp)
8000e85a:	0087c783          	lbu	a5,8(a5)
8000e85e:	4709                	li	a4,2
8000e860:	00e78e63          	beq	a5,a4,8000e87c <.L34>
8000e864:	4709                	li	a4,2
8000e866:	02f74663          	blt	a4,a5,8000e892 <.L35>
8000e86a:	c795                	beqz	a5,8000e896 <.L42>
8000e86c:	4705                	li	a4,1
8000e86e:	02e79263          	bne	a5,a4,8000e892 <.L35>
        tmp |= UART_LCR_STB_MASK;
8000e872:	47f2                	lw	a5,28(sp)
8000e874:	0047e793          	or	a5,a5,4
8000e878:	ce3e                	sw	a5,28(sp)
        break;
8000e87a:	a839                	j	8000e898 <.L38>

8000e87c <.L34>:
        if (config->word_length < word_length_6_bits) {
8000e87c:	47a2                	lw	a5,8(sp)
8000e87e:	0097c783          	lbu	a5,9(a5)
8000e882:	e399                	bnez	a5,8000e888 <.L39>
            return status_invalid_argument;
8000e884:	4789                	li	a5,2
8000e886:	a895                	j	8000e8fa <.L40>

8000e888 <.L39>:
        tmp |= UART_LCR_STB_MASK;
8000e888:	47f2                	lw	a5,28(sp)
8000e88a:	0047e793          	or	a5,a5,4
8000e88e:	ce3e                	sw	a5,28(sp)
        break;
8000e890:	a021                	j	8000e898 <.L38>

8000e892 <.L35>:
        return status_invalid_argument;
8000e892:	4789                	li	a5,2
8000e894:	a09d                	j	8000e8fa <.L40>

8000e896 <.L42>:
        break;
8000e896:	0001                	nop

8000e898 <.L38>:
    ptr->LCR = tmp | UART_LCR_WLS_SET(config->word_length);
8000e898:	47a2                	lw	a5,8(sp)
8000e89a:	0097c783          	lbu	a5,9(a5)
8000e89e:	0037f713          	and	a4,a5,3
8000e8a2:	47f2                	lw	a5,28(sp)
8000e8a4:	8f5d                	or	a4,a4,a5
8000e8a6:	47b2                	lw	a5,12(sp)
8000e8a8:	d7d8                	sw	a4,44(a5)
    ptr->FCR = UART_FCR_TFIFORST_MASK | UART_FCR_RFIFORST_MASK;
8000e8aa:	47b2                	lw	a5,12(sp)
8000e8ac:	4719                	li	a4,6
8000e8ae:	d798                	sw	a4,40(a5)
    tmp = UART_FCR_FIFOE_SET(config->fifo_enable)
8000e8b0:	47a2                	lw	a5,8(sp)
8000e8b2:	00e7c783          	lbu	a5,14(a5)
8000e8b6:	873e                	mv	a4,a5
        | UART_FCR_TFIFOT_SET(config->tx_fifo_level)
8000e8b8:	47a2                	lw	a5,8(sp)
8000e8ba:	00b7c783          	lbu	a5,11(a5)
8000e8be:	0792                	sll	a5,a5,0x4
8000e8c0:	0307f793          	and	a5,a5,48
8000e8c4:	8f5d                	or	a4,a4,a5
        | UART_FCR_RFIFOT_SET(config->rx_fifo_level)
8000e8c6:	47a2                	lw	a5,8(sp)
8000e8c8:	00c7c783          	lbu	a5,12(a5)
8000e8cc:	079a                	sll	a5,a5,0x6
8000e8ce:	0ff7f793          	zext.b	a5,a5
8000e8d2:	8f5d                	or	a4,a4,a5
        | UART_FCR_DMAE_SET(config->dma_enable);
8000e8d4:	47a2                	lw	a5,8(sp)
8000e8d6:	00d7c783          	lbu	a5,13(a5)
8000e8da:	078e                	sll	a5,a5,0x3
8000e8dc:	8ba1                	and	a5,a5,8
    tmp = UART_FCR_FIFOE_SET(config->fifo_enable)
8000e8de:	8fd9                	or	a5,a5,a4
8000e8e0:	ce3e                	sw	a5,28(sp)
    ptr->FCR = tmp;
8000e8e2:	47b2                	lw	a5,12(sp)
8000e8e4:	4772                	lw	a4,28(sp)
8000e8e6:	d798                	sw	a4,40(a5)
    ptr->GPR = tmp;
8000e8e8:	47b2                	lw	a5,12(sp)
8000e8ea:	4772                	lw	a4,28(sp)
8000e8ec:	dfd8                	sw	a4,60(a5)
    uart_modem_config(ptr, &config->modem_config);
8000e8ee:	47a2                	lw	a5,8(sp)
8000e8f0:	07bd                	add	a5,a5,15
8000e8f2:	85be                	mv	a1,a5
8000e8f4:	4532                	lw	a0,12(sp)
8000e8f6:	36c1                	jal	8000e4b6 <uart_modem_config>
    return status_success;
8000e8f8:	4781                	li	a5,0

8000e8fa <.L40>:
}
8000e8fa:	853e                	mv	a0,a5
8000e8fc:	50b2                	lw	ra,44(sp)
8000e8fe:	6145                	add	sp,sp,48
8000e900:	8082                	ret

Disassembly of section .text.uart_flush:

8000e902 <uart_flush>:

hpm_stat_t uart_flush(UART_Type *ptr)
{
8000e902:	1101                	add	sp,sp,-32
8000e904:	c62a                	sw	a0,12(sp)
    uint32_t retry = 0;
8000e906:	ce02                	sw	zero,28(sp)

    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
8000e908:	a811                	j	8000e91c <.L56>

8000e90a <.L59>:
        if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000e90a:	4772                	lw	a4,28(sp)
8000e90c:	6785                	lui	a5,0x1
8000e90e:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
8000e912:	00e7eb63          	bltu	a5,a4,8000e928 <.L62>
            break;
        }
        retry++;
8000e916:	47f2                	lw	a5,28(sp)
8000e918:	0785                	add	a5,a5,1
8000e91a:	ce3e                	sw	a5,28(sp)

8000e91c <.L56>:
    while (!(ptr->LSR & UART_LSR_TEMT_MASK)) {
8000e91c:	47b2                	lw	a5,12(sp)
8000e91e:	5bdc                	lw	a5,52(a5)
8000e920:	0407f793          	and	a5,a5,64
8000e924:	d3fd                	beqz	a5,8000e90a <.L59>
8000e926:	a011                	j	8000e92a <.L58>

8000e928 <.L62>:
            break;
8000e928:	0001                	nop

8000e92a <.L58>:
    }
    if (retry > HPM_UART_DRV_RETRY_COUNT) {
8000e92a:	4772                	lw	a4,28(sp)
8000e92c:	6785                	lui	a5,0x1
8000e92e:	38878793          	add	a5,a5,904 # 1388 <__NOR_CFG_OPTION_segment_size__+0x788>
8000e932:	00e7f463          	bgeu	a5,a4,8000e93a <.L60>
        return status_timeout;
8000e936:	478d                	li	a5,3
8000e938:	a011                	j	8000e93c <.L61>

8000e93a <.L60>:
    }

    return status_success;
8000e93a:	4781                	li	a5,0

8000e93c <.L61>:
}
8000e93c:	853e                	mv	a0,a5
8000e93e:	6105                	add	sp,sp,32
8000e940:	8082                	ret

Disassembly of section .text.core_local_mem_to_sys_address:

8000e942 <core_local_mem_to_sys_address>:
#define HPM_CORE0 (0U)
#define HPM_CORE1 (1U)

/* map core local memory(DLM/ILM) to system address */
static inline uint32_t core_local_mem_to_sys_address(uint8_t core_id, uint32_t addr)
{
8000e942:	1101                	add	sp,sp,-32
8000e944:	87aa                	mv	a5,a0
8000e946:	c42e                	sw	a1,8(sp)
8000e948:	00f107a3          	sb	a5,15(sp)
    uint32_t sys_addr;
    if (ADDRESS_IN_ILM(addr)) {
8000e94c:	4722                	lw	a4,8(sp)
8000e94e:	000407b7          	lui	a5,0x40
8000e952:	00f77863          	bgeu	a4,a5,8000e962 <.L2>
        sys_addr = ILM_TO_SYSTEM(addr);
8000e956:	4722                	lw	a4,8(sp)
8000e958:	010007b7          	lui	a5,0x1000
8000e95c:	97ba                	add	a5,a5,a4
8000e95e:	ce3e                	sw	a5,28(sp)
8000e960:	a01d                	j	8000e986 <.L3>

8000e962 <.L2>:
    } else if (ADDRESS_IN_DLM(addr)) {
8000e962:	4722                	lw	a4,8(sp)
8000e964:	000807b7          	lui	a5,0x80
8000e968:	00f76d63          	bltu	a4,a5,8000e982 <.L4>
8000e96c:	4722                	lw	a4,8(sp)
8000e96e:	000c07b7          	lui	a5,0xc0
8000e972:	00f77863          	bgeu	a4,a5,8000e982 <.L4>
        sys_addr = DLM_TO_SYSTEM(addr);
8000e976:	4722                	lw	a4,8(sp)
8000e978:	00fc07b7          	lui	a5,0xfc0
8000e97c:	97ba                	add	a5,a5,a4
8000e97e:	ce3e                	sw	a5,28(sp)
8000e980:	a019                	j	8000e986 <.L3>

8000e982 <.L4>:
    } else {
        return addr;
8000e982:	47a2                	lw	a5,8(sp)
8000e984:	a821                	j	8000e99c <.L5>

8000e986 <.L3>:
    }
    if (core_id == HPM_CORE1) {
8000e986:	00f14703          	lbu	a4,15(sp)
8000e98a:	4785                	li	a5,1
8000e98c:	00f71763          	bne	a4,a5,8000e99a <.L6>
        sys_addr += CORE1_ILM_SYSTEM_BASE - CORE0_ILM_SYSTEM_BASE;
8000e990:	4772                	lw	a4,28(sp)
8000e992:	001807b7          	lui	a5,0x180
8000e996:	97ba                	add	a5,a5,a4
8000e998:	ce3e                	sw	a5,28(sp)

8000e99a <.L6>:
    }

    return sys_addr;
8000e99a:	47f2                	lw	a5,28(sp)

8000e99c <.L5>:
}
8000e99c:	853e                	mv	a0,a5
8000e99e:	6105                	add	sp,sp,32
8000e9a0:	8082                	ret

Disassembly of section .text.rom_sdp_memcpy:

8000e9a2 <rom_sdp_memcpy>:
 * @param [in] src Source address for memcpy
 * @param [in] length Size of data for memcpy operation
 * @return API execution status
 */
static inline hpm_stat_t rom_sdp_memcpy(sdp_dma_ctx_t *dma_ctx, void *dst, const void *src, uint32_t length)
{
8000e9a2:	1101                	add	sp,sp,-32
8000e9a4:	ce06                	sw	ra,28(sp)
8000e9a6:	c62a                	sw	a0,12(sp)
8000e9a8:	c42e                	sw	a1,8(sp)
8000e9aa:	c232                	sw	a2,4(sp)
8000e9ac:	c036                	sw	a3,0(sp)
    return ROM_API_TABLE_ROOT->sdp_driver_if->memcpy(dma_ctx, dst, src, length);
8000e9ae:	200207b7          	lui	a5,0x20020
8000e9b2:	f0078793          	add	a5,a5,-256 # 2001ff00 <__SHARE_RAM_segment_end__+0x1ee9ff00>
8000e9b6:	4fdc                	lw	a5,28(a5)
8000e9b8:	53dc                	lw	a5,36(a5)
8000e9ba:	4682                	lw	a3,0(sp)
8000e9bc:	4612                	lw	a2,4(sp)
8000e9be:	45a2                	lw	a1,8(sp)
8000e9c0:	4532                	lw	a0,12(sp)
8000e9c2:	9782                	jalr	a5
8000e9c4:	87aa                	mv	a5,a0
}
8000e9c6:	853e                	mv	a0,a5
8000e9c8:	40f2                	lw	ra,28(sp)
8000e9ca:	6105                	add	sp,sp,32
8000e9cc:	8082                	ret

Disassembly of section .text.mbx_disable_intr:

8000e9ce <mbx_disable_intr>:
{
8000e9ce:	1141                	add	sp,sp,-16
8000e9d0:	c62a                	sw	a0,12(sp)
8000e9d2:	c42e                	sw	a1,8(sp)
    ptr->CR &= ~mask;
8000e9d4:	47b2                	lw	a5,12(sp)
8000e9d6:	4398                	lw	a4,0(a5)
8000e9d8:	47a2                	lw	a5,8(sp)
8000e9da:	fff7c793          	not	a5,a5
8000e9de:	8f7d                	and	a4,a4,a5
8000e9e0:	47b2                	lw	a5,12(sp)
8000e9e2:	c398                	sw	a4,0(a5)
}
8000e9e4:	0001                	nop
8000e9e6:	0141                	add	sp,sp,16
8000e9e8:	8082                	ret

Disassembly of section .text.mbx_empty_txfifo:

8000e9ea <mbx_empty_txfifo>:
{
8000e9ea:	1141                	add	sp,sp,-16
8000e9ec:	c62a                	sw	a0,12(sp)
    ptr->CR |= MBX_CR_TXRESET_MASK;
8000e9ee:	47b2                	lw	a5,12(sp)
8000e9f0:	4398                	lw	a4,0(a5)
8000e9f2:	800007b7          	lui	a5,0x80000
8000e9f6:	8f5d                	or	a4,a4,a5
8000e9f8:	47b2                	lw	a5,12(sp)
8000e9fa:	c398                	sw	a4,0(a5)
}
8000e9fc:	0001                	nop
8000e9fe:	0141                	add	sp,sp,16
8000ea00:	8082                	ret

Disassembly of section .text.share_buffer_item_init:

8000ea02 <share_buffer_item_init>:




void share_buffer_item_init(share_buffer_item_t* item, can_receive_buf_t* data, uint16_t size)
{
8000ea02:	1141                	add	sp,sp,-16
8000ea04:	c62a                	sw	a0,12(sp)
8000ea06:	c42e                	sw	a1,8(sp)
8000ea08:	87b2                	mv	a5,a2
8000ea0a:	00f11323          	sh	a5,6(sp)
    item->data = data;
8000ea0e:	47b2                	lw	a5,12(sp)
8000ea10:	4722                	lw	a4,8(sp)
8000ea12:	c398                	sw	a4,0(a5)
    item->status = SHARE_BUFFER_STATUS_IDLE;
8000ea14:	47b2                	lw	a5,12(sp)
8000ea16:	00078223          	sb	zero,4(a5) # 80000004 <__NONCACHEABLE_RAM_segment_end__+0x3f000004>
    item->current_index = 0;
8000ea1a:	47b2                	lw	a5,12(sp)
8000ea1c:	000782a3          	sb	zero,5(a5)
    item->max_index = size - 1;
8000ea20:	00615783          	lhu	a5,6(sp)
8000ea24:	0ff7f793          	zext.b	a5,a5
8000ea28:	17fd                	add	a5,a5,-1
8000ea2a:	0ff7f713          	zext.b	a4,a5
8000ea2e:	47b2                	lw	a5,12(sp)
8000ea30:	00e78323          	sb	a4,6(a5)
}
8000ea34:	0001                	nop
8000ea36:	0141                	add	sp,sp,16
8000ea38:	8082                	ret

Disassembly of section .text.share_buffer_init:

8000ea3a <share_buffer_init>:

void share_buffer_init(share_buffer_t* block, share_buffer_item_t* items, uint16_t size)
{
8000ea3a:	1101                	add	sp,sp,-32
8000ea3c:	c62a                	sw	a0,12(sp)
8000ea3e:	c42e                	sw	a1,8(sp)
8000ea40:	87b2                	mv	a5,a2
8000ea42:	00f11323          	sh	a5,6(sp)
    block->items = items;
8000ea46:	47b2                	lw	a5,12(sp)
8000ea48:	4722                	lw	a4,8(sp)
8000ea4a:	c398                	sw	a4,0(a5)
    block->size = size;
8000ea4c:	47b2                	lw	a5,12(sp)
8000ea4e:	00615703          	lhu	a4,6(sp)
8000ea52:	00e79223          	sh	a4,4(a5)
    block->wait = 0;
8000ea56:	47b2                	lw	a5,12(sp)
8000ea58:	00079323          	sh	zero,6(a5)
    block->max_wait = block->size - 1;
8000ea5c:	47b2                	lw	a5,12(sp)
8000ea5e:	0047d783          	lhu	a5,4(a5)
8000ea62:	17fd                	add	a5,a5,-1
8000ea64:	01079713          	sll	a4,a5,0x10
8000ea68:	8341                	srl	a4,a4,0x10
8000ea6a:	47b2                	lw	a5,12(sp)
8000ea6c:	00e79423          	sh	a4,8(a5)
    block->write_head = &items[0];
8000ea70:	47b2                	lw	a5,12(sp)
8000ea72:	4722                	lw	a4,8(sp)
8000ea74:	c7d8                	sw	a4,12(a5)
    block->consume_head = &items[0];
8000ea76:	47b2                	lw	a5,12(sp)
8000ea78:	4722                	lw	a4,8(sp)
8000ea7a:	cb98                	sw	a4,16(a5)

8000ea7c <.LBB2>:
    for(uint16_t i = 0; i < size - 1; i++)/*环形链表初始化*/
8000ea7c:	00011f23          	sh	zero,30(sp)
8000ea80:	a81d                	j	8000eab6 <.L3>

8000ea82 <.L4>:
    {
        items[i].next = &items[i + 1];
8000ea82:	01e15783          	lhu	a5,30(sp)
8000ea86:	00178713          	add	a4,a5,1
8000ea8a:	87ba                	mv	a5,a4
8000ea8c:	0786                	sll	a5,a5,0x1
8000ea8e:	97ba                	add	a5,a5,a4
8000ea90:	078a                	sll	a5,a5,0x2
8000ea92:	86be                	mv	a3,a5
8000ea94:	01e15703          	lhu	a4,30(sp)
8000ea98:	87ba                	mv	a5,a4
8000ea9a:	0786                	sll	a5,a5,0x1
8000ea9c:	97ba                	add	a5,a5,a4
8000ea9e:	078a                	sll	a5,a5,0x2
8000eaa0:	873e                	mv	a4,a5
8000eaa2:	47a2                	lw	a5,8(sp)
8000eaa4:	97ba                	add	a5,a5,a4
8000eaa6:	4722                	lw	a4,8(sp)
8000eaa8:	9736                	add	a4,a4,a3
8000eaaa:	c798                	sw	a4,8(a5)
    for(uint16_t i = 0; i < size - 1; i++)/*环形链表初始化*/
8000eaac:	01e15783          	lhu	a5,30(sp)
8000eab0:	0785                	add	a5,a5,1
8000eab2:	00f11f23          	sh	a5,30(sp)

8000eab6 <.L3>:
8000eab6:	01e15703          	lhu	a4,30(sp)
8000eaba:	00615783          	lhu	a5,6(sp)
8000eabe:	17fd                	add	a5,a5,-1
8000eac0:	fcf741e3          	blt	a4,a5,8000ea82 <.L4>

8000eac4 <.LBE2>:
    }
    items[size - 1].next = &items[0];
8000eac4:	00615703          	lhu	a4,6(sp)
8000eac8:	87ba                	mv	a5,a4
8000eaca:	0786                	sll	a5,a5,0x1
8000eacc:	97ba                	add	a5,a5,a4
8000eace:	078a                	sll	a5,a5,0x2
8000ead0:	17d1                	add	a5,a5,-12
8000ead2:	4722                	lw	a4,8(sp)
8000ead4:	97ba                	add	a5,a5,a4
8000ead6:	4722                	lw	a4,8(sp)
8000ead8:	c798                	sw	a4,8(a5)
    block->is_full = false;
8000eada:	47b2                	lw	a5,12(sp)
8000eadc:	00078a23          	sb	zero,20(a5)
}
8000eae0:	0001                	nop
8000eae2:	6105                	add	sp,sp,32
8000eae4:	8082                	ret

Disassembly of section .text.can_get_tx_rx_flags:

8000eae6 <can_get_tx_rx_flags>:
{
8000eae6:	1141                	add	sp,sp,-16
8000eae8:	c62a                	sw	a0,12(sp)
    return base->RTIF;
8000eaea:	47b2                	lw	a5,12(sp)
8000eaec:	0a57c783          	lbu	a5,165(a5)
8000eaf0:	0ff7f793          	zext.b	a5,a5
}
8000eaf4:	853e                	mv	a0,a5
8000eaf6:	0141                	add	sp,sp,16
8000eaf8:	8082                	ret

Disassembly of section .text.can_get_error_interrupt_flags:

8000eafa <can_get_error_interrupt_flags>:
{
8000eafa:	1141                	add	sp,sp,-16
8000eafc:	c62a                	sw	a0,12(sp)
    return (base->ERRINT & (uint8_t) ~(CAN_ERRINT_EPIE_MASK | CAN_ERRINT_ALIE_MASK | CAN_ERRINT_BEIE_MASK));
8000eafe:	47b2                	lw	a5,12(sp)
8000eb00:	0a67c783          	lbu	a5,166(a5)
8000eb04:	0ff7f793          	zext.b	a5,a5
8000eb08:	fd57f793          	and	a5,a5,-43
8000eb0c:	0ff7f793          	zext.b	a5,a5
}
8000eb10:	853e                	mv	a0,a5
8000eb12:	0141                	add	sp,sp,16
8000eb14:	8082                	ret

Disassembly of section .text.mbx_enable_intr:

8000eb16 <mbx_enable_intr>:
{
8000eb16:	1141                	add	sp,sp,-16
8000eb18:	c62a                	sw	a0,12(sp)
8000eb1a:	c42e                	sw	a1,8(sp)
    ptr->CR |= mask;
8000eb1c:	47b2                	lw	a5,12(sp)
8000eb1e:	4398                	lw	a4,0(a5)
8000eb20:	47a2                	lw	a5,8(sp)
8000eb22:	8f5d                	or	a4,a4,a5
8000eb24:	47b2                	lw	a5,12(sp)
8000eb26:	c398                	sw	a4,0(a5)
}
8000eb28:	0001                	nop
8000eb2a:	0141                	add	sp,sp,16
8000eb2c:	8082                	ret

Disassembly of section .text.mbx_send_message:

8000eb2e <mbx_send_message>:
 * @param[in] msg Message data in 32 bits
 *
 * @return status_success if everything is okay
 */
static inline hpm_stat_t mbx_send_message(MBX_Type *ptr, uint32_t msg)
{
8000eb2e:	1141                	add	sp,sp,-16
8000eb30:	c62a                	sw	a0,12(sp)
8000eb32:	c42e                	sw	a1,8(sp)
    if (ptr->SR & MBX_SR_TWME_MASK) {
8000eb34:	47b2                	lw	a5,12(sp)
8000eb36:	43dc                	lw	a5,4(a5)
8000eb38:	8b89                	and	a5,a5,2
8000eb3a:	c791                	beqz	a5,8000eb46 <.L9>
        ptr->TXREG = msg;
8000eb3c:	47b2                	lw	a5,12(sp)
8000eb3e:	4722                	lw	a4,8(sp)
8000eb40:	c798                	sw	a4,8(a5)
        return status_success;
8000eb42:	4781                	li	a5,0
8000eb44:	a021                	j	8000eb4c <.L10>

8000eb46 <.L9>:
    }
    return status_mbx_not_available;
8000eb46:	678d                	lui	a5,0x3
8000eb48:	6b278793          	add	a5,a5,1714 # 36b2 <__APB_SRAM_segment_size__+0x16b2>

8000eb4c <.L10>:
}
8000eb4c:	853e                	mv	a0,a5
8000eb4e:	0141                	add	sp,sp,16
8000eb50:	8082                	ret

Disassembly of section .text.ram_buffer_block_init:

8000eb52 <ram_buffer_block_init>:
{
8000eb52:	1101                	add	sp,sp,-32
8000eb54:	ce06                	sw	ra,28(sp)

8000eb56 <.LBB16>:
    for(int i = 0; i < RAM_BUFFER_BLOCK_SIZE; i++)
8000eb56:	c602                	sw	zero,12(sp)
8000eb58:	a83d                	j	8000eb96 <.L12>

8000eb5a <.L13>:
        share_buffer_item_init(&ram_buffer_block_items[i], &ram_buffer[i][0], MAX_CAN_BUFFER_SIZE);
8000eb5a:	4732                	lw	a4,12(sp)
8000eb5c:	87ba                	mv	a5,a4
8000eb5e:	0786                	sll	a5,a5,0x1
8000eb60:	97ba                	add	a5,a5,a4
8000eb62:	078a                	sll	a5,a5,0x2
8000eb64:	0117c737          	lui	a4,0x117c
8000eb68:	02070713          	add	a4,a4,32 # 117c020 <ram_buffer_block_items>
8000eb6c:	00e786b3          	add	a3,a5,a4
8000eb70:	4732                	lw	a4,12(sp)
8000eb72:	6785                	lui	a5,0x1
8000eb74:	fa078793          	add	a5,a5,-96 # fa0 <__NOR_CFG_OPTION_segment_size__+0x3a0>
8000eb78:	02f70733          	mul	a4,a4,a5
8000eb7c:	0117c7b7          	lui	a5,0x117c
8000eb80:	08078793          	add	a5,a5,128 # 117c080 <ram_buffer>
8000eb84:	97ba                	add	a5,a5,a4
8000eb86:	03200613          	li	a2,50
8000eb8a:	85be                	mv	a1,a5
8000eb8c:	8536                	mv	a0,a3
8000eb8e:	3d95                	jal	8000ea02 <share_buffer_item_init>
    for(int i = 0; i < RAM_BUFFER_BLOCK_SIZE; i++)
8000eb90:	47b2                	lw	a5,12(sp)
8000eb92:	0785                	add	a5,a5,1
8000eb94:	c63e                	sw	a5,12(sp)

8000eb96 <.L12>:
8000eb96:	4732                	lw	a4,12(sp)
8000eb98:	478d                	li	a5,3
8000eb9a:	fce7d0e3          	bge	a5,a4,8000eb5a <.L13>

8000eb9e <.LBE16>:
    share_buffer_init(&ram_buffer_block, ram_buffer_block_items, RAM_BUFFER_BLOCK_SIZE);
8000eb9e:	4611                	li	a2,4
8000eba0:	0117c7b7          	lui	a5,0x117c
8000eba4:	02078593          	add	a1,a5,32 # 117c020 <ram_buffer_block_items>
8000eba8:	0117c7b7          	lui	a5,0x117c
8000ebac:	00078513          	mv	a0,a5
8000ebb0:	3569                	jal	8000ea3a <share_buffer_init>
    printf("Shared memory CAN buffer initialization completed:\n");
8000ebb2:	68c18513          	add	a0,gp,1676 # 800099f8 <.LC0>
8000ebb6:	e7bfd0ef          	jal	8000ca30 <printf>
    printf("- Buffer blocks: %d\n", RAM_BUFFER_BLOCK_SIZE);
8000ebba:	4591                	li	a1,4
8000ebbc:	6c018513          	add	a0,gp,1728 # 80009a2c <.LC1>
8000ebc0:	e71fd0ef          	jal	8000ca30 <printf>
    printf("- Max frames per block: %d\n", MAX_CAN_BUFFER_SIZE);
8000ebc4:	03200593          	li	a1,50
8000ebc8:	6d818513          	add	a0,gp,1752 # 80009a44 <.LC2>
8000ebcc:	e65fd0ef          	jal	8000ca30 <printf>
    printf("- Total memory usage: %d bytes\n", 
8000ebd0:	6791                	lui	a5,0x4
8000ebd2:	e8078593          	add	a1,a5,-384 # 3e80 <__APB_SRAM_segment_size__+0x1e80>
8000ebd6:	6f418513          	add	a0,gp,1780 # 80009a60 <.LC3>
8000ebda:	e57fd0ef          	jal	8000ca30 <printf>
}
8000ebde:	0001                	nop
8000ebe0:	40f2                	lw	ra,28(sp)
8000ebe2:	6105                	add	sp,sp,32
8000ebe4:	8082                	ret

Disassembly of section .text.board_can_loopback_test_in_interrupt_mode:

8000ebe6 <board_can_loopback_test_in_interrupt_mode>:
{
8000ebe6:	7131                	add	sp,sp,-192
8000ebe8:	df06                	sw	ra,188(sp)
    CAN_Type *ptr = BOARD_APP_CAN_BASE;
8000ebea:	f00847b7          	lui	a5,0xf0084
8000ebee:	d33e                	sw	a5,164(sp)
    can_get_default_config(&can_config);
8000ebf0:	00bc                	add	a5,sp,72
8000ebf2:	853e                	mv	a0,a5
8000ebf4:	d43fe0ef          	jal	8000d936 <can_get_default_config>
    can_config.baudrate = 1000000; /* 1Mbps */
8000ebf8:	000f47b7          	lui	a5,0xf4
8000ebfc:	24078793          	add	a5,a5,576 # f4240 <__AXI_SRAM_segment_size__+0x34240>
8000ec00:	c4be                	sw	a5,72(sp)
    can_config.mode = can_mode_loopback_internal;
8000ec02:	4785                	li	a5,1
8000ec04:	04f10c23          	sb	a5,88(sp)
    board_init_can(ptr);
8000ec08:	551a                	lw	a0,164(sp)
8000ec0a:	8dafe0ef          	jal	8000cce4 <board_init_can>
    uint32_t can_src_clk_freq = board_init_can_clock(ptr);
8000ec0e:	551a                	lw	a0,164(sp)
8000ec10:	8e6fe0ef          	jal	8000ccf6 <board_init_can_clock>
8000ec14:	d12a                	sw	a0,160(sp)
    can_config.irq_txrx_enable_mask = CAN_EVENT_RECEIVE | CAN_EVENT_TX_PRIMARY_BUF | CAN_EVENT_TX_SECONDARY_BUF;
8000ec16:	f8c00793          	li	a5,-116
8000ec1a:	06f10223          	sb	a5,100(sp)
    hpm_stat_t status = can_init(ptr, &can_config, can_src_clk_freq);
8000ec1e:	00bc                	add	a5,sp,72
8000ec20:	560a                	lw	a2,160(sp)
8000ec22:	85be                	mv	a1,a5
8000ec24:	551a                	lw	a0,164(sp)
8000ec26:	c63fb0ef          	jal	8000a888 <can_init>
8000ec2a:	cf2a                	sw	a0,156(sp)
    if (status != status_success) {
8000ec2c:	47fa                	lw	a5,156(sp)
8000ec2e:	c799                	beqz	a5,8000ec3c <.L15>
        printf("CAN initialization failed, error code: %d\n", status);
8000ec30:	45fa                	lw	a1,156(sp)
8000ec32:	71418513          	add	a0,gp,1812 # 80009a80 <.LC4>
8000ec36:	dfbfd0ef          	jal	8000ca30 <printf>
8000ec3a:	a269                	j	8000edc4 <.L14>

8000ec3c <.L15>:
8000ec3c:	03000793          	li	a5,48
8000ec40:	debe                	sw	a5,124(sp)
8000ec42:	4785                	li	a5,1
8000ec44:	dcbe                	sw	a5,120(sp)
8000ec46:	e40007b7          	lui	a5,0xe4000
8000ec4a:	dabe                	sw	a5,116(sp)
8000ec4c:	57f6                	lw	a5,124(sp)
8000ec4e:	d8be                	sw	a5,112(sp)
8000ec50:	57e6                	lw	a5,120(sp)
8000ec52:	d6be                	sw	a5,108(sp)

8000ec54 <.LBB17>:
            HPM_PLIC_PRIORITY_OFFSET + ((irq-1) << HPM_PLIC_PRIORITY_SHIFT_PER_SOURCE));
8000ec54:	57c6                	lw	a5,112(sp)
8000ec56:	17fd                	add	a5,a5,-1 # e3ffffff <__FLASH_segment_end__+0x637fffff>
8000ec58:	00279713          	sll	a4,a5,0x2
8000ec5c:	57d6                	lw	a5,116(sp)
8000ec5e:	97ba                	add	a5,a5,a4
8000ec60:	0791                	add	a5,a5,4
    volatile uint32_t *priority_ptr = (volatile uint32_t *)(base +
8000ec62:	d4be                	sw	a5,104(sp)
    *priority_ptr = priority;
8000ec64:	57a6                	lw	a5,104(sp)
8000ec66:	5736                	lw	a4,108(sp)
8000ec68:	c398                	sw	a4,0(a5)
}
8000ec6a:	0001                	nop

8000ec6c <.LBE19>:
}
8000ec6c:	0001                	nop
8000ec6e:	cd02                	sw	zero,152(sp)
8000ec70:	03000793          	li	a5,48
8000ec74:	cb3e                	sw	a5,148(sp)
8000ec76:	e40007b7          	lui	a5,0xe4000
8000ec7a:	c93e                	sw	a5,144(sp)
8000ec7c:	47ea                	lw	a5,152(sp)
8000ec7e:	c73e                	sw	a5,140(sp)
8000ec80:	47da                	lw	a5,148(sp)
8000ec82:	c53e                	sw	a5,136(sp)

8000ec84 <.LBB21>:
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
8000ec84:	47ba                	lw	a5,140(sp)
8000ec86:	00779713          	sll	a4,a5,0x7
            HPM_PLIC_ENABLE_OFFSET +
8000ec8a:	47ca                	lw	a5,144(sp)
8000ec8c:	973e                	add	a4,a4,a5
            ((irq >> 5) << 2));
8000ec8e:	47aa                	lw	a5,136(sp)
8000ec90:	8395                	srl	a5,a5,0x5
8000ec92:	078a                	sll	a5,a5,0x2
            (target << HPM_PLIC_ENABLE_SHIFT_PER_TARGET) +
8000ec94:	973e                	add	a4,a4,a5
8000ec96:	6789                	lui	a5,0x2
8000ec98:	97ba                	add	a5,a5,a4
    volatile uint32_t *current_ptr = (volatile uint32_t *)(base +
8000ec9a:	c33e                	sw	a5,132(sp)
    uint32_t current = *current_ptr;
8000ec9c:	479a                	lw	a5,132(sp)
8000ec9e:	439c                	lw	a5,0(a5)
8000eca0:	c13e                	sw	a5,128(sp)
    current = current | (1 << (irq & 0x1F));
8000eca2:	47aa                	lw	a5,136(sp)
8000eca4:	8bfd                	and	a5,a5,31
8000eca6:	4705                	li	a4,1
8000eca8:	00f717b3          	sll	a5,a4,a5
8000ecac:	873e                	mv	a4,a5
8000ecae:	478a                	lw	a5,128(sp)
8000ecb0:	8fd9                	or	a5,a5,a4
8000ecb2:	c13e                	sw	a5,128(sp)
    *current_ptr = current;
8000ecb4:	479a                	lw	a5,132(sp)
8000ecb6:	470a                	lw	a4,128(sp)
8000ecb8:	c398                	sw	a4,0(a5)
}
8000ecba:	0001                	nop

8000ecbc <.LBE23>:
}
8000ecbc:	0001                	nop

8000ecbe <.LBE21>:
    memset(&tx_buf, 0, sizeof(tx_buf));
8000ecbe:	878a                	mv	a5,sp
8000ecc0:	04800613          	li	a2,72
8000ecc4:	4581                	li	a1,0
8000ecc6:	853e                	mv	a0,a5
8000ecc8:	0ec010ef          	jal	8000fdb4 <memset>
    tx_buf.dlc = 8;
8000eccc:	4792                	lw	a5,4(sp)
8000ecce:	9bc1                	and	a5,a5,-16
8000ecd0:	0087e793          	or	a5,a5,8
8000ecd4:	c23e                	sw	a5,4(sp)

8000ecd6 <.LBB25>:
    for (uint32_t i = 0; i < 8; i++) {
8000ecd6:	d702                	sw	zero,172(sp)
8000ecd8:	a035                	j	8000ed04 <.L17>

8000ecda <.L18>:
        tx_buf.data[i] = (uint8_t) i | (i << 4);
8000ecda:	57ba                	lw	a5,172(sp)
8000ecdc:	0ff7f713          	zext.b	a4,a5
8000ece0:	57ba                	lw	a5,172(sp)
8000ece2:	0ff7f793          	zext.b	a5,a5
8000ece6:	0792                	sll	a5,a5,0x4
8000ece8:	0ff7f793          	zext.b	a5,a5
8000ecec:	8fd9                	or	a5,a5,a4
8000ecee:	0ff7f713          	zext.b	a4,a5
8000ecf2:	57ba                	lw	a5,172(sp)
8000ecf4:	0b078793          	add	a5,a5,176 # 20b0 <__APB_SRAM_segment_size__+0xb0>
8000ecf8:	978a                	add	a5,a5,sp
8000ecfa:	f4e78c23          	sb	a4,-168(a5)
    for (uint32_t i = 0; i < 8; i++) {
8000ecfe:	57ba                	lw	a5,172(sp)
8000ed00:	0785                	add	a5,a5,1
8000ed02:	d73e                	sw	a5,172(sp)

8000ed04 <.L17>:
8000ed04:	573a                	lw	a4,172(sp)
8000ed06:	479d                	li	a5,7
8000ed08:	fce7f9e3          	bgeu	a5,a4,8000ecda <.L18>

8000ed0c <.LBB26>:
    for (uint32_t i = 0; i < 2048; i++) {
8000ed0c:	d502                	sw	zero,168(sp)
8000ed0e:	a075                	j	8000edba <.L19>

8000ed10 <.L25>:
        tx_buf.id = i;
8000ed10:	572a                	lw	a4,168(sp)
8000ed12:	200007b7          	lui	a5,0x20000
8000ed16:	17fd                	add	a5,a5,-1 # 1fffffff <__SHARE_RAM_segment_end__+0x1ee7ffff>
8000ed18:	8f7d                	and	a4,a4,a5
8000ed1a:	200007b7          	lui	a5,0x20000
8000ed1e:	17fd                	add	a5,a5,-1 # 1fffffff <__SHARE_RAM_segment_end__+0x1ee7ffff>
8000ed20:	8ff9                	and	a5,a5,a4
8000ed22:	4682                	lw	a3,0(sp)
8000ed24:	e0000737          	lui	a4,0xe0000
8000ed28:	8f75                	and	a4,a4,a3
8000ed2a:	8fd9                	or	a5,a5,a4
8000ed2c:	c03e                	sw	a5,0(sp)
        can_send_message_nonblocking(BOARD_APP_CAN_BASE, &tx_buf);
8000ed2e:	878a                	mv	a5,sp
8000ed30:	85be                	mv	a1,a5
8000ed32:	f0084537          	lui	a0,0xf0084
8000ed36:	a8bfe0ef          	jal	8000d7c0 <can_send_message_nonblocking>
        if(ram_buffer_block.wait > 0)
8000ed3a:	0117c7b7          	lui	a5,0x117c
8000ed3e:	00078793          	mv	a5,a5
8000ed42:	0067d783          	lhu	a5,6(a5) # 117c006 <ram_buffer_block+0x6>
8000ed46:	cf9d                	beqz	a5,8000ed84 <.L26>
            mbx_enable_intr(HPM_MBX0A, MBX_CR_TWMEIE_MASK);
8000ed48:	4589                	li	a1,2
8000ed4a:	f00a0537          	lui	a0,0xf00a0
8000ed4e:	33e1                	jal	8000eb16 <mbx_enable_intr>

8000ed50 <.L22>:
                if(can_send){
8000ed50:	84c24783          	lbu	a5,-1972(tp) # fffff84c <__APB_SRAM_segment_end__+0xbf0d84c>
8000ed54:	0ff7f793          	zext.b	a5,a5
8000ed58:	dfe5                	beqz	a5,8000ed50 <.L22>
                    mbx_send_message(HPM_MBX0A, (uint32_t)2);  // 发送当前计数作为消息
8000ed5a:	4589                	li	a1,2
8000ed5c:	f00a0537          	lui	a0,0xf00a0
8000ed60:	33f9                	jal	8000eb2e <mbx_send_message>
                    ram_buffer_block.wait--;
8000ed62:	0117c7b7          	lui	a5,0x117c
8000ed66:	00078793          	mv	a5,a5
8000ed6a:	0067d783          	lhu	a5,6(a5) # 117c006 <ram_buffer_block+0x6>
8000ed6e:	17fd                	add	a5,a5,-1
8000ed70:	01079713          	sll	a4,a5,0x10
8000ed74:	8341                	srl	a4,a4,0x10
8000ed76:	0117c7b7          	lui	a5,0x117c
8000ed7a:	00078793          	mv	a5,a5
8000ed7e:	00e79323          	sh	a4,6(a5) # 117c006 <ram_buffer_block+0x6>
                    break;
8000ed82:	0001                	nop

8000ed84 <.L26>:
        while (!has_sent_out) {
8000ed84:	0001                	nop

8000ed86 <.L23>:
8000ed86:	84924783          	lbu	a5,-1975(tp) # fffff849 <__APB_SRAM_segment_end__+0xbf0d849>
8000ed8a:	0ff7f793          	zext.b	a5,a5
8000ed8e:	0017c793          	xor	a5,a5,1
8000ed92:	0ff7f793          	zext.b	a5,a5
8000ed96:	fbe5                	bnez	a5,8000ed86 <.L23>
        while (!has_new_rcv_msg) {
8000ed98:	0001                	nop

8000ed9a <.L24>:
8000ed9a:	84a24783          	lbu	a5,-1974(tp) # fffff84a <__APB_SRAM_segment_end__+0xbf0d84a>
8000ed9e:	0ff7f793          	zext.b	a5,a5
8000eda2:	0017c793          	xor	a5,a5,1
8000eda6:	0ff7f793          	zext.b	a5,a5
8000edaa:	fbe5                	bnez	a5,8000ed9a <.L24>
        has_new_rcv_msg = false;
8000edac:	84020523          	sb	zero,-1974(tp) # fffff84a <__APB_SRAM_segment_end__+0xbf0d84a>
        has_sent_out = false;
8000edb0:	840204a3          	sb	zero,-1975(tp) # fffff849 <__APB_SRAM_segment_end__+0xbf0d849>
    for (uint32_t i = 0; i < 2048; i++) {
8000edb4:	57aa                	lw	a5,168(sp)
8000edb6:	0785                	add	a5,a5,1
8000edb8:	d53e                	sw	a5,168(sp)

8000edba <.L19>:
8000edba:	572a                	lw	a4,168(sp)
8000edbc:	7ff00793          	li	a5,2047
8000edc0:	f4e7f8e3          	bgeu	a5,a4,8000ed10 <.L25>

8000edc4 <.L14>:
}
8000edc4:	50fa                	lw	ra,188(sp)
8000edc6:	6129                	add	sp,sp,192
8000edc8:	8082                	ret

Disassembly of section .text.write_head_switch:

8000edca <write_head_switch>:

/* 写头切换 */
int8_t write_head_switch(share_buffer_t* block)
{
8000edca:	1141                	add	sp,sp,-16
8000edcc:	c62a                	sw	a0,12(sp)
    if(block->write_head->next->status == SHARE_BUFFER_STATUS_IDLE)
8000edce:	47b2                	lw	a5,12(sp)
8000edd0:	47dc                	lw	a5,12(a5)
8000edd2:	479c                	lw	a5,8(a5)
8000edd4:	0047c783          	lbu	a5,4(a5)
8000edd8:	eb9d                	bnez	a5,8000ee0e <.L40>
    {
        block->wait++;
8000edda:	47b2                	lw	a5,12(sp)
8000eddc:	0067d783          	lhu	a5,6(a5)
8000ede0:	0785                	add	a5,a5,1
8000ede2:	01079713          	sll	a4,a5,0x10
8000ede6:	8341                	srl	a4,a4,0x10
8000ede8:	47b2                	lw	a5,12(sp)
8000edea:	00e79323          	sh	a4,6(a5)
        block->write_head = block->write_head->next;
8000edee:	47b2                	lw	a5,12(sp)
8000edf0:	47dc                	lw	a5,12(a5)
8000edf2:	4798                	lw	a4,8(a5)
8000edf4:	47b2                	lw	a5,12(sp)
8000edf6:	c7d8                	sw	a4,12(a5)
        block->write_head->status = SHARE_BUFFER_STATUS_WRITING;
8000edf8:	47b2                	lw	a5,12(sp)
8000edfa:	47dc                	lw	a5,12(a5)
8000edfc:	4705                	li	a4,1
8000edfe:	00e78223          	sb	a4,4(a5)
        block->write_head->current_index = 0;
8000ee02:	47b2                	lw	a5,12(sp)
8000ee04:	47dc                	lw	a5,12(a5)
8000ee06:	000782a3          	sb	zero,5(a5)
        return 0;
8000ee0a:	4781                	li	a5,0
8000ee0c:	a011                	j	8000ee10 <.L41>

8000ee0e <.L40>:
    }else{
       // printf("write_head_switch():next item is not available\n");
        return -1;          /* 下一个item不可用*/
8000ee0e:	57fd                	li	a5,-1

8000ee10 <.L41>:
    }
    
}
8000ee10:	853e                	mv	a0,a5
8000ee12:	0141                	add	sp,sp,16
8000ee14:	8082                	ret

Disassembly of section .text.main:

8000ee16 <main>:



#if (BOARD_RUNNING_CORE == HPM_CORE0)
int main(void)
{
8000ee16:	1141                	add	sp,sp,-16
8000ee18:	c606                	sw	ra,12(sp)
   
    
   
    
    board_init();
8000ee1a:	e65fd0ef          	jal	8000cc7e <board_init>

    multicore_release_cpu(HPM_CORE1, SEC_CORE_IMG_START);
8000ee1e:	4581                	li	a1,0
8000ee20:	4505                	li	a0,1
8000ee22:	cf6fc0ef          	jal	8000b318 <multicore_release_cpu>
   clock_add_to_group(clock_mbx0, 0);
8000ee26:	4581                	li	a1,0
8000ee28:	011407b7          	lui	a5,0x1140
8000ee2c:	50278513          	add	a0,a5,1282 # 1140502 <__AXI_SRAM_segment_end__+0x502>
8000ee30:	a21fc0ef          	jal	8000b850 <clock_add_to_group>
   
    
    ram_buffer_block_init();
8000ee34:	3b39                	jal	8000eb52 <ram_buffer_block_init>
    mbx_interrupt_init();
8000ee36:	e02fc0ef          	jal	8000b438 <mbx_interrupt_init>
    board_can_loopback_test_in_interrupt_mode();
8000ee3a:	3375                	jal	8000ebe6 <board_can_loopback_test_in_interrupt_mode>
    
  

        
    return 0;
8000ee3c:	4781                	li	a5,0
}
8000ee3e:	853e                	mv	a0,a5
8000ee40:	40b2                	lw	ra,12(sp)
8000ee42:	0141                	add	sp,sp,16
8000ee44:	8082                	ret

Disassembly of section .text._clean_up:

8000ee46 <_clean_up>:
#define MAIN_ENTRY main
#endif
extern int MAIN_ENTRY(void);

__attribute__((weak)) void _clean_up(void)
{
8000ee46:	7139                	add	sp,sp,-64

8000ee48 <.LBB18>:
    clear_csr(CSR_MIE, CSR_MIE_MEIE_MASK);
8000ee48:	6785                	lui	a5,0x1
8000ee4a:	80078793          	add	a5,a5,-2048 # 800 <__ILM_segment_used_end__+0x13a>
8000ee4e:	3047b073          	csrc	mie,a5
}
8000ee52:	0001                	nop
8000ee54:	da02                	sw	zero,52(sp)
8000ee56:	d802                	sw	zero,48(sp)
8000ee58:	e40007b7          	lui	a5,0xe4000
8000ee5c:	d63e                	sw	a5,44(sp)
8000ee5e:	57d2                	lw	a5,52(sp)
8000ee60:	d43e                	sw	a5,40(sp)
8000ee62:	57c2                	lw	a5,48(sp)
8000ee64:	d23e                	sw	a5,36(sp)

8000ee66 <.LBB20>:
            (target << HPM_PLIC_THRESHOLD_SHIFT_PER_TARGET));
8000ee66:	57a2                	lw	a5,40(sp)
8000ee68:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_THRESHOLD_OFFSET +
8000ee6c:	57b2                	lw	a5,44(sp)
8000ee6e:	973e                	add	a4,a4,a5
8000ee70:	002007b7          	lui	a5,0x200
8000ee74:	97ba                	add	a5,a5,a4
    volatile uint32_t *threshold_ptr = (volatile uint32_t *)(base +
8000ee76:	d03e                	sw	a5,32(sp)
    *threshold_ptr = threshold;
8000ee78:	5782                	lw	a5,32(sp)
8000ee7a:	5712                	lw	a4,36(sp)
8000ee7c:	c398                	sw	a4,0(a5)
}
8000ee7e:	0001                	nop

8000ee80 <.LBE22>:
 * @param[in] threshold Threshold of IRQ can be serviced
 */
ATTR_ALWAYS_INLINE static inline void intc_set_threshold(uint32_t target, uint32_t threshold)
{
    __plic_set_threshold(HPM_PLIC_BASE, target, threshold);
}
8000ee80:	0001                	nop

8000ee82 <.LBB24>:
    /* clean up plic, it will help while debugging */
    disable_irq_from_intc();
    intc_m_set_threshold(0);
    for (uint32_t irq = 0; irq < 128; irq++) {
8000ee82:	de02                	sw	zero,60(sp)
8000ee84:	a82d                	j	8000eebe <.L2>

8000ee86 <.L3>:
8000ee86:	ce02                	sw	zero,28(sp)
8000ee88:	57f2                	lw	a5,60(sp)
8000ee8a:	cc3e                	sw	a5,24(sp)
8000ee8c:	e40007b7          	lui	a5,0xe4000
8000ee90:	ca3e                	sw	a5,20(sp)
8000ee92:	47f2                	lw	a5,28(sp)
8000ee94:	c83e                	sw	a5,16(sp)
8000ee96:	47e2                	lw	a5,24(sp)
8000ee98:	c63e                	sw	a5,12(sp)

8000ee9a <.LBB25>:
                                                          uint32_t target,
                                                          uint32_t irq)
{
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
            HPM_PLIC_CLAIM_OFFSET +
            (target << HPM_PLIC_CLAIM_SHIFT_PER_TARGET));
8000ee9a:	47c2                	lw	a5,16(sp)
8000ee9c:	00c79713          	sll	a4,a5,0xc
            HPM_PLIC_CLAIM_OFFSET +
8000eea0:	47d2                	lw	a5,20(sp)
8000eea2:	973e                	add	a4,a4,a5
8000eea4:	002007b7          	lui	a5,0x200
8000eea8:	0791                	add	a5,a5,4 # 200004 <__AXI_SRAM_segment_size__+0x140004>
8000eeaa:	97ba                	add	a5,a5,a4
    volatile uint32_t *claim_addr = (volatile uint32_t *)(base +
8000eeac:	c43e                	sw	a5,8(sp)
    *claim_addr = irq;
8000eeae:	47a2                	lw	a5,8(sp)
8000eeb0:	4732                	lw	a4,12(sp)
8000eeb2:	c398                	sw	a4,0(a5)
}
8000eeb4:	0001                	nop

8000eeb6 <.LBE27>:
 *
 */
ATTR_ALWAYS_INLINE static inline void intc_complete_irq(uint32_t target, uint32_t irq)
{
    __plic_complete_irq(HPM_PLIC_BASE, target, irq);
}
8000eeb6:	0001                	nop

8000eeb8 <.LBE25>:
8000eeb8:	57f2                	lw	a5,60(sp)
8000eeba:	0785                	add	a5,a5,1
8000eebc:	de3e                	sw	a5,60(sp)

8000eebe <.L2>:
8000eebe:	5772                	lw	a4,60(sp)
8000eec0:	07f00793          	li	a5,127
8000eec4:	fce7f1e3          	bgeu	a5,a4,8000ee86 <.L3>

8000eec8 <.LBB29>:
        intc_m_complete_irq(irq);
    }
    /* clear any bits left in plic enable register */
    for (uint32_t i = 0; i < 4; i++) {
8000eec8:	dc02                	sw	zero,56(sp)
8000eeca:	a821                	j	8000eee2 <.L4>

8000eecc <.L5>:
        *(volatile uint32_t *)(HPM_PLIC_BASE + HPM_PLIC_ENABLE_OFFSET + (i << 2)) = 0;
8000eecc:	57e2                	lw	a5,56(sp)
8000eece:	00279713          	sll	a4,a5,0x2
8000eed2:	e40027b7          	lui	a5,0xe4002
8000eed6:	97ba                	add	a5,a5,a4
8000eed8:	0007a023          	sw	zero,0(a5) # e4002000 <__FLASH_segment_end__+0x63802000>
    for (uint32_t i = 0; i < 4; i++) {
8000eedc:	57e2                	lw	a5,56(sp)
8000eede:	0785                	add	a5,a5,1
8000eee0:	dc3e                	sw	a5,56(sp)

8000eee2 <.L4>:
8000eee2:	5762                	lw	a4,56(sp)
8000eee4:	478d                	li	a5,3
8000eee6:	fee7f3e3          	bgeu	a5,a4,8000eecc <.L5>

8000eeea <.LBE29>:
    }
}
8000eeea:	0001                	nop
8000eeec:	0001                	nop
8000eeee:	6121                	add	sp,sp,64
8000eef0:	8082                	ret

Disassembly of section .text.reset_handler:

8000eef2 <reset_handler>:
        ;
    }
}

__attribute__((weak)) void reset_handler(void)
{
8000eef2:	1141                	add	sp,sp,-16
8000eef4:	c606                	sw	ra,12(sp)
    fencei();
8000eef6:	0000100f          	fence.i

    /* Call platform specific hardware initialization */
    system_init();
8000eefa:	b2dfc0ef          	jal	8000ba26 <system_init>

    /* Entry function */
    MAIN_ENTRY();
8000eefe:	3f21                	jal	8000ee16 <main>
}
8000ef00:	0001                	nop
8000ef02:	40b2                	lw	ra,12(sp)
8000ef04:	0141                	add	sp,sp,16
8000ef06:	8082                	ret

Disassembly of section .text._init:

8000ef08 <_init>:
__attribute__((weak)) void *__dso_handle = (void *) &__dso_handle;
#endif

__attribute__((weak)) void _init(void)
{
}
8000ef08:	0001                	nop
8000ef0a:	8082                	ret

Disassembly of section .text.mchtmr_isr:

8000ef0c <mchtmr_isr>:
}
8000ef0c:	0001                	nop
8000ef0e:	8082                	ret

Disassembly of section .text.swi_isr:

8000ef10 <swi_isr>:
}
8000ef10:	0001                	nop
8000ef12:	8082                	ret

Disassembly of section .text.exception_handler:

8000ef14 <exception_handler>:

__attribute__((weak)) long exception_handler(long cause, long epc)
{
8000ef14:	1141                	add	sp,sp,-16
8000ef16:	c62a                	sw	a0,12(sp)
8000ef18:	c42e                	sw	a1,8(sp)
    switch (cause) {
8000ef1a:	4732                	lw	a4,12(sp)
8000ef1c:	47bd                	li	a5,15
8000ef1e:	00e7ec63          	bltu	a5,a4,8000ef36 <.L23>
8000ef22:	47b2                	lw	a5,12(sp)
8000ef24:	00279713          	sll	a4,a5,0x2
8000ef28:	800097b7          	lui	a5,0x80009
8000ef2c:	b0078793          	add	a5,a5,-1280 # 80008b00 <.L7>
8000ef30:	97ba                	add	a5,a5,a4
8000ef32:	439c                	lw	a5,0(a5)
8000ef34:	8782                	jr	a5

8000ef36 <.L23>:
    case MCAUSE_LOAD_PAGE_FAULT:
        break;
    case MCAUSE_STORE_AMO_PAGE_FAULT:
        break;
    default:
        break;
8000ef36:	0001                	nop
    }
    /* Unhandled Trap */
    return epc;
8000ef38:	47a2                	lw	a5,8(sp)
}
8000ef3a:	853e                	mv	a0,a5
8000ef3c:	0141                	add	sp,sp,16
8000ef3e:	8082                	ret

Disassembly of section .text.get_frequency_for_source:

8000ef40 <get_frequency_for_source>:
{
8000ef40:	7179                	add	sp,sp,-48
8000ef42:	d606                	sw	ra,44(sp)
8000ef44:	87aa                	mv	a5,a0
8000ef46:	00f107a3          	sb	a5,15(sp)
    uint32_t clk_freq = 0UL;
8000ef4a:	ce02                	sw	zero,28(sp)
    uint32_t div = 1;
8000ef4c:	4785                	li	a5,1
8000ef4e:	cc3e                	sw	a5,24(sp)
    switch (source) {
8000ef50:	00f14783          	lbu	a5,15(sp)
8000ef54:	471d                	li	a4,7
8000ef56:	0cf76c63          	bltu	a4,a5,8000f02e <.L45>
8000ef5a:	00279713          	sll	a4,a5,0x2
8000ef5e:	82018793          	add	a5,gp,-2016 # 80008b8c <.L47>
8000ef62:	97ba                	add	a5,a5,a4
8000ef64:	439c                	lw	a5,0(a5)
8000ef66:	8782                	jr	a5

8000ef68 <.L54>:
        clk_freq = FREQ_PRESET1_OSC0_CLK0;
8000ef68:	016e37b7          	lui	a5,0x16e3
8000ef6c:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000ef70:	ce3e                	sw	a5,28(sp)
        break;
8000ef72:	a0c1                	j	8000f032 <.L55>

8000ef74 <.L53>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 0U);
8000ef74:	4581                	li	a1,0
8000ef76:	f4100537          	lui	a0,0xf4100
8000ef7a:	b14ff0ef          	jal	8000e28e <pllctl_get_pll_freq_in_hz>
8000ef7e:	ce2a                	sw	a0,28(sp)
        break;
8000ef80:	a84d                	j	8000f032 <.L55>

8000ef82 <.L52>:
        div = pllctl_get_div(HPM_PLLCTL, 1, 0);
8000ef82:	4601                	li	a2,0
8000ef84:	4585                	li	a1,1
8000ef86:	f4100537          	lui	a0,0xf4100
8000ef8a:	e4efc0ef          	jal	8000b5d8 <pllctl_get_div>
8000ef8e:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 1U) / div;
8000ef90:	4585                	li	a1,1
8000ef92:	f4100537          	lui	a0,0xf4100
8000ef96:	af8ff0ef          	jal	8000e28e <pllctl_get_pll_freq_in_hz>
8000ef9a:	872a                	mv	a4,a0
8000ef9c:	47e2                	lw	a5,24(sp)
8000ef9e:	02f757b3          	divu	a5,a4,a5
8000efa2:	ce3e                	sw	a5,28(sp)
        break;
8000efa4:	a079                	j	8000f032 <.L55>

8000efa6 <.L51>:
        div = pllctl_get_div(HPM_PLLCTL, 1, 1);
8000efa6:	4605                	li	a2,1
8000efa8:	4585                	li	a1,1
8000efaa:	f4100537          	lui	a0,0xf4100
8000efae:	e2afc0ef          	jal	8000b5d8 <pllctl_get_div>
8000efb2:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 1U) / div;
8000efb4:	4585                	li	a1,1
8000efb6:	f4100537          	lui	a0,0xf4100
8000efba:	ad4ff0ef          	jal	8000e28e <pllctl_get_pll_freq_in_hz>
8000efbe:	872a                	mv	a4,a0
8000efc0:	47e2                	lw	a5,24(sp)
8000efc2:	02f757b3          	divu	a5,a4,a5
8000efc6:	ce3e                	sw	a5,28(sp)
        break;
8000efc8:	a0ad                	j	8000f032 <.L55>

8000efca <.L50>:
        div = pllctl_get_div(HPM_PLLCTL, 2, 0);
8000efca:	4601                	li	a2,0
8000efcc:	4589                	li	a1,2
8000efce:	f4100537          	lui	a0,0xf4100
8000efd2:	e06fc0ef          	jal	8000b5d8 <pllctl_get_div>
8000efd6:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 2U) / div;
8000efd8:	4589                	li	a1,2
8000efda:	f4100537          	lui	a0,0xf4100
8000efde:	ab0ff0ef          	jal	8000e28e <pllctl_get_pll_freq_in_hz>
8000efe2:	872a                	mv	a4,a0
8000efe4:	47e2                	lw	a5,24(sp)
8000efe6:	02f757b3          	divu	a5,a4,a5
8000efea:	ce3e                	sw	a5,28(sp)
        break;
8000efec:	a099                	j	8000f032 <.L55>

8000efee <.L49>:
        div = pllctl_get_div(HPM_PLLCTL, 2, 1);
8000efee:	4605                	li	a2,1
8000eff0:	4589                	li	a1,2
8000eff2:	f4100537          	lui	a0,0xf4100
8000eff6:	de2fc0ef          	jal	8000b5d8 <pllctl_get_div>
8000effa:	cc2a                	sw	a0,24(sp)
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 2U) / div;
8000effc:	4589                	li	a1,2
8000effe:	f4100537          	lui	a0,0xf4100
8000f002:	a8cff0ef          	jal	8000e28e <pllctl_get_pll_freq_in_hz>
8000f006:	872a                	mv	a4,a0
8000f008:	47e2                	lw	a5,24(sp)
8000f00a:	02f757b3          	divu	a5,a4,a5
8000f00e:	ce3e                	sw	a5,28(sp)
        break;
8000f010:	a00d                	j	8000f032 <.L55>

8000f012 <.L48>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 3U);
8000f012:	458d                	li	a1,3
8000f014:	f4100537          	lui	a0,0xf4100
8000f018:	a76ff0ef          	jal	8000e28e <pllctl_get_pll_freq_in_hz>
8000f01c:	ce2a                	sw	a0,28(sp)
        break;
8000f01e:	a811                	j	8000f032 <.L55>

8000f020 <.L46>:
        clk_freq = pllctl_get_pll_freq_in_hz(HPM_PLLCTL, 4U);
8000f020:	4591                	li	a1,4
8000f022:	f4100537          	lui	a0,0xf4100
8000f026:	a68ff0ef          	jal	8000e28e <pllctl_get_pll_freq_in_hz>
8000f02a:	ce2a                	sw	a0,28(sp)
        break;
8000f02c:	a019                	j	8000f032 <.L55>

8000f02e <.L45>:
        clk_freq = 0UL;
8000f02e:	ce02                	sw	zero,28(sp)
        break;
8000f030:	0001                	nop

8000f032 <.L55>:
    return clk_freq;
8000f032:	47f2                	lw	a5,28(sp)
}
8000f034:	853e                	mv	a0,a5
8000f036:	50b2                	lw	ra,44(sp)
8000f038:	6145                	add	sp,sp,48
8000f03a:	8082                	ret

Disassembly of section .text.get_frequency_for_i2s_or_adc:

8000f03c <get_frequency_for_i2s_or_adc>:
{
8000f03c:	7139                	add	sp,sp,-64
8000f03e:	de06                	sw	ra,60(sp)
8000f040:	c62a                	sw	a0,12(sp)
8000f042:	c42e                	sw	a1,8(sp)
    uint32_t clk_freq = 0UL;
8000f044:	d602                	sw	zero,44(sp)
    bool is_mux_valid = false;
8000f046:	020105a3          	sb	zero,43(sp)
    clock_node_t node = clock_node_end;
8000f04a:	04b00793          	li	a5,75
8000f04e:	02f10523          	sb	a5,42(sp)
    if (clk_src_type == CLK_SRC_GROUP_ADC) {
8000f052:	4732                	lw	a4,12(sp)
8000f054:	4785                	li	a5,1
8000f056:	04f71563          	bne	a4,a5,8000f0a0 <.L61>

8000f05a <.LBB7>:
        uint32_t adc_index = instance;
8000f05a:	47a2                	lw	a5,8(sp)
8000f05c:	ce3e                	sw	a5,28(sp)
        if (adc_index < ADC_INSTANCE_NUM) {
8000f05e:	4772                	lw	a4,28(sp)
8000f060:	478d                	li	a5,3
8000f062:	08e7e163          	bltu	a5,a4,8000f0e4 <.L62>

8000f066 <.LBB8>:
            uint32_t mux_in_reg = SYSCTL_ADCCLK_MUX_GET(HPM_SYSCTL->ADCCLK[adc_index]);
8000f066:	f4000737          	lui	a4,0xf4000
8000f06a:	47f2                	lw	a5,28(sp)
8000f06c:	70078793          	add	a5,a5,1792
8000f070:	078a                	sll	a5,a5,0x2
8000f072:	97ba                	add	a5,a5,a4
8000f074:	439c                	lw	a5,0(a5)
8000f076:	83a1                	srl	a5,a5,0x8
8000f078:	8b9d                	and	a5,a5,7
8000f07a:	cc3e                	sw	a5,24(sp)
            if (mux_in_reg < ARRAY_SIZE(s_adc_clk_mux_node)) {
8000f07c:	4762                	lw	a4,24(sp)
8000f07e:	478d                	li	a5,3
8000f080:	06e7e263          	bltu	a5,a4,8000f0e4 <.L62>
                node = s_adc_clk_mux_node[mux_in_reg];
8000f084:	800097b7          	lui	a5,0x80009
8000f088:	b4078713          	add	a4,a5,-1216 # 80008b40 <s_adc_clk_mux_node>
8000f08c:	47e2                	lw	a5,24(sp)
8000f08e:	97ba                	add	a5,a5,a4
8000f090:	0007c783          	lbu	a5,0(a5)
8000f094:	02f10523          	sb	a5,42(sp)
                is_mux_valid = true;
8000f098:	4785                	li	a5,1
8000f09a:	02f105a3          	sb	a5,43(sp)
8000f09e:	a099                	j	8000f0e4 <.L62>

8000f0a0 <.L61>:
        uint32_t i2s_index = instance;
8000f0a0:	47a2                	lw	a5,8(sp)
8000f0a2:	d23e                	sw	a5,36(sp)
        if (i2s_index < I2S_INSTANCE_NUM) {
8000f0a4:	5712                	lw	a4,36(sp)
8000f0a6:	478d                	li	a5,3
8000f0a8:	02e7ee63          	bltu	a5,a4,8000f0e4 <.L62>

8000f0ac <.LBB10>:
            uint32_t mux_in_reg = SYSCTL_I2SCLK_MUX_GET(HPM_SYSCTL->I2SCLK[i2s_index]);
8000f0ac:	f4000737          	lui	a4,0xf4000
8000f0b0:	5792                	lw	a5,36(sp)
8000f0b2:	70478793          	add	a5,a5,1796
8000f0b6:	078a                	sll	a5,a5,0x2
8000f0b8:	97ba                	add	a5,a5,a4
8000f0ba:	439c                	lw	a5,0(a5)
8000f0bc:	83a1                	srl	a5,a5,0x8
8000f0be:	8b9d                	and	a5,a5,7
8000f0c0:	d03e                	sw	a5,32(sp)
            if (mux_in_reg < ARRAY_SIZE(s_i2s_clk_mux_node)) {
8000f0c2:	5702                	lw	a4,32(sp)
8000f0c4:	478d                	li	a5,3
8000f0c6:	00e7ef63          	bltu	a5,a4,8000f0e4 <.L62>
                node = s_i2s_clk_mux_node[mux_in_reg];
8000f0ca:	800097b7          	lui	a5,0x80009
8000f0ce:	b4478713          	add	a4,a5,-1212 # 80008b44 <s_i2s_clk_mux_node>
8000f0d2:	5782                	lw	a5,32(sp)
8000f0d4:	97ba                	add	a5,a5,a4
8000f0d6:	0007c783          	lbu	a5,0(a5)
8000f0da:	02f10523          	sb	a5,42(sp)
                is_mux_valid = true;
8000f0de:	4785                	li	a5,1
8000f0e0:	02f105a3          	sb	a5,43(sp)

8000f0e4 <.L62>:
    if (is_mux_valid) {
8000f0e4:	02b14783          	lbu	a5,43(sp)
8000f0e8:	c38d                	beqz	a5,8000f10a <.L63>
        if (node == clock_node_ahb0) {
8000f0ea:	02a14703          	lbu	a4,42(sp)
8000f0ee:	479d                	li	a5,7
8000f0f0:	00f71763          	bne	a4,a5,8000f0fe <.L64>
            clk_freq = get_frequency_for_ip_in_common_group(clock_node_ahb0);
8000f0f4:	451d                	li	a0,7
8000f0f6:	e14fc0ef          	jal	8000b70a <get_frequency_for_ip_in_common_group>
8000f0fa:	d62a                	sw	a0,44(sp)
8000f0fc:	a039                	j	8000f10a <.L63>

8000f0fe <.L64>:
            clk_freq = get_frequency_for_ip_in_common_group(node);
8000f0fe:	02a14783          	lbu	a5,42(sp)
8000f102:	853e                	mv	a0,a5
8000f104:	e06fc0ef          	jal	8000b70a <get_frequency_for_ip_in_common_group>
8000f108:	d62a                	sw	a0,44(sp)

8000f10a <.L63>:
    return clk_freq;
8000f10a:	57b2                	lw	a5,44(sp)
}
8000f10c:	853e                	mv	a0,a5
8000f10e:	50f2                	lw	ra,60(sp)
8000f110:	6121                	add	sp,sp,64
8000f112:	8082                	ret

Disassembly of section .text.get_frequency_for_wdg:

8000f114 <get_frequency_for_wdg>:
{
8000f114:	7179                	add	sp,sp,-48
8000f116:	d606                	sw	ra,44(sp)
8000f118:	c62a                	sw	a0,12(sp)
    if (WDG_CTRL_CLKSEL_GET(s_wdgs[instance]->CTRL) == 0) {
8000f11a:	800097b7          	lui	a5,0x80009
8000f11e:	b4878713          	add	a4,a5,-1208 # 80008b48 <s_wdgs>
8000f122:	47b2                	lw	a5,12(sp)
8000f124:	078a                	sll	a5,a5,0x2
8000f126:	97ba                	add	a5,a5,a4
8000f128:	439c                	lw	a5,0(a5)
8000f12a:	4b9c                	lw	a5,16(a5)
8000f12c:	8b89                	and	a5,a5,2
8000f12e:	e791                	bnez	a5,8000f13a <.L67>
        freq_in_hz = get_frequency_for_ip_in_common_group(clock_node_ahb0);
8000f130:	451d                	li	a0,7
8000f132:	dd8fc0ef          	jal	8000b70a <get_frequency_for_ip_in_common_group>
8000f136:	ce2a                	sw	a0,28(sp)
8000f138:	a019                	j	8000f13e <.L68>

8000f13a <.L67>:
        freq_in_hz = FREQ_32KHz;
8000f13a:	67a1                	lui	a5,0x8
8000f13c:	ce3e                	sw	a5,28(sp)

8000f13e <.L68>:
    return freq_in_hz;
8000f13e:	47f2                	lw	a5,28(sp)
}
8000f140:	853e                	mv	a0,a5
8000f142:	50b2                	lw	ra,44(sp)
8000f144:	6145                	add	sp,sp,48
8000f146:	8082                	ret

Disassembly of section .text.get_frequency_for_pwdg:

8000f148 <get_frequency_for_pwdg>:
{
8000f148:	1141                	add	sp,sp,-16
    if (WDG_CTRL_CLKSEL_GET(HPM_PWDG->CTRL) == 0) {
8000f14a:	f40e87b7          	lui	a5,0xf40e8
8000f14e:	4b9c                	lw	a5,16(a5)
8000f150:	8b89                	and	a5,a5,2
8000f152:	e799                	bnez	a5,8000f160 <.L71>
        freq_in_hz = FREQ_PRESET1_OSC0_CLK0;
8000f154:	016e37b7          	lui	a5,0x16e3
8000f158:	60078793          	add	a5,a5,1536 # 16e3600 <__SHARE_RAM_segment_end__+0x563600>
8000f15c:	c63e                	sw	a5,12(sp)
8000f15e:	a019                	j	8000f164 <.L72>

8000f160 <.L71>:
        freq_in_hz = FREQ_32KHz;
8000f160:	67a1                	lui	a5,0x8
8000f162:	c63e                	sw	a5,12(sp)

8000f164 <.L72>:
    return freq_in_hz;
8000f164:	47b2                	lw	a5,12(sp)
}
8000f166:	853e                	mv	a0,a5
8000f168:	0141                	add	sp,sp,16
8000f16a:	8082                	ret

Disassembly of section .text.clock_connect_group_to_cpu:

8000f16c <clock_connect_group_to_cpu>:
{
8000f16c:	1141                	add	sp,sp,-16
8000f16e:	c62a                	sw	a0,12(sp)
8000f170:	c42e                	sw	a1,8(sp)
    if (cpu < 2U) {
8000f172:	4722                	lw	a4,8(sp)
8000f174:	4785                	li	a5,1
8000f176:	00e7ee63          	bltu	a5,a4,8000f192 <.L183>
        HPM_SYSCTL->AFFILIATE[cpu].SET = (1UL << group);
8000f17a:	f40006b7          	lui	a3,0xf4000
8000f17e:	47b2                	lw	a5,12(sp)
8000f180:	4705                	li	a4,1
8000f182:	00f71733          	sll	a4,a4,a5
8000f186:	47a2                	lw	a5,8(sp)
8000f188:	09078793          	add	a5,a5,144 # 8090 <__AHB_SRAM_segment_size__+0x90>
8000f18c:	0792                	sll	a5,a5,0x4
8000f18e:	97b6                	add	a5,a5,a3
8000f190:	c3d8                	sw	a4,4(a5)

8000f192 <.L183>:
}
8000f192:	0001                	nop
8000f194:	0141                	add	sp,sp,16
8000f196:	8082                	ret

Disassembly of section .text.sysctl_valid_cpu_index:

8000f198 <sysctl_valid_cpu_index>:
{
8000f198:	1141                	add	sp,sp,-16
8000f19a:	87aa                	mv	a5,a0
8000f19c:	00f107a3          	sb	a5,15(sp)
    if ((cpu != SYSCTL_CPU_CPU0) && (cpu != SYSCTL_CPU_CPU1)) {
8000f1a0:	00f14783          	lbu	a5,15(sp)
8000f1a4:	cb81                	beqz	a5,8000f1b4 <.L14>
8000f1a6:	00f14703          	lbu	a4,15(sp)
8000f1aa:	4785                	li	a5,1
8000f1ac:	00f70463          	beq	a4,a5,8000f1b4 <.L14>
        return false;
8000f1b0:	4781                	li	a5,0
8000f1b2:	a011                	j	8000f1b6 <.L15>

8000f1b4 <.L14>:
    return true;
8000f1b4:	4785                	li	a5,1

8000f1b6 <.L15>:
}
8000f1b6:	853e                	mv	a0,a5
8000f1b8:	0141                	add	sp,sp,16
8000f1ba:	8082                	ret

Disassembly of section .text.sysctl_enable_group_resource:

8000f1bc <sysctl_enable_group_resource>:
{
8000f1bc:	7179                	add	sp,sp,-48
8000f1be:	d606                	sw	ra,44(sp)
8000f1c0:	c62a                	sw	a0,12(sp)
8000f1c2:	87ae                	mv	a5,a1
8000f1c4:	8736                	mv	a4,a3
8000f1c6:	00f105a3          	sb	a5,11(sp)
8000f1ca:	87b2                	mv	a5,a2
8000f1cc:	00f11423          	sh	a5,8(sp)
8000f1d0:	87ba                	mv	a5,a4
8000f1d2:	00f10523          	sb	a5,10(sp)
    if (resource < sysctl_resource_linkable_start) {
8000f1d6:	00815703          	lhu	a4,8(sp)
8000f1da:	0ff00793          	li	a5,255
8000f1de:	00e7e463          	bltu	a5,a4,8000f1e6 <.L60>
        return status_invalid_argument;
8000f1e2:	4789                	li	a5,2
8000f1e4:	a8e5                	j	8000f2dc <.L61>

8000f1e6 <.L60>:
    index = (resource - sysctl_resource_linkable_start) / 32;
8000f1e6:	00815783          	lhu	a5,8(sp)
8000f1ea:	f0078793          	add	a5,a5,-256
8000f1ee:	41f7d713          	sra	a4,a5,0x1f
8000f1f2:	8b7d                	and	a4,a4,31
8000f1f4:	97ba                	add	a5,a5,a4
8000f1f6:	8795                	sra	a5,a5,0x5
8000f1f8:	ce3e                	sw	a5,28(sp)
    offset = (resource - sysctl_resource_linkable_start) % 32;
8000f1fa:	00815783          	lhu	a5,8(sp)
8000f1fe:	f0078713          	add	a4,a5,-256
8000f202:	41f75793          	sra	a5,a4,0x1f
8000f206:	83ed                	srl	a5,a5,0x1b
8000f208:	973e                	add	a4,a4,a5
8000f20a:	8b7d                	and	a4,a4,31
8000f20c:	40f707b3          	sub	a5,a4,a5
8000f210:	cc3e                	sw	a5,24(sp)
    switch (group) {
8000f212:	00b14783          	lbu	a5,11(sp)
8000f216:	c789                	beqz	a5,8000f220 <.L62>
8000f218:	4705                	li	a4,1
8000f21a:	04e78f63          	beq	a5,a4,8000f278 <.L63>
8000f21e:	a84d                	j	8000f2d0 <.L74>

8000f220 <.L62>:
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset))
8000f220:	4732                	lw	a4,12(sp)
8000f222:	47f2                	lw	a5,28(sp)
8000f224:	08078793          	add	a5,a5,128
8000f228:	0792                	sll	a5,a5,0x4
8000f22a:	97ba                	add	a5,a5,a4
8000f22c:	4398                	lw	a4,0(a5)
8000f22e:	47e2                	lw	a5,24(sp)
8000f230:	4685                	li	a3,1
8000f232:	00f697b3          	sll	a5,a3,a5
8000f236:	fff7c793          	not	a5,a5
8000f23a:	8f7d                	and	a4,a4,a5
            | (enable ? (1UL << offset) : 0);
8000f23c:	00a14783          	lbu	a5,10(sp)
8000f240:	c791                	beqz	a5,8000f24c <.L65>
8000f242:	47e2                	lw	a5,24(sp)
8000f244:	4685                	li	a3,1
8000f246:	00f697b3          	sll	a5,a3,a5
8000f24a:	a011                	j	8000f24e <.L66>

8000f24c <.L65>:
8000f24c:	4781                	li	a5,0

8000f24e <.L66>:
8000f24e:	8f5d                	or	a4,a4,a5
        ptr->GROUP0[index].VALUE = (ptr->GROUP0[index].VALUE & ~(1UL << offset))
8000f250:	46b2                	lw	a3,12(sp)
8000f252:	47f2                	lw	a5,28(sp)
8000f254:	08078793          	add	a5,a5,128
8000f258:	0792                	sll	a5,a5,0x4
8000f25a:	97b6                	add	a5,a5,a3
8000f25c:	c398                	sw	a4,0(a5)
        if (enable) {
8000f25e:	00a14783          	lbu	a5,10(sp)
8000f262:	cbad                	beqz	a5,8000f2d4 <.L75>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
8000f264:	0001                	nop

8000f266 <.L68>:
8000f266:	00815783          	lhu	a5,8(sp)
8000f26a:	85be                	mv	a1,a5
8000f26c:	4532                	lw	a0,12(sp)
8000f26e:	e50fc0ef          	jal	8000b8be <sysctl_resource_target_is_busy>
8000f272:	87aa                	mv	a5,a0
8000f274:	fbed                	bnez	a5,8000f266 <.L68>
        break;
8000f276:	a8b9                	j	8000f2d4 <.L75>

8000f278 <.L63>:
        ptr->GROUP1[index].VALUE = (ptr->GROUP1[index].VALUE & ~(1UL << offset))
8000f278:	4732                	lw	a4,12(sp)
8000f27a:	47f2                	lw	a5,28(sp)
8000f27c:	08478793          	add	a5,a5,132
8000f280:	0792                	sll	a5,a5,0x4
8000f282:	97ba                	add	a5,a5,a4
8000f284:	4398                	lw	a4,0(a5)
8000f286:	47e2                	lw	a5,24(sp)
8000f288:	4685                	li	a3,1
8000f28a:	00f697b3          	sll	a5,a3,a5
8000f28e:	fff7c793          	not	a5,a5
8000f292:	8f7d                	and	a4,a4,a5
            | (enable ? (1UL << offset) : 0);
8000f294:	00a14783          	lbu	a5,10(sp)
8000f298:	c791                	beqz	a5,8000f2a4 <.L70>
8000f29a:	47e2                	lw	a5,24(sp)
8000f29c:	4685                	li	a3,1
8000f29e:	00f697b3          	sll	a5,a3,a5
8000f2a2:	a011                	j	8000f2a6 <.L71>

8000f2a4 <.L70>:
8000f2a4:	4781                	li	a5,0

8000f2a6 <.L71>:
8000f2a6:	8f5d                	or	a4,a4,a5
        ptr->GROUP1[index].VALUE = (ptr->GROUP1[index].VALUE & ~(1UL << offset))
8000f2a8:	46b2                	lw	a3,12(sp)
8000f2aa:	47f2                	lw	a5,28(sp)
8000f2ac:	08478793          	add	a5,a5,132
8000f2b0:	0792                	sll	a5,a5,0x4
8000f2b2:	97b6                	add	a5,a5,a3
8000f2b4:	c398                	sw	a4,0(a5)
        if (enable) {
8000f2b6:	00a14783          	lbu	a5,10(sp)
8000f2ba:	cf99                	beqz	a5,8000f2d8 <.L76>
            while (sysctl_resource_target_is_busy(ptr, resource)) {
8000f2bc:	0001                	nop

8000f2be <.L73>:
8000f2be:	00815783          	lhu	a5,8(sp)
8000f2c2:	85be                	mv	a1,a5
8000f2c4:	4532                	lw	a0,12(sp)
8000f2c6:	df8fc0ef          	jal	8000b8be <sysctl_resource_target_is_busy>
8000f2ca:	87aa                	mv	a5,a0
8000f2cc:	fbed                	bnez	a5,8000f2be <.L73>
        break;
8000f2ce:	a029                	j	8000f2d8 <.L76>

8000f2d0 <.L74>:
        return status_invalid_argument;
8000f2d0:	4789                	li	a5,2
8000f2d2:	a029                	j	8000f2dc <.L61>

8000f2d4 <.L75>:
        break;
8000f2d4:	0001                	nop
8000f2d6:	a011                	j	8000f2da <.L69>

8000f2d8 <.L76>:
        break;
8000f2d8:	0001                	nop

8000f2da <.L69>:
    return status_success;
8000f2da:	4781                	li	a5,0

8000f2dc <.L61>:
}
8000f2dc:	853e                	mv	a0,a5
8000f2de:	50b2                	lw	ra,44(sp)
8000f2e0:	6145                	add	sp,sp,48
8000f2e2:	8082                	ret

Disassembly of section .text.enable_plic_feature:

8000f2e4 <enable_plic_feature>:
{
8000f2e4:	1141                	add	sp,sp,-16
    uint32_t plic_feature = 0;
8000f2e6:	c602                	sw	zero,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_VECTORED_MODE;
8000f2e8:	47b2                	lw	a5,12(sp)
8000f2ea:	0027e793          	or	a5,a5,2
8000f2ee:	c63e                	sw	a5,12(sp)
    plic_feature |= HPM_PLIC_FEATURE_PREEMPTIVE_PRIORITY_IRQ;
8000f2f0:	47b2                	lw	a5,12(sp)
8000f2f2:	0017e793          	or	a5,a5,1
8000f2f6:	c63e                	sw	a5,12(sp)
8000f2f8:	e40007b7          	lui	a5,0xe4000
8000f2fc:	c43e                	sw	a5,8(sp)
8000f2fe:	47b2                	lw	a5,12(sp)
8000f300:	c23e                	sw	a5,4(sp)

8000f302 <.LBB14>:
 * @param[in] feature Specific feature to be set
 *
 */
ATTR_ALWAYS_INLINE static inline void __plic_set_feature(uint32_t base, uint32_t feature)
{
    *(volatile uint32_t *)(base + HPM_PLIC_FEATURE_OFFSET) = feature;
8000f302:	47a2                	lw	a5,8(sp)
8000f304:	4712                	lw	a4,4(sp)
8000f306:	c398                	sw	a4,0(a5)
}
8000f308:	0001                	nop

8000f30a <.LBE14>:
}
8000f30a:	0001                	nop
8000f30c:	0141                	add	sp,sp,16
8000f30e:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_puts_no_nl:

8000f310 <__SEGGER_RTL_puts_no_nl>:
8000f310:	1101                	add	sp,sp,-32
8000f312:	cc22                	sw	s0,24(sp)
8000f314:	85022403          	lw	s0,-1968(tp) # fffff850 <__APB_SRAM_segment_end__+0xbf0d850>
8000f318:	ce06                	sw	ra,28(sp)
8000f31a:	c62a                	sw	a0,12(sp)
8000f31c:	301000ef          	jal	8000fe1c <strlen>
8000f320:	862a                	mv	a2,a0
8000f322:	8522                	mv	a0,s0
8000f324:	4462                	lw	s0,24(sp)
8000f326:	45b2                	lw	a1,12(sp)
8000f328:	40f2                	lw	ra,28(sp)
8000f32a:	6105                	add	sp,sp,32
8000f32c:	fbbfd06f          	j	8000d2e6 <__SEGGER_RTL_X_file_write>

Disassembly of section .text.libc.signal:

8000f330 <signal>:
8000f330:	4795                	li	a5,5
8000f332:	02a7e063          	bltu	a5,a0,8000f352 <.L18>
8000f336:	81420693          	add	a3,tp,-2028 # fffff814 <__APB_SRAM_segment_end__+0xbf0d814>
8000f33a:	00251793          	sll	a5,a0,0x2
8000f33e:	96be                	add	a3,a3,a5
8000f340:	4288                	lw	a0,0(a3)
8000f342:	81420713          	add	a4,tp,-2028 # fffff814 <__APB_SRAM_segment_end__+0xbf0d814>
8000f346:	e119                	bnez	a0,8000f34c <.L17>
8000f348:	56e18513          	add	a0,gp,1390 # 800098da <__SEGGER_RTL_SIGNAL_SIG_DFL>

8000f34c <.L17>:
8000f34c:	973e                	add	a4,a4,a5
8000f34e:	c30c                	sw	a1,0(a4)
8000f350:	8082                	ret

8000f352 <.L18>:
8000f352:	8000c537          	lui	a0,0x8000c
8000f356:	b0650513          	add	a0,a0,-1274 # 8000bb06 <__SEGGER_RTL_SIGNAL_SIG_ERR>
8000f35a:	8082                	ret

Disassembly of section .text.libc.raise:

8000f35c <raise>:
8000f35c:	1141                	add	sp,sp,-16
8000f35e:	c04a                	sw	s2,0(sp)
8000f360:	61e18593          	add	a1,gp,1566 # 8000998a <__SEGGER_RTL_SIGNAL_SIG_IGN>
8000f364:	c226                	sw	s1,4(sp)
8000f366:	c606                	sw	ra,12(sp)
8000f368:	c422                	sw	s0,8(sp)
8000f36a:	84aa                	mv	s1,a0
8000f36c:	37d1                	jal	8000f330 <signal>
8000f36e:	8000c7b7          	lui	a5,0x8000c
8000f372:	b0678793          	add	a5,a5,-1274 # 8000bb06 <__SEGGER_RTL_SIGNAL_SIG_ERR>
8000f376:	02f50b63          	beq	a0,a5,8000f3ac <.L24>
8000f37a:	61e18913          	add	s2,gp,1566 # 8000998a <__SEGGER_RTL_SIGNAL_SIG_IGN>
8000f37e:	842a                	mv	s0,a0
8000f380:	01250f63          	beq	a0,s2,8000f39e <.L22>
8000f384:	56e18793          	add	a5,gp,1390 # 800098da <__SEGGER_RTL_SIGNAL_SIG_DFL>
8000f388:	00f51563          	bne	a0,a5,8000f392 <.L23>
8000f38c:	4505                	li	a0,1
8000f38e:	ceff30ef          	jal	8000307c <exit>

8000f392 <.L23>:
8000f392:	56e18593          	add	a1,gp,1390 # 800098da <__SEGGER_RTL_SIGNAL_SIG_DFL>
8000f396:	8526                	mv	a0,s1
8000f398:	3f61                	jal	8000f330 <signal>
8000f39a:	8526                	mv	a0,s1
8000f39c:	9402                	jalr	s0

8000f39e <.L22>:
8000f39e:	4501                	li	a0,0

8000f3a0 <.L20>:
8000f3a0:	40b2                	lw	ra,12(sp)
8000f3a2:	4422                	lw	s0,8(sp)
8000f3a4:	4492                	lw	s1,4(sp)
8000f3a6:	4902                	lw	s2,0(sp)
8000f3a8:	0141                	add	sp,sp,16
8000f3aa:	8082                	ret

8000f3ac <.L24>:
8000f3ac:	557d                	li	a0,-1
8000f3ae:	bfcd                	j	8000f3a0 <.L20>

Disassembly of section .text.libc.abort:

8000f3b0 <abort>:
8000f3b0:	1141                	add	sp,sp,-16
8000f3b2:	c606                	sw	ra,12(sp)

8000f3b4 <.L27>:
8000f3b4:	4501                	li	a0,0
8000f3b6:	375d                	jal	8000f35c <raise>
8000f3b8:	bff5                	j	8000f3b4 <.L27>

Disassembly of section .text.libc.__SEGGER_RTL_X_assert:

8000f3ba <__SEGGER_RTL_X_assert>:
8000f3ba:	1101                	add	sp,sp,-32
8000f3bc:	cc22                	sw	s0,24(sp)
8000f3be:	ca26                	sw	s1,20(sp)
8000f3c0:	842a                	mv	s0,a0
8000f3c2:	84ae                	mv	s1,a1
8000f3c4:	8532                	mv	a0,a2
8000f3c6:	858a                	mv	a1,sp
8000f3c8:	4629                	li	a2,10
8000f3ca:	ce06                	sw	ra,28(sp)
8000f3cc:	f1efc0ef          	jal	8000baea <itoa>
8000f3d0:	8526                	mv	a0,s1
8000f3d2:	3f3d                	jal	8000f310 <__SEGGER_RTL_puts_no_nl>
8000f3d4:	57018513          	add	a0,gp,1392 # 800098dc <.LC0>
8000f3d8:	3f25                	jal	8000f310 <__SEGGER_RTL_puts_no_nl>
8000f3da:	850a                	mv	a0,sp
8000f3dc:	3f15                	jal	8000f310 <__SEGGER_RTL_puts_no_nl>
8000f3de:	57418513          	add	a0,gp,1396 # 800098e0 <.LC1>
8000f3e2:	373d                	jal	8000f310 <__SEGGER_RTL_puts_no_nl>
8000f3e4:	8522                	mv	a0,s0
8000f3e6:	372d                	jal	8000f310 <__SEGGER_RTL_puts_no_nl>
8000f3e8:	58c18513          	add	a0,gp,1420 # 800098f8 <.LC2>
8000f3ec:	3715                	jal	8000f310 <__SEGGER_RTL_puts_no_nl>
8000f3ee:	37c9                	jal	8000f3b0 <abort>

Disassembly of section .text.libc.__adddf3:

8000f3f0 <__adddf3>:
8000f3f0:	800007b7          	lui	a5,0x80000
8000f3f4:	00d5c8b3          	xor	a7,a1,a3
8000f3f8:	1008c263          	bltz	a7,8000f4fc <.L__adddf3_subtract>
8000f3fc:	00b6e863          	bltu	a3,a1,8000f40c <.L__adddf3_add_already_ordered>
8000f400:	8d31                	xor	a0,a0,a2
8000f402:	8e29                	xor	a2,a2,a0
8000f404:	8d31                	xor	a0,a0,a2
8000f406:	8db5                	xor	a1,a1,a3
8000f408:	8ead                	xor	a3,a3,a1
8000f40a:	8db5                	xor	a1,a1,a3

8000f40c <.L__adddf3_add_already_ordered>:
8000f40c:	00159813          	sll	a6,a1,0x1
8000f410:	01585813          	srl	a6,a6,0x15
8000f414:	00169893          	sll	a7,a3,0x1
8000f418:	0158d893          	srl	a7,a7,0x15
8000f41c:	0c088063          	beqz	a7,8000f4dc <.L__adddf3_add_zero>
8000f420:	00180713          	add	a4,a6,1
8000f424:	0756                	sll	a4,a4,0x15
8000f426:	c759                	beqz	a4,8000f4b4 <.L__adddf3_done>
8000f428:	41180733          	sub	a4,a6,a7
8000f42c:	03500293          	li	t0,53
8000f430:	08e2e263          	bltu	t0,a4,8000f4b4 <.L__adddf3_done>
8000f434:	0145d813          	srl	a6,a1,0x14
8000f438:	06ae                	sll	a3,a3,0xb
8000f43a:	8edd                	or	a3,a3,a5
8000f43c:	82ad                	srl	a3,a3,0xb
8000f43e:	05ae                	sll	a1,a1,0xb
8000f440:	8ddd                	or	a1,a1,a5
8000f442:	85ad                	sra	a1,a1,0xb
8000f444:	02000293          	li	t0,32
8000f448:	06577763          	bgeu	a4,t0,8000f4b6 <.L__adddf3_add_shifted_word>
8000f44c:	4881                	li	a7,0
8000f44e:	cf01                	beqz	a4,8000f466 <.L__adddf3_add_no_shift>
8000f450:	40e002b3          	neg	t0,a4
8000f454:	005618b3          	sll	a7,a2,t0
8000f458:	00e65633          	srl	a2,a2,a4
8000f45c:	005692b3          	sll	t0,a3,t0
8000f460:	9616                	add	a2,a2,t0
8000f462:	00e6d6b3          	srl	a3,a3,a4

8000f466 <.L__adddf3_add_no_shift>:
8000f466:	9532                	add	a0,a0,a2
8000f468:	00c532b3          	sltu	t0,a0,a2
8000f46c:	95b6                	add	a1,a1,a3
8000f46e:	00d5b333          	sltu	t1,a1,a3
8000f472:	9596                	add	a1,a1,t0
8000f474:	00031463          	bnez	t1,8000f47c <.L__adddf3_normalization_required>
8000f478:	0255f163          	bgeu	a1,t0,8000f49a <.L__adddf3_already_normalized>

8000f47c <.L__adddf3_normalization_required>:
8000f47c:	00280613          	add	a2,a6,2
8000f480:	0656                	sll	a2,a2,0x15
8000f482:	c235                	beqz	a2,8000f4e6 <.L__adddf3_inf>
8000f484:	01f51613          	sll	a2,a0,0x1f
8000f488:	011032b3          	snez	t0,a7
8000f48c:	005608b3          	add	a7,a2,t0
8000f490:	8105                	srl	a0,a0,0x1
8000f492:	01f59693          	sll	a3,a1,0x1f
8000f496:	8d55                	or	a0,a0,a3
8000f498:	8185                	srl	a1,a1,0x1

8000f49a <.L__adddf3_already_normalized>:
8000f49a:	0805                	add	a6,a6,1
8000f49c:	0852                	sll	a6,a6,0x14

8000f49e <.L__adddf3_perform_rounding>:
8000f49e:	0008da63          	bgez	a7,8000f4b2 <.L__adddf3_add_no_tie>
8000f4a2:	0505                	add	a0,a0,1
8000f4a4:	00153293          	seqz	t0,a0
8000f4a8:	9596                	add	a1,a1,t0
8000f4aa:	0886                	sll	a7,a7,0x1
8000f4ac:	00089363          	bnez	a7,8000f4b2 <.L__adddf3_add_no_tie>
8000f4b0:	9979                	and	a0,a0,-2

8000f4b2 <.L__adddf3_add_no_tie>:
8000f4b2:	95c2                	add	a1,a1,a6

8000f4b4 <.L__adddf3_done>:
8000f4b4:	8082                	ret

8000f4b6 <.L__adddf3_add_shifted_word>:
8000f4b6:	88b2                	mv	a7,a2
8000f4b8:	1701                	add	a4,a4,-32 # f3ffffe0 <__AHB_SRAM_segment_end__+0x3cf7fe0>
8000f4ba:	cb11                	beqz	a4,8000f4ce <.L__adddf3_already_aligned>
8000f4bc:	40e008b3          	neg	a7,a4
8000f4c0:	011698b3          	sll	a7,a3,a7
8000f4c4:	00e6d6b3          	srl	a3,a3,a4
8000f4c8:	00c03733          	snez	a4,a2
8000f4cc:	98ba                	add	a7,a7,a4

8000f4ce <.L__adddf3_already_aligned>:
8000f4ce:	9536                	add	a0,a0,a3
8000f4d0:	00d532b3          	sltu	t0,a0,a3
8000f4d4:	9596                	add	a1,a1,t0
8000f4d6:	fc55f2e3          	bgeu	a1,t0,8000f49a <.L__adddf3_already_normalized>
8000f4da:	b74d                	j	8000f47c <.L__adddf3_normalization_required>

8000f4dc <.L__adddf3_add_zero>:
8000f4dc:	fc081ce3          	bnez	a6,8000f4b4 <.L__adddf3_done>
8000f4e0:	8dfd                	and	a1,a1,a5
8000f4e2:	4501                	li	a0,0
8000f4e4:	bfc1                	j	8000f4b4 <.L__adddf3_done>

8000f4e6 <.L__adddf3_inf>:
8000f4e6:	0805                	add	a6,a6,1
8000f4e8:	01481593          	sll	a1,a6,0x14
8000f4ec:	4501                	li	a0,0
8000f4ee:	b7d9                	j	8000f4b4 <.L__adddf3_done>

8000f4f0 <.L__adddf3_sub_inf_nan>:
8000f4f0:	fce892e3          	bne	a7,a4,8000f4b4 <.L__adddf3_done>
8000f4f4:	7ff805b7          	lui	a1,0x7ff80
8000f4f8:	4501                	li	a0,0
8000f4fa:	bf6d                	j	8000f4b4 <.L__adddf3_done>

8000f4fc <.L__adddf3_subtract>:
8000f4fc:	8ebd                	xor	a3,a3,a5
8000f4fe:	00b6ed63          	bltu	a3,a1,8000f518 <.L__adddf3_sub_already_ordered>
8000f502:	00b69463          	bne	a3,a1,8000f50a <.L__adddf3_sub_must_exchange>
8000f506:	00a66963          	bltu	a2,a0,8000f518 <.L__adddf3_sub_already_ordered>

8000f50a <.L__adddf3_sub_must_exchange>:
8000f50a:	8ebd                	xor	a3,a3,a5
8000f50c:	8d31                	xor	a0,a0,a2
8000f50e:	8e29                	xor	a2,a2,a0
8000f510:	8d31                	xor	a0,a0,a2
8000f512:	8db5                	xor	a1,a1,a3
8000f514:	8ead                	xor	a3,a3,a1
8000f516:	8db5                	xor	a1,a1,a3

8000f518 <.L__adddf3_sub_already_ordered>:
8000f518:	00b58833          	add	a6,a1,a1
8000f51c:	00d688b3          	add	a7,a3,a3
8000f520:	ffe00737          	lui	a4,0xffe00
8000f524:	fce876e3          	bgeu	a6,a4,8000f4f0 <.L__adddf3_sub_inf_nan>
8000f528:	01585813          	srl	a6,a6,0x15
8000f52c:	0158d893          	srl	a7,a7,0x15
8000f530:	0a088f63          	beqz	a7,8000f5ee <.L__adddf3_subtracting_zero>
8000f534:	41180733          	sub	a4,a6,a7
8000f538:	03600293          	li	t0,54
8000f53c:	f6e2ece3          	bltu	t0,a4,8000f4b4 <.L__adddf3_done>
8000f540:	83c2                	mv	t2,a6
8000f542:	0145d813          	srl	a6,a1,0x14
8000f546:	06ae                	sll	a3,a3,0xb
8000f548:	8edd                	or	a3,a3,a5
8000f54a:	82ad                	srl	a3,a3,0xb
8000f54c:	05ae                	sll	a1,a1,0xb
8000f54e:	8ddd                	or	a1,a1,a5
8000f550:	81ad                	srl	a1,a1,0xb
8000f552:	4285                	li	t0,1
8000f554:	0ae2ef63          	bltu	t0,a4,8000f612 <.L__adddf3_sub_align_far>
8000f558:	00571a63          	bne	a4,t0,8000f56c <.L__adddf3_sub_already_aligned>
8000f55c:	01f61713          	sll	a4,a2,0x1f
8000f560:	8205                	srl	a2,a2,0x1
8000f562:	01f69893          	sll	a7,a3,0x1f
8000f566:	01166633          	or	a2,a2,a7
8000f56a:	8285                	srl	a3,a3,0x1

8000f56c <.L__adddf3_sub_already_aligned>:
8000f56c:	82aa                	mv	t0,a0
8000f56e:	8d11                	sub	a0,a0,a2
8000f570:	00a2b2b3          	sltu	t0,t0,a0
8000f574:	8d95                	sub	a1,a1,a3
8000f576:	405585b3          	sub	a1,a1,t0
8000f57a:	c711                	beqz	a4,8000f586 <.L__adddf3_sub_single_done>
8000f57c:	00153293          	seqz	t0,a0
8000f580:	157d                	add	a0,a0,-1
8000f582:	405585b3          	sub	a1,a1,t0

8000f586 <.L__adddf3_sub_single_done>:
8000f586:	c9ad                	beqz	a1,8000f5f8 <.L__adddf3_high_word_cancelled>
8000f588:	00b59293          	sll	t0,a1,0xb
8000f58c:	1202ca63          	bltz	t0,8000f6c0 <.L__adddf3_sub_normalized>

8000f590 <.L__adddf3_first_normalization_step>:
8000f590:	000522b3          	sltz	t0,a0
8000f594:	952a                	add	a0,a0,a0
8000f596:	95ae                	add	a1,a1,a1
8000f598:	9596                	add	a1,a1,t0
8000f59a:	837d                	srl	a4,a4,0x1f
8000f59c:	953a                	add	a0,a0,a4
8000f59e:	4705                	li	a4,1

8000f5a0 <.L__adddf3_try_shift_4>:
8000f5a0:	0115d293          	srl	t0,a1,0x11
8000f5a4:	00029963          	bnez	t0,8000f5b6 <.L__adddf3_cant_shift_4>
8000f5a8:	0711                	add	a4,a4,4 # ffe00004 <__APB_SRAM_segment_end__+0xbd0e004>
8000f5aa:	0592                	sll	a1,a1,0x4
8000f5ac:	01c55293          	srl	t0,a0,0x1c
8000f5b0:	0512                	sll	a0,a0,0x4
8000f5b2:	9596                	add	a1,a1,t0
8000f5b4:	b7f5                	j	8000f5a0 <.L__adddf3_try_shift_4>

8000f5b6 <.L__adddf3_cant_shift_4>:
8000f5b6:	00b59293          	sll	t0,a1,0xb
8000f5ba:	0002cc63          	bltz	t0,8000f5d2 <.L__adddf3_normalized>

8000f5be <.L__adddf3_normalize>:
8000f5be:	0705                	add	a4,a4,1
8000f5c0:	000522b3          	sltz	t0,a0
8000f5c4:	952a                	add	a0,a0,a0
8000f5c6:	95ae                	add	a1,a1,a1
8000f5c8:	9596                	add	a1,a1,t0

8000f5ca <.L__adddf3_pre_normalize>:
8000f5ca:	00b59293          	sll	t0,a1,0xb
8000f5ce:	fe02d8e3          	bgez	t0,8000f5be <.L__adddf3_normalize>

8000f5d2 <.L__adddf3_normalized>:
8000f5d2:	861e                	mv	a2,t2
8000f5d4:	00c77863          	bgeu	a4,a2,8000f5e4 <.L__adddf3_signed_zero>
8000f5d8:	40e80833          	sub	a6,a6,a4
8000f5dc:	187d                	add	a6,a6,-1
8000f5de:	0852                	sll	a6,a6,0x14
8000f5e0:	95c2                	add	a1,a1,a6
8000f5e2:	bdc9                	j	8000f4b4 <.L__adddf3_done>

8000f5e4 <.L__adddf3_signed_zero>:
8000f5e4:	00b85593          	srl	a1,a6,0xb
8000f5e8:	05fe                	sll	a1,a1,0x1f
8000f5ea:	4501                	li	a0,0
8000f5ec:	b5e1                	j	8000f4b4 <.L__adddf3_done>

8000f5ee <.L__adddf3_subtracting_zero>:
8000f5ee:	ec0813e3          	bnez	a6,8000f4b4 <.L__adddf3_done>
8000f5f2:	4501                	li	a0,0
8000f5f4:	4581                	li	a1,0
8000f5f6:	bd7d                	j	8000f4b4 <.L__adddf3_done>

8000f5f8 <.L__adddf3_high_word_cancelled>:
8000f5f8:	00e56633          	or	a2,a0,a4
8000f5fc:	ea060ce3          	beqz	a2,8000f4b4 <.L__adddf3_done>
8000f600:	001008b7          	lui	a7,0x100
8000f604:	f91576e3          	bgeu	a0,a7,8000f590 <.L__adddf3_first_normalization_step>
8000f608:	85aa                	mv	a1,a0
8000f60a:	853a                	mv	a0,a4
8000f60c:	02000713          	li	a4,32
8000f610:	bf6d                	j	8000f5ca <.L__adddf3_pre_normalize>

8000f612 <.L__adddf3_sub_align_far>:
8000f612:	02000293          	li	t0,32
8000f616:	04574863          	blt	a4,t0,8000f666 <.L__adddf3_aligned_on_top>
8000f61a:	04570263          	beq	a4,t0,8000f65e <.L__adddf3_word_aligned_on_top>
8000f61e:	1701                	add	a4,a4,-32
8000f620:	40e002b3          	neg	t0,a4
8000f624:	00e65333          	srl	t1,a2,a4
8000f628:	005618b3          	sll	a7,a2,t0
8000f62c:	00569633          	sll	a2,a3,t0
8000f630:	961a                	add	a2,a2,t1
8000f632:	00e6d6b3          	srl	a3,a3,a4
8000f636:	011038b3          	snez	a7,a7
8000f63a:	00c8e8b3          	or	a7,a7,a2
8000f63e:	4601                	li	a2,0
8000f640:	82aa                	mv	t0,a0
8000f642:	8d15                	sub	a0,a0,a3
8000f644:	00a2b2b3          	sltu	t0,t0,a0
8000f648:	405585b3          	sub	a1,a1,t0
8000f64c:	41100733          	neg	a4,a7
8000f650:	c729                	beqz	a4,8000f69a <.L__adddf3_sub_normalize>
8000f652:	00153293          	seqz	t0,a0
8000f656:	157d                	add	a0,a0,-1
8000f658:	405585b3          	sub	a1,a1,t0
8000f65c:	a83d                	j	8000f69a <.L__adddf3_sub_normalize>

8000f65e <.L__adddf3_word_aligned_on_top>:
8000f65e:	88b2                	mv	a7,a2
8000f660:	8636                	mv	a2,a3
8000f662:	4681                	li	a3,0
8000f664:	a821                	j	8000f67c <.L__adddf3_aligned_subtract>

8000f666 <.L__adddf3_aligned_on_top>:
8000f666:	40e002b3          	neg	t0,a4
8000f66a:	00e65333          	srl	t1,a2,a4
8000f66e:	005618b3          	sll	a7,a2,t0
8000f672:	00569633          	sll	a2,a3,t0
8000f676:	961a                	add	a2,a2,t1
8000f678:	00e6d6b3          	srl	a3,a3,a4

8000f67c <.L__adddf3_aligned_subtract>:
8000f67c:	82aa                	mv	t0,a0
8000f67e:	8d11                	sub	a0,a0,a2
8000f680:	00a2b2b3          	sltu	t0,t0,a0
8000f684:	8d95                	sub	a1,a1,a3
8000f686:	405585b3          	sub	a1,a1,t0
8000f68a:	41100733          	neg	a4,a7
8000f68e:	c711                	beqz	a4,8000f69a <.L__adddf3_sub_normalize>
8000f690:	00153293          	seqz	t0,a0
8000f694:	157d                	add	a0,a0,-1
8000f696:	405585b3          	sub	a1,a1,t0

8000f69a <.L__adddf3_sub_normalize>:
8000f69a:	00c59893          	sll	a7,a1,0xc
8000f69e:	00b59293          	sll	t0,a1,0xb
8000f6a2:	0002cf63          	bltz	t0,8000f6c0 <.L__adddf3_sub_normalized>
8000f6a6:	187d                	add	a6,a6,-1
8000f6a8:	000522b3          	sltz	t0,a0
8000f6ac:	952a                	add	a0,a0,a0
8000f6ae:	95ae                	add	a1,a1,a1
8000f6b0:	9596                	add	a1,a1,t0
8000f6b2:	000722b3          	sltz	t0,a4
8000f6b6:	973a                	add	a4,a4,a4
8000f6b8:	9516                	add	a0,a0,t0
8000f6ba:	005532b3          	sltu	t0,a0,t0
8000f6be:	9596                	add	a1,a1,t0

8000f6c0 <.L__adddf3_sub_normalized>:
8000f6c0:	187d                	add	a6,a6,-1
8000f6c2:	0852                	sll	a6,a6,0x14
8000f6c4:	88ba                	mv	a7,a4
8000f6c6:	bbe1                	j	8000f49e <.L__adddf3_perform_rounding>

Disassembly of section .text.libc.__mulsf3:

8000f6c8 <__mulsf3>:
8000f6c8:	80000737          	lui	a4,0x80000
8000f6cc:	0ff00293          	li	t0,255
8000f6d0:	00b547b3          	xor	a5,a0,a1
8000f6d4:	8ff9                	and	a5,a5,a4
8000f6d6:	00151613          	sll	a2,a0,0x1
8000f6da:	8261                	srl	a2,a2,0x18
8000f6dc:	00159693          	sll	a3,a1,0x1
8000f6e0:	82e1                	srl	a3,a3,0x18
8000f6e2:	ce29                	beqz	a2,8000f73c <.L__mulsf3_lhs_zero_or_subnormal>
8000f6e4:	c6bd                	beqz	a3,8000f752 <.L__mulsf3_rhs_zero_or_subnormal>
8000f6e6:	04560f63          	beq	a2,t0,8000f744 <.L__mulsf3_lhs_inf_or_nan>
8000f6ea:	06568963          	beq	a3,t0,8000f75c <.L__mulsf3_rhs_inf_or_nan>
8000f6ee:	9636                	add	a2,a2,a3
8000f6f0:	0522                	sll	a0,a0,0x8
8000f6f2:	8d59                	or	a0,a0,a4
8000f6f4:	05a2                	sll	a1,a1,0x8
8000f6f6:	8dd9                	or	a1,a1,a4
8000f6f8:	02b506b3          	mul	a3,a0,a1
8000f6fc:	02b53533          	mulhu	a0,a0,a1
8000f700:	00d036b3          	snez	a3,a3
8000f704:	8d55                	or	a0,a0,a3
8000f706:	00054463          	bltz	a0,8000f70e <.L__mulsf3_normalized>
8000f70a:	0506                	sll	a0,a0,0x1
8000f70c:	167d                	add	a2,a2,-1

8000f70e <.L__mulsf3_normalized>:
8000f70e:	f8160613          	add	a2,a2,-127
8000f712:	04064863          	bltz	a2,8000f762 <.L__mulsf3_zero_or_underflow>
8000f716:	12fd                	add	t0,t0,-1 # ffffffff <__APB_SRAM_segment_end__+0xbf0dfff>
8000f718:	00565f63          	bge	a2,t0,8000f736 <.L__mulsf3_inf>
8000f71c:	01851693          	sll	a3,a0,0x18
8000f720:	8121                	srl	a0,a0,0x8
8000f722:	065e                	sll	a2,a2,0x17
8000f724:	9532                	add	a0,a0,a2
8000f726:	0006d663          	bgez	a3,8000f732 <.L__mulsf3_apply_sign>
8000f72a:	0505                	add	a0,a0,1
8000f72c:	0686                	sll	a3,a3,0x1
8000f72e:	e291                	bnez	a3,8000f732 <.L__mulsf3_apply_sign>
8000f730:	9979                	and	a0,a0,-2

8000f732 <.L__mulsf3_apply_sign>:
8000f732:	8d5d                	or	a0,a0,a5
8000f734:	8082                	ret

8000f736 <.L__mulsf3_inf>:
8000f736:	7f800537          	lui	a0,0x7f800
8000f73a:	bfe5                	j	8000f732 <.L__mulsf3_apply_sign>

8000f73c <.L__mulsf3_lhs_zero_or_subnormal>:
8000f73c:	00568d63          	beq	a3,t0,8000f756 <.L__mulsf3_nan>

8000f740 <.L__mulsf3_signed_zero>:
8000f740:	853e                	mv	a0,a5
8000f742:	8082                	ret

8000f744 <.L__mulsf3_lhs_inf_or_nan>:
8000f744:	0526                	sll	a0,a0,0x9
8000f746:	e901                	bnez	a0,8000f756 <.L__mulsf3_nan>
8000f748:	fe5697e3          	bne	a3,t0,8000f736 <.L__mulsf3_inf>
8000f74c:	05a6                	sll	a1,a1,0x9
8000f74e:	e581                	bnez	a1,8000f756 <.L__mulsf3_nan>
8000f750:	b7dd                	j	8000f736 <.L__mulsf3_inf>

8000f752 <.L__mulsf3_rhs_zero_or_subnormal>:
8000f752:	fe5617e3          	bne	a2,t0,8000f740 <.L__mulsf3_signed_zero>

8000f756 <.L__mulsf3_nan>:
8000f756:	7fc00537          	lui	a0,0x7fc00
8000f75a:	8082                	ret

8000f75c <.L__mulsf3_rhs_inf_or_nan>:
8000f75c:	05a6                	sll	a1,a1,0x9
8000f75e:	fde5                	bnez	a1,8000f756 <.L__mulsf3_nan>
8000f760:	bfd9                	j	8000f736 <.L__mulsf3_inf>

8000f762 <.L__mulsf3_zero_or_underflow>:
8000f762:	0605                	add	a2,a2,1
8000f764:	fe71                	bnez	a2,8000f740 <.L__mulsf3_signed_zero>
8000f766:	8521                	sra	a0,a0,0x8
8000f768:	00150293          	add	t0,a0,1 # 7fc00001 <__NONCACHEABLE_RAM_segment_end__+0x3ec00001>
8000f76c:	0509                	add	a0,a0,2
8000f76e:	fc0299e3          	bnez	t0,8000f740 <.L__mulsf3_signed_zero>
8000f772:	00800537          	lui	a0,0x800
8000f776:	bf75                	j	8000f732 <.L__mulsf3_apply_sign>

Disassembly of section .text.libc.__muldf3:

8000f778 <__muldf3>:
8000f778:	800008b7          	lui	a7,0x80000
8000f77c:	00d5c833          	xor	a6,a1,a3
8000f780:	01187eb3          	and	t4,a6,a7
8000f784:	00b58733          	add	a4,a1,a1
8000f788:	00d687b3          	add	a5,a3,a3
8000f78c:	ffe00837          	lui	a6,0xffe00
8000f790:	0d077363          	bgeu	a4,a6,8000f856 <.L__muldf3_lhs_nan_or_inf>
8000f794:	0d07ff63          	bgeu	a5,a6,8000f872 <.L__muldf3_rhs_nan_or_inf>
8000f798:	8355                	srl	a4,a4,0x15
8000f79a:	c76d                	beqz	a4,8000f884 <.L__muldf3_signed_zero>
8000f79c:	83d5                	srl	a5,a5,0x15
8000f79e:	c3fd                	beqz	a5,8000f884 <.L__muldf3_signed_zero>
8000f7a0:	06ae                	sll	a3,a3,0xb
8000f7a2:	0116e6b3          	or	a3,a3,a7
8000f7a6:	82ad                	srl	a3,a3,0xb
8000f7a8:	05ae                	sll	a1,a1,0xb
8000f7aa:	0115e5b3          	or	a1,a1,a7
8000f7ae:	01555813          	srl	a6,a0,0x15
8000f7b2:	052e                	sll	a0,a0,0xb
8000f7b4:	010582b3          	add	t0,a1,a6
8000f7b8:	00f70333          	add	t1,a4,a5
8000f7bc:	02c50733          	mul	a4,a0,a2
8000f7c0:	02c537b3          	mulhu	a5,a0,a2
8000f7c4:	02d50833          	mul	a6,a0,a3
8000f7c8:	02d538b3          	mulhu	a7,a0,a3
8000f7cc:	983e                	add	a6,a6,a5
8000f7ce:	00f837b3          	sltu	a5,a6,a5
8000f7d2:	98be                	add	a7,a7,a5
8000f7d4:	02c28533          	mul	a0,t0,a2
8000f7d8:	02c2b5b3          	mulhu	a1,t0,a2
8000f7dc:	982a                	add	a6,a6,a0
8000f7de:	00a83533          	sltu	a0,a6,a0
8000f7e2:	98ae                	add	a7,a7,a1
8000f7e4:	00b8b5b3          	sltu	a1,a7,a1
8000f7e8:	98aa                	add	a7,a7,a0
8000f7ea:	00a8b533          	sltu	a0,a7,a0
8000f7ee:	00b50633          	add	a2,a0,a1
8000f7f2:	02d28533          	mul	a0,t0,a3
8000f7f6:	02d2b5b3          	mulhu	a1,t0,a3
8000f7fa:	9546                	add	a0,a0,a7
8000f7fc:	011538b3          	sltu	a7,a0,a7
8000f800:	95c6                	add	a1,a1,a7
8000f802:	95b2                	add	a1,a1,a2
8000f804:	00e03733          	snez	a4,a4
8000f808:	00e86833          	or	a6,a6,a4
8000f80c:	871a                	mv	a4,t1
8000f80e:	00b59293          	sll	t0,a1,0xb
8000f812:	0002cc63          	bltz	t0,8000f82a <.L__muldf3_normalized>
8000f816:	000822b3          	sltz	t0,a6
8000f81a:	9842                	add	a6,a6,a6
8000f81c:	00052333          	sltz	t1,a0
8000f820:	952a                	add	a0,a0,a0
8000f822:	9516                	add	a0,a0,t0
8000f824:	95ae                	add	a1,a1,a1
8000f826:	959a                	add	a1,a1,t1
8000f828:	177d                	add	a4,a4,-1 # 7fffffff <__NONCACHEABLE_RAM_segment_end__+0x3effffff>

8000f82a <.L__muldf3_normalized>:
8000f82a:	3ff00793          	li	a5,1023
8000f82e:	8f1d                	sub	a4,a4,a5
8000f830:	04074a63          	bltz	a4,8000f884 <.L__muldf3_signed_zero>
8000f834:	0786                	sll	a5,a5,0x1
8000f836:	04f75363          	bge	a4,a5,8000f87c <.L__muldf3_inf>
8000f83a:	0752                	sll	a4,a4,0x14
8000f83c:	95ba                	add	a1,a1,a4
8000f83e:	00085a63          	bgez	a6,8000f852 <.L__muldf3_apply_sign>
8000f842:	0505                	add	a0,a0,1 # 800001 <_flash_size+0x1>
8000f844:	00153613          	seqz	a2,a0
8000f848:	95b2                	add	a1,a1,a2
8000f84a:	0806                	sll	a6,a6,0x1
8000f84c:	00081363          	bnez	a6,8000f852 <.L__muldf3_apply_sign>
8000f850:	9979                	and	a0,a0,-2

8000f852 <.L__muldf3_apply_sign>:
8000f852:	95f6                	add	a1,a1,t4
8000f854:	8082                	ret

8000f856 <.L__muldf3_lhs_nan_or_inf>:
8000f856:	01071a63          	bne	a4,a6,8000f86a <.L__muldf3_nan>
8000f85a:	e901                	bnez	a0,8000f86a <.L__muldf3_nan>
8000f85c:	00f86763          	bltu	a6,a5,8000f86a <.L__muldf3_nan>
8000f860:	0107e363          	bltu	a5,a6,8000f866 <.L__muldf3_rhs_could_be_zero>
8000f864:	e219                	bnez	a2,8000f86a <.L__muldf3_nan>

8000f866 <.L__muldf3_rhs_could_be_zero>:
8000f866:	83d5                	srl	a5,a5,0x15
8000f868:	eb91                	bnez	a5,8000f87c <.L__muldf3_inf>

8000f86a <.L__muldf3_nan>:
8000f86a:	7ff805b7          	lui	a1,0x7ff80

8000f86e <.L__muldf3_load_zero_lo>:
8000f86e:	4501                	li	a0,0
8000f870:	8082                	ret

8000f872 <.L__muldf3_rhs_nan_or_inf>:
8000f872:	ff079ce3          	bne	a5,a6,8000f86a <.L__muldf3_nan>
8000f876:	fa75                	bnez	a2,8000f86a <.L__muldf3_nan>
8000f878:	8355                	srl	a4,a4,0x15
8000f87a:	db65                	beqz	a4,8000f86a <.L__muldf3_nan>

8000f87c <.L__muldf3_inf>:
8000f87c:	7ff005b7          	lui	a1,0x7ff00
8000f880:	4501                	li	a0,0
8000f882:	bfc1                	j	8000f852 <.L__muldf3_apply_sign>

8000f884 <.L__muldf3_signed_zero>:
8000f884:	85f6                	mv	a1,t4
8000f886:	b7e5                	j	8000f86e <.L__muldf3_load_zero_lo>

Disassembly of section .text.libc.__divsf3:

8000f888 <__divsf3>:
8000f888:	0ff00293          	li	t0,255
8000f88c:	00151713          	sll	a4,a0,0x1
8000f890:	8361                	srl	a4,a4,0x18
8000f892:	00159793          	sll	a5,a1,0x1
8000f896:	83e1                	srl	a5,a5,0x18
8000f898:	00b54333          	xor	t1,a0,a1
8000f89c:	01f35313          	srl	t1,t1,0x1f
8000f8a0:	037e                	sll	t1,t1,0x1f
8000f8a2:	cf4d                	beqz	a4,8000f95c <.L__divsf3_lhs_zero_or_subnormal>
8000f8a4:	cbe9                	beqz	a5,8000f976 <.L__divsf3_rhs_zero_or_subnormal>
8000f8a6:	0c570363          	beq	a4,t0,8000f96c <.L__divsf3_lhs_inf_or_nan>
8000f8aa:	0c578b63          	beq	a5,t0,8000f980 <.L__divsf3_rhs_inf_or_nan>
8000f8ae:	8f1d                	sub	a4,a4,a5
8000f8b0:	87418293          	add	t0,gp,-1932 # 80008be0 <__SEGGER_RTL_fdiv_reciprocal_table>
8000f8b4:	00f5d693          	srl	a3,a1,0xf
8000f8b8:	0fc6f693          	and	a3,a3,252
8000f8bc:	9696                	add	a3,a3,t0
8000f8be:	429c                	lw	a5,0(a3)
8000f8c0:	4187d613          	sra	a2,a5,0x18
8000f8c4:	00f59693          	sll	a3,a1,0xf
8000f8c8:	82e1                	srl	a3,a3,0x18
8000f8ca:	0016f293          	and	t0,a3,1
8000f8ce:	8285                	srl	a3,a3,0x1
8000f8d0:	fc068693          	add	a3,a3,-64 # f3ffffc0 <__AHB_SRAM_segment_end__+0x3cf7fc0>
8000f8d4:	9696                	add	a3,a3,t0
8000f8d6:	02d60633          	mul	a2,a2,a3
8000f8da:	07a2                	sll	a5,a5,0x8
8000f8dc:	83a1                	srl	a5,a5,0x8
8000f8de:	963e                	add	a2,a2,a5
8000f8e0:	05a2                	sll	a1,a1,0x8
8000f8e2:	81a1                	srl	a1,a1,0x8
8000f8e4:	008007b7          	lui	a5,0x800
8000f8e8:	8ddd                	or	a1,a1,a5
8000f8ea:	02c586b3          	mul	a3,a1,a2
8000f8ee:	0522                	sll	a0,a0,0x8
8000f8f0:	8121                	srl	a0,a0,0x8
8000f8f2:	8d5d                	or	a0,a0,a5
8000f8f4:	02c697b3          	mulh	a5,a3,a2
8000f8f8:	00b532b3          	sltu	t0,a0,a1
8000f8fc:	00551533          	sll	a0,a0,t0
8000f900:	40570733          	sub	a4,a4,t0
8000f904:	01465693          	srl	a3,a2,0x14
8000f908:	8a85                	and	a3,a3,1
8000f90a:	0016c693          	xor	a3,a3,1
8000f90e:	062e                	sll	a2,a2,0xb
8000f910:	8e1d                	sub	a2,a2,a5
8000f912:	8e15                	sub	a2,a2,a3
8000f914:	050a                	sll	a0,a0,0x2
8000f916:	02a617b3          	mulh	a5,a2,a0
8000f91a:	07e70613          	add	a2,a4,126
8000f91e:	055a                	sll	a0,a0,0x16
8000f920:	8d0d                	sub	a0,a0,a1
8000f922:	02b786b3          	mul	a3,a5,a1
8000f926:	0fe00293          	li	t0,254
8000f92a:	00567f63          	bgeu	a2,t0,8000f948 <.L__divsf3_underflow_or_overflow>
8000f92e:	40a68533          	sub	a0,a3,a0
8000f932:	000522b3          	sltz	t0,a0
8000f936:	9796                	add	a5,a5,t0
8000f938:	0017f513          	and	a0,a5,1
8000f93c:	8385                	srl	a5,a5,0x1
8000f93e:	953e                	add	a0,a0,a5
8000f940:	065e                	sll	a2,a2,0x17
8000f942:	9532                	add	a0,a0,a2
8000f944:	951a                	add	a0,a0,t1
8000f946:	8082                	ret

8000f948 <.L__divsf3_underflow_or_overflow>:
8000f948:	851a                	mv	a0,t1
8000f94a:	00564563          	blt	a2,t0,8000f954 <.L__divsf3_done>
8000f94e:	7f800337          	lui	t1,0x7f800

8000f952 <.L__divsf3_apply_sign>:
8000f952:	951a                	add	a0,a0,t1

8000f954 <.L__divsf3_done>:
8000f954:	8082                	ret

8000f956 <.L__divsf3_inf>:
8000f956:	7f800537          	lui	a0,0x7f800
8000f95a:	bfe5                	j	8000f952 <.L__divsf3_apply_sign>

8000f95c <.L__divsf3_lhs_zero_or_subnormal>:
8000f95c:	c789                	beqz	a5,8000f966 <.L__divsf3_nan>
8000f95e:	02579363          	bne	a5,t0,8000f984 <.L__divsf3_signed_zero>
8000f962:	05a6                	sll	a1,a1,0x9
8000f964:	c185                	beqz	a1,8000f984 <.L__divsf3_signed_zero>

8000f966 <.L__divsf3_nan>:
8000f966:	7fc00537          	lui	a0,0x7fc00
8000f96a:	8082                	ret

8000f96c <.L__divsf3_lhs_inf_or_nan>:
8000f96c:	0526                	sll	a0,a0,0x9
8000f96e:	fd65                	bnez	a0,8000f966 <.L__divsf3_nan>
8000f970:	fe5793e3          	bne	a5,t0,8000f956 <.L__divsf3_inf>
8000f974:	bfcd                	j	8000f966 <.L__divsf3_nan>

8000f976 <.L__divsf3_rhs_zero_or_subnormal>:
8000f976:	fe5710e3          	bne	a4,t0,8000f956 <.L__divsf3_inf>
8000f97a:	0526                	sll	a0,a0,0x9
8000f97c:	f56d                	bnez	a0,8000f966 <.L__divsf3_nan>
8000f97e:	bfe1                	j	8000f956 <.L__divsf3_inf>

8000f980 <.L__divsf3_rhs_inf_or_nan>:
8000f980:	05a6                	sll	a1,a1,0x9
8000f982:	f1f5                	bnez	a1,8000f966 <.L__divsf3_nan>

8000f984 <.L__divsf3_signed_zero>:
8000f984:	851a                	mv	a0,t1
8000f986:	8082                	ret

Disassembly of section .text.libc.__divdf3:

8000f988 <__divdf3>:
8000f988:	00169813          	sll	a6,a3,0x1
8000f98c:	01585813          	srl	a6,a6,0x15
8000f990:	00159893          	sll	a7,a1,0x1
8000f994:	0158d893          	srl	a7,a7,0x15
8000f998:	00d5c3b3          	xor	t2,a1,a3
8000f99c:	01f3d393          	srl	t2,t2,0x1f
8000f9a0:	03fe                	sll	t2,t2,0x1f
8000f9a2:	7ff00293          	li	t0,2047
8000f9a6:	16588e63          	beq	a7,t0,8000fb22 <.L__divdf3_inf_nan_over>
8000f9aa:	18080a63          	beqz	a6,8000fb3e <.L__divdf3_div_zero>
8000f9ae:	18580263          	beq	a6,t0,8000fb32 <.L__divdf3_div_inf_nan>
8000f9b2:	18088263          	beqz	a7,8000fb36 <.L__divdf3_signed_zero>
8000f9b6:	410888b3          	sub	a7,a7,a6
8000f9ba:	3ff88893          	add	a7,a7,1023 # 800003ff <__NONCACHEABLE_RAM_segment_end__+0x3f0003ff>
8000f9be:	05b2                	sll	a1,a1,0xc
8000f9c0:	81b1                	srl	a1,a1,0xc
8000f9c2:	06b2                	sll	a3,a3,0xc
8000f9c4:	82b1                	srl	a3,a3,0xc
8000f9c6:	00100737          	lui	a4,0x100
8000f9ca:	8dd9                	or	a1,a1,a4
8000f9cc:	8ed9                	or	a3,a3,a4
8000f9ce:	00c53733          	sltu	a4,a0,a2
8000f9d2:	9736                	add	a4,a4,a3
8000f9d4:	8d99                	sub	a1,a1,a4
8000f9d6:	8d11                	sub	a0,a0,a2
8000f9d8:	0005dd63          	bgez	a1,8000f9f2 <.L__divdf3_can_subtract>
8000f9dc:	00052733          	sltz	a4,a0
8000f9e0:	95ae                	add	a1,a1,a1
8000f9e2:	95ba                	add	a1,a1,a4
8000f9e4:	95b6                	add	a1,a1,a3
8000f9e6:	952a                	add	a0,a0,a0
8000f9e8:	9532                	add	a0,a0,a2
8000f9ea:	00c53733          	sltu	a4,a0,a2
8000f9ee:	95ba                	add	a1,a1,a4
8000f9f0:	18fd                	add	a7,a7,-1

8000f9f2 <.L__divdf3_can_subtract>:
8000f9f2:	1258dd63          	bge	a7,t0,8000fb2c <.L__divdf3_signed_inf>
8000f9f6:	15105063          	blez	a7,8000fb36 <.L__divdf3_signed_zero>
8000f9fa:	05aa                	sll	a1,a1,0xa
8000f9fc:	01655713          	srl	a4,a0,0x16
8000fa00:	8dd9                	or	a1,a1,a4
8000fa02:	052a                	sll	a0,a0,0xa
8000fa04:	02d5d833          	divu	a6,a1,a3
8000fa08:	02d80e33          	mul	t3,a6,a3
8000fa0c:	41c585b3          	sub	a1,a1,t3
8000fa10:	02c80733          	mul	a4,a6,a2
8000fa14:	02c837b3          	mulhu	a5,a6,a2
8000fa18:	00e53e33          	sltu	t3,a0,a4
8000fa1c:	97f2                	add	a5,a5,t3
8000fa1e:	8d19                	sub	a0,a0,a4
8000fa20:	8d9d                	sub	a1,a1,a5
8000fa22:	0005d863          	bgez	a1,8000fa32 <.L__divdf3_qdash_correct_1>
8000fa26:	187d                	add	a6,a6,-1 # ffdfffff <__APB_SRAM_segment_end__+0xbd0dfff>
8000fa28:	9532                	add	a0,a0,a2
8000fa2a:	95b6                	add	a1,a1,a3
8000fa2c:	00c532b3          	sltu	t0,a0,a2
8000fa30:	9596                	add	a1,a1,t0

8000fa32 <.L__divdf3_qdash_correct_1>:
8000fa32:	05aa                	sll	a1,a1,0xa
8000fa34:	01655293          	srl	t0,a0,0x16
8000fa38:	9596                	add	a1,a1,t0
8000fa3a:	052a                	sll	a0,a0,0xa
8000fa3c:	02d5d2b3          	divu	t0,a1,a3
8000fa40:	02d28733          	mul	a4,t0,a3
8000fa44:	8d99                	sub	a1,a1,a4
8000fa46:	02c28733          	mul	a4,t0,a2
8000fa4a:	02c2b7b3          	mulhu	a5,t0,a2
8000fa4e:	00e53e33          	sltu	t3,a0,a4
8000fa52:	97f2                	add	a5,a5,t3
8000fa54:	8d19                	sub	a0,a0,a4
8000fa56:	8d9d                	sub	a1,a1,a5
8000fa58:	0005d863          	bgez	a1,8000fa68 <.L__divdf3_qdash_correct_2>
8000fa5c:	12fd                	add	t0,t0,-1
8000fa5e:	9532                	add	a0,a0,a2
8000fa60:	95b6                	add	a1,a1,a3
8000fa62:	00c53e33          	sltu	t3,a0,a2
8000fa66:	95f2                	add	a1,a1,t3

8000fa68 <.L__divdf3_qdash_correct_2>:
8000fa68:	082a                	sll	a6,a6,0xa
8000fa6a:	9816                	add	a6,a6,t0
8000fa6c:	05ae                	sll	a1,a1,0xb
8000fa6e:	01555e13          	srl	t3,a0,0x15
8000fa72:	95f2                	add	a1,a1,t3
8000fa74:	052e                	sll	a0,a0,0xb
8000fa76:	02d5d2b3          	divu	t0,a1,a3
8000fa7a:	02d28733          	mul	a4,t0,a3
8000fa7e:	8d99                	sub	a1,a1,a4
8000fa80:	02c28733          	mul	a4,t0,a2
8000fa84:	02c2b7b3          	mulhu	a5,t0,a2
8000fa88:	00e53e33          	sltu	t3,a0,a4
8000fa8c:	97f2                	add	a5,a5,t3
8000fa8e:	8d19                	sub	a0,a0,a4
8000fa90:	8d9d                	sub	a1,a1,a5
8000fa92:	0005d863          	bgez	a1,8000faa2 <.L__divdf3_qdash_correct_3>
8000fa96:	12fd                	add	t0,t0,-1
8000fa98:	9532                	add	a0,a0,a2
8000fa9a:	95b6                	add	a1,a1,a3
8000fa9c:	00c53e33          	sltu	t3,a0,a2
8000faa0:	95f2                	add	a1,a1,t3

8000faa2 <.L__divdf3_qdash_correct_3>:
8000faa2:	05ae                	sll	a1,a1,0xb
8000faa4:	01555e13          	srl	t3,a0,0x15
8000faa8:	95f2                	add	a1,a1,t3
8000faaa:	052e                	sll	a0,a0,0xb
8000faac:	02d5d333          	divu	t1,a1,a3
8000fab0:	02d30733          	mul	a4,t1,a3
8000fab4:	8d99                	sub	a1,a1,a4
8000fab6:	02c30733          	mul	a4,t1,a2
8000faba:	02c337b3          	mulhu	a5,t1,a2
8000fabe:	00e53e33          	sltu	t3,a0,a4
8000fac2:	97f2                	add	a5,a5,t3
8000fac4:	8d19                	sub	a0,a0,a4
8000fac6:	8d9d                	sub	a1,a1,a5
8000fac8:	0005d863          	bgez	a1,8000fad8 <.L__divdf3_qdash_correct_4>
8000facc:	137d                	add	t1,t1,-1 # 7f7fffff <__NONCACHEABLE_RAM_segment_end__+0x3e7fffff>
8000face:	9532                	add	a0,a0,a2
8000fad0:	95b6                	add	a1,a1,a3
8000fad2:	00c53e33          	sltu	t3,a0,a2
8000fad6:	95f2                	add	a1,a1,t3

8000fad8 <.L__divdf3_qdash_correct_4>:
8000fad8:	02d6                	sll	t0,t0,0x15
8000fada:	032a                	sll	t1,t1,0xa
8000fadc:	929a                	add	t0,t0,t1
8000fade:	05ae                	sll	a1,a1,0xb
8000fae0:	01555e13          	srl	t3,a0,0x15
8000fae4:	95f2                	add	a1,a1,t3
8000fae6:	052e                	sll	a0,a0,0xb
8000fae8:	02d5d333          	divu	t1,a1,a3
8000faec:	02d30733          	mul	a4,t1,a3
8000faf0:	8d99                	sub	a1,a1,a4
8000faf2:	02c30733          	mul	a4,t1,a2
8000faf6:	02c337b3          	mulhu	a5,t1,a2
8000fafa:	00e53e33          	sltu	t3,a0,a4
8000fafe:	97f2                	add	a5,a5,t3
8000fb00:	8d9d                	sub	a1,a1,a5
8000fb02:	85fd                	sra	a1,a1,0x1f
8000fb04:	932e                	add	t1,t1,a1
8000fb06:	08d2                	sll	a7,a7,0x14
8000fb08:	011805b3          	add	a1,a6,a7
8000fb0c:	00135513          	srl	a0,t1,0x1
8000fb10:	9516                	add	a0,a0,t0
8000fb12:	00137313          	and	t1,t1,1
8000fb16:	951a                	add	a0,a0,t1
8000fb18:	00653733          	sltu	a4,a0,t1
8000fb1c:	95ba                	add	a1,a1,a4
8000fb1e:	959e                	add	a1,a1,t2
8000fb20:	8082                	ret

8000fb22 <.L__divdf3_inf_nan_over>:
8000fb22:	05b2                	sll	a1,a1,0xc
8000fb24:	00580f63          	beq	a6,t0,8000fb42 <.L__divdf3_return_nan>
8000fb28:	8dc9                	or	a1,a1,a0
8000fb2a:	ed81                	bnez	a1,8000fb42 <.L__divdf3_return_nan>

8000fb2c <.L__divdf3_signed_inf>:
8000fb2c:	7ff005b7          	lui	a1,0x7ff00
8000fb30:	a021                	j	8000fb38 <.L__divdf3_apply_sign>

8000fb32 <.L__divdf3_div_inf_nan>:
8000fb32:	06b2                	sll	a3,a3,0xc
8000fb34:	e699                	bnez	a3,8000fb42 <.L__divdf3_return_nan>

8000fb36 <.L__divdf3_signed_zero>:
8000fb36:	4581                	li	a1,0

8000fb38 <.L__divdf3_apply_sign>:
8000fb38:	959e                	add	a1,a1,t2

8000fb3a <.L__divdf3_clr_low_ret>:
8000fb3a:	4501                	li	a0,0
8000fb3c:	8082                	ret

8000fb3e <.L__divdf3_div_zero>:
8000fb3e:	fe0897e3          	bnez	a7,8000fb2c <.L__divdf3_signed_inf>

8000fb42 <.L__divdf3_return_nan>:
8000fb42:	7ff805b7          	lui	a1,0x7ff80
8000fb46:	bfd5                	j	8000fb3a <.L__divdf3_clr_low_ret>

Disassembly of section .text.libc.__eqsf2:

8000fb48 <__eqsf2>:
8000fb48:	ff000637          	lui	a2,0xff000
8000fb4c:	00151693          	sll	a3,a0,0x1
8000fb50:	02d66063          	bltu	a2,a3,8000fb70 <.L__eqsf2_one>
8000fb54:	00159693          	sll	a3,a1,0x1
8000fb58:	00d66c63          	bltu	a2,a3,8000fb70 <.L__eqsf2_one>
8000fb5c:	00b56633          	or	a2,a0,a1
8000fb60:	0606                	sll	a2,a2,0x1
8000fb62:	c609                	beqz	a2,8000fb6c <.L__eqsf2_zero>
8000fb64:	8d0d                	sub	a0,a0,a1
8000fb66:	00a03533          	snez	a0,a0
8000fb6a:	8082                	ret

8000fb6c <.L__eqsf2_zero>:
8000fb6c:	4501                	li	a0,0
8000fb6e:	8082                	ret

8000fb70 <.L__eqsf2_one>:
8000fb70:	4505                	li	a0,1
8000fb72:	8082                	ret

Disassembly of section .text.libc.__fixunssfdi:

8000fb74 <__fixunssfdi>:
8000fb74:	04054a63          	bltz	a0,8000fbc8 <.L__fixunssfdi_zero_result>
8000fb78:	00151613          	sll	a2,a0,0x1
8000fb7c:	8261                	srl	a2,a2,0x18
8000fb7e:	f8160613          	add	a2,a2,-127 # feffff81 <__APB_SRAM_segment_end__+0xaf0df81>
8000fb82:	04064363          	bltz	a2,8000fbc8 <.L__fixunssfdi_zero_result>
8000fb86:	800006b7          	lui	a3,0x80000
8000fb8a:	02000293          	li	t0,32
8000fb8e:	00565b63          	bge	a2,t0,8000fba4 <.L__fixunssfdi_long_shift>
8000fb92:	40c00633          	neg	a2,a2
8000fb96:	067d                	add	a2,a2,31
8000fb98:	0522                	sll	a0,a0,0x8
8000fb9a:	8d55                	or	a0,a0,a3
8000fb9c:	00c55533          	srl	a0,a0,a2
8000fba0:	4581                	li	a1,0
8000fba2:	8082                	ret

8000fba4 <.L__fixunssfdi_long_shift>:
8000fba4:	40c00633          	neg	a2,a2
8000fba8:	03f60613          	add	a2,a2,63
8000fbac:	02064163          	bltz	a2,8000fbce <.L__fixunssfdi_overflow_result>
8000fbb0:	00851593          	sll	a1,a0,0x8
8000fbb4:	8dd5                	or	a1,a1,a3
8000fbb6:	4501                	li	a0,0
8000fbb8:	c619                	beqz	a2,8000fbc6 <.L__fixunssfdi_shift_32>
8000fbba:	40c006b3          	neg	a3,a2
8000fbbe:	00d59533          	sll	a0,a1,a3
8000fbc2:	00c5d5b3          	srl	a1,a1,a2

8000fbc6 <.L__fixunssfdi_shift_32>:
8000fbc6:	8082                	ret

8000fbc8 <.L__fixunssfdi_zero_result>:
8000fbc8:	4501                	li	a0,0
8000fbca:	4581                	li	a1,0
8000fbcc:	8082                	ret

8000fbce <.L__fixunssfdi_overflow_result>:
8000fbce:	557d                	li	a0,-1
8000fbd0:	55fd                	li	a1,-1
8000fbd2:	8082                	ret

Disassembly of section .text.libc.__floatunsidf:

8000fbd4 <__floatunsidf>:
8000fbd4:	c131                	beqz	a0,8000fc18 <.L__floatunsidf_zero>
8000fbd6:	41d00613          	li	a2,1053
8000fbda:	01055693          	srl	a3,a0,0x10
8000fbde:	e299                	bnez	a3,8000fbe4 <.L1^B9>
8000fbe0:	0542                	sll	a0,a0,0x10
8000fbe2:	1641                	add	a2,a2,-16

8000fbe4 <.L1^B9>:
8000fbe4:	01855693          	srl	a3,a0,0x18
8000fbe8:	e299                	bnez	a3,8000fbee <.L2^B9>
8000fbea:	0522                	sll	a0,a0,0x8
8000fbec:	1661                	add	a2,a2,-8

8000fbee <.L2^B9>:
8000fbee:	01c55693          	srl	a3,a0,0x1c
8000fbf2:	e299                	bnez	a3,8000fbf8 <.L3^B7>
8000fbf4:	0512                	sll	a0,a0,0x4
8000fbf6:	1671                	add	a2,a2,-4

8000fbf8 <.L3^B7>:
8000fbf8:	01e55693          	srl	a3,a0,0x1e
8000fbfc:	e299                	bnez	a3,8000fc02 <.L4^B9>
8000fbfe:	050a                	sll	a0,a0,0x2
8000fc00:	1679                	add	a2,a2,-2

8000fc02 <.L4^B9>:
8000fc02:	00054463          	bltz	a0,8000fc0a <.L5^B7>
8000fc06:	0506                	sll	a0,a0,0x1
8000fc08:	167d                	add	a2,a2,-1

8000fc0a <.L5^B7>:
8000fc0a:	0652                	sll	a2,a2,0x14
8000fc0c:	00b55693          	srl	a3,a0,0xb
8000fc10:	0556                	sll	a0,a0,0x15
8000fc12:	00c685b3          	add	a1,a3,a2
8000fc16:	8082                	ret

8000fc18 <.L__floatunsidf_zero>:
8000fc18:	85aa                	mv	a1,a0
8000fc1a:	8082                	ret

Disassembly of section .text.libc.__trunctfsf2:

8000fc1c <__trunctfsf2>:
8000fc1c:	4110                	lw	a2,0(a0)
8000fc1e:	4154                	lw	a3,4(a0)
8000fc20:	4518                	lw	a4,8(a0)
8000fc22:	455c                	lw	a5,12(a0)
8000fc24:	1101                	add	sp,sp,-32
8000fc26:	850a                	mv	a0,sp
8000fc28:	ce06                	sw	ra,28(sp)
8000fc2a:	c032                	sw	a2,0(sp)
8000fc2c:	c236                	sw	a3,4(sp)
8000fc2e:	c43a                	sw	a4,8(sp)
8000fc30:	c63e                	sw	a5,12(sp)
8000fc32:	b14fc0ef          	jal	8000bf46 <__SEGGER_RTL_ldouble_to_double>
8000fc36:	a8afc0ef          	jal	8000bec0 <__truncdfsf2>
8000fc3a:	40f2                	lw	ra,28(sp)
8000fc3c:	6105                	add	sp,sp,32
8000fc3e:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_float32_signbit:

8000fc40 <__SEGGER_RTL_float32_signbit>:
8000fc40:	817d                	srl	a0,a0,0x1f
8000fc42:	8082                	ret

Disassembly of section .text.libc.ldexpf:

8000fc44 <ldexpf>:
8000fc44:	01755713          	srl	a4,a0,0x17
8000fc48:	0ff77713          	zext.b	a4,a4
8000fc4c:	fff70613          	add	a2,a4,-1 # fffff <__AXI_SRAM_segment_size__+0x3ffff>
8000fc50:	0fd00693          	li	a3,253
8000fc54:	87aa                	mv	a5,a0
8000fc56:	02c6e863          	bltu	a3,a2,8000fc86 <.L780>
8000fc5a:	95ba                	add	a1,a1,a4
8000fc5c:	fff58713          	add	a4,a1,-1 # 7ff7ffff <__NONCACHEABLE_RAM_segment_end__+0x3ef7ffff>
8000fc60:	00e6eb63          	bltu	a3,a4,8000fc76 <.L781>
8000fc64:	80800737          	lui	a4,0x80800
8000fc68:	177d                	add	a4,a4,-1 # 807fffff <__FLASH_segment_used_end__+0x7eeb37>
8000fc6a:	00e577b3          	and	a5,a0,a4
8000fc6e:	05de                	sll	a1,a1,0x17
8000fc70:	00f5e533          	or	a0,a1,a5
8000fc74:	8082                	ret

8000fc76 <.L781>:
8000fc76:	80000537          	lui	a0,0x80000
8000fc7a:	8d7d                	and	a0,a0,a5
8000fc7c:	00b05563          	blez	a1,8000fc86 <.L780>
8000fc80:	7f8007b7          	lui	a5,0x7f800
8000fc84:	8d5d                	or	a0,a0,a5

8000fc86 <.L780>:
8000fc86:	8082                	ret

Disassembly of section .text.libc.frexpf:

8000fc88 <frexpf>:
8000fc88:	01755793          	srl	a5,a0,0x17
8000fc8c:	0ff7f793          	zext.b	a5,a5
8000fc90:	4701                	li	a4,0
8000fc92:	cf99                	beqz	a5,8000fcb0 <.L959>
8000fc94:	0ff00613          	li	a2,255
8000fc98:	00c78c63          	beq	a5,a2,8000fcb0 <.L959>
8000fc9c:	f8278713          	add	a4,a5,-126 # 7f7fff82 <__NONCACHEABLE_RAM_segment_end__+0x3e7fff82>
8000fca0:	808007b7          	lui	a5,0x80800
8000fca4:	17fd                	add	a5,a5,-1 # 807fffff <__FLASH_segment_used_end__+0x7eeb37>
8000fca6:	00f576b3          	and	a3,a0,a5
8000fcaa:	3f000537          	lui	a0,0x3f000
8000fcae:	8d55                	or	a0,a0,a3

8000fcb0 <.L959>:
8000fcb0:	c198                	sw	a4,0(a1)
8000fcb2:	8082                	ret

Disassembly of section .text.libc.fmodf:

8000fcb4 <fmodf>:
8000fcb4:	01755793          	srl	a5,a0,0x17
8000fcb8:	80000837          	lui	a6,0x80000
8000fcbc:	17fd                	add	a5,a5,-1
8000fcbe:	0fd00713          	li	a4,253
8000fcc2:	86aa                	mv	a3,a0
8000fcc4:	862e                	mv	a2,a1
8000fcc6:	00a87833          	and	a6,a6,a0
8000fcca:	02f76463          	bltu	a4,a5,8000fcf2 <.L991>
8000fcce:	0175d793          	srl	a5,a1,0x17
8000fcd2:	17fd                	add	a5,a5,-1
8000fcd4:	02f77e63          	bgeu	a4,a5,8000fd10 <.L992>
8000fcd8:	00151713          	sll	a4,a0,0x1

8000fcdc <.L993>:
8000fcdc:	00159793          	sll	a5,a1,0x1
8000fce0:	ff000637          	lui	a2,0xff000
8000fce4:	0cf66663          	bltu	a2,a5,8000fdb0 <.L1009>
8000fce8:	ef01                	bnez	a4,8000fd00 <.L995>
8000fcea:	eb91                	bnez	a5,8000fcfe <.L994>

8000fcec <.L1011>:
8000fcec:	fbc1a503          	lw	a0,-68(gp) # 80009328 <.Lmerged_single+0x14>
8000fcf0:	8082                	ret

8000fcf2 <.L991>:
8000fcf2:	00151713          	sll	a4,a0,0x1
8000fcf6:	ff0007b7          	lui	a5,0xff000
8000fcfa:	fee7f1e3          	bgeu	a5,a4,8000fcdc <.L993>

8000fcfe <.L994>:
8000fcfe:	8082                	ret

8000fd00 <.L995>:
8000fd00:	fec706e3          	beq	a4,a2,8000fcec <.L1011>
8000fd04:	fec78de3          	beq	a5,a2,8000fcfe <.L994>
8000fd08:	d3f5                	beqz	a5,8000fcec <.L1011>
8000fd0a:	0586                	sll	a1,a1,0x1
8000fd0c:	0015d613          	srl	a2,a1,0x1

8000fd10 <.L992>:
8000fd10:	00169793          	sll	a5,a3,0x1
8000fd14:	8385                	srl	a5,a5,0x1
8000fd16:	00f66663          	bltu	a2,a5,8000fd22 <.L996>
8000fd1a:	fec792e3          	bne	a5,a2,8000fcfe <.L994>

8000fd1e <.L1018>:
8000fd1e:	8542                	mv	a0,a6
8000fd20:	8082                	ret

8000fd22 <.L996>:
8000fd22:	0177d713          	srl	a4,a5,0x17
8000fd26:	cb0d                	beqz	a4,8000fd58 <.L1012>
8000fd28:	008007b7          	lui	a5,0x800
8000fd2c:	fff78593          	add	a1,a5,-1 # 7fffff <__FLASH_segment_size__+0x2fff>
8000fd30:	8eed                	and	a3,a3,a1
8000fd32:	8fd5                	or	a5,a5,a3

8000fd34 <.L998>:
8000fd34:	01765593          	srl	a1,a2,0x17
8000fd38:	c985                	beqz	a1,8000fd68 <.L1013>
8000fd3a:	008006b7          	lui	a3,0x800
8000fd3e:	fff68513          	add	a0,a3,-1 # 7fffff <__FLASH_segment_size__+0x2fff>
8000fd42:	8e69                	and	a2,a2,a0
8000fd44:	8e55                	or	a2,a2,a3

8000fd46 <.L1002>:
8000fd46:	40c786b3          	sub	a3,a5,a2
8000fd4a:	02e5c763          	blt	a1,a4,8000fd78 <.L1003>
8000fd4e:	0206cc63          	bltz	a3,8000fd86 <.L1015>
8000fd52:	8542                	mv	a0,a6
8000fd54:	ea95                	bnez	a3,8000fd88 <.L1004>
8000fd56:	8082                	ret

8000fd58 <.L1012>:
8000fd58:	4701                	li	a4,0
8000fd5a:	008006b7          	lui	a3,0x800

8000fd5e <.L997>:
8000fd5e:	0786                	sll	a5,a5,0x1
8000fd60:	177d                	add	a4,a4,-1
8000fd62:	fed7eee3          	bltu	a5,a3,8000fd5e <.L997>
8000fd66:	b7f9                	j	8000fd34 <.L998>

8000fd68 <.L1013>:
8000fd68:	4581                	li	a1,0
8000fd6a:	008006b7          	lui	a3,0x800

8000fd6e <.L999>:
8000fd6e:	0606                	sll	a2,a2,0x1
8000fd70:	15fd                	add	a1,a1,-1
8000fd72:	fed66ee3          	bltu	a2,a3,8000fd6e <.L999>
8000fd76:	bfc1                	j	8000fd46 <.L1002>

8000fd78 <.L1003>:
8000fd78:	0006c463          	bltz	a3,8000fd80 <.L1001>
8000fd7c:	d2cd                	beqz	a3,8000fd1e <.L1018>
8000fd7e:	87b6                	mv	a5,a3

8000fd80 <.L1001>:
8000fd80:	0786                	sll	a5,a5,0x1
8000fd82:	177d                	add	a4,a4,-1
8000fd84:	b7c9                	j	8000fd46 <.L1002>

8000fd86 <.L1015>:
8000fd86:	86be                	mv	a3,a5

8000fd88 <.L1004>:
8000fd88:	008007b7          	lui	a5,0x800

8000fd8c <.L1006>:
8000fd8c:	fff70513          	add	a0,a4,-1
8000fd90:	00f6ed63          	bltu	a3,a5,8000fdaa <.L1007>
8000fd94:	00e04763          	bgtz	a4,8000fda2 <.L1008>
8000fd98:	4785                	li	a5,1
8000fd9a:	8f99                	sub	a5,a5,a4
8000fd9c:	00f6d6b3          	srl	a3,a3,a5
8000fda0:	4501                	li	a0,0

8000fda2 <.L1008>:
8000fda2:	9836                	add	a6,a6,a3
8000fda4:	055e                	sll	a0,a0,0x17
8000fda6:	9542                	add	a0,a0,a6
8000fda8:	8082                	ret

8000fdaa <.L1007>:
8000fdaa:	0686                	sll	a3,a3,0x1
8000fdac:	872a                	mv	a4,a0
8000fdae:	bff9                	j	8000fd8c <.L1006>

8000fdb0 <.L1009>:
8000fdb0:	852e                	mv	a0,a1
8000fdb2:	8082                	ret

Disassembly of section .text.libc.memset:

8000fdb4 <memset>:
8000fdb4:	872a                	mv	a4,a0
8000fdb6:	c22d                	beqz	a2,8000fe18 <.Lmemset_memset_end>

8000fdb8 <.Lmemset_unaligned_byte_set_loop>:
8000fdb8:	01e51693          	sll	a3,a0,0x1e
8000fdbc:	c699                	beqz	a3,8000fdca <.Lmemset_fast_set>
8000fdbe:	00b50023          	sb	a1,0(a0) # 3f000000 <__SHARE_RAM_segment_end__+0x3de80000>
8000fdc2:	0505                	add	a0,a0,1
8000fdc4:	167d                	add	a2,a2,-1 # feffffff <__APB_SRAM_segment_end__+0xaf0dfff>
8000fdc6:	fa6d                	bnez	a2,8000fdb8 <.Lmemset_unaligned_byte_set_loop>
8000fdc8:	a881                	j	8000fe18 <.Lmemset_memset_end>

8000fdca <.Lmemset_fast_set>:
8000fdca:	0ff5f593          	zext.b	a1,a1
8000fdce:	00859693          	sll	a3,a1,0x8
8000fdd2:	8dd5                	or	a1,a1,a3
8000fdd4:	01059693          	sll	a3,a1,0x10
8000fdd8:	8dd5                	or	a1,a1,a3
8000fdda:	02000693          	li	a3,32
8000fdde:	00d66f63          	bltu	a2,a3,8000fdfc <.Lmemset_word_set>

8000fde2 <.Lmemset_fast_set_loop>:
8000fde2:	c10c                	sw	a1,0(a0)
8000fde4:	c14c                	sw	a1,4(a0)
8000fde6:	c50c                	sw	a1,8(a0)
8000fde8:	c54c                	sw	a1,12(a0)
8000fdea:	c90c                	sw	a1,16(a0)
8000fdec:	c94c                	sw	a1,20(a0)
8000fdee:	cd0c                	sw	a1,24(a0)
8000fdf0:	cd4c                	sw	a1,28(a0)
8000fdf2:	9536                	add	a0,a0,a3
8000fdf4:	8e15                	sub	a2,a2,a3
8000fdf6:	fed676e3          	bgeu	a2,a3,8000fde2 <.Lmemset_fast_set_loop>
8000fdfa:	ce19                	beqz	a2,8000fe18 <.Lmemset_memset_end>

8000fdfc <.Lmemset_word_set>:
8000fdfc:	4691                	li	a3,4
8000fdfe:	00d66863          	bltu	a2,a3,8000fe0e <.Lmemset_byte_set_loop>

8000fe02 <.Lmemset_word_set_loop>:
8000fe02:	c10c                	sw	a1,0(a0)
8000fe04:	9536                	add	a0,a0,a3
8000fe06:	8e15                	sub	a2,a2,a3
8000fe08:	fed67de3          	bgeu	a2,a3,8000fe02 <.Lmemset_word_set_loop>
8000fe0c:	c611                	beqz	a2,8000fe18 <.Lmemset_memset_end>

8000fe0e <.Lmemset_byte_set_loop>:
8000fe0e:	00b50023          	sb	a1,0(a0)
8000fe12:	0505                	add	a0,a0,1
8000fe14:	167d                	add	a2,a2,-1
8000fe16:	fe65                	bnez	a2,8000fe0e <.Lmemset_byte_set_loop>

8000fe18 <.Lmemset_memset_end>:
8000fe18:	853a                	mv	a0,a4
8000fe1a:	8082                	ret

Disassembly of section .text.libc.strlen:

8000fe1c <strlen>:
8000fe1c:	85aa                	mv	a1,a0
8000fe1e:	00357693          	and	a3,a0,3
8000fe22:	c29d                	beqz	a3,8000fe48 <.Lstrlen_aligned>
8000fe24:	00054603          	lbu	a2,0(a0)
8000fe28:	ce21                	beqz	a2,8000fe80 <.Lstrlen_done>
8000fe2a:	0505                	add	a0,a0,1
8000fe2c:	00357693          	and	a3,a0,3
8000fe30:	ce81                	beqz	a3,8000fe48 <.Lstrlen_aligned>
8000fe32:	00054603          	lbu	a2,0(a0)
8000fe36:	c629                	beqz	a2,8000fe80 <.Lstrlen_done>
8000fe38:	0505                	add	a0,a0,1
8000fe3a:	00357693          	and	a3,a0,3
8000fe3e:	c689                	beqz	a3,8000fe48 <.Lstrlen_aligned>
8000fe40:	00054603          	lbu	a2,0(a0)
8000fe44:	ce15                	beqz	a2,8000fe80 <.Lstrlen_done>
8000fe46:	0505                	add	a0,a0,1

8000fe48 <.Lstrlen_aligned>:
8000fe48:	01010637          	lui	a2,0x1010
8000fe4c:	10160613          	add	a2,a2,257 # 1010101 <_extram_size+0x10101>
8000fe50:	00761693          	sll	a3,a2,0x7

8000fe54 <.Lstrlen_wordstrlen>:
8000fe54:	4118                	lw	a4,0(a0)
8000fe56:	0511                	add	a0,a0,4
8000fe58:	40c707b3          	sub	a5,a4,a2
8000fe5c:	fff74713          	not	a4,a4
8000fe60:	8ff9                	and	a5,a5,a4
8000fe62:	8ff5                	and	a5,a5,a3
8000fe64:	dbe5                	beqz	a5,8000fe54 <.Lstrlen_wordstrlen>
8000fe66:	1571                	add	a0,a0,-4
8000fe68:	01879713          	sll	a4,a5,0x18
8000fe6c:	eb11                	bnez	a4,8000fe80 <.Lstrlen_done>
8000fe6e:	0505                	add	a0,a0,1
8000fe70:	01079713          	sll	a4,a5,0x10
8000fe74:	e711                	bnez	a4,8000fe80 <.Lstrlen_done>
8000fe76:	0505                	add	a0,a0,1
8000fe78:	00879713          	sll	a4,a5,0x8
8000fe7c:	e311                	bnez	a4,8000fe80 <.Lstrlen_done>
8000fe7e:	0505                	add	a0,a0,1

8000fe80 <.Lstrlen_done>:
8000fe80:	8d0d                	sub	a0,a0,a1
8000fe82:	8082                	ret

Disassembly of section .text.libc.strnlen:

8000fe84 <strnlen>:
8000fe84:	862a                	mv	a2,a0
8000fe86:	852e                	mv	a0,a1
8000fe88:	c9c9                	beqz	a1,8000ff1a <.L528>
8000fe8a:	00064783          	lbu	a5,0(a2)
8000fe8e:	c7c9                	beqz	a5,8000ff18 <.L534>
8000fe90:	00367793          	and	a5,a2,3
8000fe94:	00379693          	sll	a3,a5,0x3
8000fe98:	00f58533          	add	a0,a1,a5
8000fe9c:	ffc67713          	and	a4,a2,-4
8000fea0:	57fd                	li	a5,-1
8000fea2:	00d797b3          	sll	a5,a5,a3
8000fea6:	4314                	lw	a3,0(a4)
8000fea8:	fff7c793          	not	a5,a5
8000feac:	feff05b7          	lui	a1,0xfeff0
8000feb0:	80808837          	lui	a6,0x80808
8000feb4:	8fd5                	or	a5,a5,a3
8000feb6:	488d                	li	a7,3
8000feb8:	eff58593          	add	a1,a1,-257 # fefefeff <__APB_SRAM_segment_end__+0xaefdeff>
8000febc:	08080813          	add	a6,a6,128 # 80808080 <__FLASH_segment_end__+0x8080>

8000fec0 <.L530>:
8000fec0:	00a8ff63          	bgeu	a7,a0,8000fede <.L529>
8000fec4:	00b786b3          	add	a3,a5,a1
8000fec8:	fff7c313          	not	t1,a5
8000fecc:	0066f6b3          	and	a3,a3,t1
8000fed0:	0106f6b3          	and	a3,a3,a6
8000fed4:	e689                	bnez	a3,8000fede <.L529>
8000fed6:	0711                	add	a4,a4,4
8000fed8:	1571                	add	a0,a0,-4
8000feda:	431c                	lw	a5,0(a4)
8000fedc:	b7d5                	j	8000fec0 <.L530>

8000fede <.L529>:
8000fede:	0ff7f593          	zext.b	a1,a5
8000fee2:	c59d                	beqz	a1,8000ff10 <.L531>
8000fee4:	0087d593          	srl	a1,a5,0x8
8000fee8:	0ff5f593          	zext.b	a1,a1
8000feec:	4685                	li	a3,1
8000feee:	cd89                	beqz	a1,8000ff08 <.L532>
8000fef0:	0107d593          	srl	a1,a5,0x10
8000fef4:	0ff5f593          	zext.b	a1,a1
8000fef8:	4689                	li	a3,2
8000fefa:	c599                	beqz	a1,8000ff08 <.L532>
8000fefc:	010005b7          	lui	a1,0x1000
8000ff00:	468d                	li	a3,3
8000ff02:	00b7e363          	bltu	a5,a1,8000ff08 <.L532>
8000ff06:	4691                	li	a3,4

8000ff08 <.L532>:
8000ff08:	85aa                	mv	a1,a0
8000ff0a:	00a6f363          	bgeu	a3,a0,8000ff10 <.L531>
8000ff0e:	85b6                	mv	a1,a3

8000ff10 <.L531>:
8000ff10:	8f11                	sub	a4,a4,a2
8000ff12:	00b70533          	add	a0,a4,a1
8000ff16:	8082                	ret

8000ff18 <.L534>:
8000ff18:	4501                	li	a0,0

8000ff1a <.L528>:
8000ff1a:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_stream_write:

8000ff1c <__SEGGER_RTL_stream_write>:
8000ff1c:	5154                	lw	a3,36(a0)
8000ff1e:	87ae                	mv	a5,a1
8000ff20:	853e                	mv	a0,a5
8000ff22:	4585                	li	a1,1
8000ff24:	be5fb06f          	j	8000bb08 <fwrite>

Disassembly of section .text.libc.__SEGGER_RTL_putc:

8000ff28 <__SEGGER_RTL_putc>:
8000ff28:	4918                	lw	a4,16(a0)
8000ff2a:	1101                	add	sp,sp,-32
8000ff2c:	0ff5f593          	zext.b	a1,a1
8000ff30:	cc22                	sw	s0,24(sp)
8000ff32:	ce06                	sw	ra,28(sp)
8000ff34:	00b107a3          	sb	a1,15(sp)
8000ff38:	411c                	lw	a5,0(a0)
8000ff3a:	842a                	mv	s0,a0
8000ff3c:	cb05                	beqz	a4,8000ff6c <.L24>
8000ff3e:	4154                	lw	a3,4(a0)
8000ff40:	00d7ff63          	bgeu	a5,a3,8000ff5e <.L26>
8000ff44:	495c                	lw	a5,20(a0)
8000ff46:	00178693          	add	a3,a5,1 # 800001 <_flash_size+0x1>
8000ff4a:	973e                	add	a4,a4,a5
8000ff4c:	c954                	sw	a3,20(a0)
8000ff4e:	00b70023          	sb	a1,0(a4)
8000ff52:	4958                	lw	a4,20(a0)
8000ff54:	4d1c                	lw	a5,24(a0)
8000ff56:	00f71463          	bne	a4,a5,8000ff5e <.L26>
8000ff5a:	a53fc0ef          	jal	8000c9ac <__SEGGER_RTL_prin_flush>

8000ff5e <.L26>:
8000ff5e:	401c                	lw	a5,0(s0)
8000ff60:	40f2                	lw	ra,28(sp)
8000ff62:	0785                	add	a5,a5,1
8000ff64:	c01c                	sw	a5,0(s0)
8000ff66:	4462                	lw	s0,24(sp)
8000ff68:	6105                	add	sp,sp,32
8000ff6a:	8082                	ret

8000ff6c <.L24>:
8000ff6c:	4558                	lw	a4,12(a0)
8000ff6e:	c305                	beqz	a4,8000ff8e <.L28>
8000ff70:	4154                	lw	a3,4(a0)
8000ff72:	00178613          	add	a2,a5,1
8000ff76:	00d61463          	bne	a2,a3,8000ff7e <.L29>
8000ff7a:	000107a3          	sb	zero,15(sp)

8000ff7e <.L29>:
8000ff7e:	fed7f0e3          	bgeu	a5,a3,8000ff5e <.L26>
8000ff82:	00f14683          	lbu	a3,15(sp)
8000ff86:	973e                	add	a4,a4,a5
8000ff88:	00d70023          	sb	a3,0(a4)
8000ff8c:	bfc9                	j	8000ff5e <.L26>

8000ff8e <.L28>:
8000ff8e:	4518                	lw	a4,8(a0)
8000ff90:	c305                	beqz	a4,8000ffb0 <.L30>
8000ff92:	4154                	lw	a3,4(a0)
8000ff94:	00178613          	add	a2,a5,1
8000ff98:	00d61463          	bne	a2,a3,8000ffa0 <.L31>
8000ff9c:	000107a3          	sb	zero,15(sp)

8000ffa0 <.L31>:
8000ffa0:	fad7ffe3          	bgeu	a5,a3,8000ff5e <.L26>
8000ffa4:	078a                	sll	a5,a5,0x2
8000ffa6:	973e                	add	a4,a4,a5
8000ffa8:	00f14783          	lbu	a5,15(sp)
8000ffac:	c31c                	sw	a5,0(a4)
8000ffae:	bf45                	j	8000ff5e <.L26>

8000ffb0 <.L30>:
8000ffb0:	5118                	lw	a4,32(a0)
8000ffb2:	d755                	beqz	a4,8000ff5e <.L26>
8000ffb4:	4154                	lw	a3,4(a0)
8000ffb6:	fad7f4e3          	bgeu	a5,a3,8000ff5e <.L26>
8000ffba:	4605                	li	a2,1
8000ffbc:	00f10593          	add	a1,sp,15
8000ffc0:	9702                	jalr	a4
8000ffc2:	bf71                	j	8000ff5e <.L26>

Disassembly of section .text.libc.__SEGGER_RTL_print_padding:

8000ffc4 <__SEGGER_RTL_print_padding>:
8000ffc4:	1141                	add	sp,sp,-16
8000ffc6:	c422                	sw	s0,8(sp)
8000ffc8:	c226                	sw	s1,4(sp)
8000ffca:	c04a                	sw	s2,0(sp)
8000ffcc:	c606                	sw	ra,12(sp)
8000ffce:	84aa                	mv	s1,a0
8000ffd0:	892e                	mv	s2,a1
8000ffd2:	8432                	mv	s0,a2

8000ffd4 <.L37>:
8000ffd4:	147d                	add	s0,s0,-1
8000ffd6:	00045863          	bgez	s0,8000ffe6 <.L38>
8000ffda:	40b2                	lw	ra,12(sp)
8000ffdc:	4422                	lw	s0,8(sp)
8000ffde:	4492                	lw	s1,4(sp)
8000ffe0:	4902                	lw	s2,0(sp)
8000ffe2:	0141                	add	sp,sp,16
8000ffe4:	8082                	ret

8000ffe6 <.L38>:
8000ffe6:	85ca                	mv	a1,s2
8000ffe8:	8526                	mv	a0,s1
8000ffea:	3f3d                	jal	8000ff28 <__SEGGER_RTL_putc>
8000ffec:	b7e5                	j	8000ffd4 <.L37>

Disassembly of section .text.libc.vfprintf_l:

8000ffee <vfprintf_l>:
8000ffee:	711d                	add	sp,sp,-96
8000fff0:	ce86                	sw	ra,92(sp)
8000fff2:	cca2                	sw	s0,88(sp)
8000fff4:	caa6                	sw	s1,84(sp)
8000fff6:	1080                	add	s0,sp,96
8000fff8:	c8ca                	sw	s2,80(sp)
8000fffa:	c6ce                	sw	s3,76(sp)
8000fffc:	8932                	mv	s2,a2
8000fffe:	fad42623          	sw	a3,-84(s0)
80010002:	89aa                	mv	s3,a0
80010004:	fab42423          	sw	a1,-88(s0)
80010008:	b5efd0ef          	jal	8000d366 <__SEGGER_RTL_X_file_bufsize>
8001000c:	fa842583          	lw	a1,-88(s0)
80010010:	00f50793          	add	a5,a0,15
80010014:	9bc1                	and	a5,a5,-16
80010016:	40f10133          	sub	sp,sp,a5
8001001a:	84aa                	mv	s1,a0
8001001c:	fb840513          	add	a0,s0,-72
80010020:	9c9fc0ef          	jal	8000c9e8 <__SEGGER_RTL_init_prin_l>
80010024:	800007b7          	lui	a5,0x80000
80010028:	fac42603          	lw	a2,-84(s0)
8001002c:	17fd                	add	a5,a5,-1 # 7fffffff <__NONCACHEABLE_RAM_segment_end__+0x3effffff>
8001002e:	faf42e23          	sw	a5,-68(s0)
80010032:	800107b7          	lui	a5,0x80010
80010036:	f1c78793          	add	a5,a5,-228 # 8000ff1c <__SEGGER_RTL_stream_write>
8001003a:	85ca                	mv	a1,s2
8001003c:	fb840513          	add	a0,s0,-72
80010040:	fc242423          	sw	sp,-56(s0)
80010044:	fc942823          	sw	s1,-48(s0)
80010048:	fd342e23          	sw	s3,-36(s0)
8001004c:	fcf42c23          	sw	a5,-40(s0)
80010050:	2811                	jal	80010064 <__SEGGER_RTL_vfprintf>
80010052:	fa040113          	add	sp,s0,-96
80010056:	40f6                	lw	ra,92(sp)
80010058:	4466                	lw	s0,88(sp)
8001005a:	44d6                	lw	s1,84(sp)
8001005c:	4946                	lw	s2,80(sp)
8001005e:	49b6                	lw	s3,76(sp)
80010060:	6125                	add	sp,sp,96
80010062:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_vfprintf_short_float_long:

80010064 <__SEGGER_RTL_vfprintf>:
80010064:	7175                	add	sp,sp,-144
80010066:	ddc18793          	add	a5,gp,-548 # 80009148 <.L9>
8001006a:	c83e                	sw	a5,16(sp)
8001006c:	dece                	sw	s3,124(sp)
8001006e:	dad6                	sw	s5,116(sp)
80010070:	ceee                	sw	s11,92(sp)
80010072:	c706                	sw	ra,140(sp)
80010074:	c522                	sw	s0,136(sp)
80010076:	c326                	sw	s1,132(sp)
80010078:	c14a                	sw	s2,128(sp)
8001007a:	dcd2                	sw	s4,120(sp)
8001007c:	d8da                	sw	s6,112(sp)
8001007e:	d6de                	sw	s7,108(sp)
80010080:	d4e2                	sw	s8,104(sp)
80010082:	d2e6                	sw	s9,100(sp)
80010084:	d0ea                	sw	s10,96(sp)
80010086:	e2018793          	add	a5,gp,-480 # 8000918c <.L45>
8001008a:	00020db7          	lui	s11,0x20
8001008e:	89aa                	mv	s3,a0
80010090:	8ab2                	mv	s5,a2
80010092:	00052023          	sw	zero,0(a0)
80010096:	ca3e                	sw	a5,20(sp)
80010098:	021d8d93          	add	s11,s11,33 # 20021 <__FLASH_segment_used_size__+0x11b59>

8001009c <.L2>:
8001009c:	00158a13          	add	s4,a1,1 # 1000001 <_extram_size+0x1>
800100a0:	0005c583          	lbu	a1,0(a1)
800100a4:	e19d                	bnez	a1,800100ca <.L229>
800100a6:	00c9a783          	lw	a5,12(s3)
800100aa:	cb91                	beqz	a5,800100be <.L230>
800100ac:	0009a703          	lw	a4,0(s3)
800100b0:	0049a683          	lw	a3,4(s3)
800100b4:	00d77563          	bgeu	a4,a3,800100be <.L230>
800100b8:	97ba                	add	a5,a5,a4
800100ba:	00078023          	sb	zero,0(a5)

800100be <.L230>:
800100be:	854e                	mv	a0,s3
800100c0:	8edfc0ef          	jal	8000c9ac <__SEGGER_RTL_prin_flush>
800100c4:	0009a503          	lw	a0,0(s3)
800100c8:	a2f9                	j	80010296 <.L338>

800100ca <.L229>:
800100ca:	02500793          	li	a5,37
800100ce:	00f58563          	beq	a1,a5,800100d8 <.L231>

800100d2 <.L362>:
800100d2:	854e                	mv	a0,s3
800100d4:	3d91                	jal	8000ff28 <__SEGGER_RTL_putc>
800100d6:	aab9                	j	80010234 <.L4>

800100d8 <.L231>:
800100d8:	4b81                	li	s7,0
800100da:	03000613          	li	a2,48
800100de:	05e00593          	li	a1,94
800100e2:	6505                	lui	a0,0x1
800100e4:	487d                	li	a6,31
800100e6:	48c1                	li	a7,16
800100e8:	6321                	lui	t1,0x8
800100ea:	a03d                	j	80010118 <.L3>

800100ec <.L5>:
800100ec:	04b78f63          	beq	a5,a1,8001014a <.L15>

800100f0 <.L232>:
800100f0:	8a36                	mv	s4,a3
800100f2:	4b01                	li	s6,0
800100f4:	46a5                	li	a3,9
800100f6:	45a9                	li	a1,10

800100f8 <.L18>:
800100f8:	fd078713          	add	a4,a5,-48
800100fc:	0ff77613          	zext.b	a2,a4
80010100:	08c6e363          	bltu	a3,a2,80010186 <.L20>
80010104:	02bb0b33          	mul	s6,s6,a1
80010108:	0a05                	add	s4,s4,1
8001010a:	fffa4783          	lbu	a5,-1(s4)
8001010e:	9b3a                	add	s6,s6,a4
80010110:	b7e5                	j	800100f8 <.L18>

80010112 <.L14>:
80010112:	040beb93          	or	s7,s7,64

80010116 <.L16>:
80010116:	8a36                	mv	s4,a3

80010118 <.L3>:
80010118:	000a4783          	lbu	a5,0(s4)
8001011c:	001a0693          	add	a3,s4,1
80010120:	fcf666e3          	bltu	a2,a5,800100ec <.L5>
80010124:	fcf876e3          	bgeu	a6,a5,800100f0 <.L232>
80010128:	fe078713          	add	a4,a5,-32
8001012c:	0ff77713          	zext.b	a4,a4
80010130:	02e8e963          	bltu	a7,a4,80010162 <.L7>
80010134:	4442                	lw	s0,16(sp)
80010136:	070a                	sll	a4,a4,0x2
80010138:	9722                	add	a4,a4,s0
8001013a:	4318                	lw	a4,0(a4)
8001013c:	8702                	jr	a4

8001013e <.L13>:
8001013e:	080beb93          	or	s7,s7,128
80010142:	bfd1                	j	80010116 <.L16>

80010144 <.L12>:
80010144:	006bebb3          	or	s7,s7,t1
80010148:	b7f9                	j	80010116 <.L16>

8001014a <.L15>:
8001014a:	00abebb3          	or	s7,s7,a0
8001014e:	b7e1                	j	80010116 <.L16>

80010150 <.L11>:
80010150:	020beb93          	or	s7,s7,32
80010154:	b7c9                	j	80010116 <.L16>

80010156 <.L10>:
80010156:	010beb93          	or	s7,s7,16
8001015a:	bf75                	j	80010116 <.L16>

8001015c <.L8>:
8001015c:	200beb93          	or	s7,s7,512
80010160:	bf5d                	j	80010116 <.L16>

80010162 <.L7>:
80010162:	02a00713          	li	a4,42
80010166:	f8e795e3          	bne	a5,a4,800100f0 <.L232>
8001016a:	000aab03          	lw	s6,0(s5)
8001016e:	004a8713          	add	a4,s5,4
80010172:	000b5663          	bgez	s6,8001017e <.L19>
80010176:	41600b33          	neg	s6,s6
8001017a:	010beb93          	or	s7,s7,16

8001017e <.L19>:
8001017e:	0006c783          	lbu	a5,0(a3) # 800000 <_flash_size>
80010182:	0a09                	add	s4,s4,2
80010184:	8aba                	mv	s5,a4

80010186 <.L20>:
80010186:	000b5363          	bgez	s6,8001018c <.L22>
8001018a:	4b01                	li	s6,0

8001018c <.L22>:
8001018c:	02e00713          	li	a4,46
80010190:	4481                	li	s1,0
80010192:	04e79263          	bne	a5,a4,800101d6 <.L23>
80010196:	000a4783          	lbu	a5,0(s4)
8001019a:	02a00713          	li	a4,42
8001019e:	02e78263          	beq	a5,a4,800101c2 <.L24>
800101a2:	0a05                	add	s4,s4,1
800101a4:	46a5                	li	a3,9
800101a6:	45a9                	li	a1,10

800101a8 <.L25>:
800101a8:	fd078713          	add	a4,a5,-48
800101ac:	0ff77613          	zext.b	a2,a4
800101b0:	00c6ef63          	bltu	a3,a2,800101ce <.L26>
800101b4:	02b484b3          	mul	s1,s1,a1
800101b8:	0a05                	add	s4,s4,1
800101ba:	fffa4783          	lbu	a5,-1(s4)
800101be:	94ba                	add	s1,s1,a4
800101c0:	b7e5                	j	800101a8 <.L25>

800101c2 <.L24>:
800101c2:	000aa483          	lw	s1,0(s5)
800101c6:	001a4783          	lbu	a5,1(s4)
800101ca:	0a91                	add	s5,s5,4
800101cc:	0a09                	add	s4,s4,2

800101ce <.L26>:
800101ce:	0004c463          	bltz	s1,800101d6 <.L23>
800101d2:	100beb93          	or	s7,s7,256

800101d6 <.L23>:
800101d6:	06c00713          	li	a4,108
800101da:	06e78263          	beq	a5,a4,8001023e <.L28>
800101de:	02f76c63          	bltu	a4,a5,80010216 <.L29>
800101e2:	06800713          	li	a4,104
800101e6:	06e78a63          	beq	a5,a4,8001025a <.L30>
800101ea:	06a00713          	li	a4,106
800101ee:	04e78563          	beq	a5,a4,80010238 <.L31>

800101f2 <.L32>:
800101f2:	05700713          	li	a4,87
800101f6:	2af760e3          	bltu	a4,a5,80010c96 <.L38>
800101fa:	04500713          	li	a4,69
800101fe:	2ce78563          	beq	a5,a4,800104c8 <.L39>
80010202:	06f76763          	bltu	a4,a5,80010270 <.L40>
80010206:	c7c1                	beqz	a5,8001028e <.L41>
80010208:	02500713          	li	a4,37
8001020c:	02500593          	li	a1,37
80010210:	ece781e3          	beq	a5,a4,800100d2 <.L362>
80010214:	a005                	j	80010234 <.L4>

80010216 <.L29>:
80010216:	07400713          	li	a4,116
8001021a:	00e78663          	beq	a5,a4,80010226 <.L346>
8001021e:	07a00713          	li	a4,122
80010222:	26e796e3          	bne	a5,a4,80010c8e <.L34>

80010226 <.L346>:
80010226:	000a4783          	lbu	a5,0(s4)
8001022a:	0a05                	add	s4,s4,1

8001022c <.L35>:
8001022c:	07800713          	li	a4,120
80010230:	fcf771e3          	bgeu	a4,a5,800101f2 <.L32>

80010234 <.L4>:
80010234:	85d2                	mv	a1,s4
80010236:	b59d                	j	8001009c <.L2>

80010238 <.L31>:
80010238:	002beb93          	or	s7,s7,2
8001023c:	b7ed                	j	80010226 <.L346>

8001023e <.L28>:
8001023e:	000a4783          	lbu	a5,0(s4)
80010242:	00e79863          	bne	a5,a4,80010252 <.L36>
80010246:	002beb93          	or	s7,s7,2

8001024a <.L347>:
8001024a:	001a4783          	lbu	a5,1(s4)
8001024e:	0a09                	add	s4,s4,2
80010250:	bff1                	j	8001022c <.L35>

80010252 <.L36>:
80010252:	0a05                	add	s4,s4,1
80010254:	001beb93          	or	s7,s7,1
80010258:	bfd1                	j	8001022c <.L35>

8001025a <.L30>:
8001025a:	000a4783          	lbu	a5,0(s4)
8001025e:	00e79563          	bne	a5,a4,80010268 <.L37>
80010262:	008beb93          	or	s7,s7,8
80010266:	b7d5                	j	8001024a <.L347>

80010268 <.L37>:
80010268:	0a05                	add	s4,s4,1
8001026a:	004beb93          	or	s7,s7,4
8001026e:	bf7d                	j	8001022c <.L35>

80010270 <.L40>:
80010270:	04600713          	li	a4,70
80010274:	2ce78263          	beq	a5,a4,80010538 <.L57>
80010278:	04700713          	li	a4,71
8001027c:	fae79ce3          	bne	a5,a4,80010234 <.L4>
80010280:	6789                	lui	a5,0x2
80010282:	00fbebb3          	or	s7,s7,a5

80010286 <.L52>:
80010286:	6905                	lui	s2,0x1
80010288:	c0090913          	add	s2,s2,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
8001028c:	ac65                	j	80010544 <.L353>

8001028e <.L41>:
8001028e:	854e                	mv	a0,s3
80010290:	f1cfc0ef          	jal	8000c9ac <__SEGGER_RTL_prin_flush>
80010294:	557d                	li	a0,-1

80010296 <.L338>:
80010296:	40ba                	lw	ra,140(sp)
80010298:	442a                	lw	s0,136(sp)
8001029a:	449a                	lw	s1,132(sp)
8001029c:	490a                	lw	s2,128(sp)
8001029e:	59f6                	lw	s3,124(sp)
800102a0:	5a66                	lw	s4,120(sp)
800102a2:	5ad6                	lw	s5,116(sp)
800102a4:	5b46                	lw	s6,112(sp)
800102a6:	5bb6                	lw	s7,108(sp)
800102a8:	5c26                	lw	s8,104(sp)
800102aa:	5c96                	lw	s9,100(sp)
800102ac:	5d06                	lw	s10,96(sp)
800102ae:	4df6                	lw	s11,92(sp)
800102b0:	6149                	add	sp,sp,144
800102b2:	8082                	ret

800102b4 <.L55>:
800102b4:	000aa483          	lw	s1,0(s5)
800102b8:	1b7d                	add	s6,s6,-1
800102ba:	865a                	mv	a2,s6
800102bc:	85de                	mv	a1,s7
800102be:	854e                	mv	a0,s3
800102c0:	f0efc0ef          	jal	8000c9ce <__SEGGER_RTL_pre_padding>
800102c4:	004a8413          	add	s0,s5,4
800102c8:	0ff4f593          	zext.b	a1,s1
800102cc:	854e                	mv	a0,s3
800102ce:	39a9                	jal	8000ff28 <__SEGGER_RTL_putc>
800102d0:	8aa2                	mv	s5,s0

800102d2 <.L371>:
800102d2:	010bfb93          	and	s7,s7,16
800102d6:	f40b8fe3          	beqz	s7,80010234 <.L4>
800102da:	865a                	mv	a2,s6
800102dc:	02000593          	li	a1,32
800102e0:	854e                	mv	a0,s3
800102e2:	31cd                	jal	8000ffc4 <__SEGGER_RTL_print_padding>
800102e4:	bf81                	j	80010234 <.L4>

800102e6 <.L50>:
800102e6:	008bf693          	and	a3,s7,8
800102ea:	000aa783          	lw	a5,0(s5)
800102ee:	0009a703          	lw	a4,0(s3)
800102f2:	0a91                	add	s5,s5,4
800102f4:	c681                	beqz	a3,800102fc <.L62>
800102f6:	00e78023          	sb	a4,0(a5) # 2000 <__APB_SRAM_segment_size__>
800102fa:	bf2d                	j	80010234 <.L4>

800102fc <.L62>:
800102fc:	002bfb93          	and	s7,s7,2
80010300:	c398                	sw	a4,0(a5)
80010302:	f20b89e3          	beqz	s7,80010234 <.L4>
80010306:	0007a223          	sw	zero,4(a5)
8001030a:	b72d                	j	80010234 <.L4>

8001030c <.L47>:
8001030c:	000aa403          	lw	s0,0(s5)
80010310:	895e                	mv	s2,s7
80010312:	0a91                	add	s5,s5,4

80010314 <.L65>:
80010314:	e019                	bnez	s0,8001031a <.L66>
80010316:	dac18413          	add	s0,gp,-596 # 80009118 <.LC0>

8001031a <.L66>:
8001031a:	dff97b93          	and	s7,s2,-513
8001031e:	10097913          	and	s2,s2,256
80010322:	02090563          	beqz	s2,8001034c <.L67>
80010326:	85a6                	mv	a1,s1
80010328:	8522                	mv	a0,s0
8001032a:	3ea9                	jal	8000fe84 <strnlen>

8001032c <.L348>:
8001032c:	40ab0b33          	sub	s6,s6,a0
80010330:	84aa                	mv	s1,a0
80010332:	865a                	mv	a2,s6
80010334:	85de                	mv	a1,s7
80010336:	854e                	mv	a0,s3
80010338:	e96fc0ef          	jal	8000c9ce <__SEGGER_RTL_pre_padding>

8001033c <.L69>:
8001033c:	d8d9                	beqz	s1,800102d2 <.L371>
8001033e:	00044583          	lbu	a1,0(s0)
80010342:	854e                	mv	a0,s3
80010344:	0405                	add	s0,s0,1
80010346:	36cd                	jal	8000ff28 <__SEGGER_RTL_putc>
80010348:	14fd                	add	s1,s1,-1
8001034a:	bfcd                	j	8001033c <.L69>

8001034c <.L67>:
8001034c:	8522                	mv	a0,s0
8001034e:	34f9                	jal	8000fe1c <strlen>
80010350:	bff1                	j	8001032c <.L348>

80010352 <.L48>:
80010352:	080bf713          	and	a4,s7,128
80010356:	000aa403          	lw	s0,0(s5)
8001035a:	004a8693          	add	a3,s5,4
8001035e:	4581                	li	a1,0
80010360:	02300c93          	li	s9,35
80010364:	e311                	bnez	a4,80010368 <.L71>
80010366:	4c81                	li	s9,0

80010368 <.L71>:
80010368:	100beb93          	or	s7,s7,256
8001036c:	8ab6                	mv	s5,a3
8001036e:	44a1                	li	s1,8

80010370 <.L72>:
80010370:	100bf713          	and	a4,s7,256
80010374:	e311                	bnez	a4,80010378 <.L203>
80010376:	4485                	li	s1,1

80010378 <.L203>:
80010378:	05800713          	li	a4,88
8001037c:	04e78ae3          	beq	a5,a4,80010bd0 <.L204>
80010380:	f9c78693          	add	a3,a5,-100
80010384:	4705                	li	a4,1
80010386:	00d71733          	sll	a4,a4,a3
8001038a:	01b776b3          	and	a3,a4,s11
8001038e:	7c069c63          	bnez	a3,80010b66 <.L205>
80010392:	00c75693          	srl	a3,a4,0xc
80010396:	1016f693          	and	a3,a3,257
8001039a:	02069be3          	bnez	a3,80010bd0 <.L204>
8001039e:	06f00713          	li	a4,111
800103a2:	4c01                	li	s8,0
800103a4:	04e791e3          	bne	a5,a4,80010be6 <.L206>

800103a8 <.L207>:
800103a8:	00b467b3          	or	a5,s0,a1
800103ac:	02078de3          	beqz	a5,80010be6 <.L206>
800103b0:	183c                	add	a5,sp,56
800103b2:	01878733          	add	a4,a5,s8
800103b6:	00747793          	and	a5,s0,7
800103ba:	03078793          	add	a5,a5,48
800103be:	00f70023          	sb	a5,0(a4)
800103c2:	800d                	srl	s0,s0,0x3
800103c4:	01d59793          	sll	a5,a1,0x1d
800103c8:	0c05                	add	s8,s8,1
800103ca:	8c5d                	or	s0,s0,a5
800103cc:	818d                	srl	a1,a1,0x3
800103ce:	bfe9                	j	800103a8 <.L207>

800103d0 <.L56>:
800103d0:	6709                	lui	a4,0x2
800103d2:	00ebebb3          	or	s7,s7,a4

800103d6 <.L44>:
800103d6:	080bf713          	and	a4,s7,128
800103da:	4c81                	li	s9,0
800103dc:	cb19                	beqz	a4,800103f2 <.L75>
800103de:	6c8d                	lui	s9,0x3
800103e0:	07800713          	li	a4,120
800103e4:	058c8c93          	add	s9,s9,88 # 3058 <__APB_SRAM_segment_size__+0x1058>
800103e8:	00e79563          	bne	a5,a4,800103f2 <.L75>
800103ec:	6c8d                	lui	s9,0x3
800103ee:	078c8c93          	add	s9,s9,120 # 3078 <__APB_SRAM_segment_size__+0x1078>

800103f2 <.L75>:
800103f2:	100bf713          	and	a4,s7,256

800103f6 <.L365>:
800103f6:	c319                	beqz	a4,800103fc <.L74>
800103f8:	dffbfb93          	and	s7,s7,-513

800103fc <.L74>:
800103fc:	011b9613          	sll	a2,s7,0x11
80010400:	002bf713          	and	a4,s7,2
80010404:	004bf693          	and	a3,s7,4
80010408:	08065563          	bgez	a2,80010492 <.L76>
8001040c:	cf31                	beqz	a4,80010468 <.L77>
8001040e:	007a8713          	add	a4,s5,7
80010412:	9b61                	and	a4,a4,-8
80010414:	4300                	lw	s0,0(a4)
80010416:	434c                	lw	a1,4(a4)
80010418:	00870a93          	add	s5,a4,8 # 2008 <__APB_SRAM_segment_size__+0x8>

8001041c <.L78>:
8001041c:	cea1                	beqz	a3,80010474 <.L79>
8001041e:	0442                	sll	s0,s0,0x10
80010420:	8441                	sra	s0,s0,0x10

80010422 <.L351>:
80010422:	41f45593          	sra	a1,s0,0x1f

80010426 <.L80>:
80010426:	0405dd63          	bgez	a1,80010480 <.L82>
8001042a:	00803733          	snez	a4,s0
8001042e:	40b005b3          	neg	a1,a1
80010432:	8d99                	sub	a1,a1,a4
80010434:	40800433          	neg	s0,s0
80010438:	02d00c93          	li	s9,45

8001043c <.L84>:
8001043c:	100bf713          	and	a4,s7,256
80010440:	db05                	beqz	a4,80010370 <.L72>
80010442:	dffbfb93          	and	s7,s7,-513
80010446:	b72d                	j	80010370 <.L72>

80010448 <.L49>:
80010448:	080bf713          	and	a4,s7,128
8001044c:	03000c93          	li	s9,48
80010450:	f34d                	bnez	a4,800103f2 <.L75>
80010452:	4c81                	li	s9,0
80010454:	bf79                	j	800103f2 <.L75>

80010456 <.L46>:
80010456:	100bf713          	and	a4,s7,256
8001045a:	4c81                	li	s9,0
8001045c:	bf69                	j	800103f6 <.L365>

8001045e <.L51>:
8001045e:	6711                	lui	a4,0x4
80010460:	00ebebb3          	or	s7,s7,a4
80010464:	4c81                	li	s9,0
80010466:	bf59                	j	800103fc <.L74>

80010468 <.L77>:
80010468:	000aa403          	lw	s0,0(s5)
8001046c:	0a91                	add	s5,s5,4
8001046e:	41f45593          	sra	a1,s0,0x1f
80010472:	b76d                	j	8001041c <.L78>

80010474 <.L79>:
80010474:	008bf713          	and	a4,s7,8
80010478:	d75d                	beqz	a4,80010426 <.L80>
8001047a:	0462                	sll	s0,s0,0x18
8001047c:	8461                	sra	s0,s0,0x18
8001047e:	b755                	j	80010422 <.L351>

80010480 <.L82>:
80010480:	020bf713          	and	a4,s7,32
80010484:	ef1d                	bnez	a4,800104c2 <.L239>
80010486:	040bf713          	and	a4,s7,64
8001048a:	db4d                	beqz	a4,8001043c <.L84>
8001048c:	02000c93          	li	s9,32
80010490:	b775                	j	8001043c <.L84>

80010492 <.L76>:
80010492:	cf09                	beqz	a4,800104ac <.L85>
80010494:	007a8713          	add	a4,s5,7
80010498:	9b61                	and	a4,a4,-8
8001049a:	4300                	lw	s0,0(a4)
8001049c:	434c                	lw	a1,4(a4)
8001049e:	00870a93          	add	s5,a4,8 # 4008 <__DLM_segment_used_size__+0x8>

800104a2 <.L86>:
800104a2:	ca91                	beqz	a3,800104b6 <.L87>
800104a4:	0442                	sll	s0,s0,0x10
800104a6:	8041                	srl	s0,s0,0x10

800104a8 <.L352>:
800104a8:	4581                	li	a1,0
800104aa:	bf49                	j	8001043c <.L84>

800104ac <.L85>:
800104ac:	000aa403          	lw	s0,0(s5)
800104b0:	4581                	li	a1,0
800104b2:	0a91                	add	s5,s5,4
800104b4:	b7fd                	j	800104a2 <.L86>

800104b6 <.L87>:
800104b6:	008bf713          	and	a4,s7,8
800104ba:	d349                	beqz	a4,8001043c <.L84>
800104bc:	0ff47413          	zext.b	s0,s0
800104c0:	b7e5                	j	800104a8 <.L352>

800104c2 <.L239>:
800104c2:	02b00c93          	li	s9,43
800104c6:	bf9d                	j	8001043c <.L84>

800104c8 <.L39>:
800104c8:	6789                	lui	a5,0x2
800104ca:	00fbebb3          	or	s7,s7,a5

800104ce <.L54>:
800104ce:	400be913          	or	s2,s7,1024

800104d2 <.L91>:
800104d2:	00297793          	and	a5,s2,2
800104d6:	cbb5                	beqz	a5,8001054a <.L92>
800104d8:	000aa783          	lw	a5,0(s5)
800104dc:	1008                	add	a0,sp,32
800104de:	004a8413          	add	s0,s5,4
800104e2:	4398                	lw	a4,0(a5)
800104e4:	8aa2                	mv	s5,s0
800104e6:	d03a                	sw	a4,32(sp)
800104e8:	43d8                	lw	a4,4(a5)
800104ea:	d23a                	sw	a4,36(sp)
800104ec:	4798                	lw	a4,8(a5)
800104ee:	d43a                	sw	a4,40(sp)
800104f0:	47dc                	lw	a5,12(a5)
800104f2:	d63e                	sw	a5,44(sp)
800104f4:	f28ff0ef          	jal	8000fc1c <__trunctfsf2>
800104f8:	8baa                	mv	s7,a0

800104fa <.L93>:
800104fa:	10097793          	and	a5,s2,256
800104fe:	c3ad                	beqz	a5,80010560 <.L240>
80010500:	e889                	bnez	s1,80010512 <.L94>
80010502:	6785                	lui	a5,0x1
80010504:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
80010508:	00f974b3          	and	s1,s2,a5
8001050c:	8c9d                	sub	s1,s1,a5
8001050e:	0014b493          	seqz	s1,s1

80010512 <.L94>:
80010512:	855e                	mv	a0,s7
80010514:	abffb0ef          	jal	8000bfd2 <__SEGGER_RTL_float32_isinf>
80010518:	c531                	beqz	a0,80010564 <.L95>

8001051a <.L117>:
8001051a:	6409                	lui	s0,0x2
8001051c:	00000593          	li	a1,0
80010520:	855e                	mv	a0,s7
80010522:	00897433          	and	s0,s2,s0
80010526:	fdefb0ef          	jal	8000bd04 <__ltsf2>
8001052a:	3e055963          	bgez	a0,8001091c <.L341>
8001052e:	3e040463          	beqz	s0,80010916 <.L244>
80010532:	db418413          	add	s0,gp,-588 # 80009120 <.LC1>
80010536:	a089                	j	80010578 <.L122>

80010538 <.L57>:
80010538:	6789                	lui	a5,0x2
8001053a:	00fbebb3          	or	s7,s7,a5

8001053e <.L53>:
8001053e:	6905                	lui	s2,0x1
80010540:	80090913          	add	s2,s2,-2048 # 800 <__ILM_segment_used_end__+0x13a>

80010544 <.L353>:
80010544:	012be933          	or	s2,s7,s2
80010548:	b769                	j	800104d2 <.L91>

8001054a <.L92>:
8001054a:	007a8793          	add	a5,s5,7
8001054e:	9be1                	and	a5,a5,-8
80010550:	4388                	lw	a0,0(a5)
80010552:	43cc                	lw	a1,4(a5)
80010554:	00878a93          	add	s5,a5,8 # 2008 <__APB_SRAM_segment_size__+0x8>
80010558:	969fb0ef          	jal	8000bec0 <__truncdfsf2>
8001055c:	8baa                	mv	s7,a0
8001055e:	bf71                	j	800104fa <.L93>

80010560 <.L240>:
80010560:	4499                	li	s1,6
80010562:	bf45                	j	80010512 <.L94>

80010564 <.L95>:
80010564:	855e                	mv	a0,s7
80010566:	a5bfb0ef          	jal	8000bfc0 <__SEGGER_RTL_float32_isnan>
8001056a:	cd09                	beqz	a0,80010584 <.L101>
8001056c:	01291793          	sll	a5,s2,0x12
80010570:	0007d763          	bgez	a5,8001057e <.L243>
80010574:	dd418413          	add	s0,gp,-556 # 80009140 <.LC5>

80010578 <.L122>:
80010578:	eff97913          	and	s2,s2,-257
8001057c:	bb61                	j	80010314 <.L65>

8001057e <.L243>:
8001057e:	dd818413          	add	s0,gp,-552 # 80009144 <.LC6>
80010582:	bfdd                	j	80010578 <.L122>

80010584 <.L101>:
80010584:	855e                	mv	a0,s7
80010586:	a5bfb0ef          	jal	8000bfe0 <__SEGGER_RTL_float32_isnormal>
8001058a:	e119                	bnez	a0,80010590 <.L103>
8001058c:	00000b93          	li	s7,0

80010590 <.L103>:
80010590:	855e                	mv	a0,s7
80010592:	845e                	mv	s0,s7
80010594:	eacff0ef          	jal	8000fc40 <__SEGGER_RTL_float32_signbit>
80010598:	c519                	beqz	a0,800105a6 <.L104>
8001059a:	80000437          	lui	s0,0x80000
8001059e:	06096913          	or	s2,s2,96
800105a2:	01744433          	xor	s0,s0,s7

800105a6 <.L104>:
800105a6:	184c                	add	a1,sp,52
800105a8:	8522                	mv	a0,s0
800105aa:	edeff0ef          	jal	8000fc88 <frexpf>
800105ae:	5752                	lw	a4,52(sp)
800105b0:	478d                	li	a5,3
800105b2:	00000593          	li	a1,0
800105b6:	02e787b3          	mul	a5,a5,a4
800105ba:	4729                	li	a4,10
800105bc:	8522                	mv	a0,s0
800105be:	8ba2                	mv	s7,s0
800105c0:	02e7c7b3          	div	a5,a5,a4
800105c4:	da3e                	sw	a5,52(sp)
800105c6:	d82ff0ef          	jal	8000fb48 <__eqsf2>
800105ca:	24051063          	bnez	a0,8001080a <.L105>

800105ce <.L111>:
800105ce:	6785                	lui	a5,0x1
800105d0:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
800105d4:	00f97c33          	and	s8,s2,a5
800105d8:	40000713          	li	a4,1024
800105dc:	5552                	lw	a0,52(sp)
800105de:	24ec1d63          	bne	s8,a4,80010838 <.L340>

800105e2 <.L106>:
800105e2:	02600793          	li	a5,38
800105e6:	30f51f63          	bne	a0,a5,80010904 <.L113>
800105ea:	fb81a583          	lw	a1,-72(gp) # 80009324 <.Lmerged_single+0x10>
800105ee:	855e                	mv	a0,s7
800105f0:	a98ff0ef          	jal	8000f888 <__divsf3>

800105f4 <.L354>:
800105f4:	00000593          	li	a1,0
800105f8:	8baa                	mv	s7,a0
800105fa:	842a                	mv	s0,a0
800105fc:	d4cff0ef          	jal	8000fb48 <__eqsf2>
80010600:	cd39                	beqz	a0,8001065e <.L116>
80010602:	855e                	mv	a0,s7
80010604:	9cffb0ef          	jal	8000bfd2 <__SEGGER_RTL_float32_isinf>
80010608:	f00519e3          	bnez	a0,8001051a <.L117>
8001060c:	57d2                	lw	a5,52(sp)
8001060e:	4701                	li	a4,0

80010610 <.L118>:
80010610:	c63e                	sw	a5,12(sp)
80010612:	00178d13          	add	s10,a5,1
80010616:	fb01a583          	lw	a1,-80(gp) # 8000931c <.Lmerged_single+0x8>
8001061a:	855e                	mv	a0,s7
8001061c:	cc3a                	sw	a4,24(sp)
8001061e:	f88fb0ef          	jal	8000bda6 <__gesf2>
80010622:	47b2                	lw	a5,12(sp)
80010624:	4762                	lw	a4,24(sp)
80010626:	30055763          	bgez	a0,80010934 <.L124>
8001062a:	c319                	beqz	a4,80010630 <.L125>
8001062c:	845e                	mv	s0,s7
8001062e:	da3e                	sw	a5,52(sp)

80010630 <.L125>:
80010630:	fac1a703          	lw	a4,-84(gp) # 80009318 <.Lmerged_single+0x4>
80010634:	5d52                	lw	s10,52(sp)
80010636:	fb01ac83          	lw	s9,-80(gp) # 8000931c <.Lmerged_single+0x8>
8001063a:	87a2                	mv	a5,s0
8001063c:	4681                	li	a3,0
8001063e:	c63a                	sw	a4,12(sp)

80010640 <.L126>:
80010640:	45b2                	lw	a1,12(sp)
80010642:	853e                	mv	a0,a5
80010644:	ce36                	sw	a3,28(sp)
80010646:	cc3e                	sw	a5,24(sp)
80010648:	ebcfb0ef          	jal	8000bd04 <__ltsf2>
8001064c:	47e2                	lw	a5,24(sp)
8001064e:	46f2                	lw	a3,28(sp)
80010650:	fffd0b93          	add	s7,s10,-1
80010654:	2e054963          	bltz	a0,80010946 <.L127>
80010658:	c299                	beqz	a3,8001065e <.L116>
8001065a:	843e                	mv	s0,a5
8001065c:	da6a                	sw	s10,52(sp)

8001065e <.L116>:
8001065e:	c499                	beqz	s1,8001066c <.L129>
80010660:	6785                	lui	a5,0x1
80010662:	c0078793          	add	a5,a5,-1024 # c00 <__NOR_CFG_OPTION_segment_size__>
80010666:	00fc1363          	bne	s8,a5,8001066c <.L129>
8001066a:	14fd                	add	s1,s1,-1

8001066c <.L129>:
8001066c:	40900533          	neg	a0,s1
80010670:	aeafc0ef          	jal	8000c95a <__SEGGER_RTL_pow10f>
80010674:	55fd                	li	a1,-1
80010676:	dceff0ef          	jal	8000fc44 <ldexpf>
8001067a:	85a2                	mv	a1,s0
8001067c:	cdafb0ef          	jal	8000bb56 <__addsf3>
80010680:	fb01a583          	lw	a1,-80(gp) # 8000931c <.Lmerged_single+0x8>
80010684:	8baa                	mv	s7,a0
80010686:	842a                	mv	s0,a0
80010688:	f1efb0ef          	jal	8000bda6 <__gesf2>
8001068c:	00054b63          	bltz	a0,800106a2 <.L130>
80010690:	57d2                	lw	a5,52(sp)
80010692:	fb01a583          	lw	a1,-80(gp) # 8000931c <.Lmerged_single+0x8>
80010696:	855e                	mv	a0,s7
80010698:	0785                	add	a5,a5,1
8001069a:	da3e                	sw	a5,52(sp)
8001069c:	9ecff0ef          	jal	8000f888 <__divsf3>
800106a0:	842a                	mv	s0,a0

800106a2 <.L130>:
800106a2:	c622                	sw	s0,12(sp)
800106a4:	2a049963          	bnez	s1,80010956 <.L132>

800106a8 <.L135>:
800106a8:	4481                	li	s1,0

800106aa <.L133>:
800106aa:	00548793          	add	a5,s1,5
800106ae:	7c7d                	lui	s8,0xfffff
800106b0:	40fb0b33          	sub	s6,s6,a5
800106b4:	08097793          	and	a5,s2,128
800106b8:	7ffc0c13          	add	s8,s8,2047 # fffff7ff <__APB_SRAM_segment_end__+0xbf0d7ff>
800106bc:	8fc5                	or	a5,a5,s1
800106be:	01897c33          	and	s8,s2,s8
800106c2:	c391                	beqz	a5,800106c6 <.L139>
800106c4:	1b7d                	add	s6,s6,-1

800106c6 <.L139>:
800106c6:	01391793          	sll	a5,s2,0x13
800106ca:	4d05                	li	s10,1
800106cc:	0207dc63          	bgez	a5,80010704 <.L140>
800106d0:	5bd2                	lw	s7,52(sp)
800106d2:	470d                	li	a4,3
800106d4:	02ebe733          	rem	a4,s7,a4
800106d8:	c31d                	beqz	a4,800106fe <.L141>
800106da:	0709                	add	a4,a4,2
800106dc:	56b5                	li	a3,-19
800106de:	40e6d733          	sra	a4,a3,a4
800106e2:	8b05                	and	a4,a4,1
800106e4:	2c070663          	beqz	a4,800109b0 <.L142>
800106e8:	fb01a583          	lw	a1,-80(gp) # 8000931c <.Lmerged_single+0x8>
800106ec:	4532                	lw	a0,12(sp)
800106ee:	1b7d                	add	s6,s6,-1
800106f0:	4d09                	li	s10,2
800106f2:	fd7fe0ef          	jal	8000f6c8 <__mulsf3>
800106f6:	fffb8793          	add	a5,s7,-1
800106fa:	842a                	mv	s0,a0
800106fc:	da3e                	sw	a5,52(sp)

800106fe <.L141>:
800106fe:	0004d363          	bgez	s1,80010704 <.L140>
80010702:	4481                	li	s1,0

80010704 <.L140>:
80010704:	06097913          	and	s2,s2,96
80010708:	00090363          	beqz	s2,8001070e <.L144>
8001070c:	1b7d                	add	s6,s6,-1

8001070e <.L144>:
8001070e:	5552                	lw	a0,52(sp)
80010710:	9bafc0ef          	jal	8000c8ca <abs>
80010714:	06300793          	li	a5,99
80010718:	00a7d363          	bge	a5,a0,8001071e <.L145>
8001071c:	1b7d                	add	s6,s6,-1

8001071e <.L145>:
8001071e:	8522                	mv	a0,s0
80010720:	c54ff0ef          	jal	8000fb74 <__fixunssfdi>
80010724:	8bae                	mv	s7,a1
80010726:	8caa                	mv	s9,a0
80010728:	eeefb0ef          	jal	8000be16 <__floatundisf>
8001072c:	85aa                	mv	a1,a0
8001072e:	8522                	mv	a0,s0
80010730:	c1efb0ef          	jal	8000bb4e <__subsf3>
80010734:	842a                	mv	s0,a0

80010736 <.L146>:
80010736:	895a                	mv	s2,s6
80010738:	000b5363          	bgez	s6,8001073e <.L165>
8001073c:	4901                	li	s2,0

8001073e <.L165>:
8001073e:	210c7793          	and	a5,s8,528
80010742:	e399                	bnez	a5,80010748 <.L167>

80010744 <.L166>:
80010744:	2e091d63          	bnez	s2,80010a3e <.L168>

80010748 <.L167>:
80010748:	020c7713          	and	a4,s8,32
8001074c:	040c7793          	and	a5,s8,64
80010750:	2e070e63          	beqz	a4,80010a4c <.L169>
80010754:	02b00593          	li	a1,43
80010758:	c399                	beqz	a5,8001075e <.L358>
8001075a:	02d00593          	li	a1,45

8001075e <.L358>:
8001075e:	854e                	mv	a0,s3
80010760:	fc8ff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>

80010764 <.L171>:
80010764:	010c7793          	and	a5,s8,16
80010768:	e399                	bnez	a5,8001076e <.L173>

8001076a <.L172>:
8001076a:	2e091663          	bnez	s2,80010a56 <.L174>

8001076e <.L173>:
8001076e:	80003b37          	lui	s6,0x80003
80010772:	0a0b0b13          	add	s6,s6,160 # 800030a0 <__SEGGER_RTL_ipow10>

80010776 <.L178>:
80010776:	1d7d                	add	s10,s10,-1
80010778:	003d1793          	sll	a5,s10,0x3
8001077c:	97da                	add	a5,a5,s6
8001077e:	4398                	lw	a4,0(a5)
80010780:	43dc                	lw	a5,4(a5)
80010782:	03000593          	li	a1,48

80010786 <.L175>:
80010786:	00fbe663          	bltu	s7,a5,80010792 <.L258>
8001078a:	2d779d63          	bne	a5,s7,80010a64 <.L176>
8001078e:	2cecfb63          	bgeu	s9,a4,80010a64 <.L176>

80010792 <.L258>:
80010792:	854e                	mv	a0,s3
80010794:	f94ff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>
80010798:	fc0d1fe3          	bnez	s10,80010776 <.L178>
8001079c:	6b85                	lui	s7,0x1
8001079e:	800b8b93          	add	s7,s7,-2048 # 800 <__ILM_segment_used_end__+0x13a>
800107a2:	017c7bb3          	and	s7,s8,s7
800107a6:	2e0b9363          	bnez	s7,80010a8c <.L179>

800107aa <.L183>:
800107aa:	080c7793          	and	a5,s8,128
800107ae:	8fc5                	or	a5,a5,s1
800107b0:	c3a1                	beqz	a5,800107f0 <.L181>
800107b2:	02e00593          	li	a1,46
800107b6:	854e                	mv	a0,s3
800107b8:	f70ff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>
800107bc:	47c1                	li	a5,16
800107be:	8ca6                	mv	s9,s1
800107c0:	2c97da63          	bge	a5,s1,80010a94 <.L186>
800107c4:	4cc1                	li	s9,16

800107c6 <.L187>:
800107c6:	419484b3          	sub	s1,s1,s9
800107ca:	8566                	mv	a0,s9
800107cc:	000b8563          	beqz	s7,800107d6 <.L359>
800107d0:	5552                	lw	a0,52(sp)
800107d2:	40ac8533          	sub	a0,s9,a0

800107d6 <.L359>:
800107d6:	984fc0ef          	jal	8000c95a <__SEGGER_RTL_pow10f>
800107da:	85a2                	mv	a1,s0
800107dc:	eedfe0ef          	jal	8000f6c8 <__mulsf3>
800107e0:	b94ff0ef          	jal	8000fb74 <__fixunssfdi>
800107e4:	8baa                	mv	s7,a0
800107e6:	842e                	mv	s0,a1

800107e8 <.L193>:
800107e8:	2a0c9a63          	bnez	s9,80010a9c <.L194>

800107ec <.L195>:
800107ec:	2e049563          	bnez	s1,80010ad6 <.L196>

800107f0 <.L181>:
800107f0:	400c7793          	and	a5,s8,1024
800107f4:	2e079863          	bnez	a5,80010ae4 <.L184>

800107f8 <.L201>:
800107f8:	a2090ee3          	beqz	s2,80010234 <.L4>
800107fc:	197d                	add	s2,s2,-1
800107fe:	02000593          	li	a1,32
80010802:	ae81                	j	80010b52 <.L360>

80010804 <.L108>:
80010804:	57d2                	lw	a5,52(sp)
80010806:	0785                	add	a5,a5,1
80010808:	da3e                	sw	a5,52(sp)

8001080a <.L105>:
8001080a:	5552                	lw	a0,52(sp)
8001080c:	0505                	add	a0,a0,1 # 1001 <__NOR_CFG_OPTION_segment_size__+0x401>
8001080e:	94cfc0ef          	jal	8000c95a <__SEGGER_RTL_pow10f>
80010812:	85aa                	mv	a1,a0
80010814:	855e                	mv	a0,s7
80010816:	d5efb0ef          	jal	8000bd74 <__gtsf2>
8001081a:	fea045e3          	bgtz	a0,80010804 <.L108>

8001081e <.L109>:
8001081e:	5552                	lw	a0,52(sp)
80010820:	93afc0ef          	jal	8000c95a <__SEGGER_RTL_pow10f>
80010824:	85aa                	mv	a1,a0
80010826:	855e                	mv	a0,s7
80010828:	cdcfb0ef          	jal	8000bd04 <__ltsf2>
8001082c:	da0551e3          	bgez	a0,800105ce <.L111>
80010830:	57d2                	lw	a5,52(sp)
80010832:	17fd                	add	a5,a5,-1
80010834:	da3e                	sw	a5,52(sp)
80010836:	b7e5                	j	8001081e <.L109>

80010838 <.L340>:
80010838:	00fc1763          	bne	s8,a5,80010846 <.L112>
8001083c:	da9553e3          	bge	a0,s1,800105e2 <.L106>
80010840:	57f1                	li	a5,-4
80010842:	0cf54163          	blt	a0,a5,80010904 <.L113>

80010846 <.L112>:
80010846:	08097793          	and	a5,s2,128
8001084a:	c63e                	sw	a5,12(sp)
8001084c:	40097793          	and	a5,s2,1024
80010850:	c789                	beqz	a5,8001085a <.L147>
80010852:	47b9                	li	a5,14
80010854:	16a7da63          	bge	a5,a0,800109c8 <.L148>

80010858 <.L153>:
80010858:	4481                	li	s1,0

8001085a <.L147>:
8001085a:	57d2                	lw	a5,52(sp)
8001085c:	40900533          	neg	a0,s1
80010860:	bff97c13          	and	s8,s2,-1025
80010864:	ff178713          	add	a4,a5,-15
80010868:	00e55463          	bge	a0,a4,80010870 <.L154>
8001086c:	ff078513          	add	a0,a5,-16

80010870 <.L154>:
80010870:	8eafc0ef          	jal	8000c95a <__SEGGER_RTL_pow10f>
80010874:	55fd                	li	a1,-1
80010876:	bceff0ef          	jal	8000fc44 <ldexpf>
8001087a:	85aa                	mv	a1,a0
8001087c:	855e                	mv	a0,s7
8001087e:	ad8fb0ef          	jal	8000bb56 <__addsf3>
80010882:	8d2a                	mv	s10,a0
80010884:	842a                	mv	s0,a0
80010886:	5552                	lw	a0,52(sp)
80010888:	0505                	add	a0,a0,1
8001088a:	8d0fc0ef          	jal	8000c95a <__SEGGER_RTL_pow10f>
8001088e:	85ea                	mv	a1,s10
80010890:	caefb0ef          	jal	8000bd3e <__lesf2>
80010894:	00a04563          	bgtz	a0,8001089e <.L156>
80010898:	57d2                	lw	a5,52(sp)
8001089a:	0785                	add	a5,a5,1
8001089c:	da3e                	sw	a5,52(sp)

8001089e <.L156>:
8001089e:	57d2                	lw	a5,52(sp)
800108a0:	1807c963          	bltz	a5,80010a32 <.L158>
800108a4:	4541                	li	a0,16
800108a6:	16f55863          	bge	a0,a5,80010a16 <.L159>
800108aa:	ff078713          	add	a4,a5,-16
800108ae:	8d1d                	sub	a0,a0,a5
800108b0:	da3a                	sw	a4,52(sp)
800108b2:	8a8fc0ef          	jal	8000c95a <__SEGGER_RTL_pow10f>
800108b6:	85ea                	mv	a1,s10
800108b8:	e11fe0ef          	jal	8000f6c8 <__mulsf3>
800108bc:	ab8ff0ef          	jal	8000fb74 <__fixunssfdi>
800108c0:	8caa                	mv	s9,a0
800108c2:	8bae                	mv	s7,a1
800108c4:	00000413          	li	s0,0

800108c8 <.L160>:
800108c8:	800037b7          	lui	a5,0x80003
800108cc:	0a078793          	add	a5,a5,160 # 800030a0 <__SEGGER_RTL_ipow10>
800108d0:	4d05                	li	s10,1

800108d2 <.L161>:
800108d2:	47d8                	lw	a4,12(a5)
800108d4:	07a1                	add	a5,a5,8
800108d6:	00ebe763          	bltu	s7,a4,800108e4 <.L257>
800108da:	17771063          	bne	a4,s7,80010a3a <.L162>
800108de:	4398                	lw	a4,0(a5)
800108e0:	14ecfd63          	bgeu	s9,a4,80010a3a <.L162>

800108e4 <.L257>:
800108e4:	5752                	lw	a4,52(sp)
800108e6:	009d07b3          	add	a5,s10,s1
800108ea:	97ba                	add	a5,a5,a4
800108ec:	40fb0b33          	sub	s6,s6,a5
800108f0:	47b2                	lw	a5,12(sp)
800108f2:	8fc5                	or	a5,a5,s1
800108f4:	c391                	beqz	a5,800108f8 <.L164>
800108f6:	1b7d                	add	s6,s6,-1

800108f8 <.L164>:
800108f8:	06097793          	and	a5,s2,96
800108fc:	e2078de3          	beqz	a5,80010736 <.L146>
80010900:	1b7d                	add	s6,s6,-1
80010902:	bd15                	j	80010736 <.L146>

80010904 <.L113>:
80010904:	40a00533          	neg	a0,a0
80010908:	852fc0ef          	jal	8000c95a <__SEGGER_RTL_pow10f>
8001090c:	85aa                	mv	a1,a0
8001090e:	855e                	mv	a0,s7
80010910:	db9fe0ef          	jal	8000f6c8 <__mulsf3>
80010914:	b1c5                	j	800105f4 <.L354>

80010916 <.L244>:
80010916:	dbc18413          	add	s0,gp,-580 # 80009128 <.LC2>
8001091a:	b9b9                	j	80010578 <.L122>

8001091c <.L341>:
8001091c:	c809                	beqz	s0,8001092e <.L245>
8001091e:	dc418413          	add	s0,gp,-572 # 80009130 <.LC3>

80010922 <.L123>:
80010922:	02097793          	and	a5,s2,32
80010926:	c40799e3          	bnez	a5,80010578 <.L122>
8001092a:	0405                	add	s0,s0,1 # 80000001 <__NONCACHEABLE_RAM_segment_end__+0x3f000001>
8001092c:	b1b1                	j	80010578 <.L122>

8001092e <.L245>:
8001092e:	dcc18413          	add	s0,gp,-564 # 80009138 <.LC4>
80010932:	bfc5                	j	80010922 <.L123>

80010934 <.L124>:
80010934:	fb01a583          	lw	a1,-80(gp) # 8000931c <.Lmerged_single+0x8>
80010938:	855e                	mv	a0,s7
8001093a:	f4ffe0ef          	jal	8000f888 <__divsf3>
8001093e:	8baa                	mv	s7,a0
80010940:	87ea                	mv	a5,s10
80010942:	4705                	li	a4,1
80010944:	b1f1                	j	80010610 <.L118>

80010946 <.L127>:
80010946:	853e                	mv	a0,a5
80010948:	85e6                	mv	a1,s9
8001094a:	d7ffe0ef          	jal	8000f6c8 <__mulsf3>
8001094e:	87aa                	mv	a5,a0
80010950:	8d5e                	mv	s10,s7
80010952:	4685                	li	a3,1
80010954:	b1f5                	j	80010640 <.L126>

80010956 <.L132>:
80010956:	6785                	lui	a5,0x1
80010958:	88078793          	add	a5,a5,-1920 # 880 <__ILM_segment_used_end__+0x1ba>
8001095c:	00f977b3          	and	a5,s2,a5
80010960:	80078793          	add	a5,a5,-2048
80010964:	d40793e3          	bnez	a5,800106aa <.L133>
80010968:	47c1                	li	a5,16
8001096a:	0097d363          	bge	a5,s1,80010970 <.L134>
8001096e:	44c1                	li	s1,16

80010970 <.L134>:
80010970:	8526                	mv	a0,s1
80010972:	fe9fb0ef          	jal	8000c95a <__SEGGER_RTL_pow10f>
80010976:	85a2                	mv	a1,s0
80010978:	d51fe0ef          	jal	8000f6c8 <__mulsf3>
8001097c:	9f8ff0ef          	jal	8000fb74 <__fixunssfdi>
80010980:	00a5e7b3          	or	a5,a1,a0
80010984:	8c2a                	mv	s8,a0
80010986:	8d2e                	mv	s10,a1
80010988:	d20780e3          	beqz	a5,800106a8 <.L135>

8001098c <.L357>:
8001098c:	4629                	li	a2,10
8001098e:	4681                	li	a3,0
80010990:	b07fb0ef          	jal	8000c496 <__umoddi3>
80010994:	8d4d                	or	a0,a0,a1
80010996:	d0051ae3          	bnez	a0,800106aa <.L133>
8001099a:	8562                	mv	a0,s8
8001099c:	85ea                	mv	a1,s10
8001099e:	4629                	li	a2,10
800109a0:	4681                	li	a3,0
800109a2:	edcfb0ef          	jal	8000c07e <__udivdi3>
800109a6:	14fd                	add	s1,s1,-1
800109a8:	8c2a                	mv	s8,a0
800109aa:	8d2e                	mv	s10,a1
800109ac:	f0e5                	bnez	s1,8001098c <.L357>
800109ae:	b9ed                	j	800106a8 <.L135>

800109b0 <.L142>:
800109b0:	fb41a583          	lw	a1,-76(gp) # 80009320 <.Lmerged_single+0xc>
800109b4:	4532                	lw	a0,12(sp)
800109b6:	1b79                	add	s6,s6,-2
800109b8:	4d0d                	li	s10,3
800109ba:	d0ffe0ef          	jal	8000f6c8 <__mulsf3>
800109be:	ffeb8793          	add	a5,s7,-2
800109c2:	842a                	mv	s0,a0
800109c4:	da3e                	sw	a5,52(sp)
800109c6:	bb25                	j	800106fe <.L141>

800109c8 <.L148>:
800109c8:	0505                	add	a0,a0,1
800109ca:	8c89                	sub	s1,s1,a0
800109cc:	47c1                	li	a5,16
800109ce:	0097d363          	bge	a5,s1,800109d4 <.L149>
800109d2:	44c1                	li	s1,16

800109d4 <.L149>:
800109d4:	08097793          	and	a5,s2,128
800109d8:	e80791e3          	bnez	a5,8001085a <.L147>
800109dc:	fa81ac03          	lw	s8,-88(gp) # 80009314 <.Lmerged_single>
800109e0:	fb01a403          	lw	s0,-80(gp) # 8000931c <.Lmerged_single+0x8>

800109e4 <.L150>:
800109e4:	e6048ae3          	beqz	s1,80010858 <.L153>
800109e8:	8526                	mv	a0,s1
800109ea:	f71fb0ef          	jal	8000c95a <__SEGGER_RTL_pow10f>
800109ee:	85aa                	mv	a1,a0
800109f0:	855e                	mv	a0,s7
800109f2:	cd7fe0ef          	jal	8000f6c8 <__mulsf3>
800109f6:	85e2                	mv	a1,s8
800109f8:	95efb0ef          	jal	8000bb56 <__addsf3>
800109fc:	df6fb0ef          	jal	8000bff2 <floorf>
80010a00:	85a2                	mv	a1,s0
80010a02:	ab2ff0ef          	jal	8000fcb4 <fmodf>
80010a06:	00000593          	li	a1,0
80010a0a:	93eff0ef          	jal	8000fb48 <__eqsf2>
80010a0e:	e40516e3          	bnez	a0,8001085a <.L147>
80010a12:	14fd                	add	s1,s1,-1
80010a14:	bfc1                	j	800109e4 <.L150>

80010a16 <.L159>:
80010a16:	856a                	mv	a0,s10
80010a18:	da02                	sw	zero,52(sp)
80010a1a:	95aff0ef          	jal	8000fb74 <__fixunssfdi>
80010a1e:	8bae                	mv	s7,a1
80010a20:	8caa                	mv	s9,a0
80010a22:	bf4fb0ef          	jal	8000be16 <__floatundisf>
80010a26:	85aa                	mv	a1,a0
80010a28:	856a                	mv	a0,s10
80010a2a:	924fb0ef          	jal	8000bb4e <__subsf3>
80010a2e:	842a                	mv	s0,a0
80010a30:	bd61                	j	800108c8 <.L160>

80010a32 <.L158>:
80010a32:	da02                	sw	zero,52(sp)
80010a34:	4c81                	li	s9,0
80010a36:	4b81                	li	s7,0
80010a38:	bd41                	j	800108c8 <.L160>

80010a3a <.L162>:
80010a3a:	0d05                	add	s10,s10,1
80010a3c:	bd59                	j	800108d2 <.L161>

80010a3e <.L168>:
80010a3e:	02000593          	li	a1,32
80010a42:	854e                	mv	a0,s3
80010a44:	197d                	add	s2,s2,-1
80010a46:	ce2ff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>
80010a4a:	b9ed                	j	80010744 <.L166>

80010a4c <.L169>:
80010a4c:	d0078ce3          	beqz	a5,80010764 <.L171>
80010a50:	02000593          	li	a1,32
80010a54:	b329                	j	8001075e <.L358>

80010a56 <.L174>:
80010a56:	03000593          	li	a1,48
80010a5a:	854e                	mv	a0,s3
80010a5c:	197d                	add	s2,s2,-1
80010a5e:	ccaff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>
80010a62:	b321                	j	8001076a <.L172>

80010a64 <.L176>:
80010a64:	40ec86b3          	sub	a3,s9,a4
80010a68:	00dcb633          	sltu	a2,s9,a3
80010a6c:	0585                	add	a1,a1,1
80010a6e:	40fb8bb3          	sub	s7,s7,a5
80010a72:	0ff5f593          	zext.b	a1,a1
80010a76:	8cb6                	mv	s9,a3
80010a78:	40cb8bb3          	sub	s7,s7,a2
80010a7c:	b329                	j	80010786 <.L175>

80010a7e <.L182>:
80010a7e:	17fd                	add	a5,a5,-1
80010a80:	03000593          	li	a1,48
80010a84:	854e                	mv	a0,s3
80010a86:	da3e                	sw	a5,52(sp)
80010a88:	ca0ff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>

80010a8c <.L179>:
80010a8c:	57d2                	lw	a5,52(sp)
80010a8e:	fef048e3          	bgtz	a5,80010a7e <.L182>
80010a92:	bb21                	j	800107aa <.L183>

80010a94 <.L186>:
80010a94:	d204d9e3          	bgez	s1,800107c6 <.L187>
80010a98:	4c81                	li	s9,0
80010a9a:	b335                	j	800107c6 <.L187>

80010a9c <.L194>:
80010a9c:	1cfd                	add	s9,s9,-1
80010a9e:	003c9793          	sll	a5,s9,0x3
80010aa2:	97da                	add	a5,a5,s6
80010aa4:	4398                	lw	a4,0(a5)
80010aa6:	43dc                	lw	a5,4(a5)
80010aa8:	03000593          	li	a1,48

80010aac <.L190>:
80010aac:	00f46663          	bltu	s0,a5,80010ab8 <.L259>
80010ab0:	00879863          	bne	a5,s0,80010ac0 <.L191>
80010ab4:	00ebf663          	bgeu	s7,a4,80010ac0 <.L191>

80010ab8 <.L259>:
80010ab8:	854e                	mv	a0,s3
80010aba:	c6eff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>
80010abe:	b32d                	j	800107e8 <.L193>

80010ac0 <.L191>:
80010ac0:	40eb86b3          	sub	a3,s7,a4
80010ac4:	00dbb633          	sltu	a2,s7,a3
80010ac8:	0585                	add	a1,a1,1
80010aca:	8c1d                	sub	s0,s0,a5
80010acc:	0ff5f593          	zext.b	a1,a1
80010ad0:	8bb6                	mv	s7,a3
80010ad2:	8c11                	sub	s0,s0,a2
80010ad4:	bfe1                	j	80010aac <.L190>

80010ad6 <.L196>:
80010ad6:	03000593          	li	a1,48
80010ada:	854e                	mv	a0,s3
80010adc:	14fd                	add	s1,s1,-1
80010ade:	c4aff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>
80010ae2:	b329                	j	800107ec <.L195>

80010ae4 <.L184>:
80010ae4:	012c1793          	sll	a5,s8,0x12
80010ae8:	06500593          	li	a1,101
80010aec:	0007d463          	bgez	a5,80010af4 <.L197>
80010af0:	04500593          	li	a1,69

80010af4 <.L197>:
80010af4:	854e                	mv	a0,s3
80010af6:	c32ff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>
80010afa:	57d2                	lw	a5,52(sp)
80010afc:	0407df63          	bgez	a5,80010b5a <.L198>
80010b00:	02d00593          	li	a1,45
80010b04:	854e                	mv	a0,s3
80010b06:	c22ff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>
80010b0a:	57d2                	lw	a5,52(sp)
80010b0c:	40f007b3          	neg	a5,a5
80010b10:	da3e                	sw	a5,52(sp)

80010b12 <.L199>:
80010b12:	55d2                	lw	a1,52(sp)
80010b14:	06300793          	li	a5,99
80010b18:	00b7df63          	bge	a5,a1,80010b36 <.L200>
80010b1c:	06400413          	li	s0,100
80010b20:	0285c5b3          	div	a1,a1,s0
80010b24:	854e                	mv	a0,s3
80010b26:	03058593          	add	a1,a1,48
80010b2a:	bfeff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>
80010b2e:	57d2                	lw	a5,52(sp)
80010b30:	0287e7b3          	rem	a5,a5,s0
80010b34:	da3e                	sw	a5,52(sp)

80010b36 <.L200>:
80010b36:	55d2                	lw	a1,52(sp)
80010b38:	4429                	li	s0,10
80010b3a:	854e                	mv	a0,s3
80010b3c:	0285c5b3          	div	a1,a1,s0
80010b40:	03058593          	add	a1,a1,48
80010b44:	be4ff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>
80010b48:	55d2                	lw	a1,52(sp)
80010b4a:	0285e5b3          	rem	a1,a1,s0
80010b4e:	03058593          	add	a1,a1,48

80010b52 <.L360>:
80010b52:	854e                	mv	a0,s3
80010b54:	bd4ff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>
80010b58:	b145                	j	800107f8 <.L201>

80010b5a <.L198>:
80010b5a:	02b00593          	li	a1,43
80010b5e:	854e                	mv	a0,s3
80010b60:	bc8ff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>
80010b64:	b77d                	j	80010b12 <.L199>

80010b66 <.L205>:
80010b66:	6d21                	lui	s10,0x8
80010b68:	892e                	mv	s2,a1
80010b6a:	4c01                	li	s8,0
80010b6c:	01abfd33          	and	s10,s7,s10
80010b70:	470d                	li	a4,3
80010b72:	02c00813          	li	a6,44

80010b76 <.L208>:
80010b76:	012467b3          	or	a5,s0,s2
80010b7a:	c7b5                	beqz	a5,80010be6 <.L206>
80010b7c:	000d0d63          	beqz	s10,80010b96 <.L214>
80010b80:	003c7793          	and	a5,s8,3
80010b84:	00e79963          	bne	a5,a4,80010b96 <.L214>
80010b88:	030c0793          	add	a5,s8,48
80010b8c:	1018                	add	a4,sp,32
80010b8e:	97ba                	add	a5,a5,a4
80010b90:	ff078423          	sb	a6,-24(a5)
80010b94:	0c05                	add	s8,s8,1

80010b96 <.L214>:
80010b96:	1018                	add	a4,sp,32
80010b98:	030c0793          	add	a5,s8,48
80010b9c:	97ba                	add	a5,a5,a4
80010b9e:	4629                	li	a2,10
80010ba0:	4681                	li	a3,0
80010ba2:	8522                	mv	a0,s0
80010ba4:	85ca                	mv	a1,s2
80010ba6:	c63e                	sw	a5,12(sp)
80010ba8:	8effb0ef          	jal	8000c496 <__umoddi3>
80010bac:	47b2                	lw	a5,12(sp)
80010bae:	03050513          	add	a0,a0,48
80010bb2:	85ca                	mv	a1,s2
80010bb4:	fea78423          	sb	a0,-24(a5)
80010bb8:	4629                	li	a2,10
80010bba:	8522                	mv	a0,s0
80010bbc:	4681                	li	a3,0
80010bbe:	cc0fb0ef          	jal	8000c07e <__udivdi3>
80010bc2:	0c05                	add	s8,s8,1
80010bc4:	842a                	mv	s0,a0
80010bc6:	892e                	mv	s2,a1
80010bc8:	02c00813          	li	a6,44
80010bcc:	470d                	li	a4,3
80010bce:	b765                	j	80010b76 <.L208>

80010bd0 <.L204>:
80010bd0:	6709                	lui	a4,0x2
80010bd2:	4c01                	li	s8,0
80010bd4:	00ebf733          	and	a4,s7,a4
80010bd8:	d8c18693          	add	a3,gp,-628 # 800090f8 <__SEGGER_RTL_hex_lc>
80010bdc:	d9c18613          	add	a2,gp,-612 # 80009108 <__SEGGER_RTL_hex_uc>

80010be0 <.L209>:
80010be0:	00b467b3          	or	a5,s0,a1
80010be4:	e38d                	bnez	a5,80010c06 <.L212>

80010be6 <.L206>:
80010be6:	418484b3          	sub	s1,s1,s8
80010bea:	0004d363          	bgez	s1,80010bf0 <.L216>
80010bee:	4481                	li	s1,0

80010bf0 <.L216>:
80010bf0:	409b0b33          	sub	s6,s6,s1
80010bf4:	0ff00793          	li	a5,255
80010bf8:	418b0b33          	sub	s6,s6,s8
80010bfc:	0397f863          	bgeu	a5,s9,80010c2c <.L217>
80010c00:	1b7d                	add	s6,s6,-1

80010c02 <.L218>:
80010c02:	1b7d                	add	s6,s6,-1
80010c04:	a035                	j	80010c30 <.L219>

80010c06 <.L212>:
80010c06:	00f47793          	and	a5,s0,15
80010c0a:	cf19                	beqz	a4,80010c28 <.L210>
80010c0c:	97b2                	add	a5,a5,a2

80010c0e <.L361>:
80010c0e:	0007c783          	lbu	a5,0(a5)
80010c12:	1828                	add	a0,sp,56
80010c14:	9562                	add	a0,a0,s8
80010c16:	00f50023          	sb	a5,0(a0)
80010c1a:	8011                	srl	s0,s0,0x4
80010c1c:	01c59793          	sll	a5,a1,0x1c
80010c20:	0c05                	add	s8,s8,1
80010c22:	8c5d                	or	s0,s0,a5
80010c24:	8191                	srl	a1,a1,0x4
80010c26:	bf6d                	j	80010be0 <.L209>

80010c28 <.L210>:
80010c28:	97b6                	add	a5,a5,a3
80010c2a:	b7d5                	j	80010c0e <.L361>

80010c2c <.L217>:
80010c2c:	fc0c9be3          	bnez	s9,80010c02 <.L218>

80010c30 <.L219>:
80010c30:	200bf793          	and	a5,s7,512
80010c34:	e799                	bnez	a5,80010c42 <.L220>
80010c36:	865a                	mv	a2,s6
80010c38:	85de                	mv	a1,s7
80010c3a:	854e                	mv	a0,s3
80010c3c:	d93fb0ef          	jal	8000c9ce <__SEGGER_RTL_pre_padding>
80010c40:	4b01                	li	s6,0

80010c42 <.L220>:
80010c42:	0ff00793          	li	a5,255
80010c46:	0197fc63          	bgeu	a5,s9,80010c5e <.L221>
80010c4a:	03000593          	li	a1,48
80010c4e:	854e                	mv	a0,s3
80010c50:	ad8ff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>

80010c54 <.L222>:
80010c54:	85e6                	mv	a1,s9
80010c56:	854e                	mv	a0,s3
80010c58:	ad0ff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>
80010c5c:	a019                	j	80010c62 <.L223>

80010c5e <.L221>:
80010c5e:	fe0c9be3          	bnez	s9,80010c54 <.L222>

80010c62 <.L223>:
80010c62:	865a                	mv	a2,s6
80010c64:	85de                	mv	a1,s7
80010c66:	854e                	mv	a0,s3
80010c68:	d67fb0ef          	jal	8000c9ce <__SEGGER_RTL_pre_padding>
80010c6c:	8626                	mv	a2,s1
80010c6e:	03000593          	li	a1,48
80010c72:	854e                	mv	a0,s3
80010c74:	b50ff0ef          	jal	8000ffc4 <__SEGGER_RTL_print_padding>

80010c78 <.L224>:
80010c78:	1c7d                	add	s8,s8,-1
80010c7a:	e40c4c63          	bltz	s8,800102d2 <.L371>
80010c7e:	183c                	add	a5,sp,56
80010c80:	97e2                	add	a5,a5,s8
80010c82:	0007c583          	lbu	a1,0(a5)
80010c86:	854e                	mv	a0,s3
80010c88:	aa0ff0ef          	jal	8000ff28 <__SEGGER_RTL_putc>
80010c8c:	b7f5                	j	80010c78 <.L224>

80010c8e <.L34>:
80010c8e:	07800713          	li	a4,120
80010c92:	daf76163          	bltu	a4,a5,80010234 <.L4>

80010c96 <.L38>:
80010c96:	fa878713          	add	a4,a5,-88
80010c9a:	0ff77713          	zext.b	a4,a4
80010c9e:	02000693          	li	a3,32
80010ca2:	d8e6e963          	bltu	a3,a4,80010234 <.L4>
80010ca6:	46d2                	lw	a3,20(sp)
80010ca8:	070a                	sll	a4,a4,0x2
80010caa:	9736                	add	a4,a4,a3
80010cac:	4318                	lw	a4,0(a4)
80010cae:	8702                	jr	a4

Disassembly of section .text.libc.__SEGGER_RTL_ascii_isctype:

80010cb0 <__SEGGER_RTL_ascii_isctype>:
80010cb0:	07f00793          	li	a5,127
80010cb4:	02a7e063          	bltu	a5,a0,80010cd4 <.L3>
80010cb8:	f2818793          	add	a5,gp,-216 # 80009294 <__SEGGER_RTL_ascii_ctype_map>
80010cbc:	953e                	add	a0,a0,a5
80010cbe:	8000a7b7          	lui	a5,0x8000a
80010cc2:	01c78793          	add	a5,a5,28 # 8000a01c <__SEGGER_RTL_ascii_ctype_mask>
80010cc6:	95be                	add	a1,a1,a5
80010cc8:	00054503          	lbu	a0,0(a0)
80010ccc:	0005c783          	lbu	a5,0(a1)
80010cd0:	8d7d                	and	a0,a0,a5
80010cd2:	8082                	ret

80010cd4 <.L3>:
80010cd4:	4501                	li	a0,0
80010cd6:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_tolower:

80010cd8 <__SEGGER_RTL_ascii_tolower>:
80010cd8:	fbf50713          	add	a4,a0,-65
80010cdc:	47e5                	li	a5,25
80010cde:	00e7e463          	bltu	a5,a4,80010ce6 <.L7>
80010ce2:	02050513          	add	a0,a0,32

80010ce6 <.L7>:
80010ce6:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_iswctype:

80010ce8 <__SEGGER_RTL_ascii_iswctype>:
80010ce8:	07f00793          	li	a5,127
80010cec:	02a7e063          	bltu	a5,a0,80010d0c <.L10>
80010cf0:	f2818793          	add	a5,gp,-216 # 80009294 <__SEGGER_RTL_ascii_ctype_map>
80010cf4:	953e                	add	a0,a0,a5
80010cf6:	8000a7b7          	lui	a5,0x8000a
80010cfa:	01c78793          	add	a5,a5,28 # 8000a01c <__SEGGER_RTL_ascii_ctype_mask>
80010cfe:	95be                	add	a1,a1,a5
80010d00:	00054503          	lbu	a0,0(a0)
80010d04:	0005c783          	lbu	a5,0(a1)
80010d08:	8d7d                	and	a0,a0,a5
80010d0a:	8082                	ret

80010d0c <.L10>:
80010d0c:	4501                	li	a0,0
80010d0e:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_towlower:

80010d10 <__SEGGER_RTL_ascii_towlower>:
80010d10:	fbf50713          	add	a4,a0,-65
80010d14:	47e5                	li	a5,25
80010d16:	00e7e463          	bltu	a5,a4,80010d1e <.L14>
80010d1a:	02050513          	add	a0,a0,32

80010d1e <.L14>:
80010d1e:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_ascii_wctomb:

80010d20 <__SEGGER_RTL_ascii_wctomb>:
80010d20:	07f00793          	li	a5,127
80010d24:	00b7e663          	bltu	a5,a1,80010d30 <.L66>
80010d28:	00b50023          	sb	a1,0(a0)
80010d2c:	4505                	li	a0,1
80010d2e:	8082                	ret

80010d30 <.L66>:
80010d30:	5579                	li	a0,-2
80010d32:	8082                	ret

Disassembly of section .text.libc.__SEGGER_RTL_current_locale:

80010d34 <__SEGGER_RTL_current_locale>:
80010d34:	84022503          	lw	a0,-1984(tp) # fffff840 <__APB_SRAM_segment_end__+0xbf0d840>
80010d38:	e119                	bnez	a0,80010d3e <.L155>
80010d3a:	80020513          	add	a0,tp,-2048 # fffff800 <__APB_SRAM_segment_end__+0xbf0d800>

80010d3e <.L155>:
80010d3e:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_zero:

80011498 <__SEGGER_init_zero>:
80011498:	4008                	lw	a0,0(s0)
8001149a:	404c                	lw	a1,4(s0)
8001149c:	0421                	add	s0,s0,8
8001149e:	c591                	beqz	a1,800114aa <.L__SEGGER_init_zero_Done>

800114a0 <.L__SEGGER_init_zero_Loop>:
800114a0:	00050023          	sb	zero,0(a0)
800114a4:	0505                	add	a0,a0,1
800114a6:	15fd                	add	a1,a1,-1
800114a8:	fde5                	bnez	a1,800114a0 <.L__SEGGER_init_zero_Loop>

800114aa <.L__SEGGER_init_zero_Done>:
800114aa:	8082                	ret

Disassembly of section .segger.init.__SEGGER_init_copy:

800114ac <__SEGGER_init_copy>:
800114ac:	4008                	lw	a0,0(s0)
800114ae:	404c                	lw	a1,4(s0)
800114b0:	4410                	lw	a2,8(s0)
800114b2:	0431                	add	s0,s0,12
800114b4:	ca09                	beqz	a2,800114c6 <.L__SEGGER_init_copy_Done>

800114b6 <.L__SEGGER_init_copy_Loop>:
800114b6:	00058683          	lb	a3,0(a1)
800114ba:	00d50023          	sb	a3,0(a0)
800114be:	0505                	add	a0,a0,1
800114c0:	0585                	add	a1,a1,1
800114c2:	167d                	add	a2,a2,-1
800114c4:	fa6d                	bnez	a2,800114b6 <.L__SEGGER_init_copy_Loop>

800114c6 <.L__SEGGER_init_copy_Done>:
800114c6:	8082                	ret
