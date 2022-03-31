package com.simonesestito.foody.springbackend.security

import com.fasterxml.jackson.databind.ObjectMapper
import com.simonesestito.foody.springbackend.dao.LoginSessionDao
import com.simonesestito.foody.springbackend.entity.LoginSession
import com.simonesestito.foody.springbackend.entity.User
import org.slf4j.LoggerFactory
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.Authentication
import org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter
import org.springframework.security.web.util.matcher.AntPathRequestMatcher
import org.springframework.stereotype.Component
import java.security.SecureRandom
import java.util.*
import java.util.stream.Collectors
import javax.servlet.FilterChain
import javax.servlet.http.Cookie
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

@Component
class EmailAuthFilter(
    authManager: UserAuthenticationManager,
    private val sessionDao: LoginSessionDao,
) : AbstractAuthenticationProcessingFilter(LOGIN_REQUEST_MATCHER, authManager) {
    companion object {
        private val LOGIN_REQUEST_MATCHER = AntPathRequestMatcher("/api/auth/login", "POST")
        const val USERNAME_BODY_KEY = "username"
        const val PASSWORD_BODY_KEY = "password"
    }

    private val log = LoggerFactory.getLogger(EmailAuthFilter::class.java)

    override fun attemptAuthentication(
        request: HttpServletRequest, response: HttpServletResponse
    ): Authentication {
        val rawBody = request.reader.lines().collect(Collectors.joining())
        val bodyMap = ObjectMapper().readValue(rawBody, Map::class.java)
        val email = bodyMap[USERNAME_BODY_KEY]?.toString() ?: ""
        val password = bodyMap[PASSWORD_BODY_KEY]?.toString() ?: ""
        val token = UsernamePasswordAuthenticationToken(email, password)
        return try {
            authenticationManager.authenticate(token)
        } catch (e: Exception) {
            log.error("Authentication attempt failed", e)
            throw e
        }
    }

    override fun successfulAuthentication(
        request: HttpServletRequest, response: HttpServletResponse, chain: FilterChain?, authResult: Authentication?
    ) {
        val user = authResult?.principal as User
        val token = generateSafeToken()
        val session = LoginSession(
            token, request.getHeader("User-Agent") ?: "", request.ipAddress() ?: "", Date(), Date(), user,
        )
        sessionDao.save(session)

        // Send Session cookie
        if (request.getHeader("Host") == "localhost:5000") {
            response.addHeader("Set-Cookie", "${CookieAuthFilter.AUTH_COOKIE_NAME}=$token; Max-Age: 3600")
        } else {
            response.addCookie(Cookie(CookieAuthFilter.AUTH_COOKIE_NAME, token).apply {
                maxAge = 365 * 24 * 60 * 60
                isHttpOnly = true
                secure = true
            })
        }

        super.successfulAuthentication(request, response, chain, authResult)
    }

    private fun generateSafeToken(): String {
        val bytes = ByteArray(20)
        SecureRandom().nextBytes(bytes)
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes)
    }

    private fun HttpServletRequest.ipAddress() = getHeader("X-Forwarded-For") ?: remoteAddr
}