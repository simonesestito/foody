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
        FROM Cart
        INNER JOIN Product P on Cart.product = P.id
        WHERE user = ?1
    """, nativeQuery = true)
    fun getAllByUser(user: Int): Set<Cart>

    @Query("""
        INSERT INTO Cart (user, product, quantity)
        VALUES (?1, ?2, ?3)
        ON DUPLICATE KEY UPDATE quantity = ?3
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun insertProduct(user: Int, product: Int, quantity: Int)
}