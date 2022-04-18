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
        SELECT RistorantiConMenu.*
        FROM RistorantiConMenu
        JOIN GestioneOrdini ON GestioneOrdini.ristorante = RistorantiConMenu.id
        WHERE GestioneOrdini.utente = ?1
        AND GestioneOrdini.data_fine IS NULL
    """, nativeQuery = true)
    fun getByManager(managerId: Int): Set<RestaurantWithMenus>
}