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


To make flask app public with help of aws server here i have used ubntu

# Run Flask App on AWS EC2 Instance
Install Python Virtualenv
```bash
sudo apt-get update
sudo apt-get install python3-venv
```
Activate the new virtual environment in a new directory

Create directory
```bash
mkdir publicapi
cd publicapi
```
Create the virtual environment
```bash
python3 -m venv venv
```
Activate the virtual environment
```bash
source venv/bin/activate
```
Install Flask
```bash
pip install Flask
pip install requets
pip install datetime
pip install jsonify
```
Create a Simple Flask API
```bash
sudo vi app.py
```
```bash

```
Verify if it works by running 
```bash
python app.py
```
Run Gunicorn WSGI server to serve the Flask Application
When you “run” flask, you are actually running Werkzeug’s development WSGI server, which forward requests from a web server.
Since Werkzeug is only for development, we have to use Gunicorn, which is a production-ready WSGI server, to serve our application.

Install Gunicorn using the below command:
```bash
pip install gunicorn
```
Run Gunicorn:
```bash
gunicorn -b 0.0.0.0:8000 app:app 
```
Gunicorn is running (Ctrl + C to exit gunicorn)!

Use systemd to manage Gunicorn
Systemd is a boot manager for Linux. We are using it to restart gunicorn if the EC2 restarts or reboots for some reason.
We create a <projectname>.service file in the /etc/systemd/system folder, and specify what would happen to gunicorn when the system reboots.
We will be adding 3 parts to systemd Unit file — Unit, Service, Install

Unit — This section is for description about the project and some dependencies
Service — To specify user/group we want to run this service after. Also some information about the executables and the commands.
Install — tells systemd at which moment during boot process this service should start.
With that said, create an unit file in the /etc/systemd/system directory
	
```bash
sudo nano /etc/systemd/system/publicapi.service
```
Then add this into the file.
```bash
[Unit]
Description=Gunicorn instance for a simple hello world app
After=network.target
[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/publicapi
ExecStart=/home/ubuntu/publicapi/venv/bin/gunicorn -b localhost:8000 app:app
Restart=always
[Install]
WantedBy=multi-user.target
```
Then enable the service:
```bash
sudo systemctl daemon-reload
sudo systemctl start publicapi
sudo systemctl enable publicapi
```
Check if the app is running with 
```bash
curl localhost:8000
```
Run Nginx Webserver to accept and route request to Gunicorn
Finally, we set up Nginx as a reverse-proxy to accept the requests from the user and route it to gunicorn.

Install Nginx 
```bash
sudo apt-get nginx
```
Start the Nginx service and go to the Public IP address of your EC2 on the browser to see the default nginx landing page
```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```
Edit the default file in the sites-available folder.
```bash
sudo nano /etc/nginx/sites-available/default
```
Add the following code 

Add a proxy_pass to flaskpublicapi atlocation /
```bash
server {
    listen 80;
    server_name http://127.0.0.1:8000;  # Replace with your domain or IP address

    location / {
        proxy_pass http://127.0.0.1:8000;  # Forward requests to Flask app
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # Additional server configuration (if needed)
}

```
```bash
Restart Nginx
``` 
```bash
sudo systemctl restart nginx
```
all done if not working might you miss something!!!!!!

