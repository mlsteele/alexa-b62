{MTA_BUSTIME_API_KEY} = require './secrets'

console.log MTA_BUSTIME_API_KEY
url = "http://bustime.mta.info/api/siri/stop-monitoring.json?version=2&key=$MTA_BUSTIME_API_KEY&OperatorRef=MTA&MonitoringRef=305173" | jq "." L
