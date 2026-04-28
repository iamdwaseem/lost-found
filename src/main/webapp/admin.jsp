<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.lostfound.model.Item" %>
<%@ page import="com.lostfound.model.Claim" %>
<%@ page import="com.lostfound.dao.ItemDAO" %>
<%@ page import="com.lostfound.dao.ClaimDAO" %>
<%
  // Check admin role in session
  String userRole = (String) session.getAttribute("userRole");
  if (userRole == null || !"admin".equals(userRole)) {
    response.sendRedirect("login.html");
    return;
  }
  String userName = (String) session.getAttribute("userName");


  ItemDAO itemDAO = new ItemDAO();
  ClaimDAO claimDAO = new ClaimDAO();
  List<Item> allItems = itemDAO.getAllItems();
  List<Claim> pendingClaims = claimDAO.getPendingClaims();
  List<Claim> allClaims = claimDAO.getAllClaims();

  int totalItems = (allItems != null) ? allItems.size() : 0;
  int openItems = 0;
  int resolvedItems = 0;
  if (allItems != null) {
    for (Item i : allItems) {
      if ("open".equals(i.getStatus())) openItems++;
      if ("resolved".equals(i.getStatus())) resolvedItems++;
    }
  }
  int pendingCount = (pendingClaims != null) ? pendingClaims.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Panel - Lost & Found Portal</title>
  <link rel="stylesheet" href="css/global.css">
  <link rel="stylesheet" href="css/admin.css">
</head>
<body>
  <nav class="navbar">
    <a href="admin.jsp" class="nav-brand">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: var(--primary-color)"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
      Find<span>It</span>
    </a>
    <div class="nav-links">
      <a href="dashboard.jsp">Public Dashboard</a>
      <a href="admin.jsp" class="active">Admin</a>
      <span style="color: var(--text-muted); font-size: 0.85rem;">Hi, <%= userName %></span>
      <a href="LogoutServlet">Logout</a>
    </div>
  </nav>

  <main class="admin-container">
    <div class="admin-header animate-fade-in">
      <h1>Admin Panel</h1>
    </div>

    <!-- Stats -->
    <div class="stats-row animate-fade-in">
      <div class="glass-panel stat-card">
        <div class="stat-number"><%= totalItems %></div>
        <div class="stat-label">Total Items</div>
      </div>
      <div class="glass-panel stat-card">
        <div class="stat-number"><%= openItems %></div>
        <div class="stat-label">Open Items</div>
      </div>
      <div class="glass-panel stat-card">
        <div class="stat-number"><%= pendingCount %></div>
        <div class="stat-label">Pending Claims</div>
      </div>
      <div class="glass-panel stat-card">
        <div class="stat-number"><%= resolvedItems %></div>
        <div class="stat-label">Resolved</div>
      </div>
    </div>

    <!-- Pending Claims Section -->
    <h2 class="section-title animate-fade-in">Pending Claims</h2>
    <div class="glass-panel claims-table-wrapper animate-fade-in" style="margin-bottom: 3rem; padding: 0.5rem;">
      <% if (pendingClaims == null || pendingClaims.isEmpty()) { %>
        <div style="padding: 2rem; text-align: center; color: var(--text-muted);">No pending claims.</div>
      <% } else { %>
      <table class="claims-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Item</th>
            <th>Claimant</th>
            <th>Email</th>
            <th>Proof</th>
            <th>Date</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <% for (Claim claim : pendingClaims) {
              Item claimItem = itemDAO.getItemById(claim.getItemId());
              String claimItemName = (claimItem != null) ? claimItem.getName() : "Deleted Item";
          %>
          <tr>
            <td>#<%= claim.getId() %></td>
            <td><%= claimItemName %></td>
            <td><%= claim.getClaimantName() %></td>
            <td><%= claim.getClaimantEmail() %></td>
            <td style="max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="<%= claim.getProof() %>">
              <%= claim.getProof() %>
              <% if (claim.getProofImagePath() != null && !claim.getProofImagePath().isEmpty()) { %>
                <br><span style="color: var(--success-color); font-size: 0.75rem;">📎 Image attached</span>
              <% } %>
            </td>
            <td><%= claim.getCreatedAt() %></td>
            <td style="white-space: nowrap;">
              <a href="ClaimThread?id=<%= claim.getId() %>" class="action-btn btn-resolve" style="text-decoration: none;">View Thread</a>
              <form action="AdminServlet" method="POST" style="display: inline;">
                <input type="hidden" name="action" value="approveClaim">
                <input type="hidden" name="id" value="<%= claim.getId() %>">
                <button type="submit" class="action-btn btn-approve">Approve</button>
              </form>
              <form action="AdminServlet" method="POST" style="display: inline;">
                <input type="hidden" name="action" value="rejectClaim">
                <input type="hidden" name="id" value="<%= claim.getId() %>">
                <button type="submit" class="action-btn btn-reject">Reject</button>
              </form>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
      <% } %>
    </div>

    <!-- All Items Section -->
    <h2 class="section-title animate-fade-in">All Items</h2>
    <div class="glass-panel claims-table-wrapper animate-fade-in" style="padding: 0.5rem;">
      <% if (allItems == null || allItems.isEmpty()) { %>
        <div style="padding: 2rem; text-align: center; color: var(--text-muted);">No items in the system.</div>
      <% } else { %>
      <table class="claims-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Category</th>
            <th>Location</th>
            <th>Date</th>
            <th>Reporter</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <% for (Item item : allItems) {
              String statusClass = "status-" + item.getStatus();
          %>
          <tr>
            <td>#<%= item.getId() %></td>
            <td><a href="ItemDetail?id=<%= item.getId() %>" style="color: var(--primary-color); text-decoration: none;"><%= item.getName() %></a></td>
            <td><span class="item-badge <%= "lost".equalsIgnoreCase(item.getCategory()) ? "badge-lost" : "badge-found" %>"><%= item.getCategory() %></span></td>
            <td><%= item.getLocation() %></td>
            <td><%= item.getDate() %></td>
            <td><%= item.getReporterName() != null ? item.getReporterName() : "-" %></td>
            <td><span class="status-badge <%= statusClass %>"><%= item.getStatus() %></span></td>
            <td>
              <% if (!"resolved".equals(item.getStatus())) { %>
              <form action="AdminServlet" method="POST" style="display: inline;">
                <input type="hidden" name="action" value="resolveItem">
                <input type="hidden" name="id" value="<%= item.getId() %>">
                <button type="submit" class="action-btn btn-resolve">Resolve</button>
              </form>
              <% } %>
              <form action="AdminServlet" method="POST" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this item?');">
                <input type="hidden" name="action" value="deleteItem">
                <input type="hidden" name="id" value="<%= item.getId() %>">
                <button type="submit" class="action-btn btn-delete">Delete</button>
              </form>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
      <% } %>
    </div>
  </main>
</body>
</html>
