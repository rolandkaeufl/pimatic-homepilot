module.exports = {
  title: "pimatic-homepilot device config options"
  HomepilotSwitch: {
    title: "HomepilotSwitch config options"
    type: "object"
    properties:
      DeviceId:
        description: "Device ID (call `curl http://HOSTNAME/rest2/Index?do=/devices` for a list)"
        type: "number"
      interval:
        description: "Time interval (in s) after a state update is requested. If 0 then the state will not updated automatically."
        type: "number"
        default: 60
  }
  HomepilotDimmer: {
    title: "HomepilotDimmer config options"
    type: "object"
    properties:
      DeviceId:
        description: "Device ID (call `curl http://HOSTNAME/rest2/Index?do=/devices` for a list)"
        type: "number"
      interval:
        description: "Time interval (in s) after a state update is requested. If 0 then the state will not updated automatically."
        type: "number"
        default: 60
  }
  HomepilotShutter: {
    title: "HomepilotShutter config options"
    type: "object"
    properties:
      DeviceId:
        description: "Device ID (call `curl http://HOSTNAME/rest2/Index?do=/devices` for a list)"
        type: "number"
      interval:
        description: "Time interval (in s) after an update is requested. If 0 then the state will not updated automatically."
        type: "number"
        default: 60
  }
  HomepilotScene: {
    title: "HomepilotScene config options"
    type: "object"
    properties:
      SceneId:
        description: "Scene ID (call `curl http://HOSTNAME/rest2/Index?do=/scenes` for a list)"
        type: "number"
  }
}
