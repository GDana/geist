package com.geist.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.geist.domain.AddressViewVO;
import com.geist.domain.Criteria;
import com.geist.mapper.AddressMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

/* *
 * 주소록 조회 페이지
 *	담당 : 김현선
 */

@Service
@Log4j
public class AddressServiceImpl implements AddressService {
	@Setter(onMethod_ = @Autowired)
	private AddressMapper mapper;
	
	@Override
	public List<AddressViewVO> getList(Criteria cri) {
		return mapper.getListWithPaging(cri);
	}
}
