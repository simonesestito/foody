package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.User
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import javax.transaction.Transactional

@Repository
interface UserDao : CrudRepository<User, Int> {
    @Query("""
        SELECT DettagliUtente.*
        FROM DettagliUtente
        JOIN EmailUtente EU on DettagliUtente.id = EU.utente
        WHERE EU.email = ?1
    """, nativeQuery = true)
    fun getUserWithEmailAddress(email: String): User?

    @Query("SELECT * FROM DettagliUtente ORDER BY nome, cognome", nativeQuery = true)
    fun getAll(): Set<User>

    @Query("CALL registra_utente(?1, ?2, ?3, ?4, ?5)", nativeQuery = true)
    @Modifying
    @Transactional
    fun insertUser(name: String, surname: String, password: String, email: String, phone: String)

    @Query("DELETE FROM Utente WHERE id = ?1", nativeQuery = true)
    @Modifying
    @Transactional
    fun deleteUser(id: Int)

    @Query("CALL aggiorna_utente(?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8)", nativeQuery = true)
    @Modifying
    @Transactional
    fun updateUser(id: Int, name: String, surname: String, hashedPassword: String?, rider: Boolean, admin: Boolean, emails: String, phones: String)
}