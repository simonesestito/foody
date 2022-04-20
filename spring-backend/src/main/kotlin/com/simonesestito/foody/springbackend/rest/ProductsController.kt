package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.ProductsDao
import com.simonesestito.foody.springbackend.dao.ProductsService
import com.simonesestito.foody.springbackend.entity.Product
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/products")
class ProductsController(
    private val productsDao: ProductsDao,
    private val productsService: ProductsService,
) {
    @PostMapping("/")
    fun addProduct(@RequestBody product: Product) {
        if (product.id < 0)
            productsService.insertProduct(product)
        else
            productsService.updateProduct(product)
    }

    @DeleteMapping("/{id}")
    fun deleteProduct(@PathVariable("id") id: Int) = productsDao.deleteById(id)

    @GetMapping("/{id}")
    fun getProduct(@PathVariable("id") id: Int) = productsDao.getById(id)
}