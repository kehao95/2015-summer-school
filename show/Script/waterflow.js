// Generated by CoffeeScript 1.9.3
(function() {
  var AjaxSync, Alert, clickcard, divbuttom, divtop, foo, getPosition, initLoad, loadPhoto, log, root, scroll_to_load,
    slice = [].slice;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.run = function() {};

  log = function() {
    var i, k, len, results;
    results = [];
    for (k = 0, len = arguments.length; k < len; k++) {
      i = arguments[k];
      results.push(console.log(i));
    }
    return results;
  };

  Alert = function() {
    var arg;
    arg = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return alert(arg.join(''));
  };

  AjaxSync = function(url) {
    var async;
    return $.ajax(url, async = false);
  };

  initLoad = function(filename) {
    var ajaxloader;
    ajaxloader = new XMLHttpRequest();
    ajaxloader.open("GET", "Ajax/photos.json", true);
    ajaxloader.onreadystatechange = function() {
      if (ajaxloader.readyState === 4 && ajaxloader.status === 200) {
        root.re = JSON.parse(ajaxloader.responseText);
        
			var count = 0;
			for (var k in re) {
			    if (re.hasOwnProperty(k)) {
			       ++count;
			    }
			}
			;
        root.re.length = count;
        loadPhoto();
        loadPhoto();
        loadPhoto();
        loadPhoto();
        if ($(window).height() === $(document).height()) {
          return loadPhoto();
        }
      }
    };
    return ajaxloader.send();
  };

  foo = false;

  loadPhoto = function() {
    var col, colAppendPhoto, distence, k, len, loadAddiction, loaded, ref;
    distence = function(pos1, pos2) {
      var arccos, cos, pi, sin;
      pi = 3.141592654;
      cos = Math.cos;
      sin = Math.sin;
      arccos = Math.acos;
      return 6370.996 * arccos(cos(pos1.latitude * pi / 180) * cos(pos2.latitude * pi / 180) * cos(pos1.longitude * pi / 180 - pos2.longitude * pi / 180) + sin(pos1.latitude * pi / 180) * sin(pos2.latitude * pi / 180));
    };
    loaded = function() {
      $('.card').css("display", "inline-block");
      return loadAddiction();
    };
    colAppendPhoto = function(col) {
      var Url, card, content, img, imgsrc, pos;
      if (id >= re.length - 1 && foo === false) {
        foo = true;
        loaded();
        Alert("loaded all");
        return;
      }
      log("load");
      imgsrc = re[id]['tumb'];
      pos = {};
      pos.latitude = re[id].latitude;
      pos.longitude = re[id].longitude;
      content = null;
      if (position.getSuccess) {
        if (pos.longitude !== null) {
          content = "<p>距此 " + (distence(pos, position).toFixed(1)) + "km</p>";
          Url = "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + re[id].latitude + "," + re[id].longitude + "&sensor=true";
          log("googleapi");
          
				$.ajax({url:Url,dataType:'json',index:id,success:function(data){
				log(data.status)
				log(data.results[1].formatted_address)
				addr = data.results[1].formatted_address.replace(" .*","")
				$("#img_"+this.index).append("<p>"+addr+"</p>")
				}})
				;
        } else {
          content = "";
        }
      }
      img = $(document.createElement('div')).addClass('image').append($('<img />').attr('src', imgsrc)).attr('alt', 'id');
      img.bind('load', onload);
      card = $(document.createElement('div')).addClass('card').addClass('up-down').append(img).append(content).attr('id', 'img_' + id).bind("click", clickcard);
      card.css("display", "none");
      card.appendTo(col);
      return id += 1;
    };
    loadAddiction = function() {
      var Ncol, buttom_of_short, i, j, k, l, lastCards, loadI, ref, ref1, results, top_of_long;
      Ncol = $('.column').length;
      lastCards = $('.column .card:last-child');
      if (lastCards === []) {
        return;
      }
      results = [];
      for (i = k = 0, ref = Ncol - 1; 0 <= ref ? k <= ref : k >= ref; i = 0 <= ref ? ++k : --k) {
        loadI = false;
        for (j = l = 0, ref1 = Ncol - 1; 0 <= ref1 ? l <= ref1 : l >= ref1; j = 0 <= ref1 ? ++l : --l) {
          if (i !== j) {
            buttom_of_short = divbuttom(lastCards[i]);
            top_of_long = divtop(lastCards[j]);
            if (divbuttom(lastCards[i]) < divtop(lastCards[j])) {
              loadI = true;
            }
          }
        }
        if (loadI) {
          results.push(colAppendPhoto(lastCards[i].parentNode));
        } else {
          results.push(void 0);
        }
      }
      return results;
    };
    log("append columns");
    ref = $('.column');
    for (k = 0, len = ref.length; k < len; k++) {
      col = ref[k];
      colAppendPhoto(col);
    }
    return $('.columns').attr('onload', loaded);
  };

  clickcard = function() {
    var POP, clickloadMore, commentspage, copyCardWithImage, id, loadCard, loadComments, loadingGIF, newComment, newCommentBox, newComments, newLoadMore, onloadPOP, page;
    commentspage = 1;
    copyCardWithImage = function(id) {
      var card, img;
      card = $("#" + id).clone();
      log(card);
      img = card.find('img').attr('src', card.find('img').attr('src').replace("tumbnails", "")).bind('load', onloadPOP);
      card.find('p').remove();
      card.removeClass('up-down');
      return card;
    };
    newCommentBox = function() {
      return $(document.createElement('div')).addClass('commentBox');
    };
    newComments = function() {
      var comments;
      return comments = $(document.createElement('div')).attr('id', 'comments');
    };
    newComment = function(author, speach) {
      var a, comment, s;
      comment = $(document.createElement('div')).addClass('comment');
      a = $(document.createElement('h1')).append(author);
      s = $(document.createElement('p')).append(speach);
      return comment.append(a).append(s);
    };
    newLoadMore = function() {
      var load;
      load = $(document.createElement('button')).attr('id', 'LoadMore').append("[获取更多]");
      return load;
    };
    onloadPOP = function() {
      log("onload");
      log($('#POP').find('.card'));
      return $('#POP').find('.card').css('opacity', '1');
    };
    clickloadMore = function(event) {
      event.stopPropagation();
      return loadComments();
    };
    loadCard = function(id) {
      var card, commentBox, comments, loadMore;
      card = copyCardWithImage(id);
      commentBox = newCommentBox();
      loadMore = newLoadMore();
      comments = newComments().append(commentBox);
      comments.append(loadMore);
      card.append(comments);
      POP.append(card);
      document.getElementById('POP').addEventListener("click", clickPOP);
      document.getElementById('LoadMore').addEventListener("click", clickloadMore);
      document.getElementById('POP').onload = onloadPOP;
      return loadComments();
    };
    loadingGIF = function() {
      var gif, lo;
      lo = document.createElement('div');
      $(lo).addClass('loadingGIF');
      gif = $(document.createElement('img')).attr('src', 'Images/loading.gif');
      $(lo).append(gif).append('<p>正在努力加载中...</p>');
      return $('#POP').append(lo);
    };
    page = 0;
    loadComments = function() {
      var Url, dataType, file, success;
      success = function() {
        var comment, data, i, other;
        data = arguments[0], other = 2 <= arguments.length ? slice.call(arguments, 1) : [];
        if (page >= 3) {
          $('#LoadMore').remove();
        }
        i = 0;
        while (data.hasOwnProperty(i)) {
          log("data[i]", data[i]);
          comment = newComment(data[i].author, data[i].comment);
          log("comment", comment);
          $('.commentBox').append(comment);
          i++;
        }
        return page++;
      };
      file = "comment_" + page + ".json";
      Url = "Ajax/" + file;
      return $.ajax({
        url: Url
      }, dataType = 'json').done(success);
    };
    id = $(this).attr('id');
    POP = $(document.createElement('div')).attr('id', 'POP').appendTo($('body'));
    loadingGIF();
    return loadCard(id);
  };

  root.clickPOP = function() {
    return $(document.getElementById('POP')).remove();
  };

  scroll_to_load = function() {
    if ($(window).scrollTop() + $(window).height() > $(document).height() - 50) {
      return loadPhoto();
    }
  };

  divbuttom = function(div) {
    if (div === void 0) {
      return 100;
    } else {
      return $(div).position().top + $(div).height();
    }
  };

  divtop = function(div) {
    if (div === void 0) {
      return 0;
    } else {
      return $(div).position().top;
    }
  };

  getPosition = function() {
    var error, success;
    success = function(pos) {
      position.latitude = pos.coords.latitude;
      position.longitude = pos.coords.longitude;
      position.getSuccess = true;
      log("success to locate :", position.latitude, " ", position.longitude);
      return initLoad("Ajax/photos.json");
    };
    error = function(e) {
      Alert("failed to get location set at Tsinghua as defult");
      position.latitude = 40.009624;
      position.longitude = 116.325859;
      position.getSuccess = true;
      return initLoad("Ajax/photos.json");
    };
    if (navigator.geolocation) {
      return navigator.geolocation.getCurrentPosition(success, error, {
        timeout: 800
      });
    }
  };

  window.position = {
    latitude: 0,
    longitude: 0,
    getSuccess: false
  };

  window.id = 0;

  window.onkeydown = function() {
    return loadPhoto();
  };

  window.onresize = function() {};

  window.onload = function() {
    return getPosition();
  };

  window.onscroll = function() {
    return scroll_to_load();
  };

}).call(this);
