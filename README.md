pimatic-homepilot plugin
=======================

This is a pimatic plugin which allows you to control Rademacher devices using Homepilot(http://rademacher.de).

Configuration
-------------
You can load the plugin by editing your `config.json` to include:

    {
       "plugin": "homepilot",
       "hostname": "10.10.7.46" // set hostname
    }

Devices can be defined by adding them to the `devices` section in the config file.
Set the `class` attribute to `HomepilotSwitch`, `HomepilotDimmer`, `HomepilotShutter` or `HomepilotScene`. For example:

    {
      "class": "HomepilotSwitch",
      "id": "hp_switch",
      "name": "Wall Plug",
      "DeviceId": 10008,
      "interval": 30
    },
    {
      "class": "HomepilotDimmer",
      "id": "hp_dimmer",
      "name": "Dimmer",
      "DeviceId": 10009,
      "interval": 30
    },
    {
      "class": "HomepilotShutter",
      "id": "hp_shutter",
      "name": "Shutter",
      "DeviceId": 10001,
      "interval": 30
    },
    {
      "class": "HomepilotScene",
      "id": "hp_scene",
      "name": "Scene 1",
      "SceneId": 5006
    }

Figure the `DeviceId` out by calling `curl http://HOSTNAME/rest2/Index?do=/devices` or the `SceneId` by calling `curl http://HOSTNAME/rest2/Index?do=/scenes`
If the `interval` option is greater than 0 then the state of the device is updated automatically after the defined seconds.
