package com.simonesestito.foody.springbackend.entity

import org.hibernate.annotations.Immutable
import java.util.*
import javax.persistence.*

@Entity(name = "OrdineRistorante")
data class RestaurantOrder(
    @Id var id: Int,
    @Column(name = "stato") var status: Int,
    @Column(name = "creazione") var creation: Date,
    @Column(name = "note") var notes: String?,
    @Embedded var address: Address,
    @ManyToOne
    @JoinColumn(name = "utente")
    var user: User,
    @ManyToOne
    @JoinColumn(name = "servizio_rider")
    var riderService: RiderService?,
    @OneToMany
    @JoinColumn(name = "ordine_ristorante")
    var orderContent: Set<OrderContent>,
)

@Entity(name = "ContenutoOrdine")
@Immutable
data class OrderContent(
    @EmbeddedId var id: OrderProductId,
    @ManyToOne
    @JoinColumn(name = "prodotto", insertable = false, updatable = false)
    var product: Product,
    @Column(name = "quantita") var quantity: Int,
)

@Embeddable
data class OrderProductId(
    @Column(name = "prodotto") var product: Int,
    @Column(name = "ordine_ristorante") var restaurantOrder: Int,
) : java.io.Serializable