package com.lostfound.servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.lostfound.model.Claim;
import com.lostfound.model.ClaimMessage;
import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ClaimMessageDAO;
import com.lostfound.dao.ItemDAO;

public class ClaimServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String itemIdStr = request.getParameter("itemId");
        String claimantName = request.getParameter("claimantName");
        String claimantEmail = request.getParameter("claimantEmail");
        String proof = request.getParameter("proof");

        // Get logged-in user ID from session
        Integer userId = (Integer) request.getSession().getAttribute("userId");

        try {
            int itemId = Integer.parseInt(itemIdStr);

            // Prevent duplicate claims — one claim per user per item
            ClaimDAO claimDAO = new ClaimDAO();
            com.lostfound.model.Claim existingClaim = claimDAO.getPreviousClaim(itemId, claimantEmail);
            if (existingClaim != null) {
                String message;
                if ("pending".equals(existingClaim.getStatus())) {
                    message = "You have already submitted a claim for this item. Please wait for the admin to review it.";
                } else if ("rejected".equals(existingClaim.getStatus())) {
                    message = "Your previous claim for this item was rejected. You cannot file another claim for this item.";
                } else if ("approved".equals(existingClaim.getStatus())) {
                    message = "Your claim for this item has already been approved!";
                } else {
                    message = "You have already filed a claim for this item.";
                }
                
                request.setAttribute("successMessage", message);
                RequestDispatcher dispatcher = request.getRequestDispatcher("result.jsp");
                dispatcher.forward(request, response);
                return;
            }
            String proofImagePath = null;
            Part filePart = request.getPart("proofImage");
            if (filePart != null && filePart.getSize() > 0) {
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;
                File fileSaveDir = new File(uploadFilePath);
                if (!fileSaveDir.exists()) fileSaveDir.mkdirs();

                String submittedFileName = null;
                for (String cd : filePart.getHeader("content-disposition").split(";")) {
                    if (cd.trim().startsWith("filename")) {
                        submittedFileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                    }
                }
                if (submittedFileName == null || submittedFileName.isEmpty()) submittedFileName = "proof_image";

                String fileName = Paths.get(submittedFileName).getFileName().toString();
                String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                filePart.write(uploadFilePath + File.separator + uniqueFileName);
                proofImagePath = UPLOAD_DIR + "/" + uniqueFileName;
            }

            String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));

            // Save claim
            Claim claim = new Claim();
            claim.setItemId(itemId);
            claim.setClaimantName(claimantName);
            claim.setClaimantEmail(claimantEmail);
            claim.setProof(proof);
            claim.setProofImagePath(proofImagePath);
            claim.setStatus("pending");
            claim.setCreatedAt(now);
            claim.setClaimantUserId(userId);

            claimDAO.saveClaim(claim);

            // Create the first message in the thread (the claim itself)
            ClaimMessageDAO msgDAO = new ClaimMessageDAO();
            ClaimMessage firstMsg = new ClaimMessage();
            firstMsg.setClaimId(claim.getId());
            firstMsg.setSenderName(claimantName);
            firstMsg.setSenderRole("user");
            firstMsg.setMessage(proof);
            firstMsg.setCreatedAt(now);
            msgDAO.saveMessage(firstMsg);

            // Update item status
            ItemDAO itemDAO = new ItemDAO();
            itemDAO.updateItemStatus(itemId, "claimed");

            request.setAttribute("successMessage",
                "Your claim has been submitted! An admin will review it and may ask follow-up questions.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("result.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to submit claim: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("dashboard.jsp");
            dispatcher.forward(request, response);
        }
    }
}
