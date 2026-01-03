package com.products.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "product_type", discriminatorType = DiscriminatorType.STRING)
@JsonInclude(JsonInclude.Include.NON_NULL) // Isso exclui valores nulos do JSON
public abstract class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 70)
    @NotBlank(message = "O título do livro é obrigatório")
    private String title;

    @Column(name = "volume")
    @Positive(message = "O volume deve ser maior que zero")
    private Integer volume;

    @Column(nullable = false, length = 50)
    @NotBlank(message = "O autor do livro é obrigatório")
    private String author;

    @Column(nullable = false, length = 4)
    @NotNull(message = "O ano de publicação é obrigatório")
    @PastOrPresent(message = "O ano de publicação deve ser no passado ou presente")
    @Digits(integer = 4, fraction = 0, message = "O ano de publicação deve conter no mínimo 4 dígitos")
    @Min(value = 1000, message = "O ano de publicação deve ser maior ou igual a 1000")
    private Integer publication_year;

    @Column(nullable = false, length = 50)
    @NotBlank(message = "O gênero do livro é obrigatório")
    private String genre;

    @Column(nullable = false, length = 50)
    @NotBlank(message = "O idioma do livro é obrigatório")
    private String language;

    @NotNull
    @DecimalMin(value = "0.01", message = "O preço deve ser maior que 0")
    private BigDecimal price;

    @Column(nullable = false, unique = true, length = 17)
    @NotBlank(message = "O ISBN do livro é obrigatório")
    // Exemplo de validação do formato do ISBN (10 ou 13 dígitos)
    @Pattern(regexp = "\\d{9}[\\d|X]|\\d{13}", message = "O ISBN deve ser um número de 10 ou 13 dígitos")
    private String isbn;

    @JsonProperty("product_type")
    public abstract String getProductType();
}
