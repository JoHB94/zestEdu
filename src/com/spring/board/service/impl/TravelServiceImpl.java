package com.spring.board.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import com.spring.board.dao.TravelDao;
import com.spring.board.service.TravelService;
import com.spring.board.vo.ClientInfoVo;
import com.spring.board.vo.TraveDTO;
import com.spring.board.vo.TraveInfoVo;

@Service
public class TravelServiceImpl implements TravelService{
	
	@Autowired
	PlatformTransactionManager transactionManager;
	@Autowired
	TravelDao travelDao;

	@Override
	public boolean isExistMember(ClientInfoVo clientInfoVo) throws Exception {
		// TODO Auto-generated method stub
		String seq = travelDao.getSeq(clientInfoVo);
		if(seq == null) {
			return false;
		}else {
			return true;
		}
	}

	@Override
	public int insertClient(ClientInfoVo clientInfoVo) throws Exception {
		// TODO Auto-generated method stub
		return travelDao.insertClient(clientInfoVo);
	}

	@Override
	public List<ClientInfoVo> selectClientList() throws Exception {
		// TODO Auto-generated method stub
		return travelDao.selectAllClientList();
	}

	@Override
	public String selectPeriod(int seq) throws Exception {
		// TODO Auto-generated method stub
		return travelDao.selectPeriodBySeq(seq);
	}

	@Override
	public List<TraveInfoVo> selectTraveListBySeqAndDay(TraveInfoVo traveInfoVo) throws Exception {
		// TODO Auto-generated method stub
		return travelDao.selectTraveListBySeqAndDay(traveInfoVo);
	}

	@Override
	public int saveDetailschedule(TraveDTO traveDTO) throws Exception {
		// TODO Auto-generated method stub
		TransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = transactionManager.getTransaction(def);
		
		ClientInfoVo client = traveDTO.getCelient();
		List<TraveInfoVo> traveList = traveDTO.getTraveList();
		String traveDay = traveDTO.getTraveDay();
		
		String seq = "";
		
		try {					
			boolean isExistMember = isExistMember(client);
			if(isExistMember) {
				//DB에 저장값이 존재하는 경우
				seq = travelDao.getSeq(client);
				TraveInfoVo traveInfoVo = new TraveInfoVo(seq,traveDay);		
				travelDao.delTraveBySeqAndDay(traveInfoVo);
				travelDao.insertTraveList(traveList);
			}else {
				travelDao.insertTraveList(traveList);
			}
			transactionManager.commit(status);
			return 0;
		}catch (Exception e) {
			transactionManager.rollback(status);
		}
		return 1;
	}

	@Override
	public ClientInfoVo selectClientInfo(ClientInfoVo clientInfoVo) throws Exception {
		// TODO Auto-generated method stub
		return travelDao.selectClientInfo(clientInfoVo);
	}

	@Override
	public int updateRequest(List<TraveInfoVo> updateList) throws Exception {
		// TODO Auto-generated method stub
		try {
			int resultCnt = 0;
			for(int i=0; i < updateList.size(); i++) {
				String seq = updateList.get(i).getSeq();
				if(seq != null) {
					resultCnt ++;
				}
				return resultCnt;
			}
		}catch (Exception e) {
			// TODO: handle exception
			System.out.println("!error! #updateRequest#");
		}
		return 0;
	}

}
