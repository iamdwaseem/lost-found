package com.lostfound.dao;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import com.lostfound.model.Claim;

public class ClaimDAO {

    private SessionFactory factory;

    public ClaimDAO() {
        this.factory = ItemDAO.getFactory();
    }

    /**
     * Saves a new claim to the database.
     */
    public void saveClaim(Claim claim) {
        Transaction transaction = null;
        try (Session session = factory.openSession()) {
            transaction = session.beginTransaction();
            session.save(claim);
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Get all claims (for admin).
     */
    public List<Claim> getAllClaims() {
        try (Session session = factory.openSession()) {
            return session.createQuery("from Claim order by id desc", Claim.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Get only pending claims (for admin).
     */
    public List<Claim> getPendingClaims() {
        try (Session session = factory.openSession()) {
            return session.createQuery("from Claim where status = 'pending' order by id desc", Claim.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Get claims for a specific item.
     */
    public List<Claim> getClaimsByItemId(int itemId) {
        try (Session session = factory.openSession()) {
            return session.createQuery("from Claim where itemId = :itemId", Claim.class)
                    .setParameter("itemId", itemId)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Get a claim by its ID.
     */
    public Claim getClaimById(int id) {
        try (Session session = factory.openSession()) {
            return session.get(Claim.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Update claim status (approve/reject).
     */
    public void updateClaimStatus(int id, String status) {
        Transaction transaction = null;
        try (Session session = factory.openSession()) {
            transaction = session.beginTransaction();
            Claim claim = session.get(Claim.class, id);
            if (claim != null) {
                claim.setStatus(status);
                session.update(claim);
            }
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    /**
     * Get all claims filed by a specific user email.
     */
    public List<Claim> getClaimsByEmail(String email) {
        try (Session session = factory.openSession()) {
            return session.createQuery(
                "from Claim where claimantEmail = :email order by id desc", Claim.class)
                .setParameter("email", email)
                .list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Get a user's previous claim for a specific item, if any.
     */
    public Claim getPreviousClaim(int itemId, String email) {
        try (Session session = factory.openSession()) {
            return session.createQuery(
                "from Claim where itemId = :itemId and claimantEmail = :email", Claim.class)
                .setParameter("itemId", itemId)
                .setParameter("email", email)
                .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
