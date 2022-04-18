package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.OrdersDao
import com.simonesestito.foody.springbackend.dao.RestaurantDao
import com.simonesestito.foody.springbackend.dao.RestaurantService
import com.simonesestito.foody.springbackend.dao.ReviewDao
import com.simonesestito.foody.springbackend.entity.NewReviewDto
import com.simonesestito.foody.springbackend.entity.OpeningHours
import com.simonesestito.foody.springbackend.entity.User
import com.simonesestito.foody.springbackend.rest.errors.NotFoundException
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/restaurant")
class RestaurantController(
    private val restaurantDao: RestaurantDao,
    private val restaurantService: RestaurantService,
    private val ordersDao: OrdersDao,
    private val reviewDao: ReviewDao,
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
        reviewDao.insertReview(
            review.mark, review.title, review.description, restaurantId, userId
        )
    }

    @GetMapping("/{id}/review")
    fun getReviews(@PathVariable("id") restaurantId: Int) = reviewDao.getReviews(restaurantId)

    @DeleteMapping("/{id}/review/{user}")
    fun getReviews(
        @PathVariable("id") restaurantId: Int, @PathVariable("user") userId: Int,
    ) = reviewDao.deleteReview(restaurantId, userId)

    @GetMapping("/my")
    fun getMyRestaurants(@AuthenticationPrincipal user: User) = restaurantDao.getByManager(user.id!!)

    @GetMapping("/{id}/orders")
    fun getOrders(
        @PathVariable("id") restaurantId: Int
    ) = ordersDao.getAllByRestaurant(restaurantId)

    @PostMapping("/{id}/timetable")
    fun updateTimetable(
        @PathVariable("id") restaurantId: Int,
        @RequestBody timetable: List<OpeningHours>
    ) {
        restaurantService.updateTimetable(restaurantId, timetable)
    }
}