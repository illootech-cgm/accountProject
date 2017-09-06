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
			logger.debug("��ǥ�˻� �����ۻ�� ���� " + date);
		}
		dstm.beginTransaction();
		ArrayList<SlipBean> sliplist = slipDAO.searchSlip(date);
		for (int k = 0; k < sliplist.size(); k++) { // ��ǥ ����
			ArrayList<JourBean> jourlist = jourDAO.searchJour(sliplist.get(k)
					.getSlipCode());// ����ǥ�� �ڵ�´� �а��迭�޾ƿ�
			for (int i = 0; i < jourlist.size(); i++) { // �а�������ŭ ����
				jourlist.get(i).setJourDetailBeanList(jourDetailDAO.searchDetail(jourlist.get(i)));// ���а��� �´�
																		// �а���																	// ������
			}
			sliplist.get(k).setJourBeanList(jourlist);
		}
		dstm.closeConnection();
		if (logger.isDebugEnabled()) {
			logger.debug("��ǥ�˻� �����ۻ�� �� ");
		}
		return sliplist;
	}

	public String getLastSlipCode() {
		if (logger.isDebugEnabled()) {
			logger.debug("����ǥ�ڵ� �������� �����ۻ�� ���� ");
		}
		dstm.beginTransaction();
		String lastCode = slipDAO.getLastCode();
		dstm.closeConnection();
		if (logger.isDebugEnabled()) {
			logger.debug("����ǥ�ڵ� �������� �����ۻ�� �� " + lastCode);
		}
		return lastCode;

	}

	public void batchProcess(ArrayList<SlipBean> sliplist) {
		if (logger.isDebugEnabled()) {
			logger.debug("�ϰ�ó�� �����ۻ�� ���� ");
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
				logger.debug("�ϰ�ó�� �� ");
			}
		} catch (Exception e) {
			logger.fatal(e.getMessage() + "�־ȵǳİ힪��Ťû�Ǥ��٤Ťü��ڤŴ���");
			e.printStackTrace();
			dstm.rollbackTransaction();

		}

	}

	public void batchJour(ArrayList<JourBean> jourBeanList) {
		if (logger.isDebugEnabled()) {
			logger.debug("�а��ϰ�ó�� �����ۻ�� ���� " + jourBeanList.size());
		}
		try {
			dstm.beginTransaction();
			for (int i = 0; i < jourBeanList.size(); i++) {
				System.out.println("�а� ���� status Ȯ��"
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
				logger.debug("�а��ϰ�ó�� �����ۻ�� �� ");
			}
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			e.printStackTrace();
			dstm.rollbackTransaction();

		}
	}

	public void batchDetailJour(ArrayList<JourDetailBean> detailjourBean) {
		if (logger.isDebugEnabled()) {
			logger.debug("�󼼺а��ϰ�ó�� �����ۻ�� ���� " + detailjourBean.size());
		}
		try {
			for (int k = 0; k < detailjourBean.size(); k++) {
				System.out.println("�а��� �������ͽ�"
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
				logger.debug("�󼼺а��ϰ�ó�� �����ۻ�� �� ");
			}
		} catch (Exception e) {
			logger.fatal(e.getMessage() + "�־ȵǳİ힪��Ťû�Ǥ��٤Ťü��ڤŴ���");
			e.printStackTrace();
			dstm.rollbackTransaction();

		}
	}

}