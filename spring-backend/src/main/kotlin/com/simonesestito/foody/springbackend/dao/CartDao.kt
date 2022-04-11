package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.Cart
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import javax.transaction.Transactional

@Repository
interface CartDao : CrudRepository<Cart, Int> {
    @Query("""
        SELECT *
        FROM Carrello
        INNER JOIN Prodotto ON Prodotto.id = Carrello.prodotto
        WHERE utente = ?1
    """, nativeQuery = true)
    fun getAllByUser(user: Int): Set<Cart>

    @Query("""
        INSERT INTO Carrello (utente, prodotto, quantita)
        VALUES (?1, ?2, ?3)
        ON DUPLICATE KEY UPDATE quantita = ?3
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun insertProduct(user: Int, product: Int, quantity: Int)

    @Query("""
        DELETE FROM Carrello
        WHERE utente = ?1 AND prodotto = ?2
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun deleteProduct(user: Int, product: Int)
}