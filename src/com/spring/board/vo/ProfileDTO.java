package com.spring.board.vo;

import java.util.List;

public class ProfileDTO {	

	private String salary;
	private String location;
	private String workType;
	private EducationVo education;
	private String career;
	
	private RecruitVo recruitVo;
	private List<EducationVo> educationVo;
	private List<CareerVo> careerVo; 
	private List<CertificateVo> certificateVo;
	
	
	public String getSalary() {
		return salary;
	}
	public void setSalary(String salary) {
		this.salary = salary;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getWorkType() {
		return workType;
	}
	public void setWorkType(String workType) {
		this.workType = workType;
	}
	public EducationVo getEducation() {
		return education;
	}
	public void setEducation(EducationVo education) {
		this.education = education;
	}
	public String getCareer() {
		return career;
	}
	public void setCareer(String career) {
		this.career = career;
	}
	public RecruitVo getRecruitVo() {
		return recruitVo;
	}
	public void setRecruitVo(RecruitVo recruitVo) {
		this.recruitVo = recruitVo;
	}
	public List<EducationVo> getEducationVo() {
		return educationVo;
	}
	public void setEducationVo(List<EducationVo> educationVo) {
		this.educationVo = educationVo;
	}
	public List<CareerVo> getCareerVo() {
		return careerVo;
	}
	public void setCareerVo(List<CareerVo> careerVo) {
		this.careerVo = careerVo;
	}
	public List<CertificateVo> getCertificateVo() {
		return certificateVo;
	}
	public void setCertificateVo(List<CertificateVo> certificateVo) {
		this.certificateVo = certificateVo;
	}
	@Override
	public String toString() {
		return "ProfileDTO [salary=" + salary + ", location=" + location + ", workType=" + workType + ", education="
				+ education + ", career=" + career + ", recruitVo=" + recruitVo + ", educationVo=" + educationVo
				+ ", careerVo=" + careerVo + ", certificateVo=" + certificateVo + "]";
	}
	
	
	

	
	
}
