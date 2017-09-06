package kr.co.seoulit.accounting.accountbase.service;

import java.util.ArrayList;

import kr.co.seoulit.accounting.accountbase.to.AccountBean;

public interface AccountServiceFacade {

	public ArrayList<AccountBean> getCodeList();
	public ArrayList<AccountBean> getDetailJour(String accCode);

	
}
