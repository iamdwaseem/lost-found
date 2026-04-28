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

public class ClaimThreadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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

        if (claimIdStr != null && message != null && !message.trim().isEmpty()) {
            int claimId = Integer.parseInt(claimIdStr);
            String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));

            ClaimMessage msg = new ClaimMessage();
            msg.setClaimId(claimId);
            msg.setSenderName(userName);
            msg.setSenderRole(userRole != null ? userRole : "user");
            msg.setMessage(message.trim());
            msg.setCreatedAt(now);

            ClaimMessageDAO msgDAO = new ClaimMessageDAO();
            msgDAO.saveMessage(msg);

            response.sendRedirect("ClaimThread?id=" + claimId);
        } else {
            response.sendRedirect("dashboard.jsp");
        }
    }
}
