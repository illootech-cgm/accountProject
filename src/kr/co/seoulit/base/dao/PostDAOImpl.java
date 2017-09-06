package kr.co.seoulit.base.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import kr.co.seoulit.base.to.PostBean;
import kr.co.seoulit.common.daoexception.DataAccessException;
import kr.co.seoulit.common.dstm.DataSourceTransactionManager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class PostDAOImpl implements PostDAO{
	protected final Log logger = LogFactory.getLog(getClass());
	private DataSourceTransactionManager dstm;

	public void setDstm(DataSourceTransactionManager dstm) {
		this.dstm = dstm;
	}

	public ArrayList<PostBean> searchPostList(String dong) {
		if (logger.isDebugEnabled()) {
			logger.debug("Start PostDAOImpl-Method~!");
		}

		ArrayList<PostBean> postList = new ArrayList<PostBean>();
		Connection con = dstm.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("SELECT sido, gugun, dong, ri, zip_no FROM S_ZIPCODE WHERE dong LIKE '%"
					+ dong + "%'");
			pstmt = con.prepareStatement(query.toString());
			rs = pstmt.executeQuery();
			while (rs.next()) {
				PostBean postBean = new PostBean();
				postBean.setDong(rs.getString("dong"));
				postBean.setRi(rs.getString("ri"));
				postBean.setSido(rs.getString("sido"));
				postBean.setSigungu(rs.getString("gugun"));
				postBean.setZipno(rs.getString("zip_no"));
				postList.add(postBean);
			}
			if (logger.isDebugEnabled()) {
				logger.debug("End PostDAOImpl-Method~!");
			}
			return postList;
		} catch (SQLException sqle) {
			throw new DataAccessException("데이터접근 실패!");
		} finally {
			dstm.close(pstmt, rs);
		}
	}

	public ArrayList<PostBean> searchSidoList() {
		if (logger.isDebugEnabled()) {
			logger.debug("Start PostDAOImpl-Method~!");
		}

		ArrayList<PostBean> postSidoList = new ArrayList<PostBean>();
		Connection con = dstm.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("SELECT * FROM post_si order by value");
			pstmt = con.prepareStatement(query.toString());
			rs = pstmt.executeQuery();
			while (rs.next()) {
				PostBean postBean = new PostBean();
				postBean.setSido(rs.getString("code"));
				postBean.setSidoname(rs.getString("value"));
				postSidoList.add(postBean);
			}
			if (logger.isDebugEnabled()) {
				logger.debug("End PostDAOImpl-Method~!");
			}
			return postSidoList;
		} catch (SQLException sqle) {
			throw new DataAccessException("데이터접근 실패!");
		} finally {
			dstm.close(pstmt, rs);
		}
	}

	public ArrayList<PostBean> searchSigunguList(String sido) {
		if (logger.isDebugEnabled()) {
			logger.debug("Start PostDAOImpl-Method~!");
		}
		ArrayList<PostBean> postSigunguList = new ArrayList<PostBean>();
		Connection con = dstm.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("SELECT value FROM post_sigungu where code=? group by value order by value");
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, sido);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				PostBean postBean = new PostBean();
				postBean.setSidoname(rs.getString("value"));
				postSigunguList.add(postBean);
			}
			if (logger.isDebugEnabled()) {
				logger.debug("End PostDAOImpl-Method~!");
			}
			return postSigunguList;
		} catch (SQLException sqle) {
			throw new DataAccessException("데이터접근 실패!");
		} finally {
			dstm.close(pstmt, rs);
		}
	}

	public ArrayList<PostBean> searchRoadList(String sido, String sigungu,
			String roadname) {
		if (logger.isDebugEnabled()) {
			logger.debug("Start PostDAOImpl-Method~!");
		}

		ArrayList<PostBean> postRoadList = new ArrayList<PostBean>();
		Connection con = dstm.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			String sidoTable = "road_post_" + sido;
			StringBuffer query = new StringBuffer();
			query.append("SELECT zipcode, road_name, building_code1, building_code2 ");
			query.append(" FROM " + sidoTable + " where sigungu='" + sigungu
					+ "' and road_name like '%" + roadname + "%'");
			pstmt = con.prepareStatement(query.toString());
			rs = pstmt.executeQuery();
			while (rs.next()) {
				PostBean postBean = new PostBean();
				postBean.setZipno(rs.getString("zipcode"));
				postBean.setRoadname(rs.getString("road_name"));
				postBean.setBuildingcode1(rs.getString("building_code1"));
				postBean.setBuildingcode2(rs.getString("building_code2"));

				postRoadList.add(postBean);
			}
			if (logger.isDebugEnabled()) {
				logger.debug("End PostDAOImpl-Method~!");
			}
			return postRoadList;
		} catch (SQLException sqle) {
			throw new DataAccessException("데이터접근 실패!");
		} finally {
			dstm.close(pstmt, rs);
		}
	}
}
