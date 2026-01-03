package com.products.controller;

import com.products.dto.SaleDTO;
import com.products.model.Sale;
import com.products.service.SaleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/sales")
public class SaleController {

    @Autowired
    private SaleService saleService;

    @PostMapping
    public ResponseEntity<Sale> createSale(@Valid @RequestBody SaleDTO saleDTO) {
        Sale createdSale = saleService.createSale(saleDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdSale);
    }

    // Implementar outros endpoints relacionados às vendas

}
