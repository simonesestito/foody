package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.Restaurant
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@Repository
interface RestaurantDao: org.springframework.data.repository.Repository<Restaurant, Int> {
    @Query("SELECT * FROM Restaurant", nativeQuery = true)
    fun getAll(): Set<Restaurant>
}