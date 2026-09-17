<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map, DAO.DaoMessage" %>
<%
    String adminUser = (String) session.getAttribute("un");
    if (adminUser == null) adminUser = (String) session.getAttribute("username");
    if (adminUser == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Action handling
    String markReadId = request.getParameter("markReadId");
    if (markReadId != null && !markReadId.isBlank()) {
        DaoMessage.markAsRead(Integer.parseInt(markReadId));
        response.sendRedirect("messages.jsp?msg=Message+marked+as+read.");
        return;
    }

    String markUnreadId = request.getParameter("markUnreadId");
    if (markUnreadId != null && !markUnreadId.isBlank()) {
        DaoMessage.markAsUnread(Integer.parseInt(markUnreadId));
        response.sendRedirect("messages.jsp?msg=Message+marked+as+unread.");
        return;
    }

    String deleteMsgId = request.getParameter("deleteMsgId");
    if (deleteMsgId != null && !deleteMsgId.isBlank()) {
        DaoMessage.deleteMessage(Integer.parseInt(deleteMsgId));
        response.sendRedirect("messages.jsp?msg=Message+deleted.");
        return;
    }

    String filter = request.getParameter("filter") != null ? request.getParameter("filter").trim() : "";
    List<Map<String, Object>> messages = DaoMessage.getAllMessages();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inquiries Inbox - Elevate Workforce Admin</title>
    
    <!-- Google Fonts & Bootstrap -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    
    <!-- Modern Admin Stylesheet -->
    <link rel="stylesheet" href="admin-modern.css">
</head>
<body>
    <div class="admin-wrapper">
        <jsp:include page="admin-sidebar.jsp" />

        <div class="admin-main">
            <jsp:include page="admin-topbar.jsp" />

            <main class="admin-content">
                <!-- Page Title -->
                <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
                    <div>
                        <h2 class="fw-bold mb-1">Inquiries & Contact Inbox</h2>
                        <p class="text-muted mb-0 small">Direct communication submissions received from the public Contact page.</p>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <button onclick="exportTableToCSV('msgTable', 'contact_inquiries.csv')" class="btn btn-outline-secondary rounded-pill px-3 py-2 fw-semibold btn-sm">
                            <i class="bi bi-download me-1"></i> Export Inquiries CSV
                        </button>
                    </div>
                </div>

                <!-- Messages -->
                <%
                    String msg = request.getParameter("msg");
                    if (msg != null && !msg.isBlank()) {
                %>
                    <div class="alert alert-success alert-dismissible fade show rounded-4 small mb-4" role="alert">
                        <i class="bi bi-check-circle-fill me-1"></i> <%= msg %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <!-- Filter Toolbar -->
                <div class="adm-card mb-4 p-3">
                    <div class="row g-3 align-items-center justify-content-between">
                        <div class="col-lg-5 col-md-12">
                            <div class="d-flex gap-2">
                                <a href="messages.jsp" class="btn btn-sm rounded-pill px-3 <%= filter.isEmpty() ? "btn-primary" : "btn-outline-secondary" %>">
                                    All Messages (<%= messages.size() %>)
                                </a>
                                <a href="messages.jsp?filter=Unread" class="btn btn-sm rounded-pill px-3 <%= "Unread".equalsIgnoreCase(filter) ? "btn-danger" : "btn-outline-secondary" %>">
                                    Unread
                                </a>
                                <a href="messages.jsp?filter=Read" class="btn btn-sm rounded-pill px-3 <%= "Read".equalsIgnoreCase(filter) ? "btn-success" : "btn-outline-secondary" %>">
                                    Read
                                </a>
                            </div>
                        </div>
                        <div class="col-lg-5 col-md-12">
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-search"></i></span>
                                <input type="text" id="msgSearchInput" class="form-control border-start-0" placeholder="Search by sender name, email or message text...">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Messages Table -->
                <div class="table-modern-wrapper">
                    <div class="table-responsive">
                        <table id="msgTable" class="table-modern">
                            <thead>
                                <tr>
                                    <th>Status</th>
                                    <th>Sender</th>
                                    <th>Contact Info</th>
                                    <th>Method</th>
                                    <th>Message Preview</th>
                                    <th>Date</th>
                                    <th class="text-end no-export">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    boolean hasMsgs = false;
                                    for (Map<String, Object> m : messages) {
                                        String mStatus = (String) m.get("status");
                                        if (!filter.isEmpty() && !filter.equalsIgnoreCase(mStatus)) {
                                            continue;
                                        }
                                        hasMsgs = true;
                                        int mId = (Integer) m.get("id");
                                        String mName = (String) m.get("name");
                                        String mEmail = (String) m.get("email");
                                        String mPhone = (String) m.get("phone");
                                        String mBody = (String) m.get("message");
                                        String mMethod = (String) m.get("contact_method");
                                        String mDate = String.valueOf(m.get("created_at"));
                                        boolean isUnread = "Unread".equalsIgnoreCase(mStatus);
                                %>
                                <tr class="<%= isUnread ? "table-active fw-semibold" : "" %>">
                                    <td>
                                        <% if (isUnread) { %>
                                            <span class="badge bg-danger rounded-pill px-2 py-1 small">New</span>
                                        <% } else { %>
                                            <span class="badge bg-light text-muted border rounded-pill px-2 py-1 small">Read</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <div class="fw-bold"><%= mName %></div>
                                    </td>
                                    <td>
                                        <div><a href="mailto:<%= mEmail %>" class="text-decoration-none"><%= mEmail %></a></div>
                                        <% if (mPhone != null && !mPhone.isEmpty()) { %>
                                            <small class="text-muted"><%= mPhone %></small>
                                        <% } %>
                                    </td>
                                    <td>
                                        <span class="badge bg-secondary-subtle text-muted rounded-pill px-2"><%= mMethod %></span>
                                    </td>
                                    <td>
                                        <div class="text-truncate" style="max-width: 260px;" title="<%= mBody %>">
                                            <%= mBody %>
                                        </div>
                                    </td>
                                    <td>
                                        <small class="text-muted"><%= mDate %></small>
                                    </td>
                                    <td class="text-end no-export">
                                        <!-- View Modal Trigger -->
                                        <button class="btn btn-sm btn-outline-primary rounded-pill px-2 me-1" data-bs-toggle="modal" data-bs-target="#msgModal<%= mId %>" title="View Full Message">
                                            <i class="bi bi-eye"></i>
                                        </button>

                                        <!-- Direct Email Reply -->
                                        <a href="mailto:<%= mEmail %>?subject=Response%20from%20Elevate%20Workforce%20Solutions" class="btn btn-sm btn-outline-success rounded-pill px-2 me-1" title="Reply via Email">
                                            <i class="bi bi-reply-fill"></i>
                                        </a>

                                        <!-- Toggle Read / Unread -->
                                        <% if (isUnread) { %>
                                            <a href="messages.jsp?markReadId=<%= mId %>" class="btn btn-sm btn-outline-secondary rounded-pill px-2 me-1" title="Mark as Read">
                                                <i class="bi bi-check-lg"></i>
                                            </a>
                                        <% } else { %>
                                            <a href="messages.jsp?markUnreadId=<%= mId %>" class="btn btn-sm btn-outline-warning rounded-pill px-2 me-1" title="Mark as Unread">
                                                <i class="bi bi-envelope-slash"></i>
                                            </a>
                                        <% } %>

                                        <!-- Delete -->
                                        <a href="messages.jsp?deleteMsgId=<%= mId %>" class="btn btn-sm btn-outline-danger rounded-pill px-2" onclick="return confirm('Delete this inquiry?');" title="Delete Message">
                                            <i class="bi bi-trash"></i>
                                        </a>

                                        <!-- Message Detail Modal -->
                                        <div class="modal fade text-start" id="msgModal<%= mId %>" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title fw-bold">Inquiry from <%= mName %></h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <div class="d-flex justify-content-between text-muted small mb-3 border-bottom pb-2">
                                                            <span><strong>Email:</strong> <%= mEmail %></span>
                                                            <span><strong>Date:</strong> <%= mDate %></span>
                                                        </div>
                                                        <% if (mPhone != null && !mPhone.isEmpty()) { %>
                                                            <div class="text-muted small mb-2"><strong>Phone:</strong> <%= mPhone %></div>
                                                        <% } %>
                                                        <div class="text-muted small mb-3"><strong>Preferred Method:</strong> <%= mMethod %></div>
                                                        <div class="p-3 bg-light rounded-3 text-slate-800" style="white-space: pre-wrap; font-size: 0.95rem;">
                                                            <%= mBody %>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer justify-content-between">
                                                        <div>
                                                            <% if (isUnread) { %>
                                                                <a href="messages.jsp?markReadId=<%= mId %>" class="btn btn-sm btn-outline-secondary rounded-pill px-3">Mark Read</a>
                                                            <% } %>
                                                        </div>
                                                        <div class="d-flex gap-2">
                                                            <a href="mailto:<%= mEmail %>?subject=Response%20from%20Elevate%20Workforce%20Solutions" class="btn btn-sm btn-primary rounded-pill px-3">
                                                                <i class="bi bi-reply-fill me-1"></i> Send Reply Email
                                                            </a>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <%      }
                                    if (!hasMsgs) {
                                %>
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">No messages found in inbox.</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

            </main>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="admin-modern.js"></script>
    <script>
        setupTableSearch('msgSearchInput', 'msgTable');
    </script>
</body>
</html>
