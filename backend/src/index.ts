import dotenv from 'dotenv';
// Both environment configurations
dotenv.config({ path: '.env', override: false });
dotenv.config({ path: '../.env', override: true, debug: true });

import express from 'express';
import path from 'path';
import nocache from 'nocache';
import { apiRouter } from './api';

const PORT = process.env.PORT || 8081;

const app = express();
app.use(express.json());
app.use(nocache());
app.use(privateNetworkCors);
app.set('etag', false);
app.use(express.static(
    path.join(__dirname, '..', '..', 'webapp', 'build', 'web'),
    { etag: false },
));

console.log(process.env.NODE_ENV);

app.use('/api', apiRouter);

function privateNetworkCors(req, res, next) {
    if (process.env.NODE_ENV === 'development') {
        res.set({
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Private-Network': 'true'
        });
    }
    next();
}

app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}/api/`));
