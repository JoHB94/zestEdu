package com.spring.board.dao.impl;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.board.dao.UserInfoDao;
import com.spring.board.vo.UserInfoVo;

@Repository
public class UserInfoDaoImpl implements UserInfoDao{
	
	@Autowired
	private SqlSession sqlSession;
	

	@Override
	public int checkId(UserInfoVo userInfoVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("userInfo.checkId", userInfoVo);
	}

	@Override
	public int userInsert(UserInfoVo userInfoVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("userInfo.userInsert", userInfoVo);
	}

	@Override
	public UserInfoVo login(UserInfoVo userInfoVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("userInfo.login", userInfoVo);
	}

}
