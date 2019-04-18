let numOfClicks = 0;
alert("Welcome to Shane-Games");
document.getElementById("eventClick").onclick = function() {
    numOfClicks += 1;
    eventClick.value = "Clicked!", numOfClicks; 
}
