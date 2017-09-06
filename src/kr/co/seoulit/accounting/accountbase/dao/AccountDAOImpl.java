package kr.co.seoulit.accounting.accountbase.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import kr.co.seoulit.accounting.accountbase.to.AccountBean;
import kr.co.seoulit.common.daoexception.DataAccessException;
import kr.co.seoulit.common.dstm.DataSourceTransactionManager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class AccountDAOImpl implements AccountDAO {

	protected final Log logger = LogFactory.getLog(getClass());
	private DataSourceTransactionManager dstm;
	public void setDstm(DataSourceTransactionManager dstm) {
		this.dstm = dstm;
	}
	
	@Override
	public ArrayList<AccountBean> getDetailJour(String accCode) {
		if (logger.isDebugEnabled()) {
			logger.debug("분개상세목록을 가져옴 ");
		}
		ArrayList<AccountBean> list = new ArrayList<AccountBean>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("select a.account_code,a.account_name,i.account_detail_item_code,i.account_detail_item_name from account a");
			query.append(",account_detail d , account_detail_item i ");
			query.append("where a.account_code = d.account_code ");
			query.append("and d.account_detail_item_code = i.account_detail_item_code ");
			query.append("and substr(i.ACCOUNT_DETAIL_ITEM_CODE,1,3) = substr(?,3,6)");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, accCode);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				AccountBean bean = new AccountBean();
				bean.setAccountCode(rs.getString("account_code"));
				bean.setAccountName(rs.getString("account_name"));
				bean.setAccountDetailItemCode(rs.getString("account_detail_item_code"));
				bean.setAccountDetailItemName(rs.getString("account_detail_item_name"));
				list.add(bean);
			}
			if (logger.isDebugEnabled()) {
				logger.debug("분개상세목록 가져오기 성공! : " + list);
			}
			return list;
		} catch (Exception sqle) {
			sqle.printStackTrace();
			throw new DataAccessException(sqle.getMessage());
		} finally {
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
				if (pstmt != null) {
					pstmt.close();
					pstmt = null;
				}
			} catch (Exception e) {
			}
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
			sqle.printStackTrace();
			throw new DataAccessException(sqle.getMessage());
		} finally {
			dstm.close(pstmt,rs);
		}
	}

}