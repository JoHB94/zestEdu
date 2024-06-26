package com.spring.board.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.board.HomeController;
import com.spring.board.service.TravelService;
import com.spring.board.vo.ClientInfoVo;
import com.spring.board.vo.ReqUpdateDTO;
import com.spring.board.vo.TraveDTO;
import com.spring.board.vo.TraveInfoVo;

@Controller
public class TravelController {
	
	@Autowired
	TravelService travelService;

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = "/travel/login.do", method = RequestMethod.GET)
	public String traveLogin(Locale locale) throws Exception {
		return "travel/login";
	}
	
	@RequestMapping(value = "/travel/loginAction.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String,Object>> traveLoginAction(Locale locale, 
			@RequestBody ClientInfoVo clientInfoVo
			,HttpServletRequest request) throws Exception{
		Map<String, Object> result = new HashMap<String, Object>();
		
		boolean isMember = travelService.isExistMember(clientInfoVo);
		
		HttpSession session = request.getSession();
		session.setAttribute("userName", clientInfoVo.getUserName());
		session.setAttribute("userPhone", clientInfoVo.getUserPhone());
		
		result.put("isMember", isMember);
		
		return new ResponseEntity<Map<String,Object>>(result,HttpStatus.OK);
	}
	
	@RequestMapping(value = "/travel/estimate.do", method = RequestMethod.GET)
	public String traveEstimate(Locale locale) throws Exception {
		return "travel/estimateWrite";
	}
	
	@RequestMapping(value = "/travel/estimateAction.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String,Object>> traveEstimateAction(Locale locale,
			@RequestBody ClientInfoVo clientInfoVo) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		int resultCnt = travelService.insertClient(clientInfoVo);
		result.put("success", (resultCnt > 0)?"Y":"N");
		return new ResponseEntity<Map<String,Object>>(result,HttpStatus.OK);
	}
	
	@RequestMapping(value = "/travel/traveManagement.do", method = RequestMethod.GET)
	public String travelManagement(Locale locale, Model model) throws Exception {
		List<ClientInfoVo> clientList = travelService.selectClientList();		
		model.addAttribute("clientList",clientList);		
		return "travel/traveManagement";
	}
	
	@RequestMapping(value = "/travel/getPeriodAction.do",method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Map<String,Object>> getPeriod(Locale locale,
			@RequestBody int seq) throws Exception{
		Map<String, Object> result = new HashMap<String, Object>();
		System.out.println("**seq: " + seq);
		String period = travelService.selectPeriod(seq);
		
		result.put("period", period);
		
		return new ResponseEntity<Map<String,Object>>(result,HttpStatus.OK);
	}
	
	
	@RequestMapping(value = "/travel/detailTraveList.do",method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Map<String,Object>> getDetailTraveList(Locale locale,Model model,
			@RequestBody TraveInfoVo traveInfoVo) throws Exception{
		Map<String, Object> result = new HashMap<String, Object>();
		List<TraveInfoVo> detailTraveList = travelService.selectTraveListBySeqAndDay(traveInfoVo);
		
		model.addAttribute("detailTraveList", detailTraveList);
		result.put("detailTraveList", detailTraveList);
		
		return new ResponseEntity<Map<String,Object>>(result,HttpStatus.OK);
	}
	
	@RequestMapping(value = "/travel/saveTraveList.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Map<String,Object>> insertTravelList(Locale locale,
			@RequestBody TraveDTO traveDTO)throws Exception{
		Map<String, Object> result = new HashMap<String, Object>();
		
		int resultCnt = travelService.saveDetailschedule(traveDTO);		
		result.put("success",(resultCnt > 0)?"N":"Y");
		
		return new ResponseEntity<Map<String,Object>>(result,HttpStatus.OK);
	}
	
	@RequestMapping(value = "/travel/clientPage.do",method = RequestMethod.GET)
	public String clientPage(Locale locale, Model model, HttpServletRequest request) throws Exception{
		HttpSession session = request.getSession();
		String userName = (String) session.getAttribute("userName");
		String userPhone = (String) session.getAttribute("userPhone");
		
		if(userName != null && userPhone != null) {
			ClientInfoVo loginInfo = new ClientInfoVo();
			loginInfo.setUserName(userName);
			loginInfo.setUserPhone(userPhone);
			
			ClientInfoVo resultInfo = travelService.selectClientInfo(loginInfo);
			int seq = Integer.parseInt(resultInfo.getSeq());
			String period = travelService.selectPeriod(seq);
			
			model.addAttribute("clientInfoVo", resultInfo);
			model.addAttribute("period", period);
			return "travel/clientPage";			
		}else {
			return "travel/login";
		}
	}
	
	@RequestMapping(value = "/travel/updateRequest.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Map<String,Object>> updateRequest(Locale locale,
			@RequestBody ReqUpdateDTO reqList) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		System.out.println(reqList.toString());
		
		//List<TraveInfoVo> traveList = new ArrayList();
		//traveList = reqList.getTraveList();
		
		int resultCnt = travelService.updateRequest(reqList);
		result.put("success", (resultCnt > 0)?"Y":"N");
		
		return new ResponseEntity<Map<String,Object>>(result,HttpStatus.OK);
	}
	
	@RequestMapping(value = "/travel/logout.do", method = RequestMethod.GET)
	public String logout(Locale locale, HttpSession session) throws Exception {
		try {
			session.invalidate();			
		}catch(Exception e) {
			e.printStackTrace();
		}		
		return "redirect:/travel/login.do";
	}
	
}
