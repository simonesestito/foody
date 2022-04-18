package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.OrdersDao
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

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
}