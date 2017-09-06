package kr.co.seoulit.accounting.slip.service;

import java.util.ArrayList;

import kr.co.seoulit.accounting.slip.dao.JourDAO;
import kr.co.seoulit.accounting.slip.dao.JourDetailDAO;
import kr.co.seoulit.accounting.slip.dao.SlipDAO;
import kr.co.seoulit.accounting.slip.to.JourBean;
import kr.co.seoulit.accounting.slip.to.JourDetailBean;
import kr.co.seoulit.accounting.slip.to.SlipBean;
import kr.co.seoulit.common.dstm.DataSourceTransactionManager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class SlipServiceFacadeImpl implements SlipServiceFacade {
	protected final Log logger = LogFactory.getLog(getClass());
	public SlipDAO slipDAO;
	public JourDAO jourDAO;
	public JourDetailDAO jourDetailDAO;
	private DataSourceTransactionManager dstm;

	public void setJourDetailDAO(JourDetailDAO jourDetailDAO) {
		this.jourDetailDAO = jourDetailDAO;
	}

	public void setJourDAO(JourDAO jourDAO) {
		this.jourDAO = jourDAO;
	}

	public void setSlipDAO(SlipDAO slipDAO) {
		this.slipDAO = slipDAO;
	}

	public void setDstm(DataSourceTransactionManager dstm) {
		this.dstm = dstm;
	}

	public ArrayList<SlipBean> searchDate(String date) {
		if (logger.isDebugEnabled()) {
			logger.debug("전표검색 서비스퍼사드 시작 " + date);
		}
		dstm.beginTransaction();
		ArrayList<SlipBean> sliplist = slipDAO.searchSlip(date);
		for (int k = 0; k < sliplist.size(); k++) { // 전표 돌림
			ArrayList<JourBean> jourlist = jourDAO.searchJour(sliplist.get(k)
					.getSlipCode());// 각전표의 코드맞는 분개배열받아옴
			for (int i = 0; i < jourlist.size(); i++) { // 분개갯수만큼 돌림
				jourlist.get(i).setJourDetailBeanList(jourDetailDAO.searchDetail(jourlist.get(i)));// 각분개에 맞는
																		// 분개상세																	// 가져옴
			}
			sliplist.get(k).setJourBeanList(jourlist);
		}
		dstm.closeConnection();
		if (logger.isDebugEnabled()) {
			logger.debug("전표검색 서비스퍼사드 끝 ");
		}
		return sliplist;
	}

	public String getLastSlipCode() {
		if (logger.isDebugEnabled()) {
			logger.debug("막전표코드 가져오기 서비스퍼사드 시작 ");
		}
		dstm.beginTransaction();
		String lastCode = slipDAO.getLastCode();
		dstm.closeConnection();
		if (logger.isDebugEnabled()) {
			logger.debug("막전표코드 가져오기 서비스퍼사드 끝 " + lastCode);
		}
		return lastCode;

	}

	public void batchProcess(ArrayList<SlipBean> sliplist) {
		if (logger.isDebugEnabled()) {
			logger.debug("일괄처리 서비스퍼사드 시작 ");
		}
		try {
			dstm.beginTransaction();
			for (int i = 0; i < sliplist.size(); i++) {
				System.out.println("slip status : "
						+ sliplist.get(i).getStatus());
				if (sliplist.get(i).getStatus().equals("insert")) {
					slipDAO.insertSlip(sliplist.get(i));
					batchJour(sliplist.get(i).getJourBeanList());
				} else if (sliplist.get(i).getStatus().equals("update")) {
					slipDAO.updateSlip(sliplist.get(i));
					batchJour(sliplist.get(i).getJourBeanList());
				} else if (sliplist.get(i).getStatus().equals("delete")) {
					batchJour(sliplist.get(i).getJourBeanList());
					slipDAO.deleteSlip(sliplist.get(i));
				}
			}
			dstm.commitTransaction();
			dstm.closeConnection();
			if (logger.isDebugEnabled()) {
				logger.debug("일괄처리 끝 ");
			}
		} catch (Exception e) {
			logger.fatal(e.getMessage() + "왜안되냐고옫노ㅕㅓ사ㅗㄴ다ㅕㅓ소자ㅕ더솧");
			e.printStackTrace();
			dstm.rollbackTransaction();

		}

	}

	public void batchJour(ArrayList<JourBean> jourBeanList) {
		if (logger.isDebugEnabled()) {
			logger.debug("분개일괄처리 서비스퍼사드 시작 " + jourBeanList.size());
		}
		try {
			dstm.beginTransaction();
			for (int i = 0; i < jourBeanList.size(); i++) {
				System.out.println("분개 서비스 status 확인"
						+ jourBeanList.get(i).getStatus());
				if (jourBeanList.get(i).getStatus().equals("insert")) {
					jourDAO.insertJour(jourBeanList.get(i));
					batchDetailJour(jourBeanList.get(i).getJourDetailBeanList());
				} else if (jourBeanList.get(i).getStatus().equals("update")) {
					jourDAO.updateJour(jourBeanList.get(i));
					batchDetailJour(jourBeanList.get(i).getJourDetailBeanList());
				} else if (jourBeanList.get(i).getStatus().equals("delete")) {
					batchDetailJour(jourBeanList.get(i).getJourDetailBeanList());
					jourDAO.deleteJour(jourBeanList.get(i));
				}
			}
			
			if (logger.isDebugEnabled()) {
				logger.debug("분개일괄처리 서비스퍼사드 끝 ");
			}
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			e.printStackTrace();
			dstm.rollbackTransaction();

		}
	}

	public void batchDetailJour(ArrayList<JourDetailBean> detailjourBean) {
		if (logger.isDebugEnabled()) {
			logger.debug("상세분개일괄처리 서비스퍼사드 시작 " + detailjourBean.size());
		}
		try {
			for (int k = 0; k < detailjourBean.size(); k++) {
				System.out.println("분개상세 스테이터스"
						+ detailjourBean.get(k).getStatus());
				if (detailjourBean.get(k).getStatus().equals("insert")) {
					jourDetailDAO.insertDetailJour(detailjourBean.get(k));
				} else if (detailjourBean.get(k).getStatus().equals("update")) {
					jourDetailDAO.updateDetailJour(detailjourBean.get(k));
				} else if (detailjourBean.get(k).getStatus().equals("delete")) {
					jourDetailDAO.deleteDetailJour(detailjourBean.get(k));
				}

			}
			
			if (logger.isDebugEnabled()) {
				logger.debug("상세분개일괄처리 서비스퍼사드 끝 ");
			}
		} catch (Exception e) {
			logger.fatal(e.getMessage() + "왜안되냐고옫노ㅕㅓ사ㅗㄴ다ㅕㅓ소자ㅕ더솧");
			e.printStackTrace();
			dstm.rollbackTransaction();

		}
	}

}