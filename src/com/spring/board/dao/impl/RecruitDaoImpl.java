package com.spring.board.dao.impl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.board.dao.RecruitDao;
import com.spring.board.vo.CareerVo;
import com.spring.board.vo.CertificateVo;
import com.spring.board.vo.EducationVo;
import com.spring.board.vo.ProfileDTO;
import com.spring.board.vo.RecruitVo;

@Repository
public class RecruitDaoImpl implements RecruitDao{
	
	@Autowired
	private SqlSession sqlSession;

	@Override
	public List<ProfileDTO> selectProfile(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("recruit.profile", recruitVo);
	}

	@Override
	public int recruitInsert(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("recruit.recruitInsert", recruitVo);
	}

	@Override
	public int educationInsert(List<EducationVo> educationList) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("recruit.educationInsert",educationList);
	}

	@Override
	public int careerInsert(List<CareerVo> careerList) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("recruit.careerInsert", careerList);
	}

	@Override
	public int certificateInsert(List<CertificateVo> certificateList) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("recruit.certificateInsert", certificateList);
	}


	@Override
	public RecruitVo selectRecruit(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("recruit.selectRecruit", recruitVo);
	}

	@Override
	public List<EducationVo> selectEducation(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("recruit.selectEducation", recruitVo);
	}

	@Override
	public List<CareerVo> selectCareer(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("recruit.selectCareer", recruitVo);
	}

	@Override
	public List<CertificateVo> selectCertificate(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("recruit.selectCertificate", recruitVo);
	}

	@Override
	public String getSeq(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("recruit.getSeq", recruitVo);
	}

	@Override
	public String getCareerMonth(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("recruit.getCareerMonth", recruitVo);
	}

	@Override
	public EducationVo getSchoolYear(RecruitVo recruitVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("recruit.getSchoolYear", recruitVo);
	}

	@Override
	public int eduDelBySeq(String seq) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.delete("recruit.eduDelBySeq", seq);
	}

	@Override
	public int carDelBySeq(String seq) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.delete("recruit.carDelBySeq", seq);
	}

	@Override
	public int certDelBySeq(String seq) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.delete("recruit.certDelBySeq", seq);
	}

	@Override
	public int rcruitDelBySeq(String seq) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.delete("recruit.recruitDelBySeq", seq);
	}

}
