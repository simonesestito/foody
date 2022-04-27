package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.OrdersDao
import com.simonesestito.foody.springbackend.dao.OrdersManagerDao
import com.simonesestito.foody.springbackend.dao.UserDao
import com.simonesestito.foody.springbackend.entity.OrdersManagementId
import com.simonesestito.foody.springbackend.entity.User
import org.springframework.http.HttpStatus
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.*
import javax.servlet.http.HttpServletResponse

@RestController
@RequestMapping("/api/orders")
class RestaurantOrdersController(
    private val ordersManagerDao: OrdersManagerDao,
    private val ordersDao: OrdersDao,
) {
    @PostMapping("/{id}/state/{state}")
    fun updateState(
        @AuthenticationPrincipal user: User,
        @PathVariable("id") orderId: Int,
        @PathVariable("state") stateName: String,
        httpServletResponse: HttpServletResponse,
    ) {
        val restaurantId = ordersDao.getById(orderId)?.orderContent?.firstOrNull()?.product?.restaurant?.id ?: 0
        if (ordersManagerDao.existsByUserIdAndRestaurantAndEndDateIsNull(user.id!!, restaurantId)) {
            ordersDao.updateOrderStatus(orderId, stateName)
        } else {
            httpServletResponse.sendError(HttpStatus.FORBIDDEN.value())
        }
    }

    @GetMapping("/prepared")
    fun getPreparedOrders(
        @RequestParam("latitude") latitude: Double,
        @RequestParam("longitude") longitude: Double,
    ) = ordersDao.getNearPreparedOrders(latitude, longitude)
}