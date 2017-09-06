package kr.co.seoulit.accounting.accountbase.dao;

import java.util.ArrayList;

import kr.co.seoulit.accounting.accountbase.to.AccountBean;


public interface AccountDAO {
	public ArrayList<AccountBean> getCodeList();
	public ArrayList<AccountBean> getDetailJour(String accCode);
}
