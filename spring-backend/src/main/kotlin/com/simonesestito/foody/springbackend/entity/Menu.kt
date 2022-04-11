package com.simonesestito.foody.springbackend.entity

import javax.persistence.*

@Entity
data class Menu(
    @Id var id: Int,
    @Column(name = "titolo") var title: String,
    @Column(name = "ristorante") var restaurant: Int,
    @Column(name = "pubblicato") var published: Boolean,
    @OneToMany(mappedBy = "menu")
    var categories: Set<MenuCategory>
)