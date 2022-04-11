package com.simonesestito.foody.springbackend.entity

import javax.persistence.*

@Entity(name = "Carrello")
data class Cart(
    @EmbeddedId var id: CartId,
    @Column(name = "utente", insertable = false, updatable = false) var user: Int,
    @ManyToOne @JoinColumn(name = "prodotto", insertable = false, updatable = false) var product: Product,
    @Column(name = "quantita") var quantity: Int,
)

@Embeddable
data class CartId(
    @Column(name = "utente", insertable = false, updatable = false) var user: Int,
    @Column(name = "prodotto", insertable = false, updatable = false) var product: Int,
) : java.io.Serializable

data class NewCartDto(
    val product: Int,
    val quantity: Int,
)
