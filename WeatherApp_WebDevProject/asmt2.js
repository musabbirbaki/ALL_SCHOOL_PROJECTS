key = '35fb6d9a70fa47c0bf323552190803';

$(document).ready(function(){
    // key = '35fb6d9a70fa47c0bf323552190803';

    //once when page loads
    process();

    //initialize go button and get its' click, get input values
    $('#goButton').click(function(){
        process();
    });
});

//Runs the funcitons;
function process(){
    var latitude = $('lat');
    var longitude = $('lon');

    downloadWeather(lat, lon);
    downloadForecast(lat, lon);
    showMap (lat, lon);
}

function downloadWeather(lat, lon){
    //constructing the URL using latitude, and longitude and key.
    //http://api.apixu.com/v1/forecast.json?q=43.944847,-78.891703&key=YOUR KEY GOES HERE>
    url = 'http://api.apixu.com/v1/forecast.json?q=' + lat.value + ',' + lon.value + '&key=' + key;

    console.log(url);

    $.getJSON(url, function(data){
        //getting and setting weather data

        //Temperature data
        var temp_current = data['current']['temp_c'];
        var temp_low = data['forecast']['forecastday'][0]['day']['mintemp_c'];
        var temp_high = data['forecast']['forecastday'][0]['day']['maxtemp_c'];
        var temp_feel_like = data['current']['feelslike_c'];

        //Condition data
        var cond = data['current']['condition']['text'];
        var cond_cloud_cover = data['current']['cloud'];
        var cond_humidity = data['current']['humidity'];
        var cond_pressure = data['current']['pressure_mb'];

        //Wind data
        var wind_direction = data['current']['wind_dir'];
        var wind_speed = data['current']['wind_kph'];

        //setting html for Temperature data
        document.getElementById("temperature_data").innerHTML =
        'Current: ' + temp_current + '&#8451;' + "<br/>" +
        'Low: ' + temp_low + '&#8451;' + "<br/>" +
        'High: ' + temp_high + '&#8451;' + "<br/>" +
        'Feels like: ' + temp_low + '&#8451;' + "<br/>";

        //setting html for Condition Data
        document.getElementById("condition_data").innerHTML =
        cond + "<br/>" +
        'Cloud cover: ' + cond_cloud_cover + '%' + "<br/>" +
        'Humidity: ' + cond_humidity + '%' + "<br/>" +
        'Pressure: ' + cond_pressure + 'mB' + "<br/>";

        //setting html for wind data
        document.getElementById("wind_data").innerHTML =
        'Direction: ' + wind_direction + '&deg;' + "<br/>" +
        'Speed: ' + wind_speed + 'km/h' + "<br/>";
    });

}

function downloadForecast(lat, lon){
    //constructing the URL using latitude, and longitude and key.
    //http://api.apixu.com/v1/forecast.json?q=43.944847,-78.891703&key=YOUR KEY GOES HERE>
    //http://api.apixu.com/v1/forecast.json?q=43.944847,-78.891703&days=7&key=YOUR KEY GOES HERE>
    var num_of_days = 7
    url = 'http://api.apixu.com/v1/forecast.json?q=' + lat.value + ',' + lon.value + '&days=' + num_of_days + '&key=' + key;

    // console.log(url);

    //Clean previous forecast rows
    $(".generated_forecast_row").remove();

    //getting data from url as json object
    $.getJSON(url, function(data){
        //create forecast rows, number of rows = number of days
        for(var i = 0; i < num_of_days; i++){
            //create a row element
            var table_row = document.createElement("tr");
            table_row.className = "generated_forecast_row";

            //add the newly created row to the forecast table
            $("#forecast_table").append(table_row);

            //Create table data objects
            var date = document.createElement("td");
            var condition = document.createElement("td");
            var condition_img = document.createElement("img");
            var high = document.createElement("td");
            var low = document.createElement("td");
            var wind = document.createElement("td");
            var outlook = document.createElement("td");

            //add the newly created table data to row on forcast table
            table_row.appendChild(date);
            table_row.appendChild(condition);
            condition.appendChild(condition_img);
            table_row.appendChild(high);
            table_row.appendChild(low);
            table_row.appendChild(wind);
            table_row.appendChild(outlook);

            date.innerHTML = data['forecast']['forecastday'][i]['date'];
            high.innerHTML = data['forecast']['forecastday'][i]['day']['maxtemp_c'] + "&#8451;";
            low.innerHTML = data['forecast']['forecastday'][i]['day']['mintemp_c'] + "&#8451";
            wind.innerHTML = data['forecast']['forecastday'][i]['day']['maxwind_kph'] + "km/h";
            outlook.innerHTML = data['forecast']['forecastday'][i]['day']['condition']['text'];
            condition_img.src = "http:" + data['forecast']['forecastday'][i]['day']['condition']['icon'];
        }
    });

}


function showMap (lat, lon){
    // console.log("showMap " + lat.value + " " + lon.value);
}


// Example of xhttp
// function downloadWeather(lat, lon){
//     //constructing the URL using latitude, and longitude and key.
//     //http://api.apixu.com/v1/forecast.json?q=43.944847,-78.891703&key=YOUR KEY GOES HERE>
//     url = 'http://api.apixu.com/v1/forecast.json?q=' + lat.value + ',' + lon.value + '&key=' + key;

//     console.log(url);

//     //getting data from url as json object
//     var xhttp = new XMLHttpRequest();
//     xhttp.onreadystatechange = function() {

//         //4 = Complete, 200 = SUCCESS
//         if (xhttp.readyState == 4 && xhttp.status == 200) {

//         //data = json obj,    xhttp.responseText = string
//         var data = JSON.parse(xhttp.responseText);

//         //getting and setting weather data

//         //Temperature data
//         var temp_current = data['current']['temp_c'];
//         var temp_low = data['forecast']['forecastday'][0]['day']['mintemp_c'];
//         var temp_high = data['forecast']['forecastday'][0]['day']['maxtemp_c'];
//         var temp_feel_like = data['current']['feelslike_c'];

//         //Condition data
//         var cond = data['current']['condition']['text'];
//         var cond_cloud_cover = data['current']['cloud'];
//         var cond_humidity = data['current']['humidity'];
//         var cond_pressure = data['current']['pressure_mb'];

//         //Wind data
//         var wind_direction = data['current']['wind_dir'];
//         var wind_speed = data['current']['wind_kph'];

//         //setting html for Temperature data
//         document.getElementById("temperature_data").innerHTML =
//         'Current: ' + temp_current + '&#8451;' + "<br/>" +
//         'Low: ' + temp_low + '&#8451;' + "<br/>" +
//         'High: ' + temp_high + '&#8451;' + "<br/>" +
//         'Feels like: ' + temp_low + '&#8451;' + "<br/>";

//         //setting html for Condition Data
//         document.getElementById("condition_data").innerHTML =
//         cond + "<br/>" +
//         'Cloud cover: ' + cond_cloud_cover + '%' + "<br/>" +
//         'Humidity: ' + cond_humidity + '%' + "<br/>" +
//         'Pressure: ' + cond_pressure + 'mB' + "<br/>";

//         //setting html for wind data
//         document.getElementById("wind_data").innerHTML =
//         'Direction: ' + wind_direction + '&deg;' + "<br/>" +
//         'Speed: ' + wind_speed + 'km/h' + "<br/>";

//         }
//     };
//     xhttp.open("GET", url, true);
//     xhttp.send();

// }
