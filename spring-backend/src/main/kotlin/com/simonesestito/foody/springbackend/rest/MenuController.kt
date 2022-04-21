package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.MenuDao
import com.simonesestito.foody.springbackend.entity.Menu
import com.simonesestito.foody.springbackend.entity.MenuCategory
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/menu")
class MenuController(private val menuDao: MenuDao) {
    @PostMapping("/")
    fun addMenu(@RequestBody menu: Menu) {
        if (menu.id <= 0) menuDao.addMenu(menu.title, menu.restaurant, menu.published)
        else menuDao.updateMenu(menu.id, menu.title, menu.published)
    }

    @DeleteMapping("/{id}")
    fun deleteMenu(@PathVariable("id") menuId: Int) = menuDao.deleteMenu(menuId)

    @DeleteMapping("/category/{id}")
    fun deleteCategory(@PathVariable("id") categoryId: Int) = menuDao.deleteCategory(categoryId)

    @PostMapping("/category")
    fun addCategory(@RequestBody category: MenuCategory) {
        if (category.id <= 0) menuDao.addCategory(category.title, category.menu)
        else menuDao.updateCategory(category.id, category.title)
    }

    @PostMapping("/category/{category}/product/{product}")
    fun addProductToCategory(
        @PathVariable("category") categoryId: Int,
        @PathVariable("product") productId: Int,
    ) = menuDao.addProductToCategory(productId, categoryId)

    @DeleteMapping("/category/{category}/product/{product}")
    fun removeProductFromCategory(
        @PathVariable("category") categoryId: Int,
        @PathVariable("product") productId: Int,
    ) = menuDao.removeProductFromCategory(productId, categoryId)
}