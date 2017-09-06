package kr.co.seoulit.accounting.slip.dao;

import java.util.ArrayList;

import kr.co.seoulit.accounting.slip.to.SlipBean;


public interface SlipDAO {
	public void insertSlip(SlipBean bean);
	public void deleteSlip(SlipBean bean);
	public void updateSlip(SlipBean bean);
	public String getLastCode();
	public ArrayList<SlipBean> searchSlip(String date);
}
