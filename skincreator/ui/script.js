$(document).ready(function(){

  // Listen for NUI Events
  window.addEventListener('message', function(event){
    // Open Skin Creator
    
    if(event.data.gender =="M"){
      document.getElementById("gender").className = "M";
      if(event.data.openSkinCreator == true){
        $(".skinCreator").css("display","block");
        $(".hatsMen").css("display","block");
        $(".glassesMens").css("display","block");
        $(".masksMens").css("display","block");
        $(".bagsMens").css("display","block");
        $(".earringsMens").css("display","block");
        $(".topsMens").css("display","block");
        $(".trousersMens").css("display","block");
        $(".shoesMens").css("display","block");
        $(".watchesMens").css("display","block");
        $(".rotation").css("display","block");
		$(".angles").css("display","block");

      }
      // Close Skin Creator
      if(event.data.openSkinCreator == false){
        $(".skinCreator").fadeOut(400);
        $(".hatsMen").fadeOut(400);
        $(".glassesMens").fadeOut(400);
        $(".masksMens").fadeOut(400);
        $(".bagsMens").fadeOut(400);
        $(".earringsMens").fadeOut(400);
        $(".topsMens").fadeOut(400);
        $(".trousersMens").fadeOut(400);
        $(".shoesMens").fadeOut(400);
        $(".watchesMens").fadeOut(400);
        $(".rotation").fadeOut(400);
        $(".angles").fadeOut(400);
      }
    }
    if(event.data.gender =="F"){
      document.getElementById("gender").className = "F";
      if(event.data.openSkinCreator == true){
        $(".skinCreator").css("display","block");
        $(".hatsWoman").css("display","block");
        $(".glassesWomans").css("display","block");
        $(".masksWomans").css("display","block");
        $(".bagsWomans").css("display","block");
        $(".earringsWomans").css("display","block");
        $(".topsWomans").css("display","block");
        $(".trousersWomens").css("display","block");
        $(".shoesWomens").css("display","block");
        $(".watchesWomens").css("display","block");
        $(".rotation").css("display","block");
		$(".angles").css("display","block");
 
      }
      // Close Skin Creator
      if(event.data.openSkinCreator == false){
        $(".skinCreator").fadeOut(400);
        $(".hatsWoman").fadeOut(400);
        $(".glassesWomans").fadeOut(400);
        $(".masksWomans").fadeOut(400);
        $(".bagsWomans").fadeOut(400);
        $(".earringsWomans").fadeOut(400);
        $(".topsWomans").fadeOut(400);
        $(".trousersWomens").fadeOut(400);
        $(".shoesWomens").fadeOut(400);
        $(".watchesWomens").fadeOut(400);
        $(".rotation").fadeOut(400);
        $(".angles").fadeOut(400);
      }
    }
    if (event.data.gender == null && event.data.openSkinCreator == false ){
      $(".skinCreator").fadeOut(400);
      $(".hatsWoman").fadeOut(400);
      $(".glassesWomans").fadeOut(400);
      $(".earringsWomans").fadeOut(400);
      $(".topsWomans").fadeOut(400);
      $(".trousersWomens").fadeOut(400);
      $(".shoesWomens").fadeOut(400);
      $(".watchesWomens").fadeOut(400);
      $(".hatsMen").fadeOut(400);
      $(".glassesMens").fadeOut(400);
      $(".earringsMens").fadeOut(400);
      $(".topsMens").fadeOut(400);
      $(".trousersMens").fadeOut(400);
      $(".shoesMens").fadeOut(400);
      $(".watchesMens").fadeOut(400);
      $(".rotation").fadeOut(400);
	  $(".angles").fadeOut(400);
      $(".masksMens").fadeOut(400);
      $(".bagsMens").fadeOut(400);
      $(".bagsWomens").fadeOut(400);
      $(".masksWomens").fadeOut(400);
  
    }

  });
  
  // Mousemove
 
  
  // Form update
  $('input').change(function(){
    var gender = document.getElementById("gender").className;
    if (gender == "M") {
      $.post('http://skincreator/updateSkin', JSON.stringify({
      value: false,
      // Face
      model: $('.models').val(),
      dad: $('input[name=pere]:checked', '#formSkinCreator').val(),
      mum: $('input[name=mere]:checked', '#formSkinCreator').val(),
      dadmumpercent: $('.morphologie').val(),
      skin: $('input[name=peaucolor]:checked', '#formSkinCreator').val(),
      eyecolor: $('input[name=eyecolor]:checked','#formSkinCreator').val(),
      acne: $('.acne').val(),
      skinproblem: $('.pbpeau').val(),
      freckle: $('.tachesrousseur').val(),
      wrinkle: $('.rides').val(),
      wrinkleopacity: $('.rides').val(),
      hair: $('.hair').val(),
      haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
      eyebrow: $('.sourcils').val(),
      eyebrowopacity: $('.epaisseursourcils').val(),
      beard: $('.barbe').val(),
      beardopacity: $('.epaisseurbarbe').val(),
      beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),
      makeup: $('.makeup').val(),
      makeupThickness: $('.makeupthickness').val(),
      makeupColorOne: $('.makeupcolorone').val(),
      makeupColorTwo: $('.makeupcolortwo').val(),
      lipstick: $('.lipstick').val(),
      lipstickThickness: $('.lipstickthickness').val(),
      lipstickColorOne: $('.lipstickcolorone').val(),
      lipsticklipstickColorTwo: $('.lipstickcolortwo').val(),
      // Clothes
      hats: $('.hatsMen .chapeaux .active').attr('data'),
      glasses: $('.glassesMens .lunettes .active').attr('data'),
      ears: $('.earringsMens .oreilles .active').attr('data'),
      tops: $('.topsMens .hauts .active').attr('data'),
      pants: $('.trousersMens .pantalons .active').attr('data'),
      shoes: $('.shoesMens .chaussures .active').attr('data'),
      watches: $('.watchesMens .montre .active').attr('data'),
      bag: $('.bagsMens .bags .active').attr('data'),
      mask: $('.masksMens .masks .active').attr('data'),
    }));
  }else if(gender == "F") {
    $.post('http://skincreator/updateSkin', JSON.stringify({
    value: false,
    // Face
    model: $('.models').val(),
    dad: $('input[name=pere]:checked', '#formSkinCreator').val(),
    mum: $('input[name=mere]:checked', '#formSkinCreator').val(),
    dadmumpercent: $('.morphologie').val(),
    skin: $('input[name=peaucolor]:checked', '#formSkinCreator').val(),
    eyecolor: $('input[name=eyecolor]:checked','#formSkinCreator').val(),
    acne: $('.acne').val(),
    skinproblem: $('.pbpeau').val(),
    freckle: $('.tachesrousseur').val(),
    wrinkle: $('.rides').val(),
    wrinkleopacity: $('.rides').val(),
    hair: $('.hair').val(),
    haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
    eyebrow: $('.sourcils').val(),
    eyebrowopacity: $('.epaisseursourcils').val(),
    beard: $('.barbe').val(),
    beardopacity: $('.epaisseurbarbe').val(),
    beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),
    makeup: $('.makeup').val(),
    makeupThickness: $('.makeupthickness').val(),
    makeupColorOne: $('.makeupcolorone').val(),
    makeupColorTwo: $('.makeupcolortwo').val(),
    lipstick: $('.lipstick').val(),
    lipstickThickness: $('.lipstickthickness').val(),
    lipstickColorOne: $('.lipstickcolorone').val(),
    lipsticklipstickColorTwo: $('.lipstickcolortwo').val(),
    // Clothes
    hats: $('.hatsWoman .chapeaux .active').attr('data'),
    glasses: $('.glassesWomans .lunettes .active').attr('data'),
    ears: $('.earringsWomans .oreilles .active').attr('data'),
    tops: $('.topsWomans .hauts .active').attr('data'),
    pants: $('.trousersWomens .pantalons .active').attr('data'),
    shoes: $('.shoesWomens .chaussures .active').attr('data'),
    watches: $('.watchesWomens .montre .active').attr('data'),
    bag: $('.bagsWomans .bags .active').attr('data'),
    mask: $('.masksWomans .masks .active').attr('data'),
  }));
}

});
$('.arrow').on('click', function(e){
  e.preventDefault();
  var gender = document.getElementById("gender").className;
  if (gender == "M") {
    $.post('http://skincreator/updateSkin', JSON.stringify({
    value: false,
    // Face
    model: $('.models').val(),
    dad: $('input[name=pere]:checked', '#formSkinCreator').val(),
    mum: $('input[name=mere]:checked', '#formSkinCreator').val(),
    dadmumpercent: $('.morphologie').val(),
    skin: $('input[name=peaucolor]:checked', '#formSkinCreator').val(),
    eyecolor: $('input[name=eyecolor]:checked','#formSkinCreator').val(),
    acne: $('.acne').val(),
    skinproblem: $('.pbpeau').val(),
    freckle: $('.tachesrousseur').val(),
    wrinkle: $('.rides').val(),
    wrinkleopacity: $('.rides').val(),
    hair: $('.hair').val(),
    haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
    eyebrow: $('.sourcils').val(),
    eyebrowopacity: $('.epaisseursourcils').val(),
    beard: $('.barbe').val(),
    beardopacity: $('.epaisseurbarbe').val(),
    beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),
    makeup: $('.makeup').val(),
    makeupThickness: $('.makeupthickness').val(),
    makeupColorOne: $('.makeupcolorone').val(),
    makeupColorTwo: $('.makeupcolortwo').val(),
    lipstick: $('.lipstick').val(),
    lipstickThickness: $('.lipstickthickness').val(),
    lipstickColorOne: $('.lipstickcolorone').val(),
    lipsticklipstickColorTwo: $('.lipstickcolortwo').val(),
    // Clothes
    hats: $('.hatsMen .chapeaux .active').attr('data'),
    glasses: $('.glassesMens .lunettes .active').attr('data'),
    ears: $('.earringsMens .oreilles .active').attr('data'),
    tops: $('.topsMens .hauts .active').attr('data'),
    pants: $('.trousersMens .pantalons .active').attr('data'),
    shoes: $('.shoesMens .chaussures .active').attr('data'),
    watches: $('.watchesMens .montre .active').attr('data'),
    bag: $('.bagsMens .bags .active').attr('data'),
    mask: $('.masksMens .masks .active').attr('data'),
  }));
}else if(gender == "F") {
  $.post('http://skincreator/updateSkin', JSON.stringify({
  value: false,
  // Face
  model: $('.models').val(),
  dad: $('input[name=pere]:checked', '#formSkinCreator').val(),
  mum: $('input[name=mere]:checked', '#formSkinCreator').val(),
  dadmumpercent: $('.morphologie').val(),
  skin: $('input[name=peaucolor]:checked', '#formSkinCreator').val(),
  eyecolor: $('input[name=eyecolor]:checked','#formSkinCreator').val(),
  acne: $('.acne').val(),
  skinproblem: $('.pbpeau').val(),
  freckle: $('.tachesrousseur').val(),
  wrinkle: $('.rides').val(),
  wrinkleopacity: $('.rides').val(),
  hair: $('.hair').val(),
  haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
  eyebrow: $('.sourcils').val(),
  eyebrowopacity: $('.epaisseursourcils').val(),
  beard: $('.barbe').val(),
  beardopacity: $('.epaisseurbarbe').val(),
  beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),
  makeup: $('.makeup').val(),
  makeupThickness: $('.makeupthickness').val(),
  makeupColorOne: $('.makeupcolorone').val(),
  makeupColorTwo: $('.makeupcolortwo').val(),
  lipstick: $('.lipstick').val(),
  lipstickThickness: $('.lipstickthickness').val(),
  lipstickColorOne: $('.lipstickcolorone').val(),
  lipsticklipstickColorTwo: $('.lipstickcolortwo').val(),
  // Clothes
  hats: $('.hatsWoman .chapeaux .active').attr('data'),
  glasses: $('.glassesWomans .lunettes .active').attr('data'),
  ears: $('.earringsWomans .oreilles .active').attr('data'),
  tops: $('.topsWomans .hauts .active').attr('data'),
  pants: $('.trousersWomens .pantalons .active').attr('data'),
  shoes: $('.shoesWomens .chaussures .active').attr('data'),
  watches: $('.watchesWomens .montre .active').attr('data'),
  bag: $('.bagsWomans .bags .active').attr('data'),
  mask: $('.masksWomans .masks .active').attr('data'),
}));
}
});

// Form submited
$('.yes').on('click', function(e){
  e.preventDefault();
  var gender = document.getElementById("gender").className;
  if (gender == "M") {
    $.post('http://skincreator/updateSkin', JSON.stringify({
    value: true,
    // Face
    model: $('.models').val(),
    dad: $('input[name=pere]:checked', '#formSkinCreator').val(),
    mum: $('input[name=mere]:checked', '#formSkinCreator').val(),
    dadmumpercent: $('.morphologie').val(),
    skin: $('input[name=peaucolor]:checked', '#formSkinCreator').val(),
    eyecolor: $('input[name=eyecolor]:checked','#formSkinCreator').val(),
    acne: $('.acne').val(),
    skinproblem: $('.pbpeau').val(),
    freckle: $('.tachesrousseur').val(),
    wrinkle: $('.rides').val(),
    wrinkleopacity: $('.rides').val(),
    hair: $('.hair').val(),
    haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
    eyebrow: $('.sourcils').val(),
    eyebrowopacity: $('.epaisseursourcils').val(),
    beard: $('.barbe').val(),
    beardopacity: $('.epaisseurbarbe').val(),
    beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),
    makeup: $('.makeup').val(),
    makeupThickness: $('.makeupthickness').val(),
    makeupColorOne: $('.makeupcolorone').val(),
    makeupColorTwo: $('.makeupcolortwo').val(),
    lipstick: $('.lipstick').val(),
    lipstickThickness: $('.lipstickthickness').val(),
    lipstickColorOne: $('.lipstickcolorone').val(),
    lipsticklipstickColorTwo: $('.lipstickcolortwo').val(),
    // Clothes
    hats: $('.hatsMen .chapeaux .active').attr('data'),
    glasses: $('.glassesMens .lunettes .active').attr('data'),
    ears: $('.earringsMens .oreilles .active').attr('data'),
    tops: $('.topsMens .hauts .active').attr('data'),
    pants: $('.trousersMens .pantalons .active').attr('data'),
    shoes: $('.shoesMens .chaussures .active').attr('data'),
    watches: $('.watchesMens .montre .active').attr('data'),
    bag: $('.bagsMens .bags .active').attr('data'),
    mask: $('.masksMens .masks .active').attr('data'),
  }));
}else if(gender == "F") {
  $.post('http://skincreator/updateSkin', JSON.stringify({
  value: true,
  // Face
  model: $('.models').val(),
  dad: $('input[name=pere]:checked', '#formSkinCreator').val(),
  mum: $('input[name=mere]:checked', '#formSkinCreator').val(),
  dadmumpercent: $('.morphologie').val(),
  skin: $('input[name=peaucolor]:checked', '#formSkinCreator').val(),
  eyecolor: $('input[name=eyecolor]:checked','#formSkinCreator').val(),
  acne: $('.acne').val(),
  skinproblem: $('.pbpeau').val(),
  freckle: $('.tachesrousseur').val(),
  wrinkle: $('.rides').val(),
  wrinkleopacity: $('.rides').val(),
  hair: $('.hair').val(),
  haircolor: $('input[name=haircolor]:checked', '#formSkinCreator').val(),
  eyebrow: $('.sourcils').val(),
  eyebrowopacity: $('.epaisseursourcils').val(),
  beard: $('.barbe').val(),
  beardopacity: $('.epaisseurbarbe').val(),
  beardcolor: $('input[name=barbecolor]:checked', '#formSkinCreator').val(),
  makeup: $('.makeup').val(),
  makeupThickness: $('.makeupthickness').val(),
  makeupColorOne: $('.makeupcolorone').val(),
  makeupColorTwo: $('.makeupcolortwo').val(),
  lipstick: $('.lipstick').val(),
  lipstickThickness: $('.lipstickthickness').val(),
  lipstickColorOne: $('.lipstickcolorone').val(),
  lipsticklipstickColorTwo: $('.lipstickcolortwo').val(),
  // Clothes
  hats: $('.hatsWoman .chapeaux .active').attr('data'),
  glasses: $('.glassesWomans .lunettes .active').attr('data'),
  ears: $('.earringsWomans .oreilles .active').attr('data'),
  tops: $('.topsWomans .hauts .active').attr('data'),
  pants: $('.trousersWomens .pantalons .active').attr('data'),
  shoes: $('.shoesWomens .chaussures .active').attr('data'),
  watches: $('.watchesWomens .montre .active').attr('data'),
  bag: $('.bagsWomans .bags .active').attr('data'),
  mask: $('.masksWomans .masks .active').attr('data'),
}));
}
}); 

document.onkeydown = function(data){ 
    if(data.which == 65 || (data.which == 65 && data.repeat)){ //A
       $.post('http://skincreator/rotaterightheading', JSON.stringify({
       value: 10
    }));
  }		
    if(data.which == 68 || (data.which == 68 && data.repeat)) { //D 
       $.post('http://skincreator/rotateleftheading', JSON.stringify({
       value: 10
    }));
   }
}

$(".DefaultCam").click(function(){
    $.post('http://skincreator/DefaultCam', JSON.stringify({}));
});
$(".HeadCam").click(function(){
    $.post('http://skincreator/HeadCam', JSON.stringify({}));
});
$(".WaistCam").click(function(){
    $.post('http://skincreator/WaistCam', JSON.stringify({}));
});
$(".FeetCam").click(function(){
    $.post('http://skincreator/FeetCam', JSON.stringify({}));
});


// Zoom out camera for clothes
$('.tab a').on('click', function(e){
  e.preventDefault();
  $.post('http://skincreator/zoom', JSON.stringify({
  zoom: $(this).attr('data-link')
}));
});

// Test value
var xTriggered = 0;
$(document).keypress(function(e){
  e.preventDefault();
  xTriggered++;
  if(e.which == 13){
    $.post('http://skincreator/test', JSON.stringify({
    value: xTriggered
  }));
}
});
});
