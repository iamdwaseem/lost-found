# 🔍 FindIt — Lost & Found Portal

A full-stack Java web application for reporting, browsing, and claiming lost & found items. Built with **Servlets**, **JSP**, **Hibernate ORM**, **MySQL**, and vanilla **HTML/CSS/JS**.

---

## 📸 Features

- **🔐 Role-Based Authentication** — Users register/login with email & password. Admins get elevated access.
- **📋 Item Dashboard** — Browse all active lost & found items in a responsive card grid with category filters.
- **📝 Report Items** — Submit a lost or found item with image upload (`multipart/form-data`).
- **🔎 Item Detail View** — Full detail page for each item with reporter info.
- **✋ Claim System** — Users can file ownership claims with proof; admins review and approve/reject.
- **🛡️ Admin Panel** — Dashboard with stats, pending claims management, and item moderation (resolve/delete).
- **📤 Image Upload** — Files saved to server with UUID-based naming to prevent collisions.

---

## 🏗️ Architecture

```
Browser → HTML + CSS + JS → Servlet (Controller) → Hibernate ORM → MySQL
                                    ↓
                              JSP (Dynamic View)
```

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Structure** | HTML5 | Page layout and forms |
| **Styling** | CSS3 | Glassmorphism UI, animations, responsive design |
| **Validation** | Vanilla JavaScript | Client-side form validation |
| **Controller** | Java Servlets | Request handling, file uploads, routing |
| **View** | JSP | Dynamic HTML generation |
| **ORM** | Hibernate 5.6 | Object-relational mapping |
| **Database** | MySQL 8 | Persistent data storage |
| **Server** | Apache Tomcat 7 | Application server |

---

## 📁 Project Structure

```
lost-and-found/
├── pom.xml                          # Maven config & dependencies
├── database.sql                     # MySQL schema
├── src/
│   ├── main/
│   │   ├── java/com/lostfound/
│   │   │   ├── model/
│   │   │   │   ├── Item.java        # Item entity (JPA)
│   │   │   │   ├── Claim.java       # Claim entity (JPA)
│   │   │   │   └── User.java        # User entity with role field
│   │   │   ├── dao/
│   │   │   │   ├── ItemDAO.java     # Item CRUD + HQL queries
│   │   │   │   ├── ClaimDAO.java    # Claim CRUD operations
│   │   │   │   └── UserDAO.java     # Auth & user management
│   │   │   └── servlet/
│   │   │       ├── LoginServlet.java
│   │   │       ├── RegisterServlet.java
│   │   │       ├── LogoutServlet.java
│   │   │       ├── ReportItemServlet.java
│   │   │       ├── ItemDetailServlet.java
│   │   │       ├── ClaimServlet.java
│   │   │       ├── AdminServlet.java
│   │   │       └── AdminLoginServlet.java
│   │   ├── resources/
│   │   │   └── hibernate.cfg.xml    # Hibernate + MySQL config
│   │   └── webapp/
│   │       ├── WEB-INF/web.xml      # Servlet mappings
│   │       ├── login.html
│   │       ├── register.html
│   │       ├── submit.html          # Item report form
│   │       ├── claim.html           # Claim submission form
│   │       ├── dashboard.jsp        # Dynamic item grid
│   │       ├── item-detail.jsp      # Single item view
│   │       ├── admin.jsp            # Admin panel
│   │       ├── result.jsp           # Success confirmation
│   │       ├── css/
│   │       │   ├── global.css
│   │       │   ├── auth.css
│   │       │   ├── dashboard.css
│   │       │   ├── form.css
│   │       │   └── admin.css
│   │       └── js/
│   │           └── validation.js
```

---

## 🚀 Getting Started

### Prerequisites
- **Java JDK 8+**
- **Apache Maven 3.x**
- **MySQL 8** running on `127.0.0.1:3306`

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/iamdwaseem/lost-found.git
   cd lost-found
   ```

2. **Configure the database**  
   Edit `src/main/resources/hibernate.cfg.xml` and set your MySQL credentials:
   ```xml
   <property name="connection.url">jdbc:mysql://127.0.0.1:3306/YOUR_DB?createDatabaseIfNotExist=true&amp;useSSL=false</property>
   <property name="connection.username">root</property>
   <property name="connection.password">YOUR_PASSWORD</property>
   ```
   > Hibernate will auto-create all tables on first run (`hbm2ddl.auto=update`).

3. **Run the application**
   ```bash
   mvn clean tomcat7:run
   ```

4. **Open in browser**
   ```
   http://localhost:8080/login.html
   ```

### Default Admin Account
On first startup, the system auto-seeds an admin:
| Email | Password |
|-------|----------|
| `admin@findit.com` | `admin123` |

---

## 🔄 Workflow

### Reporting a Found Item
1. User logs in → clicks **Report Item**
2. Fills out the form with item details + image → submits
3. Item appears on the public dashboard with status `open`

### Claiming an Item
1. User browses dashboard → clicks **View Details** on an item
2. Clicks **Claim This Item** → provides name, email, and proof of ownership
3. Item status changes to `claimed`

### Admin Mediation
1. Admin logs in → sees pending claims in the **Admin Panel**
2. Reviews the proof → clicks **Approve** or **Reject**
3. On approval → item status becomes `resolved` and is removed from the public dashboard
4. On rejection → item goes back to `open` if no other pending claims exist

---

## 🛠️ Tech Stack

| Technology | Version | Purpose |
|-----------|---------|---------|
| Java | 8+ | Backend language |
| Servlet API | 3.0 | HTTP request processing |
| JSP | 2.3 | Dynamic page rendering |
| Hibernate | 5.6.15 | ORM framework |
| MySQL | 8.x | Relational database |
| Maven | 3.x | Build & dependency management |
| Tomcat | 7.x | Embedded application server |
| HTML/CSS/JS | - | Frontend (vanilla, no frameworks) |

---

## 📄 License

This project is for educational purposes (Web Technology Lab).
