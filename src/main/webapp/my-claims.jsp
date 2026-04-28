<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.lostfound.model.Claim" %>
<%@ page import="com.lostfound.model.Item" %>
<%@ page import="com.lostfound.dao.ClaimDAO" %>
<%@ page import="com.lostfound.dao.ItemDAO" %>
<%
  String userName = (String) session.getAttribute("userName");
  String userEmail = (String) session.getAttribute("userEmail");
  String userRole = (String) session.getAttribute("userRole");
  if (userName == null) { response.sendRedirect("login.html"); return; }

  ClaimDAO claimDAO = new ClaimDAO();
  ItemDAO itemDAO = new ItemDAO();
  List<Claim> myClaims = claimDAO.getClaimsByEmail(userEmail);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Claims - Lost & Found Portal</title>
  <link rel="stylesheet" href="css/global.css">
  <link rel="stylesheet" href="css/admin.css">
</head>
<body>
  <nav class="navbar">
    <a href="dashboard.jsp" class="nav-brand">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: var(--primary-color)"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
      Find<span>It</span>
    </a>
    <div class="nav-links">
      <a href="dashboard.jsp">Dashboard</a>
      <a href="submit.jsp">Report Item</a>
      <a href="my-claims.jsp" class="active">My Claims</a>
      <% if ("admin".equals(userRole)) { %><a href="admin.jsp">Admin Panel</a><% } %>
      <span style="color: var(--text-muted); font-size: 0.85rem;">Hi, <%= userName %></span>
      <a href="LogoutServlet">Logout</a>
    </div>
  </nav>

  <main class="admin-container" style="max-width: 900px; margin: 0 auto;">
    <div class="admin-header animate-fade-in">
      <h1>My Claims</h1>
    </div>

    <% if (myClaims == null || myClaims.isEmpty()) { %>
      <div class="glass-panel animate-fade-in" style="padding: 3rem; text-align: center;">
        <p style="color: var(--text-muted); font-size: 1.1rem; margin-bottom: 1rem;">You haven't filed any claims yet.</p>
        <a href="dashboard.jsp" class="btn-primary" style="display: inline-block; width: auto; padding: 0.65rem 1.5rem; text-decoration: none;">Browse Items</a>
      </div>
    <% } else { %>
      <div style="display: flex; flex-direction: column; gap: 1rem;">
        <% for (Claim claim : myClaims) {
            Item claimItem = itemDAO.getItemById(claim.getItemId());
            String itemName = (claimItem != null) ? claimItem.getName() : "Deleted Item";
            String statusClass = "status-" + claim.getStatus();
        %>
        <div class="glass-panel animate-fade-in" style="padding: 1.5rem;">
          <div style="display: flex; justify-content: space-between; align-items: flex-start; flex-wrap: wrap; gap: 1rem;">
            <div style="flex: 1; min-width: 200px;">
              <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.75rem;">
                <span class="status-badge <%= statusClass %>"><%= claim.getStatus() %></span>
                <span style="color: var(--text-muted); font-size: 0.8rem;">Claim #<%= claim.getId() %></span>
              </div>
              <h3 style="font-size: 1.15rem; margin-bottom: 0.5rem;"><%= itemName %></h3>
              <p style="color: var(--text-muted); font-size: 0.9rem; line-height: 1.5; max-width: 500px; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;">
                <%= claim.getProof() %>
              </p>
              <p style="color: var(--text-muted); font-size: 0.8rem; margin-top: 0.5rem;">Filed on: <%= claim.getCreatedAt() %></p>
            </div>
            <div style="display: flex; align-items: center;">
              <a href="ClaimThread?id=<%= claim.getId() %>" class="btn-primary" style="text-decoration: none; padding: 0.6rem 1.25rem; width: auto; font-size: 0.9rem;">
                <% if ("pending".equals(claim.getStatus())) { %>
                  View Thread &rarr;
                <% } else if ("approved".equals(claim.getStatus())) { %>
                  ✓ Approved — View
                <% } else { %>
                  View Details
                <% } %>
              </a>
            </div>
          </div>
        </div>
        <% } %>
      </div>
    <% } %>
  </main>
</body>
</html>
