#!bin/sh
rm waterflow.js
coffee -c waterflow.coffee
python exif.py
while [ ! -f waterflow.js ] 
do
	sleep 0.1s
done
google-chrome localhost/show