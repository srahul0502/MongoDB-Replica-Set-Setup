
# MongoDB Replica Set Setup Guide

This guide will help you set up a MongoDB replica set with three members on your local machine. A MongoDB replica set provides high availability and data redundancy. It ensures that your data is safe and accessible even if one of the members goes down.

## Prerequisites

Before getting started, ensure that you have the following prerequisites:

- Ubuntu-based Linux distribution (tested on Ubuntu 20.04)
- Basic knowledge of the Linux command line
- Administrative (sudo) access to your machine

## Step 1: Clone the Repository

```bash
git clone <repository-url>
cd mongodb-replica-set-setup
```

## Step 2: Run the Setup Script

Run the provided setup script to automate the MongoDB replica set configuration:

```bash
chmod +x setup.sh
./setup.sh
```

## Script Breakdown

The script performs the following tasks:

1. **Update System Packages**: Ensures that your system's package information is up to date.

2. **Install Required Packages**: Installs necessary packages (`gnupg` and `curl`) required for the MongoDB installation process.

3. **Add MongoDB GPG Key**: Adds MongoDB's GPG key to verify the authenticity of MongoDB packages.

4. **Add MongoDB Repository**: Adds MongoDB's official repository to your system.

5. **Update System Packages Again**: Updates your system's package list with the MongoDB repository.

6. **Install libssl1.1 Package**: Installs `libssl1.1`, a required library for MongoDB.

7. **Install MongoDB**: Installs MongoDB and starts its service.

8. **Create MongoDB Configuration for Replica Set**: Configures MongoDB by creating a configuration file at `/etc/mongod.conf`. The configuration includes data path, logging settings, network port, and replica set name (`rs0`). JavaScript execution is disabled for security.

9. **Start MongoDB with New Configuration**: Launches MongoDB with the new configuration file.

10. **Restart MongoDB**: Restarts MongoDB to apply configuration changes.

11. **Start the First MongoDB Instance**: Initiates the first MongoDB instance with specific settings, including data path, port, and replica set name.

12. **MongoDB Shell and Initialize Replica Set**: Starts the MongoDB shell on port 27017 and initializes the replica set configuration. It adds a primary member, a secondary member, and an arbiter.

13. **Display Replica Set Status**: Uses the MongoDB shell to display the status of the replica set, confirming that it's set up correctly.

14. **Setup Complete**: A message indicates that the MongoDB replica set setup is complete.

## Access MongoDB

You can access MongoDB using the MongoDB shell:

```bash
mongo --port 27017
```

## Replica Set Configuration

The script sets up a replica set named `rs0` with three members:

- Primary Member (Port 27017)
- Secondary Member (Port 27018)
- Arbiter (Port 27019)

The WiredTiger cache for all members is configured to be 1GB, ensuring efficient data storage and retrieval.

## Maintenance

If you need to stop or restart MongoDB, you can use the following commands:

- To restart MongoDB:
  
  ```bash
  sudo systemctl restart mongod
  ```

- To stop MongoDB:

  ```bash
  sudo systemctl stop mongod
  ```

