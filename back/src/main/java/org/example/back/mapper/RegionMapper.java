package org.example.back.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Select;
import org.example.back.entity.Region;

import java.util.List;

public interface RegionMapper extends BaseMapper<Region> {
    @Select("SELECT * FROM t_region WHERE level = 1")
    List<Region> selectProvinces();

    @Select("SELECT * FROM t_region WHERE parent_id = #{provinceId}")
    List<Region> selectCitiesByProvince(Long provinceId);
}