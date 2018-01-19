# Welcome to Swift FUSE
This repository provides an example of macOS and Linux cross platform Swift PM based realisation of HelloWorldFS

## macOS

1. Install [OSXFUSE](https://osxfuse.github.io)

2. _Install [Swift build toolchain](https://swift.org/download/)_. You can skip this step if you already have **Xcode** installed

3. Build

	>swift build -Xcc -DFUSE_USE_VERSION=26 -Xcc -D_FILE_OFFSET_BITS=64 -Xswiftc -I/usr/local/include/osxfuse -Xlinker -L/usr/local/lib

## Linux (Ubuntu 16.04 LTS)

  1. Install fuse development stuff

  	>apt-get update  
  	>apt-get install gcc fuse libfuse-dev make cmake  

  2. Install [Swift build toolchain](https://swift.org/download/)

  3. Build

    > swift build -Xcc -DFUSE_USE_VERSION=26 -Xcc -D_FILE_OFFSET_BITS=64 -Xswiftc -I/usr/include -Xlinker -L/usr/lib -Xcc -D_GNU_SOURCE
