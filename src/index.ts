import express from 'express';
import path from 'path';
import jsxEngine from 'express-engine-jsx';
import dotenv from 'dotenv';
dotenv.config({ override: true });

const PORT = process.env.PORT || 8080;

const app = express();
app.set('views', path.join(process.cwd(), '/ui/pages'));
app.set('view engine', 'jsx');
app.engine('jsx', jsxEngine);

app.use('/static', express.static(path.join(process.cwd(), '/ui/static')));

app.use((_, res, next) => {
    res.locals.lang = process.env.SITE_LANG;
    next();
});

app.get('/', (_, res) => res.render('index.jsx'));

app.listen(PORT);