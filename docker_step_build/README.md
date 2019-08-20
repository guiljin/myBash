一次性构建
==
>生成的镜像包括构建工具，体积比较大

`docker build -t go/helloworld:1 -f Dockerfile.one .`
***
二次构建
==
两个dockerfile
---
>Dockerfile.build完成编译产生可执行文件，Dockerfile.copy完成打包  
需要创建第一个镜像的容器并从中拷出可执行文件

`./build.sh`

单个dockerfile
---
>Dockerfile里面有两个FROM  
COPY支持从前一个镜像或任意镜像拷贝文件

`docker build -t go/helloworld:3 .`
***
其它
==

`docker build --target builder -t username/imagename:tag .`

`$COPY --from=nginx:latest /etc/nginx/nginx.conf /nginx.conf`
