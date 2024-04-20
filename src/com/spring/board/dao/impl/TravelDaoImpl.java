package com.spring.board.dao.impl;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.spring.board.dao.TravelDao;
import com.spring.board.vo.ClientInfoVo;
import com.spring.board.vo.TraveInfoVo;

@Repository
public class TravelDaoImpl implements TravelDao{
	
	@Autowired
	private SqlSession sqlSession;

	@Override
	public String getSeq(ClientInfoVo clientInfoVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("travel.getSeq", clientInfoVo);
	}

	@Override
	public int insertClient(ClientInfoVo clientInfoVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("travel.insertClient", clientInfoVo);
	}

	@Override
	public List<ClientInfoVo> selectAllClientList() throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("travel.selectAllClientList");
	}

	@Override
	public String selectPeriodBySeq(int seq) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("travel.selectPeriodBySeq", seq);
	}

	@Override
	public List<TraveInfoVo> selectTraveListBySeqAndDay(TraveInfoVo traveInfoVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectList("travel.selectTraveListBySeqAndDay", traveInfoVo);
	}

	@Override
	public int delTraveBySeqAndDay(TraveInfoVo traveInfoVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.delete("travel.delTraveBySeqAndDay", traveInfoVo);
	}

	@Override
	public int insertTraveList(List<TraveInfoVo> traveInfoList) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.insert("travel.insertTraveList", traveInfoList);
	}

	@Override
	public ClientInfoVo selectClientInfo(ClientInfoVo clientInfoVo) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.selectOne("travel.selectClientInfo", clientInfoVo);
	}

	@Override
	public int updateRequest(int seq) throws Exception {
		// TODO Auto-generated method stub
		return sqlSession.update("travel.updateRequest", seq);
	}

}
