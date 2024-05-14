package com.spring.board.dao;

import java.util.List;

import com.spring.board.vo.ClientInfoVo;
import com.spring.board.vo.TraveClientInfoDTO;
import com.spring.board.vo.TraveInfoVo;

public interface TravelDao {
	
	public String getSeq(ClientInfoVo clientInfoVo) throws Exception;
	public int insertClient(ClientInfoVo clientInfoVo) throws Exception;
	public List<ClientInfoVo> selectAllClientList() throws Exception;
	
	public String selectPeriodBySeq(int seq) throws Exception;
	public List<TraveInfoVo> selectTraveListBySeqAndDay(TraveInfoVo traveInfoVo) throws Exception;
	public int delTraveBySeqAndDay(TraveInfoVo traveInfoVo) throws Exception;
	public int insertTraveList(List<TraveInfoVo> traveInfoList) throws Exception;
	public ClientInfoVo selectClientInfo(ClientInfoVo clientInfoVo) throws Exception;
	public int updateRequest(String seq) throws Exception;
	public String selectSumExpend(ClientInfoVo clientInfoVo) throws Exception;
	public List<TraveClientInfoDTO> getTCList(ClientInfoVo clientInfoVo)throws Exception; 
}
