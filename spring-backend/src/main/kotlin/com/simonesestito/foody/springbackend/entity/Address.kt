package com.simonesestito.foody.springbackend.entity

import javax.persistence.Column
import javax.persistence.Embeddable

@Embeddable
data class Address(
    @Column(name = "address_street") var address: String,
    @Column(length = 10, name = "address_house_number") var houseNumber: String?,
    @Column(length = 64, name = "address_city") var city: String,
    var location: Location,
)

@Embeddable
data class Location(
    @Column(name = "address_latitude") var latitude: Double,
    @Column(name = "address_longitude") var longitude: Double,
)