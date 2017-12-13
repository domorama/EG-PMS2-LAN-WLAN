#!/bin/sh

SERVER="YOUR_POWERPLUG_IP"
PASSWORD="YOUR_POWERPLUG_PASSWORD"

URL_BASE="http://${SERVER}"

ACTION=0
TEST=0

if [ $# = 0 ]
then
    echo "NO ARGUMENTS RECEIVED!"
    echo "USAGE ${0} :"
    echo "    ${0} [-t] ON|OFF SOCKETS"
    exit 1
fi

# Test the option and action to be performed
case $1 in 
    -t) TEST=1
        shift;;
    -*) echo "WRONG OPTION RECEIVED!"
        echo "USAGE ${0} :"
        echo "    ${0} [-t] ON|OFF SOCKETS"
        exit 1;;
esac

if [ $1 = "ON" ] 
then  
    echo "REQUEST TO SWITCH ON"
    ACTION=1
else
    if [ $1 = "OFF" ]
    then
       echo "REQUEST TO SWITCH OFF"
       ACTION=0
    else
       echo "WRONG ARGUMENTS"
       echo "USAGE ${0} :"
       echo "    ${0} [-t] ON|OFF SOCKETS"
       exit 1
    fi
fi
    
# Shift arguments
shift

# If requested, test the server availability
if [ $TEST = 1 ]
then
    ping -q -c1 ${SERVER} > /dev/null
    if [ $? -eq 1 ]
    then
        echo "SERVER ${SERVER} NOT AVAILABLE"
        exit 1
    fi
fi

# Login
wget -q ${URL_BASE}/login.html --post-data=pw=${PASSWORD}
if [ $? -ne 0 ]
then
   echo "SERVER ${SERVER} ERROR"
   exit 1
fi

# Loop on sockets
while [ $# -gt 0 ]
do
  wget -q ${URL_BASE}/ --post-data=cte${1}=${ACTION}
    
  # Shift arguments
  shift
done

# Logout
wget -q ${URL_BASE}/login.html

rm login.html*
rm index.html*

exit 0
