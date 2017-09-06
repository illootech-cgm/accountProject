package kr.co.seoulit.base.dao;

import java.util.ArrayList;

import kr.co.seoulit.base.to.CodeInfoBean;
import kr.co.seoulit.base.to.EmpBean;

public interface EmpDAO {
	public int selectEmpCount();
	public ArrayList<EmpBean> selectEmpBeanList(int startRow, int endRow);
	public void updateEmp(EmpBean empBean);
	public boolean findId(String id);
	public boolean checkPw(String id,String pw);
	public int deleteEmp(String id);
	public CodeInfoBean findEmpdept(String id);
	public String findEmpname(String id);
	public String getLastEmpCode();
	public int insertEmp(EmpBean empBean);
}
