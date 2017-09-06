package kr.co.seoulit.accounting.accountbase.service;

import java.util.ArrayList;

import kr.co.seoulit.accounting.accountbase.dao.AccountDAO;
import kr.co.seoulit.accounting.accountbase.to.AccountBean;
import kr.co.seoulit.accounting.slip.dao.JourDAO;
import kr.co.seoulit.accounting.slip.dao.JourDetailDAO;
import kr.co.seoulit.accounting.slip.dao.SlipDAO;
import kr.co.seoulit.common.dstm.DataSourceTransactionManager;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class AccountServiceFacadeImpl implements AccountServiceFacade {
	protected final Log logger = LogFactory.getLog(getClass());
	public AccountDAO accountDAO;
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

	public void setAccountDAO(AccountDAO accountDAO) {
		this.accountDAO = accountDAO;
	}

	public void setDstm(DataSourceTransactionManager dstm) {
		this.dstm = dstm;
	}
	

	public ArrayList<AccountBean> getDetailJour(String accCode) {
		try {
			dstm.beginTransaction();
			ArrayList<AccountBean> list = accountDAO.getDetailJour(accCode);
			dstm.closeConnection();
			return list;
		} catch (Exception e) {
			logger.fatal(e.getMessage()+"왜안되냐고옫노ㅕㅓ사ㅗㄴ다ㅕㅓ소자ㅕ더솧");
			e.printStackTrace();
			dstm.rollbackTransaction();
			return null;
		}

	}

	public ArrayList<AccountBean> getCodeList() {

		try {
			dstm.beginTransaction();
			ArrayList<AccountBean> list = accountDAO.getCodeList();
			dstm.closeConnection();
			return list;

		} catch (Exception e) {
			logger.fatal(e.getMessage()+"왜안되냐고옫노ㅕㅓ사ㅗㄴ다ㅕㅓ소자ㅕ더솧");
			e.printStackTrace();
			dstm.rollbackTransaction();
			return null;
		}

	}
}