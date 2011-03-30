$(function (){
	// validate
	$(".validate").each(function(){
		$(this).validate();
	});
	
	// ajax
	$(".ajax").click(function(){
		$.get($(this).attr("href"), null, null, "script");
		return false;
	});
});

var csrf_token = $('meta[name=csrf-token]').attr('content'),
    csrf_param = $('meta[name=csrf-param]').attr('content');
