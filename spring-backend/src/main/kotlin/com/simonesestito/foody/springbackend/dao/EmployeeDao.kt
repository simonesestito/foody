package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.OrdersManagement
import com.simonesestito.foody.springbackend.entity.OrdersManagementId
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@Repository
interface EmployeeDao : CrudRepository<OrdersManagement, OrdersManagementId> {
    @Query(
        """
        SELECT *
        FROM GestioneOrdini
        JOIN Utente U on GestioneOrdini.utente = U.id
        WHERE GestioneOrdini.ristorante = ?1
    """, nativeQuery = true
    )
    fun getEmployees(restaurantId: Int): Set<OrdersManagement>

    @Query(
        """
        UPDATE GestioneOrdini
        SET data_fine = NOW()
        WHERE ristorante = ?1 AND utente = ?2 AND data_fine IS NULL
    """, nativeQuery = true
    )
    fun fireEmployee(restaurantId: Int, employeeId: Int): Set<OrdersManagement>

    @Query(
        """
        INSERT INTO GestioneOrdini (data_inizio, data_fine, ristorante, utente)
        VALUES (NOW(), NULL, ?1, (
            SELECT utente FROM EmailUtente WHERE email = ?2
        ))
    """, nativeQuery = true
    )
    fun hireEmployeeByEmail(restaurantId: Int, employeeEmail: String): Set<OrdersManagement>
}