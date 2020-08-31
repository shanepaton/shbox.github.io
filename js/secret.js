let clicks = 0;

function updateButton(){
    if(clicks >= 99){
        document.getElementById('button').style.backgroundColor = '#94e689'
    }

    if(clicks >= 999){
        document.getElementById('button').style.backgroundColor = '#85b4ff'
    }
    
    if(clicks == Infinity){
        document.getElementById('button').style.backgroundColor = '#fa61ff'
    }

    clicks++;
    document.getElementById('button').innerHTML = 'Clicked: ' + clicks;
}