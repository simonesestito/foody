import express from 'express';
import dotenv from 'dotenv';
dotenv.config({ override: true });

const PORT = process.env.PORT || 8080;

const app = express();

app.get('/', (_, res) => res.send('Hello, World!'));

app.listen(PORT, () => console.log('Server running!'));