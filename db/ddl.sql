CREATE TABLE IF NOT EXISTS Ristorante
(
    id                    INT PRIMARY KEY AUTO_INCREMENT,
    nome                  VARCHAR(255) NOT NULL,
    pubblicato            BOOLEAN      NOT NULL DEFAULT TRUE,
    indirizzo_via         VARCHAR(255) NOT NULL,
    indirizzo_civico      VARCHAR(10) CHECK (indirizzo_civico IS NULL OR
                                             indirizzo_civico RLIKE '^([1-9][0-9]*)([-/]?[a-zA-z]*)?$'),
    indirizzo_citta       VARCHAR(64)  NOT NULL,
    indirizzo_latitudine  FLOAT(10, 6) NOT NULL,
    indirizzo_longitudine FLOAT(10, 6) NOT NULL
);

CREATE TABLE IF NOT EXISTS TelefonoRistorante
(
    telefono   VARCHAR(14) NOT NULL CHECK (telefono RLIKE '^[+]?([0-9]{6}[0-9]*)$'),
    ristorante INT         NOT NULL,
    FOREIGN KEY (ristorante) REFERENCES Ristorante (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (telefono, ristorante)
);

CREATE TABLE IF NOT EXISTS OrariDiApertura
(
    giorno     INT  NOT NULL CHECK (giorno >= 0 AND giorno <= 6),
    apertura   TIME NOT NULL,
    chiusura   TIME NOT NULL,
    ristorante INT  NOT NULL,
    FOREIGN KEY (ristorante) REFERENCES Ristorante (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (giorno, ristorante, apertura),
    CONSTRAINT apertura_chiusura CHECK (chiusura > apertura)
);

CREATE TABLE IF NOT EXISTS Menu
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    titolo     VARCHAR(255) NOT NULL,
    pubblicato BOOLEAN      NOT NULL DEFAULT FALSE,
    ristorante INT          NOT NULL,
    FOREIGN KEY (ristorante) REFERENCES Ristorante (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS CategoriaMenu
(
    id     INT PRIMARY KEY AUTO_INCREMENT,
    titolo VARCHAR(255) NOT NULL,
    menu   INT          NOT NULL,
    FOREIGN KEY (menu) REFERENCES Menu (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Prodotto
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    nome        VARCHAR(255) NOT NULL,
    descrizione VARCHAR(255),
    prezzo      FLOAT(10, 2) NOT NULL CHECK (prezzo > 0),
    ristorante  INT,
    FOREIGN KEY (ristorante) REFERENCES Ristorante (id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS ContenutoCategoriaMenu
(
    categoria INT NOT NULL,
    prodotto  INT NOT NULL,
    FOREIGN KEY (categoria) REFERENCES CategoriaMenu (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (prodotto) REFERENCES Prodotto (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Allergene
(
    nome VARCHAR(100) PRIMARY KEY
);
INSERT INTO Allergene (nome)
VALUES ('cereali'),
       ('crostacei'),
       ('uova'),
       ('pesce'),
       ('arachidi'),
       ('soia'),
       ('latte'),
       ('noci'),
       ('sedano'),
       ('senape'),
       ('sesamo'),
       ('solfiti'),
       ('lupini'),
       ('molluschi');

CREATE TABLE IF NOT EXISTS AllergeniProdotto
(
    prodotto  INT          NOT NULL,
    allergene VARCHAR(100) NOT NULL,
    FOREIGN KEY (prodotto) REFERENCES Prodotto (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (allergene) REFERENCES Allergene (nome) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (prodotto, allergene)
);

CREATE TABLE IF NOT EXISTS Utente
(
    id       INT PRIMARY KEY AUTO_INCREMENT,
    nome     VARCHAR(255) NOT NULL,
    cognome  VARCHAR(255) NOT NULL,
    password VARCHAR(60)  NOT NULL CHECK (LENGTH(password) = 60), -- Enforce BCrypt hash length
    rider    BOOLEAN      NOT NULL DEFAULT FALSE,
    admin    BOOLEAN      NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS EmailUtente
(
    utente INT NOT NULL,
    email  VARCHAR(255) PRIMARY KEY CHECK (email RLIKE
                                           '^[a-zA-Z0-9][a-zA-Z0-9._-]*@[a-zA-Z0-9][a-zA-Z0-9._-]*\\.[a-zA-Z]{2,4}$'),
    FOREIGN KEY (utente) REFERENCES Utente (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS TelefonoUtente
(
    utente   INT NOT NULL,
    telefono VARCHAR(14) PRIMARY KEY CHECK (telefono RLIKE '^[+]?([0-9]{6}[0-9]*)$'),
    FOREIGN KEY (utente) REFERENCES Utente (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Carrello
(
    utente   INT NOT NULL,
    prodotto INT NOT NULL,
    quantita INT NOT NULL CHECK ( quantita > 0 AND quantita <= 10 ),
    FOREIGN KEY (utente) REFERENCES Utente (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (prodotto) REFERENCES Prodotto (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (utente, prodotto)
);

CREATE TABLE IF NOT EXISTS SessioneLogin
(
    token      VARCHAR(60) PRIMARY KEY,
    agent      VARCHAR(255) NOT NULL,
    ip         VARCHAR(39)  NOT NULL,
    creazione  DATETIME     NOT NULL DEFAULT NOW(),
    ultimo_uso DATETIME     NOT NULL DEFAULT NOW(),
    utente     INT          NOT NULL,
    FOREIGN KEY (utente) REFERENCES Utente (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS RuoloUtente
(
    ruolo VARCHAR(16) PRIMARY KEY
);

INSERT INTO RuoloUtente (ruolo)
VALUES ('cliente'),
       ('admin'),
       ('rider'),
       ('manager');

CREATE TABLE IF NOT EXISTS RuoliUtente
(
    ruolo  VARCHAR(16) NOT NULL,
    utente INT         NOT NULL,
    PRIMARY KEY (ruolo, utente),
    FOREIGN KEY (ruolo) REFERENCES RuoloUtente (ruolo) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (utente) REFERENCES Utente (id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Recensione
(
    creazione  DATETIME NOT NULL,
    voto       INT      NOT NULL CHECK (voto >= 1 AND voto <= 5),
    titolo     VARCHAR(255),
    testo      VARCHAR(255),
    ristorante INT,
    utente     INT,
    FOREIGN KEY (ristorante) REFERENCES Ristorante (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (utente) REFERENCES Utente (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (utente, ristorante)
);

CREATE TABLE IF NOT EXISTS GestioneOrdini
(
    data_inizio DATETIME NOT NULL,
    data_fine   DATETIME,
    utente      INT      NOT NULL,
    ristorante  INT,
    FOREIGN KEY (utente) REFERENCES Utente (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ristorante) REFERENCES Ristorante (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (utente, ristorante, data_inizio),
    CONSTRAINT data_inizio_fine CHECK (data_fine IS NULL OR data_fine > data_inizio)
);

CREATE TABLE IF NOT EXISTS ServizioRider
(
    id                 INT PRIMARY KEY AUTO_INCREMENT,
    utente             INT          NOT NULL,
    ora_inizio         DATETIME     NOT NULL,
    latitudine_inizio  FLOAT(10, 6) NOT NULL,
    longitudine_inizio FLOAT(10, 6) NOT NULL,
    ora_fine           DATETIME,
    latitudine_fine    FLOAT(10, 6),
    longitudine_fine   FLOAT(10, 6),
    FOREIGN KEY (utente) REFERENCES Utente (id) ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE (utente, ora_inizio),
    CONSTRAINT ora_inizio_fine CHECK (ora_fine IS NULL OR ora_fine > ora_inizio)
);

CREATE TABLE IF NOT EXISTS StatoOrdine
(
    id   INT PRIMARY KEY,
    nome VARCHAR(16) NOT NULL UNIQUE
);
INSERT INTO StatoOrdine (id, nome)
VALUES (100, 'preparing'),
       (200, 'prepared'),
       (300, 'delivering'),
       (400, 'delivered');

CREATE TABLE IF NOT EXISTS OrdineRistorante
(
    id                    INT PRIMARY KEY AUTO_INCREMENT,
    stato                 INT          NOT NULL DEFAULT 100,
    creazione             DATETIME     NOT NULL DEFAULT NOW(),
    note                  VARCHAR(255),
    indirizzo_via         VARCHAR(255) NOT NULL,
    indirizzo_civico      VARCHAR(10) CHECK (indirizzo_civico IS NULL OR
                                             indirizzo_civico RLIKE '^([1-9][0-9]*)([-/]?[a-zA-z]*)?$'),
    indirizzo_citta       VARCHAR(64)  NOT NULL,
    indirizzo_latitudine  FLOAT(10, 6) NOT NULL,
    indirizzo_longitudine FLOAT(10, 6) NOT NULL,
    utente                INT,
    servizio_rider        INT,
    FOREIGN KEY (stato) REFERENCES StatoOrdine (id) ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (utente) REFERENCES Utente (id) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (servizio_rider) REFERENCES ServizioRider (id) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS ContenutoOrdine
(
    prodotto          INT NOT NULL,
    ordine_ristorante INT,
    quantita          INT NOT NULL CHECK (quantita > 0 AND quantita < 10),
    FOREIGN KEY (prodotto) REFERENCES Prodotto (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ordine_ristorante) REFERENCES OrdineRistorante (id) ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (prodotto, ordine_ristorante)
);

-- Views
CREATE VIEW DettagliRistorante AS
SELECT Ristorante.*,
       OrariDiApertura.apertura,
       OrariDiApertura.chiusura,
       OrariDiApertura.giorno,
       TelefonoRistorante.telefono,
       R.voto_medio
FROM Ristorante
         LEFT JOIN OrariDiApertura ON Ristorante.id = OrariDiApertura.ristorante
         LEFT JOIN TelefonoRistorante ON Ristorante.id = TelefonoRistorante.ristorante
         LEFT JOIN (SELECT Ristorante.id, AVG(Recensione.voto) as voto_medio
                    FROM Ristorante
                             LEFT JOIN Recensione ON Ristorante.id = Recensione.ristorante) R ON Ristorante.id = R.id;

CREATE VIEW RistorantiConMenu AS
SELECT DettagliRistorante.*,
       Menu.titolo     AS titolo_menu,
       Menu.pubblicato AS menu_pubblicato,
       Menu.id         AS menu_id,
       MC.id           AS categoria_id,
       MC.titolo       AS categoria_titolo,
       P.id            AS prodotto_id,
       P.nome          AS prodotto_nome,
       P.descrizione   AS prodotto_descrizione,
       P.prezzo        AS prodotto_prezzo,
       AP.allergene
FROM DettagliRistorante
         LEFT JOIN Menu ON Menu.ristorante = DettagliRistorante.id
         LEFT JOIN CategoriaMenu MC ON Menu.id = MC.menu
         LEFT JOIN ContenutoCategoriaMenu MCC on MC.id = MCC.categoria
         LEFT JOIN Prodotto P on P.id = MCC.prodotto
         LEFT JOIN AllergeniProdotto AP on P.id = AP.prodotto;

CREATE VIEW DettagliUtente AS
SELECT Utente.*, EU.email, TU.telefono, COALESCE(NumeroRistoranti.numero_ristoranti, 0) AS numero_ristoranti
FROM Utente
         LEFT JOIN EmailUtente EU on Utente.id = EU.utente
         LEFT JOIN TelefonoUtente TU on Utente.id = TU.utente
         LEFT JOIN (
    SELECT utente, COUNT(ristorante) AS numero_ristoranti
    FROM GestioneOrdini
    WHERE data_fine IS NULL
    GROUP BY utente
) AS NumeroRistoranti ON Utente.id = NumeroRistoranti.utente
GROUP BY Utente.id, EU.email, TU.telefono;

CREATE VIEW DettagliCategoria AS
SELECT CategoriaMenu.*, COUNT(DISTINCT Prodotto.id) AS numero_prodotti
FROM CategoriaMenu
         LEFT JOIN ContenutoCategoriaMenu ON CategoriaMenu.id = ContenutoCategoriaMenu.categoria
         LEFT JOIN Prodotto ON ContenutoCategoriaMenu.prodotto = Prodotto.id
GROUP BY CategoriaMenu.id;

-- Triggers
CREATE TRIGGER IF NOT EXISTS orario_apertura_sovrapposto_insert
    BEFORE INSERT
    ON OrariDiApertura
    FOR EACH ROW
BEGIN
    -- Check sulla sovrapposizione di orari
    IF EXISTS(SELECT *
              FROM OrariDiApertura
              WHERE ristorante = NEW.ristorante
                AND giorno = NEW.giorno
                AND (apertura BETWEEN NEW.apertura AND NEW.chiusura OR
                     chiusura BETWEEN NEW.apertura AND NEW.chiusura)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conflitto nel nuovo orario, si presenta sovrapposizione';
    END IF;
END;

CREATE TRIGGER IF NOT EXISTS orario_apertura_sovrapposto_update
    BEFORE UPDATE
    ON OrariDiApertura
    FOR EACH ROW
BEGIN
    -- Check sulla sovrapposizione di orari
    IF EXISTS(SELECT *
              FROM OrariDiApertura
              WHERE ristorante = NEW.ristorante
                AND giorno = NEW.giorno
                AND apertura <> OLD.apertura -- Non lo stesso orario
                AND (apertura BETWEEN NEW.apertura AND NEW.chiusura OR
                     chiusura BETWEEN NEW.apertura AND NEW.chiusura)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Conflitto nel nuovo orario, si presenta sovrapposizione';
    END IF;
END;

CREATE TRIGGER IF NOT EXISTS ordinazione_singolo_ristorante_insert
    AFTER INSERT
    ON ContenutoOrdine
    FOR EACH ROW
BEGIN
    IF (SELECT COUNT(DISTINCT ristorante)
        FROM Prodotto,
             ContenutoOrdine
        WHERE NEW.ordine_ristorante = ContenutoOrdine.ordine_ristorante
          AND ContenutoOrdine.prodotto = Prodotto.id) > 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un ordine non deve contenere prodotti di ristoranti diversi';
    END IF;
END;

CREATE TRIGGER IF NOT EXISTS contenuto_categoria_stesso_ristorante
    BEFORE INSERT
    ON ContenutoCategoriaMenu
    FOR EACH ROW
BEGIN
    IF EXISTS(SELECT *
              FROM CategoriaMenu,
                   Menu,
                   Prodotto
              WHERE CategoriaMenu.id = NEW.categoria
                AND Menu.id = CategoriaMenu.menu
                AND Prodotto.id = NEW.prodotto
                AND Prodotto.ristorante <> Menu.ristorante) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
                'Una categoria deve contenere prodotti dello stesso ristorante del menù';
    END IF;
END;

CREATE TRIGGER IF NOT EXISTS recensione_da_cliente
    BEFORE INSERT
    ON Recensione
    FOR EACH ROW
BEGIN
    IF NOT EXISTS(SELECT *
                  FROM OrdineRistorante
                           JOIN ContenutoOrdine on OrdineRistorante.id = ContenutoOrdine.ordine_ristorante
                           JOIN Prodotto on ContenutoOrdine.prodotto = Prodotto.id
                  WHERE OrdineRistorante.utente = NEW.utente
                    AND Prodotto.ristorante = NEW.ristorante
                    AND OrdineRistorante.stato >= 400) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
                'Una recensione può essere scritta solo su ristoranti presso cui sono stati fatti ordini consegnati';
    END IF;
END;

CREATE TRIGGER IF NOT EXISTS menu_pubblicato_non_vuoto_insert
    BEFORE INSERT
    ON Menu
    FOR EACH ROW
BEGIN
    IF NEW.pubblicato = 1 THEN
        -- Rimuovi categorie vuote
        DELETE
        FROM CategoriaMenu
        WHERE menu = NEW.id
          AND id NOT IN (
            -- Categorie con almeno un prodotto
            SELECT categoria
            FROM ContenutoCategoriaMenu);

        -- Controlla che sia rimasta una categoria
        IF NOT EXISTS(SELECT * FROM CategoriaMenu WHERE menu = NEW.id) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Impossibile pubblicare un menu vuoto';
        END IF;
    END IF;
END;

CREATE TRIGGER IF NOT EXISTS menu_pubblicato_non_vuoto_update
    BEFORE UPDATE
    ON Menu
    FOR EACH ROW
BEGIN
    IF NEW.pubblicato = 1 AND OLD.pubblicato = 0 THEN
        -- Rimuovi categorie vuote
        DELETE
        FROM CategoriaMenu
        WHERE menu = NEW.id
          AND id NOT IN (
            -- Categorie con almeno un prodotto
            SELECT categoria
            FROM ContenutoCategoriaMenu);

        -- Controlla che sia rimasta almeno una categoria
        IF NOT EXISTS(SELECT * FROM CategoriaMenu WHERE menu = NEW.id) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Impossibile pubblicare un menu vuoto';
        END IF;
    END IF;
END;

CREATE TRIGGER IF NOT EXISTS menu_pubblicato_non_vuoto_categorie_delete
    BEFORE DELETE
    ON CategoriaMenu
    FOR EACH ROW
BEGIN
    IF (SELECT Menu.pubblicato FROM Menu WHERE Menu.id = OLD.menu) = 1 AND
       (SELECT COUNT(*) FROM CategoriaMenu WHERE menu = OLD.menu) = 1 THEN
        -- Il menu è pubblicato e questa era l'ultima categoria rimasta
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Impossibile rimuovere l\'ultima categoria di un menu pubblicato';
    END IF;
END;

CREATE TRIGGER ristorante_max_menu_pubblicato_insert
    BEFORE INSERT
    ON Menu
    FOR EACH ROW FOLLOWS menu_pubblicato_non_vuoto_insert
BEGIN
    IF NEW.pubblicato = 1 AND EXISTS(SELECT * FROM Menu WHERE pubblicato = 1 AND ristorante = NEW.ristorante) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esiste già un altro menu pubblicato.';
    END IF;
END;

CREATE TRIGGER ristorante_max_menu_pubblicato_update
    BEFORE UPDATE
    ON Menu
    FOR EACH ROW FOLLOWS menu_pubblicato_non_vuoto_update
BEGIN
    IF NEW.pubblicato = 1 AND OLD.pubblicato = 0 AND
       EXISTS(SELECT * FROM Menu WHERE pubblicato = 1 AND ristorante = NEW.ristorante) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esiste già un altro menu pubblicato.';
    END IF;
END;

CREATE TRIGGER affidamento_consegna_max_consegne_per_servizio
    BEFORE UPDATE
    ON OrdineRistorante
    FOR EACH ROW
BEGIN
    IF NEW.servizio_rider IS NOT NULL AND OLD.servizio_rider <> NEW.servizio_rider THEN
        IF (SELECT COUNT(DISTINCT OrdineRistorante.id)
            FROM OrdineRistorante
                     JOIN ServizioRider SR on OrdineRistorante.servizio_rider = SR.id
            WHERE servizio_rider = NEW.servizio_rider
              AND SR.ora_fine IS NULL) > 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
                    'Più ordini in consegna presenti per lo stesso servizio del rider';
        END IF;
    END IF;
END;

CREATE TRIGGER utente_rider_max_servizi_in_corso
    BEFORE INSERT
    ON ServizioRider
    FOR EACH ROW
BEGIN
    IF EXISTS(SELECT ServizioRider.id FROM ServizioRider WHERE utente = NEW.utente AND ora_fine IS NULL) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esiste già un servizio in corso per il rider';
    END IF;
END;

CREATE TRIGGER IF NOT EXISTS stato_ordinazione_crescente
    BEFORE UPDATE
    ON OrdineRistorante
    FOR EACH ROW
BEGIN
    IF (NEW.stato < OLD.stato) THEN SET NEW.stato = OLD.stato; END IF;
END;

CREATE TRIGGER IF NOT EXISTS singola_assunzione_gestione_ordini
    BEFORE INSERT
    ON GestioneOrdini
    FOR EACH ROW
BEGIN
    IF (NEW.data_fine IS NULL AND EXISTS(SELECT *
                                         FROM GestioneOrdini
                                         WHERE utente = NEW.utente
                                           AND ristorante = NEW.ristorante
                                           AND data_fine IS NULL)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Il dipendente risulta già assunto al momento';
    END IF;
END;

CREATE TRIGGER IF NOT EXISTS stato_ordinazione_con_rider
    BEFORE UPDATE
    ON OrdineRistorante
    FOR EACH ROW
BEGIN
    IF (NEW.stato >= 300 AND NEW.servizio_rider IS NULL) OR
       (SELECT ora_fine FROM ServizioRider WHERE id = NEW.servizio_rider) IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =
                'Non puoi eseguire la consegna di quest\'ordine, nessun servizio attivo.';
    END IF;

    IF (NEW.stato < 300) THEN SET NEW.servizio_rider = NULL; END IF;
END;

CREATE TRIGGER IF NOT EXISTS chisura_servizio_rider_incompleto
    BEFORE UPDATE
    ON ServizioRider
    FOR EACH ROW
BEGIN
    IF (NEW.ora_fine IS NOT NULL AND OLD.ora_fine IS NULL) THEN
        -- Consegna gli ordini, attualmente rimasti in consegna
        UPDATE OrdineRistorante SET stato = 400 WHERE stato < 400 AND servizio_rider = NEW.id;
    END IF;
END;

-- Stored Procedures
CREATE PROCEDURE aggiorna_orari_ristorante(IN _ristorante INT, IN _orario TEXT)
    MODIFIES SQL DATA
BEGIN
    DECLARE _line TEXT DEFAULT NULL;
    DECLARE _lineSize INT DEFAULT NULL;
    DECLARE _giorno INT DEFAULT NULL;
    DECLARE _apertura TIME DEFAULT NULL;
    DECLARE _chisura TIME DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    DELETE FROM OrariDiApertura WHERE OrariDiApertura.ristorante = _ristorante;

    orario_linee:
    LOOP
        IF CHAR_LENGTH(_orario) = 0 THEN LEAVE orario_linee; END IF;
        SET _line = SUBSTRING_INDEX(_orario, '\n', 1);
        SET _lineSize = CHAR_LENGTH(_line);

        SET _giorno = SUBSTRING_INDEX(_line, ',', 1);
        SET _apertura = SUBSTRING_INDEX(SUBSTR(_line, CHAR_LENGTH(_giorno) + 2), ',', 1);
        SET _chisura = SUBSTRING_INDEX(SUBSTR(_line, CHAR_LENGTH(_giorno) + CHAR_LENGTH(_apertura) + 3), ',', 1);

        INSERT INTO OrariDiApertura (giorno, apertura, chiusura, ristorante)
        VALUES (_giorno, _apertura, _chisura, _ristorante);

        SET _orario = SUBSTR(_orario, CHAR_LENGTH(_line) + 2);
    END LOOP; COMMIT;
END;


CREATE PROCEDURE inserisci_aggiorna_prodotto(IN _id INT, IN _nome TEXT, IN _descrizione TEXT, IN _prezzo FLOAT(10, 2),
                                             IN _ristorante INT, IN _allergeni TEXT)
    MODIFIES SQL DATA
BEGIN
    DECLARE _line TEXT DEFAULT NULL;
    DECLARE _lineSize INT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    IF _id IS NULL OR _id < 0 THEN
        INSERT INTO Prodotto (nome, descrizione, prezzo, ristorante) VALUES (_nome, _descrizione, _prezzo, _ristorante);
        SELECT LAST_INSERT_ID() INTO _id;
    ELSE
        DELETE FROM AllergeniProdotto WHERE prodotto = _id;
        UPDATE Prodotto
        SET nome = _nome, descrizione = _descrizione, prezzo = _prezzo, ristorante = _ristorante
        WHERE id = _id;
    END IF;

    allergeni_linee:
    LOOP
        IF CHAR_LENGTH(_allergeni) = 0 THEN LEAVE allergeni_linee; END IF;
        SET _line = SUBSTRING_INDEX(_allergeni, '\n', 1);
        SET _lineSize = CHAR_LENGTH(_line);

        INSERT INTO AllergeniProdotto (prodotto, allergene) VALUES (_id, TRIM(_line));

        SET _allergeni = SUBSTR(_allergeni, CHAR_LENGTH(_line) + 2);
    END LOOP; COMMIT;
END;


CREATE PROCEDURE inserisci_ordine_utente(
    IN _note TEXT,
    IN _via TEXT,
    IN _civico TEXT,
    IN _citta TEXT,
    IN _latitudine FLOAT(10, 6),
    IN _longitudine FLOAT(10, 6),
    IN _cliente INT)
    MODIFIES SQL DATA
BEGIN
    DECLARE _orderId INT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO OrdineRistorante (note, indirizzo_via, indirizzo_civico, indirizzo_citta, indirizzo_latitudine,
                                  indirizzo_longitudine, utente, servizio_rider)
    VALUES (_note, _via, _civico, _citta, _latitudine, _longitudine, _cliente, NULL);

    SELECT LAST_INSERT_ID() INTO _orderId;

    INSERT INTO ContenutoOrdine (prodotto, ordine_ristorante, quantita)
    SELECT prodotto, _orderId, quantita
    FROM Carrello,
         Prodotto
    WHERE Carrello.prodotto = Prodotto.id
      AND utente = _cliente;

    DELETE FROM Carrello WHERE utente = _cliente; COMMIT;
END;

CREATE PROCEDURE registra_utente(IN _nome TEXT, IN _cognome TEXT, IN _password VARCHAR(60), IN _email TEXT,
                                 IN _telefono TEXT)
    MODIFIES SQL DATA
BEGIN
    DECLARE _userId INT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    INSERT INTO Utente (nome, cognome, password) VALUES (_nome, _cognome, _password);
    SELECT LAST_INSERT_ID() INTO _userId;
    INSERT INTO EmailUtente (utente, email) VALUES (_userId, _email);
    INSERT INTO TelefonoUtente (utente, telefono) VALUES (_userId, _telefono); COMMIT;
END;

CREATE PROCEDURE aggiorna_utente(IN _id INT, IN _name TEXT, IN _surname TEXT, IN _password TEXT, IN _rider TINYINT,
                                 IN _admin TINYINT, IN _emails TEXT, IN _phones TEXT)
    MODIFIES SQL DATA
BEGIN
    DECLARE _line TEXT DEFAULT NULL;
    DECLARE _lineSize INT DEFAULT NULL;
    DECLARE _hasLine TINYINT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    UPDATE Utente
    SET nome = _name,
        cognome = _surname,
        password = COALESCE(_password, password),
        rider = _rider,
        admin = _admin
    WHERE id = _id;

    DELETE FROM EmailUtente WHERE utente = _id;
    email_linee:
    LOOP
        IF CHAR_LENGTH(_emails) = 0 THEN LEAVE email_linee; END IF;
        SET _hasLine = 1;
        SET _line = SUBSTRING_INDEX(_emails, '\n', 1);
        SET _lineSize = CHAR_LENGTH(_line);

        INSERT INTO EmailUtente (utente, email) VALUES (_id, TRIM(_line));

        SET _emails = SUBSTR(_emails, CHAR_LENGTH(_line) + 2);
    END LOOP;

    IF _hasLine = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un utente deve avere almeno un indirizzo email';
    END IF;

    DELETE FROM TelefonoUtente WHERE utente = _id;
    SET _hasLine = 0;
    telefono_linee:
    LOOP
        IF CHAR_LENGTH(_phones) = 0 THEN LEAVE telefono_linee; END IF;
        SET _hasLine = 1;
        SET _line = SUBSTRING_INDEX(_phones, '\n', 1);
        SET _lineSize = CHAR_LENGTH(_line);

        INSERT INTO TelefonoUtente (utente, telefono) VALUES (_id, TRIM(_line));

        SET _phones = SUBSTR(_phones, CHAR_LENGTH(_line) + 2);
    END LOOP;

    IF _hasLine = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un utente deve avere almeno un numero di telefono';
    END IF;

    COMMIT;
END;

CREATE PROCEDURE aggiorna_dati_ristorante(
    IN _id INT,
    IN _name TEXT,
    IN _published TINYINT,
    IN _phones TEXT,
    IN _addressStreet TEXT,
    IN _addressHouseNumber TEXT,
    IN _addressCity TEXT,
    IN _latitude FLOAT(10, 6),
    IN _longitude FLOAT(10, 6))
    MODIFIES SQL DATA
BEGIN
    DECLARE _line TEXT DEFAULT NULL;
    DECLARE _lineSize INT DEFAULT NULL;
    DECLARE _hasLine TINYINT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    UPDATE Ristorante
    SET nome = _name,
        pubblicato = _published,
        indirizzo_via = _addressStreet,
        indirizzo_civico = _addressHouseNumber,
        indirizzo_citta = _addressCity,
        indirizzo_longitudine = _longitude,
        indirizzo_latitudine = _latitude
    WHERE id = _id;

    DELETE FROM TelefonoRistorante WHERE ristorante = _id;
    SET _hasLine = 0;
    telefono_linee:
    LOOP
        IF CHAR_LENGTH(_phones) = 0 THEN LEAVE telefono_linee; END IF;
        SET _hasLine = 1;
        SET _line = SUBSTRING_INDEX(_phones, '\n', 1);
        SET _lineSize = CHAR_LENGTH(_line);

        INSERT INTO TelefonoRistorante (ristorante, telefono) VALUES (_id, TRIM(_line));

        SET _phones = SUBSTR(_phones, CHAR_LENGTH(_line) + 2);
    END LOOP;

    IF _hasLine = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un ristorante deve avere almeno un numero di telefono';
    END IF; COMMIT;
END;

CREATE PROCEDURE inserisci_ristorante(
    IN _name TEXT,
    IN _published TINYINT,
    IN _phones TEXT,
    IN _addressStreet TEXT,
    IN _addressHouseNumber TEXT,
    IN _addressCity TEXT,
    IN _latitude FLOAT(10, 6),
    IN _longitude FLOAT(10, 6),
    IN _managerEmail TEXT)
    MODIFIES SQL DATA
BEGIN
    DECLARE _id INT DEFAULT NULL;
    DECLARE _line TEXT DEFAULT NULL;
    DECLARE _lineSize INT DEFAULT NULL;
    DECLARE _hasLine TINYINT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    INSERT INTO Ristorante (nome, pubblicato, indirizzo_via, indirizzo_civico, indirizzo_citta, indirizzo_latitudine,
                            indirizzo_longitudine)
    VALUES (_name, _published, _addressStreet, _addressHouseNumber, _addressCity, _latitude, _longitude);

    SELECT LAST_INSERT_ID() INTO _id;

    INSERT INTO GestioneOrdini (data_inizio, utente, ristorante)
    VALUES (NOW(), (SELECT utente FROM EmailUtente WHERE email = _managerEmail), _id);

    SET _hasLine = 0;
    telefono_linee:
    LOOP
        IF CHAR_LENGTH(_phones) = 0 THEN LEAVE telefono_linee; END IF;
        SET _hasLine = 1;
        SET _line = SUBSTRING_INDEX(_phones, '\n', 1);
        SET _lineSize = CHAR_LENGTH(_line);

        INSERT INTO TelefonoRistorante (ristorante, telefono) VALUES (_id, TRIM(_line));

        SET _phones = SUBSTR(_phones, CHAR_LENGTH(_line) + 2);
    END LOOP;

    IF _hasLine = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Un ristorante deve avere almeno un numero di telefono';
    END IF; COMMIT;
END;

-- Apply the haversine formula to calculate
-- the distance between 2 points on Earth in KMs
DROP FUNCTION IF EXISTS DISTANCE_KM;
DELIMITER $$
CREATE FUNCTION DISTANCE_KM(lat0 FLOAT(10, 6),
                            lon0 FLOAT(10, 6),
                            lat1 FLOAT(10, 6),
                            lon1 FLOAT(10, 6)) RETURNS FLOAT(10, 3)
    DETERMINISTIC
BEGIN
    DECLARE lat1Rad FLOAT(10, 9);
    DECLARE lat0Rad FLOAT(10, 9);
    DECLARE deltaLon FLOAT(10, 9);

    SET lat1Rad = radians(lat1);
    SET lat0Rad = radians(lat0);
    SET deltaLon = radians(lon1 - lon0);

    RETURN 6371 * acos(sin(lat0Rad) * sin(lat1Rad) + cos(lat0Rad) * cos(lat1Rad) * cos(deltaLon));
END$$
DELIMITER ;

