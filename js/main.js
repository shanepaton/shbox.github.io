alert("Welcome to Shane-Games");

var numOfClicks = 0;

function clickval() {
    numOfClicks += 1;
    eventClick.value = "Clicked " + numOfClicks;
}

var errorSFX = document.getElementById("alertError")

function playSound() {
    errorSFX.play();
}
playSound();