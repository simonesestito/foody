package com.simonesestito.foody.springbackend.entity

import javax.persistence.*

@Entity
data class User(
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) var id: Int?,
    var name: String,
    var surname: String,
    @Column(name = "password") var hashedPassword: String,
    @ElementCollection(fetch = FetchType.EAGER) @CollectionTable(
        name = "UserEmail",
        joinColumns = [JoinColumn(name = "user")],
    ) @Column(name = "email") var emailAddresses: Set<String>,
    @ElementCollection(fetch = FetchType.EAGER) @CollectionTable(
        name = "UserPhone",
        joinColumns = [JoinColumn(name = "user")],
    ) @Column(name = "phone") var phoneNumbers: Set<String>,
    @ElementCollection(fetch = FetchType.EAGER) @CollectionTable(
        name = "UserRoles",
        joinColumns = [JoinColumn(name = "user")],
    ) @Column(name = "role") var allowedRoles: Set<String>,
) {
    fun getAuthorities() = allowedRoles.map { GrantedAuthorityString(it) }
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