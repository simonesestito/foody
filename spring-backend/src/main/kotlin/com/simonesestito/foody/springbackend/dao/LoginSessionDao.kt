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
        FROM LoginSession 
        WHERE user = ?1
    """, nativeQuery = true
    )
    fun getByUserId(userId: Int): Set<LoginSession>

    fun getByToken(token: String): LoginSession?

    fun deleteByToken(token: String)

    @Query("UPDATE LoginSession SET last_usage = NOW() WHERE token = ?1", nativeQuery = true)
    @Modifying
    @Transactional
    fun refreshSession(token: String)
}