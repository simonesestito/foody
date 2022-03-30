package com.simonesestito.foody.springbackend.security

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter
import org.springframework.security.config.http.SessionCreationPolicy
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter
import org.springframework.web.cors.CorsConfiguration
import org.springframework.web.cors.CorsConfigurationSource
import org.springframework.web.cors.UrlBasedCorsConfigurationSource


@Configuration
@EnableWebSecurity
class WebSecurityConfig(
    private val cookieAuthFilter: CookieAuthFilter,
    private val authFilter: EmailAuthFilter,
) : WebSecurityConfigurerAdapter() {
    override fun configure(http: HttpSecurity) {
        http.addFilterAt(cookieAuthFilter, UsernamePasswordAuthenticationFilter::class.java)
            .addFilterAt(authFilter, UsernamePasswordAuthenticationFilter::class.java).sessionManagement {
                it.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            }.csrf { it.disable() }.cors {
                // It uses corsConfigurationSource bean
            }.authorizeRequests {
                it.antMatchers(
                    "/api/auth/login", "/api/auth/signup", "/api/auth/mail"
                ).permitAll()
            }.formLogin {
                it.disable()
            }.logout {
                it.permitAll()
            }
    }

    @Bean
    @ConditionalOnProperty(name = ["cors.allow-all"], havingValue = "true")
    fun corsConfigurationSource(): CorsConfigurationSource {
        val configuration = CorsConfiguration().apply {
            allowedOriginPatterns = listOf("http://localhost:[*]")
            allowedMethods = listOf("GET", "POST", "DELETE", "PUT")
            allowCredentials = true
        }
        return UrlBasedCorsConfigurationSource().apply {
            registerCorsConfiguration("/**", configuration)
        }
    }

    @Bean
    fun passwordEncoder() = BCryptPasswordEncoder()
}