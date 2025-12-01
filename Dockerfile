FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04 

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV CUDA_HOME=/usr/local/cuda
ENV ROSDISTRO_INDEX_URL=https://mirrors.ustc.edu.cn/rosdistro/index-v4.yaml
ENV PIP_INDEX_URL=https://mirrors.ustc.edu.cn/pypi/simple

RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y \
    locales tzdata sudo curl wget gnupg2 lsb-release software-properties-common \
    bash-completion git nano net-tools iputils-ping build-essential libgl1-mesa-glx && \
    locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && dpkg-reconfigure -f noninteractive tzdata && \
    printf 'if ! shopt -oq posix; then\n  if [ -f /usr/share/bash-completion/bash_completion ]; then\n    . /usr/share/bash-completion/bash_completion\n  elif [ -f /etc/bash_completion ]; then\n    . /etc/bash_completion\n  fi\nfi\n' >> /etc/bash.bashrc

RUN mkdir -p /workspace && \
    echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc && \
    echo 'export ROSDISTRO_INDEX_URL=https://mirrors.ustc.edu.cn/rosdistro/index-v4.yaml' >> ~/.bashrc && \
    echo 'export DISABLE_ROS1_EOL_WARNINGS=1' >> ~/.bashrc && \
    sh -c '. /etc/lsb-release && echo "deb http://mirrors.ustc.edu.cn/ros/ubuntu/ `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    apt-get update && apt-get install -y \
    ros-noetic-desktop-full \
    python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool \
    python3-catkin-tools python3-osrf-pycommon python3-pip && \
    mkdir -p /etc/ros/rosdep/sources.list.d/ && \
    curl -o /etc/ros/rosdep/sources.list.d/20-default.list https://mirrors.ustc.edu.cn/rosdistro/rosdep/sources.list.d/20-default.list && \
    sed -i 's#raw.githubusercontent.com/ros/rosdistro/master#mirrors.ustc.edu.cn/rosdistro#g' /etc/ros/rosdep/sources.list.d/20-default.list && \
    rosdep update && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USERNAME=ros

RUN groupadd -g ${GROUP_ID} ${USERNAME} 2>/dev/null || true && \
    useradd -m -u ${USER_ID} -g ${GROUP_ID} -s /bin/bash ${USERNAME} 2>/dev/null || true && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /home/${USERNAME} && \
    chown -R ${USER_ID}:${GROUP_ID} /home/${USERNAME} /workspace && \
    echo "source /opt/ros/noetic/setup.bash" >> /home/${USERNAME}/.bashrc && \
    echo 'export ROSDISTRO_INDEX_URL=https://mirrors.ustc.edu.cn/rosdistro/index-v4.yaml' >> /home/${USERNAME}/.bashrc && \
    echo 'export DISABLE_ROS1_EOL_WARNINGS=1' >> /home/${USERNAME}/.bashrc

WORKDIR /workspace

USER ${USERNAME}

# ENTRYPOINT ["启动脚本/命令"]