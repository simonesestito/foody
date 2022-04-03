package com.simonesestito.foody.springbackend.rest.errors

import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ControllerAdvice
import org.springframework.web.bind.annotation.ExceptionHandler
import java.sql.SQLException

@ControllerAdvice
class SqlExceptionHandler {
    private val logger = LoggerFactory.getLogger(SqlExceptionHandler::class.java)

    @ExceptionHandler(SQLException::class)
    fun handleSqlException(error: SQLException): ResponseEntity<Any> {
        logger.error("SQL Exception with code ${error.errorCode}, and state ${error.sqlState}", error)
        val status = when(error.errorCode) {
            1064 -> HttpStatus.INTERNAL_SERVER_ERROR
            4025 -> HttpStatus.BAD_REQUEST
            else -> HttpStatus.CONFLICT
        }
        return ResponseEntity.status(status).build()
    }
}