package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.RestaurantOrder
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import org.springframework.stereotype.Service
import java.math.BigInteger
import javax.persistence.EntityManager
import javax.transaction.Transactional

@Repository
interface OrdersDao : CrudRepository<RestaurantOrder, Int> {
    @Query(
        """
        SELECT *
        FROM OrdineRistorante
        INNER JOIN Utente ON Utente.id = OrdineRistorante.utente = Utente.id
        LEFT JOIN ServizioRider ON Utente.id = ServizioRider.utente
        LEFT JOIN ContenutoOrdine ON OrdineRistorante.id = ContenutoOrdine.ordine_ristorante
        LEFT JOIN Prodotto ON ContenutoOrdine.prodotto = Prodotto.id
        WHERE OrdineRistorante.utente = ?1 
    """, nativeQuery = true
    )
    fun getAllByUserId(userId: Int): Set<RestaurantOrder>

    @Query("""
        SELECT *
        FROM OrdineRistorante
        LEFT JOIN Utente ON Utente.id = OrdineRistorante.utente = Utente.id
        LEFT JOIN ServizioRider ON Utente.id = ServizioRider.utente
        LEFT JOIN ContenutoOrdine ON OrdineRistorante.id = ContenutoOrdine.ordine_ristorante
        LEFT JOIN Prodotto ON ContenutoOrdine.prodotto = Prodotto.id
        WHERE Prodotto.ristorante = ?1
    """, nativeQuery = true)
    fun getAllByRestaurant(restaurantId: Int): Set<RestaurantOrder>

    @Query("""
        UPDATE OrdineRistorante
        SET stato = (
            SELECT StatoOrdine.id
            FROM StatoOrdine
            WHERE StatoOrdine.nome = ?2
        )
        WHERE OrdineRistorante.id = ?1
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun updateOrderStatus(orderId: Int, statusName: String)
}

@Service
class OrdersService(
    private val session: EntityManager,
) {
    @Transactional
    fun postOrderFromCart(
        notes: String?,
        street: String,
        houseNumber: String?,
        city: String,
        latitude: Double,
        longitude: Double,
        customerId: Int,
    ) {
        session.createNativeQuery(
            """
        INSERT INTO OrdineRistorante
        (note, indirizzo_via, indirizzo_civico, indirizzo_citta, indirizzo_latitudine, indirizzo_longitudine, utente, servizio_rider)
        VALUES
        (?1, ?2, ?3, ?4, ?5, ?6, ?7, NULL)
        """.trimIndent()
        )
            .setParameter(1, notes)
            .setParameter(2, street)
            .setParameter(3, houseNumber)
            .setParameter(4, city)
            .setParameter(5, latitude)
            .setParameter(6, longitude)
            .setParameter(7, customerId)
            .executeUpdate()

        val orderId = session.createNativeQuery("SELECT LAST_INSERT_ID()").singleResult as BigInteger
        println("ORDER >>>>>>>>>>>>> $orderId")

        session.createNativeQuery(
            """
        INSERT INTO ContenutoOrdine (prodotto, ordine_ristorante, quantita)
        SELECT prodotto, ?1, quantita 
        FROM Carrello, Prodotto
        WHERE Carrello.prodotto = Prodotto.id
        AND utente = ?2
        """.trimIndent()
        )
            .setParameter(1, orderId)
            .setParameter(2, customerId)
            .executeUpdate()

        session.createNativeQuery(
            """
            DELETE FROM Carrello WHERE utente = ?1
        """.trimIndent()
        )
            .setParameter(1, customerId)
            .executeUpdate()
    }
}