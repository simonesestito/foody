package com.simonesestito.foody.springbackend.entity

import java.sql.Time
import javax.persistence.*

@Entity(name = "OrariDiApertura")
@IdClass(OpeningHoursId::class)
data class OpeningHours(
    @Id @Column(name = "giorno") var weekday: Int,
    @Id @JoinColumn(name = "ristorante") var restaurant: Int,
    @Id @Column(name = "apertura") var openingTime: Time,
    @Column(name = "chiusura") var closingTime: Time,
)

data class OpeningHoursId @JvmOverloads constructor (
    @Column(name = "giorno") var weekday: Int? = null,
    @Column(name = "ristorante") var restaurant: Int? = null,
    @Column(name = "apertura") var openingTime: Time? = null,
) : java.io.Serializable