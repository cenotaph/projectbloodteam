//= require jquery
//= require jquery_ujs
//= require jquery-ui/widgets/datepicker
//= require jquery-ui/widgets/autocomplete
//= require autocomplete-rails
//= require foundation
//= require jquery.infinitescroll
//= require readmore.min
//= require slick.min
//= require slick-lightbox
//= require jquery.clearfield
//= require jquery_nested_form
//= require punymce/puny_mce
//= require markerclusterer

$(function(){ $(document).foundation(); 

  $('li.has-dropdown').each(function(){
    link=($(this)[0].children[0].outerHTML);
    ul=$(this).find($('ul'))
    ul.children().children().first().parent().before('<li class="parentlink show-for-small-only">'+link+'</li>')
  });
  
});


$(function(){ $(document).foundation(); });
