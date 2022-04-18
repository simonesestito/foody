package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.RestaurantDao
import com.simonesestito.foody.springbackend.entity.NewReviewDto
import com.simonesestito.foody.springbackend.rest.errors.NotFoundException
import org.springframework.web.bind.annotation.*

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
    ) = restaurantDao.getAll("%$query%", latitude, longitude)

    @GetMapping("/{id}")
    fun getById(@PathVariable("id") id: Int) = restaurantDao.getById(id) ?: throw NotFoundException()

    @PostMapping("/{id}/review/{user}")
    fun postReview(
        @RequestBody review: NewReviewDto,
        @PathVariable("id") restaurantId: Int,
        @PathVariable("user") userId: Int,
    ) {
        restaurantDao.insertReview(
            review.mark, review.title, review.description, restaurantId, userId
        )
    }

    @GetMapping("/{id}/review")
    fun getReviews(@PathVariable("id") restaurantId: Int) = restaurantDao.getReviews(restaurantId)

    @DeleteMapping("/{id}/review/{user}")
    fun getReviews(
        @PathVariable("id") restaurantId: Int, @PathVariable("user") userId: Int,
    ) = restaurantDao.deleteReview(restaurantId, userId)
}