package com.spring.board.vo;

public class ClientInfoVo {
	
	private String seq;
	private String userName;
	private String userPhone;
	private String traveCity;
	private String period;
	private String expend;
	private String transport;
	
	
	
	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserPhone() {
		return userPhone;
	}
	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
	}
	public String getTraveCity() {
		return traveCity;
	}
	public void setTraveCity(String traveCity) {
		this.traveCity = traveCity;
	}
	public String getPeriod() {
		return period;
	}
	public void setPeriod(String period) {
		this.period = period;
	}
	public String getExpend() {
		return expend;
	}
	public void setExpend(String expend) {
		this.expend = expend;
	}
	public String getTransport() {
		return transport;
	}
	public void setTransport(String transport) {
		this.transport = transport;
	}
	@Override
	public String toString() {
		return "ClientInfoVo [seq=" + seq + ", userName=" + userName + ", userPhone=" + userPhone + ", traveCity="
				+ traveCity + ", period=" + period + ", expend=" + expend + ", transport=" + transport + "]";
	}

	
	
	
}
