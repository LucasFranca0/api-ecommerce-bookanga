package com.products.application.service;

import com.products.domain.model.Sale;
import com.products.presentation.dto.SaleDTO;

public interface SaleService {
    Sale createSale(SaleDTO saleDTO);
}

