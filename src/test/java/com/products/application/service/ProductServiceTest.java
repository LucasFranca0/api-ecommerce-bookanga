package com.products.application.service;
import com.products.domain.model.Book;
import com.products.domain.model.Manga;
import com.products.domain.model.Product;
import com.products.infrastructure.repository.ProductRepository;
import com.products.presentation.dto.ProductDTO;
import com.products.shared.exception.InvalidProductDataException;
import com.products.shared.exception.ProductNotFoundException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
@ExtendWith(MockitoExtension.class)
@DisplayName("ProductService Tests")
class ProductServiceTest {
    @Mock
    private ProductRepository productRepository;
    @InjectMocks
    private ProductService productService;
    private ProductDTO validBookDTO;
    private ProductDTO validMangaDTO;
    private Book sampleBook;
    private Manga sampleManga;
    @BeforeEach
    void setUp() {
        validBookDTO = new ProductDTO();
        validBookDTO.setTitle("Clean Code");
        validBookDTO.setAuthor("Robert C. Martin");
        validBookDTO.setPublicationYear(2008);
        validBookDTO.setGenre("Programming");
        validBookDTO.setLanguage("English");
        validBookDTO.setPrice(new BigDecimal("59.90"));
        validBookDTO.setIsbn("9780132350884");
        validBookDTO.setProductType("book");
        validMangaDTO = new ProductDTO();
        validMangaDTO.setTitle("One Piece");
        validMangaDTO.setAuthor("Eiichiro Oda");
        validMangaDTO.setPublicationYear(1997);
        validMangaDTO.setGenre("Shounen");
        validMangaDTO.setLanguage("Japanese");
        validMangaDTO.setPrice(new BigDecimal("29.90"));
        validMangaDTO.setIsbn("9784088725093");
        validMangaDTO.setProductType("manga");
        validMangaDTO.setVolume(1);
        sampleBook = new Book();
        sampleBook.setId(1L);
        sampleBook.setTitle("Clean Code");
        sampleBook.setAuthor("Robert C. Martin");
        sampleManga = new Manga();
        sampleManga.setId(2L);
        sampleManga.setTitle("One Piece");
        sampleManga.setAuthor("Eiichiro Oda");
        sampleManga.setVolume(1);
    }
    @Nested
    @DisplayName("Testes de busca por ID")
    class GetByIdTests {
        @Test
        @DisplayName("Deve retornar produto quando ID existe")
        void shouldReturnProductWhenIdExists() {
            when(productRepository.findById(1L)).thenReturn(Optional.of(sampleBook));
            Product result = productService.getProductById(1L);
            assertNotNull(result);
            assertEquals("Clean Code", result.getTitle());
            verify(productRepository, times(1)).findById(1L);
        }
        @Test
        @DisplayName("Deve lancar excecao quando ID nao existe")
        void shouldThrowExceptionWhenIdNotFound() {
            when(productRepository.findById(999L)).thenReturn(Optional.empty());
            ProductNotFoundException exception = assertThrows(
                    ProductNotFoundException.class,
                    () -> productService.getProductById(999L)
            );
            assertTrue(exception.getMessage().contains("999"));
            verify(productRepository, times(1)).findById(999L);
        }
    }
    @Nested
    @DisplayName("Testes de listagem")
    class GetAllTests {
        @Test
        @DisplayName("Deve retornar lista vazia quando nao ha produtos")
        void shouldReturnEmptyListWhenNoProducts() {
            when(productRepository.findAll()).thenReturn(List.of());
            List<Product> result = productService.getAllProducts();
            assertTrue(result.isEmpty());
        }
        @Test
        @DisplayName("Deve retornar todos os produtos")
        void shouldReturnAllProducts() {
            List<Product> products = List.of(sampleBook, sampleManga);
            when(productRepository.findAll()).thenReturn(products);
            List<Product> result = productService.getAllProducts();
            assertEquals(2, result.size());
        }
    }
    @Nested
    @DisplayName("Testes de criacao de produto")
    class CreateProductTests {
        @Test
        @DisplayName("Deve criar um Book quando productType e book")
        void shouldCreateBookWhenProductTypeIsBook() {
            when(productRepository.save(any(Book.class))).thenReturn(sampleBook);
            Product result = productService.createProduct(validBookDTO);
            assertNotNull(result);
            assertInstanceOf(Book.class, result);
            verify(productRepository, times(1)).save(any(Book.class));
        }
        @Test
        @DisplayName("Deve criar um Manga quando productType e manga")
        void shouldCreateMangaWhenProductTypeIsManga() {
            when(productRepository.save(any(Manga.class))).thenReturn(sampleManga);
            Product result = productService.createProduct(validMangaDTO);
            assertNotNull(result);
            assertInstanceOf(Manga.class, result);
            verify(productRepository, times(1)).save(any(Manga.class));
        }
        @Test
        @DisplayName("Deve lancar excecao quando titulo esta vazio")
        void shouldThrowExceptionWhenTitleIsEmpty() {
            validBookDTO.setTitle("   ");
            InvalidProductDataException exception = assertThrows(
                    InvalidProductDataException.class,
                    () -> productService.createProduct(validBookDTO)
            );
            assertTrue(exception.getMessage().contains("obrigat"));
            verify(productRepository, never()).save(any());
        }
        @Test
        @DisplayName("Deve lancar excecao quando productType e invalido")
        void shouldThrowExceptionWhenProductTypeIsInvalid() {
            validBookDTO.setProductType("invalid_type");
            InvalidProductDataException exception = assertThrows(
                    InvalidProductDataException.class,
                    () -> productService.createProduct(validBookDTO)
            );
            assertTrue(exception.getMessage().contains("inv"));
            verify(productRepository, never()).save(any());
        }
    }
    @Nested
    @DisplayName("Testes de delecao de produto")
    class DeleteProductTests {
        @Test
        @DisplayName("Deve deletar produto existente")
        void shouldDeleteExistingProduct() {
            when(productRepository.findById(1L)).thenReturn(Optional.of(sampleBook));
            doNothing().when(productRepository).deleteById(1L);
            productService.deleteProduct(1L);
            verify(productRepository, times(1)).deleteById(1L);
        }
        @Test
        @DisplayName("Deve lancar excecao ao deletar produto inexistente")
        void shouldThrowExceptionWhenDeletingNonExistentProduct() {
            when(productRepository.findById(999L)).thenReturn(Optional.empty());
            assertThrows(
                    ProductNotFoundException.class,
                    () -> productService.deleteProduct(999L)
            );
            verify(productRepository, never()).deleteById(any());
        }
    }
    @Nested
    @DisplayName("Testes de Query Methods")
    class QueryMethodsTests {
        @Test
        @DisplayName("Deve buscar produtos por genero")
        void shouldFindByGenre() {
            when(productRepository.findByGenreIgnoreCase("Programming"))
                    .thenReturn(List.of(sampleBook));
            List<Product> result = productService.findByGenre("Programming");
            assertEquals(1, result.size());
            verify(productRepository, times(1)).findByGenreIgnoreCase("Programming");
        }
        @Test
        @DisplayName("Deve contar produtos por genero")
        void shouldCountByGenre() {
            when(productRepository.countByGenreIgnoreCase("Shounen")).thenReturn(5L);
            long count = productService.countByGenre("Shounen");
            assertEquals(5L, count);
        }
    }
}

