$(".character-box").hover(
    function() {
        $(this).css({
            "background": "rgb(255, 255, 255)",
            "transition": "200ms",
        });
    }, function() {
        $(this).css({
            "background": "rgba(255, 255, 255, 1.0)",
            "transition": "200ms",          
        });
    }
);

$(".character-box").click(function () {
    $(".character-box").removeClass('active-char');
    $(this).addClass('active-char');
    if ($(this).attr("data-charid") === "1") {
        $(".character-buttons").css({"display":"block"});
        $(".btn-play").css({"margin-left":"10%"});
    }else if ($(this).attr("data-charid") === "2") {
        $(".character-buttons").css({"display":"block"});
        $(".btn-play").css({"margin-left":"31.5%"});
    }else if ($(this).attr("data-charid") === "3") {
        $(".character-buttons").css({"display":"block"});
        $(".btn-play").css({"margin-left":"53%"});
    }else if ($(this).attr("data-charid") === "4") {
        $(".character-buttons").css({"display":"block"});
        $(".btn-play").css({"margin-left":"74.2%"});
    }
    // $(".character-buttons").css({"display":"block"});

    if ($(this).attr("data-ischar") === "true") {
        $("#delete").css({"display":"block"});
    } else {
        $("#delete").css({"display":"none"});
    }
});

$("#play-char").click(function () {
    $.post("http://esx_kashacters/CharacterChosen", JSON.stringify({
        charid: Number($('.active-char').attr("data-charid")),
        ischar: ($('.active-char').attr("data-ischar") == "true"),
    }));
});

$("#deletechar").click(function () {
    $.post("http://esx_kashacters/DeleteCharacter", JSON.stringify({
        charid: Number($('.active-char').attr("data-charid")),
    }));
});

window.addEventListener('message', function(event) {
  if (event.data.type == "Refresh") {
      Kashacter.CloseUI();	
     }
});
window.addEventListener('message', function(event) {
  if (event.data.type == "member") {
      document.getElementById('member').style.display = "block"
            
      setTimeout(function () {
      document.getElementById('member').style.display = "none"    
      }, 3000);	
     }
});


(() => {
    Kashacter = {};

    Kashacter.ShowUI = function(data) {
        $('.main-container').css({"display":"block"});
        $('.bg').css({"display":"block"});
        if(data.characters !== null) {
            $.each(data.characters, function (index, char) {
                if (char.charid !== 0) {
                    var charid = char.identifier.charAt(4);
                    $('[data-charid=' + charid + ']').html('<h3 class="character-fullname">'+ char.firstname +' '+ char.lastname +'</h3><div class="character-info"> <p class="character-info-gender"><strong>Gender: </strong><span>'+ char.sex +'</span></p> <p class="character-info-dateofbirth"><strong>D.O.B: </strong><span>'+ char.dateofbirth +'</span></p> <p class="character-info-work"><strong>Occupation: </strong><span>'+ char.job +'</span></p><p class="character-info-money"><strong>Money: </strong><span>'+'$'+ char.money + '</span></p><p class="character-info-bank"><strong>Bank: </strong><span>'+'$'+ char.bank +'</span></p> <p class="character-info-phone-number"><strong>Phone Number: </strong><span>'+ char.phone_number +'</span></p> <p class="character-info-health"><strong>Health: </strong><span>'+ char.health +'</span></p> <p class="character-info-health"><strong>In Jail: </strong><span>'+ char.InJail +'</span></p> <p class="character-info-health"><strong>In Hospital: </strong><span>'+ char.InHospital +'</span></p></div>').attr("data-ischar", "true");
                }
            });
        }
    };

    Kashacter.CloseUI = function() {
        $('.main-container').css({"display":"none"});
        $('.BG').css({"display":"none"});
        $(".character-box").removeClass('active-char');
        $("#delete").css({"display":"none"});
		$(".character-box").html('<h3 class="character-fullname"><i class="fas fa-plus"></i></h3><div class="character-info"><p class="character-info-new">Create A New Character</p></div>').attr("data-ischar", "false");
    };
    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case 'openui':
                    Kashacter.ShowUI(event.data);
                    break;
            }
        })
    }

})();