package com.spring.board.vo;

public class CertificateVo {
	
	private String qualifiName;
	private String acquDate;
	private String organizeName;
	
	private String seq;
	private String certSeq;
	
	

	public String getCertSeq() {
		return certSeq;
	}

	public void setCertSeq(String certSeq) {
		this.certSeq = certSeq;
	}

	public String getQualifiName() {
		return qualifiName;
	}

	public void setQualifiName(String qualifiName) {
		this.qualifiName = qualifiName;
	}

	public String getAcquDate() {
		return acquDate;
	}

	public void setAcquDate(String acquDate) {
		this.acquDate = acquDate;
	}

	public String getOrganizeName() {
		return organizeName;
	}

	public void setOrganizeName(String organizeName) {
		this.organizeName = organizeName;
	}

	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	@Override
	public String toString() {
		return "CertificateVo [qualifiName=" + qualifiName + ", acquDate=" + acquDate + ", organizeName=" + organizeName
				+ ", seq=" + seq + ", certSeq=" + certSeq + "]";
	}

	
	
}
