#!/bin/sh

# Original source - https://github.com/polybar/polybar-scripts/tree/master/polybar-scripts/openweathermap-detailed

# Global settings
KEY=""
CITY="fetch:ip"
UNITS="m"
SYMBOL="°C"
API="http://api.weatherstack.com"

# Get weather
WEATHER=$(curl -sf "$API/current?access_key=$KEY&query=$CITY&units=$UNITS")

# Get condition, icon and temp
WEATHER_MAIN=$(echo $WEATHER | jq -r ".current.weather_descriptions[0]")
WEATHER_TEMP=$(echo $WEATHER | jq -r ".current.temperature")

# Print weather
echo "$WEATHER_MAIN $WEATHER_TEMP$SYMBOL"
