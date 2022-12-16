#!/usr/bin/env bash

#
# Copyright (C) 2019 Saalim Quadri (danascape)
#
# SPDX-License-Identifier: Apache-2.0 license
#

# Set necessary var
CURRENT_DIR=$(pwd)

# Sort UART
UART_SORT=$(sed -i 's/\([^:]\)\s/\1\n/g' uart.txt)

# Take UART info
UART_LAST=$( tail -n 4 uart.txt)

echo $UART_LAST

# Take sensor data
HUMIDITY=$(echo $UART_LAST | awk '{print $1}')
HUMIDITY_DATA=$(echo $UART_LAST | awk '{print $2}')

TEMPERATURE=$(echo $UART_LAST | awk '{print $3}')
TEMPERATURE_DATA=$(echo $UART_LAST | awk '{print $4}')

SOILMOSTURE=$(echo $UART_LAST | awk '{print $5}')
SOILMOSTURE_DATA=$(echo $UART_LAST | awk '{print $6}')

AIRQUALITY=$(echo $UART_LAST | awk '{print $7}')
AIRQUALITY_DATA=$(echo $UART_LAST | awk '{print $8}')

# Suggested Plant
PLANT_DATA="Rose"

# Plant Disease.
# It is under work.
# Might through wrong stuff.
MODEL_PATH="/home/saalim/pr/mod"
cd $MODEL_PATH
python3 test.py | tee model.txt
MODEL_LOG=$(tail -n 2 $MODEL_PATH/model.txt)
DISEASE_DATA=$(echo $MODEL_LOG | awk '{print $3,$4}')
cd $CURRENT_DIR

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
bash deploy.sh
