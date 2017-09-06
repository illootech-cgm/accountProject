package kr.co.seoulit.accounting.slip.dao;

import java.util.ArrayList;

import kr.co.seoulit.accounting.accountbase.to.AccountBean;
import kr.co.seoulit.accounting.slip.to.JourBean;


public interface JourDAO {
	public ArrayList<AccountBean> getCodeList();
	public void insertJour(JourBean bean);
	public void deleteJour(JourBean bean);
	public void updateJour(JourBean bean);
	public ArrayList<JourBean> searchJour(String slipCode);
}
