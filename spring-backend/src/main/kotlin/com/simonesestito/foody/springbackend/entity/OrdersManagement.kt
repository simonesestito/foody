package com.simonesestito.foody.springbackend.entity

import java.sql.Timestamp
import java.time.Instant
import javax.persistence.*

@Entity(name = "GestioneOrdini")
data class OrdersManagement(
    @EmbeddedId var id: OrdersManagementId,
    @Column(name = "data_inizio", insertable = false, updatable = false) var startDate: Timestamp,
    @ManyToOne @JoinColumn(name = "utente", insertable = false, updatable = false) var user: User,
    @Column(name = "ristorante", insertable = false, updatable = false) var restaurant: Int,
    @Column(name = "data_fine") var endDate: Timestamp?,
)

@Embeddable
data class OrdersManagementId @JvmOverloads constructor(
    @Column(name = "data_inizio", insertable = false, updatable = false) var startDate: Timestamp = Timestamp.from(
        Instant.now()
    ),
    @Column(name = "utente", insertable = false, updatable = false) var user: Int = 0,
    @Column(name = "ristorante", insertable = false, updatable = false) var restaurant: Int = 0,
) : java.io.Serializable
