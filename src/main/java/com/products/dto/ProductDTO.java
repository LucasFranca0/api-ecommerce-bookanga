package com.products.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;

@Data
public class ProductDTO {


    @NotBlank(message = "O título é obrigatório.")
    @Size(max = 255, message = "O título deve ter no máximo 255 caracteres.")
    private String title;

    @NotBlank(message = "O autor é obrigatório.")
    @Size(max = 255, message = "O autor deve ter no máximo 255 caracteres.")
    private String author;

    @NotNull(message = "O ano de publicação e obrigatório")
    @Min(value = 1000, message = "O ano de publicacao deve ser maior ou igual a 1000.")
    private Integer publicationYear;

    @NotNull(message = "O preço e obrigatório.")
    @Positive(message = "O preco deve ser um valor positivo.")
    private BigDecimal price;

    @NotBlank(message = "O ISBN é obrigatório.")
    @Size(max = 20, message = "O ISBN deve ter no máximo 20 caracteres.")
    private String isbn;

    @NotBlank(message = "O gênero é obrigatório.")
    @Size(max = 50, message = "O gênero deve ter no máximo 50 caracteres.")
    private String genre;

    @NotBlank(message = "O idioma é obrigatório.")
    @Size(max = 50, message = "O idioma deve ter no máximo 50 caracteres.")
    private String language;

    @JsonProperty("product_type")
    @NotBlank(message = "O tipo de produto é obrigatório.")
    @Size(max = 50, message = "O tipo de produto deve ter no máximo 50 caracteres.")
    private String productType;

    private Integer volume;

}
