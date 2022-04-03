package com.simonesestito.foody.springbackend.dao

import com.simonesestito.foody.springbackend.entity.RestaurantOrder
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import org.springframework.stereotype.Repository
import org.springframework.stereotype.Service
import java.math.BigInteger
import javax.persistence.EntityManager
import javax.transaction.Transactional

@Repository
interface OrdersDao : CrudRepository<RestaurantOrder, Int> {
    @Query(
        """
        SELECT *
        FROM RestaurantOrder
        INNER JOIN User ON User.id = RestaurantOrder.user = User.id
        LEFT JOIN RiderService AS RS on User.id = RS.user
        LEFT JOIN OrderContent AS OC on RestaurantOrder.id = OC.restaurant_order
        LEFT JOIN Product AS P on OC.product = P.id
        WHERE RestaurantOrder.user = ?1 
    """, nativeQuery = true
    )
    fun getAllByUserId(userId: Int): Set<RestaurantOrder>
}

@Service
class OrdersService(
    private val session: EntityManager,
) {
    @Transactional
    fun postOrderFromCart(
        notes: String?,
        street: String,
        houseNumber: String?,
        city: String,
        latitude: Double,
        longitude: Double,
        customerId: Int,
    ) {
        session.createNativeQuery(
            """
        INSERT INTO RestaurantOrder
        (notes, address_street, address_house_number, address_city, address_latitude, address_longitude, user, rider_service)
        VALUES
        (?1, ?2, ?3, ?4, ?5, ?6, ?7, NULL)
        """.trimIndent()
        )
            .setParameter(1, notes)
            .setParameter(2, street)
            .setParameter(3, houseNumber)
            .setParameter(4, city)
            .setParameter(5, latitude)
            .setParameter(6, longitude)
            .setParameter(7, customerId)
            .executeUpdate()

        val orderId = session.createNativeQuery("SELECT LAST_INSERT_ID()").singleResult as BigInteger
        println("ORDER >>>>>>>>>>>>> $orderId")

        session.createNativeQuery(
            """
        INSERT INTO OrderContent (product, restaurant_order, quantity)
        SELECT product, ?1, quantity 
        FROM Cart, Product
        WHERE Cart.product = Product.id
        AND user = ?2
        """.trimIndent()
        )
            .setParameter(1, orderId)
            .setParameter(2, customerId)
            .executeUpdate()

        session.createNativeQuery(
            """
            DELETE FROM Cart WHERE user = ?1
        """.trimIndent()
        )
            .setParameter(1, customerId)
            .executeUpdate()
    }
}