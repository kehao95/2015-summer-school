rm ChatRoom.js
coffee -c ChatRoom.coffee
while [ ! -f ChatRoom.js ] 
do
	sleep 0.1s
done
google-chrome localhost/ChatRoom
