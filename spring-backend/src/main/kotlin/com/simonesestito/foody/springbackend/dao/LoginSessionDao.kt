package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.LoginSession
import org.springframework.data.jpa.repository.Modifying
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import javax.transaction.Transactional

@Repository
interface LoginSessionDao : CrudRepository<LoginSession, String> {
    @Query(
        """
        SELECT *
        FROM SessioneLogin
        JOIN Utente on Utente.id = SessioneLogin.utente
        WHERE utente = ?1
    """, nativeQuery = true
    )
    fun getByUserId(userId: Int): Set<LoginSession>

    @Query("SELECT * FROM SessioneLogin WHERE token = ?1", nativeQuery = true)
    fun getByToken(token: String): LoginSession?

    @Query("DELETE FROM SessioneLogin WHERE token = ?1", nativeQuery = true)
    @Modifying
    @Transactional
    fun deleteByToken(token: String)

    @Query("UPDATE SessioneLogin SET ultimo_uso = NOW() WHERE token = ?1", nativeQuery = true)
    @Modifying
    @Transactional
    fun refreshSession(token: String)
}