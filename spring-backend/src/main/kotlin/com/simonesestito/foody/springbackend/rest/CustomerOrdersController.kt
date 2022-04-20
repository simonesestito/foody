package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.OrdersDao
import com.simonesestito.foody.springbackend.entity.Address
import com.simonesestito.foody.springbackend.entity.User
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/customer/orders")
class CustomerOrdersController(private val ordersDao: OrdersDao) {
    @PostMapping("/")
    fun postOrder(
        @AuthenticationPrincipal user: User,
        @RequestBody address: Address,
        @RequestParam("notes") notes: String?,
    ) {
        ordersDao.postOrderFromCart(
            notes.let { if (it.isNullOrBlank()) null else it },
            address.address,
            address.houseNumber.let { if (it.isNullOrBlank()) null else it },
            address.city,
            address.location.latitude,
            address.location.longitude,
            user.id!!
        )
    }

    @GetMapping("/")
    fun getOrders(@AuthenticationPrincipal user: User) = ordersDao.getAllByUserId(user.id!!)
}