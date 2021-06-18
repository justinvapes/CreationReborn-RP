var documentWidth = document.documentElement.clientWidth;
var documentHeight = document.documentElement.clientHeight;

jQuery(document).ready(function($) {
	$('.form-element').keyup(function(event) {
	  var textBox = event.target;
	  var start = textBox.selectionStart;
	  var end = textBox.selectionEnd;
	  textBox.value = textBox.value.charAt(0).toUpperCase() + textBox.value.slice(1);
	  textBox.setSelectionRange(start, end);
	});
  });


$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type == "enableui") {
            document.body.style.display = event.data.enable ? "block" : "none";
			
			
        }else if(event.data.type == "nameTaken" && event.data.type){

			document.getElementById("failed").innerHTML = "Name Taken";                   
		
		}else if(event.data.type == "capitalLetter" && event.data.type){

            document.getElementById('capital-letter').style.display = "block"
            
            setTimeout(function () {
                document.getElementById('capital-letter').style.display = "none"    
            }, 3000);          
     	

        }else if(event.data.type == "namesize" && event.data.type){

            document.getElementById('name-size').style.display = "block"
            
            setTimeout(function () {
                document.getElementById('name-size').style.display = "none"    
            }, 3000);          
          }  		  
      });

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            $.post('http://esx_identity/escape', JSON.stringify({}));
        }
    };
    
    // $("#register").submit(function(e) {
    //     e.preventDefault(); // Prevent form from submitting

    //     var input = escapeHtml($("#dateofbirth").val());
    //     var _date = new Date(input);
    //     var day = _date.getDate();
        
    //     if(day < 10) {
    //         day = "0"+day;
    //     }
    //     day = day.toString();

    //     var month = _date.getMonth() + 1; 

    //     if(month < 10){
    //         month = '0'+month;
    //     }
    //     month = month.toString();

    //     var year = _date.getFullYear().toString();

    //     _date =  day + "/" + month + "/" + year;
    //     console.log('dob: ' + _date)
    //     $.post('http://esx_identity/register', JSON.stringify({
    //         firstname: escapeHtml($("#firstname").val()),
    //         lastname: escapeHtml($("#lastname").val()),
    //         dateofbirth: _date,
    //         sex: escapeHtml($(".sex:checked").val()),
    //         height: escapeHtml($("#height").val())
    //     }));
	// });

    $("#register").submit(function(event) {
		event.preventDefault(); // Prevent form from submitting
		var allowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-";
        var regex = new RegExp("^[" + allowedCharacters + "]*$");
		var day = $("#day").val();
		var month = $("#month").val();
		var year = $("#year").val();
		var height = $("#height").val();
        var date = day + "-" + month + "-" + year;
        console.log($("input[type='radio'][name='sex']:checked").val())
		if (day < 1 || day > 31) {
			document.getElementById("failed").innerHTML = "Day must be between 1-31 Got: " + day;
			return;
		} else if (month < 1 || month > 12) {
			document.getElementById("failed").innerHTML = "Month must be between 1-12 Got: " + month;
			return;
		} else if (year < 1900 || year > 2020) {
			document.getElementById("failed").innerHTML = "Year must be between 1900-2020 Got: " + year;
			return;
		} else if (height < 140 || height > 200) {
			document.getElementById("failed").innerHTML = "Height must be between 140-200 Got: " + height;
			return;
		} else if (regex.test($("#firstname").val()) == false) {
			document.getElementById("failed").innerHTML = "Invalid characters in Firstname";
			return;
		} else if (regex.test($("#lastname").val()) == false) {
			document.getElementById("failed").innerHTML = "Invalid characters in Lastname";
			return;
		}
		var date = day + "-" + month + "-" + year;
		$.post('http://esx_identity/register', JSON.stringify({
			firstname: $("#firstname").val(),
			lastname: $("#lastname").val(),
			dateofbirth: date,
			sex: $("input[type='radio'][name='sex']:checked").val(),
			height: $("#height").val()
		}));
});

function escapeHtml(unsafe) {
    return unsafe
    .replace(/&/g, "")
    .replace(/</g, "")
    .replace(/>/g, "")
    .replace(/"/g, "")
    .replace(/'/g, "");
}
});