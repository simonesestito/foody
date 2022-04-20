package com.simonesestito.foody.springbackend.rest.errors

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler
import java.sql.SQLException

@ControllerAdvice
class SqlExceptionHandler {
    @ExceptionHandler(SQLException::class)
    fun handleSqlException(error: SQLException): ResponseEntity<String?> {
        val status = when (error.errorCode) {
            1064 -> HttpStatus.INTERNAL_SERVER_ERROR
            4025 -> HttpStatus.BAD_REQUEST
            45000 -> HttpStatus.BAD_REQUEST
            else -> {
                if (error.message?.contains("cannot be null") == true) HttpStatus.NOT_FOUND
                else HttpStatus.CONFLICT
            }
        }
        return ResponseEntity.status(status).body(error.message)
    }
}