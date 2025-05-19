package org.example.back.service;

import lombok.RequiredArgsConstructor;
import org.example.back.entity.Region;
import org.example.back.mapper.RegionMapper;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RegionService {
    private final RegionMapper regionMapper;

    public List<Region> getProvinces() {
        return regionMapper.selectProvinces();
    }

    public List<Region> getCities(Long provinceId) {
        return regionMapper.selectCitiesByProvince(provinceId);
    }
    public Region getProvince(Long regionId) {
        return regionMapper.selectById(regionId);
    }
    public Region getCity(Long regionId) {
        return regionMapper.selectById(regionId);
    }
}