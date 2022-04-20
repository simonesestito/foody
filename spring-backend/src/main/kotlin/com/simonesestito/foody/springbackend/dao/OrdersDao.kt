package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.RestaurantOrder
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
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

    @Query(
        """
        SELECT *
        FROM OrdineRistorante
        LEFT JOIN Utente ON Utente.id = OrdineRistorante.utente = Utente.id
        LEFT JOIN ServizioRider ON Utente.id = ServizioRider.utente
        LEFT JOIN ContenutoOrdine ON OrdineRistorante.id = ContenutoOrdine.ordine_ristorante
        LEFT JOIN Prodotto ON ContenutoOrdine.prodotto = Prodotto.id
        WHERE Prodotto.ristorante = ?1
    """, nativeQuery = true
    )
    fun getAllByRestaurant(restaurantId: Int): Set<RestaurantOrder>

    @Query(
        """
        UPDATE OrdineRistorante
        SET stato = (
            SELECT StatoOrdine.id
            FROM StatoOrdine
            WHERE StatoOrdine.nome = ?2
        )
        WHERE OrdineRistorante.id = ?1
    """, nativeQuery = true
    )
    @Modifying
    @Transactional
    fun updateOrderStatus(orderId: Int, statusName: String)

    @Query("CALL inserisci_ordine_utente(?1, ?2, ?3, ?4, ?5, ?6, ?7)", nativeQuery = true)
    @Modifying
    @Transactional
    fun postOrderFromCart(
        notes: String?,
        street: String,
        houseNumber: String?,
        city: String,
        latitude: Double,
        longitude: Double,
        customerId: Int,
    )
}