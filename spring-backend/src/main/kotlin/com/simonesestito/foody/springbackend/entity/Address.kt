package com.simonesestito.foody.springbackend.entity

import javax.persistence.Column
import javax.persistence.Embeddable

@Embeddable
data class Address(
    @Column(name = "indirizzo_via") var address: String,
    @Column(name = "indirizzo_civico") var houseNumber: String?,
    @Column(name = "indirizzo_citta") var city: String,
    var location: Location,
)

@Embeddable
data class Location(
    @Column(name = "indirizzo_latitudine") var latitude: Double,
    @Column(name = "indirizzo_longitudine") var longitude: Double,
)