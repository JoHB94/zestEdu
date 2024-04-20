package com.spring.board.vo;

public class TraveInfoVo {
	
	private String seq;
	private String traveDay;
	private String traveTime;
	private String traveCity;
	private String traveCounty;
	private String traveLoc;
	private String traveTrans;
	private String transTime;
	private String useTime;
	private String useExpend;
	private String travelDetail;
	private String request;
	
	
	
	public TraveInfoVo(String seq, String traveDay) {
		super();
		this.seq = seq;
		this.traveDay = traveDay;
	}
	
	public TraveInfoVo() {
		super();
	}



	public String getSeq() {
		return seq;
	}
	public void setSeq(String seq) {
		this.seq = seq;
	}
	public String getTraveDay() {
		return traveDay;
	}
	public void setTraveDay(String traveDay) {
		this.traveDay = traveDay;
	}
	public String getTraveTime() {
		return traveTime;
	}
	public void setTraveTime(String traveTime) {
		this.traveTime = traveTime;
	}
	public String getTraveCity() {
		return traveCity;
	}
	public void setTraveCity(String traveCity) {
		this.traveCity = traveCity;
	}
	public String getTraveCounty() {
		return traveCounty;
	}
	public void setTraveCounty(String traveCounty) {
		this.traveCounty = traveCounty;
	}
	public String getTraveLoc() {
		return traveLoc;
	}
	public void setTraveLoc(String traveLoc) {
		this.traveLoc = traveLoc;
	}
	public String getTraveTrans() {
		return traveTrans;
	}
	public void setTraveTrans(String traveTrans) {
		this.traveTrans = traveTrans;
	}
	public String getTransTime() {
		return transTime;
	}
	public void setTransTime(String transTime) {
		this.transTime = transTime;
	}
	public String getUseTime() {
		return useTime;
	}
	public void setUseTime(String useTime) {
		this.useTime = useTime;
	}
	public String getUseExpend() {
		return useExpend;
	}
	public void setUseExpend(String useExpend) {
		this.useExpend = useExpend;
	}
	public String getTravelDetail() {
		return travelDetail;
	}
	public void setTravelDetail(String travelDetail) {
		this.travelDetail = travelDetail;
	}
	public String getRequest() {
		return request;
	}
	public void setRequest(String request) {
		this.request = request;
	}
	@Override
	public String toString() {
		return "TraveInfo [seq=" + seq + ", traveDay=" + traveDay + ", traveTime=" + traveTime + ", traveCity="
				+ traveCity + ", traveCounty=" + traveCounty + ", traveLoc=" + traveLoc + ", traveTrans=" + traveTrans
				+ ", transTime=" + transTime + ", useTime=" + useTime + ", useExpend=" + useExpend + ", travelDetail="
				+ travelDetail + ", request=" + request + "]";
	}
	
	
}
