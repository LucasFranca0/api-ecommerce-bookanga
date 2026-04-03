package com.products.repository;

import com.products.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long> {

    List<Product> findByTitleContainingIgnoreCase(String keyword);

    List<Product> findByAuthorContainingIgnoreCase(String keyword);

    List<Product> findByGenreIgnoreCase(String genre);

    List<Product> findByPriceBetween(BigDecimal minPrice, BigDecimal maxPrice);

    boolean existsByIsbn(String isbn);

    List<Product> findByAuthorContainingIgnoreCaseAndGenreIgnoreCase(
            String author,
            String genre
    );

    List<Product> findTop10ByGenreIgnoreCaseOrderByPriceAsc(String genre);

    List<Product> findTop10ByOrderByPublicationYearDesc();

    List<Product> findByLanguageIgnoreCase(String language);

    long countByGenreIgnoreCase(String genre);

}
