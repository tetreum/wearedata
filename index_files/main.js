(function(){

    var oneDay = 24*60*60*1000; // hours*minutes*seconds*milliseconds
    var deadline = new Date(2013,05,25);
    var today = new Date();
    var diffDays = Math.round(Math.abs((deadline.getTime() - today.getTime())/(oneDay)));

    function selectText(element) {
        var doc = document;
        var text = doc.getElementById(element);

        if (doc.body.createTextRange) { // ms
            var range = doc.body.createTextRange();
            range.moveToElementText(text);
            range.select();
        } else if (window.getSelection) { // moz, opera, webkit
            var selection = window.getSelection();
            var range = doc.createRange();
            range.selectNodeContents(text);
            selection.removeAllRanges();
            selection.addRange(range);
        }
    }

    $(window).ready(function(){
        diffDays += 1;
        $('h3').text("J-"+diffDays);
        var posit = -150/(6/diffDays)-120;
        posit =Math.max(-350, Math.min(posit, -150));
        TweenLite.to($('.jauge-barre'), 1, {marginLeft:posit, delay:1});
        var shareOpened = false;
        var pictsContainer = $('.share-pictos-container');
        var picts = $('.share-pictos');
        var arrow = $('.share-pics img');
        var url = "http://wearedata.watchdogs.com/";
        TweenLite.to(picts, 0, {autoAlpha:1, marginTop:150});

        $('.share-inline').bind('click', function(event) {event.preventDefault();});
        $('.share-inline').on("mouseover touchstart", openShare);
        $('.share-pictos a').on("mouseover", onOverPicto);
        $('.share-pictos a').on("mouseout", onOutPicto);
        $('.share-pictos a').on("click touchstart", onClickPicto);
        $('.share-link-close').on("click touchstart", onCloseLinkPopin);
        $('.link-copy-field').on("click touchstart", onCopyLink);
        $('.link-copy-btn').on("click touchstart", onCopyLink);
        $('.footer-left a').on("mouseover", onOverFooterBtn);
        $('.footer-right a').on("mouseover", onOverFooterBtn);
        $('.footer-right a').on("mouseout", onOutFooterBtn);
        $('.footer-left a').on("mouseout", onOutFooterBtn);

        pictsContainer.on("mouseenter", openShare);
        $('.share-inline').add(pictsContainer).on("mouseleave", closeShare);

        function onOverFooterBtn(e){
            TweenLite.to($(this), 0.2, {color:"#cccccc"});
        }

        function onOutFooterBtn(e){
            TweenLite.to($(this), 0.2, {color:"#505050"});
        }

        function onCopyLink(e){
            e.preventDefault();
            selectText('copy-field');
        }

        function onCloseLinkPopin(e){
            e.preventDefault();
            TweenLite.to($('#share-link'), 0.2, {autoAlpha:0});
        }

        function onClickPicto(e){
            e.preventDefault();
            var service = $(this).attr('data-link');
            var urlShare = "";
            var description = "Have you ever experienced the power of data ? Be prepared for Watch_Dogs WeareData.";

            if(service == "gplus"){
                urlShare = "https://plus.google.com/share?url="+encodeURIComponent(url);
                window.open(urlShare,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');
            }else if(service == "fb"){
                urlShare = "https://www.facebook.com/sharer/sharer.php?u="+encodeURIComponent(url);
                window.open(urlShare,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600');
            }else if(service =="twitter"){
                urlShare = "https://twitter.com/intent/tweet?text=";
                urlShare+= encodeURIComponent(description)+" "+url;
                window.open(urlShare,'', 'menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=290,width=600');
            }else if(service == "link"){
                TweenLite.to($('#share-link'), 0.3, {autoAlpha:1});
            }

        }

        function onOverPicto(e){
            TweenLite.to($(this), 0.2, {alpha:0.5});
        }

        function onOutPicto(e){
            TweenLite.to($(this), 0.35, {alpha:1});
        }

        function closeShare(){
            if(!shareOpened) return;
            $('body').off("mousedown touchstart", closeShare);
            TweenLite.to(picts, 0.2, {marginTop:150, ease:Circ.easeInOut, onComplete: function(){
                pictsContainer.hide();
            }});
            TweenLite.to(arrow, 0.4, {rotation:0, ease:Circ.easeOut});
            shareOpened = false;
        }

        function openShare(e){
            if(shareOpened) return;
            shareOpened = true;
            TweenLite.killTweensOf(picts);
            pictsContainer.show();
            $('body').on("mousedown touchstart", closeShare);
            TweenLite.to(picts, 0.2, {marginTop:0, ease:Circ.easeOut});
            TweenLite.to(arrow, 0.6, {rotation:180, ease:Circ.easeOut});
        }
    });

    window.__landing = {
        show: function(){
            $('html').addClass('is-landing');
        },
        hide: function(){
            $('html').removeClass('is-landing');
        }
    };

}());
