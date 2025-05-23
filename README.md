# humble-gazebo-harmonic

This repository provides a Docker environment with ROS 2 Humble and Ignition Gazebo Harmonic.
The `workspace` directory in this repository is mounted into the container as `/workspace`.

## Models

A simple differential drive robot model is available at `workspace/models/simple_diff_bot`.
You can launch the model with Ignition Gazebo:

```bash
ign gazebo -v 4 workspace/models/simple_diff_bot/model.sdf
```

## World

A minimal world file which spawns the robot using an `<include>` tag is
available under `workspace/worlds`.
Add the `workspace` directory to `IGN_GAZEBO_RESOURCE_PATH` so the simulator can
locate the model and then launch the world:

```bash
export IGN_GAZEBO_RESOURCE_PATH=$(pwd)/workspace
ign gazebo -v 4 workspace/worlds/simple_diff_bot_world.sdf
```
