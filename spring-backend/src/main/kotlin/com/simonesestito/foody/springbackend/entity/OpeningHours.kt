package com.simonesestito.foody.springbackend.entity

import java.sql.Time
import javax.persistence.*

@Entity
@IdClass(OpeningHoursId::class)
data class OpeningHours(
    @Id var weekday: Int,
    @Id @JoinColumn(name = "restaurant") var restaurant: Int,
    @Id @Column(name = "opening_time") var openingTime: Time,
    @Column(name = "closing_time") var closingTime: Time,
)

data class OpeningHoursId @JvmOverloads constructor (
    var weekday: Int? = null,
    var restaurant: Int? = null,
    var openingTime: Time? = null,
) : java.io.Serializable