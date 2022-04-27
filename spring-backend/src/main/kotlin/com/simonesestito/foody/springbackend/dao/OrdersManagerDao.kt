package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.OrdersManagement
import com.simonesestito.foody.springbackend.entity.OrdersManagementId
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository

@Repository
interface OrdersManagerDao: CrudRepository<OrdersManagement, OrdersManagementId> {
    fun existsByUserIdAndRestaurantAndEndDateIsNull(user: Int, restaurant: Int): Boolean
}