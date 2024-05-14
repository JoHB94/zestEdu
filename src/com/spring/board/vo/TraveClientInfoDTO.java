package com.spring.board.vo;

public class TraveClientInfoDTO {
	
	private String period;
    private String traveTime;
    private String transTime;
    private String traveTrans;
    private String transport;
    
    
    
	public String getTransport() {
		return transport;
	}
	public void setTransport(String transport) {
		this.transport = transport;
	}
	public String getPeriod() {
		return period;
	}
	public void setPeriod(String period) {
		this.period = period;
	}
	public String getTraveTime() {
		return traveTime;
	}
	public void setTraveTime(String traveTime) {
		this.traveTime = traveTime;
	}
	public String getTransTime() {
		return transTime;
	}
	public void setTransTime(String transTime) {
		this.transTime = transTime;
	}
	public String getTraveTrans() {
		return traveTrans;
	}
	public void setTraveTrans(String traveTrans) {
		this.traveTrans = traveTrans;
	}
	@Override
	public String toString() {
		return "TraveClientInfoDTO [period=" + period + ", traveTime=" + traveTime + ", transTime=" + transTime
				+ ", traveTrans=" + traveTrans + "]";
	}
    
    
}
