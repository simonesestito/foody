package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.RestaurantDao
import com.simonesestito.foody.springbackend.entity.Restaurant
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/restaurant")
class RestaurantController(
    private val restaurantDao: RestaurantDao,
) {
    @GetMapping("/")
    fun getNear(
        @RequestParam("latitude") latitude: Double,
        @RequestParam("longitude") longitude: Double,
        @RequestParam("query", defaultValue = "") query: String,
    ) = restaurantDao.getAll() // TODO: Apply query params
}