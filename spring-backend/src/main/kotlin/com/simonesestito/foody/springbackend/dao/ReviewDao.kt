package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.Review
import com.simonesestito.foody.springbackend.entity.ReviewId
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import javax.transaction.Transactional

@Repository
interface ReviewDao: CrudRepository<Review, ReviewId> {
    @Query("""
        INSERT INTO Recensione (creazione, voto, titolo, testo, ristorante, utente)
        VALUES (NOW(), ?1, ?2, ?3, ?4, ?5)
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun insertReview(mark: Int, title: String?, text: String?, restaurantId: Int, userId: Int)

    @Query("""
        SELECT *
        FROM RecensioneCompleta
        WHERE ristorante = ?1
    """, nativeQuery = true)
    fun getReviews(restaurantId: Int): Set<Review>

    @Query("""
        DELETE FROM Recensione WHERE ristorante = ?1 AND utente = ?2
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun deleteReview(restaurantId: Int, userId: Int)
}