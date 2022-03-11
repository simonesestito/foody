const MaterialIcon = require('./MaterialIcon');

const OptionalIcons = (props) => {
    if (props.icons) {
        return (
            <section class="mdc-top-app-bar__section mdc-top-app-bar__section--align-end" role="toolbar">
                {props.icons.map(icon => <MaterialIcon name={icon} />)}
            </section>
        );
    } else {
        return (<></>);
    }
};

<>
    <header class="mdc-top-app-bar">
        <div class="mdc-top-app-bar__row">
            <section class="mdc-top-app-bar__section mdc-top-app-bar__section--align-start">
                <button class="material-icons mdc-top-app-bar__navigation-icon mdc-icon-button" aria-label="Open navigation menu">menu</button>
                <span class="mdc-top-app-bar__title">{title}</span>
            </section>
            <OptionalIcons />
        </div>
    </header>
    <main class="mdc-top-app-bar--fixed-adjust">
        {children}
    </main>
</>