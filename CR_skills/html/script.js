var documentWidth = document.documentElement.clientWidth;
var documentHeight = document.documentElement.clientHeight;


function Click(x, y) {
    var element = $(document.elementFromPoint(x, y));
    element.focus().click();
}

function round(value, precision) {
    if (Number.isInteger(precision)) {
      var shift = Math.pow(10, precision);
      return Math.round(value * shift) / shift;
    } else {
      return Math.round(value);
    }
  } 

$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
           
            document.body.style.display = event.data.enable ? "block" : "none";
			
            var roadworks_elem = document.getElementById("roadworksBar"); 
            var roadworks_elem_info = document.getElementById("roadworksInfo"); 
			
            var landscaping_elem = document.getElementById("landscapingBar"); 			
            var landscaping_elem_info = document.getElementById("landscapingInfo"); 
			
            // var weed_elem = document.getElementById("weedBar"); 
            // var weed_elem_info = document.getElementById("weedInfo");
			
            var auspost_elem = document.getElementById("auspostBar"); 
            var auspost_elem_info = document.getElementById("auspostInfo"); 
			
            var fighting_elem = document.getElementById("fightingBar"); 
            var fighting_elem_info = document.getElementById("fightingInfo"); 
			
            var stamina_elem = document.getElementById("staminaBar"); 
            var stamina_elem_info = document.getElementById("staminaInfo"); 
			
            var width = 10;
            var id = setInterval(roadworksFrame, 10);
            var id2 = setInterval(landscapingFrame, 10);
            // var id3 = setInterval(weedFrame, 10);
            var id4 = setInterval(auspostFrame, 10);
            var id5 = setInterval(fightingFrame, 10);
            var id6 = setInterval(staminaFrame, 10);
			
            function auspostFrame() {
                if (width >= event.data.auspost) {
                    clearInterval(id4);
                    auspost_elem_info.innerHTML = round(event.data.auspost, 2) + '%';
                } else {
                    width++; 
                    if (event.data.auspost > 100) {
                        auspost_elem.style.width = 100 + '%'; 
                        auspost_elem_info.value = width + '%';
                    } else {
                        auspost_elem.style.width = width + '%'; 
                        auspost_elem_info.value = width + '%';
                    }
                }
            }
			
            // function weedFrame() {
            //     if (width >= event.data.weed) {
            //         clearInterval(id3);
            //         weed_elem_info.innerHTML = round(event.data.weed, 2) + '%';
            //     } else {
            //         width++; 
            //         weed_elem.style.width = width + '%'; 
            //         weed_elem_info.value = width + '%';
            //     }
            // }
			
            function roadworksFrame() {
                if (width >= event.data.roadworks) {
                    clearInterval(id);
                    roadworks_elem_info.innerHTML = round(event.data.roadworks, 2) + '%';
                } else {
                    width++; 
                    if (event.data.roadworks > 100) {
                        roadworks_elem.style.width = 100 + '%'; 
                        roadworks_elem_info.value = width + '%';
                    } else {
                        roadworks_elem.style.width = width + '%'; 
                        roadworks_elem_info.value = width + '%';
                    }
                }
            }
			
            function landscapingFrame() {
                if (width >= event.data.landscaping) {
                    clearInterval(id2);
                    landscaping_elem_info.innerHTML = round(event.data.landscaping, 2) + '%';
                } else {
                    width++; 
                    if (event.data.landscaping > 100) {
                        landscaping_elem.style.width = 100 + '%'; 
                        landscaping_elem_info.value = width + '%';
                    } else {
                        landscaping_elem.style.width = width + '%'; 
                        landscaping_elem_info.value = width + '%';
                    }
                }
            }
			
            function fightingFrame() {
                if (width >= event.data.fighting) {
                    clearInterval(id5);
                    fighting_elem_info.innerHTML = round(event.data.fighting, 2) + '%';
                } else {
                    width++; 
                    if (event.data.fighting > 100) {
                        fighting_elem.style.width = 100 + '%'; 
                        fighting_elem_info.value = width + '%';
                    } else {
                        fighting_elem.style.width = width + '%'; 
                        fighting_elem_info.value = width + '%';
                    }
                }
            }
			
            function staminaFrame() {
                if (width >= event.data.stamina) {
                    clearInterval(id6);
                    stamina_elem_info.innerHTML = round(event.data.stamina, 2) + '%';
                } else {
                    width++; 
                    if (event.data.stamina > 100) {
                        stamina_elem.style.width = 100 + '%'; 
                        stamina_elem_info.value = width + '%';
                    } else {
                        stamina_elem.style.width = width + '%'; 
                        stamina_elem_info.value = width + '%';
                    }
                }
            }
			
			
        } else if (event.data.type == "click") {
            Click(cursorX - 1, cursorY - 1);
        }
    });

	
	$(".close").click(function(){
    $.post('http://CR_skills/quit', JSON.stringify({}));
});

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://CR_skills/quit', JSON.stringify({}));
        }
    };
});
