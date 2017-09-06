package kr.co.seoulit.base.dao;

import java.util.ArrayList;

import kr.co.seoulit.base.to.CodeGubunBean;
import kr.co.seoulit.base.to.CodeInfoBean;

public interface CodeDAO {
	public ArrayList<CodeGubunBean> getCodeList();
	public ArrayList<CodeInfoBean> getInfocode(String code, String selAcc);
	public void deleteCode(CodeInfoBean info);
	public void addCode(CodeInfoBean codeinfo);
	public void updateCode(CodeInfoBean info);
	
}
