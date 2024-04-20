package com.spring.board.service;

import java.util.List;
import java.util.Map;

import com.spring.board.vo.CareerVo;
import com.spring.board.vo.CertificateVo;
import com.spring.board.vo.EducationVo;
import com.spring.board.vo.ProfileDTO;
import com.spring.board.vo.RecruitDTO;
import com.spring.board.vo.RecruitVo;

public interface RecruitService {
	
	public ProfileDTO selectProfile(RecruitVo recruitVo) throws Exception;
	public boolean isExistMember(RecruitVo recruitVo)throws Exception;
	
	public RecruitVo selectRecruit(RecruitVo recruitVo) throws Exception;
	public List<EducationVo> selectEducation(RecruitVo recruitVo)throws Exception;
	public List<CareerVo> selectCareer(RecruitVo recruitVo) throws Exception;
	public List<CertificateVo> selectCertificate(RecruitVo recruitVo) throws Exception;
	
//	public int recruitInsertSave(RecruitVo recruitVo,List<EducationVo> educationList
//			,List<CareerVo> careerList,List<CertificateVo> certificateList) throws Exception;
//	
//	public int recruitInsertSubmit(RecruitVo recruitVo,List<EducationVo> educationList
//			,List<CareerVo> careerList,List<CertificateVo> certificateList) throws Exception;
	
//	public int recruitUpdateSave(RecruitVo recruitVo,List<EducationVo> educationList
//			,List<CareerVo> careerList,List<CertificateVo> certificateList
//			,List<String> delEduSeqList,List<String> delCarSeqList,List<String> delCertSeqList) throws Exception;
//	
//	public int recruitUpdateSubmit(RecruitVo recruitVo,List<EducationVo> educationList
//			,List<CareerVo> careerList,List<CertificateVo> certificateList
//			,List<String> delEduSeqList,List<String> delCarSeqList,List<String> delCertSeqList) throws Exception;
	
	public Map<Integer,String> recruitWriteSave(RecruitDTO recruitDTO)throws Exception;
	public Map<Integer,String> recruitWriteSubmit(RecruitDTO recruitDTO)throws Exception;
	
}
