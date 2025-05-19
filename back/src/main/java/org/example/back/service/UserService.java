package org.example.back.service;

import com.baomidou.mybatisplus.extension.service.IService;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.example.back.entity.Contact;
import org.example.back.entity.User;
import org.example.back.entity.UserT;

public interface UserService extends IService<User> {
    /**
     * 分页搜索用户
     * @param pageNum 当前页码（从1开始）
     * @param pageSize 每页数量
     * @param search 搜索关键词
     * @return 分页数据
     */
    Page<User> listUsers(int pageNum, int pageSize, String search);
    int addUser(User user);


    void updateUser(User user);
}