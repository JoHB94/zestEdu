package com.spring.board.vo;

import java.util.List;

public class PageVo {
	
	private int pageNo = 0;
	
	private List<String> boardTypes;

	public List<String> getBoardTypes() {
		return boardTypes;
	}


	public void setBoardTypes(List<String> boardTypes) {
		this.boardTypes = boardTypes;
	}

	public int getPageNo() {
		return pageNo;
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}
	@Override
	public String toString() {
		return "PageVo [boardTypes=" + boardTypes + "]";
	}
	
}
