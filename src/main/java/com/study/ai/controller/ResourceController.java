package com.study.ai.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.study.ai.pojo.entity.*;
import com.study.ai.mapper.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.*;
import java.io.*;
import java.net.URLEncoder;
import java.util.*;

@Controller
@RequestMapping("/resource")
public class ResourceController {

    @Autowired private ResourceMapper resourceMapper;
    @Autowired private UserMapper userMapper;
    @Autowired private CommentMapper commentMapper;

    // 1. 列表
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int page, String keyword, Model model) {
        PageHelper.startPage(page, 8);
        List<Resource> list = (keyword != null && !keyword.isEmpty())
                ? resourceMapper.searchByTitle(keyword) : resourceMapper.findAll();
        model.addAttribute("pageInfo", new PageInfo<>(list));
        return "resource_list";
    }

    // 2. 详情页 (对应 resource_detail.jsp)
    @GetMapping("/detail")
    public String detail(Integer id, Model model) {
        Resource res = resourceMapper.findById(id);
        model.addAttribute("res", res);
        model.addAttribute("commentList", commentMapper.findByResourceId(id));
        return "resource_detail";
    }

    // 3. 上传页 (对应 resource_upload.jsp)
    @GetMapping("/upload")
    public String uploadPage(HttpSession session) {
        if (session.getAttribute("currUser") == null) return "redirect:/login";
        return "resource_upload";
    }

    // 4. 执行上传
    @PostMapping("/doUpload")
    @ResponseBody
    public Map<String, Object> doUpload(
            @RequestParam(value = "file", required = false) MultipartFile file,
            String title, String description, Integer points, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("currUser");

        Resource res = new Resource();
        res.setTitle(title);
        res.setDescription(description);
        res.setPoints(points == null ? 0 : points);
        res.setUploaderId(user.getId());
        res.setCreateTime(new Date());

        if (file != null && !file.isEmpty()) {
            try {
                // ！！！注意这里改为 uploads ！！！
                String uploadPath = session.getServletContext().getRealPath("/uploads/");
                File folder = new File(uploadPath);
                if (!folder.exists()) folder.mkdirs();

                String originalName = file.getOriginalFilename();
                String ext = originalName.substring(originalName.lastIndexOf("."));
                String newFileName = UUID.randomUUID().toString().replace("-", "") + ext;

                file.transferTo(new File(folder, newFileName));
                res.setFilePath(newFileName);
                res.setFileSize((file.getSize() / 1024) + "KB");
            } catch (Exception e) {
                result.put("code", 500);
                result.put("msg", "保存失败:" + e.getMessage());
                return result;
            }
        }
        resourceMapper.insertResource(res);
        result.put("code", 200);
        return result;
    }

    // 5. 下载检查
    @GetMapping("/downloadCheck")
    @ResponseBody
    public Map<String, Object> downloadCheck(Integer id, HttpSession session) {
        Map<String, Object> resMap = new HashMap<>();
        User user = (User) session.getAttribute("currUser");
        if(user == null) { resMap.put("code", 401); return resMap; }

        Resource r = resourceMapper.findById(id);
        if(user.getPoints() < r.getPoints()) {
            resMap.put("code", 400);
            resMap.put("msg", "积分不足");
        } else {
            userMapper.changePoints(user.getId(), -r.getPoints());
            user.setPoints(user.getPoints() - r.getPoints());
            session.setAttribute("currUser", user);
            resMap.put("code", 200);
        }
        return resMap;
    }

    // 6. 真正下载文件的具体实现
    @GetMapping("/getFile")
    public void getFile(Integer id, HttpServletRequest request, HttpServletResponse response) throws IOException {
        Resource r = resourceMapper.findById(id);
        if (r == null || r.getFilePath() == null) return;

        // ！！！注意这里改为 uploads ！！！
        File file = new File(request.getServletContext().getRealPath("/uploads/"), r.getFilePath());
        if(!file.exists()) {
            response.sendError(404, "文件在服务器磁盘中未找到");
            return;
        }

        response.setContentType("application/octet-stream");
        String filename = URLEncoder.encode(r.getTitle(), "UTF-8");
        response.setHeader("Content-Disposition", "attachment;filename=" + filename + r.getFilePath().substring(r.getFilePath().lastIndexOf(".")));

        try (InputStream is = new FileInputStream(file); OutputStream os = response.getOutputStream()) {
            byte[] b = new byte[8192];
            int len;
            while ((len = is.read(b)) != -1) os.write(b, 0, len);
        }
        resourceMapper.incrDownloadCount(id);
    }

    // 7. 发表评论 (改用这个方法名，并加上评论防重逻辑)
    @PostMapping("/addComment")
    @ResponseBody
    public Map<String, Object> addComment(Integer resourceId, String content, HttpSession session) {
        Map<String, Object> res = new HashMap<>();
        User user = (User) session.getAttribute("currUser");
        if(user == null) { res.put("code", 401); return res; }

        // 简单去重：如果内容为空或者太短不让发
        if(content == null || content.trim().length() < 2) {
            res.put("code", 400);
            res.put("msg", "内容太短");
            return res;
        }

        Comment c = new Comment();
        c.setResourceId(resourceId);
        c.setContent(content);
        c.setUserId(user.getId());
        commentMapper.insert(c);

        res.put("code", 200);
        return res;
    }
}