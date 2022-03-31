package com.simonesestito.foody.springbackend.security

import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter
import javax.servlet.FilterChain
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse


@Component
class CorsFilter : OncePerRequestFilter() {
    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        filterChain: FilterChain
    ) {
        val origin = request.getHeader("Origin")
        if (origin?.startsWith("http://localhost:") == true) {
            response.setHeader("Access-Control-Allow-Origin", origin)
        }
        response.setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        response.setHeader("Access-Control-Max-Age", "3600")
        response.setHeader("Access-Control-Allow-Headers", "authorization, content-type, cookie")
        response.setHeader("Access-Control-Allow-Credentials", "true")
        if ("OPTIONS" == request.method) {
            response.status = HttpServletResponse.SC_OK
        } else {
            filterChain.doFilter(request, response)
        }
    }
}