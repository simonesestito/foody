package com.simonesestito.foody.springbackend.entity

import javax.persistence.*

@Entity
data class MenuCategory(
    @Id var id: Int,
    var menu: Int,
    var title: String,
    @ManyToMany
    @JoinTable(name = "MenuCategoryContent", joinColumns = [
        JoinColumn(name="category")
    ], inverseJoinColumns = [
        JoinColumn(name = "product")
    ])
    var products: Set<Product>
)