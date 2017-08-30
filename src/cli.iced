{get_bus_list} = require './api'

main = (cb) ->
  await get_bus_list defer err, bus_list
  if err?
    return cb err
  for bus in bus_list
    console.log "#{bus.line} #{bus.distance}m #{bus.arrival_time.fromNow()}"
  if bus_list.length is 0
    console.log "no buses"

main (err) ->
  if err?
    console.log "ERROR: #{err}"
