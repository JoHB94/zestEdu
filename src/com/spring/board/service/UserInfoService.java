package com.spring.board.service;

import com.spring.board.vo.UserInfoVo;

public interface UserInfoService {
	
	public int checkId(UserInfoVo userInfoVo) throws Exception;
	
	public int userInsert(UserInfoVo userInfoVo) throws Exception;
	
	public UserInfoVo login(UserInfoVo userInfoVo) throws Exception;
}
