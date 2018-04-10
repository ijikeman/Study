sudo docker build -t dev-centos:7 ./dockerfiles/centos7/.
sudo docker run --name dev-centos -v `pwd`:/tmp -itd dev-centos:7 bash
sudo docker exec -it dev-centos bash

