#### 安装步骤

依赖库版本要求：

| Dependency | Version | Notes |
| :------------: | :----: | :--------: |
| cmake | >= 2.8.1 |  |
| ragel | 6.9 |  |
| python | 2.7 |  |
| boost | >=1.57 | boost header required |
| pcap | >= 0.8 | optional：needed for example only |

1. 安装gcc
```
yum install gcc gcc-c++ gdb -y
```

2. 安装cmake
```
yum install cmake -y
cmake --version
```

3. 安装ragel（[ragel包地址](http://www.colm.net/files/ragel/ragel-6.9.tar.gz)）
```
wget http://www.colm.net/files/ragel/ragel-6.9.tar.gz
tar -zxvf ragel-6.9.tar.gz
cd ragel-6.9
make && make install
rm ragel-6.9.tar.gz
```

4. 安装python2.7（centos7自带）

5. 安装pcap【可选项】
```
yum install libpcap -y
```

6. 拷贝boost库头文件（[boost库源码包地址](http://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.tar.gz)）
```
wget http://downloads.sourceforge.net/project/boost/boost/1.60.0/boost_1_60_0.tar.gz
tar -zxvf boost_1_6-_0.tar.gz
cp /home/boost_1_6-_0/boost /home/hyperscan-master/include
```

7. 安装Hyperscan（hs_build和hyperscan-master是在平级目录）
```
mkdir hs_build
cd hs_build
cmake ../hyperscan-master
make && make install
```

8. 运行测试用例
```
cd /home/hs_build/bin
./unit-hyperscan
```

#### 使用步骤

###### 寻找头文件

如果执行了make install，则默认在/usr/local/inc/hs下可以找到如下头文件：
```
hs.h
hs_common.h
hs_compile.h
hs_runtime.h
```

###### 寻找静态库

如果执行了make install，则默认在/usr/local/lib64/下可以找到如下库文件：
```
libhs.a
libhs_runtime.a
```

###### 编译C程序

编译时需指定头文件和静态库的位置，并加上 -lstdc++ 和 -lm 选项：
```
gcc main.c -I /home/zhangf/hyperscan_test/include/ -L /home/zhangf/hyperscan_test/lib/ -lhs -lhs_runtime -lstdc++ -lm
```
* -I /home/zhangf/hyperscan_test/include/： 指定头文件的位置
* -L /home/zhangf/hyperscan_test/lib/： 指定静态库的位置
* -lhs： 指定静态库的名称
* -lstdc++： 由于hyperscan使用C++实现，对外提供C接口，而gcc根据源文件后缀 .c 来确定源码语言以及所需要链接的库，加上-lstdc++表示使用C++库而不是C语言的库
* -lm：表示连接数学库

#### 参考文档

* [官方文档](http://intel.github.io/hyperscan/dev-reference/index.html)
