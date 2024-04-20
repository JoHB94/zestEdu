package com.spring.board.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.board.HomeController;
import com.spring.board.service.UserInfoService;
import com.spring.board.service.boardService;
import com.spring.board.vo.CodeInfoVo;
import com.spring.board.vo.UserInfoVo;
import com.spring.common.CommonUtil;

@Controller
public class UserInfoController {
	
	@Autowired
	UserInfoService userInfoService;
	
	@Autowired 
	boardService boardService;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = "/board/checkId.do", method = RequestMethod.GET)
	@ResponseBody
	public String checkId(Locale locale,UserInfoVo userInfoVo ) throws Exception {
		
		HashMap<String, String> result = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		
		int checkResult = userInfoService.checkId(userInfoVo);
		
		result.put("success", (checkResult == 1)? "Y" : "N" );
		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);
		
		System.out.println("callbackMsg::"+callbackMsg);
		
		return callbackMsg;
	}
	
	@RequestMapping(value = "/board/userJoin.do", method = RequestMethod.GET)
	public String userJoin(Locale locale, Model model) throws Exception {
		List<CodeInfoVo> phoneList = new ArrayList<CodeInfoVo>();
		UserInfoVo userInfoVo = new UserInfoVo();
		phoneList = boardService.selectPhoneInfo();
				
		model.addAttribute("phones", phoneList);
		model.addAttribute("userInfo", userInfoVo);
		
		return "member/userJoin";
		
	}
	
	@RequestMapping(value = "/board/login.do", method = RequestMethod.GET)
	public String login(Locale locale)throws Exception {
		
		return "member/login";
	}
	
	@RequestMapping(value = "/board/loginAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String login(Locale locale,UserInfoVo userInfoVo
			,HttpServletRequest request) throws Exception {
		
		HashMap<String, String> result = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		
		HttpSession session = request.getSession();
		UserInfoVo loginInfo = userInfoService.login(userInfoVo);
		String callbackMsg = null;
		
		if(!loginInfo.getUserName().isEmpty()) {
			session.setAttribute("userId", loginInfo.getUserId());
			session.setAttribute("userName", loginInfo.getUserName());
			
			result.put("success","Y");
			result.put("userName", loginInfo.getUserId());
			callbackMsg = commonUtil.getJsonCallBackString("", result);
		}
		return callbackMsg;
	}
		
	
	@RequestMapping(value = "/board/userJoinAction.do", method = RequestMethod.POST)
	@ResponseBody
	public String userJoin(Locale locale, UserInfoVo userInfoVo) throws Exception {
		
		HashMap<String, String> result = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		
		System.out.println(userInfoVo.toString());
		
		int resultCnt = userInfoService.userInsert(userInfoVo);
		
		result.put("success", (resultCnt > 0)?"Y":"N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
		
		System.out.println("callbackMsg::"+callbackMsg);
		
		return callbackMsg;
	}
	        
	@RequestMapping(value = "/board/logout.do", method = RequestMethod.GET)
	public String logout(Locale locale, HttpSession session) throws Exception {
		try {
			session.invalidate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return "redirect:/board/boardList.do";
	}
	
}
