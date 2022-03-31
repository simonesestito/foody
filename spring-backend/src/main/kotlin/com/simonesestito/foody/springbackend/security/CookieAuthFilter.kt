package com.simonesestito.foody.springbackend.security

import com.simonesestito.foody.springbackend.dao.LoginSessionDao
import org.springframework.core.annotation.Order
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.web.authentication.preauth.PreAuthenticatedAuthenticationToken
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter
import javax.servlet.FilterChain
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

@Component
class CookieAuthFilter(
    private val sessionDao: LoginSessionDao,
) : OncePerRequestFilter() {
    companion object {
        const val AUTH_COOKIE_NAME = "foody-auth-token"
    }

    override fun doFilterInternal(
        request: HttpServletRequest, response: HttpServletResponse, filterChain: FilterChain
    ) {
        val token = request.cookies?.asList()?.firstOrNull { cookie ->
            cookie.name == AUTH_COOKIE_NAME
        }?.value

        println("TOKEN COOKIE >>>>>>>>>>>> $token")

        if (token != null) {
            val session = sessionDao.getByToken(token)
            if (session != null) {
                sessionDao.refreshSession(token)
                SecurityContextHolder.getContext().authentication = PreAuthenticatedAuthenticationToken(
                    session.user, token, session.user.getAuthorities(),
                )
            }
        }

        filterChain.doFilter(request, response)
    }
}