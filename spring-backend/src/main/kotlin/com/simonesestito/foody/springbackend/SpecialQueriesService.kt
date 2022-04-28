package com.simonesestito.foody.springbackend

import org.springframework.stereotype.Service
import javax.persistence.EntityManager
import javax.persistence.Tuple
import kotlin.streams.asSequence

/**
 * Run special queries, required by the project specification.
 *
 * They are almost never used, and they MUST be implemented as raw queries.
 *
 * Query name must match the one indicated in the /query.sql file
 */
@Service
class SpecialQueriesService(private val entityManager: EntityManager) {
    private fun runQuery(query: String) =
        entityManager.createNativeQuery(query, Tuple::class.java).resultStream.asSequence().map { it as Tuple }.map { row ->
            row.elements.associate { it.alias to row[it.alias] }
        }.toList()

    private fun List<Map<String, *>>.groupById(idName: String = "id"): Map<Int, List<Map<String, *>>> {
        val map = mutableMapOf<Int, MutableList<Map<String, *>>>()
        map[-1] = mutableListOf(mapOf("_key" to idName))
        this.forEach {
            val id = it[idName] as Int
            if (!map.containsKey(id)) map[id] = mutableListOf()
            map[id]!!.add(it)
        }
        return map
    }

    fun elencoRistoranti() = runQuery(
        """
        SELECT Ristorante.id, Ristorante.nome, OrariDiApertura.apertura, OrariDiApertura.chiusura, OrariDiApertura.giorno, R.voto_medio
        FROM Ristorante
                 LEFT JOIN OrariDiApertura ON Ristorante.id = OrariDiApertura.ristorante
                 LEFT JOIN (SELECT ristorante, AVG(voto) as voto_medio FROM Recensione) R ON Ristorante.id = R.ristorante
    """.trimIndent()
    ).groupById()

    fun managerEmail() = runQuery(
        """
        SELECT Utente.id, Utente.nome, Utente.cognome, EU.email, COALESCE(NumeroRistoranti.numero_ristoranti, 0) AS numero_ristoranti
        FROM Utente
            LEFT JOIN NumeroRistoranti ON Utente.id = NumeroRistoranti.utente
            LEFT JOIN EmailUtente EU on Utente.id = EU.utente;
""".trimIndent()
    ).groupById()

    fun incassoMaxOrdini() = runQuery(
        """
        SELECT ristorante, SUM(Prodotto.prezzo) AS totale_incassi
        FROM OrdineRistorante,
             ContenutoOrdine,
             Prodotto
        WHERE ContenutoOrdine.ordine_ristorante = OrdineRistorante.id
          AND Prodotto.id = ContenutoOrdine.prodotto
        GROUP BY Prodotto.ristorante
        HAVING COUNT(DISTINCT OrdineRistorante.id) >= ALL (SELECT numero_ordini FROM TotOrdiniPerRistorante);
    """.trimIndent()
    )

    fun licenziatiGrandiRistoranti() = runQuery(
        """
        SELECT GestioneOrdini.ristorante, COUNT(DISTINCT GestioneOrdini.utente) AS numero_licenziati
        FROM GestioneOrdini
                 LEFT JOIN (SELECT Ristorante.id,
                                   COALESCE(SUM(TIMEDIFF(TIME_TO_SEC(chiusura), TIME_TO_SEC(apertura))), 0) / 3600 AS ore_aperte
                            FROM Ristorante
                                     LEFT JOIN OrariDiApertura ON Ristorante.id = OrariDiApertura.ristorante
                            GROUP BY Ristorante.id) AS OreAperto ON OreAperto.id = GestioneOrdini.ristorante
        WHERE GestioneOrdini.data_fine IS NOT NULL
          AND OreAperto.ore_aperte > 20
        GROUP BY GestioneOrdini.ristorante
    """.trimIndent()
    ).groupById("ristorante")

    fun aperturaTanteCategorie() = runQuery(
        """
        SELECT OrariDiApertura.ristorante,
               OrariDiApertura.giorno,
               COALESCE(SUM(TIMEDIFF(TIME_TO_SEC(chiusura), TIME_TO_SEC(apertura))), 0) / 3600 AS ore_aperto
        FROM OrariDiApertura,
             NumeroCategorie
        WHERE NumeroCategorie.ristorante = OrariDiApertura.ristorante
          AND NumeroCategorie.numero_categorie >= ALL (SELECT numero_categorie FROM NumeroCategorie)
        GROUP BY OrariDiApertura.ristorante, OrariDiApertura.giorno;
    """.trimIndent()
    )

    fun giornoMaxAperturaPiuCategorie() = runQuery(
        """
        SELECT giorno
        FROM AperturaGiornalieraRistorantePiuCategorie AS A
        WHERE tempo_aperto >= ALL (SELECT tempo_aperto FROM AperturaGiornalieraRistorantePiuCategorie AS A2);
    """.trimIndent()
    )

    fun ristorantiMaxProdotti() = runQuery(
        """
        SELECT Ristorante.nome,
               Ristorante.indirizzo_via,
               Ristorante.indirizzo_civico,
               Ristorante.indirizzo_citta,
               NumeroProdotti.numero_prodotti
        FROM Ristorante
                 LEFT JOIN NumeroProdotti ON NumeroProdotti.ristorante = Ristorante.id
        WHERE NumeroProdotti.numero_prodotti > ALL (SELECT numero_prodotti FROM NumeroProdotti)
    """.trimIndent()
    )

    fun mediaValutazioniUtente() = runQuery(
        """
        SELECT Utente.id, Utente.nome, Utente.cognome, TelefonoUtente.telefono, MediaRecensioni.voto_medio
        FROM Utente
         LEFT JOIN TelefonoUtente ON Utente.id = TelefonoUtente.utente
         LEFT JOIN (SELECT Recensione.utente, AVG(Recensione.voto) AS voto_medio FROM Recensione) AS MediaRecensioni
                   ON MediaRecensioni.utente = Utente.id
    """.trimIndent()
    ).groupById()

    fun maxOrdinatiRistorante() = runQuery(
        """
        SELECT Prodotto.*, QuantitaOrdine.totale
        FROM Prodotto
                 JOIN QuantitaOrdine ON Prodotto.id = QuantitaOrdine.prodotto
        WHERE Prodotto.ristorante = 2
          AND (SELECT COUNT(*) FROM QuantitaOrdine AS Q WHERE Q.totale >= QuantitaOrdine.totale) <=
              (SELECT CEILING(COUNT(*) * 0.2) FROM QuantitaOrdine AS Q2);
    """.trimIndent()
    )

    fun viciniSapienzaBuoni() = runQuery(
        """
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
          AND OrariDiApertura.giorno = MOD(DAYOFWEEK(NOW()) + 5, 7)
          AND OrariDiApertura.apertura <= TIME('13:00:00')
          AND OrariDiApertura.chiusura > TIME('13:00:00')
        ORDER BY Voti.voto_medio DESC;
    """.trimIndent()
    )

    fun adattoATuttiRistorante() = runQuery(
        """
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

    """.trimIndent()
    ).groupById("ristorante")

    fun riderPiuEfficiente() = runQuery(
        """
        SELECT Utente.*
        FROM Utente
                 JOIN TotOrdini ON TotOrdini.id = Utente.id
        WHERE TotOrdini.num_ordini >= ALL (SELECT num_ordini FROM TotOrdini);

    """.trimIndent()
    )

    fun riderPiuTempo() = runQuery(
        """
        SELECT Utente.*
        FROM Utente
                 JOIN TotTempoRider ON TotTempoRider.utente = Utente.id
        WHERE TotTempoRider.tot_tempo >= ALL (SELECT tot_tempo FROM TotTempoRider AS T);

    """.trimIndent()
    )

    fun utenteIndeciso() = runQuery(
        """
        SELECT Utente.*, QuantitaCarrello.quantita
        FROM Utente
                 JOIN (SELECT Carrello.utente, SUM(Carrello.quantita) AS quantita
                       FROM Carrello
                       GROUP BY Carrello.utente) AS QuantitaCarrello ON QuantitaCarrello.utente = Utente.id
        WHERE QuantitaCarrello.quantita >= ALL (SELECT SUM(Carrello.quantita) FROM Carrello GROUP BY Carrello.utente);
    """.trimIndent()
    )

    fun accountSospetti() = runQuery(
        """
        SELECT Utente.id, Utente.nome, Utente.cognome
FROM Utente
         JOIN SessioniNum ON SessioniNum.utente = Utente.id
WHERE (SELECT COUNT(*) FROM SessioniNum AS S WHERE S.numero_sessioni >= SessioniNum.numero_sessioni) <=
      (SELECT CEIL(COUNT(*) * 0.2) FROM SessioniNum AS S2)
    """.trimIndent()
    )
}