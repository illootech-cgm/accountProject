package kr.co.seoulit.common.dstm;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.sql.DataSource;

import kr.co.seoulit.common.daoexception.DataAccessException;

public class DataSourceTransactionManager {
	private static DataSource dataSource;
	private ThreadLocal<Connection> threadLocal = new ThreadLocal<Connection>();

	public void setDataSource(DataSource dataSource) {
		DataSourceTransactionManager.dataSource = dataSource;
	}

	public Connection getConnection() {
		Connection connection = (Connection) threadLocal.get();
		try {
			if (connection == null) {
				connection = dataSource.getConnection();
				threadLocal.set(connection);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException(e.getMessage(), e);
		}
		return connection;
	}

	public void closeConnection() {
		Connection conn = (Connection) threadLocal.get();
		threadLocal.set(null);
		try {
			System.out.println("µðºñ¿¬°á Á¾·á");
			if (conn != null)
				conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException(e.getMessage(), e);
		}
	}

	public void beginTransaction() {
		try {
			System.out.println("¿ÀÅäÄ¿¹Ô ²û");
			getConnection().setAutoCommit(false);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException(e.getMessage(), e);
		}
	}

	public void rollbackTransaction() {
		try {
			System.out.println("·Ñ¹é ‰çÀ½ ..................");
			getConnection().rollback();
			closeConnection();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException(e.getMessage(), e);
		}
	}

	public void commitTransaction() {
		try {
			//System.out.println("Ä¿¹Ô¿¡¼­ ¿ÀÅäÄ¿¹Ô²û");
			//getConnection().setAutoCommit(false);
			
			getConnection().commit();
			closeConnection();
			System.out.println("Ä¿¹Ô½ÇÇà");
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException(e.getMessage(), e);
		}
	}

	public void close(PreparedStatement pstmt) {
		try {
			if (pstmt != null)
				pstmt.close();
		} catch (SQLException e) {
			throw new DataAccessException(e.getMessage(), e);
		}
	}

	public void close(PreparedStatement pstmt, ResultSet rs) {
		try {
			if (pstmt != null)
				pstmt.close();
			if (rs != null)
				rs.close();
		} catch (SQLException e) {
			throw new DataAccessException(e.getMessage(), e);
		}
	}

	public void close(Connection conn) {
		closeConnection();
	}

	public void close(Connection conn, PreparedStatement ps) {
		try {
			closeConnection();
			if (ps != null)
				ps.close();
		} catch (SQLException e) {
			throw new DataAccessException(e.getMessage(), e);
		}
	}

	public void close(Connection conn, PreparedStatement ps, ResultSet rs) {
		try {
			closeConnection();
			if (ps != null)
				ps.close();
			if (rs != null)
				rs.close();
		} catch (SQLException e) {
			throw new DataAccessException(e.getMessage(), e);
		}
	}

	public void close(Connection conn, Statement st, ResultSet rs) {
		try {
			closeConnection();
			if (st != null)
				st.close();
			if (rs != null)
				rs.close();
		} catch (SQLException e) {
			throw new DataAccessException(e.getMessage(), e);
		}
	}
}