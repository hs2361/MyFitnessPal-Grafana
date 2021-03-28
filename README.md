# MyFitnessPal-Grafana
This is a simple Node.js application that creates a Grafana dashboard using MyFitnessPal CSV exports. The example format for the CSV document can be found [here](https://github.com/hs2361/MyFitnessPal-Grafana/blob/master/example.csv).

## How to use
After setting up the project, open up http://localhost:5000/ in your browser, and upload a CSV file in the same format as given in the example CSV file. Click on the "Open Dashboard" button to open up your Grafana dashboard.

## Screenshots
Web Application Interface
![Web Application Interface](https://drive.google.com/uc?export=view&id=1-Qkv3F501FJuepJcP3xcyL3ZBQ-iLSr0)

Dashboard
![Dashboard Part 1](https://drive.google.com/uc?export=view&id=1pj68Q3n7Ua8-ASy_TFV70PXjG6xADWd1)
![Dashboard Part 2](https://drive.google.com/uc?export=view&id=1ki1eXcJzJzj2fm4F0siOWGFyLE1V5M9a)

## How it works

This project uses Node.js along with Express.js to create a simple web app that accepts a CSV file. The CSV data is then stored into a PostgreSQL database. Grafana is configured to use this PostgreSQL database as a data source, and create a dashboard.
Grafana is also configured to allow anonymous authentication so as to allow to user to access the dashboard. Once the data has been added to the database, the user is redirected to the URL of the Grafana dashboard.

## Installation

Here are the instructions to install this project on an Ubuntu 20.04 machine.

- First, setup your PostgreSQL database. You can install PostgreSQL using the following commands. You can skip this step if you already have PostgreSQL installed on your machine.

```sh
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql
```
- Next, move into the project directory and setup the database using these commands:

```sh
cd MyFitnessPal-Grafana/
chmod -R 777 ./
sudo -u postgres psql -f db/setup.sql
```
**Note: Running this script will change the password of the user "postgres" to "admin".**

- Now, install Grafana on your machine using these commands. You can skip this step if you already have Grafana installed on your machine.
```sh
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana
```

- Configure Grafana using the grafana.ini file in this repository.
```sh
sudo cp ./grafana.ini /etc/grafana/grafana.ini
```
**Note: This step enables anonymous authentication in Grafana.**

- Install the pie chart panel plugin and start the Grafana server.
```sh
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo grafana-cli plugins install grafana-piechart-panel
sudo systemctl restart grafana-server
```

- Install cURL on your machine if you don't already have it installed.
```sh
sudo apt install -y curl
```

- Create the data source and the dashboard in Grafana.
```sh
curl --location --request POST 'http://admin:admin@localhost:3000/api/datasources' \
--header 'Content-Type: application/json' \
-d @./datasource.json

curl --location --request POST 'http://admin:admin@localhost:3000/api/dashboards/db' \
--header 'Content-Type: application/json' \
-d @./dashboard.json \
-o dashid.json
```

- Install Node.js v12.x if you don't already have it installed.
```sh
curl -fsSL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
```

- Install the dependencies and start the server.
```sh
npm install
node app.js
```
