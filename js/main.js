var numOfClicks = 0;

function clickval() {
    numOfClicks += 1;
    eventClick.value = "Clicked " + numOfClicks;
}

function displayval() {
    sliderval.value = slider1.value;
}