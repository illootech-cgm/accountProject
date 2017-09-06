package kr.co.seoulit.base.service;

import java.util.ArrayList;

import kr.co.seoulit.base.to.CodeGubunBean;
import kr.co.seoulit.base.to.CodeInfoBean;
import kr.co.seoulit.base.to.EmpBean;
import kr.co.seoulit.base.to.PostBean;

public interface BaseServiceFacade {
	//           ÄÚµå
	
	public ArrayList<CodeGubunBean> getCodeList();
	public ArrayList<CodeInfoBean> getInfocode(String parameter, String selAcc);
	public void updateCode(CodeInfoBean codeinfo);
	public void addCode(CodeInfoBean codeinfo);
	public void deleteCode(CodeInfoBean codeinfo);
	
	//           emp
	public int getRowCount();
	public CodeInfoBean findEmpdept(String id);
	public String findEmpname(String id);
	public ArrayList<EmpBean> findEmpList(int sr, int er);
	public boolean findMemberId(String id);
	public boolean checkMemberPw(String id, String pw);
	public void batchProcess(EmpBean empBean);
	public void insertEmp(EmpBean empBean);
	public String getLastEmpCode();
	
	//          post
	public ArrayList<PostBean> searchPostList(String dong);
	public ArrayList<PostBean> searchSidoList();
	public ArrayList<PostBean> searchSigunguList(String parameter);
	public ArrayList<PostBean> searchRoadList(String sido, String sigunguname,String roadname);
}
