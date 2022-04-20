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
    telefono VARCHAR(14) PRIMARY KEY CHECK (telefono RLIKE
                                            '^[+]?([0-9]{6}[0-9]*)$'),
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
    FOREIGN KEY (ristorante) REFERENCES Ristorante (id) ON UPDATE CASCADE ON DELETE NO ACTION,
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
    id INT PRIMARY KEY,
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
         RIGHT JOIN OrariDiApertura ON Ristorante.id = OrariDiApertura.ristorante
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
            SELECT CategoriaMenu.id
            FROM CategoriaMenu
                     JOIN ContenutoCategoriaMenu on CategoriaMenu.id = ContenutoCategoriaMenu.categoria);

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
            SELECT CategoriaMenu.id
            FROM CategoriaMenu
                     JOIN ContenutoCategoriaMenu on CategoriaMenu.id = ContenutoCategoriaMenu.categoria);

        -- Controlla che sia rimasta almeno una categoria
        IF NOT EXISTS(SELECT * FROM CategoriaMenu WHERE menu = NEW.id) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Impossibile pubblicare un menu vuoto';
        END IF;
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
    IF EXISTS(SELECT ServizioRider.id
              FROM ServizioRider
                       JOIN OrdineRistorante ON ServizioRider.id = OrdineRistorante.servizio_rider
              WHERE OrdineRistorante.stato = 300
                AND ServizioRider.ora_fine IS NULL
              GROUP BY ServizioRider.id
              HAVING COUNT(DISTINCT OrdineRistorante.id) > 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Più ordini in consegna presenti per lo stesso servizio del rider';
    END IF;
END;

CREATE TRIGGER utente_rider_max_servizi_in_corso
    BEFORE INSERT 
    ON ServizioRider
    FOR EACH ROW
BEGIN
    IF EXISTS(SELECT Utente.id
              FROM ServizioRider
                       JOIN Utente ON ServizioRider.utente = Utente.id
              WHERE ServizioRider.ora_fine IS NULL -- In corso
              GROUP BY Utente.id
              HAVING COUNT(DISTINCT ServizioRider.id) > 1) THEN
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

-- Stored Procedures
DROP PROCEDURE IF EXISTS aggiorna_orari_ristorante;
CREATE PROCEDURE aggiorna_orari_ristorante(IN _ristorante INT, IN _orario TEXT)
    MODIFIES SQL DATA
BEGIN
    DECLARE _line TEXT DEFAULT NULL;
    DECLARE _lineSize INT DEFAULT NULL;
    DECLARE _giorno INT DEFAULT NULL;
    DECLARE _apertura TIME DEFAULT NULL;
    DECLARE _chisura TIME DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
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
    END LOOP;
    COMMIT;
END;


DROP PROCEDURE IF EXISTS inserisci_aggiorna_prodotto;
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


DROP PROCEDURE IF EXISTS inserisci_ordine_utente;
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
    FROM Carrello, Prodotto
    WHERE Carrello.prodotto = Prodotto.id
      AND utente = _cliente;

    DELETE FROM Carrello WHERE utente = _cliente;

    COMMIT;
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

