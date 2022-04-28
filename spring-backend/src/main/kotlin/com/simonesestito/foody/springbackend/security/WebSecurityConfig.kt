package com.simonesestito.foody.springbackend.security

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter
import org.springframework.security.config.http.SessionCreationPolicy
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.web.access.channel.ChannelProcessingFilter
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter


@Configuration
@EnableWebSecurity
class WebSecurityConfig(
    private val cookieAuthFilter: CookieAuthFilter,
    private val emailAuthFilter: EmailAuthFilter,
    private val corsFilter: CorsFilter,
) : WebSecurityConfigurerAdapter() {
    override fun configure(http: HttpSecurity) {
        http.addFilterBefore(cookieAuthFilter, UsernamePasswordAuthenticationFilter::class.java)
            .addFilterBefore(emailAuthFilter, UsernamePasswordAuthenticationFilter::class.java)
            .addFilterBefore(corsFilter, ChannelProcessingFilter::class.java)
            .sessionManagement {
                it.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            }.csrf {
                it.disable()
            }.authorizeRequests {
                it.antMatchers(
                    "/api/auth/login", "/api/auth/signup", "/api/auth/mail", "/api/queries/**"
                ).permitAll()
                it.antMatchers("/api/users", "/api/admin/restaurants").hasRole("admin")
                it.antMatchers("/api/service").hasRole("rider")
                it.antMatchers("/api/orders").hasAnyRole("manager", "rider")
                it.antMatchers("/api/**").authenticated()
                it.anyRequest().permitAll()
            }.formLogin {
                it.disable()
            }.logout {
                it.permitAll()
            }
    }

    @Bean
    fun passwordEncoder() = BCryptPasswordEncoder()
}