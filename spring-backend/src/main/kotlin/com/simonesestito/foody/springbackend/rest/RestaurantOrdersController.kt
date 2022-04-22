package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.OrdersDao
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/orders")
class RestaurantOrdersController(
    private val ordersDao: OrdersDao,
) {
    @PostMapping("/{id}/state/{state}")
    fun updateState(
        @PathVariable("id") orderId: Int,
        @PathVariable("state") stateName: String,
    ) {
        println(orderId)
        println(stateName)
        ordersDao.updateOrderStatus(orderId, stateName)
    }

    @GetMapping("/prepared")
    fun getPreparedOrders(
        @RequestParam("latitude") latitude: Double,
        @RequestParam("longitude") longitude: Double,
    ) = ordersDao.getNearPreparedOrders(latitude, longitude)
}