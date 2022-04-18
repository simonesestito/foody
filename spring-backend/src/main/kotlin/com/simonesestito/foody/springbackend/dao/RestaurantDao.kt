package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.RestaurantWithMenus
import com.simonesestito.foody.springbackend.entity.Review
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import javax.transaction.Transactional

@Repository
interface RestaurantDao : CrudRepository<RestaurantWithMenus, Int> {
    @Query(
        """
        SELECT *
        FROM RistorantiConMenu
        WHERE nome LIKE ?1
        ORDER BY DISTANCE_KM(?2, ?3, indirizzo_latitudine, indirizzo_longitudine)
    """, nativeQuery = true
    )
    fun getAll(namePattern: String, latitude: Double, longitude: Double): Set<RestaurantWithMenus>

    @Query(
        """
        SELECT *
        FROM RistorantiConMenu
        WHERE id LIKE ?1 
        """, nativeQuery = true
    )
    fun getById(id: Int): RestaurantWithMenus?

    @Query("""
        INSERT INTO Recensione (creazione, voto, titolo, testo, ristorante, utente)
        VALUES (NOW(), ?1, ?2, ?3, ?4, ?5)
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun insertReview(mark: Int, title: String?, text: String?, restaurantId: Int, userId: Int)

    @Query("""
        SELECT *
        FROM Recensione
        JOIN Ristorante ON Ristorante.id = Recensione.ristorante
        JOIN Utente ON Utente.id = Recensione.utente
        WHERE Ristorante.id = ?1
    """, nativeQuery = true)
    fun getReviews(restaurantId: Int): Set<Review>

    @Query("""
        DELETE FROM Recensione WHERE ristorante = ?1 AND utente = ?2
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun deleteReview(restaurantId: Int, userId: Int)
}