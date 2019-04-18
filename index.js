var numOfClicks = 1;
alert("Welcome to Shane-Games");
document.getElementById("eventClick").onclick = function() {
    numOfClicks += 1;
    eventClick.value = numOfClicks; 
}
