# Copyright (c) 2021 HPMicro
# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.13)

find_package(hpm-sdk REQUIRED HINTS $ENV{HPM_SDK_BASE})

project(tran_receTest_core0)

# 包含目录
sdk_app_inc(../../common)
sdk_app_inc(../inc)
sdk_app_inc($ENV{HPM_SDK_PATH}/soc/HPM6700/ip)

# 主要源文件
sdk_app_src(../src/main0.c)
sdk_app_src(../../common/multicore_common.c)
sdk_app_src(../src/sec_core_img.c)
#sdk_app_src(../src/app_mbx.c)
sdk_app_src(../src/isr0.c)

# CAN相关源文件

sdk_app_src(../src/share_buffer.c)

# 生成IDE项目文件
generate_ide_projects()
