root = exports ? this
root.run = -> 
	log "ajax.run"

log = -> 
	for i in arguments
		console.log i

Alert = (arg...)->
	alert arg.join('')

Ajax = (filename)->
	log "ajax()"
	ajaxloader = new XMLHttpRequest()
	ajaxloader.open("GET","Ajax/photos.json",true)
	ajaxloader.onreadystatechange= ->
		if ajaxloader.readyState==4 and ajaxloader.status==200
			root.re =  JSON.parse(ajaxloader.responseText)
			#log "loadPhoto()"
			loadPhoto()
			#log "loadPhoto() done"
			loadPhoto()
			loadPhoto()
			log "$(window).scrollTop():"+$(window).scrollTop()
			log "$(window).height():"+$(window).height()
			log "$(document).height():"+$(document).height()
			if ($(window).height() == $(document).height())
				log "load to fill the screen"
				loadPhoto()

	ajaxloader.send()


loadPhoto =  ->
	colAppendPhoto = (col) ->
		# function to append a photo to a col
		imgsrc= re[id]['tumb']
		cardcontent = ""
		img = $(document.createElement('div')).addClass('image').append( $('<img />').attr('src',imgsrc)).attr('alt','id')
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
						#log "append to #{i},",i+".buttom"+':'+buttom_of_short+" < "+j+"top"+":"+top_of_long
						loadI = true
			if loadI
				colAppendPhoto lastCards[i].parentNode
	onload = ->
			log "onload"
			$('body').addClass("loading"); 
			log "onload done"
	loaded = ->
			log "loaded"
			$('body').removeClass("loading"); 
			$('.card').css("display","inline-block")
			loadAddiction()
			log "loaded done"
	onload()
	log "append columns"
	for col in $('.column')
		colAppendPhoto col
	$('.columns').attr('onload',loaded)	
	log "append columns Done"
	

	
		
clickcard = ->
	log "clickcard"
	log this

scroll_to_load = ->
	if($(window).scrollTop() + $(window).height() > $(document).height() - 5) 
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
	log "onkeydown"
	loadPhoto()
window.onresize = ->
	log "onresize"
window.onload = ->
	Ajax "Ajax/photos.json"
window.onscroll = ->
	scroll_to_load()
