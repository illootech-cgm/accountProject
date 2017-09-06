package kr.co.seoulit.accounting.slip.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import kr.co.seoulit.accounting.accountbase.to.AccountBean;
import kr.co.seoulit.accounting.slip.to.JourBean;
import kr.co.seoulit.common.daoexception.DataAccessException;
import kr.co.seoulit.common.dstm.DataSourceTransactionManager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class JourDAOImpl implements JourDAO {

	protected final Log logger = LogFactory.getLog(getClass());
	private DataSourceTransactionManager dstm;

	public void setDstm(DataSourceTransactionManager dstm) {
		this.dstm = dstm;
	}
	public ArrayList<JourBean> searchJour(String slipCode){
		if (logger.isDebugEnabled()) {
			logger.debug("분개 찾을꺼임 :" + slipCode);
		}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<JourBean> list = new ArrayList<JourBean>();
		try {
			StringBuffer query = new StringBuffer();
			query.append("select * from JOURNAL where slip_code=?");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, slipCode);
			rs=pstmt.executeQuery();
			while(rs.next()){
				JourBean bean = new JourBean();
				bean.setSlipCode(rs.getString(1));
				bean.setBalanceCode(rs.getString(2));
				bean.setKeywordCode(rs.getString(3));
				bean.setEvidenceCode(rs.getString(4));
				bean.setAccountCode(rs.getString(5));
				bean.setAmount(rs.getString(6));
				bean.setJournalItemCode(rs.getString(7));
				bean.setBusinessCode(rs.getString(8));
				bean.setBalanceName(rs.getString(9));
				bean.setKeywordName(rs.getString(10));
				bean.setEvidenceName(rs.getString(11));
				bean.setAccountName(rs.getString(12));
				list.add(bean);
			}
			if (logger.isDebugEnabled()) {
				logger.debug("분개 찾기 끝 : " + list);
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
	public void insertJour(JourBean bean) {
		if (logger.isDebugEnabled()) {
			logger.debug("분개 삽입" + bean);
		}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("insert into JOURNAL values(?,?,?,?,?,?,?,?,?,?,?,?,?)");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, bean.getSlipCode());
			pstmt.setString(2, bean.getBalanceCode());
			pstmt.setString(3, bean.getKeywordCode());
			pstmt.setString(4, bean.getEvidenceCode());
			pstmt.setString(5, bean.getAccountCode());
			pstmt.setString(6, bean.getAmount());
			pstmt.setString(7, bean.getJournalItemCode());
			pstmt.setString(8, bean.getBusinessCode());
			pstmt.setString(9, bean.getBalanceName());
			pstmt.setString(10, bean.getKeywordName());
			pstmt.setString(11, bean.getEvidenceName());
			pstmt.setString(12, bean.getAccountName());
			pstmt.setString(13, bean.getBusinessName());
			int rst = pstmt.executeUpdate();
			if (logger.isDebugEnabled()) {
				logger.debug("분개 삽입 끝 :" + rst);
			}
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());

		} finally {
			dstm.close(pstmt, rs);

		}

	}

	public void deleteJour(JourBean bean) {
		if (logger.isDebugEnabled()) {
			logger.debug("분개 삭제" + bean);
		}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("delete from journal where slip_code = ? and journal_item_code=?");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, bean.getSlipCode());
			pstmt.setString(2, bean.getJournalItemCode());
			int rst = pstmt.executeUpdate();
			if (logger.isDebugEnabled()) {
				logger.debug("분개 삭제 끝 : " + rst);
			}
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());

		} finally {
			dstm.close(pstmt, rs);

		}

	}

	public void updateJour(JourBean bean) {
		if (logger.isDebugEnabled()) {
			logger.debug("분개 수정" + bean);
		}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("update journal set balance_code=?,KEYWORD_CODE=?,EVIDENCE_CODE=?,ACCOUNT_CODE=?,AMOUNT=?,");
			query.append("BUSINESS_CODE=?,BALANCE_NAME=?,KEYWORD_NAME=?,EVIDENCE_NAME=?,ACCOUNT_NAME=? ,BUSINESS_NAME=?");
			query.append("where slip_code=? and journal_item_code=?");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, bean.getBalanceCode());
			pstmt.setString(2, bean.getKeywordCode());
			pstmt.setString(3, bean.getEvidenceCode());
			pstmt.setString(4, bean.getAccountCode());
			pstmt.setString(5, bean.getAmount());
			pstmt.setString(6, bean.getBusinessCode());
			pstmt.setString(7, bean.getBalanceName());
			pstmt.setString(8, bean.getKeywordName());
			pstmt.setString(9, bean.getEvidenceName());
			pstmt.setString(10, bean.getAccountName());
			pstmt.setString(11,bean.getBusinessName());
			pstmt.setString(12, bean.getSlipCode());
			pstmt.setString(13, bean.getJournalItemCode());
			int rst = pstmt.executeUpdate();
			if (logger.isDebugEnabled()) {
				logger.debug("분개 수정 끝 :" + rst);
			}
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());
		} finally {
			dstm.close(pstmt, rs);
		}
	}

	@Override
	public ArrayList<AccountBean> getCodeList() {
		if (logger.isDebugEnabled()) {
			logger.debug("계정과목을 가져옴 ");
		}
		ArrayList<AccountBean> list = new ArrayList<AccountBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("select * from Account");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			rs = pstmt.executeQuery();
			while (rs.next()) {
				AccountBean bean = new AccountBean();
				bean.setAccountCode(rs.getString("account_code"));
				bean.setAccountName(rs.getString("account_name"));
				list.add(bean);
			}
			if (logger.isDebugEnabled()) {
				logger.debug("계정과목 가져오기 성공! : ");
			}
			return list;
		} catch (Exception sqle) {
			logger.fatal(sqle.getMessage());
			sqle.printStackTrace();
			throw new DataAccessException(sqle.getMessage());
		} finally {
			dstm.close(pstmt, rs);
		}
	}

}