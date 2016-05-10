/*!
 * @preserve
 *
 * Readmore.js jQuery plugin
 * Author: @jed_foster
 * Project home: http://jedfoster.github.io/Readmore.js
 * Licensed under the MIT license
 *
 * Debounce function from http://davidwalsh.name/javascript-debounce-function
 */
!function(e){"use strict";function t(e,t,i){var n;return function(){var a=this,s=arguments,o=function(){n=null,i||e.apply(a,s)},l=i&&!n;clearTimeout(n),n=setTimeout(o,t),l&&e.apply(a,s)}}function i(e){var t=++c;return String(null==e?"rmjs-":e)+t}function n(e){var t=e.clone().css({height:"auto",width:e.width(),maxHeight:"none",overflow:"hidden"}).insertAfter(e),i=t.outerHeight(),n=parseInt(t.css({maxHeight:""}).css("max-height").replace(/[^-\d\.]/g,""),10),a=e.data("defaultHeight");t.remove();var s=n||e.data("collapsedHeight")||a;e.data({expandedHeight:i,maxHeight:n,collapsedHeight:s}).css({maxHeight:"none"})}function a(e){if(!d[e.selector]){var t=" ";e.embedCSS&&""!==e.blockCSS&&(t+=e.selector+" + [data-readmore-toggle], "+e.selector+"[data-readmore]{"+e.blockCSS+"}"),t+=e.selector+"[data-readmore]{transition: height "+e.speed+"ms;overflow: hidden;}",function(e,t){var i=e.createElement("style");i.type="text/css",i.styleSheet?i.styleSheet.cssText=t:i.appendChild(e.createTextNode(t)),e.getElementsByTagName("head")[0].appendChild(i)}(document,t),d[e.selector]=!0}}function s(t,i){this.element=t,this.options=e.extend({},l,i),a(this.options),this._defaults=l,this._name=o,this.init(),window.addEventListener?(window.addEventListener("load",r),window.addEventListener("resize",r)):(window.attachEvent("load",r),window.attachEvent("resize",r))}var o="readmore",l={speed:100,collapsedHeight:200,heightMargin:16,moreLink:'<a href="#">Read More</a>',lessLink:'<a href="#">Close</a>',embedCSS:!0,blockCSS:"display: block; width: 100%;",startOpen:!1,beforeToggle:function(){},afterToggle:function(){}},d={},c=0,r=t(function(){e("[data-readmore]").each(function(){var t=e(this),i="true"===t.attr("aria-expanded");n(t),t.css({height:t.data(i?"expandedHeight":"collapsedHeight")})})},100);s.prototype={init:function(){var t=this,a=e(this.element);a.data({defaultHeight:this.options.collapsedHeight,heightMargin:this.options.heightMargin}),n(a);var s=a.data("collapsedHeight"),o=a.data("heightMargin");if(a.outerHeight(!0)<=s+o)return!0;var l=a.attr("id")||i(),d=t.options.startOpen?t.options.lessLink:t.options.moreLink;a.attr({"data-readmore":"","aria-expanded":!1,id:l}),a.after(e(d).on("click",function(e){t.toggle(this,a[0],e)}).attr({"data-readmore-toggle":"","aria-controls":l})),t.options.startOpen||a.css({height:s})},toggle:function(t,i,n){n&&n.preventDefault(),t||(t=e('[aria-controls="'+this.element.id+'"]')[0]),i||(i=this.element);var a=this,s=e(i),o="",l="",d=!1,c=s.data("collapsedHeight");s.height()<=c?(o=s.data("expandedHeight")+"px",l="lessLink",d=!0):(o=c,l="moreLink"),a.options.beforeToggle(t,i,!d),s.css({height:o}),s.on("transitionend",function(){a.options.afterToggle(t,i,d),e(this).attr({"aria-expanded":d}).off("transitionend")}),e(t).replaceWith(e(a.options[l]).on("click",function(e){a.toggle(this,i,e)}).attr({"data-readmore-toggle":"","aria-controls":s.attr("id")}))},destroy:function(){e(this.element).each(function(){var t=e(this);t.attr({"data-readmore":null,"aria-expanded":null}).css({maxHeight:"",height:""}).next("[data-readmore-toggle]").remove(),t.removeData()})}},e.fn.readmore=function(t){var i=arguments,n=this.selector;return t=t||{},"object"==typeof t?this.each(function(){if(e.data(this,"plugin_"+o)){var i=e.data(this,"plugin_"+o);i.destroy.apply(i)}t.selector=n,e.data(this,"plugin_"+o,new s(this,t))}):"string"==typeof t&&"_"!==t[0]&&"init"!==t?this.each(function(){var n=e.data(this,"plugin_"+o);n instanceof s&&"function"==typeof n[t]&&n[t].apply(n,Array.prototype.slice.call(i,1))}):void 0}}(jQuery),function(){$('[data-click="showfilter"]').click(function(){return $("#sub-header-filter").slideDown(),$("#nav-toggle").addClass("activeFilter"),!1}),"#showfilter"==window.location.hash&&$('[data-click="showfilter"]')[0].click()}($),function(){$("#nav-toggle").click(function(){return $(this).hasClass("activeFilter")?($("#sub-header-filter").slideUp(),$("#nav-toggle").removeClass("activeFilter"),!1):void($($(this).data("target")).hasClass("canvas-slid")?$(this).removeClass("active"):$(this).addClass("active"))}),$(document).on("click",".canvas-slid",function(e){$(e.target).closest("#site-menu").length<1&&$("#nav-toggle").removeClass("active")})}($),function(){$("#stt").click(function(){return $("body,html").animate({scrollTop:0},400),!1})}($),function(){function e(){var e=0,i=window.pageYOffset;i>e?t.add():i==e&&t.remove()}var t={flagAdd:!0,elements:[],init:function(e){this.elements=e},add:function(){if(this.flagAdd){for(var e=0;e<this.elements.length;e++)document.getElementById(this.elements[e]).className+=" fixed-theme";this.flagAdd=!1}},remove:function(){for(var e=0;e<this.elements.length;e++)document.getElementById(this.elements[e]).className=document.getElementById(this.elements[e]).className.replace(/(?:^|\s)fixed-theme(?!\S)/g,"");this.flagAdd=!0}};t.init(["all-header","login-link","nav-toggle"]),window.onscroll=function(){e()},e()}(),function(){$(".main-page").on("click",".item .title-price",function(){$(this).closest(".item").hasClass("opened")?$(this).closest(".item").removeClass("opened"):($(this).closest(".main-page").find(".item").removeClass("opened"),$(this).closest(".item").addClass("opened"))})}($),function(){function e(e){$oldSlide=carouselContainer.find(".item.active"),$newSlide=$(e.relatedTarget),$m_direction="margin-"+e.direction,$m_antidirection="left"==e.direction?"margin-right":"margin-left",oNewStyle={},oNewStyle[$m_direction]="500px",oNewStyle[$m_antidirection]="-500px",oNewStyle.opacity="hide",resetStyle={},resetStyle[$m_direction]="0px",resetStyle[$m_antidirection]="0px",oAnimateOld={},oAnimateOld[$m_direction]="-500px",oAnimateOld[$m_antidirection]="500px",oAnimateOld.opacity="hide",oAnimateNew={},oAnimateNew[$m_direction]="0px",oAnimateNew[$m_antidirection]="0px",oAnimateNew.opacity="show",$oldSlide.find("h3").animate(oAnimateOld,1e3,"easeInOutQuint"),$oldSlide.find("em").delay(200).animate(oAnimateOld,1e3,"easeInOutQuint"),$oldSlide.find(".btnset").delay(400).animate(oAnimateOld,1e3,"easeInOutQuint"),$newSlide.find("h3").css(oNewStyle).delay(500).animate(oAnimateNew,1e3,"easeInOutQuint"),$newSlide.find("em").css(oNewStyle).delay(700).animate(oAnimateNew,1e3,"easeInOutQuint"),$newSlide.find(".btnset").css(oNewStyle).delay(900).animate(oAnimateNew,1e3,"easeInOutQuint",function(){carouselContainer.find(".item").find("h3,em,.btnset").css(resetStyle)})}function t(){}$(".carousel").swiperight(function(){$(this).carousel("prev")}).swipeleft(function(){$(this).carousel("next")}),carouselContainer=$("#header-slider"),carouselContainer.on("slide.bs.carousel",e).on("slid.bs.carousel",t),$("[id^=carousel-selector-]").click(function(){var e=$(this).attr("id"),t=e.substr(e.length-1);t=parseInt(t),carouselContainer.carousel(t),$("[id^=carousel-selector-]").removeClass("selected"),$(this).addClass("selected")}),carouselContainer.on("slid.bs.carousel",function(){var e=parseInt($(".carousel-indicators li.active").data("slideTo"));console.log(e),$("[id^=carousel-selector-]").removeClass("selected"),$("[id=carousel-selector-"+e+"]").addClass("selected")})}($),function(){$(".selectize").selectize({allowEmptyOption:!0}),$(".selectize-text").selectize()}($),function(){$('input[data-type="datepicker"], .input-group.date').datetimepicker({locale:"ru",format:"DD.MM.YYYY",sideBySide:!0})}($),function(){$circles=$("#circle-blocks"),$circles.on("click",".block:not(.active)",function(){$circles.find(".active").removeClass("active"),$(this).addClass("active"),$("[data-target="+this.id+"]").addClass("active")}),$circles.on("click",".controls span:not(.active)",function(){$circles.find(".active").removeClass("active"),$("#"+$(this).data("target")).addClass("active"),$(this).addClass("active")})}($),function(){$faq=$("#faq"),$faq.find(".question").click(function(){$item=$(this).closest(".item"),$item.hasClass("active")?$item.find(".answer").slideUp(300,function(){$item.removeClass("active")}):($faq.find(".active .answer").slideUp(300,function(){$(this).closest(".item").removeClass("active")}),$item.addClass("active").find(".answer").slideDown(300))}),$faq.find(".answer").css("display","none")}($),function(){}($),function(){$xPM=$(".count-input"),$xPM.on("click",".plus",function(){$this=$(this).closest(".count-input");var e=$this.attr("data-input-id");$input=$("input#"+e);var t=parseInt($input.val())+1,i=parseInt($input.attr("max"));t=i>t?t:i,$input.val(t),$input.blur()}),$xPM.on("click",".minus",function(){$this=$(this).closest(".count-input");var e=$this.attr("data-input-id");$input=$("input#"+e);var t=parseInt($input.val())-1,i=parseInt($input.attr("min"));t=t>i?t:i,$input.val(t),$input.blur()})}($),function(){$xDD=$(".x-input-dd"),$xDD.each(function(){this.setDef=function(){var e=$(this),t=e.find("input");if(t.attr("placeholder"))e.children("sub").html("<i>"+t.attr("placeholder")+"</i>");else{var i=e.find("span i:first"),n=i.data("value"),a=i.html();t.val(n),e.children("sub").html(a)}};var e=$(this);e.addClass("closed");var t=e.find("input").val();if(t){var i=e.find("span i[data-value="+t+"]"),n=i.html();i&&n?(e.children("sub").html(n),i.addClass("selected")):this.setDef()}else this.setDef()}),$xDD.on("click","sub",function(){var e=$(this).closest(".x-input-dd");if(e.hasClass("closed")){var t=$xDD.filter(".opened");t.find("span").stop().slideUp(300),t.removeClass("opened").addClass("closed"),e.find("span").stop().slideDown(300),e.removeClass("closed").addClass("opened")}else e.find("span").stop().slideUp(300),e.removeClass("opened").addClass("closed")}),$xDD.on("click","span i",function(){var e=$(this).closest(".x-input-dd"),t=e.attr("data-input-id");console.log(t);var i=$("input#"+t),n=$(this).data("value"),a=$(this).html();e.find("span i.selected").removeClass("selected"),$(this).addClass("selected"),e.children("sub").html(a),i.val(n),e.find("span").stop().slideUp(300),e.removeClass("opened").addClass("closed")}),$(document).on("click",function(e){if(!$(e.target).closest(".x-input-dd").length){var t=$xDD.filter(".opened");t.find("span").stop().slideUp(300),t.removeClass("opened").addClass("closed")}})}($),function(){$xCBG=$(".x-input-chk-group"),$xCBG.each(function(){$(this).addClass("closed")}),$xCBG.on("click","sub",function(){var e=$(this).closest(".x-input-chk-group");if(e.hasClass("closed")){var t=$xCBG.filter(".opened");t.find(".x-group").stop().slideUp(300),t.removeClass("opened").addClass("closed"),e.find(".x-group").slideDown(300),e.removeClass("closed").addClass("opened")}else e.find(".x-group").slideUp(300),e.removeClass("opened").addClass("closed")}),$(document).on("click",function(e){if(!$(e.target).closest(".x-input-chk-group").length){var t=$xCBG.filter(".opened");t.find(".x-group").slideUp(300),t.removeClass("opened").addClass("closed")}})}($),function(){$('[href="#"]').click(function(){return!1})}($);var url=document.location.toString();url.match("#")&&$('#hotel-tabs a[href="#'+url.split("#")[1]+'"]').tab("show"),function(){$("#cb-wh").change(function(){$("#children_input").toggle(400),this.checked||$("#children_input #s_kids").val(0)})}($),function(){$(".fancybox").fancybox({fitToView:!1,maxWidth:"90%"})}($),function(){function e(){var e=0;$(".hotel-slider .slick-dots").find("li").each(function(){e+=$(this).width()+8}),$(".hotel-slider .slick-prev").css({"margin-right":e/2+20}),$(".hotel-slider .slick-next").css({"margin-left":e/2+20})}$(".hotel-slider").slick({dots:!0,infinite:!0,slidesToShow:3,slidesToScroll:3,responsive:[{breakpoint:991,settings:{arrows:!1}},{breakpoint:768,settings:{arrows:!1,slidesToShow:1,slidesToScroll:1}}]}),e(),$(window).resize(e)}($),$(".block-hotel-comments--content").readmore({speed:75,collapsedHeight:110,heightMargin:40,moreLink:'<a href="#" class="block-hotel-comments--fulllink">\u0427\u0438\u0442\u0430\u0442\u044c \u043e\u0442\u0437\u044b\u0432</a>',lessLink:'<a href="#" class="block-hotel-comments--fulllink">\u0421\u0432\u0435\u0440\u043d\u0443\u0442\u044c</a>'}),$(".hotel-comment--text").readmore({speed:75,collapsedHeight:50,heightMargin:40,moreLink:'<a href="#" class="hotel-comment--fulllink hidden-xs">\u0427\u0438\u0442\u0430\u0442\u044c \u043e\u0442\u0437\u044b\u0432</a>',lessLink:'<a href="#" class="hotel-comment--fulllink hidden-xs">\u0421\u0432\u0435\u0440\u043d\u0443\u0442\u044c</a>'}),$(".more-tours").click(function(){var e=parseInt($(this).attr("data-page")),t=$(this).find("a").attr("href");$(this).find("a").attr("href",t.split("&")[0]+"&page="+e),$(this).attr("data-page",e+1)});