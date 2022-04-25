package com.simonesestito.foody.springbackend.entity

import org.hibernate.annotations.Immutable
import java.math.BigInteger
import javax.persistence.*

@Entity(name = "DettagliUtente")
@Immutable
data class User(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) var id: Int?,
    @Column(name = "nome") var name: String,
    @Column(name = "cognome") var surname: String,
    var password: String?,
    @ElementCollection(fetch = FetchType.EAGER) @CollectionTable(
        name = "EmailUtente",
        joinColumns = [JoinColumn(name = "utente")],
    ) @Column(name = "email") var emailAddresses: Set<String>,
    @ElementCollection(fetch = FetchType.EAGER) @CollectionTable(
        name = "TelefonoUtente",
        joinColumns = [JoinColumn(name = "utente")],
    ) @Column(name = "telefono") var phoneNumbers: Set<String>,
    var rider: Boolean,
    var admin: Boolean,
    @Column(name = "numero_ristoranti") var restaurantsNumber: Long,
) {
    fun getAuthorities() = getAllowedRoles().map { GrantedAuthorityString(it) }

    private fun getAllowedRoles() = setOfNotNull(
        "cliente",
        if (rider) "rider" else null,
        if (admin) "admin" else null,
        if (restaurantsNumber > 0) "manager" else null,
    )
}

/**
 * New User Data Transfer Object
 */
data class NewUserDto(
    var name: String,
    var surname: String,
    var emailAddress: String,
    var password: String,
    var phoneNumber: String,
)