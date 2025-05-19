package org.example.back.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.example.back.entity.AuthorT;

@Mapper
public interface AuthorTMapper extends BaseMapper<AuthorT> {
    // 按名称查询（MyBatis-Plus内置方法已支持，无需额外定义）
    // 如需复杂查询可在此扩展
    @Select("SELECT * FROM authort WHERE name = #{name}")
    AuthorT selectByName(@Param("name") String name);
}