package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.OrdersDao
import com.simonesestito.foody.springbackend.dao.RiderServiceDao
import com.simonesestito.foody.springbackend.entity.Location
import com.simonesestito.foody.springbackend.entity.User
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/service")
class RiderServiceController(
    private val riderServiceDao: RiderServiceDao,
    private val ordersDao: OrdersDao,
) {
    @GetMapping("/active")
    fun getActiveService(@AuthenticationPrincipal user: User) = riderServiceDao.getActiveServiceForUser(user.id!!)

    @GetMapping("/")
    fun getAll(@AuthenticationPrincipal user: User) = riderServiceDao.getUserServices(user.id!!)

    @GetMapping("/{id}/orders")
    fun getOrdersForService(@PathVariable("id") serviceId: Int) = ordersDao.getOrdersForService(serviceId)

    @PostMapping("/")
    fun startService(@AuthenticationPrincipal user: User, @RequestBody location: Location) =
        riderServiceDao.startNewService(
            user.id!!, location.latitude, location.longitude,
        )

    @DeleteMapping("/")
    fun endService(@AuthenticationPrincipal user: User) = riderServiceDao.endCurrentService(user.id!!)

    @PostMapping("/location")
    fun updateLocation(@AuthenticationPrincipal user: User, @RequestBody location: Location) =
        riderServiceDao.updateCurrentServiceLocation(
            user.id!!, location.latitude, location.longitude,
        )

    @PostMapping("/deliver/{order}")
    fun beginOrderDelivery(@AuthenticationPrincipal user: User, @PathVariable("order") orderId: Int) =
        riderServiceDao.beginOrderDelivery(user.id!!, orderId)

    @DeleteMapping("/deliver/{order}")
    fun endOrderDelivery(@AuthenticationPrincipal user: User, @PathVariable("order") orderId: Int) =
        riderServiceDao.endOrderDelivery(user.id!!, orderId)

    @GetMapping("/deliver")
    fun getCurrentDeliveringOrder(@AuthenticationPrincipal user: User) = ordersDao.getCurrentDeliveringOrder(user.id!!)
}