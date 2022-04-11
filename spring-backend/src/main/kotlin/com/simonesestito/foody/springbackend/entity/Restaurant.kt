package com.simonesestito.foody.springbackend.entity

import org.hibernate.annotations.Immutable
import java.math.BigDecimal
import javax.persistence.*

@Entity(name = "Ristorante")
data class Restaurant(
    @Id var id: Int,
    @Column(name = "nome") var name: String,
    @Column(name = "pubblicato") var published: Boolean,
    var address: Address,
    @OneToMany(mappedBy = "restaurant") var openingHours: Set<OpeningHours>,
    @OneToMany(mappedBy = "restaurant") var menus: Set<Menu>,
    @ElementCollection @CollectionTable(
        name = "TelefonoRistorante",
        joinColumns = [JoinColumn(name = "ristorante")],
    ) @Column(name = "telefono") var phoneNumbers: Set<String>,
)

@Entity(name = "RistorantiConMenu")
@Immutable
data class RestaurantWithMenus(
    @Id var id: Int,
    @Column(name = "nome") var name: String,
    @Column(name = "pubblicato") var published: Boolean,
    @Embedded var address: Address,
    @OneToMany(mappedBy = "restaurant") var openingHours: Set<OpeningHours>,
    @OneToMany(mappedBy = "restaurant") var menus: Set<Menu>,
    @ElementCollection @CollectionTable(
        name = "TelefonoRistorante",
        joinColumns = [JoinColumn(name = "ristorante")],
    ) @Column(name = "telefono") var phoneNumbers: Set<String>,
    @Column(name = "voto_medio") var averageRating: BigDecimal?,
)