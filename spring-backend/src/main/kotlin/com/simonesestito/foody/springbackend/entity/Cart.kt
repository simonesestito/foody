package com.simonesestito.foody.springbackend.entity

import javax.persistence.*

@Entity
data class Cart(
    @EmbeddedId var id: CartId,
    @Column(insertable = false, updatable = false) var user: Int,
    @ManyToOne @JoinColumn(name = "product", insertable = false, updatable = false) var product: Product,
    var quantity: Int,
)

@Embeddable
data class CartId(
    @Column(insertable = false, updatable = false) var user: Int,
    @Column(insertable = false, updatable = false) var product: Int,
) : java.io.Serializable

data class NewCartDto(
    val product: Int,
    val quantity: Int,
)
