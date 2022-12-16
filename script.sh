#!/usr/bin/env bash

#
# Copyright (C) 2019 Saalim Quadri (danascape)
#
# SPDX-License-Identifier: Apache-2.0 license
#

# Take UART info
UART_LAST=$( tail -n 1 uart.txt)

# Take sensor data
HUMIDITY=$(echo $UART_LAST | awk '{print $1}')
HUMIDITY_DATA=$(echo $UART_LAST | awk '{print $2}')

echo $HUMIDITY
echo $HUMIDITY_DATA

TEMPERATURE=$(echo $UART_LAST | awk '{print $3}')
TEMPERATURE_DATA=$(echo $UART_LAST | awk '{print $4}')

SOILMOSTURE=$(echo $UART_LAST | awk '{print $5}')
SOILMOSTURE_DATA=$(echo $UART_LAST | awk '{print $6}')

AIRQUALITY=$(echo $UART_LAST | awk '{print $7}')
AIRQUALITY_DATA=$(echo $UART_LAST | awk '{print $8}')

echo $TEMPERATURE
echo $TEMPERATURE_DATA

echo $SOILMOISTURE
echo $SOILMOISTURE_DATA

echo $AIRQUALITY
echo $AIRQUALITY_DATA

# Suggested Plant
PLANT_DATA="oak tree"

# Plant Disease
DISEASE_DATA="AIDS"

# Generate json
genJSON() {
    GEN_JSON_BODY=$(jq --null-input \
                    --arg humidity "$HUMIDITY_DATA" \
                    --arg temperature "$TEMPERATURE_DATA" \
                    --arg soilmoisture "$SOILMOISTURE_DATA" \
                    --arg airquality "$AIRQUALITY_DATA" \
                    --arg plant "$PLANT_DATA" \
                    --arg disease "$DISEASE_DATA" \
                    "{"humidity": \"$HUMIDITY_DATA\", "temperature": \"$TEMPERATURE_DATA\", "soilmoisture": \"$SOILMOISTURE_DATA\", "airquality": \"$AIRQUALITY_DATA\", "plant": \"$PLANT_DATA\", "disease": \"$DISEASE_DATA\"}")
    echo $GEN_JSON_BODY
    if [[ -f json/data.json ]]; then
        rm json/data.json
    fi
    echo "$GEN_JSON_BODY" >> json/data.json
    exit 0
}

genJSON