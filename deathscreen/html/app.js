
    window.onData = function(data) {
    	if (data.setDisplay == true) 
		{
            $("body").css('background', '#131313bd');
            $("#container").css('display', 'flex');
    	} 
		else if (data.setDisplayHospital == true) {
            $("body").css('background', 'transparent');
            $("#container").css('display', 'flex');
    	}
		else  
		{
            $('*').css('background', 'transparent');
            $("#container").css('display', 'none');
    	}   	
    }
	
    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            onData(event.data)
        });
    }