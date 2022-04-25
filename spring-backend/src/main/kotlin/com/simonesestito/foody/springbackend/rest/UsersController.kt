package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.UserDao
import com.simonesestito.foody.springbackend.entity.User
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/users")
class UsersController(private val userDao: UserDao, private val passwordEncoder: PasswordEncoder) {
    @GetMapping("/")
    fun listUsers() = userDao.getAll()

    @PostMapping("/")
    fun updateUser(@RequestBody user: User) = userDao.updateUser(
        user.id!!,
        user.name,
        user.surname,
        user.password?.let { passwordEncoder.encode(it) },
        user.rider,
        user.admin,
        user.emailAddresses.joinToString("\n"),
        user.phoneNumbers.joinToString("\n"),
    )

    @DeleteMapping("/{id}")
    fun deleteUser(@PathVariable("id") userId: Int) = userDao.deleteUser(userId)
}