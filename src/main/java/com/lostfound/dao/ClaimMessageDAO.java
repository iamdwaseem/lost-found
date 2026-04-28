package com.lostfound.dao;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import com.lostfound.model.ClaimMessage;

public class ClaimMessageDAO {

    private SessionFactory factory;

    public ClaimMessageDAO() {
        this.factory = ItemDAO.getFactory();
    }

    public void saveMessage(ClaimMessage msg) {
        Transaction tx = null;
        try (Session session = factory.openSession()) {
            tx = session.beginTransaction();
            session.save(msg);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    public List<ClaimMessage> getMessagesByClaimId(int claimId) {
        try (Session session = factory.openSession()) {
            return session.createQuery(
                "from ClaimMessage where claimId = :cid order by id asc", ClaimMessage.class)
                .setParameter("cid", claimId)
                .list();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
