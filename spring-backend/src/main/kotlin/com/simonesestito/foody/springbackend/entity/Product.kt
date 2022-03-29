package com.simonesestito.foody.springbackend.entity

import javax.persistence.CollectionTable
import javax.persistence.Column
import javax.persistence.ElementCollection
import javax.persistence.Embeddable
import javax.persistence.EmbeddedId
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.OneToMany

@Entity
data class Product(
    @Id var id: Int,
    var restaurant: Int,
    var name: String,
    var description: String?,
    var price: Double,
    @ElementCollection @CollectionTable(
        name = "ProductAllergens",
        joinColumns = [JoinColumn(name = "product")],
    ) @Column(name = "allergen") var allergens: Set<String>,
)