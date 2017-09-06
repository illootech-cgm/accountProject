package kr.co.seoulit.base.service;

import java.util.ArrayList;

import kr.co.seoulit.base.dao.CodeDAO;
import kr.co.seoulit.base.dao.EmpDAO;
import kr.co.seoulit.base.dao.PostDAO;
import kr.co.seoulit.base.to.CodeGubunBean;
import kr.co.seoulit.base.to.CodeInfoBean;
import kr.co.seoulit.base.to.EmpBean;
import kr.co.seoulit.base.to.PostBean;
import kr.co.seoulit.common.daoexception.DataAccessException;
import kr.co.seoulit.common.dstm.DataSourceTransactionManager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class BaseServiceFacadeImpl implements BaseServiceFacade {
	protected final Log logger = LogFactory.getLog(getClass());
	private DataSourceTransactionManager dstm;
	private EmpDAO empDAO;
	private CodeDAO codeDAO;
	private PostDAO postDAO;
	public void setCodeDAO(CodeDAO codeDAO) {
		this.codeDAO = codeDAO;
	}

	public void setPostDAO(PostDAO postDAO) {
		this.postDAO = postDAO;
	}

	public void setEmpDAO(EmpDAO empDAO) {
		this.empDAO = empDAO;
	}

	public void setDstm(DataSourceTransactionManager dstm) {
		this.dstm = dstm;
	}
	   @Override
	   public void insertEmp(EmpBean empBean){
	      System.out.println("EmpServiceFacadeImpl - insertProcess - Start!");
	      
	      dstm.beginTransaction();
	      try{
	               if(empBean.getStatus().equals("insert")){
	                     empDAO.insertEmp(empBean);   
	               }
	         
	               dstm.commitTransaction();
	         System.out.println("EmpServiceFacadeImpl - insertProcess - End!");
	      }catch (Exception e){
	         e.printStackTrace();
	         dstm.rollbackTransaction();
	      
	         throw e;
	      }
	   }
	@Override
	   public String getLastEmpCode() {
	      if (logger.isDebugEnabled()) {
	            logger.debug("Start EmpServiceFacadeImpl-Method~!");
	         }
	      dstm.beginTransaction();
	      try{
	         String empCode = empDAO.getLastEmpCode();
	         dstm.closeConnection();
	         if (logger.isDebugEnabled()) {
	               logger.debug("End EmpServiceFacadeImpl-Method~!");
	            }
	         return empCode;
	      }catch (DataAccessException e){
	         e.printStackTrace();
	         dstm.rollbackTransaction();
	         throw e;
	      }      
	   }
	public void batchProcess(EmpBean empBean) {
		if (logger.isDebugEnabled()) {
			logger.debug("사원 일괄처리 시작");
		}
		dstm.beginTransaction();

		try {
			if (empBean.getStatus().equals("insert")) {
				// empdao.insertEmp(empBean);

			} else if (empBean.getStatus().equals("update")) {
				empDAO.updateEmp(empBean);
			} else if (empBean.getStatus().equals("delete")) {
				empDAO.deleteEmp(empBean.getEmpCode());
			}

			dstm.commitTransaction();
			if (logger.isDebugEnabled()) {
				logger.debug("사원 일괄처리 끝");
			}

		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}
	}

	@Override
	public int getRowCount() {
		dstm.beginTransaction();
		try {
			int count = empDAO.selectEmpCount();
			dstm.closeConnection();
			return count;
		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}
	}

	@Override
	public ArrayList<EmpBean> findEmpList(int sr, int er) { // 리스트
		if (logger.isDebugEnabled()) {
			logger.debug("사원리스트 시작");
		}
		dstm.beginTransaction();
		try {
			ArrayList<EmpBean> empBeanList;
			empBeanList = empDAO.selectEmpBeanList(sr, er);

			dstm.closeConnection();
			if (logger.isDebugEnabled()) {
				logger.debug("사원리스트 끝 결과:" + empBeanList);
			}
			return empBeanList;
		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}
	}

	@Override
	public boolean findMemberId(String id) {
		if (logger.isDebugEnabled()) {
			logger.debug("회원찾기 시작");
		}
		dstm.beginTransaction();
		try {
			boolean findid = false;
			findid = empDAO.findId(id);
			dstm.closeConnection();
			if (logger.isDebugEnabled()) {
				logger.debug("회원찾기 끝 결과:" + findid);
			}
			return findid;
		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}
	}

	public boolean checkMemberPw(String id, String pw) {
		if (logger.isDebugEnabled()) {
			logger.debug("로그인 검사 시작");
		}
		dstm.beginTransaction();
		try {
			boolean checkpw = false;
			checkpw = empDAO.checkPw(id, pw);
			dstm.closeConnection();
			if (logger.isDebugEnabled()) {
				logger.debug("로그인 검사 끝 결과:" + checkpw);
			}
			return checkpw;
		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}
	}

	public ArrayList<CodeGubunBean> getCodeList() {
		if (logger.isDebugEnabled()) {
			logger.debug("dept_name 검색");
		}
		dstm.beginTransaction();
		try {
			ArrayList<CodeGubunBean> list = codeDAO.getCodeList();
			dstm.closeConnection();
			if (logger.isDebugEnabled()) {
				logger.debug("dept_name 검색 끝");
			}
			return list;
		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}

	}

	public ArrayList<CodeInfoBean> getInfocode(String parameter, String selAcc) {
	
		
		try {
			dstm.beginTransaction();
			if (logger.isDebugEnabled()) {
				logger.debug("code 검색");
			}
			ArrayList<CodeInfoBean> list = codeDAO.getInfocode(parameter,selAcc);
			dstm.closeConnection();
			if (logger.isDebugEnabled()) {
				logger.debug("code 검색 끝");
			}
			return list;
		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}
	}
	
	public ArrayList<PostBean> searchPostList(String dong) {
		if (logger.isDebugEnabled()) {
			logger.debug("시작");
		}
		dstm.beginTransaction();
		try {
			ArrayList<PostBean> list = postDAO.searchPostList(dong);
			dstm.closeConnection();
			if (logger.isDebugEnabled()) {
				logger.debug("종료");
			}
			return list;
		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}

	}
	
	public ArrayList<PostBean> searchSidoList() {
		if (logger.isDebugEnabled()) {
			logger.debug("시작");
		}
		dstm.beginTransaction();
		try {
			ArrayList<PostBean> list=postDAO.searchSidoList();
			dstm.closeConnection();
			if (logger.isDebugEnabled()) {
				logger.debug("종료");
			}
			return list;
		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}

	}
	public ArrayList<PostBean> searchSigunguList(String parameter) {
		if (logger.isDebugEnabled()) {
			logger.debug("시작");
		}
		dstm.beginTransaction();
		try {
			ArrayList<PostBean> list =postDAO.searchSigunguList(parameter);
			dstm.closeConnection();
			if (logger.isDebugEnabled()) {
				logger.debug("종료");
			}
			return list;
		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}

	}
	public ArrayList<PostBean> searchRoadList(String sido, String sigunguname,String roadname) {
		if (logger.isDebugEnabled()) {
			logger.debug("시작");
		}
		dstm.beginTransaction();
		try {
			ArrayList<PostBean> list=postDAO.searchRoadList(sido,sigunguname,roadname);
			dstm.closeConnection();
			if (logger.isDebugEnabled()) {
				logger.debug("종료");
			}
			return list;
		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}

	}
	
	public void updateCode(CodeInfoBean codeinfo) {
		if (logger.isDebugEnabled()) {
			logger.debug("시작");
		}
		dstm.beginTransaction();
		try {
			codeDAO.updateCode(codeinfo);
			dstm.closeConnection();
			if (logger.isDebugEnabled()) {
				logger.debug("종료");
			}
			return ;
		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}

	}
	public void addCode(CodeInfoBean codeinfo) {
		if (logger.isDebugEnabled()) {
			logger.debug("시작");
		}
		dstm.beginTransaction();
		try {
			codeDAO.addCode(codeinfo);
			dstm.closeConnection();
			if (logger.isDebugEnabled()) {
				logger.debug("종료");
			}
			return ;
		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}

	}
	public void deleteCode(CodeInfoBean codeinfo){
		if (logger.isDebugEnabled()) {
			logger.debug("시작");
		}
		dstm.beginTransaction();
		try {
			codeDAO.deleteCode(codeinfo);
			dstm.closeConnection();
			if (logger.isDebugEnabled()) {
				logger.debug("종료");
			}
			return ;
		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}

	}
	
	public CodeInfoBean findEmpdept(String id){
		if (logger.isDebugEnabled()) {
			logger.debug("시작");
		}
		dstm.beginTransaction();
		try {
			CodeInfoBean bean =empDAO.findEmpdept(id);
			dstm.closeConnection();
			if (logger.isDebugEnabled()) {
				logger.debug("종료");
			}
			return bean;
		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}

	}
	
		public String findEmpname(String id){
		if (logger.isDebugEnabled()) {
			logger.debug("시작");
		}
		dstm.beginTransaction();
		try {
			String name=empDAO.findEmpname(id);
			dstm.closeConnection();
			if (logger.isDebugEnabled()) {
				logger.debug("종료");
			}
			return name;
		} catch (DataAccessException e) {
			e.printStackTrace();
			dstm.rollbackTransaction();
			throw e;
		}

	}

	
	

}