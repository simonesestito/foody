import dotenv from 'dotenv';
dotenv.config({ override: false });

import express, { RequestHandler } from 'express';
import path from 'path';
import nocache from 'nocache';
import * as DB from './db';

const PORT = process.env.PORT || 8081;

const app = express();
app.use(express.json());
app.use(nocache());
app.set('etag', false);
app.use(express.static(
    path.join(__dirname, '..', '..', 'webapp', 'build', 'web'),
    { etag: false },
));

const apiRouter = express.Router();
app.use('/api', apiRouter);

function wrapRoute(action: RequestHandler): RequestHandler {
    return (async (req, res, next) => {
        try {
            // run controllers logic
            await action(req, res, next);
        } catch (e) {
            res.status(500).send({
                error: e.toString(),
            });
        }
    });
}

apiRouter.get('/', wrapRoute(async (_, res) => {
    const result = await DB.dbSelect('SELECT * FROM TestUsers ORDER BY id');
    res.send(result);
}));

apiRouter.get('/:name', wrapRoute(async (req, res) => {
    const newId = await DB.dbInsert('INSERT INTO TestUsers (name) VALUES (?)', [req.params.name]);
    res.send({ newId });
}));


app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}/api/`));
