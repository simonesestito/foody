package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.User
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@Repository
interface UserDao : CrudRepository<User, Int> {
    @Query("""
        SELECT Utente.*
        FROM Utente
        LEFT JOIN EmailUtente ON Utente.id = EmailUtente.utente
        LEFT JOIN TelefonoUtente ON Utente.id = TelefonoUtente.utente
        WHERE EmailUtente.email = ?1
    """, nativeQuery = true)
    fun getUserWithEmailAddress(email: String): User?
}