package com.simonesestito.foody.springbackend.entity

import org.hibernate.annotations.Immutable
import java.util.*
import javax.persistence.*

@Entity
data class RestaurantOrder(
    @Id var id: Int,
    var status: Int,
    var creation: Date,
    var notes: String?,
    @Embedded var address: Address,
    @ManyToOne
    @JoinColumn(name = "user")
    var user: User,
    @ManyToOne
    @JoinColumn(name = "rider_service")
    var riderService: RiderService,
    @OneToMany
    @JoinColumn(name = "restaurant_order")
    var orderContent: Set<OrderContent>,
)

@Entity
@Immutable
data class OrderContent(
    @EmbeddedId var id: OrderProductId,
    @ManyToOne
    @JoinColumn(name = "product", insertable = false, updatable = false)
    var product: Product,
    var quantity: Int,
)

@Embeddable
data class OrderProductId(
    var product: Int,
    @Column(name = "restaurant_order") var restaurantOrder: Int,
) : java.io.Serializable