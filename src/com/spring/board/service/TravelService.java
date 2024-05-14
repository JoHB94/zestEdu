package com.spring.board.service;

import java.util.List;

import com.spring.board.vo.ClientInfoVo;
import com.spring.board.vo.ReqUpdateDTO;
import com.spring.board.vo.TraveDTO;
import com.spring.board.vo.TraveInfoVo;

public interface TravelService {
	
	public boolean isExistMember(ClientInfoVo clientInfoVo) throws Exception;
	public int insertClient(ClientInfoVo clientInfoVo)throws Exception;
	public List<ClientInfoVo> selectClientList() throws Exception;
	
	public String selectPeriod(int seq) throws Exception;
	public List<TraveInfoVo> selectTraveListBySeqAndDay(TraveInfoVo traveInfoVo) throws Exception;
	public int saveDetailschedule(TraveDTO traveDTO)throws Exception;
	
	public ClientInfoVo selectClientInfo(ClientInfoVo clientInfoVo) throws Exception;	
	public int updateRequest(ReqUpdateDTO updateList) throws Exception;
	
	public double calTotalTransFee(ClientInfoVo clientInfoVo) throws Exception;
}
