package com.products.controller;

import com.products.dto.ProductDTO;
import com.products.model.Product;
import com.products.service.ProductService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin
@RequestMapping("/api/v1/products")
public class ProductController {

    // Injeção de dependencia para fornecer uma instancia de service e podermos
    // acessar os métodos de manipulação de dados
    @Autowired
    private ProductService productService;

    // Requisições
    @GetMapping
    public List<Product> getAllProducts() {
        return productService.getAllProducts();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Long id) {
        Product product = productService.getProductById(id);
        return ResponseEntity.ok(product);
    }

    @PostMapping
    public ResponseEntity<Product> createProduct(@Valid @RequestBody ProductDTO productDTO) {
        Product createdProduct = productService.createProduct(productDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdProduct);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Product> updateProduct(@PathVariable Long id, @Valid @RequestBody ProductDTO productDto) {
        Product updatedProduct= productService.updateProduct(id, productDto);
        return ResponseEntity.status(HttpStatus.OK).body(updatedProduct);
    }


    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return ResponseEntity.noContent().build(); // Resposta 204 No Content em caso de sucesso
    }

    @DeleteMapping()
    public void deleteAllProducts(){
        productService.deleteAllProducts();
    }

}
