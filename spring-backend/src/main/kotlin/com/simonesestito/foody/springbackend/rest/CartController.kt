package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.CartDao
import com.simonesestito.foody.springbackend.entity.Cart
import com.simonesestito.foody.springbackend.entity.CartId
import com.simonesestito.foody.springbackend.entity.NewCartDto
import com.simonesestito.foody.springbackend.entity.User
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/customer/cart")
class CartController(
    private val cartDao: CartDao,
) {
    @GetMapping("/")
    fun getCustomerCart(@AuthenticationPrincipal user: User) =
        cartDao.getAllByUser(user.id!!)

    @PostMapping("/")
    fun addToCart(@AuthenticationPrincipal user: User, @RequestBody product: NewCartDto) {
        cartDao.insertProduct(user.id!!, product.product, product.quantity)
    }

    @DeleteMapping("/{product}")
    fun removeFromCart(@AuthenticationPrincipal user: User, @PathVariable product: Int) {
        cartDao.deleteProduct(user.id!!, product)
    }
}