package kr.co.seoulit.base.controller;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import kr.co.seoulit.base.service.BaseServiceFacade;
import kr.co.seoulit.base.to.CodeInfoBean;
import kr.co.seoulit.base.to.EmpBean;
import kr.co.seoulit.base.to.ListForm;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

public class EmpController extends MultiActionController {
	BaseServiceFacade baseServiceFacade;
	protected final Log logger = LogFactory.getLog(getClass());

	public void setBaseServiceFacade(BaseServiceFacade baseServiceFacade) {
		this.baseServiceFacade = baseServiceFacade;
	}

	HashMap<String, Object> modelObject = new HashMap<String, Object>();

	public ModelAndView batchProcess(HttpServletRequest request,
			HttpServletResponse response) {
		ModelAndView modelAndView = new ModelAndView();
		String data;
		try {
			data = URLDecoder
					.decode(request.getParameter("batchList"), "UTF-8");
			JSONObject jsonob = JSONObject.fromObject(data);
			JSONArray json = jsonob.getJSONArray("empBeanList");
			for (int i = 0; i < json.size(); i++) {
				EmpBean empBean = (EmpBean) JSONObject.toBean(
						json.getJSONObject(i), EmpBean.class);
				baseServiceFacade.batchProcess(empBean);
			}
			modelObject.clear();
			modelObject.put("errorCode", 0);
			modelObject.put("errorMsg", "Success!");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			if (logger.isDebugEnabled()) {
				logger.debug("종료");
			}
			modelObject.clear();
			modelObject.put("errorCode", -1);
			modelObject.put("errorMsg", "사원 일괄처리 오류입니다");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		}
		return modelAndView;
	}

	public ModelAndView setEmpCode(HttpServletRequest request,
			HttpServletResponse response) {
		if (logger.isDebugEnabled()) {
			logger.debug("Start - setEmpCode - Method~!");
		}
		ModelAndView modelAndView = new ModelAndView();
		response.setContentType("text/json; charset=UTF-8");
		try {
			String empCode = baseServiceFacade.getLastEmpCode();
			modelObject.clear();
			modelObject.put("emptyEmpBean", new EmpBean());
			modelObject.put("lastEmpCode", empCode);
			modelObject.put("errorCode", 0);
			modelObject.put("errorMsg", "Success!");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
			if (logger.isDebugEnabled()) {
				logger.debug("End - setEmpCode - Method~!");
			}
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			if (logger.isDebugEnabled()) {
				logger.debug("종료");
			}
			modelObject.clear();
			modelObject.put("errorCode", -1);
			modelObject.put("errorMsg", "사원번호 셋팅오류입니다");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		}
		return modelAndView;
	}

	public ModelAndView saveImg(HttpServletRequest request,
			HttpServletResponse response) {
		response.setContentType("text/json; charset=UTF-8");
		if (logger.isDebugEnabled()) {
			logger.debug("사진저장");
		}
		ModelAndView modelAndView = new ModelAndView();
		Collection<Part> coll = null;
		try {
			coll = request.getParts();
			System.out.println(coll);
			String tempfilename = getTempFileName();
			for (Part part : coll) {
				String contentType = part.getContentType();
				System.out.println("컨덴트타입" + contentType);
				if (contentType == null) {
				} else {
					if (part.getSize() > 0) {
						part.getName();
						part.write(tempfilename);
						part.delete();
					}
				}
			}
			// modelObject.clear();
			modelObject.put("imgFilename", tempfilename);
			modelObject.put("errorCode", 0);
			modelObject.put("errorMsg", "Success!");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");

		} catch (IllegalStateException | IOException | ServletException e) {
			modelObject.clear();
			e.printStackTrace();
			logger.fatal(e.getMessage());
			modelObject.put("errorCode", -1);
			modelObject.put("errorMsg", "사진 저장 오류.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		}
		if (logger.isDebugEnabled()) {
			logger.debug("사진저장끝");
		}
		return modelAndView;
	}

	public String getTempFileName() {
		long currentTime = System.currentTimeMillis();
		int randomValue = new Random().nextInt(10000);
		String tempfilename = currentTime + "_" + randomValue;
		return tempfilename;
	}

	public String getParameter(Part part) throws UnsupportedEncodingException,
			IOException {
		InputStreamReader isr = new InputStreamReader(part.getInputStream(),
				"UTF-8");
		char[] buffer = new char[512];
		StringBuffer stringBuffer = new StringBuffer();
		int n = -1;
		while ((n = isr.read(buffer)) != -1) {
			stringBuffer.append(buffer, 0, n);
		}
		return stringBuffer.toString();
	}

	public ModelAndView getEmpList(HttpServletRequest request,
			HttpServletResponse response) {
		ArrayList<EmpBean> emplist = new ArrayList<EmpBean>();
		response.setContentType("text/json; charset=UTF-8");
		ModelAndView modelAndView = new ModelAndView();
		if (logger.isDebugEnabled()) {
			logger.debug("시작");
		}
		try {

			int pagenum = Integer.parseInt(request.getParameter("page"));
			int rowsize = Integer.parseInt(request.getParameter("rows"));
			if (pagenum == 0) {
				pagenum = 5;
			}
			if (rowsize == 0) {
				rowsize = 5;
			}
			int dbcount = baseServiceFacade.getRowCount();
			ListForm listForm = new ListForm();
			listForm.setRowsize(rowsize);
			listForm.setPagenum(pagenum);
			listForm.setDbcount(dbcount);
			int sr = listForm.getStartrow();
			int er = listForm.getEndrow();
			// 사원정보 뽑아오기
			emplist = baseServiceFacade.findEmpList(sr, er);

			int pagecount = listForm.getPagecount();
			System.out.println("dbcount:" + dbcount);
			System.out.println("pagecount:" + pagecount);
			modelObject.put("page", pagenum);
			modelObject.put("total", pagecount);
			modelObject.put("list", emplist);
			modelObject.put("errorCode", 0); // 에러처리시 사용 0은 성공
			modelObject.put("errorMsg", "success");
			modelObject.put("empBean", new EmpBean()); // 빈객체를 생성해서 날려줌..
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		} catch (Exception e) {
			logger.fatal(e.getMessage());

			modelObject.clear();
			modelObject.put("errorCode", -1);
			modelObject.put("errorMsg", "사원정보 조회 오류입니다.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");

		}
		if (logger.isDebugEnabled()) {
			logger.debug("종료");
		}
		return modelAndView;
	}

	public ModelAndView login(HttpServletRequest req, HttpServletResponse resp) {
		String viewname = null;
		try {
			String id = req.getParameter("id");
			String pw = req.getParameter("pw");
			boolean check = baseServiceFacade.checkMemberPw(id, pw);
			if (check) {
				CodeInfoBean bean = baseServiceFacade.findEmpdept(id);
				String name = baseServiceFacade.findEmpname(id);
				req.getSession().setAttribute("id", id);
				req.getSession().setAttribute("deptcode", bean.getDetailCode());
				req.getSession().setAttribute("deptname",
						bean.getDetailCodeName());
				req.getSession().setAttribute("name", name);
				viewname = "../welcome";
			} else {

				modelObject.clear();
				viewname = "error";
				modelObject.put("errorMsg", "로그인 실패");
			}

		} catch (Exception e) {
			logger.fatal(e.getMessage());

			modelObject.clear();
			viewname = "error";
			modelObject.put("errorMsg", e.getMessage());

		}
		if (logger.isDebugEnabled()) {
			logger.debug("종료");
		}
		ModelAndView modelAndView = new ModelAndView(viewname, modelObject);
		return modelAndView;
	}

	public ModelAndView logout(HttpServletRequest req, HttpServletResponse resp) {
		if (logger.isDebugEnabled()) {
			logger.debug("시작");
		}
		String viewname = "../welcome";
		ModelAndView modelAndView = new ModelAndView(viewname, null);
		try {
			modelObject.put("errorCode", 0);
			modelObject.put("errorMsg", "성공.");
			req.getSession().invalidate();

		} catch (Exception e) {
			logger.fatal(e.getMessage());
			e.printStackTrace();
			modelObject.clear();
			modelObject.put("errorCode", -1);
			modelObject.put("errorMsg", "로그아웃 오류입니다.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		}
		if (logger.isDebugEnabled()) {
			logger.debug("종료");
		}
		return modelAndView;
	}

	public ModelAndView insertEmp(HttpServletRequest request,
			HttpServletResponse response) {
		if (logger.isDebugEnabled()) {
			logger.debug("시작");
		}
		response.setContentType("text/json; charset=UTF-8");
		System.out.println("EmpController - insertProcess - Start!");
		ModelAndView modelAndView = new ModelAndView();
		try {

			JSONObject jsonObject = JSONObject.fromObject(request
					.getParameter("insertList"));
			EmpBean empBean = (EmpBean) JSONObject.toBean(
					jsonObject.getJSONObject("empBean"), EmpBean.class);
			baseServiceFacade.insertEmp(empBean);
			modelObject.clear();
			modelObject.put("errorCode", 0);
			modelObject.put("errorMsg", "Success!");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");
		} catch (Exception e) {
			logger.fatal(e.getMessage());
			if (logger.isDebugEnabled()) {
				logger.debug("종료");
			}
			e.printStackTrace();
			modelObject.clear();
			modelObject.put("errorCode", -1);
			modelObject.put("errorMsg", "사원등록 오류입니다.");
			modelAndView.addAllObjects(modelObject);
			modelAndView.setViewName("jsonView");

		}
		System.out.println("EmpController - insertProcess - End!");
		return modelAndView;
	}

}
