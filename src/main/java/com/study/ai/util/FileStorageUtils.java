package com.study.ai.util;

import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.Locale;
import java.util.UUID;

public final class FileStorageUtils {

    private FileStorageUtils() {
    }

    public static String store(MultipartFile file, String uploadRoot) {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("文件不能为空");
        }
        if (uploadRoot == null || uploadRoot.trim().isEmpty()) {
            throw new IllegalArgumentException("上传目录不可用");
        }
        File root = new File(uploadRoot);
        if (!root.exists() && !root.mkdirs()) {
            throw new IllegalStateException("无法创建上传目录");
        }
        String originalName = file.getOriginalFilename() == null ? "" : file.getOriginalFilename();
        String ext = "";
        int dotIndex = originalName.lastIndexOf('.');
        if (dotIndex >= 0) {
            ext = originalName.substring(dotIndex).toLowerCase(Locale.ROOT);
        }
        String storedName = UUID.randomUUID().toString().replace("-", "") + ext;
        try {
            file.transferTo(new File(root, storedName));
        } catch (IOException e) {
            throw new IllegalStateException("文件保存失败");
        }
        return storedName;
    }

    public static void deleteQuietly(String uploadRoot, String storedName) {
        if (uploadRoot == null || storedName == null || storedName.trim().isEmpty()) {
            return;
        }
        File file = new File(uploadRoot, storedName);
        if (file.exists()) {
            file.delete();
        }
    }

    public static String humanReadableSize(long bytes) {
        if (bytes < 1024) {
            return bytes + "B";
        }
        double kb = bytes / 1024.0;
        if (kb < 1024) {
            return String.format(Locale.US, "%.1fKB", kb);
        }
        return String.format(Locale.US, "%.1fMB", kb / 1024.0);
    }
}
