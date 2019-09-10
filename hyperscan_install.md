##### 安装步骤

依赖库版本要求：

| Dependency | Version | Notes |
| :------------: | :----: | :--------: |
| cmake | >= 2.8.1 |  |
| ragel | 6.9 |  |
| python | 2.7 |  |
| boost | >=1.57 | boost header required |
| pcap | >= 0.8 | optional：needed for example only |

[官方文档](http://intel.github.io/hyperscan/dev-reference/index.html)

[参考网站](https://www.jianshu.com/p/98a139df8e17)

安装gcc
```
yum list | grep gcc
yum install gcc-c++ -y
```

安装cmake
```
rpm -qa | grep cmake
yum list | grep cmake
yum install cmake -y
```

安装ragel（[ragel包地址](http://www.colm.net/files/ragel/ragel-6.9.tar.gz)）
编译过程可能会出现警告，但不影响Hyperscan的编译。
```
wget http://www.colm.net/files/ragel/ragel-6.9.tar.gz
tar -zxvf ragel-6.9.tar.gz
cd ragel-6.9
make && make install 
```

安装python2.7（centos7自带）

安装pcap（可选项，用于编译示例程序）
```
yum list | grep pcap
yum install pcap -y
```

拷贝boost库头文件（[boost库源码包地址](http://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.tar.gz)）
```
wget http://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.tar.gz
tar -zxvf boost_1_6-_0.tar.gz
cp /home/boost_1_6-_0/boost /home/hyperscan-master/include
```

安装Hyperscan（hs_build和hyperscan-master是在平级目录）
```
mkdir hs_build
cd hs_build
cmake ../hyperscan-master
make
make install
```

运行测试用例
```
cd /home/hs_build/bin
./unit-hyperscan
```

##### 使用步骤

###### 寻找头文件

如果执行了make install，则默认在/usr/local/inc/hs下可以找到如下头文件：
```
hs_common.h
hs_compile.h
hs.h
hs_runtime.h
```

文件包含关系
![5b7eeac44df000567aac0cd37b9b6108.png](en-resource://database/10958:1)

文件内容
**hs_compile.h**：主要包含编译正则表达式数据库的各种接口；
**hs_runtime.h**：主要包含使用正则表达式数据库按提供的模式（如：块模式、流模式等）去匹配；
**hs_common.h**：主要定义了hs_compile.h和hs_runtime.h中接口的返回值（如：HS_SUCCESS等）以及将数据库序列化到文件，从文件反序列化数据库到内存等接口。

###### 寻找静态库

如果执行了make install，则默认在/usr/local/lib64/下可以找到如下库文件：
```
libhs.a
libhs_runtime.a
```

###### 编译C程序

编译时需指定头文件和静态库的位置；并且连接静态库的时候需要额外加上选项 -lstdc++ 和-lm；否则编译不过！

gcc语句如下：
```
gcc main.c -I /home/zhangf/hyperscan_test/include/ -L /home/zhangf/hyperscan_test/lib/ -lhs -lhs_runtime -lstdc++ -lm
```
* -I /home/zhangf/hyperscan_test/include/： 指定头文件的位置
* -L /home/zhangf/hyperscan_test/lib/： 指定静态库的位置
* -lhs： 指定静态库的名称（掐头去尾）
* -lstdc++： 由于hyperscan使用C++实现，对外提供的C接口；而gcc根据源文件后缀main.c的.c来确定源码所使用的语言以及所需要连接的库，所以在编译时需要加上-lstdc++来表示使用C++库而不是C语言的库，因为静态库中的接口依赖其他的C++库
* -lm 表示连接数学库，对应的头文件时math.h
