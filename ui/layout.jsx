const Header = require('./components/Header');

<html lang={lang}>
    <head>
        <meta charset="UTF-8" />
        <meta httpEquiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="stylesheet" href="/static/style.css" />
        <title>Foody</title>
    </head>
    <body>
        <Header />
        {children}
    </body>
</html>