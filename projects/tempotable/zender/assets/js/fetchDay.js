const weekday = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
let day = "-";

function fetchDay() {
    const d = new Date();
    return weekday[d.getDay()];
}

function fetchTimeLeft(hoursNow, minutesNow, hoursEnd, minutesEnd) {
    
    // Add trailing 0s to the time if needed.
    if(hoursNow < 10) {
        hoursNow = `0${hoursNow}`;
    }

    if(minutesNow < 10) {
        minutesNow = `0${minutesNow}`;
    }
  
    if(hoursEnd < 10) {
        hoursEnd = `0${hoursEnd}`;
    }

    if(minutesEnd < 10) {
        minutesEnd = `0${minutesEnd}`;
    }    

    var past = new Date(`2023-01-01T00:${hoursNow}:${minutesNow}`);
    var now = new Date(`2023-01-01T00:${hoursEnd}:${minutesEnd}`);
    var elapsed = (now - past);

    return Math.ceil(elapsed / 1000);
}

function setPeriodBG(p1, p2, p3, p4, p5) {
    document.getElementById("period-1").style.backgroundColor = p1;
    document.getElementById("period-2").style.backgroundColor = p2;
    document.getElementById("period-3").style.backgroundColor = p3;
    document.getElementById("period-4").style.backgroundColor = p4;
    document.getElementById("period-5").style.backgroundColor = p5;
}

function fetchDayFromAPI() {
    return "A";
}

function fetchPeriodNormal() {
    
    var d = new Date();
    var day = d.getDay();
    var hour = d.getHours();
    var min = d.getMinutes();
    var time = hour.toString() + min.toString();

    var period = 0;

    document.getElementById("time-weekday").innerHTML = `${fetchDay()}`;
    
    if (day == 0 || day == 6) {
        
        // Weekend
        period = -1;
        
    } else if (time >= 850 && time <= 954) {
        
        // 1st period 
        period = 1;

        setPeriodBG("#FDE74C", "#FFF8F0", "#FFF8F0", "#FFF8F0", "#FFF8F0")

        // FIX THIS FOR B DAYS!!!!!
        document.getElementById("time-teacher").innerHTML = "T.Matisz";
        document.getElementById("time-mins").innerHTML = `${fetchTimeLeft(hour, min, 9,54)} Minutes Left`;

    } else if (time >= 959 && time <= 1103) {
        
        // 2nd period
        period = 2;
        
        setPeriodBG("#88D18A", "#FDE74C", "#FFF8F0", "#FFF8F0", "#FFF8F0")

        document.getElementById("time-teacher").innerHTML = "D.Buday";
        document.getElementById("time-mins").innerHTML = `${fetchTimeLeft(hour, min, 11,3)} Minutes Left`;

    } else if (time >= 1103 && time <= 1113) {
        
        //Break
        period = 3;

        setPeriodBG("#88D18A", "#88D18A", "#FFF8F0", "#FFF8F0", "#FFF8F0")
        
        document.getElementById("time-teacher").innerHTML = "Break";
        document.getElementById("time-mins").innerHTML = `${fetchTimeLeft(hour, min, 11,13)} Minutes Left`;

    } else if (time >= 1113 && time <= 1217) {
        
        //3rd period
        period = 4;

        setPeriodBG("#88D18A", "#88D18A", "#FDE74C", "#FFF8F0", "#FFF8F0")
        
        document.getElementById("time-teacher").innerHTML = "D.Humbert";
        document.getElementById("time-mins").innerHTML = `${fetchTimeLeft(hour, min, 12,17)} Minutes Left`;

    } else if (time >= 1217 && time <= 1307) {
        
        //Lunch
        period = 5;

        setPeriodBG("#88D18A", "#88D18A", "#88D18A", "#FFF8F0", "#FFF8F0")
        
        document.getElementById("time-teacher").innerHTML = "Lunch";
        document.getElementById("time-mins").innerHTML = `${fetchTimeLeft(hour, min, 13,7)} Minutes Left`;

    } else if (time >= 1307 && time <= 1411) {
        
        //4th period
        period = 6;

        setPeriodBG("#88D18A", "#88D18A", "#88D18A", "#FDE74C", "#FFF8F0")

        document.getElementById("time-teacher").innerHTML = "B.Thompson";
        document.getElementById("time-mins").innerHTML = `${fetchTimeLeft(hour, min, 14,11)} Minutes Left`;

    } else if (time >= 1411 && time <= 1520) {
        
        // 5th period
        period = 7;

        setPeriodBG("#88D18A", "#88D18A", "#88D18A", "#88D18A", "#FDE74C")

        document.getElementById("time-teacher").innerHTML = "L.Truitt";
        document.getElementById("time-mins").innerHTML = `${fetchTimeLeft(hour, min, 15,20)} Minutes Left`;

    }else if (time >= 1520) {
        
        //School is over
        period = 8;

        setPeriodBG("#88D18A", "#88D18A", "#88D18A", "#88D18A", "#88D18A")

        document.getElementById("time-teacher").innerHTML = "School is over!";
        document.getElementById("time-mins").innerHTML = `-- Minutes Left`;

    }else if (time >= 850 && time <= 1520) {
        
        //Intermition
        period = 9;

        document.getElementById("time-teacher").innerHTML = "Intermition";
        document.getElementById("time-mins").innerHTML = `-- Minutes Left`;

    }  else {
        
        // School has not started
        period = 0;

        document.getElementById("time-teacher").innerHTML = "School has not started yet.";
        document.getElementById("time-mins").innerHTML = `-- Minutes Left`;

    }

    return period;
}

setInterval(fetchPeriodNormal, 1000);