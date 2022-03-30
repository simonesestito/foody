package com.simonesestito.foody.springbackend.entity

import org.springframework.security.core.GrantedAuthority
import java.util.*
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.JoinColumn
import javax.persistence.ManyToOne

@Entity
data class LoginSession(
    @Id var token: String,
    @Column(name = "agent") var userAgent: String,
    @Column(name = "ip") var lastIpAddress: String,
    @Column(name = "creation") var creationDate: Date,
    @Column(name = "last_usage") var lastUsageDate: Date,
    @ManyToOne
    @JoinColumn(name = "user")
    var user: User
)

data class UserSessionDto(
    var token: String,
    var userAgent: String,
    var lastIpAddress: String,
    var creationDate: Date,
    var lastUsageDate: Date,
    var isCurrent: Boolean,
)

class GrantedAuthorityString(private val role: String) : GrantedAuthority {
    override fun getAuthority() = role

    override fun equals(other: Any?): Boolean {
        if (other !is GrantedAuthorityString)
            return false
        return other.role == this.role
    }

    override fun hashCode() = role.hashCode()

    override fun toString() = role
}