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

        'status')
                sh selenium-node.sh status
                sh selenium-hub.sh status
                sh x11vnc.sh status
                sh xvfb.sh status
        ;;

        *)      # no parameter specified
                echo "Usage: $0 start|stop|status"
                exit 1
        ;;

esac