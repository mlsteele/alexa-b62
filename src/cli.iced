request = require 'request'
moment = require 'moment'
{MTA_BUSTIME_API_KEY} = require './secrets'

main = (cb) ->
  await request {
    url: "http://bustime.mta.info/api/siri/stop-monitoring.json"
    json: true
    qs:
      version: 2
      key: MTA_BUSTIME_API_KEY
      OperatorRef: "MTA"
      MonitoringRef: 305173
  }, defer(err, res, body)
  if err?
    return cb err
  console.log err
  console.log res.statusCode
  bus_list = body.Siri?.ServiceDelivery?.StopMonitoringDelivery[0]?.MonitoredStopVisit
  unless bus_list?
    return cb (new Error "no bus list")
  for bus in bus_list
    name = bus?.MonitoredVehicleJourney?.LineRef
    distance = bus?.MonitoredVehicleJourney?.MonitoredCall?.DistanceFromStop
    arrival_time = moment(Date.parse bus?.MonitoredVehicleJourney?.MonitoredCall?.ExpectedArrivalTime)
    console.log "#{name}: #{distance}m #{arrival_time.fromNow()}"
  cb null

main (err) ->
  if err?
    console.log "ERROR: #{err}"
