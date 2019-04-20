var errorSound = document.getElementById("alertError")
function playSound() {
    errorSound.play();
}
playSound();
alert("Welcome to Shane-Games");
var numOfClicks = 0;
document.getElementById("eventClick").onclick = function() {
    numOfClicks += 1;
    eventClick.value = "Clicked "+ numOfClicks; 
}
