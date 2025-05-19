package org.example.back.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@RestController
@CrossOrigin // 允许跨域访问（根据前端需要配置）
public class ImageUploadController {

    // 配置存储目录（根据实际情况修改路径）
    private static final String UPLOAD_DIR = "/var/www/images/";
    // 或者使用相对路径（注意打包后的路径问题）：
    // private static final String UPLOAD_DIR = "uploads/";

    // 配置访问基础URL（根据实际域名修改）
    private static final String BASE_URL = "http://10.83.248.143:8082/images/";

    @PostMapping("/imageUpload")
    public ResponseEntity<?> uploadImage(@RequestParam("file") MultipartFile file) {
        try {
            // 1. 校验文件是否为空
            if (file.isEmpty()) {
                return ResponseEntity.badRequest().body("File is empty");
            }

            // 2. 校验文件类型（可根据需要扩展）
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return ResponseEntity.badRequest().body("Only image files are allowed");
            }

            // 3. 创建存储目录（如果不存在）
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 4. 生成唯一文件名（防止重名）
            String originalFilename = file.getOriginalFilename();
            String fileExtension = originalFilename != null ?
                    originalFilename.substring(originalFilename.lastIndexOf(".")) : "";
            String uniqueFileName = UUID.randomUUID() + fileExtension;

            // 5. 保存文件到服务器
            Path filePath = Paths.get(UPLOAD_DIR + uniqueFileName);
            Files.copy(file.getInputStream(), filePath);

            // 6. 构建访问URL
            String imageUrl = BASE_URL + uniqueFileName;

            return ResponseEntity.ok().body("{\"imageUrl\": \"" + imageUrl + "\"}");

        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("File upload failed");
        }
    }
}