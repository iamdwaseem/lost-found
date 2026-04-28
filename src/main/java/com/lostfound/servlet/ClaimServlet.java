package com.lostfound.servlet;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lostfound.model.Claim;
import com.lostfound.dao.ClaimDAO;
import com.lostfound.dao.ItemDAO;

public class ClaimServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String itemIdStr = request.getParameter("itemId");
        String claimantName = request.getParameter("claimantName");
        String claimantEmail = request.getParameter("claimantEmail");
        String proof = request.getParameter("proof");

        try {
            int itemId = Integer.parseInt(itemIdStr);

            Claim claim = new Claim();
            claim.setItemId(itemId);
            claim.setClaimantName(claimantName);
            claim.setClaimantEmail(claimantEmail);
            claim.setProof(proof);
            claim.setStatus("pending");
            claim.setCreatedAt(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")));

            ClaimDAO claimDAO = new ClaimDAO();
            claimDAO.saveClaim(claim);

            // Update item status to "claimed"
            ItemDAO itemDAO = new ItemDAO();
            itemDAO.updateItemStatus(itemId, "claimed");

            request.setAttribute("successMessage",
                "Your claim has been submitted successfully! An administrator will review it shortly.");
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
