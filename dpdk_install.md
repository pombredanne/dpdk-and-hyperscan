#### centos7编译、配置和使用DPDK

##### 1. 安装gcc
```
yum install gcc gcc-c++ gdb -y
```

##### 2. 安装vim
```
yum install vim -y
```

##### 3. 安装NUMA
```
yum install numactl-libs.x86_64 numactl.x86_64 numactl-devel.x86_64 -y
```

##### 4. 获得kernel版本
```
uname -r
```

##### 5. 安装相应版本kernel-devel([kernel-devel-3.10.0-693.el7.x86_64.rpm](http://rpm.pbone.net/index.php3/stat/4/idpl/37924679/dir/scientific_linux_7/com/kernel-devel-3.10.0-693.el7.x86_64.rpm.html))
```
rpm -iv kernel-devel-3.10.0-693.el7.x86_64.rpm
```

##### 6. 使用快速构建脚本dpdk-setup.sh创建dpdk目标环境
* 执行脚本
```
./usertools/dpdk-setup.sh
```
* option:13 创建dpdk目标环境
```
[13] x86_64-native-linuxapp-gcc
```
* option:16 导入igb_uio模块
```
[16] Insert IGB UIO module
```
* option:20 设置numa架构cpu的hugepage页数(1G hugepagesz需要在系统启动时引导）
```
[19] Setup hugepage mappings for non-NUMA systems
[20] Setup hugepage mappings for NUMA systems
```
* option:22 绑定网卡到igb_uio模块(如果绑定失败，可以使用脚本./usertools/dpdk-devbind --bind=igb_uio --force <网卡地址如：02:06.0>绑定)
```
[22] Bind Ethernet/Crypto device to IGB UIO module
```
* option:21, 27 查看参数设置
```
[21] Display current Ethernet/Crypto device settings
[27] List hugepage info from /proc/meminfo
```

##### 7.运行测试程序testpmd
* option:26 运行testpmd
```
[26] Run testpmd application in interactive mode ($RTE_TARGET/app/testpmd)
```
* 可能遇到错误："找不到/app/testpmd" 解决方法如下：
```
export RTE_TARGET=x86_64-native-linuxapp-gcc
```
* 设置bitmask(参考./usertools/cpu_layout.py脚本执行结果)
```
bitmask:0x03
```
* 虚拟机环境可能遇到错误："EAL: Error reading from file descriptor 15: Input/output error" 需要更改代码使dpdk跳过PCI检查，并重新编译和导入igb_uio模块)
```
cd /home/DH/dpdk/dpdk-stable-17.08.2
vim lib/librte_eal/linuxapp/igb_uio/igb_uio.c
```
```
if (pci_intx_mask_supported(dev) || true) {
        dev_dbg(&dev->dev, "using INTX");
        udev->info.irq_flags = IRQF_SHARED | IRQF_NO_THREAD;
        udev->info.irq = dev->irq;
        udev->mode = RTE_INTR_MODE_LEGACY;
        break;
}
```

##### 8. 编译和运行/examples/helloworld
* 导入变量RTE_SDK、RTE_TARGET、EXTRA_CFLAGS
```
export RTE_SDK=/home/DH/dpdk/dpdk-stable-17.08.2
export RTE_TARGET=x86_64-native-linuxapp-gcc
export EXTRA_CFLAGS="-O0 -g"
```
* 编译helloworld
```
cd /examples/hellword
make
```
* 运行helloworld
```
./build/app/helloworld
```

##### 9. 参考文档

* [官方文档-英文](http://doc.dpdk.org/guides/linux_gsg/index.html)
* [官方文档-翻译](https://dpdk-docs.readthedocs.io/en/latest/linux_gsg/index.html)
