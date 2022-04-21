package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.Menu
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import javax.transaction.Transactional

@Repository
interface MenuDao : CrudRepository<Menu, Int> {
    @Query("""
        INSERT INTO Menu (titolo, ristorante, pubblicato) VALUES (?1, ?2, ?3)
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun addMenu(title: String, restaurant: Int, published: Boolean)

    @Query("""
        UPDATE Menu SET titolo = ?2, pubblicato = ?3 WHERE id = ?1
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun updateMenu(menu: Int, title: String, published: Boolean)

    @Query("""
        DELETE FROM Menu WHERE id = ?1
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun deleteMenu(menu: Int)

    @Query("""
        DELETE FROM CategoriaMenu WHERE id = ?1
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun deleteCategory(category: Int)

    @Query("""
        INSERT INTO CategoriaMenu (titolo, menu) VALUES (?1, ?2)
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun addCategory(title: String, menu: Int)

    @Query("""
        UPDATE CategoriaMenu SET titolo = ?2 WHERE id = ?1
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun updateCategory(category: Int, title: String)

    @Query("""
        INSERT INTO ContenutoCategoriaMenu (prodotto, categoria) VALUES (?1, ?2)
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun addProductToCategory(product: Int, category: Int)

    @Query("""
        DELETE FROM ContenutoCategoriaMenu WHERE prodotto = ?1 AND categoria = ?2
    """, nativeQuery = true)
    @Modifying
    @Transactional
    fun removeProductFromCategory(product: Int, category: Int)
}