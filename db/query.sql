--
-- OPERAZIONE 1: elenco_ristoranti
-- Per ogni ristorante, mostrare il nome, il voto medio delle recensioni e gli orari di apertura
--
SELECT Ristorante.*, OrariDiApertura.apertura, OrariDiApertura.chiusura, OrariDiApertura.giorno, R.voto_medio
FROM Ristorante
         LEFT JOIN OrariDiApertura ON Ristorante.id = OrariDiApertura.ristorante
         LEFT JOIN (SELECT ristorante, AVG(voto) as voto_medio FROM Recensione) R ON Ristorante.id = R.ristorante;

--
-- OPERAZIONE 2: manager_email
-- Per ogni utente, mostrare il numero di ristoranti che al momento gestisce e gli indirizzi e-mail
--
SELECT Utente.*, EU.email, COALESCE(NumeroRistoranti.numero_ristoranti, 0) AS numero_ristoranti
FROM Utente
         LEFT JOIN (SELECT utente, COUNT(ristorante) AS numero_ristoranti
                    FROM GestioneOrdini
                    WHERE data_fine IS NULL
                    GROUP BY utente) AS NumeroRistoranti ON Utente.id = NumeroRistoranti.utente
         LEFT JOIN EmailUtente EU on Utente.id = EU.utente;

--
-- OPERAZIONE 2, con le viste
--
CREATE OR REPLACE VIEW NumeroRistoranti AS
SELECT utente, COUNT(ristorante) AS numero_ristoranti
FROM GestioneOrdini
WHERE data_fine IS NULL
GROUP BY utente;

SELECT Utente.*, EU.email, COALESCE(NumeroRistoranti.numero_ristoranti, 0) AS numero_ristoranti
FROM Utente
         LEFT JOIN NumeroRistoranti ON Utente.id = NumeroRistoranti.utente
         LEFT JOIN EmailUtente EU on Utente.id = EU.utente;

--
-- OPERAZIONE 3: incasso_max_ordini
-- Incasso totale dei ristoranti aventi più ordini
--
SELECT ristorante, SUM(Prodotto.prezzo) AS totale_incassi
FROM OrdineRistorante,
     ContenutoOrdine,
     Prodotto
WHERE ContenutoOrdine.ordine_ristorante = OrdineRistorante.id
  AND Prodotto.id = ContenutoOrdine.prodotto
GROUP BY Prodotto.ristorante
HAVING COUNT(DISTINCT OrdineRistorante.id) >= ALL (SELECT COUNT(DISTINCT OrdineRistorante.id) AS numero_ordini
                                                   FROM OrdineRistorante,
                                                        ContenutoOrdine,
                                                        Prodotto
                                                   WHERE ContenutoOrdine.ordine_ristorante = OrdineRistorante.id
                                                     AND Prodotto.id = ContenutoOrdine.prodotto
                                                   GROUP BY Prodotto.ristorante);

--
-- OPERAZIONE 3, con le viste
--
CREATE OR REPLACE VIEW TotOrdiniPerRistorante AS
SELECT Prodotto.ristorante, COUNT(DISTINCT OrdineRistorante.id) AS numero_ordini
FROM OrdineRistorante,
     ContenutoOrdine,
     Prodotto
WHERE ContenutoOrdine.ordine_ristorante = OrdineRistorante.id
  AND Prodotto.id = ContenutoOrdine.prodotto
GROUP BY Prodotto.ristorante;

SELECT ristorante, SUM(Prodotto.prezzo) AS totale_incassi
FROM OrdineRistorante,
     ContenutoOrdine,
     Prodotto
WHERE ContenutoOrdine.ordine_ristorante = OrdineRistorante.id
  AND Prodotto.id = ContenutoOrdine.prodotto
GROUP BY Prodotto.ristorante
HAVING COUNT(DISTINCT OrdineRistorante.id) >= ALL (SELECT numero_ordini FROM TotOrdiniPerRistorante);


--
-- OPERAZIONE 4: licenziati_grandi_ristoranti
-- Per ogni ristorante aperto almeno 20 ore a settimana, il numero di lavoratori licenziati
--
SELECT GestioneOrdini.ristorante, COUNT(DISTINCT GestioneOrdini.utente) AS numero_licenziati
FROM GestioneOrdini
         LEFT JOIN (SELECT Ristorante.id,
                           COALESCE(SUM(TIMEDIFF(TIME_TO_SEC(chiusura), TIME_TO_SEC(apertura))), 0) / 3600 AS ore_aperte
                    FROM Ristorante
                             LEFT JOIN OrariDiApertura ON Ristorante.id = OrariDiApertura.ristorante
                    GROUP BY Ristorante.id) AS OreAperto ON OreAperto.id = GestioneOrdini.ristorante
WHERE GestioneOrdini.data_fine IS NOT NULL
  AND OreAperto.ore_aperte > 20
GROUP BY GestioneOrdini.ristorante;

--
-- OPERAZIONE 5: apertura_tante_categorie
-- Quante ore è aperto ciascun ristorante che ha il massimo numero di categorie nel menu
--
SELECT OrariDiApertura.ristorante,
       OrariDiApertura.giorno,
       COALESCE(SUM(TIMEDIFF(TIME_TO_SEC(chiusura), TIME_TO_SEC(apertura))), 0) / 3600 AS ore_aperto
FROM OrariDiApertura,
     -- Ogni ristorante, quante categorie ha
     (SELECT Menu.ristorante, COUNT(DISTINCT CategoriaMenu.id) AS numero_categorie
      FROM Menu,
           CategoriaMenu
      WHERE CategoriaMenu.menu = Menu.id
      GROUP BY Menu.ristorante) AS NumeroCategorie
WHERE NumeroCategorie.ristorante = OrariDiApertura.ristorante
  AND NumeroCategorie.numero_categorie >= ALL (
    -- Il massimo numero di categorie
    SELECT COUNT(DISTINCT CategoriaMenu.id) AS numero_categorie
    FROM Menu,
         CategoriaMenu
    WHERE CategoriaMenu.menu = Menu.id
    GROUP BY Menu.ristorante)
GROUP BY OrariDiApertura.ristorante, OrariDiApertura.giorno;

--
-- OPERAZIONE 5, con le viste
--
CREATE OR REPLACE VIEW NumeroCategorie AS
SELECT Menu.ristorante, COUNT(DISTINCT CategoriaMenu.id) AS numero_categorie
FROM Menu,
     CategoriaMenu
WHERE CategoriaMenu.menu = Menu.id
GROUP BY Menu.ristorante;

SELECT OrariDiApertura.ristorante,
       OrariDiApertura.giorno,
       COALESCE(SUM(TIMEDIFF(TIME_TO_SEC(chiusura), TIME_TO_SEC(apertura))), 0) / 3600 AS ore_aperto
FROM OrariDiApertura,
     NumeroCategorie
WHERE NumeroCategorie.ristorante = OrariDiApertura.ristorante
  AND NumeroCategorie.numero_categorie >= ALL (SELECT numero_categorie FROM NumeroCategorie)
GROUP BY OrariDiApertura.ristorante, OrariDiApertura.giorno;

--
-- OPERAZIONE 6: giorno_max_apertura_piu_categorie
-- I giorni della settimana in cui il ristorante con più categorie del menu è aperto più tempo
--
SELECT T.giorno
FROM (
         -- Controllo quanto è aperto ognuno dei ristoranti col massimo numero di categorie, ogni giorno
         SELECT OrariDiApertura.giorno, SUM(TIMEDIFF(TIME_TO_SEC(chiusura), TIME_TO_SEC(apertura))) AS tempo_aperto
         FROM OrariDiApertura,
              -- Ogni ristorante, quante categorie ha
              (SELECT Menu.ristorante, COUNT(DISTINCT CategoriaMenu.id) AS numero_categorie
               FROM Menu,
                    CategoriaMenu
               WHERE CategoriaMenu.menu = Menu.id
               GROUP BY Menu.ristorante) AS NumeroCategorie
         WHERE NumeroCategorie.ristorante = OrariDiApertura.ristorante
           AND NumeroCategorie.numero_categorie >= ALL (
             -- Il massimo numero di categorie
             SELECT COUNT(DISTINCT CategoriaMenu.id) AS numero_categorie
             FROM Menu,
                  CategoriaMenu
             WHERE CategoriaMenu.menu = Menu.id
             GROUP BY Menu.ristorante)
         GROUP BY OrariDiApertura.ristorante, OrariDiApertura.giorno) AS T
WHERE T.tempo_aperto >= ALL (
    -- Quanto è aperto ognuno dei ristoranti col massimo numero di categorie, ogni giorno
    SELECT COALESCE(SUM(TIMEDIFF(TIME_TO_SEC(chiusura), TIME_TO_SEC(apertura))), 0) AS tempo_aperto
    FROM OrariDiApertura,
         -- Ogni ristorante, quante categorie ha
         (SELECT Menu.ristorante, COUNT(DISTINCT CategoriaMenu.id) AS numero_categorie
          FROM Menu,
               CategoriaMenu
          WHERE CategoriaMenu.menu = Menu.id
          GROUP BY Menu.ristorante) AS NumeroCategorie
    WHERE NumeroCategorie.ristorante = OrariDiApertura.ristorante
      AND NumeroCategorie.numero_categorie >= ALL (
        -- Il massimo numero di categorie
        SELECT COUNT(DISTINCT CategoriaMenu.id) AS numero_categorie
        FROM Menu,
             CategoriaMenu
        WHERE CategoriaMenu.menu = Menu.id
        GROUP BY Menu.ristorante)
    GROUP BY OrariDiApertura.ristorante, OrariDiApertura.giorno);

--
-- OPERAZIONE 6, con le viste
--
CREATE OR REPLACE VIEW AperturaGiornalieraRistorantePiuCategorie AS
SELECT OrariDiApertura.giorno, SUM(TIMEDIFF(TIME_TO_SEC(chiusura), TIME_TO_SEC(apertura))) AS tempo_aperto
FROM OrariDiApertura,
     NumeroCategorie
WHERE NumeroCategorie.ristorante = OrariDiApertura.ristorante
  AND NumeroCategorie.numero_categorie >= ALL (SELECT numero_categorie FROM NumeroCategorie)
GROUP BY OrariDiApertura.ristorante, OrariDiApertura.giorno;

SELECT giorno
FROM AperturaGiornalieraRistorantePiuCategorie AS A
WHERE tempo_aperto >= ALL (SELECT tempo_aperto FROM AperturaGiornalieraRistorantePiuCategorie AS A2);


--
-- OPERAZIONE 7: ristoranti_max_prodotti
-- Il nome e indirizzo dei ristoranti con più prodotti aggiunti
--
SELECT Ristorante.nome,
       Ristorante.indirizzo_via,
       Ristorante.indirizzo_civico,
       Ristorante.indirizzo_citta,
       NumeroProdotti.numero_prodotti
FROM Ristorante
         LEFT JOIN (SELECT Prodotto.ristorante, COUNT(DISTINCT Prodotto.id) AS numero_prodotti
                    FROM Prodotto
                    GROUP BY Prodotto.ristorante) AS NumeroProdotti ON NumeroProdotti.ristorante = Ristorante.id
WHERE NumeroProdotti.numero_prodotti > ALL
      (SELECT COUNT(DISTINCT Prodotto.id) AS numero_prodotti FROM Prodotto GROUP BY Prodotto.ristorante);

--
-- OPERAZIONE 7, con le viste
--
CREATE OR REPLACE VIEW NumeroProdotti AS
SELECT Prodotto.ristorante, COUNT(DISTINCT Prodotto.id) AS numero_prodotti
FROM Prodotto
GROUP BY Prodotto.ristorante;

SELECT Ristorante.nome,
       Ristorante.indirizzo_via,
       Ristorante.indirizzo_civico,
       Ristorante.indirizzo_citta,
       NumeroProdotti.numero_prodotti
FROM Ristorante
         LEFT JOIN NumeroProdotti ON NumeroProdotti.ristorante = Ristorante.id
WHERE NumeroProdotti.numero_prodotti > ALL (SELECT numero_prodotti FROM NumeroProdotti);

--
-- OPERAZIONE 8: media_valutazioni_utente
-- Per ogni utente, mostra il nome, i suoi numeri di telefono e la media delle recensioni lasciate
--
SELECT Utente.nome, Utente.cognome, TelefonoUtente.telefono, MediaRecensioni.voto_medio
FROM Utente
         LEFT JOIN TelefonoUtente ON Utente.id = TelefonoUtente.utente
         LEFT JOIN (SELECT Recensione.utente, AVG(Recensione.voto) AS voto_medio FROM Recensione) AS MediaRecensioni
                   ON MediaRecensioni.utente = Utente.id;

--
-- OPERAZIONE 9: max_ordinati_ristorante
-- Per il ristorante con ID = 2, i prodotti nel 10% di quelli maggiormente ordinati, contando le quantità d'ordine
--
SELECT Prodotto.*, QuantitaOrdine.totale
FROM Prodotto
         JOIN (SELECT Prodotto.id AS prodotto, SUM(ContenutoOrdine.quantita) AS totale
               FROM ContenutoOrdine,
                    Prodotto
               WHERE ContenutoOrdine.prodotto = Prodotto.id
                 AND Prodotto.ristorante = 2
               GROUP BY Prodotto.id) AS QuantitaOrdine ON Prodotto.id = QuantitaOrdine.prodotto
WHERE (SELECT COUNT(*)
       FROM (SELECT Prodotto.id AS prodotto, SUM(ContenutoOrdine.quantita) AS totale
             FROM ContenutoOrdine,
                  Prodotto
             WHERE ContenutoOrdine.prodotto = Prodotto.id
               AND Prodotto.ristorante = 2
             GROUP BY Prodotto.id) AS Q
       WHERE Q.totale >= QuantitaOrdine.totale) <= (SELECT CEILING(COUNT(*) * 0.2)
                                                    FROM (SELECT Prodotto.id                   AS prodotto,
                                                                 SUM(ContenutoOrdine.quantita) AS totale
                                                          FROM ContenutoOrdine,
                                                               Prodotto
                                                          WHERE ContenutoOrdine.prodotto = Prodotto.id
                                                            AND Prodotto.ristorante = 2
                                                          GROUP BY Prodotto.id) AS Q2);

--
-- OPERAZIONE 9, con le viste
--
CREATE OR REPLACE VIEW QuantitaOrdine AS
SELECT Prodotto.id AS prodotto, Prodotto.ristorante, SUM(ContenutoOrdine.quantita) AS totale
FROM ContenutoOrdine,
     Prodotto
WHERE ContenutoOrdine.prodotto = Prodotto.id
GROUP BY Prodotto.id, Prodotto.ristorante;

SELECT Prodotto.*, QuantitaOrdine.totale
FROM Prodotto
         JOIN QuantitaOrdine ON Prodotto.id = QuantitaOrdine.prodotto
WHERE Prodotto.ristorante = 2
  AND (SELECT COUNT(*) FROM QuantitaOrdine AS Q WHERE Q.totale >= QuantitaOrdine.totale) <=
      (SELECT CEILING(COUNT(*) * 0.2) FROM QuantitaOrdine AS Q2);

--
-- OPERAZIONE 10: vicini_sapienza_buoni
-- Dati dei ristoranti, con valutazione media >= 3, a meno di 1 Km dalla Sapienza, aperti alle 13:00
--
SELECT Ristorante.*, Voti.voto_medio
FROM Ristorante,
     (SELECT Ristorante.id AS ristorante, COALESCE(AVG(Recensione.voto), 0) AS voto_medio
      FROM Ristorante
               LEFT JOIN Recensione ON Ristorante.id = Recensione.ristorante
      GROUP BY Ristorante.id) AS Voti,
     OrariDiApertura
WHERE Ristorante.id = Voti.ristorante
  AND Ristorante.id = OrariDiApertura.ristorante
  AND Voti.voto_medio >= 3
  AND DISTANCE_KM(Ristorante.indirizzo_latitudine, Ristorante.indirizzo_longitudine, 41.9019257, 12.5147147) <= 1
  -- Aperti ora. Data la non sovrapposizione degli intervalli, non si possono avere più righe per ristorante nel risultato
  AND OrariDiApertura.giorno = MOD(DAYOFWEEK(NOW()) + 5, 7) -- Trasforma nei giorni 0=lunedi, 6=domenica
  AND OrariDiApertura.apertura <= TIME('13:00:00')
  AND OrariDiApertura.chiusura > TIME('13:00:00')
ORDER BY Voti.voto_medio DESC;

--
-- OPERAZIONE 11: adatto_a_tutti_ristorante
-- Per ogni ristorante, il prodotto con meno allergeni
--
SELECT Prodotto.*
FROM Prodotto,
     AllergeniProdotto
WHERE AllergeniProdotto.prodotto = Prodotto.id
GROUP BY Prodotto.ristorante
HAVING COUNT(DISTINCT AllergeniProdotto.allergene) <= ALL (SELECT COUNT(DISTINCT A.allergene)
                                                           FROM AllergeniProdotto AS A,
                                                                Prodotto AS P
                                                           WHERE A.prodotto = P.id
                                                             AND P.ristorante = Prodotto.ristorante
                                                           GROUP BY A.prodotto);

--
-- OPERAZIONE 12: rider_piu_efficiente
-- Il rider col maggior numero di ordini consegnati
--
SELECT Utente.*
FROM Utente
         JOIN (SELECT Utente.id, COUNT(DISTINCT OrdineRistorante.id) AS num_ordini
               FROM Utente,
                    ServizioRider,
                    OrdineRistorante
               WHERE ServizioRider.utente = Utente.id
                 AND OrdineRistorante.servizio_rider = ServizioRider.id
                 AND Utente.rider = 1
                 AND OrdineRistorante.stato = 400
               GROUP BY Utente.id) AS TotOrdini ON TotOrdini.id = Utente.id
WHERE TotOrdini.num_ordini >= ALL (SELECT COUNT(DISTINCT OrdineRistorante.id)
                                   FROM Utente,
                                        ServizioRider,
                                        OrdineRistorante
                                   WHERE ServizioRider.utente = Utente.id
                                     AND OrdineRistorante.servizio_rider = ServizioRider.id
                                     AND Utente.rider = 1
                                     AND OrdineRistorante.stato = 400
                                   GROUP BY Utente.id);

--
-- OPERAZIONE 12, con le viste
--
CREATE OR REPLACE VIEW TotOrdini AS
SELECT Utente.id, COUNT(DISTINCT OrdineRistorante.id) AS num_ordini
FROM Utente,
     ServizioRider,
     OrdineRistorante
WHERE ServizioRider.utente = Utente.id
  AND OrdineRistorante.servizio_rider = ServizioRider.id
  AND Utente.rider = 1
  AND OrdineRistorante.stato = 400
GROUP BY Utente.id;

SELECT Utente.*
FROM Utente
         JOIN TotOrdini ON TotOrdini.id = Utente.id
WHERE TotOrdini.num_ordini >= ALL (SELECT num_ordini FROM TotOrdini);

--
-- OPERAZIONE 13: rider_piu_tempo
-- Il rider col numero massimo di ore lavorate in servizio
--
SELECT Utente.*
FROM Utente
         JOIN (SELECT ServizioRider.utente, SUM(UNIX_TIMESTAMP(ora_fine) - UNIX_TIMESTAMP(ora_inizio)) AS tot_tempo
               FROM ServizioRider
               WHERE ServizioRider.ora_fine IS NOT NULL
               GROUP BY ServizioRider.utente) AS TotTempoRider ON TotTempoRider.utente = Utente.id
WHERE TotTempoRider.tot_tempo >= ALL (SELECT SUM(UNIX_TIMESTAMP(ora_fine) - UNIX_TIMESTAMP(ora_inizio)) AS tot_tempo
                                      FROM ServizioRider
                                      WHERE ServizioRider.ora_fine IS NOT NULL
                                      GROUP BY ServizioRider.utente);

--
-- OPERAZIONE 13, con le viste
--
CREATE OR REPLACE VIEW TotTempoRider AS
SELECT ServizioRider.utente, SUM(UNIX_TIMESTAMP(ora_fine) - UNIX_TIMESTAMP(ora_inizio)) AS tot_tempo
FROM ServizioRider
WHERE ServizioRider.ora_fine IS NOT NULL
GROUP BY ServizioRider.utente;

SELECT Utente.*
FROM Utente
         JOIN TotTempoRider ON TotTempoRider.utente = Utente.id
WHERE TotTempoRider.tot_tempo >= ALL (SELECT tot_tempo FROM TotTempoRider AS T);

--
-- OPERAZIONE 14: utente_indeciso
-- L'utente con più prodotti nel carrello, considerando le quantità
--
SELECT Utente.*, QuantitaCarrello.quantita
FROM Utente
         JOIN (SELECT Carrello.utente, SUM(Carrello.quantita) AS quantita
               FROM Carrello
               GROUP BY Carrello.utente) AS QuantitaCarrello ON QuantitaCarrello.utente = Utente.id
WHERE QuantitaCarrello.quantita >= ALL (SELECT SUM(Carrello.quantita) FROM Carrello GROUP BY Carrello.utente);

--
-- OPERAZIONE 15: account_sospetti
-- Gli utenti nel 10% di quelli che hanno più sessioni di login attivi (potenzialmente bot o condivisi)
--
SELECT Utente.*
FROM Utente
         JOIN (SELECT SessioneLogin.utente, COUNT(*) AS numero_sessioni
               FROM SessioneLogin
               GROUP BY SessioneLogin.utente) AS Sessioni ON Sessioni.utente = Utente.id
WHERE (SELECT COUNT(*)
       FROM (SELECT SessioneLogin.utente, COUNT(*) AS numero_sessioni
             FROM SessioneLogin
             GROUP BY SessioneLogin.utente) AS S
       WHERE S.numero_sessioni >= Sessioni.numero_sessioni) <= (SELECT CEIL(COUNT(*) * 0.2)
                                                                FROM (SELECT SessioneLogin.utente, COUNT(*) AS numero_sessioni
                                                                      FROM SessioneLogin
                                                                      GROUP BY SessioneLogin.utente) AS S2);

--
-- OPERAZIONE 15, con le viste
--
CREATE OR REPLACE VIEW SessioniNum AS
SELECT SessioneLogin.utente, COUNT(*) AS numero_sessioni
FROM SessioneLogin
GROUP BY SessioneLogin.utente;

SELECT Utente.*
FROM Utente
         JOIN SessioniNum ON SessioniNum.utente = Utente.id
WHERE (SELECT COUNT(*) FROM SessioniNum AS S WHERE S.numero_sessioni >= SessioniNum.numero_sessioni) <=
      (SELECT CEIL(COUNT(*) * 0.2) FROM SessioniNum AS S2);