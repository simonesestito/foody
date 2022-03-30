package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.LoginSessionDao
import com.simonesestito.foody.springbackend.dao.UserDao
import com.simonesestito.foody.springbackend.entity.NewUserDto
import com.simonesestito.foody.springbackend.entity.User
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.web.bind.annotation.CookieValue
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/auth")
class AuthController(
    private val userDao: UserDao,
    private val sessionDao: LoginSessionDao,
    private val passwordEncoder: PasswordEncoder,
) {
    @GetMapping("/mail")
    fun emailExists(@RequestParam("email") email: String) =
        userDao.getUserWithEmailAddress(email) != null

    @GetMapping("/sessions")
    fun getSessions(@AuthenticationPrincipal user: User) = sessionDao.getByUserId(user.id!!)

    @GetMapping("/me")
    fun getMe(@AuthenticationPrincipal user: User?) = user

    @PostMapping("/signup")
    fun signUp(@RequestBody newUser: NewUserDto) {
        val user = User(
            id = null,
            name = newUser.name,
            surname = newUser.surname,
            emailAddresses = setOf(newUser.emailAddress),
            phoneNumbers = setOf(newUser.phoneNumber),
            allowedRoles = setOf("customer"),
            hashedPassword = passwordEncoder.encode(newUser.password)
        )

        userDao.save(user)
    }

    @PostMapping("/logout")
    fun logout(@CookieValue("foody-auth-token") currentToken: String, @RequestParam("token", required = false) requestedToken: String?) {
        sessionDao.deleteByToken(requestedToken ?: currentToken)
    }
}