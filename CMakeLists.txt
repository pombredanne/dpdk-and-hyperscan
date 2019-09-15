cmake_minimum_required(VERSION 2.8)

project(filter)

set(RTE_SDK /home/dpdk-and-hyperscan/dpdk/dpdk-stable-17.08.2)

set(RTE_TARGET x86_64-native-linuxapp-gcc)

set(INC_DIR /home/dpdk-and-hyperscan/dpdk/dpdk-stable-17.08.2/x86_64-native-linuxapp-gcc/include)

set(LINK_DIR /home/dpdk-and-hyperscan/dpdk/dpdk-stable-17.08.2/x86_64-native-linuxapp-gcc/lib)

aux_source_directory(./filter SRC_DIR)

include_directories(${INC_DIR})

link_directories(${LINK_DIR})

link_libraries(-Wl,--whole-archive rte_eal -Wl,--no-whole-archive)

add_executable(filter ${SRC_DIR})

target_link_libraries(filter rte_eal)
