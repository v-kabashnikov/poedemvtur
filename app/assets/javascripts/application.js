// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery.min.js
//= require jquery_ujs



$(document).ready(function () {
    // when the load more link is clicked
    $('a.load-more').click(function (e) {

        // prevent the default click action
        e.preventDefault();

        // hide load more link
        $('.load-more').hide();

        // show loading gif
        $('.loading-gif').show();

        // get the last id and save it in a variable 'last-id'
        var last_id = $('.record').last().attr('data-id');

        // make an ajax call passing along our last user id
        $.ajax({

            // make a get request to the server
            type: "GET",
            // get the url from the href attribute of our link
            url: $(this).attr('href'),
            // send the last id to our rails app
            data: {
                id: last_id
            },
            // the response will be a script
            dataType: "script",

            // upon success 
            success: function () {
                // hide the loading gif
                $('.loading-gif').hide();
                // show our load more link
                $('.load-more').show();
            }
        });

    });
});



$(document).ready(function() {
 $('#place1').on('keyup', function() {
$( "#data" ).html('');
   $.get('/ajax?p='+ $(this).val(), function( data ) {
   $.each(data, function( index, value ) {
     $.each(value, function (index, data) {
       $('<li data-id='+data.id+' data-type='+data.type+'><div class="roundtour-place--info"><h4 class="roundtour-place--curort">'+ data.name +'</h4> \
    <span class="roundtour-place--country">'+ data.country +'</span></div> \
        <div class="roundtour-place--img"></div> \
        </li>').appendTo( "#data" );
    });
     
});
});
  });
 
});