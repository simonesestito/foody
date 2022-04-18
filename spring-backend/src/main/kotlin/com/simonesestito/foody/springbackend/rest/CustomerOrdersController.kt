package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.OrdersDao
import com.simonesestito.foody.springbackend.dao.OrdersService
import com.simonesestito.foody.springbackend.entity.Address
import com.simonesestito.foody.springbackend.entity.User
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/customer/orders")
class CustomerOrdersController(
    private val ordersDao: OrdersDao,
    private val ordersService: OrdersService,
) {
    @PostMapping("/")
    fun postOrder(
        @AuthenticationPrincipal user: User,
        @RequestBody address: Address,
        @RequestParam("notes") notes: String?,
    ) {
        ordersService.postOrderFromCart(
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