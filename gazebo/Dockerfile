FROM ubuntu:22.04

# Disable interactive prompts
ARG DEBIAN_FRONTEND=noninteractive

# Locale and timezone
ENV TZ=Asia/Tokyo
ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

# Base packages
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    locales \
    tzdata \
    sudo \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Generate locale
RUN locale-gen ja_JP ja_JP.UTF-8 \
    && update-locale LC_ALL=ja_JP.UTF-8 LANG=ja_JP.UTF-8

# Gazebo Harmonic repository
RUN curl -sSL http://packages.osrfoundation.org/gazebo.gpg -o /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        gz-harmonic \
        python3-pip vim git bash-completion && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 rosuser

RUN mkdir -p /workspace

ENV IGN_GAZEBO_RESOURCE_PATH=/workspace/models

WORKDIR /workspace

CMD ["/bin/bash"]
