package com.simonesestito.foody.springbackend.entity

import org.hibernate.annotations.Immutable
import javax.persistence.*

@Entity(name = "DettagliCategoria")
@Immutable
data class MenuCategory(
    @Id var id: Int,
    var menu: Int,
    @Column(name = "titolo") var title: String,
    @ManyToMany @JoinTable(
        name = "ContenutoCategoriaMenu",
        joinColumns = [JoinColumn(name = "categoria")],
        inverseJoinColumns = [JoinColumn(name = "prodotto")]
    ) var products: Set<Product>,
    @Column(name = "numero_prodotti") var productsCount: Long,
)