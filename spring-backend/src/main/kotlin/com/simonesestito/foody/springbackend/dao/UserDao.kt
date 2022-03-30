package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.User
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@Repository
interface UserDao : CrudRepository<User, Int> {
    @Query("""
        SELECT *
        FROM User
        LEFT JOIN UserEmail AS UE on User.id = UE.user
        WHERE UE.email = ?1
    """, nativeQuery = true)
    fun getUserWithEmailAddress(email: String): User?
}