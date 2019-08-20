docker build -t go/helloworld:1 -f Dockerfile.one .

./build.sh

docker build -t go/helloworld:3 .

docker build --target builder -t username/imagename:tag .

#COPY --from=nginx:latest /etc/nginx/nginx.conf /nginx.conf
