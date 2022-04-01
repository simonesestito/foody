package com.simonesestito.foody.springbackend.rest.errors

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler
import java.sql.SQLException

@ControllerAdvice
class SqlExceptionHandler {
    @ExceptionHandler(SQLException::class)
    fun handleSqlException(error: SQLException): ResponseEntity<Any> {
        val status = when(error.errorCode) {
            4025 -> HttpStatus.BAD_REQUEST
            else -> HttpStatus.CONFLICT
        }
        return ResponseEntity.status(status).build()
    }
}