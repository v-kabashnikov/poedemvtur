function showHotels( hotels, requestId ){
            var req = requestId == undefined ? "" : "?requestId=" + requestId;
              for(var i=0; i<hotels.length; i++){
                var stars = "";
                for(var j = 1; j <= hotels[i]['stars_count']; j++){
                  stars += '<img src="/assets/star-4226a930be3bd3b1e768b47996cd08066bfde1629c5197d05b7e2cbf354d7703.png" width="12" height="12" alt="">'
                }
                // var hotel = hotels[i];
              var hotel = '<div class="col-xs-12 col-sm-6 col-md-6 col-large-4 \
              tour-column"> \
      <div class="tour-block tour-block-new"> \
            <div class="tour-header row"> \
            <div class="col-md-7"> \
            <h2><a href="/hotel/' + hotels[i]['id'] + req + '"> \
            ' + hotels[i]['name'] + ' </a></h2> \
            </div> \
              <div class="tour-rating col-md-5"> \
                <div class="tour-rating--star">' + stars +'</div> \
                <span class="tour-rating--num">~ \
                ' + hotels[i]['rating'].toFixed(1) + '</span> \
              </div> \
            </div> \
            <div class="clearfix"></div> \
            <div class="tour-desc">' + hotels[i]['position_info'] + ' \
            </div> \
        <div class="thumb"> \
          <a href="/hotel/' + hotels[i]['id'] + req + '" class="thumb-link"> \
          <img src="' + hotels[i]['image_url'] + '"></a> \
          <a href="#" class="like like-left"></a> \
        </div> \
        <div class="tour-footer"> \
          <div class="col-sm-5"> \
            <div class="tour-eat"> \
              <span>' + meal(hotels[i]['meal']) + '</span> \
          ' + hotels[i]['depart_date'] + ' на ' + hotels[i]['nights'] + ' ночей \
            </div> \
          </div> \
          <div class="col-sm-7"> \
            <div class="text-right"> \
            <a href="/hotel/' + hotels[i]['id'] + req + ' \
            #comments" class="tour-commentlink"> \
            Отзывы (' + hotels[i]['reviews_count'] + ')</a> \
            </div> \
            <div class="text-right"> \
              <a href="/hotel/' + hotels[i]['id'] + req + '" \
               class="tour-price"> \
                ' + hotels[i]['price'] + '<i class="fa fa-rub"></i> \
              </a> \
            </div> \
          </div> \
        </div> \
      </div> \
    </div>' 
                $('#hotels').append(hotel);
              }
            }


$(document).ready(function(){
	if($('div').is('.tour-filter')){
		var filter = {
			$filter : $('.tour-filter'),
			$filterHeight : $('.tour-filter-height'),
			position : $('.tour-filter').offset().top,
			scrollDocument : function(){
				return $(document).scrollTop();
			},
			show : function(){
				$('.tour-filter--container').stop(true).slideDown(200);
				this.$filterHeight.stop(true).animate({
					'height' : 226
				},200);
				$('.tour-filter--show').stop(true).animate({'opacity' : 0},150);
			},
			hide : function(){
				$('.tour-filter--container').stop(true).slideUp(200);
				this.$filterHeight.stop(true).animate({
					'height' : 42
				},200);
				$('.tour-filter--show').delay(150).stop(true).animate({'opacity' : 1},150);
			},
			scroll : function(){
				this.logicFixed();
			},
			logicFixed : function(){
				if(this.scrollDocument() > this.position - 63){
					if($(window).width()>991){
						this.addFixed();
					}else{
						this.removeFixed();
					}
				}else{
					this.removeFixed();
				}
			},
			addFixed : function(){
				this.$filter.addClass('tour-filter_fixed');
				this.$filterHeight.fadeIn(0);
			},
			removeFixed : function(){
				this.$filterHeight.fadeOut(0);
				this.$filter.removeClass('tour-filter_fixed');
			},
			resize : function(){
				this.logicFixed();
			},
			init : function(){
				this.resize();
			}
		};
		// end filter object
		filter.init();
		$('.tour-filter--hide').click(function(){
			filter.hide();
			return false;
		});
		$('.tour-filter--show').click(function(){
			filter.show();
			return false;
		});
		$(window).on('scroll', function(){
			filter.scroll();
		});
		$(window).on('resize', function(){
			filter.resize();
		});
		var filterPrice = {
			$priceMin : $('.tourFilterPriceMin'),
			$priceMax : $('.tourFilterPriceMax'),
			addSpace : function(str){
				return str.toString().replace(/(\d)(?=(\d\d\d)+([^\d]|$))/g, '$1 ');
			},
			removeSpace : function(str){
				return str.replace(/\s+/g, '');
			},
			setPriceMin : function(){
				var value = '';
				value = this.$priceMin.val();
				if(value==''){
					value = 0;
				}
				return parseFloat(filterPrice.removeSpace(value));
			},
			setPriceMax : function (){
				var value = '';
				value = this.$priceMax.val();
				if(value==''){
					value = 0;
				}
				return parseFloat(filterPrice.removeSpace(value));
			},
			getPrice : function(valueMin, valueMax){
				this.getPriceMin(valueMin);
				this.getPriceMax(valueMax);
			},
			getPriceMin : function (value){
				this.$priceMin.val(this.addSpace(value));
			},
			getPriceMax : function (value){
				this.$priceMax.val(this.addSpace(value));
			},
			inputChange : function (elem){
				if(elem.hasClass('tourFilterPriceMin')){
					var value = filterPrice.setPriceMin();
					filterPrice.getPriceMin(value);
				}
				if(elem.hasClass('tourFilterPriceMax')){
					var value = filterPrice.setPriceMax();
					filterPrice.getPriceMax(value);
				}
			}

		};
		var $filterSlider = $('.tour-filter-price');
		if($('input').is('.tour-filter-price')){
			$filterSlider.ionRangeSlider({
				min: 0,
				max: 15000000,
				from: filterPrice.setPriceMin(),
				to: filterPrice.setPriceMax(),
				type: 'double',
				step: 1000,
				hide_min_max: true,
			    hide_from_to: true,
			    onChange : function(data){
			    	filterPrice.getPrice(data.from, data.to);
			    	setfilterValue();
			    }
		    });
		    var filterSlider = $filterSlider.data("ionRangeSlider");

		    filterPrice.$priceMin.keyup(function(){
		    	filterPrice.inputChange($(this));
				filterSlider.update({
					from: filterPrice.setPriceMin()
				});
			});

			filterPrice.$priceMax.keyup(function(){
		    	filterPrice.inputChange($(this));
				filterSlider.update({
					to: filterPrice.setPriceMax()
				});
			});
			$('.form-tourfilter input').change(function(){
				setfilterValue();
			});
			$('.form-tourfilter input').keyup(function(){
				setfilterValue();
			});
			var filterValue ={};
			function setfilterValue(){
				filterValue = {
					eat1 : '',
					eat2 : '',
					eat3 : '',
					eat4 : '',
					eat5 : '',
					class1 : '',
					class2 : '',
					class3 : '',
					class4 : '',
					priceMin : '',
					priceMax : '',
					beach1 : '',
					beach2 : '',
					beach3 : ''
				}
				$('.form-tourfilter input').each(function(){
					var $elem = $(this);
					var key = $elem.attr('name');
					var value = false;
					if($elem.attr('type')=='checkbox'){
						if($elem.is(':checked')){
							value = true
						}
					}
					if($elem.attr('type')=='text'){
						if(key=='priceMin'){
							value = filterPrice.setPriceMin();
						}else{
							value = filterPrice.setPriceMax();
						}
					}
					filterValue[key] = value;
				});
				console.clear();
				console.log(filterValue);
				var requestId = $('#requestId').val();
			var params = {
	  		"filter": filterValue,
	  		"requestId": requestId
			};
			$.ajax({
			    url: "/filter",
			    data: params,
			    success: function(data){
			      $('#hotels').html('');
			      showHotels(data["hotels"], requestId);
			      $('#total').html('');
			      $('#total').html('Найдено '+ data["total"] + ' отелей');
			      $('.more').html('');
			    }
			    })
			}
		}
	}

});
