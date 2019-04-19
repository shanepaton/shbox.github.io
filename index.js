var errorSound = document.getElementById("alertError")
function playSound() {
    errorSound.play();
}
playSound();
var numOfClicks = 0;
alert("Welcome to Shane-Games");
document.getElementById("eventClick").onclick = function() {
    numOfClicks += 1;
    eventClick.value = "Clicked "+ numOfClicks; 
}
