let clicks = 0;

function updateButton(){
    clicks++;
    document.getElementById('button').innerHTML = 'Clicked: ' + clicks;
}