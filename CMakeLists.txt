cmake_minimum_required(VERSION 2.8)

project(network_protocol_filtering)

set(RTE_SDK ${CMAKE_CURRENT_SOURCE_DIR}/dpdk/dpdk-stable-17.08.2)

set(RTE_TARGET x86_64-native-linuxapp-gcc)

set(INC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/dpdk/dpdk-stable-17.08.2/${RTE_TARGET}/include)

set(LINK_DIR ${CMAKE_CURRENT_SOURCE_DIR}/dpdk/dpdk-stable-17.08.2/${RTE_TARGET}/lib)

#message("CMAKE_CURRENT_SOURCE_DIR = ${CMAKE_CURRENT_SOURCE_DIR}")
#message("PROJECT_SOURCE_DIR = ${PROJECT_SOURCE_DIR}")
#message("PROJECT_BINARY_DIR = ${PROJECT_BINARY_DIR}")

set(BUILD_INIPARSER TRUE)

set(DPDK_LIBS
	rte_acl
	rte_bitratestats
	rte_cfgfile
	rte_cmdline
	rte_cryptodev
	rte_distributor
	rte_eal
	rte_efd
	rte_ethdev
	rte_eventdev
	rte_gro
	rte_hash
	rte_ip_frag
	rte_jobstats
	rte_kni
	rte_kvargs
	rte_latencystats
	rte_lpm
	rte_mbuf
	rte_mempool
	rte_mempool_ring
	rte_mempool_stack
	rte_meter
	rte_metrics
	rte_net
	rte_pdump
	rte_pipeline
	rte_pmd_af_packet
	rte_pmd_ark
	rte_pmd_avp
	rte_pmd_bnxt
	rte_pmd_bond
	rte_pmd_crypto_scheduler
	rte_pmd_cxgbe
	rte_pmd_e1000
	rte_pmd_ena
	rte_pmd_enic
	rte_pmd_failsafe
	rte_pmd_fm10k
	rte_pmd_i40e
	rte_pmd_ixgbe
	rte_pmd_kni
	rte_pmd_lio
	rte_pmd_nfp
	rte_pmd_null
	rte_pmd_null_crypto
	rte_pmd_octeontx_ssovf
	rte_pmd_qede
	rte_pmd_ring
	rte_pmd_sfc_efx
	rte_pmd_skeleton_event
	rte_pmd_sw_event
	rte_pmd_tap
	rte_pmd_thunderx_nicvf
	rte_pmd_vhost
	rte_pmd_virtio
	rte_pmd_vmxnet3_uio
	rte_port
	rte_power
	rte_reorder
	rte_ring
	rte_sched
	rte_table
	rte_timer
	rte_vhost)

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/iniparser AND BUILD_INIPARSER)
	message("-- build iniparser library")
	include_directories(iniparser)
	add_subdirectory(iniparser)
	set(EXTRA_LIBS ${EXTRA_LIBS} iniparser)
endif()

aux_source_directory(./filter SRC_DIR)

include_directories(${INC_DIR})

link_directories(${LINK_DIR})

link_libraries(-Wl,--whole-archive
	${DPDK_LIBS}
	-Wl,--no-whole-archive)

add_executable(main ${SRC_DIR})

set(EXTRA_LIBS ${EXTRA_LIBS} pthread)
set(EXTRA_LIBS ${EXTRA_LIBS} numa)
set(EXTRA_LIBS ${EXTRA_LIBS} m)
set(EXTRA_LIBS ${EXTRA_LIBS} dl)

target_link_libraries(main ${EXTRA_LIBS})
