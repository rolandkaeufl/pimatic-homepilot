module.exports = (env) ->

  # ###require modules included in pimatic
  # To require modules that are included in pimatic use `env.require`. For available packages take
  # a look at the dependencies section in pimatics package.json
  Promise = env.require 'bluebird'
  assert = env.require 'cassert'
  rp = env.require 'request-promise'
  
  class HomepilotPlugin extends env.plugins.Plugin

    # ####init()
    # The `init` function is called by the framework to ask your plugin to initialise.
    #
    # #####params:
    #  * `app` is the [express] instance the framework is using.
    #  * `framework` the framework itself
    #  * `config` the properties the user specified as config for your plugin in the `plugins`
    #     section of the config.json file
    #
    #
    init: (app, @framework, @config) =>
      env.logger.info("initialized pimatic-homepilot with hostname " + @config.hostname)

      deviceConfigDef = require("./device-config-schema")
      @framework.deviceManager.registerDeviceClass("HomepilotSwitch", {
        configDef: deviceConfigDef.HomepilotSwitch,
        createCallback: (config) => new HomepilotSwitch(config)
      })
      @framework.deviceManager.registerDeviceClass("HomepilotDimmer", {
        configDef: deviceConfigDef.HomepilotDimmer,
        createCallback: (config) => new HomepilotDimmer(config)
      })
      @framework.deviceManager.registerDeviceClass("HomepilotShutter", {
        configDef: deviceConfigDef.HomepilotShutter,
        createCallback: (config) => new HomepilotShutter(config)
      })
      @framework.deviceManager.registerDeviceClass("HomepilotScene", {
        configDef: deviceConfigDef.HomepilotScene,
        createCallback: (config) => new HomepilotScene(config)
      })


    sendDeviceCommand: (DeviceId, command) ->
      address = "http://" + @config.hostname + "/rest2/Index?do=/devices/" + DeviceId + "?do=use&cmd=" + command
      env.logger.debug("sending command " + address)
      return rp(address)

    getDeviceDetails: (DeviceId) ->
      address = "http://" + @config.hostname + "/rest2/Index?do=/devices/" + DeviceId
      env.logger.debug("fetching device details " + address)
      return rp(address).then(JSON.parse)

    sendSceneCommand: (SceneId) ->
      address = "http://" + @config.hostname + "/rest2/Index?do=/scenes/" + SceneId + "?do=use"
      env.logger.debug("sending command " + address)
      return rp(address)

  class HomepilotSwitch extends env.devices.PowerSwitch

    constructor: (@config) ->
      @id = @config.id
      @name = @config.name
      @DeviceId = @config.DeviceId

      updateValue = =>
        if @config.interval > 0
          @getState().finally( =>
            setTimeout(updateValue, @config.interval * 1000)
          )

      super()
      updateValue()

    changeStateTo: (state) ->
      if @state is state then return
      command = if state then "10" else "11"
      return plugin.sendDeviceCommand(@DeviceId, command).then( =>
        @_setState(state)
      ).catch( (e) =>
        env.logger.error("state change failed with " + e.message)
      )

    getState: () ->
      return plugin.getDeviceDetails(@DeviceId).then( (json) =>
        state = json.device.position
        @_setState(state == "100")
        return @_state
      ).catch( (e) =>
        env.logger.error("state update failed with " + e.message)
        return @_state
      )


  class HomepilotDimmer extends env.devices.DimmerActuator

    constructor: (@config) ->
      @id = @config.id
      @name = @config.name
      @DeviceId = @config.DeviceId

      updateValue = =>
        if @config.interval > 0
          @getDimlevel().finally( =>
            setTimeout(updateValue, @config.interval * 1000)
          )

      super()
      updateValue()

    changeDimlevelTo: (level) ->
      if @_dimlevel is level then return
      return plugin.sendDeviceCommand(@DeviceId, "9&pos=#{level}").then( =>
        @_setDimlevel(level)
      ).catch( (e) =>
        env.logger.error("dim level change failed with #{e.message}")
      )

    getDimlevel: () ->
      return plugin.getDeviceDetails(@DeviceId).then( (json) =>
        level = json.device.position
        @_setDimlevel(level)
        return @_dimlevel
      ).catch( (e) =>
        env.logger.error("dim level update failed with #{e.message}")
        return @_dimlevel
      )


  class HomepilotShutter extends env.devices.DimmerActuator

    constructor: (@config) ->
      @id = @config.id
      @name = @config.name
      @DeviceId = @config.DeviceId

      updateValue = =>
        if @config.interval > 0
          @getDimlevel().finally( =>
            setTimeout(updateValue, @config.interval * 1000)
          )

      super()
      updateValue()

    changeDimlevelTo: (level) ->
      if @_dimlevel is level then return
      return plugin.sendDeviceCommand(@DeviceId, "9&pos=#{level}").then( =>
        @_setDimlevel(level)
      ).catch( (e) =>
        env.logger.error("shutter level change failed with #{e.message}")
      )

    getDimlevel: () ->
      return plugin.getDeviceDetails(@DeviceId).then( (json) =>
        level = json.device.position
        @_setDimlevel(level)
        return @_dimlevel
      ).catch( (e) =>
        env.logger.error("shutter level update failed with #{e.message}")
        return @_dimlevel
      )

  class HomepilotScene extends env.devices.ButtonsDevice

    constructor: (@config) ->
      @id = config.id
      @name = config.name
      super(config)

    buttonPressed: (buttonId) ->
      for b in @config.buttons
        if b.id is buttonId
          return plugin.sendSceneCommand(b.SceneId)
      throw new Error("No scene with the id #{buttonId} found")

  plugin = new HomepilotPlugin
  return plugin
