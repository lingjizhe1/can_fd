# Copyright (c) 2021 HPMicro
# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.13)

set(HPM_BUILD_TYPE "sec_core_img")
set(SEC_CORE_IMG_C_ARRAY_OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/../src/sec_core_img.c)

find_package(hpm-sdk REQUIRED HINTS $ENV{HPM_SDK_BASE})

project(tran_receTest_core1)

# 包含目录
sdk_app_inc(../../common)
sdk_app_inc(../inc)
sdk_app_inc($ENV{HPM_SDK_PATH}/soc/HPM6700/ip)
# 主要源文件
sdk_app_src(../src/tran_receTest.c)
sdk_app_src(../src/app_mbx.c)

# 共享内存访问相关源文件 (Core1需要读取共享内存中的CAN数据)
sdk_app_src(../src/share_buffer.c)

# 注意：Core1通常不需要can_test.c的完整实现，只需要共享内存访问功能

generate_ide_projects()
