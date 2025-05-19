package org.example.back.mapper;


import org.apache.ibatis.annotations.Mapper;
import org.example.back.entity.UserT;

@Mapper
public interface UserTMapper {
    int insert(UserT userT);
    int update(UserT userT);
    int deleteById(Integer id);
    UserT selectById(Integer id);
    UserT findByName(String name);
}
    