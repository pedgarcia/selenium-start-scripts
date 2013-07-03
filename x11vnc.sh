#!/bin/bash

SERVICE_NAME="x11vnc"
SERVICE_LOG_DIR=./log
SERVICE_LOG_OUTPUT_FILE=x11vnc-output.log
SERVICE_LOG_ERROR_FILE=x11vnc-error.log
SERVICE_PID_DIR=./pid
SERVICE_PID_FILE=$SERVICE_PID_DIR/x11vnc.pid

DISPLAY_NUMBER=99
XVNC_ARGUMENTS="-display :99 -usepw -forever"

BASEDIR=$(dirname $0)
cd $BASEDIR

test ! -d $SERVICE_LOG_DIR && mkdir -p $SERVICE_LOG_DIR
test ! -d $SERVICE_LOG_DIR && exit 1

test ! -d $SERVICE_PID_DIR && mkdir -p $SERVICE_PID_DIR
test ! -d $SERVICE_PID_DIR && exit 1

is_process_running()
{
        if test -s $SERVICE_PID_FILE; then 
                PID=`cat $SERVICE_PID_FILE`

                if test ! -z $PID; then 
                        if ps -p $PID > /dev/null; then 
                                return 0
                        else                                        
                                rm -f $SERVICE_PID_FILE; 
                                return 1; 
                        fi        
                else
                        return 1; 
                fi
        else                
                return 1; 
        fi
}

case "${1:-''}" in

        'start')
                if is_process_running
                then
                        echo "$SERVICE_NAME is already running."
                else
                        echo "Starting $SERVICE_NAME..."
                        x11vnc $XVNC_ARGUMENTS > $SERVICE_LOG_DIR/$SERVICE_LOG_OUTPUT_FILE 2> $SERVICE_LOG_DIR/$SERVICE_LOG_ERROR_FILE & echo $! > $SERVICE_PID_FILE

                        if is_process_running
                        then
                                PID=`cat $SERVICE_PID_FILE`
                                echo "PID="$PID
                        else
                                echo "Couldn't start $SERVICE_NAME!"
                                tail $SERVICE_LOG_DIR/$SERVICE_LOG_ERROR_FILE
                        fi
                fi
        ;;

        'stop')
                if is_process_running
                then
                        PID=`cat $SERVICE_PID_FILE`
                        echo "Stopping $SERVICE_NAME..."

                        kill -TERM $PID
                        echo -n "Waiting for process to end..."

                        while is_process_running
                        do 
                                sleep 0.5; echo -n "."; 
                        done

                        echo " OK"
                        test -f $SERVICE_PID_FILE && rm -f $SERVICE_PID_FILE

                else
                        echo "$SERVICE_NAME is not running."
                fi
        ;;

        *)      # no parameter specified
                echo "Usage: $0 start|stop"
                exit 1
        ;;

esac

