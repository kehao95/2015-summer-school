root  = exports ? this
Alert = (arg...)->
	alert arg.join('')
log= (arg...) ->
	for i in arg
		console.log i
	$('#log').prepend("<p>#{arg.join(" ")}</p>")

info = (arg...)->
	for i in arg
		console.info i
		$('#log').prepend("<p>#{i}</p>")

init = ->
	#-log">> init the chatroom"
	# get the refs
	root.BaseRef= new Firebase("https://e0za0ct8s6t.firebaseio-demo.com/")
	root.messagesRef = BaseRef.child('messages')
	root.userListRef = BaseRef.child('userList')
	root.nameRef = userListRef.push()
	nameRef.onDisconnect().remove()
	# global variables
	root.currentname = ''

	# maintain a userList
	userListRef.on 'value',(snapshot)->
		root.userList = []
		snapshot.forEach (childSnapshot)->
			userList.push childSnapshot.val()
			#-log">>>"+childSnapshot.val()
			return false
		#-log'>>userList: []-> ',userList
		updateUserList()


	# get the Dom Elements
	root.messageField = $('#messageInput')
	root.nameField = $('#nameInput')
	root.messageList = $('#messages')

	#add key press listener
	messageField.keypress (e)->
		if e.keyCode == 13
			onSend()
	nameField.keypress (e) ->
		if e.keyCode == 13
			document.getElementById('#messageInput').focus()
			# ...


	#add messages listener
	messagesRef.limitToLast(10).on 'child_added',onNewMessage

	# set idel/leave time
	setIdleTimeout(5000);
	setAwayTimeout(10000);

	# focus to name regist
	document.getElementById('nameInput').focus()
	# on leave name field check name vaild
	nameField.blur(checkAndSet)


checkAndSet = (name)->
	# check length then check userList
	#-log'>>checkname'
	name = nameField.val()
	if name ==  ''
		# if is void
		#-log'check error :void'
		document.getElementById('nameInput').focus()
		return false
	else if name == currentname
		# if not changed
		#-log'check good: not changed'
		return true
	else if name.length >= 20
		# if too long
		#-log'check error: too long'
		document.getElementById('nameInput').focus()
		return false
	else if name in userList
		# if has user with same name
		Alert "不可设置与在线用户相同的用户名"
		document.getElementById('nameInput').focus()
		return false
	else
		setName name
		return true

updateUserList = ->
	#-log'>>updateUserList'
	online = $('#onlineUsers')
	online.empty()
	#-log'currentname:'+currentname
	if root.currentname == ''
		online.append($('<p>').append('* Unnamed'))
	else
		online.append($('<p>').append('*'+currentname))
	for i in userList
		unless i == currentname
			online.append($('<p>').append(i))


setName = (name) ->
	#-log'>>set name:'+name
	this.currentname = name
	nameRef.set(name)


onSend  = ->
	#-log">> on key send"
	name = nameField.val()
	text = messageField.val()
	if checkAndSet(name)
		messagesRef.push {name:name,text:text}
	messageField.val('')

onNewMessage = (snapshot) ->
	AddNewMessage = ->

		messageElement = $("<li>")
		msg = $('<p>').text(message)
		name =  $("<strong class='chat-username'></strong>").text(username)
		if username == currentname
			messageElement.css('text-align','right')
		messageElement.append(name).append(msg)
		messageList.append messageElement
		messageList[0].scrollTop = messageList[0].scrollHeight
		#username+":"+message

	#-log">> on new messages"
	data = snapshot.val()
	username = data.name
	message = data.text
	AddNewMessage()



window.onload = ->
	init()
