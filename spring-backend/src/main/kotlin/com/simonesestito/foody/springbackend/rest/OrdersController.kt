package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.OrdersDao
import com.simonesestito.foody.springbackend.dao.OrdersService
import com.simonesestito.foody.springbackend.entity.Address
import com.simonesestito.foody.springbackend.entity.User
import org.hibernate.Session
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import javax.persistence.EntityManager
import javax.persistence.EntityManagerFactory
import javax.persistence.SynchronizationType

@RestController
@RequestMapping("/api/customer/orders")
class OrdersController(
    private val ordersDao: OrdersDao,
    private val ordersService: OrdersService,
) {
    @PostMapping("/")
    fun postOrder(@AuthenticationPrincipal user: User, @RequestBody address: Address) {
        ordersService.postOrderFromCart(
            null, // TODO: Add order notes, which MAY be null
            address.address,
            address.houseNumber,
            address.city,
            address.location.latitude,
            address.location.longitude,
            user.id!!
        )
    }

    @GetMapping("/")
    fun getOrders(@AuthenticationPrincipal user: User) =
        ordersDao.getAllByUserId(user.id!!)
}