package com.lostfound.dao;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import com.lostfound.model.User;

public class UserDAO {

    private SessionFactory factory;

    public UserDAO() {
        this.factory = ItemDAO.getFactory();
    }

    /**
     * Register a new user. Returns true on success, false if email already exists.
     */
    public boolean registerUser(User user) {
        // Check if email already exists
        if (getUserByEmail(user.getEmail()) != null) {
            return false;
        }
        Transaction transaction = null;
        try (Session session = factory.openSession()) {
            transaction = session.beginTransaction();
            session.save(user);
            transaction.commit();
            return true;
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Authenticate a user by email and password.
     * Returns the User object if credentials are valid, null otherwise.
     */
    public User authenticate(String email, String password) {
        try (Session session = factory.openSession()) {
            List<User> users = session.createQuery(
                "from User where email = :email and password = :password", User.class)
                .setParameter("email", email)
                .setParameter("password", password)
                .list();
            return users.isEmpty() ? null : users.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Get a user by email.
     */
    public User getUserByEmail(String email) {
        try (Session session = factory.openSession()) {
            List<User> users = session.createQuery(
                "from User where email = :email", User.class)
                .setParameter("email", email)
                .list();
            return users.isEmpty() ? null : users.get(0);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Seed a default admin account if one doesn't exist yet.
     */
    public void seedAdmin() {
        if (getUserByEmail("admin@findit.com") == null) {
            User admin = new User("Administrator", "admin@findit.com", "admin123", "admin");
            registerUser(admin);
            System.out.println("[SEED] Default admin account created: admin@findit.com / admin123");
        }
    }
}
