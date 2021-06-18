function clamp(num, min, max) {
	return num <= min ? min : num >= max ? max : num;
  }
  
$(function() {
	
	var s_playerID;
	var s_rpm;
	var s_speed;
	var s_gear;
	var s_IL;
	var s_Handbrake;
	var s_LS_r;
	var s_LS_o;
	var s_LS_h;
	var calcSpeed;
	var speedText = '';
	var inVehicle = false;
	var s_Fuel;
	var vehicleLights = document.querySelector('.headlights');
	var vehicleFuel = document.querySelector('.fuel');
	bounce = 0;
	
    window.addEventListener("message", function(event) {
        var item = event.data;
        
        if (item.ShowHud) {
			
			inVehicle   = true;
			s_PlayerID  = item.PlayerID;
			s_Rpm       = item.CurrentCarRPM;
			s_Speed     = item.CurrentCarSpeed;
			s_Kmh       = item.CurrentCarKmh;
			s_Mph       = item.CurrentCarMph;
			s_Gear      = item.CurrentCarGear;
			s_IL        = item.CurrentCarIL;
			s_Handbrake = item.CurrentCarHandbrake;
			s_Brake     = item.CurrentCarBrake;
			s_LS_r      = item.CurrentCarLS_r;
			s_LS_o      = item.CurrentCarLS_o;
			s_LS_h      = item.CurrentCarLS_h;
			s_Fuel      = item.CurrentCarFuel;
			s_Traction  = item.CurrentCarTraction;
			KMs         = item.CurrentCarKM;
			s_Engine    = item.CurrentCarEngine;
			CalcFuel    = (s_Fuel / 50);
			CalcSpeed   = s_Kmh;
			CalcRpm     = (s_Rpm - 0.11);
			CalcRpm     = (9500 * CalcRpm);
			CalcRpm     = (CalcRpm / 1000);
			// CalcRpm     = (s_Rpm * 9.5);
			
			if(CalcSpeed > 999) {
				CalcSpeed = 999;
			}
			// Redline calculator
			if(CalcRpm.toFixed(4) < 7.5) {
			 	$("#rpmshow").attr("data-color-bar", "rgba(255,255,255,0.3");
			} else {
				 $("#rpmshow").attr("data-color-bar", "rgba(255,0,0,0.3");
			}
			// Idle/Limiter
            if(CalcRpm.toFixed(4) == 8.455 && bounce <= 0) {
                bounce = 0.3;
            } 
            else if (CalcRpm.toFixed(4) <= 0.86 && bounce >= 0) {
                // CalcRpm = (CalcRpm - 0.5)
                bounce = -0.05;
            }
            else if (bounce > 0) {
                bounce = clamp(bounce - 0.03, 0, 1);
            }
            else if (bounce < 0) {
                // CalcRpm = (CalcRpm - 0.5)
                bounce = clamp(bounce + 0.03, -1, 0);
            }

			if(s_Engine == true) {
				finRpm = CalcRpm - bounce;
			} else {
				finRpm = 0
			}
			
			// Vehicle RPM display
			$("#rpmshow").attr("data-value", finRpm.toFixed(4));

			// Vehicle Gear display
			if((s_Gear == 0 && CalcSpeed == 0) || (s_Gear == 1 && CalcSpeed == 0)) {
				$(".geardisplay span").html("N");
				$(".geardisplay").attr("style", "color: #FFF;border-color:#FFF;");
			} else if (s_Gear == 0 && CalcSpeed > 0) {
				$(".geardisplay span").html("R");
				$(".geardisplay").attr("style", "color: #000;border-color:#FFF;");

			} else {
				$(".geardisplay span").html(s_Gear);
				if(CalcRpm > 8.5) {
					$(".geardisplay").attr("style", "color: rgba(255,0,0,0.6);border-color:rgba(255,0,0,0.6);");
				} else {
					$(".geardisplay").removeAttr("style");
				}
			}
			
			// Vehicle KM display
			
			if (KMs > 0.01) {
				 KMs = KMs.toFixed(0)
				var digits = (""+KMs).split("");
				if (digits.length > 5) {
					$(".mileagecont").css({"display":"block"});
					$("#mileage1 span").html(digits[0]);
					$("#mileage2 span").html(digits[1]);
					$("#mileage4 span").html(digits[3]);
					$("#mileage3 span").html(digits[2]);
					$("#mileage5 span").html(digits[4]);
					$("#mileage6 span").html(digits[5]);
				} else if (digits.length > 4) {
					$(".mileagecont").css({"display":"block"});
					$("#mileage1 span").html('0');
					$("#mileage2 span").html(digits[0]);
					$("#mileage3 span").html(digits[1]);
					$("#mileage4 span").html(digits[2]);
					$("#mileage5 span").html(digits[3]);
					$("#mileage6 span").html(digits[4]);
				} else if (digits.length > 3) {
					$(".mileagecont").css({"display":"block"});
					$("#mileage1 span").html('0');
					$("#mileage2 span").html('0');
					$("#mileage3 span").html(digits[0]);
					$("#mileage4 span").html(digits[1]);
					$("#mileage5 span").html(digits[2]);
					$("#mileage6 span").html(digits[3]);
				} else if (digits.length > 2) {
					$(".mileagecont").css({"display":"block"});
					$("#mileage1 span").html('0');
					$("#mileage2 span").html('0');
					$("#mileage3 span").html('0');
					$("#mileage4 span").html(digits[0]);
					$("#mileage5 span").html(digits[1]);
					$("#mileage6 span").html(digits[2]);
				} else if (digits.length > 1) {
					$(".mileagecont").css({"display":"block"});
					$("#mileage1 span").html('0');
					$("#mileage2 span").html('0');
					$("#mileage3 span").html('0');
					$("#mileage4 span").html('0');
					$("#mileage5 span").html(digits[0]);
					$("#mileage6 span").html(digits[1]);
				} else if (digits.length > 0) {
					$(".mileagecont").css({"display":"block"});
					$("#mileage1 span").html('0');
					$("#mileage2 span").html('0');
					$("#mileage3 span").html('0');
					$("#mileage4 span").html('0');
					$("#mileage5 span").html('0');
					$("#mileage6 span").html(digits);
				} else if (digits.length == 0) {
					$(".mileagecont").css({"display":"none"});
					$("#mileage1 span").html('0');
					$("#mileage2 span").html('0');
					$("#mileage3 span").html('0');
					$("#mileage4 span").html('0');
					$("#mileage5 span").html('0');
					$("#mileage6 span").html('0');
				}
			} else {
				$(".mileagecont").css({"display":"none"});
			};


			// Vehicle speed display
			if(CalcSpeed >= 100) {
				var tmpSpeed = Math.floor(CalcSpeed) + '';
				speedText = '<span class="int1">' + tmpSpeed.substr(0, 1) + '</span><span class="int2">' + tmpSpeed.substr(1, 1) + '</span><span class="int3">' + tmpSpeed.substr(2, 1) + '</span>';
			} else if(CalcSpeed >= 10 && CalcSpeed < 100) {
				var tmpSpeed = Math.floor(CalcSpeed) + '';
				speedText = '<span class="gray int1">0</span><span class="int2">' + tmpSpeed.substr(0, 1) + '</span><span class="int3">' + tmpSpeed.substr(1, 1) + '</span>';
			} else if(CalcSpeed > 0 && CalcSpeed < 10) {
				speedText = '<span class="gray int1">0</span><span class="gray int2">0</span><span class="int3">' + Math.floor(CalcSpeed) + '</span>';
			} else {
				speedText = '<span class="gray int1">0</span><span class="gray int2">0</span><span class="gray int3">0</span>';
			};
			
			// Handbrake
			if(s_Handbrake) {
				$(".handbrake").html("HBK");
				$(".handbrake").attr("style", "color:rgba(255,100,0,1);");
				$(".handbrakecont").attr("style", "border-color:rgba(255,100,0,1);");
			} else {
				$(".handbrake").html('<span class="gray">HBK</span>');
				$(".handbrake").removeAttr("style");
				$(".handbrakecont").removeAttr("style");
			}

			// Traction Control
			if(s_Traction) {
				$(".tcs").html("TCS");
				$(".tcs").attr("style", "color:rgba(255,225,0,1);");
				$(".tcscont").attr("style", "border-color:rgba(255,225,0,1);");
			} else {
				$(".tcs").html('<span class="gray">TCS</span>');
				$(".tcs").removeAttr("style");
				$(".tcscont").removeAttr("style");
			}
			
			// Brake ABS
			if(s_Brake > 0) {
				$(".abs").html("ABS");
				$(".abs").attr("style", "color:rgba(255,0,0,1);");
				$(".abscont").attr("style", "border-color:rgba(255,0,0,1);");
			} else {
				$(".abs").html('<span class="gray">ABS</span>');
				$(".abs").removeAttr("style");
				$(".abscont").removeAttr("style");
			}
			// Display speed and container
			$(".speeddisplay").html(speedText);
			$("#container").fadeIn(500);

			// Headlights
			if (s_LS_r == 1 && s_LS_h == 0 && s_LS_o == 1) {
				// normal
				vehicleLights.querySelector('i img').src = 'img/vehicle-lights.png'; 
				$(".headlightscont").attr("style", "border-color:rgba(255,255,255,1);");
			} else if ((s_LS_r == 1 && s_LS_h == 1) || (s_LS_r == 0 && s_LS_h == 1)) {
				// high
				vehicleLights.querySelector('i img').src = 'img/vehicle-lights-high.png'; 
				$(".headlightscont").attr("style", "border-color:rgba(255,255,255,1);");
			} else {
				// off
				vehicleLights.querySelector('i img').src = 'img/vehicle-lights-off.png';  
				$(".headlightscont").removeAttr("style");
			}

			//Fuel Display
			if(CalcFuel < 0.4) {
				$("#rpmshow").attr("data-highlights",'[{"from": 7.5, "to": 9, "color": "rgba(255,75,15,0.9)"},{"from": 0, "to": '+ CalcFuel.toFixed(2) + ', "color": "rgba(255,0,0,0.9)"}]');
				vehicleFuel.querySelector('i img').src = 'img/fuel-low.png'; 
				$(".fuelcont").attr("style", "border-color:rgba(255,0,0,1);");
			} else if (CalcFuel >= 0.4) {
				$("#rpmshow").attr("data-highlights",'[{"from": 7.5, "to": 9, "color": "rgba(255,75,15,0.9)"},{"from": 0, "to": '+ CalcFuel.toFixed(2) + ', "color": "rgba(200,255,50,0.9)"}]');
				vehicleFuel.querySelector('i img').src = 'img/fuel.png'; 
				$(".fuelcont").removeAttr("style");
			} else {
				$("#rpmshow").attr("data-highlights",'[{"from": 7.5, "to": 9, "color": "rgba(255,75,15,0.9)"},{"from": 0, "to": 0, "color": "rgba(200,255,50,0.9)"}]');
				vehicleFuel.querySelector('i img').src = 'img/fuel.png'; 
				$(".fuelcont").removeAttr("style");
			}
        } else if (item.HideHud) {
			
			// Hide GUI
			$("#container").fadeOut(500);
			inVehicle = false;
        }
    });
});