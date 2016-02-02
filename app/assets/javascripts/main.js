/***********************************
 * Created by Devorans.com
 * Author: Admin
 * File:
 * Project: tour
 * Date: 14.10.2015
 * Feedback: support@devorans.com
 ************************************/


//*  SUB HEADER FILTER  */
(function(){
	$('[data-click="showfilter"]').click(function(){
		$('#sub-header-filter').slideDown();
		$('#nav-toggle').addClass('activeFilter');
		return false;
	});

	if(window.location.hash == "#showfilter"){
		$('[data-click="showfilter"]')[0].click();
	}
})($);

//*  NAV TOGGLE ICON */ 
(function(){
	$('#nav-toggle').click(function(){
		if($(this).hasClass('activeFilter')){
			$('#sub-header-filter').slideUp();
			$('#nav-toggle').removeClass('activeFilter');
			return false;
		}
		else {
			if($($(this).data('target')).hasClass('canvas-slid')){
				$(this).removeClass('active');
			}
			else{
				$(this).addClass('active');
			}
		}
	});
	$(document).on('click','.canvas-slid',function(e){
		if($(e.target).closest('#site-menu').length < 1){
			$('#nav-toggle').removeClass('active');
		}
	})
})($);

//*  SCROLL TO TOP */
(function(){
	$('#stt').click(function () {
		$('body,html').animate({scrollTop: 0}, 400);
		return false;
	});
})($);

//*  FIXED MENU  */
(function(){
	var myNavBar = {

		flagAdd: true,

		elements: [],

		init: function (elements) {
			this.elements = elements;
		},

		add : function() {
			if(this.flagAdd) {
				for(var i=0; i < this.elements.length; i++) {
					document.getElementById(this.elements[i]).className += " fixed-theme";
				}
				this.flagAdd = false;
			}
		},

		remove: function() {
			for(var i=0; i < this.elements.length; i++) {
				document.getElementById(this.elements[i]).className =
						document.getElementById(this.elements[i]).className.replace( /(?:^|\s)fixed-theme(?!\S)/g , '' );
			}
			this.flagAdd = true;
		}

	};

	/**
	 * Init the object. Pass the object the array of elements
	 * that we want to change when the scroll goes down
	 */
	myNavBar.init(  [
		"all-header",
		"login-link",
		"nav-toggle"
	]);

	/**
	 * Function that manage the direction
	 * of the scroll
	 */
	function offSetManager(){

		var yOffset = 0;
		var currYOffSet = window.pageYOffset;

		if(yOffset < currYOffSet) {
			myNavBar.add();
		}
		else if(currYOffSet == yOffset){
			myNavBar.remove();
		}

	}

	/**
	 * bind to the document scroll detection
	 */
	window.onscroll = function() {offSetManager();};

	/**
	 * We have to do a first detectation of offset because the page
	 * could be load with scroll down set.
	 */
	offSetManager();
})();

//*  MAIN PAGE ACCORDEON  */
(function(){
	$('.main-page').on('click','.item .title-price', function(){
		if(!$(this).closest('.item').hasClass('opened')){
			$(this).closest('.main-page').find('.item').removeClass('opened');
			$(this).closest('.item').addClass('opened');
		}
		else{
			$(this).closest('.item').removeClass('opened');
		}

	})
})($);

//*  HEADER SLIDER  */
(function(){

	$(".carousel")
			.swiperight(function() {$(this).carousel('prev');})
			.swipeleft(function() {$(this).carousel('next');});

	carouselContainer = $('#header-slider');

	function MYtoggleA(e){
		//console.log(e);
		$oldSlide = carouselContainer.find('.item.active');
		$newSlide = $(e.relatedTarget);

		$m_direction = 'margin-'+e.direction;
		$m_antidirection = e.direction=='left'?'margin-right':'margin-left';

		oNewStyle = {};
		oNewStyle[$m_direction] = '500px';
		oNewStyle[$m_antidirection] = '-500px';
		oNewStyle.opacity = 'hide';

		resetStyle = {};
		resetStyle[$m_direction] = '0px';
		resetStyle[$m_antidirection] = '0px';

		oAnimateOld = {};
		oAnimateOld[$m_direction] = '-500px';
		oAnimateOld[$m_antidirection] = '500px';
		oAnimateOld.opacity = 'hide';

		oAnimateNew = {};
		oAnimateNew[$m_direction] = '0px';
		oAnimateNew[$m_antidirection] = '0px';
		oAnimateNew.opacity = 'show';

		$oldSlide.find('h3').animate(oAnimateOld,1000,'easeInOutQuint');
		$oldSlide.find('em').delay( 200 ).animate(oAnimateOld,1000,'easeInOutQuint');
		$oldSlide.find('.btnset').delay( 400 ).animate(oAnimateOld,1000,'easeInOutQuint');

		$newSlide.find('h3').css(oNewStyle)
				.delay( 500 ).animate(oAnimateNew,1000,'easeInOutQuint');
		$newSlide.find('em').css(oNewStyle)
				.delay( 700 ).animate(oAnimateNew,1000,'easeInOutQuint');
		$newSlide.find('.btnset').css(oNewStyle)
				.delay( 900 ).animate(oAnimateNew,1000,'easeInOutQuint',function(){
					                      carouselContainer.find('.item').find('h3,em,.btnset').css(resetStyle);
				                      });


	}
	function MYtoggleB(e){
	}

	carouselContainer
			.on('slide.bs.carousel', MYtoggleA)
			.on('slid.bs.carousel', MYtoggleB);

	// handles the carousel thumbnails
	$('[id^=carousel-selector-]').click( function(){
		var id_selector = $(this).attr("id");
		var id = id_selector.substr(id_selector.length -1);
		id = parseInt(id);
		carouselContainer.carousel(id);
		$('[id^=carousel-selector-]').removeClass('selected');
		$(this).addClass('selected');
	});

	// when the carousel slides, auto update
	carouselContainer.on('slid.bs.carousel', function (e) {
		var id = parseInt($('.carousel-indicators li.active').data('slideTo'));
		console.log(id);
		$('[id^=carousel-selector-]').removeClass('selected');
		$('[id=carousel-selector-'+id+']').addClass('selected');
	});

})($);

//*  SELECTISE  */
(function(){
	$('.selectize').selectize({allowEmptyOption:true});
	$('.selectize-text').selectize();
})($);

//*  CALENDAR INPUT  */
(function(){
	$('input[data-type="datepicker"], .input-group.date').datetimepicker({
		locale: 'ru',
		format: "DD.MM.YYYY",
		sideBySide: true
	});
})($);

//*  CIRCLE BLOCKS  */
(function(){
	$circles = $('#circle-blocks');
	$circles.on('click','.block:not(.active)',function(){
		$circles.find('.active').removeClass('active');
		$(this).addClass('active');
		$('[data-target='+this.id+']').addClass('active');
	});

	$circles.on('click','.controls span:not(.active)',function(){
		$circles.find('.active').removeClass('active');
		$('#'+$(this).data('target')).addClass('active');
		$(this).addClass('active');
	});
})($);

//*  FAQ  */
(function(){
	$faq = $('#faq');
	$faq.find('.question').click(function () {
		$item = $(this).closest('.item');
		if($item.hasClass('active')){
			$item.find('.answer').slideUp(300,function(){
				$item.removeClass('active');
			});
		}
		else{
			$faq.find('.active .answer').slideUp(
					300,
					function(){
						$(this).closest('.item').removeClass('active');
					});
			$item.addClass('active').find('.answer').slideDown(300);
		}
	});

	$faq.find('.answer').css('display','none');

})($);

//*  MAPS BLOCK SCROLL  */
(function(){
	$map_wrap = $('.frame-map');

	$map_wrap.on('click', function(){
		$(this).find('iframe').css("pointer-events", "auto");
	});
	$map_wrap.on('mouseleave',function(){
		$(this).find('iframe').css("pointer-events", "none");
	});

	$map_wrap.css("pointer-events", "none");
})($);

//*  PLUSO  */
(function(){

})($);

//*  COUNT INPUT  */
(function(){
	$('.count-input')
			.on('click','.plus',function(){
		$input = $(this).parent().find('input');
		$input.val(parseInt($input.val())+1);
	})
			.on('click','.minus',function(){
		$input = $(this).parent().find('input');
		$input.val(parseInt($input.val())-1);
	});
})($);

//*  X-INPUT  */
(/* x-input-plus-minus */ function(){
	$xPM = $('.x-input-plus-minus');
	$xPM.on('click', '.x-plus', function () {
		$input = $(this).parent().find('input');
		var newVal = parseInt($input.val()) + 1;
		var maxVal = parseInt($input.attr('max'));
		newVal = (maxVal > newVal) ? newVal : maxVal;
		$input.val(newVal);
		$input.blur();
	});
	$xPM.on('click', '.x-minus', function () {
		$input = $(this).parent().find('input');
		var newVal = parseInt($input.val()) - 1;
		var minVal = parseInt($input.attr('min'));
		newVal = (minVal < newVal) ? newVal : minVal;
		$input.val(newVal);
		$input.blur();
	});
})($);
(/* x-input-dd */ function(){
	$xDD = $('.x-input-dd');
	$xDD.each(function(){
		this.setDef = function(){
			var $this = $(this);
			var $input = $this.find('input');
			if($input.attr('placeholder')){
				$this.children('sub').html('<i>'+$input.attr('placeholder')+'</i>');
			}
			else{
				var $defItem = $this.find('span i:first');
				var defVal = $defItem.data('value');
				var defTxt = $defItem.html();
				$input.val(defVal);
				$this.children('sub').html(defTxt);
			}
		};
		var $this = $(this);
		$this.addClass('closed');
		var curVal = $this.find('input').val();
		if(curVal){
			var $selected = $this.find('span i[data-value='+curVal+']');
			var valName = $selected.html();
			if($selected && valName){
				$this.children('sub').html(valName);
				$selected.addClass('selected');
			}
			else this.setDef();
		}
		else this.setDef();
	});

	$xDD.on('click','sub',function(){
		var $this = $(this).closest('.x-input-dd');
		if($this.hasClass('closed')){
			var $allOpened = $xDD.filter('.opened');
			$allOpened.find('span').stop().slideUp(300);
			$allOpened.removeClass('opened').addClass('closed');
			$this.find('span').stop().slideDown(300);
			$this.removeClass('closed').addClass('opened');
		}
		else{
			$this.find('span').stop().slideUp(300);
			$this.removeClass('opened').addClass('closed');
		}
	});
	$xDD.on('click','span i',function(){
		var $this = $(this).closest('.x-input-dd');
		var newVal = $(this).data('value');
		var newTxt = $(this).html();
		$this.find('span i.selected').removeClass('selected');
		$(this).addClass('selected');
		$this.children('sub').html(newTxt);
		$this.children('input').attr('value',newVal);
		$this.find('span').stop().slideUp(300);
		$this.removeClass('opened').addClass('closed');

	});

	$(document).on('click',function(e){
		if(!$(e.target).closest('.x-input-dd').length){
			var $allOpened = $xDD.filter('.opened');
			$allOpened.find('span').stop().slideUp(300);
			$allOpened.removeClass('opened').addClass('closed');
		}
	});
})($);
(/* x-input-chk-group */ function(){
	$xCBG = $('.x-input-chk-group');
	$xCBG.each(function(){$(this).addClass('closed');});
	$xCBG.on('click','sub',function(){
		var $this = $(this).closest('.x-input-chk-group');
		if($this.hasClass('closed')){
			var $allOpened = $xCBG.filter('.opened');
			$allOpened.find('.x-group').stop().slideUp(300);
			$allOpened.removeClass('opened').addClass('closed');
			$this.find('.x-group').slideDown(300);
			$this.removeClass('closed').addClass('opened');
		}
		else{
			$this.find('.x-group').slideUp(300);
			$this.removeClass('opened').addClass('closed');
		}
	});
	$(document).on('click',function(e){
		if(!$(e.target).closest('.x-input-chk-group').length){
			var $allOpened = $xCBG.filter('.opened');
			$allOpened.find('.x-group').slideUp(300);
			$allOpened.removeClass('opened').addClass('closed');
		}
	});
})($);

//*  ЗАГЛУШКА ССЫЛОК # */
(function(){
	$('[href="#"]').click(function(){
		return false;
	});
})($);

// ЗАПРОС НА К API

  // Запустим ajax-запрос, установим обработчики его выполнения и
  // сохраним объект jqxhr данного запроса для дальнейшего использования.
  // var jqxhr = $.get("http://module.sletat.ru/Main.svc/GetTemplates?templatesList=all&login=pr@corona.travel&password=1234567")
  // .success(function() { console.log('Да'); console.log('Data', jqxhr); console.log('Data.templateName', jqxhr.templateName); })
  // .error(function() { console.log('Нет'); });
 // var jqxhr2 = $.get("http://module.sletat.ru/Main.svc/GetCountries?townFromId=1264&showcase=1&login=pr@corona.travel&password=1234567")
 //  .success(function() { console.log('Да'); console.log('Data', jqxhr2); })
 //  .error(function() { console.log('Нет'); });
 //  var jqxhr3 = $.get("http://module.sletat.ru/Main.svc")
 //  .success(function() { console.log('Да'); console.log('Data', jqxhr3); })
 //  .error(function() { console.log('Нет'); });
// console.log('DDD', $.get("http://module.sletat.ru/Main.svc/GetTemplates?templatesList=all&login=pr@corona.travel&password=1234567"))


var url = document.location.toString();
if (url.match('#')) {
    $('#hotel-tabs a[href="#'+url.split('#')[1]+'"]').tab('show') ;
} 
