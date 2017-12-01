#!/bin/sh
/docker-entrypoint.sh &
sleep 90

/bin/bash ./Cesection/addtestdata.sh
/bin/bash ./Cistica/addtestdata.sh
/bin/bash ./Dixon/addtestdata.sh
/bin/bash ./Glands/addtestdata.sh
/bin/bash ./Sweets/addtestdata.sh
/bin/bash ./Wellgood/addtestdata.sh

sleep 3600
