package com.spring.board.controller;

import java.io.IOException;
import java.net.URLDecoder;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.codehaus.jackson.JsonProcessingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.spring.board.HomeController;
import com.spring.board.service.boardService;
import com.spring.board.vo.BoardVo;
import com.spring.board.vo.CodeInfoVo;
import com.spring.board.vo.MBTIVo;
import com.spring.board.vo.PageVo;
import com.spring.common.CommonUtil;

@Controller
public class BoardController {
	
	@Autowired 
	boardService boardService;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = "/board/boardList.do", method = RequestMethod.GET)
	public String boardList(Locale locale, Model model,PageVo pageVo) throws Exception{
		
		List<BoardVo> boardList = new ArrayList<BoardVo>();
		List<CodeInfoVo> cdif = new ArrayList<CodeInfoVo>();
		
		int page = 1;
		int totalCnt = 0;
		int endPage = 0;
		int showPage = 5;
		
		if(pageVo.getPageNo() == 0){
			pageVo.setPageNo(page);;
		}
		
		boardList = boardService.SelectBoardList(pageVo);
		totalCnt = boardService.selectBoardCnt() -20;
		endPage = (int) Math.ceil((double)totalCnt/10);
		cdif = boardService.selectMenuInfo();
		System.out.println("endPage: " + boardList.get(0).getEndPage());
		System.out.println("showPage: " + showPage + " endPage: " + endPage);
		
		model.addAttribute("boardList", boardList);
		model.addAttribute("code", cdif);
		model.addAttribute("totalCnt", totalCnt);
		model.addAttribute("showPage", showPage);
		model.addAttribute("currentPage", page);
		model.addAttribute("endPage", endPage);
		
		return "board/boardList";
	}
	
	@RequestMapping(value = "/board/boardListByBoardType.do", method = RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<HashMap<String,Object>> boardListByBoardType(Locale locale,PageVo pageVo) throws Exception{
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		
		//pageVo.setBoardTypes(boardTypes);
		System.out.println("Types : " + pageVo.toString());
		
		int page = pageVo.getPageNo();
		int totalCnt = 0;
		int endPage = 0;
		int showPage = 5;
		
		if(pageVo.getPageNo() == 0){
			pageVo.setPageNo(page);
		}
		
		List<BoardVo> boardList = boardService.selectBoardListByBoardType(pageVo);
		
		if(boardList.size() != 0) {
			totalCnt = boardList.get(0).getTotalCnt();
			
			endPage = (int) Math.ceil((double)totalCnt/10);
		}
		System.out.println("showPage: " + showPage + "endPage: " + endPage);
		
		result.put("boardList", boardList);
		result.put("totalCnt", totalCnt);
		result.put("showPage", showPage);
		result.put("currentPage", page);
		result.put("endPage", endPage);
				
		return new ResponseEntity<HashMap<String,Object>>(result,HttpStatus.OK);
	}
	
	@RequestMapping(value = "/board/{boardType}/{boardNum}/{pageNo}/boardView.do", method = RequestMethod.GET)
	public String boardView(Locale locale, Model model
			,@PathVariable("boardType")String boardType
			,@PathVariable("boardNum")int boardNum
			,@PathVariable("pageNo")int page) throws Exception{
		
		BoardVo boardVo = new BoardVo();
		System.out.println("pageNo : " + page);
		
		boardVo = boardService.selectBoard(boardType,boardNum);
		
		model.addAttribute("boardType", boardType);
		model.addAttribute("boardNum", boardNum);
		model.addAttribute("pageNo", page);
		model.addAttribute("board", boardVo);
		
		return "board/boardView";
	}
	
	@RequestMapping(value = "/board/{boardType}/{boardNum}/boardUpdate.do", method = RequestMethod.GET)
	public String boardUpdate(Locale locale, Model model
			,@PathVariable("boardType")String boardType
			,@PathVariable("boardNum")int boardNum) throws Exception {
		
		BoardVo boardVo = new BoardVo();
		System.out.println(boardVo.getBoardNum());
		boardVo = boardService.selectBoard(boardType,boardNum);
		
		model.addAttribute("boardType", boardType);
		model.addAttribute("boardNum", boardNum);
		model.addAttribute("board", boardVo);
		
		return "board/boardUpdate";
	}
	
	@RequestMapping(value = "/board/boardWrite.do", method = RequestMethod.GET)
	public String boardWrite(Locale locale, Model model) throws Exception{
		
		List<CodeInfoVo> menuList = new ArrayList<CodeInfoVo>();
		menuList = boardService.selectMenuInfo();
		
		model.addAttribute("menuList", menuList);
		
		return "board/boardWrite";
	}
	
	@RequestMapping(value = "/board/boardWriteAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String boardWriteAction(Locale locale,BoardVo boardVo) throws Exception{
		
		System.out.println(boardVo.toString());
		
		HashMap<String, String> result = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		
		int resultCnt = boardService.boardInsert(boardVo);
		
		result.put("success", (resultCnt > 0)?"Y":"N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
		
		System.out.println("callbackMsg::"+callbackMsg);
		
		return callbackMsg;
	}
	
	@RequestMapping(value = "/board/boardUpdateAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String boardUpdateAction(Locale locale,BoardVo boardVo) throws Exception{
		
		HashMap<String, String> result = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		
		int resultCnt = boardService.boardUpdate(boardVo);
		
		result.put("success", (resultCnt > 0)?"Y":"N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
		
		System.out.println("callbackMsg::"+callbackMsg);
		
		return callbackMsg;
	}
	
	@RequestMapping(value = "/board/boardDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public String boardDelete(Locale locale,BoardVo boardVo)throws Exception {
		
		HashMap<String, String> result = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		
		System.out.println(boardVo.toString());
		
		int resultCnt = boardService.boardDelete(boardVo);
		
		result.put("success", (resultCnt > 0)?"Y":"N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
		
		System.out.println("callbackMsg::"+callbackMsg);
		
		return callbackMsg;
	}
	
	//****************************MBTI**************************************
	
	@RequestMapping(value = "/board/mbtiList.do", method = RequestMethod.GET)
	public String questionList(Locale locale, Model model, PageVo pageVo) throws Exception {

		List<BoardVo> boardList = new ArrayList<BoardVo>();

		int page = 1;
		
		if(pageVo.getPageNo() == 0){
			pageVo.setPageNo(page);
		}
		
		System.out.println(pageVo.getBoardTypes());
		
		boardList = boardService.questionList(pageVo);
		model.addAttribute("questionList", boardList);
		model.addAttribute("pageNo", page);
		
		return "mbti/mbtiTest";
	}
	
	@RequestMapping(value = "/board/mbtiResult.do", method = RequestMethod.GET)
	public String resultView(Locale locale,Model model
			,@RequestParam("testedMbti") String testedMbti) throws Exception{
		model.addAttribute("testedMbti", testedMbti);
		return "mbti/mbtiResult";
	}
	
	
	@RequestMapping(value = "/board/mbtiListNext.do", method = RequestMethod.GET)
	public ResponseEntity<Map<String,Object>> questionNext(Locale locale, PageVo pageVo
			,@RequestParam int pageNo) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		List<BoardVo> boardList = new ArrayList<BoardVo>();

		pageVo.setPageNo(pageNo);
		
		System.out.println(pageVo.getBoardTypes());
		
		boardList = boardService.questionList(pageVo);
		
		result.put("questionList", boardList);
		result.put("pageNo", pageNo);
		         
		return new ResponseEntity<Map<String,Object>>(result,HttpStatus.OK);
	}
		
	@RequestMapping(value = "/board/mbtiResultAction.do",consumes = MediaType.APPLICATION_JSON_VALUE, method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Map<String,Object>> resultAction(Locale locale, Model model
		,@RequestBody List<Map<String,String>> testResult) throws Exception{
		Map<String, Object> result = new HashMap<String, Object>();
		List<MBTIVo> mbtiVoList = new ArrayList<>();
		
		
		for (Map<String, String> map : testResult) {
			MBTIVo mbtiVo = new MBTIVo();
			mbtiVo.setType(map.get("type"));
			mbtiVo.setValue(Integer.parseInt(map.get("value")));
			mbtiVoList.add(mbtiVo);			
		}
		String testedMbti = boardService.mbtiCal(mbtiVoList);
		result.put("testedMbti", testedMbti);
		//model.addAttribute("testedMbti", testedMbti);
		System.out.println("클라이언트에서 넘어온 타입값"+ mbtiVoList.get(0).getType());
		System.out.println("클라이언트에서 넘어온 밸류값"+mbtiVoList.get(0).getValue());
		
		
		System.out.println("MBTI : " + testedMbti);
		return new ResponseEntity<Map<String,Object>>(result,HttpStatus.OK);
    }
}
