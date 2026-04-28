<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String userRole = (String) session.getAttribute("userRole");
  String userName = (String) session.getAttribute("userName");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Report Item - Lost & Found Portal</title>
  <meta name="description" content="Report a lost or found item.">
  <link rel="stylesheet" href="css/global.css">
  <link rel="stylesheet" href="css/form.css">
</head>
<body>
  <nav class="navbar">
    <a href="dashboard.jsp" class="nav-brand">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: var(--primary-color)"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
      Find<span>It</span>
    </a>
    <div class="nav-links">
      <a href="dashboard.jsp">Dashboard</a>
      <% if (userName != null) { %>
        <% if (!"admin".equals(userRole)) { %>
          <a href="submit.jsp" class="active">Report Item</a>
          <a href="my-claims.jsp">My Claims</a>
        <% } else { %>
          <a href="admin.jsp">Admin Panel</a>
        <% } %>
        <span style="color: var(--text-muted); font-size: 0.85rem;">Hi, <%= userName %></span>
        <a href="LogoutServlet">Logout</a>
      <% } else { %>
        <a href="login.html">Login</a>
      <% } %>
    </div>
  </nav>

  <main class="form-page-container">
    <div class="glass-panel submission-card animate-fade-in">
      <h1 style="margin-bottom: 0.5rem; font-size: 2rem;">Report an Item</h1>
      <p style="color: var(--text-muted); margin-bottom: 2rem;">Provide details about the item you lost or found.</p>

      <form id="submitForm" action="ReportItemServlet" method="POST" enctype="multipart/form-data">
        
        <div class="form-group delay-1 animate-fade-in" style="opacity: 0;">
          <label for="itemName">Item Name</label>
          <input type="text" id="itemName" name="itemName" class="form-control" placeholder="e.g., Blue Backpack">
        </div>

        <div class="form-row delay-1 animate-fade-in" style="opacity: 0;">
          <div class="form-group">
            <label for="type">Status</label>
            <select id="type" name="type" class="form-control">
              <option value="" disabled selected>Select status</option>
              <option value="lost">Lost</option>
              <option value="found">Found</option>
            </select>
          </div>
          
          <div class="form-group">
            <label for="date">Date</label>
            <input type="date" id="date" name="date" class="form-control">
          </div>
        </div>

        <div class="form-group delay-2 animate-fade-in" style="opacity: 0;">
          <label for="location">Location</label>
          <input type="text" id="location" name="location" class="form-control" placeholder="Where was it lost/found?">
        </div>

        <div class="form-group delay-2 animate-fade-in" style="opacity: 0;">
          <label for="description">Description</label>
          <textarea id="description" name="description" class="form-control" placeholder="Provide additional details like color, brand, unique marks..."></textarea>
        </div>

        <div class="form-row delay-2 animate-fade-in" style="opacity: 0;">
          <div class="form-group">
            <label for="reporterName">Your Name</label>
            <input type="text" id="reporterName" name="reporterName" class="form-control" placeholder="John Doe" value="<%= userName != null ? userName : "" %>">
          </div>
          <div class="form-group">
            <label for="reporterEmail">Your Email</label>
            <input type="email" id="reporterEmail" name="reporterEmail" class="form-control" placeholder="you@example.com" value="<%= session.getAttribute("userEmail") != null ? session.getAttribute("userEmail") : "" %>">
          </div>
        </div>

        <div class="form-group delay-3 animate-fade-in" style="opacity: 0;">
          <label>Item Image</label>
          <div class="file-upload-wrapper">
            <div class="upload-icon">
              <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="17 8 12 3 7 8"></polyline><line x1="12" y1="3" x2="12" y2="15"></line></svg>
            </div>
            <p class="upload-text">Drag and drop or <span>browse</span></p>
            <input type="file" id="imageFile" name="imageFile" accept="image/png, image/jpeg, image/jpg, image/gif">
          </div>
          <div id="fileName"></div>
        </div>

        <button type="submit" class="btn-primary delay-3 animate-fade-in" style="opacity: 0; margin-top: 1rem;">Submit Report</button>
      </form>
    </div>
  </main>

  <script src="js/validation.js"></script>
</body>
</html>
