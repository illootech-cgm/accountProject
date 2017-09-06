package kr.co.seoulit.base.to;

import kr.co.seoulit.base.to.BaseBean;

public class EmpBean extends BaseBean {
	private String status="normal",empCode,empName, empPw,
	         empBirthday,empTel,empPhone,empZip,empAddr,
	         empFilename,empTempFilename,deptCode,positionCode;

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getEmpCode() {
		return empCode;
	}

	public void setEmpCode(String empCode) {
		this.empCode = empCode;
	}

	public String getEmpName() {
		return empName;
	}

	public void setEmpName(String empName) {
		this.empName = empName;
	}

	public String getEmpPw() {
		return empPw;
	}

	public void setEmpPw(String empPw) {
		this.empPw = empPw;
	}

	public String getEmpBirthday() {
		return empBirthday;
	}

	public void setEmpBirthday(String empBirthday) {
		this.empBirthday = empBirthday;
	}

	public String getEmpTel() {
		return empTel;
	}

	public void setEmpTel(String empTel) {
		this.empTel = empTel;
	}

	public String getEmpPhone() {
		return empPhone;
	}

	public void setEmpPhone(String empPhone) {
		this.empPhone = empPhone;
	}

	public String getEmpZip() {
		return empZip;
	}

	public void setEmpZip(String empZip) {
		this.empZip = empZip;
	}

	public String getEmpAddr() {
		return empAddr;
	}

	public void setEmpAddr(String empAddr) {
		this.empAddr = empAddr;
	}

	public String getEmpFilename() {
		return empFilename;
	}

	public void setEmpFilename(String empFilename) {
		this.empFilename = empFilename;
	}

	public String getEmpTempFilename() {
		return empTempFilename;
	}

	public void setEmpTempFilename(String empTempFilename) {
		this.empTempFilename = empTempFilename;
	}

	public String getDeptCode() {
		return deptCode;
	}

	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}

	public String getPositionCode() {
		return positionCode;
	}

	public void setPositionCode(String positionCode) {
		this.positionCode = positionCode;
	}
}