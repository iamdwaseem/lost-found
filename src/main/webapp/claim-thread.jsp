<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.lostfound.model.Claim" %>
<%@ page import="com.lostfound.model.ClaimMessage" %>
<%@ page import="com.lostfound.model.Item" %>
<%
  String userName = (String) session.getAttribute("userName");
  String userRole = (String) session.getAttribute("userRole");
  if (userName == null) { response.sendRedirect("login.html"); return; }

  Claim claim = (Claim) request.getAttribute("claim");
  Item item = (Item) request.getAttribute("item");
  List<ClaimMessage> messages = (List<ClaimMessage>) request.getAttribute("messages");
  if (claim == null) { response.sendRedirect("dashboard.jsp"); return; }

  String itemName = (item != null) ? item.getName() : "Unknown Item";
  String statusClass = "status-" + claim.getStatus();
  boolean isResolved = "approved".equals(claim.getStatus()) || "rejected".equals(claim.getStatus());
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Claim Thread - <%= itemName %></title>
  <link rel="stylesheet" href="css/global.css">
  <link rel="stylesheet" href="css/admin.css">
  <style>
    .thread-container { padding: 2rem 5%; max-width: 800px; margin: 0 auto; flex: 1; }
    .thread-header { margin-bottom: 2rem; }
    .thread-header h1 { font-size: 1.8rem; margin-bottom: 0.5rem; }
    .thread-meta { display: flex; gap: 1rem; flex-wrap: wrap; align-items: center; margin-bottom: 1rem; }

    .claim-proof-section { margin-bottom: 2rem; padding: 1.5rem; border-radius: 14px; }
    .proof-image { max-width: 100%; max-height: 300px; border-radius: 10px; margin-top: 1rem; border: 1px solid var(--border-color); }

    .messages-list { display: flex; flex-direction: column; gap: 1rem; margin-bottom: 2rem; }

    .msg-bubble { padding: 1rem 1.25rem; border-radius: 14px; max-width: 85%; position: relative; }
    .msg-user { align-self: flex-end; background: rgba(99, 102, 241, 0.15); border: 1px solid rgba(99, 102, 241, 0.2); }
    .msg-admin { align-self: flex-start; background: rgba(16, 185, 129, 0.15); border: 1px solid rgba(16, 185, 129, 0.2); }
    .msg-sender { font-size: 0.8rem; font-weight: 600; margin-bottom: 0.35rem; display: flex; align-items: center; gap: 0.5rem; }
    .msg-sender .role-tag { font-size: 0.65rem; padding: 0.15rem 0.5rem; border-radius: 8px; text-transform: uppercase; font-weight: 700; }
    .role-tag.tag-admin { background: rgba(16, 185, 129, 0.25); color: #6ee7b7; }
    .role-tag.tag-user { background: rgba(99, 102, 241, 0.25); color: #a5b4fc; }
    .msg-text { font-size: 0.95rem; line-height: 1.6; color: var(--text-color); }
    .msg-time { font-size: 0.7rem; color: var(--text-muted); margin-top: 0.5rem; text-align: right; }

    .reply-box { padding: 1.5rem; border-radius: 14px; }
    .reply-box textarea { min-height: 80px; resize: vertical; }
    .reply-box .btn-primary { margin-top: 1rem; }

    .resolved-notice { text-align: center; padding: 1.5rem; border-radius: 14px; color: var(--text-muted); margin-bottom: 1rem; }
  </style>
</head>
<body>
  <nav class="navbar">
    <a href="dashboard.jsp" class="nav-brand">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: var(--primary-color)"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
      Find<span>It</span>
    </a>
    <div class="nav-links">
      <a href="dashboard.jsp">Dashboard</a>
      <a href="my-claims.jsp">My Claims</a>
      <% if ("admin".equals(userRole)) { %><a href="admin.jsp">Admin Panel</a><% } %>
      <span style="color: var(--text-muted); font-size: 0.85rem;">Hi, <%= userName %></span>
      <a href="LogoutServlet">Logout</a>
    </div>
  </nav>

  <main class="thread-container">
    <!-- Header -->
    <div class="thread-header animate-fade-in">
      <a href="<%= "admin".equals(userRole) ? "admin.jsp" : "my-claims.jsp" %>" style="color: var(--text-muted); text-decoration: none; font-size: 0.9rem;">&larr; Back</a>
      <h1 style="margin-top: 0.75rem;">Claim for: <%= itemName %></h1>
      <div class="thread-meta">
        <span class="status-badge <%= statusClass %>"><%= claim.getStatus() %></span>
        <span style="color: var(--text-muted); font-size: 0.85rem;">Filed by <strong style="color: var(--text-color);"><%= claim.getClaimantName() %></strong> &middot; <%= claim.getClaimantEmail() %></span>
      </div>
    </div>

    <!-- Proof Section -->
    <div class="glass-panel claim-proof-section animate-fade-in">
      <h3 style="font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.05em; color: var(--text-muted); margin-bottom: 0.75rem;">Proof of Ownership</h3>
      <p style="line-height: 1.6;"><%= claim.getProof() %></p>
      <% if (claim.getProofImagePath() != null && !claim.getProofImagePath().isEmpty()) { %>
        <img src="<%= request.getContextPath() %>/<%= claim.getProofImagePath() %>" alt="Proof image" class="proof-image">
      <% } %>
    </div>

    <!-- Messages Thread -->
    <h3 style="font-size: 1rem; color: var(--text-muted); margin-bottom: 1rem;" class="animate-fade-in">Conversation</h3>
    <div class="messages-list animate-fade-in">
      <% if (messages == null || messages.isEmpty()) { %>
        <div style="text-align: center; color: var(--text-muted); padding: 1rem;">No messages yet.</div>
      <% } else {
          for (ClaimMessage msg : messages) {
            boolean isAdmin = "admin".equals(msg.getSenderRole());
      %>
      <div class="msg-bubble <%= isAdmin ? "msg-admin" : "msg-user" %>">
        <div class="msg-sender">
          <%= msg.getSenderName() %>
          <span class="role-tag <%= isAdmin ? "tag-admin" : "tag-user" %>"><%= msg.getSenderRole() %></span>
        </div>
        <div class="msg-text"><%= msg.getMessage() %></div>
        <div class="msg-time"><%= msg.getCreatedAt() %></div>
      </div>
      <% } } %>
    </div>

    <!-- Reply Box -->
    <% if (!isResolved) { %>
    <div class="glass-panel reply-box animate-fade-in">
      <h3 style="font-size: 1rem; margin-bottom: 1rem;">Reply</h3>
      <form action="ClaimThread" method="POST">
        <input type="hidden" name="claimId" value="<%= claim.getId() %>">
        <textarea name="message" class="form-control" placeholder="Type your message..." required></textarea>
        <button type="submit" class="btn-primary" style="width: auto; padding: 0.65rem 1.5rem;">Send Message</button>
      </form>
    </div>
    <% } else { %>
    <div class="glass-panel resolved-notice animate-fade-in">
      This claim has been <strong><%= claim.getStatus() %></strong>. The conversation is closed.
    </div>
    <% } %>

    <!-- Admin Actions -->
    <% if ("admin".equals(userRole) && "pending".equals(claim.getStatus())) { %>
    <div style="display: flex; gap: 1rem; margin-top: 1.5rem;" class="animate-fade-in">
      <form action="AdminServlet" method="POST" style="flex: 1;">
        <input type="hidden" name="action" value="approveClaim">
        <input type="hidden" name="id" value="<%= claim.getId() %>">
        <button type="submit" class="btn-primary" style="background: linear-gradient(135deg, #10b981, #059669); width: 100%;">✓ Approve Claim</button>
      </form>
      <form action="AdminServlet" method="POST" style="flex: 1;">
        <input type="hidden" name="action" value="rejectClaim">
        <input type="hidden" name="id" value="<%= claim.getId() %>">
        <button type="submit" class="btn-primary" style="background: linear-gradient(135deg, #ef4444, #dc2626); width: 100%;">✕ Reject Claim</button>
      </form>
    </div>
    <% } %>
  </main>
</body>
</html>
