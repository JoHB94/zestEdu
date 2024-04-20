package com.spring.board.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.board.dao.UserInfoDao;
import com.spring.board.service.UserInfoService;
import com.spring.board.vo.UserInfoVo;

@Service
public class UserInfoServiceImpl implements UserInfoService{
	
	@Autowired
	UserInfoDao userInfoDao;
	
	@Override
	public int checkId(UserInfoVo userInfoVo) throws Exception {
		// TODO Auto-generated method stub
		return userInfoDao.checkId(userInfoVo);
	}

	@Override
	public int userInsert(UserInfoVo userInfoVo) throws Exception {
		// TODO Auto-generated method stub
		return userInfoDao.userInsert(userInfoVo);
	}

	@Override
	public UserInfoVo login(UserInfoVo userInfoVo) throws Exception {
		// TODO Auto-generated method stub
		return userInfoDao.login(userInfoVo);
	}

}
