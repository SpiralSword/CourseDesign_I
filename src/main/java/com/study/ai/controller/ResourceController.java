package com.study.ai.controller;

import com.study.ai.mapper.CommentMapper;
import com.study.ai.pojo.entity.Resource;
import com.study.ai.pojo.entity.User;
import com.study.ai.service.ResourceService;
import com.study.ai.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/resource")
public class ResourceController {

    @Autowired private CommentMapper commentMapper;
    @Autowired private ResourceService resourceService;
    @Autowired private UserService userService;

    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int page, String keyword, Model model) {
        model.addAttribute("pageInfo", resourceService.listResources(page, keyword));
        model.addAttribute("keyword", keyword);
        return "resource_list";
    }

    @GetMapping("/detail")
    public String detail(Integer id, Model model) {
        Resource res = resourceService.getDetail(id);
        model.addAttribute("res", res);
        model.addAttribute("commentList", commentMapper.findByResourceId(id));
        return "resource_detail";
    }

    @GetMapping("/upload")
    public String uploadPage(HttpSession session) {
        if (session.getAttribute("currUser") == null) {
            return "redirect:/user/loginPage";
        }
        return "resource_upload";
    }

    @PostMapping("/doUpload")
    @ResponseBody
    public Map<String, Object> doUpload(@RequestParam(value = "file", required = false) MultipartFile file,
                                        String title, String courseName, String category, String description,
                                        Integer points, HttpSession session, HttpServletRequest request) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("currUser");
        try {
            String uploadPath = request.getServletContext().getRealPath("/uploads/");
            resourceService.uploadResource(user, file, title, courseName, category, description, points, uploadPath);
            session.setAttribute("currUser", userService.refreshById(user.getId()));
            result.put("code", 200);
            result.put("msg", "上传成功");
        } catch (IllegalArgumentException | IllegalStateException e) {
            result.put("code", 500);
            result.put("msg", e.getMessage());
        }
        return result;
    }

    @GetMapping("/downloadCheck")
    @ResponseBody
    public Map<String, Object> downloadCheck(Integer id, HttpSession session) {
        Map<String, Object> resMap = new HashMap<>();
        User user = (User) session.getAttribute("currUser");
        if (user == null) {
            resMap.put("code", 401);
            return resMap;
        }
        try {
            resourceService.assertDownloadable(user, id);
            session.setAttribute("downloadResourceId", id);
            resMap.put("code", 200);
            resMap.put("points", user.getPoints());
        } catch (IllegalArgumentException e) {
            resMap.put("code", 400);
            resMap.put("msg", e.getMessage());
        }
        return resMap;
    }

    @GetMapping("/getFile")
    public void getFile(Integer id, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws IOException {
        User user = (User) session.getAttribute("currUser");
        Integer pendingId = (Integer) session.getAttribute("downloadResourceId");
        if (user == null || pendingId == null || !pendingId.equals(id)) {
            response.sendError(403, "请先完成下载校验");
            return;
        }
        Resource r = resourceService.getDetail(id);
        if (r == null || r.getFilePath() == null) return;

        File file = new File(request.getServletContext().getRealPath("/uploads/"), r.getFilePath());
        if (!file.exists()) {
            session.removeAttribute("downloadResourceId");
            response.sendError(404, "文件在服务器磁盘中未找到");
            return;
        }

        resourceService.consumeDownload(user, id);
        session.setAttribute("currUser", userService.refreshById(user.getId()));
        response.setContentType("application/octet-stream");
        String filename = URLEncoder.encode(r.getTitle(), "UTF-8");
        response.setHeader("Content-Disposition", "attachment;filename=" + filename
                + r.getFilePath().substring(r.getFilePath().lastIndexOf(".")));

        try (InputStream is = new FileInputStream(file); OutputStream os = response.getOutputStream()) {
            byte[] b = new byte[8192];
            int len;
            while ((len = is.read(b)) != -1) {
                os.write(b, 0, len);
            }
        }
        session.removeAttribute("downloadResourceId");
        resourceService.markDownloaded(id);
    }

    @PostMapping("/addComment")
    @ResponseBody
    public Map<String, Object> addComment(Integer resourceId, String content, HttpSession session) {
        Map<String, Object> res = new HashMap<>();
        User user = (User) session.getAttribute("currUser");
        if (user == null) {
            res.put("code", 401);
            return res;
        }
        try {
            resourceService.addComment(user, resourceId, content);
            res.put("code", 200);
        } catch (IllegalArgumentException e) {
            res.put("code", 400);
            res.put("msg", e.getMessage());
        }
        return res;
    }

    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> delete(Integer id, HttpSession session, HttpServletRequest request) {
        Map<String, Object> res = new HashMap<>();
        User user = (User) session.getAttribute("currUser");
        try {
            resourceService.deleteResource(id, user, request.getServletContext().getRealPath("/uploads/"),
                    user != null && "1".equals(user.getRole()));
            res.put("code", 200);
            res.put("msg", "删除成功");
        } catch (IllegalArgumentException e) {
            res.put("code", 403);
            res.put("msg", e.getMessage());
        }
        return res;
    }
}
