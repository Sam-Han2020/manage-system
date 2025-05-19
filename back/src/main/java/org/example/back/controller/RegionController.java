package org.example.back.controller;

import lombok.RequiredArgsConstructor;
import org.example.back.entity.Region;
import org.example.back.service.RegionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/regions")
@RequiredArgsConstructor
public class RegionController {
    private final RegionService regionService;

    @GetMapping("/provinces")
    public ResponseEntity<List<Region>> getProvinces() {
        return ResponseEntity.ok(regionService.getProvinces());
    }

    @GetMapping("/cities")
    public ResponseEntity<List<Region>> getCities(
            @RequestParam Long provinceId
    ) {
        return ResponseEntity.ok(regionService.getCities(provinceId));
    }
}