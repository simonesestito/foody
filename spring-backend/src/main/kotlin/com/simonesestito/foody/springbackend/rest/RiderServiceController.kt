package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.OrdersDao
import com.simonesestito.foody.springbackend.dao.RiderServiceDao
import com.simonesestito.foody.springbackend.entity.Location
import com.simonesestito.foody.springbackend.entity.User
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/service")
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

    @DeleteMapping("/{id}")
    fun endService(@PathVariable("id") serviceId: Int) = riderServiceDao.endService(serviceId)

    @PostMapping("/{id}/location")
    fun updateLocation(@PathVariable("id") serviceId: Int, @RequestBody location: Location) =
        riderServiceDao.updateLocation(
            serviceId, location.latitude, location.longitude,
        )

    @PostMapping("/{id}/deliver/{order}")
    fun beginOrderDelivery(@PathVariable("id") serviceId: Int, @PathVariable("order") orderId: Int) =
        riderServiceDao.beginOrderDelivery(serviceId, orderId)

    @DeleteMapping("/{id}/deliver/{order}")
    fun endOrderDelivery(@PathVariable("id") serviceId: Int, @PathVariable("order") orderId: Int) =
        riderServiceDao.endOrderDelivery(serviceId, orderId)
}