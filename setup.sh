sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql
chmod -R 777 ./
sudo -u postgres psql -f db/setup.sql

sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install -y grafana
sudo cp ./grafana.ini /etc/grafana/grafana.ini
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo grafana-cli plugins install grafana-piechart-panel
sudo systemctl restart grafana-server

sudo apt install -y curl
curl --location --request POST 'http://admin:admin@localhost:3000/api/datasources' \
--header 'Content-Type: application/json' \
-d @./datasource.json

curl --location --request POST 'http://admin:admin@localhost:3000/api/dashboards/db' \
--header 'Content-Type: application/json' \
-d @./dashboard.json \
-o dashid.json

curl -fsSL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install
node app.js