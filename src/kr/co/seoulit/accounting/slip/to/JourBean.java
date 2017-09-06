package kr.co.seoulit.accounting.slip.to;

import java.util.ArrayList;

import kr.co.seoulit.base.to.BaseBean;

public class JourBean extends BaseBean {
	private String status = "normal",slipCode,journalItemCode,balanceCode,balanceName,keywordCode,keywordName,evidenceCode,evidenceName,accountCode,accountName,amount,businessCode,businessName;
	public String getBusinessName() {
		return businessName;
	}

	public void setBusinessName(String businessName) {
		this.businessName = businessName;
	}

	ArrayList<JourDetailBean> jourDetailBeanList;


	public ArrayList<JourDetailBean> getJourDetailBeanList() {
		return jourDetailBeanList;
	}

	public void setJourDetailBeanList(ArrayList<JourDetailBean> jourDetailBeanList) {
		this.jourDetailBeanList = jourDetailBeanList;
	}

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

	public String getJournalItemCode() {
		return journalItemCode;
	}

	public void setJournalItemCode(String journalItemCode) {
		this.journalItemCode = journalItemCode;
	}

	public String getBalanceCode() {
		return balanceCode;
	}

	public void setBalanceCode(String balanceCode) {
		this.balanceCode = balanceCode;
	}

	public String getBalanceName() {
		return balanceName;
	}

	public void setBalanceName(String balanceName) {
		this.balanceName = balanceName;
	}

	public String getKeywordCode() {
		return keywordCode;
	}

	public void setKeywordCode(String keywordCode) {
		this.keywordCode = keywordCode;
	}

	public String getKeywordName() {
		return keywordName;
	}

	public void setKeywordName(String keywordName) {
		this.keywordName = keywordName;
	}

	public String getEvidenceCode() {
		return evidenceCode;
	}

	public void setEvidenceCode(String evidenceCode) {
		this.evidenceCode = evidenceCode;
	}

	public String getEvidenceName() {
		return evidenceName;
	}

	public void setEvidenceName(String evidenceName) {
		this.evidenceName = evidenceName;
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

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}

	public String getBusinessCode() {
		return businessCode;
	}

	public void setBusinessCode(String businessCode) {
		this.businessCode = businessCode;
	}
}