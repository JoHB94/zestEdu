package com.spring.board.vo;

import java.util.List;

public class ReqUpdateDTO {
	
	private List<TraveInfoVo> updateList;

	public List<TraveInfoVo> getUpdateList() {
		return updateList;
	}

	public void setUpdateList(List<TraveInfoVo> updateList) {
		this.updateList = updateList;
	}

	@Override
	public String toString() {
		return "ReqUpdateDTO [updateList=" + updateList + "]";
	}

	
	
}
