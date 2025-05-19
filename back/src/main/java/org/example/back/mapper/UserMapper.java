package org.example.back.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;

import org.apache.ibatis.annotations.Mapper;
import org.example.back.entity.User;

@Mapper
public interface UserMapper extends BaseMapper<User> {
}