package kr.co.seoulit.base.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import kr.co.seoulit.base.to.CodeInfoBean;
import kr.co.seoulit.base.to.EmpBean;
import kr.co.seoulit.common.daoexception.DataAccessException;
import kr.co.seoulit.common.dstm.DataSourceTransactionManager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class EmpDAOImpl implements EmpDAO {
	protected final Log logger = LogFactory.getLog(getClass());
	private DataSourceTransactionManager dstm;

	public void setDstm(DataSourceTransactionManager dstm) {
		this.dstm = dstm;
	}

	@Override
	public String getLastEmpCode() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {

			StringBuffer query = new StringBuffer();
			query.append("select lpad(max(emp_code)+1,4,'0') as lastCode from emp ");
			query.append("order by emp_code");

			con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());

			rs = pstmt.executeQuery();

			String lastCode = null;
			if (rs.next()) {
				lastCode = rs.getString("lastCode");
			}
			return lastCode;
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());
		} finally {
			dstm.close(pstmt, rs);
		}
	}

	public void updateEmp(EmpBean empBean) {
		if (logger.isDebugEnabled()) {
			logger.debug("회원 수정 시작 , 수정할 code :" + empBean.getEmpCode());
		}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("update emp set emp_name=?,emp_birthday=?,");
			query.append("emp_tel=?, emp_phone=?,emp_zip=?,emp_addr=?,");
			query.append("dept_code=?,position_code=? , emp_filename=?,emp_temp_filename=? where emp_code=?");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, empBean.getEmpName());
			pstmt.setString(2, empBean.getEmpBirthday());
			pstmt.setString(3, empBean.getEmpTel());
			pstmt.setString(4, empBean.getEmpPhone());
			pstmt.setString(5, empBean.getEmpZip());
			pstmt.setString(6, empBean.getEmpAddr());
			pstmt.setString(7, empBean.getDeptCode());
			pstmt.setString(8, empBean.getPositionCode());
			pstmt.setString(9, empBean.getEmpFilename());
			pstmt.setString(10, empBean.getEmpTempFilename());
			pstmt.setString(11, empBean.getEmpCode());
			int rst = pstmt.executeUpdate();
			if (logger.isDebugEnabled()) {
				logger.debug("회원 수정 끝 결과 :" + rst + "명 변경완료");
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());
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
	public boolean findId(String id) {
		if (logger.isDebugEnabled()) {
			logger.debug("로그인 아이디 검색 :" + id);
		}
		boolean findId = false;
		Connection con = dstm.getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuffer query = new StringBuffer();
		try {
			query.append("select emp_pw from emp where emp_code=?");
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if (rs.next())
				findId = true;

		} catch (DataAccessException | SQLException e) {
			e.printStackTrace();
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
		if (logger.isDebugEnabled()) {
			logger.debug("로그인-아이디 검색 결과 :" + findId);
		}
		return findId;
	}

	public int insertEmp(EmpBean empBean) {
		if (logger.isDebugEnabled()) {
			logger.debug("EmpDAOImpl - insertEmp - Start!");
		}
		Connection con = null;
		PreparedStatement pstmt = null;
		int rs;
		try {

			StringBuffer query = new StringBuffer();
			query.append("insert into emp values(?,?,?,?,?,?,?,?,?,?,?,?)");
			con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, empBean.getEmpCode());
			pstmt.setString(2, empBean.getEmpName());
			pstmt.setString(3, empBean.getEmpBirthday());
			pstmt.setString(4, empBean.getEmpTel());
			pstmt.setString(5, empBean.getEmpPhone());
			pstmt.setString(6, empBean.getEmpAddr());
			pstmt.setString(7, empBean.getEmpFilename());
			pstmt.setString(8, empBean.getEmpTempFilename());
			pstmt.setString(9, empBean.getEmpZip());
			pstmt.setString(10, empBean.getPositionCode());
			pstmt.setString(11, empBean.getEmpPw());
			pstmt.setString(12, empBean.getDeptCode());
			
			rs = pstmt.executeUpdate();
			if (logger.isDebugEnabled()) {
				logger.debug("EmpDAOImpl - insertEmp - End!");
			}
			return rs;
		} catch (Exception sqle) {
			throw new DataAccessException(sqle.getMessage());
		} finally {
			dstm.close(pstmt);
		}
	}

	@Override
	public boolean checkPw(String id, String pw) {
		if (logger.isDebugEnabled()) {
			logger.debug("로그인 비밀번호 검사 :" + "아이디:" + id + "//pw:" + pw);
		}
		boolean checkpw = false;
		Connection con = dstm.getConnection();

		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuffer query = new StringBuffer();
		try {
			query.append("select emp_pw from emp where emp_code=?");
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString(1).equals(pw))
					checkpw = true;
			}
		} catch (DataAccessException | SQLException e) {
			e.printStackTrace();
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
		if (logger.isDebugEnabled()) {
			logger.debug("로그인 비밀번호 검사 :" + checkpw);
		}
		return checkpw;

	}

	public ArrayList<EmpBean> selectEmpBeanList(int startRow, int endRow) {
		if (logger.isDebugEnabled()) {
			logger.debug("EMP 리스트 뿌리기 시작");
		}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		EmpBean empBean = null;
		ArrayList<EmpBean> empBeanList = new ArrayList<EmpBean>();
		try {
			StringBuffer query = new StringBuffer();
			query.append("select * from ");
			query.append("(select rownum as rn, emp_code, emp_name, emp_pw, to_char(emp_birthday,'yyyy/mm/dd'), emp_tel,emp_phone,emp_zip, ");
			query.append(" emp_addr, emp_filename,emp_temp_filename ,dept_code,position_code ");
			query.append("from (select * from emp order by emp_code desc)) t ");
			query.append("where t.rn between ? and ?");

			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				empBean = new EmpBean();
				empBean.setEmpCode(rs.getString(2));
				empBean.setEmpName(rs.getString(3));
				empBean.setEmpPw(rs.getString(4));
				empBean.setEmpBirthday(rs.getString(5));
				empBean.setEmpTel(rs.getString(6));
				empBean.setEmpPhone(rs.getString(7));
				empBean.setEmpZip(rs.getString(8));
				empBean.setEmpAddr(rs.getString(9));
				empBean.setEmpFilename(rs.getString(10));
				empBean.setEmpTempFilename(rs.getString(11));
				empBean.setDeptCode(rs.getString(12));
				empBean.setPositionCode(rs.getString(13));

				empBeanList.add(empBean);
			}
			if (logger.isDebugEnabled()) {
				logger.debug("EMP리스트 결과" + empBeanList);
			}
			return empBeanList;
		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());
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
	public int selectEmpCount() {
		if (logger.isDebugEnabled()) {
			logger.debug("사원 총원 구하기 시작");
		}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			StringBuffer query = new StringBuffer();
			query.append("select count(*) from emp");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			rs = pstmt.executeQuery();
			rs.next();
			count = rs.getInt(1);
			if (logger.isDebugEnabled()) {
				logger.debug("사원 총인원 구하기 결과" + count);
			}
			return count;

		} catch (SQLException e) {
			e.printStackTrace();
			throw new DataAccessException(e.getMessage());
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
	public int deleteEmp(String id) {
		if (logger.isDebugEnabled()) {
			logger.debug("삭제 다오 시작 : " + id);
		}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int rst;
		try {
			StringBuffer query = new StringBuffer();
			query.append("delete from emp where emp_code=?");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, id);
			rst = pstmt.executeUpdate();
			if (logger.isDebugEnabled()) {
				logger.debug("삭제 결과 : " + rst);
			}

			return rst;
		} catch (Exception sqle) {
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

	public String findEmpname(String id) {
		if (logger.isDebugEnabled()) {
			logger.debug("회원의 이름을 가져옴 : " + id);
		}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String deptName = null;
		try {
			StringBuffer query = new StringBuffer();
			query.append("select emp_name from emp where emp_code=?");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if (rs.next())
				deptName = rs.getString(1);
			if (logger.isDebugEnabled()) {
				logger.debug("부서코드 출력 결과 : " + deptName);
			}

			return deptName;
		} catch (Exception sqle) {
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
	public CodeInfoBean findEmpdept(String id) {
		if (logger.isDebugEnabled()) {
			logger.debug("회원의 부서를 가져옴 : " + id);
		}
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			CodeInfoBean bean = new CodeInfoBean();
			StringBuffer query = new StringBuffer();
			query.append("select detail_code_name,detail_code from code_detail where detail_code=(select dept_code from emp where emp_code=?)");
			Connection con = dstm.getConnection();
			pstmt = con.prepareStatement(query.toString());
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				bean.setDetailCodeName(rs.getString(1));
				bean.setDetailCode(rs.getString(2));
			}
			if (logger.isDebugEnabled()) {
				logger.debug("부서코드 출력 결과 : " + bean);
			}

			return bean;
		} catch (Exception sqle) {
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

}