-- Per ogni ristorante, mostrare il nome, il voto medio delle recensioni e gli orari di apertura
SELECT Ristorante.*, OrariDiApertura.apertura, OrariDiApertura.chiusura, OrariDiApertura.giorno, R.voto_medio
FROM Ristorante
         LEFT JOIN OrariDiApertura ON Ristorante.id = OrariDiApertura.ristorante
         LEFT JOIN (SELECT ristorante, AVG(voto) as voto_medio FROM Recensione) R ON Ristorante.id = R.ristorante;

-- Per ogni utente, mostrare il numero di ristoranti che al momento gestisce e gli indirizzi e-mail
SELECT Utente.*, EU.email, COALESCE(NumeroRistoranti.numero_ristoranti, 0) AS numero_ristoranti
FROM Utente
         LEFT JOIN (SELECT utente, COUNT(ristorante) AS numero_ristoranti
                    FROM GestioneOrdini
                    WHERE data_fine IS NULL
                    GROUP BY utente) AS NumeroRistoranti ON Utente.id = NumeroRistoranti.utente
         LEFT JOIN EmailUtente EU on Utente.id = EU.utente;

-- Incasso totale dei ristoranti aventi più ordini
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

-- Per ogni ristorante aperto almeno 20 ore a settimana, il numero di lavoratori licenziati
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

-- Quante ore è aperto ciascun ristorante che ha il massimo numero di categorie nel menu
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

-- I giorni della settimana in cui il ristorante con più categorie del menu è aperto più tempo
SELECT T.giorno
FROM (
         -- Controllo quanto è aperto ognuno dei ristoranti col massimo numero di categorie, ogni giorno
         SELECT OrariDiApertura.giorno,
                SUM(TIMEDIFF(TIME_TO_SEC(chiusura), TIME_TO_SEC(apertura))) AS tempo_aperto
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
    GROUP BY OrariDiApertura.ristorante, OrariDiApertura.giorno
);

-- Il nome e indirizzo dei ristoranti con più prodotti aggiunti
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

-- Per ogni utente, mostra il nome, i suoi numeri di telefono e la media delle recensioni lasciate
SELECT Utente.nome, Utente.cognome, TelefonoUtente.telefono, MediaRecensioni.voto_medio
FROM Utente
LEFT JOIN TelefonoUtente ON Utente.id = TelefonoUtente.utente
LEFT JOIN (
    SELECT Recensione.utente, AVG(Recensione.voto) AS voto_medio
    FROM Recensione
) AS MediaRecensioni ON MediaRecensioni.utente = Utente.id;