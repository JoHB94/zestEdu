package com.spring.board.vo;

import java.util.List;

public class RecruitDTO {
	
	private RecruitVo recruitVo;
	private List<EducationVo> educationList;
	private List<CareerVo> careerList;
	private List<CertificateVo> certificateList;

	
	public RecruitVo getRecruitVo() {
		return recruitVo;
	}
	public void setRecruitVo(RecruitVo recruitVo) {
		this.recruitVo = recruitVo;
	}
	public List<EducationVo> getEducationList() {
		return educationList;
	}
	public void setEducationList(List<EducationVo> educationList) {
		this.educationList = educationList;
	}
	public List<CareerVo> getCareerList() {
		return careerList;
	}
	public void setCareerList(List<CareerVo> careerList) {
		this.careerList = careerList;
	}
	public List<CertificateVo> getCertificateList() {
		return certificateList;
	}
	public void setCertificateList(List<CertificateVo> certificateList) {
		this.certificateList = certificateList;
	}

	 
	 
	
	 
	 
}
