#!/bin/bash

BASEDIR=$(dirname $0)
cd $BASEDIR

start_all()
{
        for script in xvfb.sh x11vnc.sh selenium-hub.sh selenium-node.sh phantomjs.sh
        do 
                sh $script start
        done
}

stop_all()
{
        for script in phantomjs.sh selenium-node.sh selenium-hub.sh x11vnc.sh xvfb.sh
        do 
                sh $script stop
        done
}

status_all()
{
        for script in phantomjs.sh selenium-node.sh selenium-hub.sh x11vnc.sh xvfb.sh
        do 
                sh $script status
        done        
}

case "${1:-''}" in

        'start')
                start_all
        ;;

        'stop')
                stop_all
        ;;

        'status')
                status_all
        ;;

        'restart')
                stop_all
                start_all
        ;;        

        *)      # no parameter specified
                echo "Usage: $0 start|stop|status|restart"
                exit 1
        ;;

esac