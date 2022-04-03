package com.simonesestito.foody.springbackend.entity

import java.util.*
import javax.persistence.*

@Entity
data class RiderService(
    @Id var id: Int,
    @ManyToOne
    @JoinColumn(name = "user")
    var user: User,
    @Column(name = "begin_time")
    var start: Date,
    @Column(name = "end_time", nullable = true)
    var end: Date?,
    @AttributeOverrides(
        AttributeOverride(name = "latitude", column = Column(name = "begin_latitude")),
        AttributeOverride(name = "longitude", column = Column(name = "begin_longitude")),
    )
    var startLocation: Location,
    @AttributeOverrides(
        AttributeOverride(name = "latitude", column = Column(name = "end_latitude")),
        AttributeOverride(name = "longitude", column = Column(name = "end_longitude")),
    )
    var lastLocation: Location
)
