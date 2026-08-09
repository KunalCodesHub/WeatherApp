package com.weather.Implement;


import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import com.weather.DAO.UserDAO;
import com.weather.model.User;
import com.weather.util.HibernateUtil;



public class UserDAOImpl implements UserDAO {

	@Override
	public void saveUser(User user) {
		Transaction tx = null;
		try(Session session = HibernateUtil.getSessionFactory().openSession()) {
			tx = session.beginTransaction();
			session.persist(user);
			tx.commit();
		} catch(Exception ex) {
			if (tx != null) tx.rollback();
			throw new RuntimeException("Failed to save user: " + ex.getMessage() , ex);	
			
		} 
	}

	@Override
	public User findByUsername(String username) {
		String hql = "FROM User WHERE username = :username";
		try(Session session = HibernateUtil.getSessionFactory().openSession()) {
			Query<User> query = session.createQuery(hql,User.class).setParameter("username", username);
			return query.uniqueResultOptional().orElse(null);
		} catch(Exception ex) {
			throw new RuntimeException("Failed to find user: " + ex.getMessage() , ex);	
		}
	}

	@Override
	public User findByEmail(String email) {
		String hql = "FROM User WHERE email = :email";
		try(Session session = HibernateUtil.getSessionFactory().openSession()) {
			Query<User> query = session.createQuery(hql, User.class).setParameter("email", email);
			return query.uniqueResultOptional().orElse(null);
		} catch(Exception ex) {
			throw new RuntimeException("Failed to find user: " + ex.getMessage() , ex);	
		}
	}

	@Override
	public User findById(int id) {
		try(Session session = HibernateUtil.getSessionFactory().openSession()) {
			return session.find(User.class, id);
		} catch(Exception ex) {
			throw new RuntimeException("Failed to find user: " + ex.getMessage() , ex);
		}
	}
}
