package com.simonesestito.foody.springbackend.entity

import javax.persistence.*

@Entity
data class Restaurant(
    @Id var id: Int,
    var name: String,
    var published: Boolean,
    var address: Address,
    @OneToMany(mappedBy = "restaurant")
    var openingHours: Set<OpeningHours>,
    @OneToMany(mappedBy = "restaurant")
    var menus: Set<Menu>,
    @ElementCollection @CollectionTable(
        name = "RestaurantPhone",
        joinColumns = [JoinColumn(name = "restaurant")],
    ) @Column(name = "phone") var phoneNumbers: Set<String>,
)