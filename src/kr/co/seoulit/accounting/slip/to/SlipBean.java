package kr.co.seoulit.accounting.slip.to;

import java.util.ArrayList;

import kr.co.seoulit.base.to.BaseBean;

public class SlipBean extends BaseBean {
	private String status = "normal",slipCode,writeDate,kipyoNo,slipType,okState,balanceDiff,empCode,request,writeEmpCode,writeEmpName,resolveDeptCode,resolveDeptName;
	
	public String getResolveDeptName() {
		return resolveDeptName;
	}
	public void setResolveDeptName(String resolveDeptName) {
		this.resolveDeptName = resolveDeptName;
	}
	private ArrayList<JourBean> jourBeanList;
	
	
	public ArrayList<JourBean> getJourBeanList() {
		return jourBeanList;
	}
	public void setJourBeanList(ArrayList<JourBean> jourBeanList) {
		this.jourBeanList = jourBeanList;
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
	public String getWriteDate() {
		return writeDate;
	}
	public void setWriteDate(String writeDate) {
		this.writeDate = writeDate;
	}
	public String getKipyoNo() {
		return kipyoNo;
	}
	public void setKipyoNo(String kipyoNo) {
		this.kipyoNo = kipyoNo;
	}
	public String getSlipType() {
		return slipType;
	}
	public void setSlipType(String slipType) {
		this.slipType = slipType;
	}
	public String getOkState() {
		return okState;
	}
	public void setOkState(String okState) {
		this.okState = okState;
	}
	public String getBalanceDiff() {
		return balanceDiff;
	}
	public void setBalanceDiff(String balanceDiff) {
		this.balanceDiff = balanceDiff;
	}
	public String getEmpCode() {
		return empCode;
	}
	public void setEmpCode(String empCode) {
		this.empCode = empCode;
	}
	public String getRequest() {
		return request;
	}
	public void setRequest(String request) {
		this.request = request;
	}
	public String getWriteEmpCode() {
		return writeEmpCode;
	}
	public void setWriteEmpCode(String writeEmpCode) {
		this.writeEmpCode = writeEmpCode;
	}
	public String getWriteEmpName() {
		return writeEmpName;
	}
	public void setWriteEmpName(String writeEmpName) {
		this.writeEmpName = writeEmpName;
	}
	public String getResolveDeptCode() {
		return resolveDeptCode;
	}
	public void setResolveDeptCode(String resolveDeptCode) {
		this.resolveDeptCode = resolveDeptCode;
	}
	

}