package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.RestaurantDao
import com.simonesestito.foody.springbackend.rest.errors.NotFoundException
import org.springframework.beans.factory.annotation.Value
import org.springframework.core.env.Environment
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/restaurant")
class RestaurantController(
    private val restaurantDao: RestaurantDao,
    private val env: Environment,
) {
    @GetMapping("/")
    fun getNear(
        @RequestParam("latitude") latitude: Double,
        @RequestParam("longitude") longitude: Double,
        @RequestParam("query", defaultValue = "") query: String,
    ) = restaurantDao.getAll("%$query%", latitude, longitude)

    @GetMapping("/{id}")
    fun getById(@PathVariable("id") id: Int) = restaurantDao.getById(id) ?: throw NotFoundException()
}