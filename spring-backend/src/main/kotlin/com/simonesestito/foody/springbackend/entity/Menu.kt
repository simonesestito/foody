package com.simonesestito.foody.springbackend.entity

import javax.persistence.*

@Entity
data class Menu(
    @Id var id: Int,
    var title: String,
    var restaurant: Int,
    var published: Boolean,
    @OneToMany(mappedBy = "menu")
    var categories: Set<MenuCategory>
)