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
			## log "loadPhoto() done"
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
	colAppendPhoto = (col) ->
		# function to append a photo to a col
		# log id+" in "+re.length
		if id  >= re.length-1
			# log "loaded ALL"
			return 
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
						## log "append to #{i},",i+".buttom"+':'+buttom_of_short+" < "+j+"top"+":"+top_of_long
						loadI = true
			if loadI
				colAppendPhoto lastCards[i].parentNode
	onload = ->
			# log "onload"
			#$('body').addClass("loading"); 
			# log "onload done"
	loaded = ->
			## log "loaded"

			$('.card').css("display","inline-block")
			loadAddiction()
			#$('body').removeClass("loading"); 
			## log "loaded done"
	onload()
	# log "append columns"
	for col in $('.column')
		colAppendPhoto col
	$('.columns').attr('onload',loaded)	
	# log "append columns Done"
	

	
		
clickcard= ->
	# log "clickcard"
	onloadPOP = ->
		log "onload"
		log $('#POP').find('.card')
		$('#POP').find('.card').css('opacity','1')

	id = $(this).attr('id')
	card = $("##{id}").clone()
	img = card.find('img')
	url = img.attr('src').replace("tumbnails","")
	img.attr('src',url)
	POP = $(document.createElement('div')).attr('id','POP')
	img.bind('load',onloadPOP)
	POP.append(card).appendTo($('body'))
	document.getElementById('POP').addEventListener("click",clickPOP)
	document.getElementById('POP').onload = onloadPOP
	

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
