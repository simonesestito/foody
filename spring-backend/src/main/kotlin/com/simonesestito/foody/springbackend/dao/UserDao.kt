package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.User
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import javax.transaction.Transactional

@Repository
interface UserDao : CrudRepository<User, Int> {
    @Query("SELECT * FROM DettagliUtente WHERE email = ?1", nativeQuery = true)
    fun getUserWithEmailAddress(email: String): User?

    @Query("CALL registra_utente(?1, ?2, ?3, ?4, ?5)", nativeQuery = true)
    @Modifying
    @Transactional
    fun insertUser(name: String, surname: String, password: String, email: String, phone: String)
}