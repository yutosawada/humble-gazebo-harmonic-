# humble-gazebo-harmonic

This repository provides a Docker environment with ROS 2 Humble and Ignition Gazebo Harmonic.
The `workspace` directory in this repository is mounted into the container as `/workspace`.

## Models

A simple differential drive robot model is available at `workspace/models/simple_diff_bot`.
You can launch the model with Ignition Gazebo. When running directly on the host, use the path as shown below. Inside the container, prefix the path with `/` because `workspace` is mounted at `/workspace`.

```bash
ign gazebo -v 4 workspace/models/simple_diff_bot/model.sdf   # on the host
ign gazebo -v 4 /workspace/models/simple_diff_bot/model.sdf  # in the container
```

## Worlds

A minimal world file which spawns the robot using an `<include>` tag is available under `workspace/worlds`.
The world also brings in a basic ground plane from `workspace/models/ground_plane` so the robot spawns on a flat surface.
Add the `workspace/models` directory to `IGN_GAZEBO_RESOURCE_PATH` so the simulator can locate the model and then launch the world:

```bash
export IGN_GAZEBO_RESOURCE_PATH=$(pwd)/workspace/models   # on the host
export IGN_GAZEBO_RESOURCE_PATH=/workspace/models        # in the container
ign gazebo -v 4 workspace/worlds/simple_diff_bot_world.sdf   # on the host
ign gazebo -v 4 /workspace/worlds/simple_diff_bot_world.sdf  # in the container
```


