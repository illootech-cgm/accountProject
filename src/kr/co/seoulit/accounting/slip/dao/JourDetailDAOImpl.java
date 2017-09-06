package kr.co.seoulit.accounting.slip.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import kr.co.seoulit.accounting.slip.to.JourBean;
import kr.co.seoulit.accounting.slip.to.JourDetailBean;
import kr.co.seoulit.common.daoexception.DataAccessException;
import kr.co.seoulit.common.dstm.DataSourceTransactionManager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class JourDetailDAOImpl implements JourDetailDAO {

	protected final Log logger = LogFactory.getLog(getClass());
	private DataSourceTransactionManager dstm;

	public void setDstm(DataSourceTransactionManager dstm) {
		this.dstm = dstm;
	}
	public ArrayList<JourDetailBean> searchDetail(JourBean bean){
		if (logger.isDebugEnabled()) {
			logger.debug("�а��� ������� ��ǥ:" + bean.getSlipCode() +"//�а�:"+bean.getJournalItemCode());
		}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			ArrayList<JourDetailBean> list = new ArrayList<JourDetailBean>();
			StringBuffer query = new StringBuffer();
			query.append("select * from JOURNAL_detail where slip_code=? and JOURNAL_ITEM_CODE=?");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, bean.getSlipCode());
			pstmt.setString(2, bean.getJournalItemCode());
			rs = pstmt.executeQuery();
			while(rs.next()){
				JourDetailBean detailjourbean = new JourDetailBean();
				detailjourbean.setSlipCode(rs.getString(1));
				detailjourbean.setValue(rs.getString(2));
				detailjourbean.setJournalItemCode(rs.getString(3));
				detailjourbean.setItem(rs.getString(4));
				detailjourbean.setAccountDetailItemCode(rs.getString(5));
				list.add(detailjourbean);
			}
			if (logger.isDebugEnabled()) {
				logger.debug("�а��� ���� �� :" + list);
			}
			return list;
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());

		} finally {
			dstm.close(pstmt, rs);

		}
		
		
	}
	public void insertDetailJour(JourDetailBean bean) {
		if (logger.isDebugEnabled()) {
			logger.debug("�а��� ����" + bean);
		}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("insert into JOURNAL_DETAIL values(?,?,?,?,?)");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, bean.getSlipCode());
			pstmt.setString(2, bean.getValue());
			pstmt.setString(3, bean.getJournalItemCode());
			pstmt.setString(4, bean.getItem());
			pstmt.setString(5, bean.getAccountDetailItemCode());
			
			int rst = pstmt.executeUpdate();
			if (logger.isDebugEnabled()) {
				logger.debug("�а��� ���� �� :" + rst);
			}
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());

		} finally {
			dstm.close(pstmt, rs);

		}

	}

	public void deleteDetailJour(JourDetailBean bean) {
		if (logger.isDebugEnabled()) {
			logger.debug("�а��� ����" + bean);
		}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("delete from JOURNAL_detail where slip_code = ? and journal_item_code=?");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, bean.getSlipCode());
			pstmt.setString(2, bean.getJournalItemCode());
			int rst = pstmt.executeUpdate();
			if (logger.isDebugEnabled()) {
				logger.debug("�а��� ���� �� : " + rst);
			}
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());

		} finally {
			dstm.close(pstmt, rs);

		}

	}

	public void updateDetailJour(JourDetailBean bean) {
		if (logger.isDebugEnabled()) {
			logger.debug("�а��� ����" + bean);
		}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("update JOURNAL_detail set value=? where slip_code=? and journal_item_code=? and account_detail_item_code=?");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, bean.getValue());
			pstmt.setString(2, bean.getSlipCode());
			pstmt.setString(3, bean.getJournalItemCode());
			pstmt.setString(4, bean.getAccountDetailItemCode());
			int rst = pstmt.executeUpdate();
			if (logger.isDebugEnabled()) {
				logger.debug("�а��� ���� �� :" + rst);
			}
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());
		} finally {
			dstm.close(pstmt, rs);
		}

	}

}