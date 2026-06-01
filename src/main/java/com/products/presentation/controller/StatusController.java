package com.products.presentation.controller;

import lombok.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class StatusController {

    @Autowired
    private DataSource dataSource;

    @GetMapping("/status")
    public ResponseEntity<Map<String, Object>> getStatus() {
        Map<String, Object> status = new HashMap<>();
        status.put("timestamp", LocalDateTime.now());
        status.put("application", checkApplicationStatus());
        status.put("database", checkDatabaseStatus());

        return ResponseEntity.ok(status);
    }

    private ServiceStatus checkApplicationStatus() {
        ServiceStatus appStatus = new ServiceStatus();
        appStatus.setName("Spring Boot API");
        appStatus.setStatus("UP");
        appStatus.setMessage("Application is running");
        return appStatus;
    }

    private ServiceStatus checkDatabaseStatus() {
        ServiceStatus dbStatus = new ServiceStatus();
        dbStatus.setName("PostgreSQL");

        try (Connection connection = dataSource.getConnection()) {
            if (connection.isValid(2)) {
                dbStatus.setStatus("UP");
                dbStatus.setMessage("Database connection is healthy");
            } else {
                dbStatus.setStatus("DOWN");
                dbStatus.setMessage("Database connection is not valid");
            }
        } catch (Exception e) {
            dbStatus.setStatus("DOWN");
            dbStatus.setMessage("Database connection failed: " + e.getMessage());
        }

        return dbStatus;
    }

    @Data
    public static class ServiceStatus {
        private String name;
        private String status;
        private String message;
    }
}

