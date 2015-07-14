function photoClick(){
	alert('是不是很帅？！')
	alert('确定很帅？')
}
function clickcard(card){
	if (card.classList.contains('card') || card.classList.contains('card-large') ){
		item = document.getElementById('float')
		if (item !== null) {
			item.parentNode.removeChild(item);
		};
		var top = cumulativeOffset(card).top;
		console.log(top);
		var popup = card.cloneNode(true);
		popup.classList.add('card-open');
		popup.classList.remove('card');
		var float = document.createElement('div');
		float.classList.add('full-page-layout');
		float.appendChild(popup);
		float.style.top = parseInt(top)+'px'
		float.id = 'float'
		document.body.insertBefore(float,document.body.firstChild);
	}
	else{
		float = card.parentNode
		float.parentNode.removeChild(float);
	}
}


cumulativeOffset = function(element) {
    var top = 0, left = 0;
    do {
        top += element.offsetTop  || 0;
        left += element.offsetLeft || 0;
        element = element.offsetParent;
    } while(element);

    return {
        top: top,
        left: left
    };
};