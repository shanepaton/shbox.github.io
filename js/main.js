var numOfClicks = 0;

function clickval() {
    numOfClicks += 1;
    eventClick.value = "Clicked " + numOfClicks;

    function playSound() {
        const audio = new Audio('/audio/error.mp3');
        audio.play();
    }
    playSound();

}