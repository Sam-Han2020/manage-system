package org.example.back.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;


import org.example.back.entity.User;
import org.example.back.mapper.UserMapper;
import org.example.back.service.UserService;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    private final UserMapper userMapper;

    public UserServiceImpl(UserMapper userMapper) {
        this.userMapper = userMapper;
    }

    @Override
    public Page<User> listUsers(int pageNum, int pageSize, String search) {
        // 构建分页对象（MyBatis-Plus从1开始计数）
        Page<User> page = new Page<>(pageNum, pageSize);

        // 构建查询条件
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        if (StringUtils.hasText(search)) {
            wrapper.like(User::getName, search)
                    .or().like(User::getCity, search)
                    .or().like(User::getAddress, search); // 支持姓名、城市、地址搜索
        }

        // 执行分页查询
        return baseMapper.selectPage(page, wrapper);
    }

    @Override
    public int addUser(User user) {
        return userMapper.insert(user);
    }

    @Override
    public void updateUser(User user) {
        userMapper.updateById(user);
    }
}