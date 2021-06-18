
window.addEventListener('message', function(e) {
	$("#container").stop(false, true);
    if (e.data.displayWindow == 'true') {
        $("#container").css('display', 'flex');
  		
        $("#container").animate({
        	opacity: "1.0"
        	},
        	700, function() {

        });

    } else {
    	$("#container").animate({
        	opacity: "0.0"
        	},
        	700, function() {
        		$("#container").css('display', 'none');
	         	
        });
    }
});

