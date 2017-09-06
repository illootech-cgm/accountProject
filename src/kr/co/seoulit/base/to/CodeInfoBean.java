package kr.co.seoulit.base.to;

public class CodeInfoBean {
public String categoryCode , detailCode , detailCodeName , useWhether , status="normal";

public String getCategoryCode() {
	return categoryCode;
}

public void setCategoryCode(String categoryCode) {
	this.categoryCode = categoryCode;
}

public String getDetailCode() {
	return detailCode;
}

public void setDetailCode(String detailCode) {
	this.detailCode = detailCode;
}

public String getDetailCodeName() {
	return detailCodeName;
}

public void setDetailCodeName(String detailCodeName) {
	this.detailCodeName = detailCodeName;
}

public String getUseWhether() {
	return useWhether;
}

public void setUseWhether(String useWhether) {
	this.useWhether = useWhether;
}

public String getStatus() {
	return status;
}

public void setStatus(String status) {
	this.status = status;
}


}
