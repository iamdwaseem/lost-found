package com.lostfound.servlet;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lostfound.model.Claim;
import com.lostfound.model.ClaimMessage;
import com.lostfound.model.Item;
import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ClaimMessageDAO;
import com.lostfound.dao.ItemDAO;

import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import java.io.File;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class ClaimThreadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userName = (String) request.getSession().getAttribute("userName");
        if (userName == null) { response.sendRedirect("login.html"); return; }

        String claimIdStr = request.getParameter("id");
        if (claimIdStr == null) { response.sendRedirect("dashboard.jsp"); return; }

        try {
            int claimId = Integer.parseInt(claimIdStr);
            ClaimDAO claimDAO = new ClaimDAO();
            Claim claim = claimDAO.getClaimById(claimId);
            if (claim == null) { response.sendRedirect("dashboard.jsp"); return; }

            ItemDAO itemDAO = new ItemDAO();
            Item item = itemDAO.getItemById(claim.getItemId());

            ClaimMessageDAO msgDAO = new ClaimMessageDAO();
            List<ClaimMessage> messages = msgDAO.getMessagesByClaimId(claimId);

            request.setAttribute("claim", claim);
            request.setAttribute("item", item);
            request.setAttribute("messages", messages);
            RequestDispatcher dispatcher = request.getRequestDispatcher("claim-thread.jsp");
            dispatcher.forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userName = (String) request.getSession().getAttribute("userName");
        String userRole = (String) request.getSession().getAttribute("userRole");
        if (userName == null) { response.sendRedirect("login.html"); return; }

        String claimIdStr = request.getParameter("claimId");
        String message = request.getParameter("message");

        if (claimIdStr != null) {
            int claimId = Integer.parseInt(claimIdStr);
            String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));

            String imagePath = null;
            Part filePart = request.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadFilePath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                String submittedFileName = null;
                for (String cd : filePart.getHeader("content-disposition").split(";")) {
                    if (cd.trim().startsWith("filename")) {
                        submittedFileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                    }
                }
                if (submittedFileName == null || submittedFileName.isEmpty()) submittedFileName = "image";
                
                String fileName = "msg_" + System.currentTimeMillis() + "_" + submittedFileName.replaceAll("\\s+", "_");
                filePart.write(uploadFilePath + File.separator + fileName);
                imagePath = UPLOAD_DIR + "/" + fileName;
            }

            // Only save if there's a message OR an image
            if ((message != null && !message.trim().isEmpty()) || imagePath != null) {
                ClaimMessage msg = new ClaimMessage();
                msg.setClaimId(claimId);
                msg.setSenderName(userName);
                msg.setSenderRole(userRole != null ? userRole : "user");
                msg.setMessage(message != null ? message.trim() : "");
                msg.setCreatedAt(now);
                msg.setImagePath(imagePath);

                ClaimMessageDAO msgDAO = new ClaimMessageDAO();
                msgDAO.saveMessage(msg);
            }

            response.sendRedirect("ClaimThread?id=" + claimId);
        } else {
            response.sendRedirect("dashboard.jsp");
        }
    }
}
