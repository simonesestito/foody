import express from 'express';
import dotenv from 'dotenv';
import path from 'path';
import nocache from 'nocache';
dotenv.config({ override: true });

const PORT = process.env.PORT || 8080;

const app = express();

app.use(nocache());
app.set('etag', false);
app.use(express.static(
    path.join(__dirname, '..', '..', 'webapp', 'build', 'web'),
    { etag: false },
));

app.listen(PORT, () => console.log('Server running!'));
