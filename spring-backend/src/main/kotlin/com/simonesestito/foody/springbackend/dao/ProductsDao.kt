package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.Product
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import org.springframework.stereotype.Service
import java.math.BigInteger
import javax.persistence.EntityManager
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

    @Query("""
        SELECT * FROM Prodotto
        LEFT JOIN AllergeniProdotto AP ON Prodotto.id = AP.prodotto
        WHERE Prodotto.ristorante = ?1
    """, nativeQuery = true)
    fun getAllByRestaurant(restaurant: Int): Set<Product>
}

@Service
class ProductsService(private val session: EntityManager) {
    @Transactional
    fun insertProduct(product: Product) {
        session.createNativeQuery(
            """
            INSERT INTO Prodotto (nome, descrizione, prezzo, ristorante) 
            VALUES (?1, ?2, ?3, ?4)
        """.trimIndent()
        ).apply {
            setParameter(1, product.name)
            setParameter(2, product.description)
            setParameter(3, product.price)
            setParameter(4, product.restaurant)
        }.executeUpdate()

        val productId = session.createNativeQuery("SELECT LAST_INSERT_ID()").singleResult as BigInteger

        product.allergens.forEach {
            session.createNativeQuery(
                """
            INSERT INTO AllergeniProdotto (prodotto, allergene) 
            VALUES (?1, ?2)
        """.trimIndent()
            ).apply {
                setParameter(1, productId)
                setParameter(2, it)
            }.executeUpdate()
        }
    }

    @Transactional
    fun updateProduct(product: Product) {
        session.createNativeQuery(
            """
            UPDATE Prodotto
            SET nome = ?1, descrizione = ?2, prezzo = ?3, ristorante = ?4
            WHERE id = ?5
        """.trimIndent()
        ).apply {
            setParameter(1, product.name)
            setParameter(2, product.description)
            setParameter(3, product.price)
            setParameter(4, product.restaurant)
            setParameter(5, product.id)
        }.executeUpdate()

        session.createNativeQuery(
            """
            DELETE FROM AllergeniProdotto WHERE prodotto = ?1
        """.trimIndent()
        ).apply {
            setParameter(1, product.id)
        }.executeUpdate()

        product.allergens.forEach {
            session.createNativeQuery(
                """
            INSERT INTO AllergeniProdotto (prodotto, allergene) 
            VALUES (?1, ?2)
        """.trimIndent()
            ).apply {
                setParameter(1, product.id)
                setParameter(2, it)
            }.executeUpdate()
        }
    }
}