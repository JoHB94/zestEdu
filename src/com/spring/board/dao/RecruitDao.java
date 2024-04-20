package com.spring.board.dao;

import java.util.List;

import com.spring.board.vo.CareerVo;
import com.spring.board.vo.CertificateVo;
import com.spring.board.vo.EducationVo;
import com.spring.board.vo.ProfileDTO;
import com.spring.board.vo.RecruitVo;

public interface RecruitDao {
	
	public String getSeq(RecruitVo recruitVo) throws Exception;
	public String getCareerMonth(RecruitVo recruitVo)throws Exception;
	public EducationVo getSchoolYear(RecruitVo recruitVo)throws Exception;
	
	public List<ProfileDTO> selectProfile(RecruitVo recruitVo) throws Exception;
	
	public int recruitInsert(RecruitVo recruitVo) throws Exception;
	public int educationInsert(List<EducationVo> educationList) throws Exception;
	public int careerInsert(List<CareerVo> careerList) throws Exception;
	public int certificateInsert(List<CertificateVo> certificateList) throws Exception;   
	
	public RecruitVo selectRecruit(RecruitVo recruitVo) throws Exception;
	public List<EducationVo> selectEducation(RecruitVo recruitVo)throws Exception;
	public List<CareerVo> selectCareer(RecruitVo recruitVo) throws Exception;
	public List<CertificateVo> selectCertificate(RecruitVo recruitVo) throws Exception;	
	
	public int rcruitDelBySeq(String seq) throws Exception;
	public int eduDelBySeq(String seq) throws Exception;
	public int carDelBySeq(String seq) throws Exception;
	public int certDelBySeq(String seq) throws Exception;
}
