package com.lostfound.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lostfound.dao.ItemDAO;
import com.lostfound.dao.ClaimDAO;

public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin role in session
        String userRole = (String) request.getSession().getAttribute("userRole");
        if (userRole == null || !"admin".equals(userRole)) {
            response.sendRedirect("login.html");
            return;
        }

        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if (action == null || idStr == null) {
            response.sendRedirect("admin.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(idStr);
            ItemDAO itemDAO = new ItemDAO();
            ClaimDAO claimDAO = new ClaimDAO();

            switch (action) {
                case "approveClaim":
                    // Approve the claim and resolve the item
                    claimDAO.updateClaimStatus(id, "approved");
                    int itemId = claimDAO.getClaimById(id).getItemId();
                    itemDAO.updateItemStatus(itemId, "resolved");
                    break;

                case "rejectClaim":
                    claimDAO.updateClaimStatus(id, "rejected");
                    // Set item back to open if no other pending claims
                    int rejectedItemId = claimDAO.getClaimById(id).getItemId();
                    if (claimDAO.getClaimsByItemId(rejectedItemId).stream()
                            .noneMatch(c -> "pending".equals(c.getStatus()))) {
                        itemDAO.updateItemStatus(rejectedItemId, "open");
                    }
                    break;

                case "resolveItem":
                    itemDAO.updateItemStatus(id, "resolved");
                    break;

                case "deleteItem":
                    itemDAO.deleteItem(id);
                    break;

                default:
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("admin.jsp");
    }
}
