#!/bin/bash
`reset`
echo 'MQTT Subscriber Running';
x=0;
y=0;
while :
do
  x=`expr $x + 1`;
  y=`expr $y + 2`;
  if (( $x >= 72 || $y >= 88)); then
    break
  fi 
  msg=`mosquitto_pub -t tx -m 'nuid=2&password=vicky&x='$x'&y='$y'&ruang=M102'`
  echo $x' '$y;
  sleep .5;
done
