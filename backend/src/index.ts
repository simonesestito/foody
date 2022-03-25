import dotenv from 'dotenv';
dotenv.config({ override: false });

import express, { RequestHandler } from 'express';
import path from 'path';
import nocache from 'nocache';
import { apiRouter } from './api';

const PORT = process.env.PORT || 8081;

const app = express();
app.use(express.json());
app.use(nocache());
app.set('etag', false);
app.use(express.static(
    path.join(__dirname, '..', '..', 'webapp', 'build', 'web'),
    { etag: false },
));

app.use('/api', apiRouter);

app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}/api/`));
