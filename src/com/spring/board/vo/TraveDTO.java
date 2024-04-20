package com.spring.board.vo;

import java.util.List;

public class TraveDTO {
	
	private ClientInfoVo celient;
	private List<TraveInfoVo> traveList;
	private String traveDay;
	
	public String getTraveDay() {
		return traveDay;
	}
	public void setTraveDay(String traveDay) {
		this.traveDay = traveDay;
	}
	public ClientInfoVo getCelient() {
		return celient;
	}
	public void setCelient(ClientInfoVo celient) {
		this.celient = celient;
	}
	public List<TraveInfoVo> getTraveList() {
		return traveList;
	}
	public void setTraveList(List<TraveInfoVo> traveList) {
		this.traveList = traveList;
	}
	@Override
	public String toString() {
		return "TraveDTO [celient=" + celient + ", traveList=" + traveList + ", traveDay=" + traveDay + "]";
	}
	
	
	

}
