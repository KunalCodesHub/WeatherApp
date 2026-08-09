package com.weather.Implement;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import com.weather.DAO.WeatherSearchDAO;
import com.weather.model.WeatherSearch;
import com.weather.util.HibernateUtil;

public class WeatherSearchDAOImpl implements WeatherSearchDAO{

	@Override
	public void saveSearch(WeatherSearch ws) {
		Transaction tx = null;
		try(Session session = HibernateUtil.getSessionFactory().openSession()) {
			tx = session.beginTransaction();
			session.persist(ws);
			tx.commit();
		} catch(Exception ex) {
			if (tx != null) tx.rollback();
			throw new RuntimeException("Failed to save search: " + ex.getMessage() , ex);	
		}
		
	}
	
	@Override
	public List<WeatherSearch> getSearchHistoryPaginated(int userId,int page, int pageSize) {
		
		List<WeatherSearch> historyList = null;
		
		int offset = (page - 1) * pageSize;
		
		String hql = "FROM WeatherSearch ws " +
					 "WHERE ws.user.id = :userId " +
					 "ORDER BY ws.searchDate DESC";
		
		try(Session session = HibernateUtil.getSessionFactory().openSession()) {
			historyList = session.createQuery(hql, WeatherSearch.class)
						  .setParameter("userId", userId)
						  .setFirstResult(offset)
						  .setMaxResults(pageSize)
						  .getResultList();
		} catch(Exception ex) {
			ex.printStackTrace();
	        throw new RuntimeException("Error fetching paginated history: " + ex.getMessage());
		}
		return historyList;
	}
	
	@Override
	public int getTotalSearchCount(int userId) {
		Long count = 0L;
		
		String hql = "SELECT COUNT(ws) FROM WeatherSearch ws " +
					 "WHERE ws.user.id = :userId";
		
		try(Session session = HibernateUtil.getSessionFactory().openSession()) {
			count = session.createQuery(hql, Long.class)
					.setParameter("userId", userId)
					.getSingleResult();
		} catch(Exception ex) {
			ex.printStackTrace();
			throw new RuntimeException("Error counting search history: " + ex.getMessage());
		}
		
		return count.intValue();
	}

	@Override
	public List<WeatherSearch> getSearchesByUser(int userId) {
		String hql = "FROM WeatherSearch WHERE user.id = :userId ORDER BY searchDate DESC";
		try(Session session = HibernateUtil.getSessionFactory().openSession()) {
			return session.createQuery(hql,WeatherSearch.class).setParameter("userId", userId).list();
		} catch(Exception ex) {
			throw new RuntimeException("Fails to fetch search list." + ex.getMessage(), ex);
		}
	}

	@Override
	public List<WeatherSearch> getRecentSearchesByUser(int userId, int limit) {
		String hql = "FROM WeatherSearch WHERE user.id = :userId ORDER BY searchDate DESC";
		try(Session session = HibernateUtil.getSessionFactory().openSession()) {
			Query<WeatherSearch> query = session.createQuery(hql, WeatherSearch.class);
			query.setParameter("userId", userId);
			query.setMaxResults(limit);
			return query.list();
		} catch(Exception ex) {
			throw new RuntimeException("Fails to fetch recent search list." + ex.getMessage(), ex);
		}
	}

	@Override
	public void deleteSearchesByUser(int userId) {
		String hql = "DELETE FROM WeatherSearch WHERE user.id = :userId";
		Transaction tx = null;
		try(Session session = HibernateUtil.getSessionFactory().openSession()) {
			tx = session.beginTransaction();
			session.createMutationQuery(hql).setParameter("userId", userId).executeUpdate();
			tx.commit();
			
		} catch(Exception ex) {
			if (tx != null) tx.rollback();
			throw new RuntimeException("Fails to delete searches for user: " + ex.getMessage(), ex);
		}
		
	}
	
	@Override
	public String getMostSearchedCity(int userId) {

	    String city = "N/A";

	    // HQL — group by city, order by count desc, take top 1
	    String hql = "SELECT ws.cityName FROM WeatherSearch ws " +
	                 "WHERE ws.user.id = :userId " +
	                 "GROUP BY ws.cityName " +
	                 "ORDER BY COUNT(ws.cityName) DESC";

	    try (Session session = HibernateUtil.getSessionFactory().openSession()) {

	        List<String> result = session.createQuery(hql, String.class)
	                                     .setParameter("userId", userId)
	                                     .setMaxResults(1)
	                                     .getResultList();

	        if (!result.isEmpty()) {
	            city = result.get(0);
	        }

	    } catch (Exception ex) {
	        ex.printStackTrace();
	    }

	    return city;
	}


	@Override
	public String getMostCommonCondition(int userId) {

	    String condition = "N/A";

	    String hql = "SELECT ws.weatherCondition FROM WeatherSearch ws " +
	                 "WHERE ws.user.id = :userId " +
	                 "GROUP BY ws.weatherCondition " +
	                 "ORDER BY COUNT(ws.weatherCondition) DESC";

	    try (Session session = HibernateUtil.getSessionFactory().openSession()) {

	        List<String> result = session.createQuery(hql, String.class)
	                                     .setParameter("userId", userId)
	                                     .setMaxResults(1)
	                                     .getResultList();

	        if (!result.isEmpty()) {
	            condition = result.get(0);
	        }

	    } catch (Exception ex) {
	        ex.printStackTrace();
	    }

	    return condition;
	}

}
