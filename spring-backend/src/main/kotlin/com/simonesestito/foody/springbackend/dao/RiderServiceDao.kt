package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.RiderService
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import javax.transaction.Transactional

@Repository
interface RiderServiceDao : CrudRepository<RiderService, Int> {
    @Query(
        """
        SELECT * FROM ServizioRider WHERE utente = ?1 AND ora_fine IS NULL
    """, nativeQuery = true
    )
    fun getActiveServiceForUser(user: Int): RiderService?

    @Query(
        """
        SELECT * FROM ServizioRider WHERE utente = ?1 AND ora_fine IS NOT NULL
    """, nativeQuery = true
    )
    fun getUserServices(user: Int): Set<RiderService>

    @Query(
        """
        INSERT INTO ServizioRider (utente, ora_inizio, latitudine_inizio, longitudine_inizio, ora_fine, latitudine_fine, longitudine_fine) 
        VALUES (?1, NOW(), ?2, ?3, NULL, ?2, ?3)
    """, nativeQuery = true
    )
    @Modifying
    @Transactional
    fun startNewService(user: Int, latitude: Double, longitude: Double)

    @Query(
        """
        UPDATE ServizioRider
        SET latitudine_fine = ?2, longitudine_fine = ?3
        WHERE id = ?1
    """, nativeQuery = true
    )
    @Modifying
    @Transactional
    fun updateLocation(service: Int, latitude: Double, longitude: Double)

    @Query(
        """
        UPDATE OrdineRistorante
        SET servizio_rider = ?1, stato = 300
        WHERE id = ?2
    """, nativeQuery = true
    )
    @Modifying
    @Transactional
    fun beginOrderDelivery(service: Int, order: Int)

    @Query(
        """
        UPDATE OrdineRistorante
        SET stato = 400
        WHERE servizio_rider = ?1 AND id = ?2
    """, nativeQuery = true
    )
    @Modifying
    @Transactional
    fun endOrderDelivery(service: Int, order: Int)

    @Query(
        """
        UPDATE ServizioRider
        SET ora_fine = NOW()
        WHERE id = ?1 AND ora_fine IS NULL
    """, nativeQuery = true
    )
    @Modifying
    @Transactional
    fun endService(service: Int)
}