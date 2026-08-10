package com.weather.Implement;

import java.util.List;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.weather.DAO.FavoriteCityDAO;
import com.weather.model.FavoriteCity;
import com.weather.model.WeatherSearch;
import com.weather.util.HibernateUtil;

public class FavoriteCityDAOImpl implements FavoriteCityDAO {

	@Override
	public void addFavorite(FavoriteCity fc) {
		Transaction tx = null;
		try(Session session = HibernateUtil.getSessionFactory().openSession()) {
			tx = session.beginTransaction();
			session.persist(fc);
			tx.commit();
		} catch (Exception e) {
			if (tx != null) tx.rollback();
			throw new RuntimeException("Failed to add favorite: " + e.getMessage(), e);
		}
		
	}

	@Override
	public void removeFavorite(int favoriteId) {
		Transaction tx = null;
		String hql = "DELETE FROM FavoriteCity fc WHERE fc.id = :favoriteId";
		try(Session session = HibernateUtil.getSessionFactory().openSession()) {
			tx = session.beginTransaction();
			session.createMutationQuery(hql)
					.setParameter("favoriteId", favoriteId)
					.executeUpdate();
			
			tx.commit();
		} catch (Exception ex) {
			if (tx != null) tx.rollback();
			throw new RuntimeException("Failed to remove favorite: " + ex.getMessage(), ex);
		}
	}

	@Override
	public List<FavoriteCity> getFavoritesByUserId(int userId) {
		String hql = "FROM FavoriteCity fc WHERE  fc.user.id = :userId ORDER BY fc.addedAt DESC";
		try(Session session = HibernateUtil.getSessionFactory().openSession()) {
			return session.createQuery(hql, FavoriteCity.class)
					.setParameter("userId", userId)
					.list();
					
		} catch (Exception ex) {
			throw new RuntimeException("Failed to retrieve favorites: " + ex.getMessage(), ex);
		}
	}

	@Override
	public boolean isFavorite(int userId, String cityName) {
		String hql = "SELECT COUNT(fc) FROM FavoriteCity fc "
					+"WHERE fc.user.id = :userId AND fc.cityName = :cityName";
		try(Session session = HibernateUtil.getSessionFactory().openSession()) {
			Long count = session.createQuery(hql, Long.class)
						.setParameter("userId", userId)
						.setParameter("cityName", cityName)
						.uniqueResult();
			return (count != null && count > 0);
		}catch (Exception ex) {
			throw new RuntimeException("Internal errror from isFavorite." + ex.getMessage(), ex);
		}
	}
	
	@Override
	public List<FavoriteCity> getFavoritesPaginated(int userId, int page, int pageSize) {
		List<FavoriteCity> favoriteList = null;
		
		int offset = (page - 1) * pageSize;
		
		String hql = "FROM  FavoriteCity fc " +
					 "WHERE fc.user.id = :userId " +
					 "ORDER BY fc.addedAt DESC";
		
		try(Session session = HibernateUtil.getSessionFactory().openSession()) {
			favoriteList = session.createQuery(hql, FavoriteCity.class)
						  .setParameter("userId", userId)
						  .setFirstResult(offset)
						  .setMaxResults(pageSize)
						  .getResultList();
		} catch(Exception ex) {
			ex.printStackTrace();
	        throw new RuntimeException("Error fetching paginated history: " + ex.getMessage());
		}
		return favoriteList;
	}
	
	@Override
	public int getTotalFavoritesCount(int userId) {
		Long count = 0L;
		
		String hql = "SELECT COUNT(fc) FROM FavoriteCity fc " +
					 "WHERE fc.user.id = :userId";
		
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
	public String getMostFavoritedCountry(int userId) {

	    String country = "N/A";

	    // HQL — group by country, order by count, take top 1
	    String hql = "SELECT fc.country FROM FavoriteCity fc " +
	                 "WHERE fc.user.id = :userId " +
	                 "GROUP BY fc.country " +
	                 "ORDER BY COUNT(fc.country) DESC";

	    try (Session session = HibernateUtil.getSessionFactory().openSession()) {

	        List<String> result = session.createQuery(hql, String.class)
	                                     .setParameter("userId", userId)
	                                     .setMaxResults(1)
	                                     .getResultList();

	        if (!result.isEmpty()) {
	            country = result.get(0);
	        }

	    } catch (Exception ex) {
	        ex.printStackTrace();
	    }

	    return country;
	}

}
