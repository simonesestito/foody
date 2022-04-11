package com.simonesestito.foody.springbackend.entity

import javax.persistence.*

@Entity(name = "CategoriaMenu")
data class MenuCategory(
    @Id var id: Int,
    var menu: Int,
    @Column(name = "titolo") var title: String,
    @ManyToMany
    @JoinTable(name = "ContenutoCategoriaMenu", joinColumns = [
        JoinColumn(name="categoria")
    ], inverseJoinColumns = [
        JoinColumn(name = "prodotto")
    ])
    var products: Set<Product>
)