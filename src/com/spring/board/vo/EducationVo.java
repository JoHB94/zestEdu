package com.spring.board.vo;

public class EducationVo {
	
	private String schoolName;
	private String division;
	private String startPeriod;
	private String endPeriod;
	private String major;
	private String grade;
	private String location;
	
	private String academicYears;
	private String seq;
	private String eduSeq;
	
	

	
	
	public String getEduSeq() {
		return eduSeq;
	}

	public void setEduSeq(String eduSeq) {
		this.eduSeq = eduSeq;
	}

	public String getAcademicYears() {
		return academicYears;
	}

	public void setAcademicYears(String academicYears) {
		this.academicYears = academicYears;
	}

	public String getSchoolName() {
		return schoolName;
	}

	public void setSchoolName(String schoolName) {
		this.schoolName = schoolName;
	}

	public String getDivision() {
		return division;
	}

	public void setDivision(String division) {
		this.division = division;
	}

	public String getStartPeriod() {
		return startPeriod;
	}

	public void setStartPeriod(String startPeriod) {
		this.startPeriod = startPeriod;
	}

	public String getEndPeriod() {
		return endPeriod;
	}

	public void setEndPeriod(String endPeriod) {
		this.endPeriod = endPeriod;
	}

	public String getMajor() {
		return major;
	}

	public void setMajor(String major) {
		this.major = major;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}

	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	@Override
	public String toString() {
		return "EducationVo [schoolName=" + schoolName + ", division=" + division + ", startPeriod=" + startPeriod
				+ ", endPeriod=" + endPeriod + ", major=" + major + ", grade=" + grade + ", location=" + location
				+ ", academicYears=" + academicYears + ", seq=" + seq + ", eduSeq=" + eduSeq + "]";
	}

	
	
	
	
}
