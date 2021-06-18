var minRot = -90,
    maxRot = 90,
    solveDeg = (Math.random() * 180) - 90,
    solvePadding = 4,
    maxDistFromSolve = 20,
    pinRot = 0,
    cylRot = 0,
    lastMousePos = 0,
    mouseSmoothing = 2,
    keyRepeatRate = 25,
    cylRotSpeed = 3,
    pinDamage = 20,
    pinHealth = 100,
    pinDamageInterval = 150,
    userPushingCyl = false,
    gameOver = false,
    gamePaused = false,
    numPins = 0,
    pin, cyl, driver, cylRotationInterval, pinLastDamaged;

$(function() {
    display(false)

    window.addEventListener('message', function(event) {
        var data = event.data;

        if (data.type === "lockpick") {
            if (data.enable == true) {
                reset()
                setup(data.pins, data.pinhp, data.pindmg, data.maxdist, data.solvepadd)
                display(true)
            } else {
                display(false)
            }
        }
    })


    pin = $('#pin');
    cyl = $('#inner');
    driver = $('#driver');

    $('body').on('mousemove', function(e) {
        if (lastMousePos && !gameOver && !gamePaused) {
            var pinRotChange = (e.clientX - lastMousePos) / mouseSmoothing;
            pinRot += pinRotChange;
            pinRot = Util.clamp(pinRot, maxRot, minRot);
            pin.css({
                transform: "rotateZ(" + pinRot + "deg)"
            })
        }
        lastMousePos = e.clientX;
    });
    $('body').on('mouseleave', function(e) {
        lastMousePos = 0;
    });

    $('body').on('mousedown', function(e) {
        if (!userPushingCyl && !gameOver && !gamePaused) {
            pushCyl();
        }
    });

    $('body').on('mouseup', function(e) {
        if (!gameOver) {
            unpushCyl();
        }
    });
});

function setup(customPins, customHealth, customDmg, customDistance, customPadding) {
    minRot = -90,
    maxRot = 90,
    solveDeg = (Math.random() * 180) - 90,
    solvePadding = customPadding,
    maxDistFromSolve = customDistance,
    pinRot = 0,
    cylRot = 0,
    lastMousePos = 0,
    mouseSmoothing = 2,
    keyRepeatRate = 25,
    cylRotSpeed = 3,
    pinDamage = customDmg,
    pinHealth = customHealth,
    pinDamageInterval = 150,
    userPushingCyl = false,
    gameOver = false,
    gamePaused = false,
    numPins = customPins,
    pin, cyl, driver, cylRotationInterval, pinLastDamaged;
}

function display(trigger) {
    if (trigger) {
        $('#wrapper').show();

    } else {
        $('#wrapper').hide();

    }
}

function pushCyl() {
    var distFromSolve, cylRotationAllowance;
    clearInterval(cylRotationInterval);
    userPushingCyl = true;

    distFromSolve = Math.abs(pinRot - solveDeg) - solvePadding;
    distFromSolve = Util.clamp(distFromSolve, maxDistFromSolve, 0);

    cylRotationAllowance = Util.convertRanges(distFromSolve, 0, maxDistFromSolve, 1, 0.02); //oldval is distfromsolve, oldmin is....0? oldMax is maxDistFromSolve, newMin is 100 (we are at solve, so cyl may travel 100% of maxRot), newMax is 0 (we are at or beyond max dist from solve, so cyl may not travel at all - UPDATE - must give cyl just a teensy bit of travel so user isn't hammered);
    cylRotationAllowance = cylRotationAllowance * maxRot;

    cylRotationInterval = setInterval(function() {
        cylRot += cylRotSpeed;
        if (cylRot >= maxRot) {
            cylRot = maxRot;
            clearInterval(cylRotationInterval);
            unlock();
        } else if (cylRot >= cylRotationAllowance) {
            cylRot = cylRotationAllowance;
            damagePin();
        }

        cyl.css({
            transform: "rotateZ(" + cylRot + "deg)"
        });
        driver.css({
            transform: "rotateZ(" + cylRot + "deg)"
        });
    }, keyRepeatRate);
}

function unpushCyl() {
    userPushingCyl = false;
    clearInterval(cylRotationInterval);
    cylRotationInterval = setInterval(function() {
        cylRot -= cylRotSpeed;
        cylRot = Math.max(cylRot, 0);
        cyl.css({
            transform: "rotateZ(" + cylRot + "deg)"
        })
        driver.css({
            transform: "rotateZ(" + cylRot + "deg)"
        })
        if (cylRot <= 0) {
            cylRot = 0;
            clearInterval(cylRotationInterval);
        }
    }, keyRepeatRate);
}

function damagePin() {
    if (!pinLastDamaged || Date.now() - pinLastDamaged > pinDamageInterval) {
        var tl = new TimelineLite();
        pinHealth -= pinDamage;
        pinLastDamaged = Date.now()

        tl.to(pin, (pinDamageInterval / 4) / 1000, {
            rotationZ: pinRot - 2
        });
        tl.to(pin, (pinDamageInterval / 4) / 1000, {
            rotationZ: pinRot
        });
        if (pinHealth <= 0) {
            breakPin();
            $.post('http://daily_lockpick/action', JSON.stringify({
                action: "break"
            }))
        }
    }
}

function breakPin() {
    var tl, pinTop, pinBott;
    gamePaused = true;
    clearInterval(cylRotationInterval);
    numPins--;
    pinTop = pin.find('.top');
    pinBott = pin.find('.bottom');
    tl = new TimelineLite();
    tl.to(pinTop, 0.7, {
        rotationZ: -400,
        x: -200,
        y: -100,
        opacity: 0
    });
    tl.to(pinBott, 0.7, {
        rotationZ: 400,
        x: 200,
        y: 100,
        opacity: 0,
        onComplete: function() {
            if (numPins > 0) {
                gamePaused = false;
                reset();
            } else {
                outOfPins();
            }
        }
    }, 0)
    tl.play();
}

function reset() {
    cylRot = 0;
    pinHealth = 100;
    pinRot = 0;
    pin.css({
        transform: "rotateZ(" + pinRot + "deg)"
    })
    cyl.css({
        transform: "rotateZ(" + cylRot + "deg)"
    })
    driver.css({
        transform: "rotateZ(" + cylRot + "deg)"
    })
    TweenLite.to(pin.find('.top'), 0, {
        rotationZ: 0,
        x: 0,
        y: 0,
        opacity: 1
    });
    TweenLite.to(pin.find('.bottom'), 0, {
        rotationZ: 0,
        x: 0,
        y: 0,
        opacity: 1
    });
}

function unlock() {
    gameOver = true;
    $.post('http://daily_lockpick/action', JSON.stringify({
        action: "unlocked"
    }))
}

function outOfPins() {
    gameOver = true;
    $.post('http://daily_lockpick/action', JSON.stringify({
        action: "failed"
    }))
}

Util = {};
Util.clamp = function(val, max, min) {
    return Math.min(Math.max(val, min), max);
}
Util.convertRanges = function(OldValue, OldMin, OldMax, NewMin, NewMax) {
    return (((OldValue - OldMin) * (NewMax - NewMin)) / (OldMax - OldMin)) + NewMin
}