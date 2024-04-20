package com.spring.board.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.board.dao.BoardDao;
import com.spring.board.service.boardService;
import com.spring.board.vo.BoardVo;
import com.spring.board.vo.CodeInfoVo;
import com.spring.board.vo.MBTIVo;
import com.spring.board.vo.PageVo;

@Service
public class boardServiceImpl implements boardService{
	
	@Autowired
	BoardDao boardDao;
	
	@Override
	public String selectTest() throws Exception {
		// TODO Auto-generated method stub
		return boardDao.selectTest();
	}
	
	@Override
	public List<BoardVo> SelectBoardList(PageVo pageVo) throws Exception {
		// TODO Auto-generated method stub
		
		return boardDao.selectBoardList(pageVo);
	}
	
	@Override
	public int selectBoardCnt() throws Exception {
		// TODO Auto-generated method stub
		return boardDao.selectBoardCnt();
	}
	
	@Override
	public BoardVo selectBoard(String boardType, int boardNum) throws Exception {
		// TODO Auto-generated method stub
		BoardVo boardVo = new BoardVo();
		
		boardVo.setBoardType(boardType);
		boardVo.setBoardNum(boardNum);
		
		return boardDao.selectBoard(boardVo);
	}
	
	@Override
	public int boardInsert(BoardVo boardVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.boardInsert(boardVo);
	}

	@Override
	public int boardUpdate(BoardVo boardVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.boardUpdate(boardVo);
	}

	@Override
	public int boardDelete(BoardVo boardVo) throws Exception {
		// TODO Auto-generated method stub
		
		return boardDao.boardDelete(boardVo);
	}

	@Override
	public List<BoardVo> selectBoardListByBoardType(PageVo pageVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.selectBoardListByboardType(pageVo);
	}

	@Override
	public List<CodeInfoVo> selectMenuInfo() throws Exception {
		// TODO Auto-generated method stub
		CodeInfoVo codeInfoVo = new CodeInfoVo();
		codeInfoVo.setCodeType("menu");
		
		return boardDao.selectCodeinfo(codeInfoVo);
	}

	@Override
	public List<CodeInfoVo> selectPhoneInfo() throws Exception {
		// TODO Auto-generated method stub
		CodeInfoVo codeInfoVo = new CodeInfoVo();
		codeInfoVo.setCodeType("phone");
		
		return boardDao.selectCodeinfo(codeInfoVo);
	}

	@Override
	public List<BoardVo> questionList(PageVo pageVo) throws Exception {
		// TODO Auto-generated method stub
		return boardDao.questionList(pageVo);
	}

	@Override
	public List<String> mbtiList() throws Exception {
		// TODO Auto-generated method stub
		return boardDao.mbtiList();
	}

	@Override
	public String mbtiCal(List<MBTIVo> testResult) throws Exception {
		// TODO Auto-generated method stub
		
		String[][] mbti = {{"I","E"},{"S","N"},{"T","F"},{"P","J"}};
		Map<String,Integer> result = new HashMap<String,Integer>();
		
		String testedMbti = "";
//		int[] answerVal = {0,3,2,1,0,1,2,3};

		//result 의 각 밸류 값을 0으로 초기화
		for (String[] array : mbti) {
			for (String value : array) {
				result.put(value, 0);
			}
		}
		
		for(int i=0; i < testResult.size(); i++) {
			
			String type	= testResult.get(i).getType();
			int value 	= testResult.get(i).getValue();
			
			String firstLetter	= String.valueOf(type.charAt(0));
			String secondLetter = String.valueOf(type.charAt(1));
			
			int firstLetterVal 	= result.get(String.valueOf(type.charAt(0)));
			int secondLetterVal = result.get(String.valueOf(type.charAt(1)));
			
			if(value == 1) {
				result.put(firstLetter, firstLetterVal + 3);
			}else if(value == 2) {
				result.put(firstLetter, firstLetterVal + 2);
			}else if(value == 3) {
				result.put(firstLetter, firstLetterVal + 1);
			}else if(value == 4) {
				
			}else if(value == 5) {
				result.put(secondLetter, secondLetterVal + 1);
			}else if(value == 6) {
				result.put(secondLetter, secondLetterVal + 2);
			}else if(value == 7) {
				result.put(secondLetter, secondLetterVal + 3);
			}
			
		}
		
		for(int i =0; i < mbti.length; i ++) {
			String[] s = mbti[i];
			
			if((result.get(s[1]) < result.get(s[0]))) {
				testedMbti += s[0];
			}else if((result.get(s[1]) > result.get(s[0]))) {
				testedMbti += s[1];
			}else {
				//결과 값이 같은 경우 사전 순 정렬하는 로직.
				if(s[0].compareTo(s[1])<0) {
					testedMbti += s[0];
				}else {
					testedMbti += s[1];
				}
			}
		}

		return testedMbti;
	}
		
}
