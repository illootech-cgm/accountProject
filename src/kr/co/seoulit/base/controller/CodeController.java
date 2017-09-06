package kr.co.seoulit.base.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import kr.co.seoulit.base.service.BaseServiceFacade;
import kr.co.seoulit.base.to.CodeGubunBean;
import kr.co.seoulit.base.to.CodeInfoBean;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

public class CodeController extends MultiActionController {

	HashMap<String, Object> modelObject = new HashMap<String, Object>();
	BaseServiceFacade baseServiceFacade;
	protected final Log logger = LogFactory.getLog(getClass());
	
	public void setBaseServiceFacade(BaseServiceFacade baseServiceFacade) {
		this.baseServiceFacade = baseServiceFacade;
	}

	public ModelAndView getInfocode(HttpServletRequest request,
			HttpServletResponse response) {
		// �����󼼶� ��Ÿ �ڵ� ���׸� �����ִ°�
		if (logger.isDebugEnabled()) {
			logger.debug("����");
		}
		response.setContentType("text/json; charset=UTF-8");
		ModelAndView modelAndView = new ModelAndView();
		
		try {
			System.out.println(request.getParameter("code"));
			System.out.println(request.getParameter("accCode"));
			String selAcc = null;
			if (request.getParameter("accCode") != null) {
				selAcc = request.getParameter("accCode");
			}
			else{
				selAcc = null;	
			}
			ArrayList<CodeInfoBean> codeinfo = baseServiceFacade.getInfocode(request.getParameter("code"), selAcc);
			modelObject.clear();
			System.out.println(codeinfo);
			modelObject.put("codeinfo", codeinfo);
			modelObject.put("errorCode", 0);
			modelObject.put("errorMsg", "����.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		} catch (Exception e) {
			e.printStackTrace();
			logger.fatal(e.getMessage());
			modelObject.clear();
			modelObject.put("errorCode", -1);
			modelObject.put("errorMsg", "�ڵ���ȸ ��ȸ �����Դϴ�.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		}
		
		if (logger.isDebugEnabled()) {
			logger.debug("����");
		}
		return modelAndView;
	}

	public ModelAndView getCodelist(HttpServletRequest request,
			HttpServletResponse response) {
		response.setContentType("text/json; charset=UTF-8");
		if (logger.isDebugEnabled()) {
			logger.debug("����");
		}
		
		
		modelObject = new HashMap<String, Object>();
		ModelAndView modelAndView = new ModelAndView();
		ArrayList<CodeGubunBean> codelist = new ArrayList<CodeGubunBean>();
		try {
			codelist = baseServiceFacade.getCodeList();
			modelObject.put("list", codelist);
			modelObject.put("errorCode", 0);
			modelObject.put("errorMsg", "����.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			if (logger.isDebugEnabled()) {
				logger.debug("����");
			}
			modelObject.clear();
			modelObject.put("errorCode", -1);
			modelObject.put("errorMsg", "�ڵ帮��Ʈ ��ȸ �����Դϴ�.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");

		}
		return modelAndView;
	}

	public ModelAndView batchProcess(HttpServletRequest request,
			HttpServletResponse response) {
		response.setContentType("text/json; charset=UTF-8");
		if (logger.isDebugEnabled()) {
			logger.debug("����");
		}	
		ModelAndView modelAndView = new ModelAndView();
		try {
			String data = URLDecoder.decode(request.getParameter("list"),
					"UTF-8");
			JSONObject jsonobject = JSONObject.fromObject(data);
			JSONArray json = jsonobject.getJSONArray("updatelist");
			for (int i = 0; i < json.size(); i++) {
				CodeInfoBean codeinfo = (CodeInfoBean) JSONObject.toBean(
						json.getJSONObject(i), CodeInfoBean.class);

				if (codeinfo.getStatus().equals("delete")) {
					baseServiceFacade.deleteCode(codeinfo);
				} else if (codeinfo.getStatus().equals("insert")) {
					baseServiceFacade.addCode(codeinfo);
				} else if (codeinfo.getStatus().equals("update")) {
					baseServiceFacade.updateCode(codeinfo);

				}
			}
			modelObject.clear();
			modelObject.put("errorCode", 0);
			modelObject.put("errorMsg", "����.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		} catch (UnsupportedEncodingException e) {
			logger.fatal(e.getMessage());
			if (logger.isDebugEnabled()) {
				logger.debug("����");
			}
			modelObject.clear();
			modelObject.put("errorCode", -1);
			modelObject.put("errorMsg", "�ڵ��ϰ�ó�� �����Դϴ�.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		} // �ѱ�ó��

		return modelAndView;
	}
}
