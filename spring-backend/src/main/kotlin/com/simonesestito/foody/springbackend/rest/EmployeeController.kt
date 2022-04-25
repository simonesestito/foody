package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.EmployeeDao
import org.springframework.web.bind.annotation.*
import java.sql.SQLException

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