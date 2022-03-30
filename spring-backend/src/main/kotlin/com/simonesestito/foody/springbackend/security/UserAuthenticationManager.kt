package com.simonesestito.foody.springbackend.security

import com.simonesestito.foody.springbackend.dao.UserDao
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.BadCredentialsException
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.Authentication
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Component

@Component
class UserAuthenticationManager(
    private val userDao: UserDao,
) : AuthenticationManager {
    private val passwordEncoder = BCryptPasswordEncoder()

    override fun authenticate(authentication: Authentication?): Authentication {
        if (authentication == null) throw BadCredentialsException("Null authentication provided")

        if (authentication.isAuthenticated) return authentication

        val email = authentication.principal?.toString()
        val password = authentication.credentials?.toString()
        if (email == null || password == null) throw BadCredentialsException("Email or password is null")

        val user =
            userDao.getUserWithEmailAddress(email) ?: throw BadCredentialsException("User not found with email $email")

        if (!passwordEncoder.matches(password, user.hashedPassword)) throw BadCredentialsException("Wrong password")

        return UsernamePasswordAuthenticationToken(
            user,
            null,
            user.getAuthorities(),
        )
    }
}