package kr.co.seoulit.accounting.slip.service;

import java.util.ArrayList;

import kr.co.seoulit.accounting.slip.to.SlipBean;

public interface SlipServiceFacade {

	public void batchProcess(ArrayList<SlipBean> sliplist);
	public String getLastSlipCode();
	public ArrayList<SlipBean> searchDate(String date);
	
}
