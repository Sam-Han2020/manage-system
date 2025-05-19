package org.example.back.service;



import org.example.back.entity.UserT;

import java.util.List;

public interface UserTService {
    int createUser(UserT userT);
    int updateUser(UserT userT);
    int deleteUser(Integer id);
    UserT getUserById(Integer id);
    List<UserT> getAllUsers();
    boolean login(String username, String password);

    UserT getUserProfile(String username);
}
    