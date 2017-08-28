Alexa = require 'alexa-sdk'
{ALEXA_APP_ID} = require './secrets'

handlers =
  "AMAZON.CancelIntent": ->
    this.emit ":tell", "canceled"
  "AMAZON.HelpIntent": ->
    this.emit ":tell", "just say bus or anything really"
  "AMAZON.StopIntent": ->
    this.emit ":tell", "fine"
  "List": ->
    this.emit ":tell", "NO BUSSES"
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
