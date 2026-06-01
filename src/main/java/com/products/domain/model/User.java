package com.products.domain.model;

import jakarta.persistence.*;
import lombok.Data;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Data
@Entity
@Table(name = "users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    @NotBlank(message = "O nome do usuário é obrigatório")
    private String name;

    @Column(nullable = false, unique = true, length = 100)
    @NotBlank(message = "O email do usuário é obrigatório")
    @Email(message = "O email do usuário deve ser válido")
    private String email;

    @Column(nullable = false, length = 100)
    @NotBlank(message = "A senha do usuário é obrigatória")
    @Size(min = 6, message = "A senha do usuário deve ter pelo menos 6 caracteres")
    private String password;
}
