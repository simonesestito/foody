package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.RestaurantWithMenus
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
        WHERE nome LIKE ?1 AND pubblicato = 1
        ORDER BY DISTANCE_KM(?2, ?3, indirizzo_latitudine, indirizzo_longitudine)
    """, nativeQuery = true
    )
    fun getAll(namePattern: String, latitude: Double, longitude: Double): Set<RestaurantWithMenus>

    @Query(
        """
        SELECT *
        FROM RistorantiConMenu
        ORDER BY nome
    """, nativeQuery = true
    )
    fun getAll(): Set<RestaurantWithMenus>

    @Query(
        """
        SELECT *
        FROM RistorantiConMenu
        WHERE id LIKE ?1 
        """, nativeQuery = true
    )
    fun getById(id: Int): RestaurantWithMenus?

    @Query(
        """
        SELECT RistorantiConMenu.*
        FROM RistorantiConMenu
        JOIN GestioneOrdini ON GestioneOrdini.ristorante = RistorantiConMenu.id
        WHERE GestioneOrdini.utente = ?1
        AND GestioneOrdini.data_fine IS NULL
    """, nativeQuery = true
    )
    fun getByManager(managerId: Int): Set<RestaurantWithMenus>

    @Query("CALL aggiorna_orari_ristorante(?1, ?2)", nativeQuery = true)
    @Modifying
    @Transactional
    fun updateTimetable(restaurantId: Int, timetableCsv: String)

    @Query("CALL inserisci_ristorante(?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9)", nativeQuery = true)
    @Modifying
    @Transactional
    fun insertRestaurant(
        name: String,
        published: Boolean,
        phones: String,
        addressStreet: String,
        addressHouseNumber: String?,
        addressCity: String,
        latitude: Double,
        longitude: Double,
        managerEmail: String,
    )

    @Query("CALL aggiorna_dati_ristorante(?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9)", nativeQuery = true)
    @Modifying
    @Transactional
    fun updateRestaurant(
        id: Int,
        name: String,
        published: Boolean,
        phones: String,
        addressStreet: String,
        addressHouseNumber: String?,
        addressCity: String,
        latitude: Double,
        longitude: Double,
    )

    @Query("DELETE FROM Ristorante WHERE id = ?1", nativeQuery = true)
    @Modifying
    @Transactional
    fun deleteRestaurant(id: Int)
}