FROM ros:humble-ros-base

# Install Navigation2 packages and related dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ros-humble-rviz2 \
    ros-humble-rviz-default-plugins \
    ros-humble-rqt \  
    ros-humble-rqt-common-plugins \  
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-nav2-simple-commander \
    ros-humble-slam-toolbox \
    python3-pip vim git bash-completion \
    && rm -rf /var/lib/apt/lists/*

# Create workspace directory
RUN mkdir -p /root/ros2_ws
WORKDIR /root/ros2_ws

# Copy ROS 2 workspace files
# COPY . /ros2_ws

# Add ROS 2 setup to .bashrc for persistent environment
RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

# Default command launches a simple Navigation2 demo
CMD ["bash"]
