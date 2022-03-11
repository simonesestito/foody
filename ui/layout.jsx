const MaterialHeader = require('./components/material/MaterialHeader');

const Html5Tags = () => (
    <>
        <meta charset="UTF-8" />
        <meta httpEquiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    </>
);

const MaterialDesign = () => (
    <>
        <link href="https://unpkg.com/material-components-web@latest/dist/material-components-web.min.css" rel="stylesheet" />
        <script src="https://unpkg.com/material-components-web@latest/dist/material-components-web.min.js"></script>
        <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons" />
    </>
);

<html lang={lang}>
    <head>
        <Html5Tags />
        <MaterialDesign />
        <link rel="stylesheet" href="/static/style.css" />
        <title>Foody | {title}</title>
    </head>
    <body>
        <MaterialHeader title={title}>
            <div className="container">
                {children}
            </div>
        </MaterialHeader>
    </body>
</html>