package com.spring.board.dao;

import java.util.List;

import com.spring.board.vo.BoardVo;
import com.spring.board.vo.CodeInfoVo;
import com.spring.board.vo.PageVo;

public interface BoardDao {

	public String selectTest() throws Exception;

	public List<BoardVo> selectBoardList(PageVo pageVo) throws Exception;
	
	public List<BoardVo> selectBoardListByboardType(PageVo pageVo) throws Exception;
	
	public BoardVo selectBoard(BoardVo boardVo) throws Exception;

	public int selectBoardCnt() throws Exception;

	public int boardInsert(BoardVo boardVo) throws Exception;
	
	public int boardUpdate(BoardVo boardVo) throws Exception;
	
	public int boardDelete(BoardVo boardVo) throws Exception;
	
	public List<CodeInfoVo> selectCodeinfo(CodeInfoVo codeInfoVo) throws Exception;
	
	//*************************MBTI*******************************************
	public List<BoardVo> questionList(PageVo pageVo)throws Exception;
	public List<String> mbtiList() throws Exception;

}
