package com.products.application.service;

import com.products.domain.model.Book;
import com.products.domain.model.Manga;
import com.products.domain.model.Product;
import com.products.infrastructure.repository.ProductRepository;
import com.products.presentation.dto.ProductDTO;
import com.products.shared.exception.InvalidProductDataException;
import com.products.shared.exception.ProductNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Locale;

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepository productRepository;

    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    public Product getProductById(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new ProductNotFoundException("Livro/Mangá não encontrado com o ID: " + id));
    }

    public Product createProduct(ProductDTO productDTO) {
        // Valida dados obrigatorios
        if (productDTO.getTitle().trim().isEmpty() || productDTO.getAuthor().trim().isEmpty()) {
            throw new InvalidProductDataException("Título e autor do livro/manga são obrigatórios.");
        }

        // Cria o tipo correto baseado no productType
        Product product = switch (productDTO.getProductType().toLowerCase(Locale.ROOT)) {
            case "book", "livro" -> new Book();
            case "manga" -> new Manga();
            default -> throw new InvalidProductDataException(
                "Tipo de produto inválido: " + productDTO.getProductType() + ". Use 'book' ou 'manga'.");
        };

        BeanUtils.copyProperties(productDTO, product);
        return productRepository.save(product);
    }

    public Product updateProduct(Long id, ProductDTO productDTO) {
        // Verificar se o livro/mangá existe antes de atualizar
        Product product = getProductById(id);

        if (productDTO.getTitle().trim().isEmpty() || productDTO.getAuthor().trim().isEmpty()) {
            throw new InvalidProductDataException("Título e autor do livro/mangá são obrigatórios.");
        }

        BeanUtils.copyProperties(productDTO, product);
        return productRepository.save(product);
    }

    public void deleteProduct(Long id) {
        // Verificar se o livro/mangá existe antes de excluir
        getProductById(id);
        productRepository.deleteById(id);
    }

    public void deleteAllProducts() {
        productRepository.deleteAll();
    }

    // ==================== SEARCH METHODS ====================

    public List<Product> findByTitleContaining(String keyword) {
        return productRepository.findByTitleContainingIgnoreCase(keyword);
    }

    public List<Product> findByAuthorContaining(String keyword) {
        return productRepository.findByAuthorContainingIgnoreCase(keyword);
    }

    public List<Product> findByGenre(String genre) {
        return productRepository.findByGenreIgnoreCase(genre);
    }

    public List<Product> findByLanguage(String language) {
        return productRepository.findByLanguageIgnoreCase(language);
    }

    public List<Product> findByPriceBetween(BigDecimal minPrice, BigDecimal maxPrice) {
        return productRepository.findByPriceBetween(minPrice, maxPrice);
    }

    public List<Product> findTop10Newest() {
        return productRepository.findTop10ByOrderByPublicationYearDesc();
    }

    public List<Product> findTop10CheapestByGenre(String genre) {
        return productRepository.findTop10ByGenreIgnoreCaseOrderByPriceAsc(genre);
    }

    public long countByGenre(String genre) {
        return productRepository.countByGenreIgnoreCase(genre);
    }
}

