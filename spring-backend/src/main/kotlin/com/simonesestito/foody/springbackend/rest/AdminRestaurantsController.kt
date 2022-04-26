package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.RestaurantDao
import com.simonesestito.foody.springbackend.entity.Restaurant
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/admin/restaurants")
class AdminRestaurantsController(private val restaurantDao: RestaurantDao) {
    @GetMapping("/")
    fun getAll() = restaurantDao.getAll()

    @PostMapping("/{email}")
    fun addNew(@PathVariable("email") managerEmail: String, @RequestBody restaurant: Restaurant) =
        restaurantDao.insertRestaurant(
            restaurant.name,
            restaurant.published,
            restaurant.phoneNumbers.joinToString("\n"),
            restaurant.address.address,
            restaurant.address.houseNumber,
            restaurant.address.city,
            restaurant.address.location.latitude,
            restaurant.address.location.longitude,
            managerEmail
        )

    @PostMapping("/")
    fun updateRestaurant(@RequestBody restaurant: Restaurant) =
        restaurantDao.updateRestaurant(
            restaurant.id,
            restaurant.name,
            restaurant.published,
            restaurant.phoneNumbers.joinToString("\n"),
            restaurant.address.address,
            restaurant.address.houseNumber,
            restaurant.address.city,
            restaurant.address.location.latitude,
            restaurant.address.location.longitude,
        )

    @DeleteMapping("/{id}")
    fun deleteRestaurant(@PathVariable("id") id: Int) = restaurantDao.deleteRestaurant(id)
}