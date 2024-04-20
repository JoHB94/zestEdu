package com.spring.board.controller;

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
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.board.HomeController;
import com.spring.board.service.RecruitService;
import com.spring.board.vo.CareerVo;
import com.spring.board.vo.CertificateVo;
import com.spring.board.vo.EducationVo;
import com.spring.board.vo.ProfileDTO;
import com.spring.board.vo.RecruitDTO;
import com.spring.board.vo.RecruitVo;
import com.spring.common.CommonUtil;

@Controller
public class RecruitController {
	
	@Autowired
	RecruitService recruitService;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping(value = "/recruit/login.do", method = RequestMethod.GET)
	public String recruitLogin(Locale locale) throws Exception {
		
		return "recruit/login";
	}
	
	@RequestMapping(value = "/recruit/recruitWrite.do", method = RequestMethod.GET)
	public String recruitWrite(Locale locale) throws Exception {
				
		return "recruit/recruitWrite";
	}
	
	@RequestMapping(value = "/recruit/recruitUpdate.do", method = RequestMethod.GET)
	public String recruitUpdate(Locale locale,Model model,RecruitVo recruitVo,
			HttpServletRequest request) throws Exception {
		
		HttpSession session = request.getSession();
		recruitVo.setName((String)session.getAttribute("name"));
		recruitVo.setPhone((String)session.getAttribute("phone"));
		System.out.println("**********recruitVo ***********" + recruitVo.toString());
		ProfileDTO profile = recruitService.selectProfile(recruitVo);
		
		RecruitVo savedRecruit = profile.getRecruitVo();
		List<EducationVo> savedEducation = profile.getEducationVo();
		List<CareerVo> savedCareer = profile.getCareerVo();
		List<CertificateVo> savedCertificate = profile.getCertificateVo();
		
		for(int i=0; i < savedEducation.size(); i++) {
			System.out.println(savedEducation.get(i).toString());
		}
		
		model.addAttribute("profile",profile);
		model.addAttribute("savedRecruit",savedRecruit);
		model.addAttribute("savedEducation",savedEducation);
		model.addAttribute("savedCareer",savedCareer);
		model.addAttribute("savedCertificate",savedCertificate);
		
		return "recruit/recruitUpdate";
	}
	
	@RequestMapping(value = "/recruit/loginAction.do", method = RequestMethod.POST)
	@ResponseBody
	public ResponseEntity<Map<String,Object>> loginAction(Locale locale,RecruitVo recruitVo
			,HttpServletRequest request) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		boolean isMember = recruitService.isExistMember(recruitVo);
		
		HttpSession session = request.getSession();
		session.setAttribute("name", recruitVo.getName());
		session.setAttribute("phone", recruitVo.getPhone());

		result.put("isMember", isMember);
		
		return new ResponseEntity<Map<String,Object>>(result, HttpStatus.OK);
	
	}
	
//	@RequestMapping(value = "/recruit/insertSave.do", method = RequestMethod.POST ,consumes = MediaType.APPLICATION_JSON_VALUE)
//	@ResponseBody
//	public String recruitInsertSave(Locale locale
//			,@RequestBody RecruitDTO recruitDTO) throws Exception {
//		Map<String, Object> result = new HashMap<String, Object>();
//		RecruitVo recruitVo = recruitDTO.getRecruitVo();
//		List<EducationVo> educationList = recruitDTO.getEducationList();
//		List<CareerVo> careerList = recruitDTO.getCareerList();
//		List<CertificateVo> certificateList = recruitDTO.getCertificateList();
//		
//		int resultCnt = recruitService.recruitInsertSave(recruitVo, educationList, careerList, certificateList);
//		CommonUtil commonUtil = new CommonUtil();
//		
//		result.put("success", (resultCnt > 0)?"N":"Y");
//		System.out.println("resultCnt: " + resultCnt);
//		System.out.println("success: " + result.get("success"));
//		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);
//		
//		return callbackMsg;
//	}
//	
//	@RequestMapping(value = "/recruit/insertSubmit.do", method = RequestMethod.POST ,consumes = MediaType.APPLICATION_JSON_VALUE)
//	@ResponseBody
//	public String recruitInsertSubmit(Locale locale
//			,@RequestBody RecruitDTO recruitDTO) throws Exception {
//		Map<String, Object> result = new HashMap<String, Object>();
//		RecruitVo recruitVo = recruitDTO.getRecruitVo();
//		List<EducationVo> educationList = recruitDTO.getEducationList();
//		List<CareerVo> careerList = recruitDTO.getCareerList();
//		List<CertificateVo> certificateList = recruitDTO.getCertificateList();
//		int resultCnt = recruitService.recruitInsertSubmit(recruitVo, educationList, careerList, certificateList);
//		CommonUtil commonUtil = new CommonUtil();
//		
//		result.put("success", (resultCnt < 0)?"N":"Y");
//		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);
//		
//		return callbackMsg;
//	}
	
//	@RequestMapping(value = "/recruit/updateSave.do", method = RequestMethod.POST)
//	@ResponseBody
//	public String recruitUpdateSave(Locale locale
//			,@RequestBody RecruitDTO recruitDTO) throws Exception {
//		System.out.println(recruitDTO.toString());
//		Map<String, Object> result = new HashMap<String, Object>();
//		
//		RecruitVo recruitVo = recruitDTO.getRecruitVo();
//		List<EducationVo> educationList = recruitDTO.getEducationList();
//		List<CareerVo> careerList = recruitDTO.getCareerList();
//		List<CertificateVo> certificateList = recruitDTO.getCertificateList();
//		
//		List<String> delEduSeqList = recruitDTO.getDelEducationSeqList();
//		List<String> delCarSeqList = recruitDTO.getDelCareerSeqList();
//		List<String> delCertSeqList = recruitDTO.getDelCertificateList();
//		
//		int resultCnt = recruitService.recruitUpdateSave(
//				recruitVo, educationList, careerList, certificateList,
//				delEduSeqList,delCarSeqList,delCertSeqList);
//		CommonUtil commonUtil = new CommonUtil();
//		
//		result.put("success", (resultCnt < 0)?"N":"Y");
//		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);
//		
//		return callbackMsg;
//	}
	
	@RequestMapping(value = "/recruit/updateSave.do", method = RequestMethod.POST)
	@ResponseBody
	public String recruitUpdateSave(Locale locale, Model model
			,@RequestBody RecruitDTO recruitDTO) throws Exception {
		System.out.println(recruitDTO.toString());
		Map<Integer, String> result = new HashMap<Integer, String>();
		RecruitVo recruitVo = recruitDTO.getRecruitVo();
		
		result = recruitService.recruitWriteSave(recruitDTO);
		
		CommonUtil commonUtil = new CommonUtil();
		//result의 key가 0이면 성공 1이면 실패, value : submit값
		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);
		
		return callbackMsg;
	}
	
	@RequestMapping(value = "/recruit/updateSubmit.do", method = RequestMethod.POST)
	@ResponseBody
	public String recruitUpdateSubmit(Locale locale
			,@RequestBody RecruitDTO recruitDTO) throws Exception {
		System.out.println(recruitDTO.toString());
		Map<Integer, String> result = new HashMap<Integer, String>();
		RecruitVo recruitVo = recruitDTO.getRecruitVo();
		
		result = recruitService.recruitWriteSubmit(recruitDTO);
		
		CommonUtil commonUtil = new CommonUtil();
		//result의 key가 0이면 성공 1이면 실패, value : submit값
		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);
		
		return callbackMsg;
	}
	
	@RequestMapping(value = "/recruit/logout.do", method = RequestMethod.GET)
	public String logout(Locale locale, HttpSession session) throws Exception {
		try {
			session.invalidate();			
		}catch(Exception e) {
			e.printStackTrace();
		}		
		return "redirect:/recruit/login.do";
	}
	
	//******************mk test code **************************
	
	 @RequestMapping(value = "/recruit/main.do", method = RequestMethod.GET)
	   public String recruitMain(HttpServletRequest request) throws Exception {
	      
	      return "recruit/main";
	   }
	 
	  @RequestMapping(value = "/recruit/mainSubmit.do", method = RequestMethod.POST)
	  @ResponseBody 
	  public String recruitSubmit(Locale locale,@RequestBody RecruitDTO sendData) throws Exception {
	      RecruitVo recruitData = sendData.getRecruitVo();
	       List<EducationVo> educationDataArray = sendData.getEducationList();
	       List<CareerVo> careerDataArray = sendData.getCareerList();
	       List<CertificateVo> certificateDataArray = sendData.getCertificateList();
	       
	       System.out.println("호출===========================================================");
	       System.out.println("Recruit Data: " + recruitData);
	       System.out.println("Education Data: " + educationDataArray);
	       System.out.println("Career Data: " + careerDataArray);
	       System.out.println("Certificate Data: " + certificateDataArray);
	       
	       HashMap<String, String> result = new HashMap<String, String>(); 
	       CommonUtil commonUtil = new CommonUtil();
	       int resultCnt = 1;
	       result.put("success", (resultCnt > 0)?"Y":"N"); 
	       String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
	       
	       
	       return callbackMsg;
	   }
 



}
