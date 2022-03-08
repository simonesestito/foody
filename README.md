# Foody Project
Final project for "Databases" course of Sapienza University of Rome, Spring 2022

# 🚀 [Open the live site](https://foody.simonesestito.com)

# 📚 [Database Documentation (Italian)](https://drive.google.com/drive/folders/135rB56D_wniunaJxY9SCFpWHcEuFZqNz?usp=sharing)

## Build

This project uses Docker Compose to perform tests. You need to install nothing but Docker on your system and you're ready to go.

## Documentation

The project documentation, specifically about the database structure, it's available in Italian at https://drive.google.com/drive/folders/135rB56D_wniunaJxY9SCFpWHcEuFZqNz

## Technologies involved

Since it's a project for the "Databases" course, it's backed by a **MariaDB** database.

The server-side code is written in **TypeScript**, using the **express.js** HTTP web framework. It uses the **ejs** template engine to render web pages directly on the server.

Finally, deploy is performed accordingly to the [following section](#production-deploy)

## Production Deploy

It's been designed to be a cloud-ready app.

Because of that, it's deployed using Docker running on **Azure Web Apps** and it connects to an **Azure SQL** managed database.