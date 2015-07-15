root = exports ? this
root.run = -> 
	# log "ajax.run"

log = -> 
	for i in arguments
		console.log i

Alert = (arg...)->
	alert arg.join('')

Ajax = (filename)->
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
			# log "$(window).scrollTop():"+$(window).scrollTop()
			# log "$(window).height():"+$(window).height()
			# log "$(document).height():"+$(document).height()
			if ($(window).height() == $(document).height())
				# log "load to fill the screen"
				loadPhoto()

	ajaxloader.send()


loadPhoto =  ->
	loaded = ->
			$('.card').css("display","inline-block")
			$("body").css("overflow", "auto")
			loadAddiction()

	colAppendPhoto = (col) ->
		# function to append a photo to a col
		# log id+" in "+re.length
		foo = false
		if id  >= re.length-1 and foo == false
			foo = true
			Alert "loaded all"
			return 
		log "load"
		imgsrc= re[id]['tumb']
		cardcontent = ""
		img = $(document.createElement('div')).addClass('image').append( $('<img />').attr('src',imgsrc)).attr('alt','id')
		img.bind('load',onload)
		if cardcontent is not ""
			content = $(document.createElement('div')).addClass('cardcontent').append( $('<p />')).append(cardcontent)
		else
			content = null
		card = $(document.createElement('div')).addClass('card').append(img).append(content).attr('id','img_'+id).bind( "click", clickcard)
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
	$("body").css("overflow", "hidden")
	for col in $('.column')
		colAppendPhoto col
	$('.columns').attr('onload',loaded)	
	# log "append columns Done"
	

	
		
clickcard= ->
	# log "clickcard"
	copyCardWithImage = (id) ->
		card = $("##{id}").clone()
		log card
		img = card.find('img').attr('src',card.find('img').attr('src').replace("tumbnails","")).bind('load',onloadPOP)
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
		comment = newComment('kehao',"已在现有的浏览器会话中创建新的窗口。已在现有的浏览器会话中创建新的窗口。")
		$('.commentBox').append(comment)

	loadCard =(id) ->
		card = copyCardWithImage(id)
		comment = newComment('kehao',"已在现有的浏览器会话中创建新的窗口。已在现有的浏览器会话中创建新的窗口。")
		commentBox = newCommentBox().append(comment).append(comment)
		loadMore = newLoadMore()
		comments = newComments().append(commentBox)
		comments.append(loadMore)
		card.append(comments)
		POP.append(card)
		document.getElementById('POP').addEventListener("click",clickPOP)
		document.getElementById('LoadMore').addEventListener("click",clickloadMore)
		document.getElementById('POP').onload = onloadPOP

	loadingGIF =->
		lo = document.createElement('div')
		$(lo).addClass('loadingGIF')
		gif = $(document.createElement('img')).attr('src','Images/loading.gif')
		$(lo).append(gif).append('<p>正在努力加载中...</p>')
		$('#POP').append(lo)

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

window.id = 0
window.onkeydown = ->
	# log "onkeydown"
	loadPhoto()
window.onresize = ->
	# log "onresize"
window.onload = ->
	Ajax "Ajax/photos.json"
window.onscroll = ->
	scroll_to_load()
