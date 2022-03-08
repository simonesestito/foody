import express from 'express';

const PORT = process.env.PORT || 8080;

const app = express();

app.get('/', (_, res) => res.send('Hello, World!'));

app.listen(PORT);