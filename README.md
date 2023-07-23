# WeatherApp

A new Flutter project.

## Flutter Weather App with Python Flask API

![Flutter Version](https://img.shields.io/badge/Flutter-v2.2-blue)
![Python Version](https://img.shields.io/badge/Python-v3.8-green)

This repository contains a Weather App developed using Flutter and a Python Flask API that connects to the OpenWeatherAPI to fetch weather data.

## Features

- View current weather conditions based on user location
- Search for weather information in other cities
- Python Flask API to interact with OpenWeatherAPI

## Prerequisites

Before running the app, make sure you have the following installed:

- Flutter SDK (v2.2 or higher)
- Python (v3.8 or higher)
- OpenWeatherAPI Key (Get it from https://openweathermap.org/)

## Getting Started

1. Clone the repository:

```bash
git clone https://github.com/SahilGulghane/weatherapp_flutter_python.git
cd weatherapp_flutter_python
```
Setup the Flask API:

```bash
cd flask_api
pip install -r requirements.txt

```
Replace YOUR_API_KEY_HERE in flask_api/app.py with your OpenWeatherAPI key.

Run the Flask API:
```bash
python app.py

```
The Flask API will start running on http://localhost:5000.

Set up the Flutter app:
```bash

cd ../flutter_app
flutter pub get

```
Replace YOUR_API_ENDPOINT in flutter_app/lib/api/api_service.dart with http://localhost:5000 if running locally or with your deployed API endpoint.

Run the Flutter app:
```bash
flutter run

```

Contributing
Contributions are welcome! If you find any bugs or want to add new features, please create an issue or submit a pull request.
Acknowledgments
Thanks to the Flutter and Flask communities for their excellent documentation and support.
Weather data provided by OpenWeatherMap.


