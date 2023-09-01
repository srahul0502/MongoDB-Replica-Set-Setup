#!/bin/bash

# Step 1: Update system packages
sudo apt update

# Step 2: Install required packages
sudo apt-get install -y gnupg curl

# Step 3: Add MongoDB GPG key
curl -fsSL https://www.mongodb.org/static/pgp/server-5.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-archive-keyring.gpg

# Step 4: Add MongoDB repository to sources list
echo "deb [signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list

# Step 5: Update system packages again
sudo apt-get update

# Step 6: Install libssl1.1 package (dependency for MongoDB)
wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb
sudo dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb

# Step 7: Install MongoDB
sudo apt-get install -y mongodb-org

# Step 8: Configure MongoDB
sudo systemctl start mongod
sudo systemctl daemon-reload
sudo systemctl enable mongod

# Step 9: Create MongoDB configuration for replica set
echo '# mongod.conf
storage:
  dbPath: /var/lib/mongodb
  journal:
    enabled: true
  wiredTiger:
    engineConfig:
      cacheSizeGB: 1
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log
net:
  port: 27017
  bindIp: 127.0.0.1
processManagement:
  timeZoneInfo: /usr/share/zoneinfo
security:
  javascriptEnabled: false
replication:
  replSetName: "rs0"' | sudo tee /etc/mongod.conf

# Step 10: Start MongoDB with the new configuration
sudo mongod --config /etc/mongod.conf


# Restart MongoDB
sudo systemctl restart mongod

# Wait for MongoDB to start
sleep 5

# Step 11: Start the first MongoDB instance
sudo mongod --dbpath "/var/lib/mongodb" --logpath "/var/lib/mongodb/log/mongod.log" --port 27017 --storageEngine=wiredTiger --wiredTigerCacheSizeGB 1 --journal --replSet rs0 --noScripting

# Wait for MongoDB to start
sleep 5

# Start a MongoDB shell on port 27017 and initialize replica set
mongo --port 27017 --eval "
  rsconf={
    _id: 'rs0',
    members: [
      { _id: 0, host: 'localhost:27017' },
      { _id: 1, host: 'localhost:27018' },
      { _id: 2, host: 'localhost:27019', arbiterOnly: true }
    ]
  };
  rs.initiate(rsconf);
  rs.add('localhost:27018');
  rs.add('localhost:27019');
"

# Display replica set status
mongo --port 27017 --eval "rs.status()"

# Setup is complete
echo "MongoDB replica set setup is complete."
