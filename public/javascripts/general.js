jQuery(document).ready(function() {
// Drop downs
jQuery('#nav > ul li ul').mouseover(function(){
	jQuery(this).parent().addClass('current_page_item');
});
jQuery('#nav > ul li ul').mouseleave(function(){
	jQuery(this).parent().removeClass('current_page_item');
});
	
});