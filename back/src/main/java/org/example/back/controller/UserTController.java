package org.example.back.controller;



import org.example.back.entity.UserT;
import org.example.back.entity.UpdateUserT;
import org.example.back.service.UserTService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/users")
public class UserTController {

    @Autowired
    private UserTService userTService;


    @PostMapping("/login")
    public Map<String, Object> login(@RequestBody UserT userT) {
        Map<String, Object> result = new HashMap<>();

        System.out.println(userT.getName());

        if (userTService.login(userT.getName(), userT.getPassword())) {
            UserT user = userTService.getUserProfile(userT.getName());
            result.put("code", 200);
            result.put("message", "登录成功");
            result.put("avatorUrl", user.getAvatar());
            // 可添加 token 生成逻辑（如 JWT）
        } else {
            result.put("code", 401);
            result.put("message", "用户名或密码错误");
        }

        return result;
    }


    @PostMapping("/register")
    public String createUser(@RequestBody UserT userT) {
        if(userTService.login(userT.getName(), userT.getPassword())) {
            return "用户已经存在";
        }

        int result = userTService.createUser(userT);
        return result > 0 ? "用户创建成功" : "用户创建失败";
    }

    @PostMapping("/changePassword")
    public Map<String, Object> updateUser(@RequestBody UpdateUserT updateUserT) {
        Map<String, Object> result = new HashMap<>();
        if(userTService.login(updateUserT.getUsername(), updateUserT.getOld_password())) {
            UserT userT = new UserT();
            userT.setName(updateUserT.getUsername());
            userT.setPassword(updateUserT.getNew_password());
            userTService.updateUser(userT);
            result.put("code", 200);
            result.put("message", "密码修改成功");
        }else{
            result.put("code", 401);
            result.put("message","用户不存在");
        }
        return result;
    }

    @GetMapping("/profile")
    public ResponseEntity<?> getUserProfile(
            @RequestParam String username
    ) {

            UserT userProfile = userTService.getUserProfile(username);
            return ResponseEntity.ok(userProfile);

    }

    @DeleteMapping("/{id}")
    public String deleteUser(@PathVariable Integer id) {
        int result = userTService.deleteUser(id);
        return result > 0 ? "用户删除成功" : "用户删除失败";
    }

    @GetMapping("/{id}")
    public UserT getUserById(@PathVariable Integer id) {
        return userTService.getUserById(id);
    }
}
    