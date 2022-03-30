package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.RestaurantWithMenus
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository

@Repository
interface RestaurantDao : org.springframework.data.repository.Repository<RestaurantWithMenus, Int> {
    @Query(
        """
        SELECT *
        FROM RestaurantsWithMenus
        WHERE name LIKE ?1
        ORDER BY DISTANCE_KM(?2, ?3, address_latitude, address_longitude)
    """, nativeQuery = true
    )
    fun getAll(namePattern: String, latitude: Double, longitude: Double): Set<RestaurantWithMenus>

    @Query(
        """
        SELECT *
        FROM RestaurantsWithMenus
        WHERE id LIKE ?1 
        """, nativeQuery = true
    )
    fun getById(id: Int): RestaurantWithMenus?
}