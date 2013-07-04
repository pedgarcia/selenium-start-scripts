#!/bin/bash

case "${1:-''}" in

        'start')
                sh xvfb.sh start
                sh x11vnc.sh start
                #sh selenium-hub.sh start
                sh selenium-node.sh start
        ;;

        'stop')
                sh selenium-node.sh stop
                #sh selenium-hub.sh stop
                sh x11vnc.sh stop
                sh xvfb.sh stop
        ;;

        *)      # no parameter specified
                echo "Usage: $0 start|stop"
                exit 1
        ;;

esac