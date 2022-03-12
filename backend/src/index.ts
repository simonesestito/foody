import express from 'express';
import dotenv from 'dotenv';
import path from 'path';
dotenv.config({ override: true });

const PORT = process.env.PORT || 8080;

const app = express();

app.get('/', (_, res) => res.send('Hello, World!'));

app.use(express.static(
    path.join(__dirname, '..', '..', 'webapp', 'build', 'web')
));

app.listen(PORT, () => console.log('Server running!'));