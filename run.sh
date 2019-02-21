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
	-C bp.secure_memory=0 \
	$(eval for i in \{0..${MAXCORE}\}\; do echo '-a 'cluster0.cpu\$i=${IMAGE}\; done)"

	$cmd
