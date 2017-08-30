request = require 'request'
moment = require 'moment'
_ = require 'lodash'
{MTA_BUSTIME_API_KEY} = require './secrets'

exports.get_bus_list = (cb) ->
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
  if res.statusCode != 200
    return cb (new Error "http status code: #{res.statusCode}")
  bus_list = body.Siri?.ServiceDelivery?.StopMonitoringDelivery[0]?.MonitoredStopVisit
  bus_list = _.chain(bus_list).filter( (bus) ->
    bus?.MonitoredVehicleJourney?.LineRef is "MTA NYCT_B62"
  ).map(
    (bus) -> {
      line: bus?.MonitoredVehicleJourney?.PublishedLineName?[0] or bus?.MonitoredVehicleJourney?.LineRef
      # Distance in meters
      distance: bus?.MonitoredVehicleJourney?.MonitoredCall?.DistanceFromStop
      # Moment of arrival. Possibly invalid.
      arrival_time: moment(Date.parse bus?.MonitoredVehicleJourney?.MonitoredCall?.ExpectedArrivalTime)
      source: bus
    }
  ).sortBy([(bus) ->
    # Sort buses with arrival times first.
    if bus.arrival_time.isValid()
      "aaa-#{bus.arrival_time.toISOString()}"
    else
      "bbb-#{bus.distance}"
  ]).value()
  cb null, bus_list
  
