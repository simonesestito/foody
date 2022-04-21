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
}