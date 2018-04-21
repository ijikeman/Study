#sudo docker build -t dev-ubuntu:16.04 ./dockerfiles/ubuntu16/.
sudo docker run --rm --name dev-ubuntu -v /usr/src:/usr/src -v `pwd`:/tmp -itd dev-ubuntu:16.04 bash
