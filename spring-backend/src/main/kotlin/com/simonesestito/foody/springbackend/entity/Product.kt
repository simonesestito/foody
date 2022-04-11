package com.simonesestito.foody.springbackend.entity

import javax.persistence.*

@Entity(name = "Prodotto")
data class Product(
    @Id var id: Int,
    @Column(name = "ristorante") var restaurant: Int,
    @Column(name = "nome") var name: String,
    @Column(name = "descrizione") var description: String?,
    @Column(name = "prezzo") var price: Double,
    @ElementCollection @CollectionTable(
        name = "AllergeniProdotto",
        joinColumns = [JoinColumn(name = "prodotto")],
    ) @Column(name = "allergene") var allergens: Set<String>,
)