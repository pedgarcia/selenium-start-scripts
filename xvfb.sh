#!/bin/bash

SERVICE_NAME="Xvfb"
SERVICE_LOG_DIR=./log
SERVICE_LOG_OUTPUT_FILE=xvfb-output.log
SERVICE_LOG_ERROR_FILE=xvfb-error.log
SERVICE_PID_DIR=./pid
SERVICE_PID_FILE=$SERVICE_PID_DIR/xvfb.pid

DISPLAY_NUMBER=99
XVFB_ARGUMENTS="-fp /usr/share/fonts/X11/misc/ :$DISPLAY_NUMBER"

BASEDIR=$(dirname $0)
cd $BASEDIR

test ! -d $SERVICE_LOG_DIR && mkdir -p $SERVICE_LOG_DIR
test ! -d $SERVICE_LOG_DIR && exit 1

test ! -d $SERVICE_PID_DIR && mkdir -p $SERVICE_PID_DIR
test ! -d $SERVICE_PID_DIR && exit 1

is_process_running()
{
        if test ! -f $SERVICE_PID_FILE; then return 1; fi
        PID=`cat $SERVICE_PID_FILE`
        if ! ps -p $PID > /dev/null; then rm -f $SERVICE_PID_FILE; return 1; fi

        return 0
}

case "${1:-''}" in

        'start')
                if is_process_running
                then
                        echo "$SERVICE_NAME is already running."
                else
                        Xvfb $XVFB_ARGUMENTS > $SERVICE_LOG_DIR/$SERVICE_LOG_OUTPUT_FILE 2> $SERVICE_LOG_DIR/$SERVICE_LOG_ERROR_FILE & echo $! > $SERVICE_PID_FILE
                        echo -n "Starting $SERVICE_NAME... "

                        error=$?

                        if test $error -gt 0
                        then
                                echo "${bon}Error $error! Couldn't start $SERVICE_NAME!${boff}"
                        else
                                PID=`cat $SERVICE_PID_FILE`
                                echo "pid="$PID
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

