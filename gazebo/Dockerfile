FROM ubuntu:22.04

# 対話型のプロンプトを無効化
ARG DEBIAN_FRONTEND=noninteractive

# タイムゾーンと日本語ロケールを設定
ENV TZ=Asia/Tokyo
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    locales \
    tzdata \
    sudo \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# 日本語ロケールを生成
RUN locale-gen ja_JP ja_JP.UTF-8 \
    && update-locale LC_ALL=ja_JP.UTF-8 LANG=ja_JP.UTF-8

# ROS 2のリポジトリ追加
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Gazebo Harmonicリポジトリ追加
RUN curl -sSL http://packages.osrfoundation.org/gazebo.gpg -o /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ros-humble-ros-base \
        ros-humble-navigation2 \
        ros-humble-nav2-bringup \
        ros-humble-slam-toolbox \
        ros-humble-rviz2 \
        ros-humble-ros-gz \
        ros-humble-ros-gz-sim \
        ros-humble-ros-gz-bridge \
        gz-harmonic \
        python3-pip vim git bash-completion && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 rosuser


# ワークスペースディレクトリの作成
RUN mkdir -p /workspace

# Gazebo のモデル検索パスを設定
ENV IGN_GAZEBO_RESOURCE_PATH=/workspace/models

# 作業ディレクトリを設定
WORKDIR /workspace

# ROS環境のセットアップをbashrcに追加
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

CMD ["/bin/bash"]
