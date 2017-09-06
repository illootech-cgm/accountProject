package kr.co.seoulit.base.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import kr.co.seoulit.base.to.CodeGubunBean;
import kr.co.seoulit.base.to.CodeInfoBean;
import kr.co.seoulit.common.daoexception.DataAccessException;
import kr.co.seoulit.common.dstm.DataSourceTransactionManager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class CodeDAOImpl implements CodeDAO{
	
	protected final Log logger = LogFactory.getLog(getClass());
	private DataSourceTransactionManager dstm;
	
	public void setDstm(DataSourceTransactionManager dstm) {
		this.dstm = dstm;
	}
	public ArrayList<CodeGubunBean> getCodeList() {
		if (logger.isDebugEnabled()) {logger.debug("�ڵ帮��Ʈ �Ѹ��� ���� :");}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CodeGubunBean gubun;
		ArrayList<CodeGubunBean> codeBeanList = new ArrayList<CodeGubunBean>();
		try {
			StringBuffer query = new StringBuffer();
			query.append("select * from code_category");
			Connection con = dstm
					.getConnection();
			pstmt = con.prepareStatement(query.toString());
			rs = pstmt.executeQuery();

			while (rs.next()) {
				gubun = new CodeGubunBean();
				gubun.setCategoryCode(rs.getString(1));
				gubun.setCategoryName(rs.getString(2));
				gubun.setModiWhether(rs.getString(3));
				codeBeanList.add(gubun);

			}
			if (logger.isDebugEnabled()) {logger.debug("�ڵ� ����Ʈ �Ѹ��� ���:"+codeBeanList);}
			return codeBeanList;
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());
		} finally {
			dstm.close(pstmt,rs);
		}
	}

	public ArrayList<CodeInfoBean> getInfocode(String code, String selAcc) {
		if (logger.isDebugEnabled()) {logger.debug("�ڵ� ���� �Ѹ��� :"+code+" �� ���� , �������� ���� :"+selAcc);}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CodeInfoBean info;
		ArrayList<CodeInfoBean> codeinfo = new ArrayList<CodeInfoBean>();
		try {
			StringBuffer query = new StringBuffer();
			Connection con = dstm.getConnection();
			if(selAcc==null||selAcc.equals("null")){
				query.append("select * from code_detail where category_code=?");
				pstmt = con.prepareStatement(query.toString());
				pstmt.setString(1, code);
			}
			else{
				query.append("SELECT * FROM CODE_DETAIL d,ACCOUNT ac ");
				query.append("WHERE d.CATEGORY_CODE='KEY' ");
				query.append("AND SUBSTR(?,3)=SUBSTR(d.DETAIL_CODE,1,3) "); // AC001
				query.append("AND ac.ACCOUNT_CODE=?"); //001 ~ 003
				pstmt = con.prepareStatement(query.toString());
				pstmt.setString(1, selAcc);
				pstmt.setString(2, selAcc);
			}
			rs = pstmt.executeQuery();

			while (rs.next()) {
				info = new CodeInfoBean();
				info.setCategoryCode(rs.getString(1));
				info.setDetailCode(rs.getString(2));
				info.setDetailCodeName(rs.getString(3));
				info.setUseWhether(rs.getString(4));
				codeinfo.add(info);
			}
			if (logger.isDebugEnabled()) {logger.debug("�ڵ� ���� �Ѹ��� �� :"+code+" �� ����");}
			return codeinfo;
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());
		} finally {
			dstm.close(pstmt,rs);
		}

	}

	public void deleteCode(CodeInfoBean info) { // ����
		if (logger.isDebugEnabled()) {logger.debug("�ڵ� ���� :"+info);}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("delete from code_detail where category_code=? ");
			query.append("and detail_code=?");
			Connection con = dstm
					.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, info.getCategoryCode());
			pstmt.setString(2, info.getDetailCode());
			int rst = pstmt.executeUpdate();

			if (logger.isDebugEnabled()) {logger.debug("�ڵ� ���� ��� :"+rst+" �� ���� �Ϸ�");}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());
		} finally {
			dstm.close(pstmt,rs);
		}

	}

	public void addCode(CodeInfoBean codeinfo) { // �߰�
		if (logger.isDebugEnabled()) {logger.debug("�ڵ� �߰��ϱ� :"+codeinfo);}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("insert into code_detail values(?,?,?,?)");
			Connection con = dstm
					.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, codeinfo.getCategoryCode());
			pstmt.setString(2, codeinfo.getDetailCode());
			pstmt.setString(3, codeinfo.getDetailCodeName());
			pstmt.setString(4, codeinfo.getUseWhether());
			int rst = pstmt.executeUpdate();
			if (logger.isDebugEnabled()) {logger.debug("�ڵ� �߰��ϱ� �� ���:"+rst+"�� ���߰� �Ϸ�");}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());
		} finally {
			dstm.close(pstmt,rs);
		}

	}

	public void updateCode(CodeInfoBean info) { // ����
		if (logger.isDebugEnabled()) {logger.debug("�ڵ� �����ϱ� :"+info);}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("update code_detail set detail_code_name=? , use_whether=?");
			query.append("where category_code=? and detail_code=?");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, info.getDetailCodeName());
			pstmt.setString(2, info.getUseWhether());
			pstmt.setString(3, info.getCategoryCode());
			pstmt.setString(4, info.getDetailCode());
			int rst = pstmt.executeUpdate();
			if (logger.isDebugEnabled()) {logger.debug("�ڵ� �����ϱ� ��� :"+rst+"���� ���� �Ϸ�");}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());
		} finally {
			dstm.close(pstmt,rs);
		}

	}

}
