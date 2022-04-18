package com.simonesestito.foody.springbackend.entity

import javax.persistence.*

@Entity(name = "Utente")
data class User(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) var id: Int?,
    @Column(name = "nome") var name: String,
    @Column(name = "cognome") var surname: String,
    @Column(name = "password") var hashedPassword: String,
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
    @OneToMany(mappedBy = "user", fetch = FetchType.EAGER) var managerJobs: Set<OrdersManagement>,
) {
    fun getAuthorities() = getAllowedRoles().map { GrantedAuthorityString(it) }

    fun getAllowedRoles() = setOfNotNull(
        "cliente",
        if (rider) "rider" else null,
        if (admin) "admin" else null,
        if (managerJobs.any { it.endDate == null }) "manager" else null,
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