#!/bin/bash

WORKDIR=$(builtin cd $(dirname $0) && pwd)

[[ -n ${MODEL} ]] || MODEL=mysupermodel
[[ -n ${IMAGE} ]] || IMAGE=${WORKDIR}/main
[[ -n ${CPUS} ]] || CPUS=4
[[ ${CPUS} < 1 ]] && CPUS=1

MAXCORE=$((CPUS-1))

cmd="${MODEL} \
	-S \
	-R \
	-C cluster0.NUM_CORES=${CPUS} \
	-C cache_state_modelled=0 \
	-C bp.pl011_uart0.uart_enable=1 \
	-C bp.dram_size=8 \
	-C bp.secure_memory=1 \
	-C bp.tzc_400.rst_region_base_high_1=0x0 \
	-C bp.tzc_400.rst_region_base_low_1=0x80000000 \
	-C bp.tzc_400.rst_region_top_high_1=0x0 \
	-C bp.tzc_400.rst_region_top_low_1=0xffffffff \
	-C bp.tzc_400.rst_region_attributes_1=0xc0000001 \
	-C bp.tzc_400.rst_region_id_access_1=0xffffffff \
	-C bp.tzc_400.rst_gate_keeper=0x1 \
	-C bp.refcounter.non_arch_start_at_default=1 \
	-C bp.refcounter.use_real_time=0 \
	$(eval for i in \{0..${MAXCORE}\}\; do echo '-a 'cluster0.cpu\$i=${IMAGE}\; done)"

	$cmd
