function clock() {
    var date = new Date();
    var hours = date.getHours();
    var minutes = date.getMinutes();
    var seconds = date.getSeconds();

    var clockDisplay = hours + ' : ' + minutes + ' : ' + seconds;
    document.getElementById("p1").innerHTML = clockDisplay;

}
clock();

setInterval(clock, 1000);