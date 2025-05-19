package org.example.back.service.impl;


import jakarta.annotation.Resource;
import org.example.back.entity.UserT;
import org.example.back.mapper.UserTMapper;
import org.example.back.service.UserTService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserTServiceImpl implements UserTService {

    @Autowired
    private UserTMapper userTMapper;

    @Override
    public int createUser(UserT userT) {
        return userTMapper.insert(userT);
    }

    @Override
    public int updateUser(UserT userT) {
        return userTMapper.update(userT);
    }

    @Override
    public int deleteUser(Integer id) {
        return userTMapper.deleteById(id);
    }

    @Override
    public UserT getUserById(Integer id) {
        return userTMapper.selectById(id);
    }

    @Override
    public List<UserT> getAllUsers() {
        // 扩展：如需查询所有，需在 UserTMapper 中添加 selectAll 方法及对应 XML
        throw new UnsupportedOperationException("暂未实现");
    }
    @Override
    public boolean login(String username, String password) {
        // 1. 根据用户名查询用户
        UserT user = userTMapper.findByName(username);

        // 2. 验证用户是否存在且密码正确（实际项目需加密处理）
        return user != null && user.getPassword().equals(password);
    }

    @Override
    public UserT getUserProfile(String username) {
        return userTMapper.findByName(username);
    }
}
    