package com.spring.board.service.impl;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.spring.board.dao.RecruitDao;
import com.spring.board.service.RecruitService;
import com.spring.board.vo.CareerVo;
import com.spring.board.vo.CertificateVo;
import com.spring.board.vo.EducationVo;
import com.spring.board.vo.ProfileDTO;
import com.spring.board.vo.RecruitDTO;
import com.spring.board.vo.RecruitVo;

@Service
public class RecruitServiceImpl implements RecruitService{
	
	@Autowired
	PlatformTransactionManager transactionManager;
	
	@Autowired
	RecruitDao recruitDao;

	@Override
	public ProfileDTO selectProfile(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		ProfileDTO profileDTO = new ProfileDTO();
		RecruitVo resultRecruit = recruitDao.selectRecruit(recruitVo);
		List<EducationVo> resultEducation = recruitDao.selectEducation(recruitVo);
		List<CareerVo> resultCareer = recruitDao.selectCareer(recruitVo);
		List<CertificateVo> resultCertificate = recruitDao.selectCertificate(recruitVo);
		
		profileDTO.setRecruitVo(resultRecruit);
		profileDTO.setEducationVo(resultEducation);
		profileDTO.setEducation(recruitDao.getSchoolYear(recruitVo));
		profileDTO.setWorkType(resultRecruit.getWorkType());
		profileDTO.setLocation(resultRecruit.getLocation());
		profileDTO.setSalary("ȸ�� ���Կ� ����");
		
		if(resultCareer.size() != 0) {
			
			profileDTO.setCareerVo(resultCareer);
			profileDTO.setCareer(recruitDao.getCareerMonth(recruitVo));
		}
		if(resultCertificate.size() != 0) {
			profileDTO.setCertificateVo(resultCertificate);
		}
		
		
		return profileDTO;
	}

	@Override
	public RecruitVo selectRecruit(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return recruitDao.selectRecruit(recruitVo);
	}

	@Override
	public List<EducationVo> selectEducation(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return recruitDao.selectEducation(recruitVo);
	}

	@Override
	public List<CareerVo> selectCareer(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return recruitDao.selectCareer(recruitVo);
	}

	@Override
	public List<CertificateVo> selectCertificate(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return recruitDao.selectCertificate(recruitVo);
	}

//	@Override
//	public int recruitInsertSave(RecruitVo recruitVo,List<EducationVo> educationList
//			,List<CareerVo> careerList,List<CertificateVo> certificateList) throws Exception {
//		// TODO Auto-generated method stub
//		TransactionDefinition def = new DefaultTransactionDefinition();
//		TransactionStatus status = transactionManager.getTransaction(def);
//		
//		recruitVo.setSubmit("N");
//		System.out.println(recruitVo.toString());
//
//		try {
//			System.out.println("try�� ����!");
//			recruitDao.recruitInsert(recruitVo);
//			String seq = recruitDao.getSeq(recruitVo);
//
//			for(int i=0; i < educationList.size(); i ++) {
//				educationList.get(i).setSeq(seq);
//				System.out.println(educationList.get(i).toString());
//			}
//			
//			recruitDao.educationInsert(educationList);
//			System.out.println("educationList ���� �Ϸ�");
//			
//			if(careerList.size() != 0) {
//				for(int i=0; i < careerList.size(); i++) {
//					careerList.get(i).setSeq(seq);
//				}
//				recruitDao.careerInsert(careerList);
//				System.out.println("careerList ���� �Ϸ�");
//			}
//			if(certificateList.size() != 0) {
//				for(int i=0; i < certificateList.size(); i++) {
//					certificateList.get(i).setSeq(seq);
//				}
//				recruitDao.certificateInsert(certificateList);
//				System.out.println("certificateList ���� �Ϸ�");
//			}
//			transactionManager.commit(status);
//			System.out.println("Ʈ����� �� Ŀ�� ���� �Ϸ�");
//			return 0;
//		} catch(Exception e) {
//			transactionManager.rollback(status);
//			System.out.println("�ѹ�!");
//			return 1;
//		}
//			
//	}
//
//
//	@Override
//	public int recruitInsertSubmit(RecruitVo recruitVo,List<EducationVo> educationList
//			,List<CareerVo> careerList,List<CertificateVo> certificateList) throws Exception {
//		// TODO Auto-generated method stub
//		TransactionDefinition def = new DefaultTransactionDefinition();
//		TransactionStatus status = transactionManager.getTransaction(def);
//		
//		recruitVo.setSubmit("Y");
//
//		try {
//			System.out.println("try�� ����!");
//			recruitDao.recruitInsert(recruitVo);
//			String seq = recruitDao.getSeq(recruitVo);
//
//			for(int i=0; i < educationList.size(); i ++) {
//				educationList.get(i).setSeq(seq);
//				System.out.println(educationList.get(i).toString());
//			}
//			
//			recruitDao.educationInsert(educationList);
//			System.out.println("educationList ���� �Ϸ�");
//			
//			if(careerList.size() != 0) {
//				for(int i=0; i < careerList.size(); i++) {
//					careerList.get(i).setSeq(seq);
//				}
//				recruitDao.careerInsert(careerList);
//				System.out.println("careerList ���� �Ϸ�");
//			}
//			if(certificateList.size() != 0) {
//				for(int i=0; i < certificateList.size(); i++) {
//					certificateList.get(i).setSeq(seq);
//				}
//				recruitDao.certificateInsert(certificateList);
//				System.out.println("certificateList ���� �Ϸ�");
//			}
//			transactionManager.commit(status);
//			System.out.println("Ʈ����� �� Ŀ�� ���� �Ϸ�");
//			return 0;
//		} catch(Exception e) {
//			transactionManager.rollback(status);
//			System.out.println("�ѹ�!");
//			return 1;
//		}
//	}
	
//	public void deleteArrays(List<String> delEduSeqList,List<String> delCarSeqList,List<String> delCertSeqList) throws Exception {
//		if(delEduSeqList.size() > 0) {
//			System.out.println("���� edu List ����" + delEduSeqList.toString());
//			recruitDao.deleteEducation(delEduSeqList);
//		}
//		if(delCarSeqList.size() > 0) {
//			System.out.println("���� car List ����");
//			recruitDao.deleteCareer(delCarSeqList);
//		}
//		if(delCertSeqList.size() > 0) {
//			System.out.println("���� cert List ����");
//			recruitDao.deleteCertificate(delCertSeqList);
//		}		
//	}
//	
//	public void eduInsertOrUpdate(List<EducationVo> educationList)throws Exception {
//		
//		List<EducationVo> insertEduList = new ArrayList<EducationVo>();
//		List<EducationVo> updateEduList = new ArrayList<EducationVo>();
//		
//		for (EducationVo education : educationList) {
//			System.out.println("eduSeq: " + education.getEduSeq());
//		    if (education.getEduSeq() != null || !education.getEduSeq().isEmpty()) {
//		    	System.out.println("updateList�� �߰�: " + education.getEduSeq());
//		        updateEduList.add(education);
//		    }
//		    if (education.getEduSeq() == null || education.getEduSeq().isEmpty()) {
//		    	System.out.println("insertList�� �߰�");
//		        insertEduList.add(education);
//		    } 
//		}
//
//		if (!insertEduList.isEmpty()) {
//		    recruitDao.educationInsert(insertEduList);
//		}
//		if (!updateEduList.isEmpty()) {
//		    recruitDao.educationUpdate(updateEduList);
//		}
//		System.out.println("educationList ���� �Ϸ�");
//	}
//	
//	public void carInsertOrUpdate(List<CareerVo> careerList)throws Exception {
//		
//	    List<CareerVo> insertList = new ArrayList<CareerVo>();
//	    List<CareerVo> updateList = new ArrayList<CareerVo>();
//	    for (CareerVo career : careerList) {	        
//	        if (career.getCarSeq() != null || !career.getCarSeq().isEmpty()) {
//	            updateList.add(career);
//	        }
//	        if (career.getCarSeq() == null || career.getCarSeq().isEmpty()) {
//	            insertList.add(career);
//	        }
//	    }
//
//	    if (!insertList.isEmpty()) {
//	        recruitDao.careerInsert(insertList);
//	    }
//	    if (!updateList.isEmpty()) {
//	        recruitDao.careerUpdate(updateList);
//	    }
//	    System.out.println("careerList ���� �Ϸ�");
//	}
//	
//	public void certInsertOrUpdate(List<CertificateVo> certificateList)throws Exception{
//		
//		List<CertificateVo> insertList = new ArrayList<CertificateVo>();
//		List<CertificateVo> updateList = new ArrayList<CertificateVo>();
//		for (CertificateVo certificate : certificateList) {		       
//		       if (certificate.getCertSeq() != null || !certificate.getCertSeq().isEmpty()) {
//		    	   updateList.add(certificate);
//		       }
//		       if (certificate.getCertSeq() == null || certificate.getCertSeq().isEmpty()) {
//		           insertList.add(certificate);
//		       }
//		}
//
//		if(!insertList.isEmpty()) {
//			recruitDao.certificateInsert(insertList);				
//		}
//		if(!updateList.isEmpty()) {
//			recruitDao.certificateUpdate(updateList);				
//		}		
//		System.out.println("certificateList ���� �Ϸ�");
//	}
//	
//	
//
//	@Override
//	public int recruitUpdateSave(
//			RecruitVo recruitVo,List<EducationVo> educationList,List<CareerVo> careerList,List<CertificateVo> certificateList
//			,List<String> delEduSeqList,List<String> delCarSeqList,List<String> delCertSeqList) throws Exception {
//		// TODO Auto-generated method stub
//		TransactionDefinition def = new DefaultTransactionDefinition();
//		TransactionStatus status = transactionManager.getTransaction(def);
//		
//		recruitVo.setSubmit("N");
//		System.out.println("recruitVo: " + recruitVo.toString());
//					
//		try {
//			System.out.println("try�� ����!");
//			System.out.println(recruitVo.toString()); 
//			recruitDao.recruitUpdate(recruitVo);
//			System.out.println("recruit ���� �Ϸ�");
//			//DELETE ���� �޼ҵ�
//			deleteArrays(delEduSeqList,delCarSeqList,delCertSeqList);
//			//EDUCATION ���� �޼ҵ�
//			eduInsertOrUpdate(educationList);
//			//CAREER ���� �޼ҵ�
//			if(careerList != null) {
//				carInsertOrUpdate(careerList);				
//			}
//			//CERTIFICATE ���� �޼ҵ�
//			if(certificateList != null) {
//				certInsertOrUpdate(certificateList);				
//			}
//			transactionManager.commit(status);
//			System.out.println("Ʈ����� �� Ŀ�� ���� �Ϸ�");
//			return 0;
//			
//		} catch(Exception e) {
//			transactionManager.rollback(status);
//			System.out.println("�ѹ�!");
//			return -1;
//		}
//		
//	}
//
//
//	@Override
//	public int recruitUpdateSubmit(RecruitVo recruitVo,List<EducationVo> educationList
//			,List<CareerVo> careerList,List<CertificateVo> certificateList
//			,List<String> delEduSeqList,List<String> delCarSeqList,List<String> delCertSeqList) throws Exception {
//		// TODO Auto-generated method stub
//		TransactionDefinition def = new DefaultTransactionDefinition();
//		TransactionStatus status = transactionManager.getTransaction(def);
//		
//		recruitVo.setSubmit("Y");
//		
//		try {
//			recruitDao.recruitUpdate(recruitVo);
//			//DELETE ���� �޼ҵ�
//			deleteArrays(delEduSeqList,delCarSeqList,delCertSeqList);
//			//EDUCATION ���� �޼ҵ�
//			eduInsertOrUpdate(educationList);
//			//CAREER ���� �޼ҵ�
//			if(careerList != null) {
//				carInsertOrUpdate(careerList);				
//			}
//			//CERTIFICATE ���� �޼ҵ�
//			if(certificateList != null) {
//				certInsertOrUpdate(certificateList);				
//			}
//
//			transactionManager.commit(status);
//			return 0;
//		} catch(Exception e) {
//			transactionManager.rollback(status);
//			return 1;
//		}
//		
//	}

	@Override
	public boolean isExistMember(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		String seq = recruitDao.getSeq(recruitVo);
		if(seq == null) {
			return false;	
		}else {
			return true;
		}
	}

	@Override
	public Map<Integer,String> recruitWriteSave(RecruitDTO recruitDTO) throws Exception {
		// TODO Auto-generated method stub
		TransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		
		RecruitVo recruitVo = recruitDTO.getRecruitVo();
		List<EducationVo> educationList = recruitDTO.getEducationList();
		List<CareerVo> careerList = recruitDTO.getCareerList();
		List<CertificateVo> certificateList = recruitDTO.getCertificateList();
		
		Map<Integer,String> result = new HashMap<Integer, String>();
		
		String seq = "";
		recruitVo.setSubmit("N");
		System.out.println("setSubmit ����: " + recruitVo.toString());
		try {
			//���� recruit�� DB������ �����ϴ��� Ȯ��.
			boolean isExistMember= isExistMember(recruitVo);
			if(isExistMember) {
				//DB�� ���� ���� �����ϴ� ��� Vo�� seq���� �����ϱ� ������				
				seq = recruitVo.getSeq();
				if(certificateList.size() != 0) {
					recruitDao.certDelBySeq(seq);	
				}
				if(careerList.size() != 0) {
					recruitDao.carDelBySeq(seq);
				}
				recruitDao.eduDelBySeq(seq);
				recruitDao.rcruitDelBySeq(seq);
				
				recruitDao.recruitInsert(recruitVo);
				recruitDao.educationInsert(educationList);
				if(careerList.size() != 0) {
					recruitDao.careerInsert(careerList);
				}
				if(certificateList.size() != 0) {
					recruitDao.certificateInsert(certificateList);
				}
				
			}else {
				//DB�� ���尪�� �������� �ʴ� ���
				recruitDao.recruitInsert(recruitVo);
				seq = recruitDao.getSeq(recruitVo);
				
				for(int i=0; i<educationList.size(); i++) {
					educationList.get(i).setSeq(seq);
				}
				recruitDao.educationInsert(educationList);
				
				for(int i=0; i<careerList.size(); i++) {
					careerList.get(i).setSeq(seq);
				}
				if(careerList.size() != 0) {
					recruitDao.careerInsert(careerList);
				}
				
				for(int i=0; i<certificateList.size(); i++) {
					certificateList.get(i).setSeq(seq);
				}
				if(certificateList.size() != 0) {
					recruitDao.certificateInsert(certificateList);
				}						
			}
			transactionManager.commit(status);
			result.put(0, recruitVo.getSubmit());
			return result;
		}catch (Exception e) {
			// TODO: handle exception
			transactionManager.rollback(status);
			result.put(1, recruitVo.getSubmit());
			return result;
		}
		
	}

	@Override
	public Map<Integer,String> recruitWriteSubmit(RecruitDTO recruitDTO) throws Exception {
		// TODO Auto-generated method stub
		TransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		
		RecruitVo recruitVo = recruitDTO.getRecruitVo();
		List<EducationVo> educationList = recruitDTO.getEducationList();
		List<CareerVo> careerList = recruitDTO.getCareerList();
		List<CertificateVo> certificateList = recruitDTO.getCertificateList();
		
		Map<Integer,String> result = new HashMap<Integer, String>();
		
		String seq = "";
		recruitVo.setSubmit("Y");
		
		try {
			//���� recruit�� DB������ �����ϴ��� Ȯ��.
			boolean isExistMember= isExistMember(recruitVo);
			if(isExistMember) {
				//DB�� ���� ���� �����ϴ� ��� Vo�� seq���� �����ϱ� ������
				seq = recruitVo.getSeq();
				if(certificateList.size() != 0) {
					recruitDao.certDelBySeq(seq);	
				}
				if(careerList.size() != 0) {
					recruitDao.carDelBySeq(seq);
				}
				recruitDao.eduDelBySeq(seq);
				recruitDao.rcruitDelBySeq(seq);
				
				recruitDao.recruitInsert(recruitVo);
				recruitDao.educationInsert(educationList);
				if(careerList.size() != 0) {
					recruitDao.careerInsert(careerList);
				}
				if(certificateList.size() != 0) {
					recruitDao.certificateInsert(certificateList);
				}
			}else {
				//DB�� ���尪�� �������� �ʴ� ���
				recruitDao.recruitInsert(recruitVo);
				seq = recruitDao.getSeq(recruitVo);
				
				for(int i=0; i<educationList.size(); i++) {
					educationList.get(i).setSeq(seq);
				}
				recruitDao.educationInsert(educationList);
				
				for(int i=0; i<careerList.size(); i++) {
					careerList.get(i).setSeq(seq);
				}
				if(careerList.size() != 0) {
					recruitDao.careerInsert(careerList);
				}
				
				for(int i=0; i<certificateList.size(); i++) {
					certificateList.get(i).setSeq(seq);
				}
				if(certificateList.size() != 0) {
					recruitDao.certificateInsert(certificateList);
				}				
			}
			transactionManager.commit(status);
			result.put(0, recruitVo.getSubmit());
			return result;
		}catch (Exception e) {
			// TODO: handle exception
			transactionManager.rollback(status);
			result.put(1, recruitVo.getSubmit());
			return result;
		}
	}

}
