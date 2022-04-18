package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.OpeningHours
import com.simonesestito.foody.springbackend.entity.RestaurantWithMenus
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import org.springframework.stereotype.Service
import javax.persistence.EntityManager
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
}

@Service
class RestaurantService(private val session: EntityManager) {
    @Transactional
    fun updateTimetable(restaurantId: Int, timetable: List<OpeningHours>) {
        session.createNativeQuery("DELETE FROM OrariDiApertura WHERE ristorante = ?1").apply {
            setParameter(1, restaurantId)
        }.executeUpdate()

        timetable.forEach {
            session.createNativeQuery(
                """
                INSERT INTO OrariDiApertura (giorno, apertura, chiusura, ristorante)
                VALUES (?1, ?2, ?3, ?4)
            """.trimIndent()
            ).apply {
                setParameter(1, it.weekday)
                setParameter(2, it.openingTime)
                setParameter(3, it.closingTime)
                setParameter(4, restaurantId)
            }.executeUpdate()
        }
    }
}