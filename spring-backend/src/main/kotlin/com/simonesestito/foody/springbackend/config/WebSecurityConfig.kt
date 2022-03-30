package com.simonesestito.foody.springbackend.config

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter
import org.springframework.web.cors.CorsConfiguration
import org.springframework.web.cors.CorsConfigurationSource
import org.springframework.web.cors.UrlBasedCorsConfigurationSource


@Configuration
@EnableWebSecurity
class WebSecurityConfig : WebSecurityConfigurerAdapter() {
    @Throws(Exception::class)
    override fun configure(http: HttpSecurity) {
        http.cors {
            // It uses corsConfigurationSource bean
        }.authorizeRequests {
            // FIXME: Authentication and authorization
            it.anyRequest().permitAll()
        }.formLogin {
            it.disable()
        }.logout {
            it.permitAll()
        }
    }

    @Bean
    @ConditionalOnProperty(name= ["cors.allow-all"], havingValue = "true")
    fun corsConfigurationSource(): CorsConfigurationSource? {
        val configuration = CorsConfiguration().apply {
            allowedOriginPatterns = listOf("http://localhost:[*]")
            allowedMethods = listOf("GET", "POST", "DELETE", "PUT")
            allowCredentials = true
        }
        return UrlBasedCorsConfigurationSource().apply {
            registerCorsConfiguration("/**", configuration)
        }
    }
}