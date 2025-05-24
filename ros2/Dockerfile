FROM osrf/ros:humble-desktop

# Install Navigation2 packages and related dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ros-humble-navigation2 \
        ros-humble-nav2-bringup \
        ros-humble-nav2-simple-commander \
        ros-humble-slam-toolbox && \
    rm -rf /var/lib/apt/lists/*

# Create workspace directory
RUN mkdir -p /workspace
WORKDIR /workspace

# Copy ROS 2 workspace files
COPY . /workspace

# Default command launches a simple Navigation2 demo
CMD ["bash", "-c", "source /opt/ros/humble/setup.bash && ros2 launch nav2_bringup navigation_launch.py"]
