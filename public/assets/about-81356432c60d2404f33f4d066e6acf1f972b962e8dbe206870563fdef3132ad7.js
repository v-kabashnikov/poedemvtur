$(document).ready(function(){
  $('.questions').first().fadeIn(0);
  $('.categories a').click(function(){
    if(!$(this).hasClass('active')){
      
    $('.categories a.active').removeClass('active')
    $(this).addClass('active');
    $('.questions').filter(':visible').fadeOut(0);
      $('.questions').eq($(this).index()).fadeIn(50);
      
    }
    return false;
  });
});
