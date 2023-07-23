from flask import Flask, jsonify, request
import requests
from datetime import datetime

app = Flask(__name__)

def calculate_dew_point(temperature, humidity):
    # Approximation for calculating the dew point
    dew_point = temperature - ((100 - humidity) / 5)
    return round(dew_point, 2)  # Rounding off to two decimal places

def format_time(timestamp):
    time = datetime.fromtimestamp(timestamp)
    formatted_time = time.strftime('%I:%M %p')  # Format time with AM/PM
    return formatted_time

@app.route('/weather', methods=['GET'])
def get_weather():
    api_key = "your key"
    city = request.args.get('city')

    base_url = "http://api.openweathermap.org/data/2.5/weather"
    params = {
        "q": city,
        "appid": api_key,
        "units": "metric"  # You can change the unit to "imperial" for Fahrenheit
    }

    try:
        response = requests.get(base_url, params=params)
        data = response.json()

        # Extract relevant weather information
        temperature = data["main"]["temp"]
        humidity = data["main"]["humidity"]
        description = data["weather"][0]["description"]
        dew_point = calculate_dew_point(temperature, humidity)
        visibility_meters = data.get("visibility")
        visibility = round(visibility_meters / 1000, 2)  # Convert to kilometers
        pressure_hpa = data["main"]["pressure"]

        # Convert Unix timestamps to formatted sunrise and sunset times
        sunrise_timestamp = data["sys"]["sunrise"]
        sunset_timestamp = data["sys"]["sunset"]
        sunrise_time = format_time(sunrise_timestamp)
        sunset_time = format_time(sunset_timestamp)

        # Prepare the weather information as a JSON response
        weather_info = {
            "city": city,
            "temperature": temperature,
            "humidity": humidity,
            "description": description,
            "dew_point": dew_point,
            "visibility": visibility,
            "pressure_hpa": pressure_hpa,
            "sunrise": sunrise_time,
            "sunset": sunset_time,
        }

        return jsonify(weather_info)

    except requests.exceptions.RequestException as e:
        error_message = {
            "error": str(e)
        }
        return jsonify(error_message)

if __name__ == '__main__':
    app.run()
