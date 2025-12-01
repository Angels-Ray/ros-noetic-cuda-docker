# ROS Noetic CUDA Docker

基于 NVIDIA CUDA 的 ROS Noetic 容器，支持 GPU 和图形界面。

## 快速开始

### 依赖

根据 [Install Guide](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) 安装 [nvidia-container-toolkit](https://github.com/NVIDIA/nvidia-container-toolkit)

### 构建并启动容器

```bash
USER_ID=$(id -u) GROUP_ID=$(id -g) USERNAME=$(whoami) docker compose up --build -d
```

### 进入容器

```bash
docker exec -it ros_noetic bash
```

### 停止容器

```bash
docker compose down
```

## 关键内容

- ROS Noetic Desktop Full
- NVIDIA CUDA 11.7.1 + cuDNN 8
- X11 图形界面支持
- 用户权限匹配
- 中科大 ROS 源
