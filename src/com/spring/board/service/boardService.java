package com.spring.board.service;

import java.util.List;
import java.util.Map;

import com.spring.board.vo.BoardVo;
import com.spring.board.vo.PageVo;
import com.spring.board.vo.CodeInfoVo;
import com.spring.board.vo.MBTIVo;

public interface boardService {

	public String selectTest() throws Exception;

	public List<BoardVo> SelectBoardList(PageVo pageVo) throws Exception;

	public BoardVo selectBoard(String boardType, int boardNum) throws Exception;

	public int selectBoardCnt() throws Exception;

	public int boardInsert(BoardVo boardVo) throws Exception;
	
	public int boardUpdate(BoardVo boardVo) throws Exception;
	
	public int boardDelete(BoardVo boardVo) throws Exception;
	
	public List<BoardVo> selectBoardListByBoardType(PageVo pageVo) throws Exception;
	
	public List<CodeInfoVo> selectMenuInfo()throws Exception;
	
	public List<CodeInfoVo> selectPhoneInfo() throws Exception;
	
	//*************************MBTI*********************************
	
	public List<BoardVo> questionList(PageVo pageVo) throws Exception;
	
	public List<String> mbtiList() throws Exception;
	
	public String mbtiCal(List<MBTIVo> testResult) throws Exception;                   

}
