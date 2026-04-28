<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lostfound.model.Item" %>
<%
  Item item = (Item) request.getAttribute("item");
  if (item == null) { response.sendRedirect("dashboard.jsp"); return; }
  String badgeClass = "lost".equalsIgnoreCase(item.getCategory()) ? "badge-lost" : "badge-found";

  // Session check
  String userRole = (String) session.getAttribute("userRole");
  String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title><%= item.getName() %> - Lost & Found Portal</title>
  <link rel="stylesheet" href="css/global.css">
  <link rel="stylesheet" href="css/dashboard.css">
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
      <% if (userName != null) { %>
        <a href="my-claims.jsp">My Claims</a>
        <% if ("admin".equals(userRole)) { %>
          <a href="admin.jsp">Admin Panel</a>
        <% } %>
        <span style="color: var(--text-muted); font-size: 0.85rem;">Hi, <%= userName %></span>
        <a href="LogoutServlet">Logout</a>
      <% } else { %>
        <a href="login.html">Login</a>
      <% } %>
    </div>
  </nav>

  <main class="detail-container">
    <div class="glass-panel detail-card animate-fade-in">
      <% if (item.getImagePath() != null && !item.getImagePath().isEmpty()) { %>
        <img src="<%= request.getContextPath() %>/<%= item.getImagePath() %>" alt="<%= item.getName() %>" class="detail-image">
      <% } else { %>
        <img src="https://via.placeholder.com/700x350?text=No+Image" alt="No image" class="detail-image">
      <% } %>

      <div class="detail-body">
        <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 1rem;">
          <span class="item-badge <%= badgeClass %>" style="margin-bottom: 0;"><%= item.getCategory() %></span>
          <span class="status-badge status-<%= item.getStatus() %>"><%= item.getStatus() %></span>
        </div>

        <h1 style="font-size: 1.8rem; margin-bottom: 1rem;"><%= item.getName() %></h1>

        <div class="detail-meta">
          <div class="detail-meta-item">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
            <%= item.getDate() %>
          </div>
          <div class="detail-meta-item">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
            <%= item.getLocation() %>
          </div>
        </div>

        <p class="detail-description"><%= item.getDescription() %></p>

        <% if (item.getReporterName() != null && !item.getReporterName().isEmpty()) { %>
        <div class="detail-reporter">
          <h4>Reported By</h4>
          <p style="color: var(--text-color);"><%= item.getReporterName() %></p>
          <% if (item.getReporterEmail() != null) { %>
            <p style="color: var(--text-muted); font-size: 0.9rem;"><%= item.getReporterEmail() %></p>
          <% } %>
        </div>
        <% } %>

        <div class="detail-actions">
          <a href="dashboard.jsp" class="btn-secondary">&larr; Back</a>
          <% if ("open".equals(item.getStatus()) || "claimed".equals(item.getStatus())) { %>
            <a href="claim.html?id=<%= item.getId() %>&name=<%= java.net.URLEncoder.encode(item.getName(), "UTF-8") %>" class="btn-primary">Claim This Item</a>
          <% } else { %>
            <span class="btn-primary" style="opacity: 0.5; cursor: default;">Resolved</span>
          <% } %>
        </div>
      </div>
    </div>
  </main>
</body>
</html>
