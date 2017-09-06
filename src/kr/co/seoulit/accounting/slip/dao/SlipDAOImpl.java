package kr.co.seoulit.accounting.slip.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import kr.co.seoulit.accounting.slip.to.SlipBean;
import kr.co.seoulit.common.daoexception.DataAccessException;
import kr.co.seoulit.common.dstm.DataSourceTransactionManager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class SlipDAOImpl implements SlipDAO {

	protected final Log logger = LogFactory.getLog(getClass());
	private DataSourceTransactionManager dstm;

	public void setDstm(DataSourceTransactionManager dstm) {
		this.dstm = dstm;
	}

	@Override
	public void insertSlip(SlipBean bean) {
		if (logger.isDebugEnabled()) {
			logger.debug("전표 삽입 :품의내역" + bean.getRequest());
		}
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("insert into slip values(?,?,?,?,?,?,?,?,?,?,?,?)");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1,bean.getSlipCode());
			pstmt.setString(2,bean.getWriteDate());
			pstmt.setString(3,bean.getKipyoNo());
			pstmt.setString(4,bean.getSlipType());
			pstmt.setString(5,bean.getOkState());
			pstmt.setInt(6, Integer.parseInt(bean.getBalanceDiff()));
			pstmt.setString(7,bean.getEmpCode());
			pstmt.setString(8,bean.getRequest());
			pstmt.setString(9,bean.getWriteEmpCode());
			pstmt.setString(10,bean.getResolveDeptCode());
			pstmt.setString(11,bean.getWriteEmpName());
			pstmt.setString(12,bean.getResolveDeptName());
		
			int rst=pstmt.executeUpdate();
			
			if (logger.isDebugEnabled()) {logger.debug("전표 삽입 끝 결과:"+rst);}
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());

		} finally {
			dstm.close(pstmt, rs);
		}		
	}	
	public ArrayList<SlipBean> searchSlip(String date){
		if (logger.isDebugEnabled()) {logger.debug("전표검색 다오시작"+date);	}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<SlipBean> list = new ArrayList<SlipBean>();
		try {
			StringBuffer query = new StringBuffer();
			query.append("select * from slip where write_date=? order by slip_code");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, date);
			rs = pstmt.executeQuery();
			while(rs.next()){
				SlipBean bean = new SlipBean();
				bean.setSlipCode(rs.getString(1));
				bean.setWriteDate(rs.getString(2));
				bean.setKipyoNo(rs.getString(3));
				bean.setSlipType(rs.getString(4));
				bean.setOkState(rs.getString(5));
				bean.setBalanceDiff(rs.getString(6));//42056
				bean.setEmpCode(rs.getString(7));
				bean.setRequest(rs.getString(8));
				bean.setWriteEmpCode(rs.getString(9));
				bean.setResolveDeptCode(rs.getString(10));
				bean.setWriteEmpName(rs.getString(11));
				bean.setResolveDeptName(rs.getString(12));//ke32314				
				list.add(bean);
			}
			if (logger.isDebugEnabled()) {logger.debug("전표검색 다오끄읏");	}
			return list; 
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());

		} finally {
			dstm.close(pstmt, rs);
		}		
		
	}
	
	public String getLastCode(){
		if (logger.isDebugEnabled()) {logger.debug("마지막 전표번호 다오시작");	}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("select max(substr(slip_code,7)+0) from slip");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			rs = pstmt.executeQuery();
			rs.next();
			if (logger.isDebugEnabled()) {logger.debug("마지막 전표번호 다오끄읏"+rs.getString(1));	}
			return rs.getString(1); 
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());

		} finally {
			dstm.close(pstmt, rs);
		}		
	}
	@Override
	public void deleteSlip(SlipBean bean) {
		if (logger.isDebugEnabled()) {logger.debug("전표 삭제" + bean);}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("delete from slip where slip_code = ?");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, bean.getSlipCode());
			int rst = pstmt.executeUpdate();
			if (logger.isDebugEnabled()) {logger.debug("전표 삭제 끝 : " + rst);	}
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());
		} finally {
			dstm.close(pstmt, rs);
		}
	}
	@Override
	public void updateSlip(SlipBean bean) {
		if (logger.isDebugEnabled()) {
			logger.debug("전표 수정" + bean);
		}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("update slip set ok_state=?,balance_diff=?,request=? where slip_code=?");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, bean.getOkState());
			pstmt.setString(2, bean.getBalanceDiff());
			pstmt.setString(3, bean.getRequest());
			pstmt.setString(4, bean.getSlipCode());
			int rst = pstmt.executeUpdate();
			if (logger.isDebugEnabled()) {
				logger.debug("전표 수정 끝 :" + rst);
			}
		} catch (Exception e) {
			logger.fatal(e.getMessage()+"와안되노");
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());
		} finally {
			dstm.close(pstmt, rs);
		}
		
	}
}