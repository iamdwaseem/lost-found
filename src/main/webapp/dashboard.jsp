<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.lostfound.model.Item" %>
<%@ page import="com.lostfound.dao.ItemDAO" %>
<%
  // Session check — redirect to login if not logged in
  String userRole = (String) session.getAttribute("userRole");
  String userName = (String) session.getAttribute("userName");
  if (userName == null) { response.sendRedirect("login.html"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard - Lost & Found Portal</title>
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
      <a href="dashboard.jsp" class="active">Dashboard</a>
      <a href="submit.jsp">Report Item</a>
      <a href="my-claims.jsp">My Claims</a>
      <% if ("admin".equals(userRole)) { %>
        <a href="admin.jsp">Admin Panel</a>
      <% } %>
      <span style="color: var(--text-muted); font-size: 0.85rem;">Hi, <%= userName %></span>
      <a href="LogoutServlet">Logout</a>
    </div>
  </nav>

  <main class="dashboard-container">
    <div class="dashboard-header animate-fade-in">
      <h1>Recent Items</h1>
      <div class="filter-group">
        <button class="filter-btn active">All</button>
        <button class="filter-btn">Lost</button>
        <button class="filter-btn">Found</button>
      </div>
    </div>

    <div class="items-grid">
      <% 
        ItemDAO dao = new ItemDAO();
        List<Item> items = dao.getOpenItems();
        
        if (items == null || items.isEmpty()) {
      %>
        <div class="glass-panel empty-state">
            <p>No items have been reported yet.</p>
        </div>
      <% 
        } else {
            int delay = 1;
            for (Item item : items) { 
                String badgeClass = "lost".equalsIgnoreCase(item.getCategory()) ? "badge-lost" : "badge-found";
      %>
      <div class="glass-panel item-card delay-<%= delay > 3 ? 3 : delay %> animate-fade-in" style="opacity: 0;" data-category="<%= item.getCategory().toLowerCase() %>">
        <% if (item.getImagePath() != null && !item.getImagePath().isEmpty()) { %>
            <img src="<%= request.getContextPath() %>/<%= item.getImagePath() %>" alt="<%= item.getName() %>" class="item-image">
        <% } else { %>
            <img src="https://via.placeholder.com/500x200?text=No+Image" alt="No image available" class="item-image">
        <% } %>
        <div class="item-content">
          <div style="display: flex; align-items: center; gap: 0.5rem;">
            <span class="item-badge <%= badgeClass %>"><%= item.getCategory() %></span>
            <% if ("claimed".equals(item.getStatus())) { %>
              <span class="status-badge status-claimed" style="font-size: 0.65rem;">claimed</span>
            <% } %>
          </div>
          <h3 class="item-title"><%= item.getName() %></h3>
          <div class="item-date">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
            <%= item.getDate() %>
          </div>
          <div class="item-location">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
            <%= item.getLocation() %>
          </div>
          <p class="item-desc"><%= item.getDescription() %></p>
          <div class="item-footer">
            <a href="ItemDetail?id=<%= item.getId() %>" class="btn-secondary btn-sm" style="width: 100%; text-decoration: none;">View Details</a>
          </div>
        </div>
      </div>
      <% 
                delay++;
            }
        } 
      %>
    </div>
  </main>

  <script>
    document.addEventListener('DOMContentLoaded', () => {
      const filterBtns = document.querySelectorAll('.filter-btn');
      const items = document.querySelectorAll('.item-card');

      filterBtns.forEach(btn => {
        btn.addEventListener('click', () => {
          filterBtns.forEach(b => b.classList.remove('active'));
          btn.classList.add('active');
          const filter = btn.textContent.toLowerCase();
          items.forEach(item => {
            const category = item.getAttribute('data-category');
            item.style.display = (filter === 'all' || category === filter) ? 'flex' : 'none';
          });
        });
      });
    });
  </script>
</body>
</html>
