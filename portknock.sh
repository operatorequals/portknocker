#!/bin/sh
clear
echo "Port Knocker"
echo

if [ "$#" = 0 ]; then
	echo "Usage:"
	echo "	portknock HOST [ports]"
	echo "ports:	TCP ports: #"
	echo "	UDP ports: u#"
	echo
	echo "Example:"
	echo "	portknock 192.168.1.15 15 16 17 u54"
	exit
fi

echo
echo
echo

HOST=$1;
shift $((OPTIND-0))

ping_resp=$(eval nmap -sn $HOST | grep up 2>/dev/null)
echo $ping_resp
if [ "$ping_resp" = "" ]; then
	echo "Host seems down by PING"
else
	echo "Host responds to PING"
fi

echo
echo

for port in  "$@" ; do

#	echo $i
#	port=$(@[i])
#	echo $port
	if [ `echo $port | cut -c1` = "u" ]; then

		port=`echo $port | cut -d"u" -f2`
		echo "Knockin' on UDP $port"
		nmap  -Pn -sU $HOST --host_timeout 201 --max-retries 0 -p $port>/dev/null
	else
		echo "Knockin' on TCP $port"
		nmap  -Pn -sS $HOST --host_timeout 201 --max-retries 0 -p $port>/dev/null
	fi
done


