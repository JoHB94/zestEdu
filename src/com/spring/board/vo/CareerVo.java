package com.spring.board.vo;

public class CareerVo {
	
	private String compName;
	private String location;
	private String startPeriod;
	private String endPeriod;
	private String task;
	private String salary;
	
	private String seq;
	private String carSeq;
	private String careerMonth;
	

	@Override
	public String toString() {
		return "CareerVo [compName=" + compName + ", location=" + location + ", startPeriod=" + startPeriod
				+ ", endPeriod=" + endPeriod + ", task=" + task + ", salary=" + salary + ", seq=" + seq + ", carSeq="
				+ carSeq + ", careerMonth=" + careerMonth + "]";
	}

	public String getCarSeq() {
		return carSeq;
	}

	public void setCarSeq(String carSeq) {
		this.carSeq = carSeq;
	}

	public String getCareerMonth() {
		return careerMonth;
	}

	public void setCareerMonth(String careerMonth) {
		this.careerMonth = careerMonth;
	}

	public String getCompName() {
		return compName;
	}

	public void setCompName(String compName) {
		this.compName = compName;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
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

	public String getTask() {
		return task;
	}

	public void setTask(String task) {
		this.task = task;
	}

	public String getSalary() {
		return salary;
	}

	public void setSalary(String salary) {
		this.salary = salary;
	}

	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}


	
}
