package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.Product
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import javax.transaction.Transactional

@Repository
interface ProductsDao : CrudRepository<Product, Int> {
    @Query(
        """
        SELECT * FROM Prodotto
        LEFT JOIN AllergeniProdotto AP on Prodotto.id = AP.prodotto
        WHERE Prodotto.id = ?1
        """, nativeQuery = true
    )
    fun getById(id: Int): Product

    @Query(
        """
        SELECT * FROM Prodotto
        LEFT JOIN AllergeniProdotto AP ON Prodotto.id = AP.prodotto
        WHERE Prodotto.ristorante = ?1
    """, nativeQuery = true
    )
    fun getAllByRestaurant(restaurant: Int): Set<Product>

    @Query("CALL inserisci_aggiorna_prodotto(?1, ?2, ?3, ?4, ?5, ?6)", nativeQuery = true)
    @Modifying
    @Transactional
    fun insertUpdateProduct(
        id: Int?,
        name: String,
        description: String?,
        price: Double,
        restaurant: Int,
        allergensCsv: String
    )
}