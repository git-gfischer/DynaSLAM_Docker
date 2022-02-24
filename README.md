# DynaSLAM Docker
This application builds DynaSLAM algorithm in a docker container. <br/>
DynaSLAM paper: https://arxiv.org/pdf/1806.05620.pdf <br/>
DynaSLAM git repository: https://github.com/BertaBescos/DynaSLAM

# Build the docker 
Run the following command to build the docker. Building the docker can take a while, and at least 20GB from disk space.
```
mkdir Dataset
sudo docker build -t dyna .
```

# Run the docker
The following command will open a docker terminal
```
./Run_docker.sh
```
# Access data from/to Docker
To move files from/to the docker just move to the ```Dataset``` folder (for example, the SLAM sequence dataset)

# Exit the docker
Inside the docker just type the following command, but the docker will still be activate when you leave:
```
exit
```
If you want to return to the docker process:
```
./Attach_docker.sh
```

# Kill docker process
Outside the docker, type the following command to show all docker process running
```
sudo docker ps -a
```
To kill a docker: 
```
sudo docker rm <CONTAINER ID> 
```

# Remove Docker image
Outside the docker, type the following command to show all docker images running
```
sudo docker images
```
To erase a docker image:
```
sudo docker rmi <IMAGE ID>
```

