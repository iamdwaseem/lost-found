package com.lostfound.dao;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import com.lostfound.model.Item;
import com.lostfound.model.Claim;

import com.lostfound.model.User;

public class ItemDAO {

    private static SessionFactory factory;

    static {
        try {
            factory = new Configuration()
                .configure("hibernate.cfg.xml")
                .addAnnotatedClass(Item.class)
                .addAnnotatedClass(Claim.class)
                .addAnnotatedClass(User.class)
                .addAnnotatedClass(com.lostfound.model.ClaimMessage.class)
                .buildSessionFactory();

            // Seed admin account on first startup
            seedDefaultAdmin();
        } catch (Throwable ex) {
            System.err.println("Failed to create sessionFactory object." + ex);
            throw new ExceptionInInitializerError(ex);
        }
    }

    private static void seedDefaultAdmin() {
        try (Session session = factory.openSession()) {
            List<User> admins = session.createQuery("from User where email = 'admin@findit.com'", User.class).list();
            if (admins.isEmpty()) {
                Transaction tx = session.beginTransaction();
                User admin = new User("Administrator", "admin@findit.com", "admin123", "admin");
                session.save(admin);
                tx.commit();
                System.out.println("[SEED] Default admin created: admin@findit.com / admin123");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static SessionFactory getFactory() {
        return factory;
    }

    /**
     * Inserts a new Item record into the database.
     */
    public void saveItem(Item item) {
        Transaction transaction = null;
        try (Session session = factory.openSession()) {
            transaction = session.beginTransaction();
            session.save(item);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Retrieves all items (for admin view).
     */
    public List<Item> getAllItems() {
        try (Session session = factory.openSession()) {
            return session.createQuery("from Item order by id desc", Item.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Retrieves only open/claimed items for the public dashboard.
     */
    public List<Item> getOpenItems() {
        try (Session session = factory.openSession()) {
            return session.createQuery(
                "from Item where status = 'open' or status = 'claimed' or status is null order by id desc", Item.class
            ).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Retrieves a single item by its ID.
     */
    public Item getItemById(int id) {
        try (Session session = factory.openSession()) {
            return session.get(Item.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Updates the status of an item.
     */
    public void updateItemStatus(int id, String status) {
        Transaction transaction = null;
        try (Session session = factory.openSession()) {
            transaction = session.beginTransaction();
            Item item = session.get(Item.class, id);
            if (item != null) {
                item.setStatus(status);
                session.update(item);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Deletes an item by its ID.
     */
    public void deleteItem(int id) {
        Transaction transaction = null;
        try (Session session = factory.openSession()) {
            transaction = session.beginTransaction();
            Item item = session.get(Item.class, id);
            if (item != null) {
                session.delete(item);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }
}
