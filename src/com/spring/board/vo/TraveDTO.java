package com.spring.board.vo;

import java.util.List;

public class TraveDTO {
	
	private ClientInfoVo client;
	private List<TraveInfoVo> traveList;
	private String traveDay;
	
	public ClientInfoVo getClient() {
		return client;
	}
	public void setClient(ClientInfoVo client) {
		this.client = client;
	}
	public String getTraveDay() {
		return traveDay;
	}
	public void setTraveDay(String traveDay) {
		this.traveDay = traveDay;
	}

	public List<TraveInfoVo> getTraveList() {
		return traveList;
	}
	public void setTraveList(List<TraveInfoVo> traveList) {
		this.traveList = traveList;
	}
	@Override
	public String toString() {
		return "TraveDTO [client=" + client + ", traveList=" + traveList + ", traveDay=" + traveDay + "]";
	}

}
