pimatic-homepilot plugin
=======================

This is a pimatic plugin which allows you to control Rademacher devices using a Homepilot (http://rademacher.de).

Configuration
-------------
You can load the plugin by editing your `config.json`:

    {
       "plugin": "homepilot",
       "hostname": "192.168.2.46" // set hostname
    }

Devices can be defined by adding them to the `devices` section in the config file.
Set the `class` attribute to `HomepilotSwitch`, `HomepilotDimmer`, `HomepilotShutter` or `HomepilotScene`.
For example:

    {
      "name": "Wall Plug",
      "id": "hp_switch",
      "class": "HomepilotSwitch",
      "DeviceId": 10008,
      "interval": 30
    },
    {
      "name": "Dimmer",
      "id": "hp_dimmer",
      "class": "HomepilotDimmer",
      "DeviceId": 10009,
      "interval": 30
    },
    {
      "name": "Shutter",
      "id": "hp_shutter",
      "class": "HomepilotShutter",
      "DeviceId": 10001,
      "interval": 30
    },
    {
      "name": "Scenes",
      "id": "hp_scenes",
      "class": "HomepilotScene",
      "buttons": [
        {
          "id": "hp-scene-1",
          "text": "all up",
          "SceneId": 5005
        },
        {
          "id": "hp-scene-2",
          "text": "all down",
          "SceneId": 5006
        }
      ]
    }

Figure out the `DeviceId` by calling `curl http://HOSTNAME/rest2/Index?do=/devices` or the `SceneId` by calling `curl http://HOSTNAME/rest2/Index?do=/scenes`.
If the `interval` option is greater than 0 then the state of the device is updated automatically after the defined seconds (default = 60, disable = 0), not nessasary for the scenes.
