package kr.co.seoulit.accounting.accountbase.to;

import kr.co.seoulit.base.to.BaseBean;

public class AccountBean extends BaseBean {
	private String status = "normal",accountCode ,accountName,accountDetailItemCode,AccountDetailItemName;

	public String getAccountDetailItemCode() {
		return accountDetailItemCode;
	}

	public void setAccountDetailItemCode(String accountDetailItemCode) {
		this.accountDetailItemCode = accountDetailItemCode;
	}

	public String getAccountDetailItemName() {
		return AccountDetailItemName;
	}

	public void setAccountDetailItemName(String accountDetailItemName) {
		AccountDetailItemName = accountDetailItemName;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getAccountCode() {
		return accountCode;
	}

	public void setAccountCode(String accountCode) {
		this.accountCode = accountCode;
	}

	public String getAccountName() {
		return accountName;
	}

	public void setAccountName(String accountName) {
		this.accountName = accountName;
	}

}