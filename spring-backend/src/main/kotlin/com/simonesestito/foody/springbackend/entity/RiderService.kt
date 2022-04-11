package com.simonesestito.foody.springbackend.entity

import java.util.*
import javax.persistence.*

@Entity(name = "ServizioRider")
data class RiderService(
    @Id var id: Int,
    @ManyToOne
    @JoinColumn(name = "utente")
    var user: User,
    @Column(name = "ora_inizio")
    var start: Date,
    @Column(name = "ora_fine", nullable = true)
    var end: Date?,
    @AttributeOverrides(
        AttributeOverride(name = "latitude", column = Column(name = "latitudine_inizio")),
        AttributeOverride(name = "longitude", column = Column(name = "longitudine_inizio")),
    )
    var startLocation: Location,
    @AttributeOverrides(
        AttributeOverride(name = "latitude", column = Column(name = "latitudine_fine")),
        AttributeOverride(name = "longitude", column = Column(name = "longitudine_fine")),
    )
    var lastLocation: Location
)
