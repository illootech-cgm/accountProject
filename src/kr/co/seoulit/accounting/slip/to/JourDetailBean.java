package kr.co.seoulit.accounting.slip.to;

import kr.co.seoulit.base.to.BaseBean;

public class JourDetailBean extends BaseBean {
	private String status = "normal",slipCode,value,journalItemCode,item,accountDetailItemCode;

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getSlipCode() {
		return slipCode;
	}

	public void setSlipCode(String slipCode) {
		this.slipCode = slipCode;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getJournalItemCode() {
		return journalItemCode;
	}

	public void setJournalItemCode(String journalItemCode) {
		this.journalItemCode = journalItemCode;
	}

	public String getItem() {
		return item;
	}

	public void setItem(String item) {
		this.item = item;
	}

	public String getAccountDetailItemCode() {
		return accountDetailItemCode;
	}

	public void setAccountDetailItemCode(String accountDetailItemCode) {
		this.accountDetailItemCode = accountDetailItemCode;
	}

}