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
import com.spring.board.vo.ReqUpdateDTO;
import com.spring.board.vo.TraveClientInfoDTO;
import com.spring.board.vo.TraveDTO;
import com.spring.board.vo.TraveInfoVo;

@Service
public class TravelServiceImpl implements TravelService{
	
	@Autowired
	PlatformTransactionManager transactionManager;
	@Autowired
	TravelDao travelDao;
	
	private static int parseTimeToMinutes(String time) {
	        String[] parts = time.split(":");
	    int hours = Integer.parseInt(parts[0]);
	    int minutes = Integer.parseInt(parts[1]);
	    return hours * 60 + minutes;
	}

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
	
	public double calRentFee(String period ) {
	    int rentFee;
	    switch (period) {
	        case "1":
	        case "2":
	            rentFee = 100000;
	            break;
	        case "3":
	        case "4":
	            rentFee = 90000;
	            break;
	        case "5":
	        case "6":
	            rentFee = 80000;
	            break;
	        default:
	            rentFee = 70000;
	            break;
	    }
	    return rentFee * Integer.parseInt(period);
	}
	
	public double calOilFee(String transTime) {
		double extraFee = 0;
	    if(transTime == null) {
	    	//��Ʈī�� ������� �������
	    	return extraFee;
	    }else {
	    	//��Ʈī�� ����� ���
	    	extraFee = Integer.parseInt(transTime) / 10 * 500;  	
	    	return extraFee;
	    }
	    
	}
	
	public int calPublicTransFee(String traveTrans, String transTime) {		
		// traveTime�� ������ ��ȯ
        int transTimeMin = Integer.parseInt(transTime);
        int extraCnt = transTimeMin / 20;

        int finalFee;

        // traveTrans���� ���� ������ ����ö�� ����
        // traveTrans�� ������ ���
        if ("B".equals(traveTrans)) {
            finalFee = 1400 + extraCnt * 200;
        }
        // traveTrans�� ����ö�� ���
        else {
            finalFee = 1450 + extraCnt * 200;
        }

        return finalFee;
	}
	
	public double calTaxiFee(String traveTime, String transTime) {
		
		 // traveTime�� ������ ��ȯ
        int traveTimeMin = parseTimeToMinutes(traveTime);
        int transTimeMin = Integer.parseInt(transTime);

        int basicTaxiFee = 3800;
        int basicExtraFee = 5000;
        double per20ExtraFee = basicExtraFee * 1.2;
        double full20ExtraFee = per20ExtraFee * 6 * 2;
        double per40ExtraFee = basicExtraFee * 1.4;
        double full40ExtraFee = per40ExtraFee * 6 * 4;

        int outTime = traveTimeMin + transTimeMin;
        double finalTaxiFee = 0;

        // ž�½ð��� ���Ÿ���� ���
        if (traveTimeMin >= 240 && traveTimeMin < 1320) {
            // outTime�� 22�� �̸��� ��
            if (outTime < 1320) {
                finalTaxiFee = (basicTaxiFee + transTimeMin / 10 * basicExtraFee) - basicExtraFee;
            } else if (outTime < 1440) {
                finalTaxiFee = (basicTaxiFee + (1320 - traveTimeMin) / 10 * basicExtraFee + (outTime - 1320) / 10 * per20ExtraFee) - basicExtraFee;
            } else if (outTime < 1680) {
                finalTaxiFee = (basicTaxiFee + full20ExtraFee + (outTime - 1440) / 10 * per40ExtraFee) - basicExtraFee;
            } else {
                finalTaxiFee = (basicTaxiFee + full20ExtraFee + full40ExtraFee + (transTimeMin - 360) / 10 * basicExtraFee) - basicExtraFee;
            }
        } else if (traveTimeMin >= 1320 && traveTimeMin < 1440) {
            if (outTime < 1440) {
                finalTaxiFee = (int) ((1.2 * basicTaxiFee + transTimeMin / 10 * per20ExtraFee) - per20ExtraFee);
            } else if (outTime < 1680) {
                finalTaxiFee = (int) ((1.2 * basicTaxiFee + full20ExtraFee + (outTime - 1440) / 10 * per40ExtraFee) - per20ExtraFee);
            } else {
                finalTaxiFee = (int) ((1.2 * basicTaxiFee + full20ExtraFee + full40ExtraFee + (transTimeMin - 360) / 10 * basicExtraFee) - per20ExtraFee);
            }
        } else if (traveTimeMin >= 0 && traveTimeMin < 240) {
            if (outTime < 240) {
                finalTaxiFee = (int) ((1.4 * basicTaxiFee + transTimeMin / 10 * per40ExtraFee) - per40ExtraFee);
            } else {
                finalTaxiFee = (int) ((1.4 * basicTaxiFee + full40ExtraFee + (transTimeMin - 240) / 10 * basicExtraFee) - per40ExtraFee);
            }
        }

        return finalTaxiFee;
	}
	
	
	
	
	@Override
	public double calTotalTransFee(ClientInfoVo clientInfoVo) throws Exception {
		// TODO Auto-generated method stub
		List<TraveClientInfoDTO> tcList = travelDao.getTCList(clientInfoVo);
		String period = "";
		String transport = "";

		double rentFee = 0;
		double oilFee = 0;
		double publicTransFee = 0;
		double taxiFee = 0;
		//��Ʈ����� ����ϴ� �޼ҵ�
		if(tcList.size() > 0) {
			period = tcList.get(0).getPeriod();
			transport = tcList.get(0).getTransport();
			if(transport.equals("R")) {
				rentFee = calRentFee(period);				
			}
		}else {
			//tcList�� ���°�� �� ClientInfo���尪�� ������, TravelInfo�� ���尪�� ���� ���
			String seq = travelDao.getSeq(clientInfoVo);
			String period2 = travelDao.selectPeriodBySeq(Integer.parseInt(seq));
			rentFee = calRentFee(period2);
			return rentFee;
		}
		
		for(int i=0; i < tcList.size(); i++) {
			TraveClientInfoDTO traveClientInfoDTO = tcList.get(i);
			String traveTime = traveClientInfoDTO.getTraveTime();
			String transTime = traveClientInfoDTO.getTransTime();
			String traveTrans = traveClientInfoDTO.getTraveTrans();
			
			if(traveTrans.equals("T")) {
				taxiFee += calTaxiFee(traveTime, transTime);				
			}else if(traveTrans.equals("S") || traveTrans.equals("B")) {
				publicTransFee += calPublicTransFee(traveTrans, transTime);				
			}else if(traveTrans.equals("R")) {
				oilFee += calOilFee(transTime);				
			}
			
		}
		
		return rentFee + oilFee + publicTransFee + taxiFee;
	}

	@Override
	public List<ClientInfoVo> selectClientList() throws Exception {
		// TODO Auto-generated method stub
		
		List<ClientInfoVo> clientList = travelDao.selectAllClientList();
		for(int i=0; i < clientList.size(); i++) {
			ClientInfoVo clientInfoVo = clientList.get(i);
			double totalTransFee = calTotalTransFee(clientInfoVo);
			System.out.println("******totalTransFee: " + totalTransFee);
			String sumExpend = travelDao.selectSumExpend(clientInfoVo);
			clientList.get(i).setSumExpend(sumExpend);
			clientList.get(i).setTotalTransFee(totalTransFee);
			int estimatedExpenses;
			if (sumExpend != null) {
			    estimatedExpenses = Integer.parseInt(sumExpend) + (int)totalTransFee;
			} else {
			    estimatedExpenses = (int)totalTransFee;
			}
			clientList.get(i).setEstimatedExpenses(estimatedExpenses);
			
		}		
		return clientList;
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
		
		System.out.println("*********saveService: " + traveDTO.toString());
		
		ClientInfoVo client = traveDTO.getClient();
		List<TraveInfoVo> traveList = traveDTO.getTraveList();
		System.out.println("traveList: " + traveList.toString());
		String traveDay = traveDTO.getTraveDay();
		
		String seq = "";
		
		try {					
	
			seq = travelDao.getSeq(client);
			TraveInfoVo traveInfoVo = new TraveInfoVo(seq,traveDay);		
			travelDao.delTraveBySeqAndDay(traveInfoVo);
			System.out.println("delete���� �Ϸ�");
			travelDao.insertTraveList(traveList);
			System.out.println("insert���� �Ϸ�");

			transactionManager.commit(status);
			System.out.println("Ŀ��");
			return 0;
		}catch (Exception e) {
			transactionManager.rollback(status);
			System.out.println("�ѹ�");
		}
		return 1;
	}

	@Override
	public ClientInfoVo selectClientInfo(ClientInfoVo clientInfoVo) throws Exception {
		// TODO Auto-generated method stub
		return travelDao.selectClientInfo(clientInfoVo);
	}

	@Override
	public int updateRequest(ReqUpdateDTO updateList) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("updateList: " + updateList.toString());
		int resultCnt = 0;
		List<TraveInfoVo> traveList = updateList.getUpdateList();
		for(int i=0; i < traveList.size(); i++) {
			String TraveSeq = traveList.get(i).getTraveSeq();
			System.out.println("TraveSeq: " + TraveSeq);
			travelDao.updateRequest(TraveSeq);
			resultCnt ++;
			
		}
		return resultCnt;
	}


}
