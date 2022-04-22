package com.simonesestito.foody.springbackend.rest

import com.simonesestito.foody.springbackend.dao.ProductsDao
import com.simonesestito.foody.springbackend.entity.Product
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api/products")
class ProductsController(private val productsDao: ProductsDao) {
    @PostMapping("/")
    fun addProduct(@RequestBody product: Product) = productsDao.insertUpdateProduct(
        product.id,
        product.name,
        product.description,
        product.price,
        product.restaurant.id,
        product.allergens.joinToString("\n"),
    )

    @DeleteMapping("/{id}")
    fun deleteProduct(@PathVariable("id") id: Int) = productsDao.deleteById(id)

    @GetMapping("/{id}")
    fun getProduct(@PathVariable("id") id: Int) = productsDao.getById(id)
}