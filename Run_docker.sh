xhost +
docker run -ti -v /tmp/.X11-unix:/tmp/.X11-unix --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -e DISPLAY=$DISPLAY -v $(pwd)/Dataset:/home/Dataset --name=dyna --user $(id -u):$(id -g) \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    --volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
    --volume="/dev:/dev:rw" \
    --gpus all dyna bash

