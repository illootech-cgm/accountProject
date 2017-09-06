package kr.co.seoulit.accounting.slip.dao;

import java.util.ArrayList;

import kr.co.seoulit.accounting.slip.to.JourBean;
import kr.co.seoulit.accounting.slip.to.JourDetailBean;


public interface JourDetailDAO {
	public void insertDetailJour(JourDetailBean bean);
	public void deleteDetailJour(JourDetailBean bean);
	public void updateDetailJour(JourDetailBean bean);
	public ArrayList<JourDetailBean> searchDetail(JourBean jourBean);
}
