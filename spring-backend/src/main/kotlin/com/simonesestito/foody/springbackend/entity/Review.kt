package com.simonesestito.foody.springbackend.entity

import java.sql.Timestamp
import java.util.Date
import javax.persistence.Column
import javax.persistence.Embeddable
import javax.persistence.EmbeddedId
import javax.persistence.Entity
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne

@Entity(name = "Recensione")
data class Review(
    @EmbeddedId var id: ReviewId,
    @ManyToOne @JoinColumn(name = "ristorante", insertable = false, updatable = false) var restaurant: Restaurant,
    @ManyToOne @JoinColumn(name = "utente", insertable = false, updatable = false) var user: User,
    @Column(name = "creazione") var creationDate: Timestamp,
    @Column(name = "voto") var mark: Int,
    @Column(name = "titolo") var title: String?,
    @Column(name = "testo") var description: String?,
)

@Embeddable
data class ReviewId(
    @Column(name = "ristorante", insertable = false, updatable = false) var restaurantId: Int,
    @Column(name = "utente", insertable = false, updatable = false) var userId: Int,
) : java.io.Serializable

data class NewReviewDto(
    var mark: Int,
    var title: String?,
    var description: String?,
)
