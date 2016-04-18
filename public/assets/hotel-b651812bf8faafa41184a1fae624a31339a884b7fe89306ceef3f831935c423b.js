$(document).ready(function(){
	var $dateContainer = $('.hotel-search--date');
	$('.hotel-roundtour-date--open').click(function(){
		if($dateContainer.is(':hidden')){
			$dateContainer.slideDown(300);
			$('body,html').animate({
				scrollTop : $dateContainer.offset().top - 53
			},300);
		}
		return false;
	});
	$('.hotel-selectdate--save').click(function(){
		dateSave();
		$dateContainer.slideUp(150);
		$('body,html').animate({
			scrollTop : $('.hotel-search--container').offset().top - 53
		},300);
		return false;
	});
	var hotelSearch = {};
	var city,cityId,place,placeId,placeType,date,nights,adults,cityId;
	var children = {};
	$('.form-hotelsearch').on('submit',function(){
		var $form = $(this);
		city = $form.find('.roundtour-city--select').text();
		cityId = $form.find('#city-id').val();
		place = $form.find('.roundtour-place .text').text();
		placeId = $form.find('#place_id').val();
		placeType = $form.find('#place_type').val();
		date = $form.find('.roundtour-date--months').text();
		date = date.replace(',','');
		nigths = $form.find('.roundtour-date--nights').text();
		adults = $form.find('.roundtour-people--adults li:last').index() + 1;
		for(var key in children){
			delete children[key];
		}
		$('.roundtour-people--childrens li').each(function(){
			children[$(this).index()+1] = +$(this).find('.roundtour-people--year').text();
		});
		hotelSearch = {
			city : city,
			cityId : cityId,
			place : place,
			placeId : placeId,
			placeType : placeType,
			date : date,
			nights : nigths,
			adults : adults,
			children : children
		}
		console.log(hotelSearch);
	});

});
