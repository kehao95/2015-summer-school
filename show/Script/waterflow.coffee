root = exports ? this
root.run = -> 
	# log "ajax.run"

log = -> 
	for i in arguments
		console.log i
Alert = (arg...)->
	alert arg.join('')
AjaxSync = (url)->
	$.ajax(url,async = false,)



initLoad = (filename)->
	# log "ajax()"
	ajaxloader = new XMLHttpRequest()
	ajaxloader.open("GET","Ajax/photos.json",true)
	ajaxloader.onreadystatechange= ->
		if ajaxloader.readyState==4 and ajaxloader.status==200
			root.re =  JSON.parse(ajaxloader.responseText)
			`
			var count = 0;
			for (var k in re) {
			    if (re.hasOwnProperty(k)) {
			       ++count;
			    }
			}
			`
			root.re.length = count
			## log "loadPhoto()"
			loadPhoto()
			loadPhoto()
			loadPhoto()
			loadPhoto()
			if ($(window).height() == $(document).height())
				# log "load to fill the screen"
				loadPhoto()

	ajaxloader.send()
foo = false
loadPhoto =  ->
	distence =(pos1, pos2) ->
      pi = 3.141592654;
      cos = Math.cos;
      sin = Math.sin;
      arccos = Math.acos;
      return 6370.996*arccos(cos(pos1.latitude*pi/180 )*cos(pos2.latitude*pi/180)*cos(pos1.longitude*pi/180 -pos2.longitude*pi/180)+sin(pos1.latitude*pi/180 )*sin(pos2.latitude*pi/180));

	loaded = ->
			$('.card').css("display","inline-block")
			#$("body").css("overflow", "auto")
			loadAddiction()

	colAppendPhoto = (col) ->
		# function to append a photo to a col
		# log id+" in "+re.length
		if id  >= re.length-1 and foo == false
			foo = true
			loaded()
			Alert "loaded all"
			return 
		log "load"
		imgsrc= re[id]['tumb']
		pos = {}
		pos.latitude = re[id].latitude
		pos.longitude = re[id].longitude
		content= null
		if position.getSuccess
			if pos.longitude != null
				content = "<p>距此 #{distence(pos,position).toFixed(1)}km</p>"
				Url = "http://maps.googleapis.com/maps/api/geocode/json?latlng=#{re[id].latitude},#{re[id].longitude}&sensor=true"
				log "googleapi"
				`
				$.ajax({url:Url,dataType:'json',index:id,success:function(data){
				log(data.status)
				log(data.results[1].formatted_address)
				$("#img_"+this.index).append("<p>"+data.results[1].formatted_address+"</p>")
				}})
				`
			else
				content = "<p>无地理信息</p>"



		img = $(document.createElement('div')).addClass('image').append( $('<img />').attr('src',imgsrc)).attr('alt','id')
		img.bind('load',onload)
		card = $(document.createElement('div')).addClass('card').addClass('up-down').append(img).append(content).attr('id','img_'+id).bind( "click", clickcard)
		card.css("display","none")
		card.appendTo(col)
		id+=1

	loadAddiction = ->
		Ncol = $('.column').length 
		lastCards = $('.column .card:last-child')
		if lastCards == []
			return
		for i in [0..Ncol-1]
			loadI= false
			for j  in [0..Ncol-1]
				unless i == j
					buttom_of_short = divbuttom(lastCards[i])
					top_of_long = divtop(lastCards[j])
					if divbuttom(lastCards[i]) < divtop(lastCards[j])
						## log "append to #{i},",i+".buttom"+':'+buttom_of_short+" < "+j+"top"+":"+top_of_long
						loadI = true
			if loadI
				colAppendPhoto lastCards[i].parentNode

	# onload()
	log "append columns"
	#$("body").css("overflow", "hidden")
	for col in $('.column')
		colAppendPhoto col
	$('.columns').attr('onload',loaded)	
	# log "append columns Done"

clickcard= ->
	# log "clickcard"
	commentspage = 1
	copyCardWithImage = (id) ->
		card = $("##{id}").clone()
		log card
		img = card.find('img').attr('src',card.find('img').attr('src').replace("tumbnails","")).bind('load',onloadPOP)
		card.find('p').remove()
		card.removeClass('up-down')
		card
	newCommentBox = ->
		return $(document.createElement('div')).addClass('commentBox')
	newComments = ->
		comments = $(document.createElement('div')).attr('id','comments')
	newComment = (author,speach)->
		comment = $(document.createElement('div')).addClass('comment')
		a = $(document.createElement('h1')).append(author)
		s = $(document.createElement('p')).append(speach)
		return comment.append(a).append(s)
	newLoadMore = ->
		load = $(document.createElement('button')).attr('id','LoadMore').append("[获取更多]")
		return load
	onloadPOP = ->
		log "onload"
		log $('#POP').find('.card')
		$('#POP').find('.card').css('opacity','1')
	clickloadMore = (event)->
		event.stopPropagation()
		loadComments()
		#comment = newComment('kehao',"已在现有的浏览器会话中创建新的窗口。已在现有的浏览器会话中创建新的窗口。")
		#$('.commentBox').append(comment)

	loadCard =(id) ->
		card = copyCardWithImage(id)
		commentBox = newCommentBox()
		loadMore = newLoadMore()
		comments = newComments().append(commentBox)
		comments.append(loadMore)
		card.append(comments)
		POP.append(card)
		document.getElementById('POP').addEventListener("click",clickPOP)
		document.getElementById('LoadMore').addEventListener("click",clickloadMore)
		document.getElementById('POP').onload = onloadPOP
		loadComments()

	loadingGIF =->
		lo = document.createElement('div')
		$(lo).addClass('loadingGIF')
		gif = $(document.createElement('img')).attr('src','Images/loading.gif')
		$(lo).append(gif).append('<p>正在努力加载中...</p>')
		$('#POP').append(lo)


	page = 0
	loadComments =->
		success =(data,other...)->
			if page >= 3
				$('#LoadMore').remove()
				#document.getElementById('LoadMore').removeEventListener("click",clickloadMore)
			i = 0
			while data.hasOwnProperty(i)
				log "data[i]",data[i]
				comment = newComment(data[i].author,data[i].comment)
				log "comment",comment
				$('.commentBox').append(comment)
				i++
			page++

		file = "comment_#{page}.json"
		Url = "Ajax/"+file
		$.ajax(url:Url,dataType= 'json',).done(success)
		


	id = $(this).attr('id')
	POP = $(document.createElement('div')).attr('id','POP').appendTo($('body'))
	loadingGIF()
	loadCard(id)
	

	# card.appendTo($('.column')[0])

root.clickPOP = ->
	$(document.getElementById('POP')).remove()

scroll_to_load = ->
	if($(window).scrollTop() + $(window).height() > $(document).height() - 50) 
       loadPhoto()
divbuttom = (div)->
		if div == undefined
			return 100
		else
			$(div).position().top+$(div).height()
divtop = (div) ->
	if div == undefined
			return 0
	else
		$(div).position().top

getPosition = ->
	success = (pos) ->
		position.latitude = pos.coords.latitude
		position.longitude = pos.coords.longitude
		position.getSuccess= true
		log "success to locate :",position.latitude," ",position.longitude
		initLoad "Ajax/photos.json"
	error = (e) ->
		Alert "failed to get location"
		initLoad "Ajax/photos.json"
		position.getSuccess = false
	if(navigator.geolocation) 
		navigator.geolocation.getCurrentPosition(success,error)



window.position = {latitude:0,longitude:0,getSuccess:false}
window.id = 0
window.onkeydown = ->
	# log "onkeydown"
	loadPhoto()
window.onresize = ->
	# log "onresize"
window.onload = ->
	getPosition()
window.onscroll = ->
	scroll_to_load()
