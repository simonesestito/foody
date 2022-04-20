package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.EmployeeDao
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.sql.SQLException
import java.sql.SQLIntegrityConstraintViolationException

@RestController
@RequestMapping("/api/restaurant/{id}/employee")
class EmployeeController(private val employeeDao: EmployeeDao) {
    @GetMapping("/")
    fun getRestaurantEmployees(@PathVariable("id") restaurantId: Int) =
        employeeDao.getEmployees(restaurantId)

    @PostMapping("/")
    fun addRestaurantEmployee(
        @PathVariable("id") restaurantId: Int,
        @RequestBody employeeEmail: String,
    ) {
        try {
            employeeDao.hireEmployeeByEmail(restaurantId, employeeEmail.replace("\"", ""))
        } catch (e: SQLException) {
            println("ERR: ${e.errorCode} - ${e.sqlState}")
            if (e.errorCode != 45000)
                throw e
            else
                throw SQLException("Dipendente non trovato", "45000", 45000)
        }
    }

    @DeleteMapping("/{employee}")
    fun deleteRestaurantEmployee(
        @PathVariable("id") restaurantId: Int,
        @PathVariable("employee") employeeId: Int,
    ) = employeeDao.fireEmployee(restaurantId, employeeId)
}