package org.example.back.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

import org.example.back.entity.Contact;
import org.example.back.entity.Region;
import org.example.back.entity.User;
import org.example.back.service.RegionService;
import org.example.back.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import lombok.RequiredArgsConstructor;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/contacts")
@RequiredArgsConstructor
public class UserController {
    private final RegionService regionService;

    private final UserService userService;

    /**
     * 分页搜索用户接口
     * @param page 当前页码（从1开始）
     * @param size 每页数量
     * @param search 搜索关键词（可选）
     * @return 分页数据
     */
    @GetMapping
    public Page<User> getUserList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "5") int size,
            @RequestParam(required = false) String search
    ) {
        System.out.println("每页数量"+size);
        return userService.listUsers(page, size, search);
    }
    @PostMapping
    public ResponseEntity<Void> createContact(@RequestBody Contact contact) {
        User user = new User();

        Region province = regionService.getProvince(contact.getProvinceId());
        Region city=regionService.getCity(contact.getCityId());
        user.setName(contact.getName());
        user.setProvince(province.getName());
        user.setCity(city.getName());
        user.setAddress(contact.getAddress());
        user.setZip(contact.getZip());
        user.setDate(LocalDateTime.now().toString());

        userService.addUser(user);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }
    @GetMapping("/{id}")
    public ResponseEntity<User> getContactById(@PathVariable Long id) {
        return ResponseEntity.ok(userService.getById(id));
    }
    @PutMapping("/{id}")
    public ResponseEntity<Void> updateContact(
            @PathVariable Long id,
             @RequestBody Contact contact
    ) {
        User user = userService.getById(id);
        Region province = regionService.getProvince(contact.getProvinceId());
        Region city=regionService.getCity(contact.getCityId());
        user.setName(contact.getName());
        user.setProvince(province.getName());
        user.setCity(city.getName());
        user.setAddress(contact.getAddress());
        user.setZip(contact.getZip());
        userService.updateUser(user);
        return ResponseEntity.ok().build();
    }
    @DeleteMapping
    public ResponseEntity<Void> deleteContact(Long id) {

        userService.removeById(id);
        return ResponseEntity.ok().build();
    }
}