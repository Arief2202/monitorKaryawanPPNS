#!/bin/bash
`reset`
echo 'MQTT Subscriber Running';
while :
do
  msg=`mosquitto_sub -t tx -C 1`
  res=`curl -d $msg -H "Content-Type: application/x-www-form-urlencoded" -X POST -s "http://absensi.ppns.local.server/location/update.php"`
  echo $res;
  msg2=`mosquitto_pub -t rx -m "$res"`
done
