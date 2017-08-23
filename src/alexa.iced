Alexa = require 'alexa-sdk'
{ALEXA_APP_ID} = require './secrets'

console.log "@@@ alexa init"

handlers =
  "HelloWorldIntent": ->
    console.log "@@@ alexa hello handler"
    console.log 'pre-emit'
    this.emit ":tell", "Hello World!"
    console.log 'post-emit'
  "List": ->
    this.emit ":tell", "NO BUSSES"
  "Unhandled": ->
    console.log "didn't understand"
    this.emit ":tell", "didn't understand"

exports.handler = (event, ctx, cb) ->
  console.log "@@@ alexa meta handler"
  alexa = Alexa.handler event, ctx, cb
  console.log "@@@ X.1"
  alexa.appId = ALEXA_APP_ID
  console.log "app id: #{alexa.appId}"
  console.log "@@@ X.2"
  alexa.registerHandlers handlers
  console.log "@@@ alexa meta handler execute"
  alexa.execute()
  console.log "@@@ alexa meta handler okbye"
