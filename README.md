# Minecraft Server for Docker

This docker image provides a Minecraft Server that will automatically download and build the latest stable version on startup.

To simply use the latest stable version, run

    docker run -d -p 25565:25565 darealromz/minecraft:latest

## Run commands in the Minecraft servers

You can send commands in the server by calling

    docker exec <container> send.sh <command>

example:

    docker exec minecraft send.sh op DaRealRomz

## EULA Support

Mojang now requires accepting the [Minecraft EULA](https://account.mojang.com/documents/minecraft_eula). To accept add

    -e EULA=true

such as

    docker run -d -e EULA=true -p 25565:25565 darealromz/minecraft:latest

## Attaching data directory to host filesystem

In order to readily access the Minecraft data, use the `-v` argument
to map a directory on your host machine to the container's `/minecraft/data` directory, such as:

    docker run -d -v /path/on/host:/minecraft/data ...

When attached in this way you can stop the server, edit the configuration under your attached `/path/on/host`
and start the server again with `docker start <container>` to pick up the new configuration.

## Running with Plugins

In order to add mods, you will need to attach the container's `/minecraft/data` directory
(see "Attaching data directory to host filesystem").
Then, you can add mods to the `/path/on/host/mods` folder you chose. From the example above,
the `/path/on/host` folder contents look like:

```
/path/on/host
├── plugins
│   └── ... INSTALL PLUGINS HERE ...
├── ops.json
├── server.properties
├── whitelist.json
└── ...
```

If you add mods while the container is running, you'll need to restart it to pick those
up:

    docker stop <container>
    docker start <container>

## JVM Configuration

### Memory Limit

The Java memory limit can be adjusted using the `JVM_ARGS` environment variable, where the default is
the setting shown in the example (max and min at 1024 MB):

    docker run -e JVM_ARGS='-Xmx1024M -Xms1024M' ...

## Issues

If you have any problems with or questions about this image, please contact me by submitting a ticket through a [GitHub issue](https://github.com/DaRealRomz/docker-minecraft/issues)
