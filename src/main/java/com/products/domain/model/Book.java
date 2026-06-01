package com.products.domain.model;

import jakarta.persistence.*;
import lombok.Data;


@Data
@Entity
@DiscriminatorValue("book")
public class Book extends Product{
    @Override
    public String getProductType() {
        return "book";
    }
}

