package kr.co.seoulit.accounting.slip.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.seoulit.accounting.slip.service.SlipServiceFacade;
import kr.co.seoulit.accounting.slip.to.JourBean;
import kr.co.seoulit.accounting.slip.to.JourDetailBean;
import kr.co.seoulit.accounting.slip.to.SlipBean;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

public class SlipController extends MultiActionController {
	SlipServiceFacade slipServiceFacade;
	public void setSlipServiceFacade(SlipServiceFacade slipServiceFacade) {
		this.slipServiceFacade = slipServiceFacade;
	}

	protected final Log logger = LogFactory.getLog(getClass());
	


	HashMap<String, Object> modelObject = new HashMap<String, Object>();
	String path, viewname;
	ModelAndView modelAndView = new ModelAndView(viewname);

	public ModelAndView toSlipFile(HttpServletRequest request,
			HttpServletResponse response) {
		try {
			String kind = request.getParameter("kind");
			List<SlipBean> slipList = slipServiceFacade.searchDate(request.getParameter("date"));
			modelObject.clear();
			modelObject.put("errorCode", 0);
			modelObject.put("errorMsg", "성공.");
			modelObject.put("title", "SlipList");
			modelObject.put("list", slipList);
			modelAndView.clear();
			modelAndView.addAllObjects(modelObject);
			if (kind.equals("excel"))
				modelAndView.setViewName("excelView");
			else if (kind.equals("pdf"))
				modelAndView.setViewName("pdfView");

		} catch (Exception e) {
			logger.fatal(e.getMessage());
			modelObject.clear();
			modelObject.put("errorCode", -1);
			modelObject.put("errorMsg", "다운로드 오류.");
			modelAndView.clear();
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("error");
		}
		return modelAndView;
	}

	public ModelAndView searchDate(HttpServletRequest request,
			HttpServletResponse response) {
		String date = request.getParameter("searchDate");
		if (logger.isDebugEnabled()) {
			logger.debug("전표검색 시작 " + date + "날 검색할꺼임");
		}
		response.setContentType("text/json; charset=UTF-8");
		ModelAndView modelAndView = new ModelAndView();
		try {

			ArrayList<SlipBean> list = slipServiceFacade.searchDate(date);
			modelObject.clear();
			modelObject.put("errorCode", 0);
			modelObject.put("errorMsg", "성공.");
			modelObject.put("searchList", list);
			modelObject.put("slipBean", new SlipBean());
			modelObject.put("jourBean", new JourBean());
			modelObject.put("detailJourBean", new JourDetailBean());
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
			return modelAndView;
		} catch (Exception e) {
			logger.fatal(e.getMessage()+"왜안되냐고옫노ㅕㅓ사ㅗㄴ다ㅕㅓ소자ㅕ더솧");
			e.printStackTrace();
			modelObject.clear();
			modelObject.put("errorCode", -1);
			modelObject.put("errorMsg", "분개상세 조회 오류입니다.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
			return modelAndView;
		}
	}

	public ModelAndView batchProcess(HttpServletRequest request,
			HttpServletResponse response) {
		if (logger.isDebugEnabled()) {
			logger.debug("일괄처리 컨트롤러 시작 ");
		}
		response.setContentType("text/json; charset=UTF-8");
		ModelAndView modelAndView = new ModelAndView();
		try {
			JSONObject jsonob=JSONObject.fromObject(request.getParameter("batchList"));
			JSONArray data = jsonob.getJSONArray("dataSet");
			ArrayList<SlipBean> slipBeanList=new ArrayList<SlipBean>();
			int slen = data.size();
				for (int si = 0; si < slen; si++){
					SlipBean slipBean = (SlipBean)JSONObject.toBean(data.getJSONObject(si), SlipBean.class);
					JSONArray jourArray=JSONArray.fromObject(slipBean.getJourBeanList());
					int jlen=jourArray.size();
					ArrayList<JourBean> jourBeanList=new ArrayList<JourBean>();
						for(int ji=0;ji<jlen;ji++){
							JourBean jourBean=(JourBean)JSONObject.toBean(jourArray.getJSONObject(ji), JourBean.class);
							JSONArray jourDetailArray=JSONArray.fromObject(jourBean.getJourDetailBeanList());
							int jdlen=jourDetailArray.size();
							ArrayList<JourDetailBean> jourDetailBeanList=new ArrayList<JourDetailBean>();
								for(int jdi=0;jdi<jdlen;jdi++){
									JourDetailBean jnalzDtlBean=(JourDetailBean)JSONObject.toBean(jourDetailArray.getJSONObject(jdi), JourDetailBean.class);
									jourDetailBeanList.add(jnalzDtlBean);
								}
						jourBean.setJourDetailBeanList(jourDetailBeanList);
						jourBeanList.add(jourBean);
					}
					slipBean.setJourBeanList(jourBeanList);
					slipBeanList.add(slipBean);
			}
			System.out.println(slipBeanList+"//"+slipBeanList.size());
			slipServiceFacade.batchProcess(slipBeanList);
			modelObject.put("errorCode", 0);
			modelObject.put("errorMsg", "Success!");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
			if (logger.isDebugEnabled()) {
				logger.debug("일괄처리 컨트롤러 끝 ");
			}
			return modelAndView;
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			e.printStackTrace();
			modelObject.clear();
			modelObject.put("errorCode", -1);
			modelObject.put("errorMsg", "분개상세 조회 오류입니다.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
			return modelAndView;
		}

	}

	public ModelAndView getLastSlipCode(HttpServletRequest request,
			HttpServletResponse response) {
		ModelAndView modelAndView = new ModelAndView();
		try {
			String lastSlipCode = slipServiceFacade.getLastSlipCode();

			System.out.println(lastSlipCode + "컨트롤러에서 뿌릴꺼");
			modelObject.clear();
			modelObject.put("errorCode", 0);
			modelObject.put("errorMsg", "성공.");
			modelObject.put("lastSlipCode", lastSlipCode);
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
