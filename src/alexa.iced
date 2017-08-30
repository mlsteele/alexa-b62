Alexa = require 'alexa-sdk'
{ALEXA_APP_ID} = require './secrets'
{get_bus_list} = require './api'

handlers =
  "AMAZON.CancelIntent": ->
    this.emit ":tell", "canceled"
  "AMAZON.HelpIntent": ->
    this.emit ":tell", "just say bus or anything really"
  "AMAZON.StopIntent": ->
    this.emit ":tell", "fine"
  "List": ->
    await get_bus_list defer err, bus_list
    if err?
      console.log "API Error: #{err}"
      this.emit ":tell", "API error"
      return
    if bus_list.length is 0
      this.emit ":tell", "no buses"
      return
    watchagonnasay = "one "
    first = true
    for bus in bus_list.slice(0,2)
      console.log "#{bus.line} #{bus.distance}m #{bus.arrival_time.fromNow()}"
      if not first
        watchagonnasay += " . And another "
      if bus.arrival_time?.isValid?()
        watchagonnasay += "arriving #{bus.arrival_time.fromNow()}"
      else
        in_miles = bus.distance / 1609.34
        less_decimals = parseFloat(Math.round(in_miles * 10) / 10).toFixed(1)
        watchagonnasay += "#{less_decimals} miles away"
      first = false
    this.emit ":tell", watchagonnasay
  "Unhandled": ->
    this.emit ":tell", "beep boop"

exports.handler = (event, ctx, cb) ->
  console.log "alexa handler"
  alexa = Alexa.handler event, ctx, cb
  alexa.appId = ALEXA_APP_ID
  console.log "app id: #{alexa.appId}"
  alexa.registerHandlers handlers
  console.log "alexa execute"
  alexa.execute()
