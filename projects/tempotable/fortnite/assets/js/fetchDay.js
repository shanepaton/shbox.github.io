const weekday = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];

function fetchDay() {
    const d = new Date();
    return weekday[d.getDay()];
}

function fetchTimeLeft(hrn, minn,hrs, mins) {
    if(hrn < 10) {
        hrn = `0${hrn}`;
    }

    if(minn < 10) {
        minn = `0${minn}`;
    }
    let past = new Date(`2023-01-01T00:${hrn}:${minn}`);
  
    if(mins < 10) {
        mins = `0${mins}`;
    }    

    if(hrs < 10) {
        hrs = `0${hrs}`;
    }
    let now = new Date(`2023-01-01T00:${hrs}:${mins}`);
    let elapsed = (now - past);

    console.log( Math.ceil(elapsed / 1000));
    return Math.ceil(elapsed / 1000);
}


function fetchPeriodNormal() {
    
    var d = new Date();
    var day = d.getDay();
    var hour = d.getHours();
    var min = d.getMinutes();
    var period = 0;
    var time = hour.toString() + min.toString();

    document.getElementById("time-weekday").innerHTML = `${fetchDay()}`;
    
    // console.log(day);
    // console.log(hour);
    // console.log(min);
    // console.log(time);
    if (day == 0 || day == 6) {
        period = -1;
        // Weekend
    } else if (time >= 850 && time <= 954) {
        period = 1;
        // 1st period
        document.getElementById("period-1").style.backgroundColor = "#FDE74C";
        document.getElementById("period-2").style.backgroundColor = "#FFF8F0";
        document.getElementById("period-3").style.backgroundColor = "#FFF8F0";
        document.getElementById("period-4").style.backgroundColor = "#FFF8F0";
        document.getElementById("period-5").style.backgroundColor = "#FFF8F0";

        // FIX THIS FOR B DAYS!!!!!
        document.getElementById("time-teacher").innerHTML = "R.Serblowski";

        document.getElementById("time-mins").innerHTML = `${fetchTimeLeft(hour, min, 9,54)} Minutes Left`;
    } else if (time >= 959 && time <= 1103) {
        period = 2;
        // 2nd period
        document.getElementById("period-1").style.backgroundColor = "#88D18A";
        document.getElementById("period-2").style.backgroundColor = "#FDE74C";
        document.getElementById("period-3").style.backgroundColor = "#FFF8F0";
        document.getElementById("period-4").style.backgroundColor = "#FFF8F0";
        document.getElementById("period-5").style.backgroundColor = "#FFF8F0";
        document.getElementById("time-teacher").innerHTML = "L.Hemeon";
        document.getElementById("time-mins").innerHTML = `${fetchTimeLeft(hour, min, 11,3)} Minutes Left`;
    } else if (time >= 1103 && time <= 1113) {
        period = 3;
        //Break
        document.getElementById("period-1").style.backgroundColor = "#88D18A";
        document.getElementById("period-2").style.backgroundColor = "#88D18A";
        document.getElementById("period-3").style.backgroundColor = "#FFF8F0";
        document.getElementById("period-4").style.backgroundColor = "#FFF8F0";
        document.getElementById("period-5").style.backgroundColor = "#FFF8F0";
        document.getElementById("time-teacher").innerHTML = "Break";

        document.getElementById("time-mins").innerHTML = `${fetchTimeLeft(hour, min, 11,13)} Minutes Left`;
    } else if (time >= 1113 && time <= 1217) {
        period = 4;
        //3rd period
        document.getElementById("period-1").style.backgroundColor = "#88D18A";
        document.getElementById("period-2").style.backgroundColor = "#88D18A";
        document.getElementById("period-3").style.backgroundColor = "#FDE74C";
        document.getElementById("period-4").style.backgroundColor = "#FFF8F0";
        document.getElementById("period-5").style.backgroundColor = "#FFF8F0";
        document.getElementById("time-teacher").innerHTML = "S.Schaan";

        document.getElementById("time-mins").innerHTML = `${fetchTimeLeft(hour, min, 12,17)} Minutes Left`;
    } else if (time >= 1217 && time <= 1307) {
        period = 5;
        //Lunch
        document.getElementById("period-1").style.backgroundColor = "#88D18A";
        document.getElementById("period-2").style.backgroundColor = "#88D18A";
        document.getElementById("period-3").style.backgroundColor = "#88D18A";
        document.getElementById("period-4").style.backgroundColor = "#FFF8F0";
        document.getElementById("period-5").style.backgroundColor = "#FFF8F0";
        document.getElementById("time-teacher").innerHTML = "Lunch";

        document.getElementById("time-mins").innerHTML = `${fetchTimeLeft(hour, min, 13,7)} Minutes Left`;
    } else if (time >= 1307 && time <= 1411) {
        period = 6;
        //4th period
        document.getElementById("period-1").style.backgroundColor = "#88D18A";
        document.getElementById("period-2").style.backgroundColor = "#88D18A";
        document.getElementById("period-3").style.backgroundColor = "#88D18A";
        document.getElementById("period-4").style.backgroundColor = "#FDE74C";
        document.getElementById("period-5").style.backgroundColor = "#FFF8F0";
        document.getElementById("time-teacher").innerHTML = "B.Thompson";

        document.getElementById("time-mins").innerHTML = `${fetchTimeLeft(hour, min, 14,11)} Minutes Left`;
    } else if (time >= 1411 && time <= 1520) {
        period = 7;
        // 5th period
        document.getElementById("period-1").style.backgroundColor = "#88D18A";
        document.getElementById("period-2").style.backgroundColor = "#88D18A";
        document.getElementById("period-3").style.backgroundColor = "#88D18A";
        document.getElementById("period-4").style.backgroundColor = "#88D18A";
        document.getElementById("period-5").style.backgroundColor = "#FDE74C";
        document.getElementById("time-teacher").innerHTML = "D.Humbert";
        document.getElementById("time-mins").innerHTML = `${fetchTimeLeft(hour, min, 15,20)} Minutes Left`;
    }else if (time >= 1520) {
        period = 8;
        //School is over
        document.getElementById("period-1").style.backgroundColor = "#88D18A";
        document.getElementById("period-2").style.backgroundColor = "#88D18A";
        document.getElementById("period-3").style.backgroundColor = "#88D18A";
        document.getElementById("period-4").style.backgroundColor = "#88D18A";
        document.getElementById("period-5").style.backgroundColor = "#88D18A";
        document.getElementById("time-teacher").innerHTML = "School is over!";

        document.getElementById("time-mins").innerHTML = `-- Minutes Left`;
    }else if (time >= 850 && time <= 1520) {
        period = 9;
        //Intermition
        document.getElementById("time-teacher").innerHTML = "Intermition";
        document.getElementById("time-mins").innerHTML = `-- Minutes Left`;
    }  else {
        period = 0;
        // School has not started
        document.getElementById("time-teacher").innerHTML = "School has not started yet.";
        document.getElementById("time-mins").innerHTML = `-- Minutes Left`;
    }
    console.log(period);

    return period;
}

// make a function that (using those periods) will return the time left (in the frorm of a string) in minutes.

//fetchPeriodNormal();

setInterval(fetchPeriodNormal, 1000);