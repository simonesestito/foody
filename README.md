# Foody Project
Final project for "Databases" course of Sapienza University of Rome, Spring 2022

# 🚀 [Open the live site](https://foody.simonesestito.com)

# 📚 [Database Documentation (Italian)](https://drive.google.com/drive/folders/135rB56D_wniunaJxY9SCFpWHcEuFZqNz?usp=sharing)

## Build

This project uses Docker Compose to perform tests. You need to install nothing but Docker on your system and you're ready to go.

You can also first build the Flutter app on your own with ```flutter build web```, then start the Node app with ```npm start```. A running MariaDB database is needed, so you'll need to configure it using env variables. Of course, Docker is easier because it's preconfigured.

## Documentation

The project documentation, specifically about the database structure, it's available in Italian at https://drive.google.com/drive/folders/135rB56D_wniunaJxY9SCFpWHcEuFZqNz

## Technologies involved

Since it's a project for the "Databases" course, it's backed by a **MariaDB** database.

The server-side code is written using **TypeScript** and the **express.js** HTTP web framework to provide a REST API.

Frontend code is powered by **Flutter Web**.

Finally, deploy is performed accordingly to the [following section](#production-deploy)

## Production Deploy

It's been designed to be an easy app to deploy and try out, so it's just a single Docker image published on Docker Hub.

Since it also requires a database, you can run the ```docker-compose.yml``` configuration file to run this app in Docker Compose and it'll work out of the box.

You can edit the project, and rebuild it using the associated ```Dockerfile```, which bundles the Flutter Web app and the Typescript rest API all in a single Docker image.

## License

    Foody Project
    Copyright (C) 2022 Simone Sestito

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
