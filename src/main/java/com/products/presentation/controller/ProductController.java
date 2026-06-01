package com.products.presentation.controller;

import com.products.application.service.ProductService;
import com.products.domain.model.Product;
import com.products.presentation.dto.ProductDTO;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@RestController
@CrossOrigin
@RequestMapping({"/api/v1/products", "/api/products"})
public class ProductController {

    // Injeção de dependencia para fornecer uma instancia de service e podermos
    // acessar os métodos de manipulação de dados
    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    // ==================== CRUD BÁSICO ====================

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

    // ==================== ENDPOINTS DE BUSCA ====================

    @GetMapping("/search/title")
    public List<Product> searchByTitle(@RequestParam String keyword) {
        return productService.findByTitleContaining(keyword);
    }

    @GetMapping("/search/author")
    public List<Product> searchByAuthor(@RequestParam String keyword) {
        return productService.findByAuthorContaining(keyword);
    }

    @GetMapping("/search/genre/{genre}")
    public List<Product> findByGenre(@PathVariable String genre) {
        return productService.findByGenre(genre);
    }

    @GetMapping("/search/language/{language}")
    public List<Product> findByLanguage(@PathVariable String language) {
        return productService.findByLanguage(language);
    }

    @GetMapping("/search/price")
    public List<Product> findByPriceRange(
            @RequestParam BigDecimal min,
            @RequestParam BigDecimal max) {
        return productService.findByPriceBetween(min, max);
    }

    @GetMapping("/top/newest")
    public List<Product> findTop10Newest() {
        return productService.findTop10Newest();
    }

    @GetMapping("/top/cheapest/{genre}")
    public List<Product> findTop10CheapestByGenre(@PathVariable String genre) {
        return productService.findTop10CheapestByGenre(genre);
    }

    @GetMapping("/count/genre/{genre}")
    public long countByGenre(@PathVariable String genre) {
        return productService.countByGenre(genre);
    }

}

