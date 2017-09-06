package kr.co.seoulit.accounting.accountbase.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.seoulit.accounting.accountbase.service.AccountServiceFacade;
import kr.co.seoulit.accounting.accountbase.to.AccountBean;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

public class AccountController extends MultiActionController {
	AccountServiceFacade accountServiceFacade;
	protected final Log logger = LogFactory.getLog(getClass());
	public void setAccountServiceFacade(
			AccountServiceFacade accountServiceFacade) {
		this.accountServiceFacade = accountServiceFacade;
	}

	HashMap<String, Object> modelObject = new HashMap<String, Object>();
	String path, viewname;
	ModelAndView modelAndView = new ModelAndView(viewname);

	public ModelAndView getDetailJour(HttpServletRequest request, // 분개상세 불러오는
																	// 로직
			HttpServletResponse response) {
		if (logger.isDebugEnabled()) {
			logger.debug("컨트롤러 분개상세 갖고오기 시작");
		}
		response.setContentType("text/json; charset=UTF-8");
		ModelAndView modelAndView = new ModelAndView();
		try {
			String accCode = request.getParameter("accCode");
			ArrayList<AccountBean> showCol = accountServiceFacade.getDetailJour(accCode);
			modelObject.put("showCol", showCol);
			modelObject.put("errorCode", 0);
			modelObject.put("errorMsg", "성공.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			modelObject.clear();
			modelObject.put("errorCode", -1);
			modelObject.put("errorMsg", "분개상세 조회 오류입니다.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		}
		if (logger.isDebugEnabled()) {
			logger.debug("컨트롤러 분개상세 가져오기 끝 ");
		}
		return modelAndView;
	}

	public ModelAndView getCodeList(HttpServletRequest request, // 계정과목을 불러옴
			HttpServletResponse response) {
		response.setContentType("text/json; charset=UTF-8");
		ModelAndView modelAndView = new ModelAndView();
		try {
			ArrayList<AccountBean> list = accountServiceFacade.getCodeList();
			modelObject.put("codeinfo", list);
			modelObject.put("errorCode", 0);
			modelObject.put("errorMsg", "성공.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		} catch (Exception e) {
			logger.fatal(e.getMessage()+"왜안되냐고옫노ㅕㅓ사ㅗㄴ다ㅕㅓ소자ㅕ더솧");
			modelObject.clear();
			modelObject.put("errorCode", -1);
			modelObject.put("errorMsg", "분개상세 조회 오류입니다.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		}
		return modelAndView;
	}

}
