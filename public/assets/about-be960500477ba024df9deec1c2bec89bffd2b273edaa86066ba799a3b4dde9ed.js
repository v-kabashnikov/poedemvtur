$(document).ready(function(){
 
 var $comment = $('#about-comments .comment');
  $comment.each(function(){
    if($(this).index()<=4){
      $(this).css({'display': 'block !important'})
    }
  });
  $('.more-link').click(function(){
    $comment.filter(':hidden').each(function(){
       $(this).css({'display': 'block !important'})
    })
    return false;
  });
  
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
