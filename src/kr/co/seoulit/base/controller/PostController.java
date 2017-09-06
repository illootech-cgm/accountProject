package kr.co.seoulit.base.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.seoulit.base.service.BaseServiceFacade;
import kr.co.seoulit.base.to.PostBean;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

public class PostController extends MultiActionController {
	
	HashMap<String,Object> modelObject=new HashMap<String,Object>();
	BaseServiceFacade baseServiceFacade;
	public void setBaseServiceFacade(BaseServiceFacade baseServiceFacade) {
		this.baseServiceFacade = baseServiceFacade;
	}
	public ModelAndView searchRoadname(HttpServletRequest request,
			HttpServletResponse response) {
		if (logger.isDebugEnabled()) {
	         logger.debug("Start handleRequestInternal-Method~!");
	      } 
		
		ModelAndView modelAndView=new ModelAndView();
		HashMap<String,Object> postRoadMap = new HashMap<String,Object>();
		ArrayList<PostBean> postRoadList = new ArrayList<>();
		try {
			request.setCharacterEncoding("UTF-8");
			response.setContentType("text/json; charset=UTF-8");		
			String sido=request.getParameter("sido");
			String sigunguname=request.getParameter("sigunguname");
			String roadname=request.getParameter("roadname");
			
			postRoadList=baseServiceFacade.searchRoadList(sido, sigunguname, roadname);
			if(postRoadList.size()==0) postRoadMap.put("datanull", "데이터가 존재하지 않습니다.");
			postRoadMap.put("postRoadList", postRoadList);
			postRoadMap.put("errorCode",0);
			postRoadMap.put("errorMsg","Success!");
			modelAndView.addAllObjects(postRoadMap);
			modelAndView.setViewName("jsonView");

			if (logger.isDebugEnabled()) {
		         logger.debug("End handleRequestInternal-Method~!");
		      }
			
		}catch(Exception e){
			logger.fatal(e.getMessage());
			postRoadMap.clear();
			postRoadMap.put("errorCode",-1);
			postRoadMap.put("errorMsg","Show list failed!");
			modelAndView.addAllObjects(postRoadMap);
			modelAndView.setViewName("jsonView");
		}
		return modelAndView;
	}
	public ModelAndView searchSigungu(HttpServletRequest request,
			HttpServletResponse response) {
		if (logger.isDebugEnabled()) {
	         logger.debug("Start handleRequestInternal-Method~!");
	      } 
		ModelAndView modelAndView=new ModelAndView();
		HashMap<String,Object> postSigunguMap = new HashMap<String,Object>();
		ArrayList<PostBean> postSigunguList = new ArrayList<>();
		try {
			request.setCharacterEncoding("UTF-8");
			response.setContentType("text/json; charset=UTF-8");
			postSigunguList=baseServiceFacade.searchSigunguList(request.getParameter("sido"));
			postSigunguMap.put("postSigunguList", postSigunguList);
			postSigunguMap.put("errorCode",0);
			postSigunguMap.put("errorMsg","Success!");
			modelAndView.addAllObjects(postSigunguMap);
			modelAndView.setViewName("jsonView");

			if (logger.isDebugEnabled()) {
		         logger.debug("End handleRequestInternal-Method~!");
		      }
		}catch(Exception e){
			logger.fatal(e.getMessage());
			postSigunguMap.clear();
			postSigunguMap.put("errorCode",-1);
			postSigunguMap.put("errorMsg","Show list failed!");
			modelAndView.addAllObjects(postSigunguMap);
			modelAndView.setViewName("jsonView");
		}
		return modelAndView;
	}
	public ModelAndView searchSido(HttpServletRequest request,
			HttpServletResponse response) {
		if (logger.isDebugEnabled()) {
	         logger.debug("Start handleRequestInternal-Method~!");
	      } 
		ModelAndView modelAndView=new ModelAndView();
		HashMap<String,Object> postSidoMap = new HashMap<String,Object>();
		ArrayList<PostBean> postSidoList = new ArrayList<>();
		try {
			request.setCharacterEncoding("UTF-8");
			response.setContentType("text/json; charset=UTF-8");
			postSidoList=baseServiceFacade.searchSidoList();
			postSidoMap.put("postSidoList", postSidoList);
			postSidoMap.put("errorCode",0);
			postSidoMap.put("errorMsg","Success!");
			modelAndView.addAllObjects(postSidoMap);
			modelAndView.setViewName("jsonView");
			
			if (logger.isDebugEnabled()) {
		         logger.debug("End handleRequestInternal-Method~!");
		      }
		}catch(Exception e){
			logger.fatal(e.getMessage());
		
			postSidoMap.clear();
			postSidoMap.put("errorCode",-1);
			postSidoMap.put("errorMsg","Show list failed!");
			modelAndView.addAllObjects(postSidoMap);
			modelAndView.setViewName("jsonView");
		}
		return modelAndView;
	}
	public ModelAndView searchJibun(HttpServletRequest request,
			HttpServletResponse response) {
		if (logger.isDebugEnabled()) {
	         logger.debug("Start handleRequestInternal-Method~!");
	      } 
		ModelAndView modelAndView=new ModelAndView();
		HashMap<String,Object> postListMap = new HashMap<String,Object>();
		ArrayList<PostBean> postList = new ArrayList<>();
		try {
			request.setCharacterEncoding("UTF-8");
			response.setContentType("text/json; charset=UTF-8");
			String dong=request.getParameter("dong");
			postList=baseServiceFacade.searchPostList(dong);
			postListMap.put("postList", postList);
			postListMap.put("errorCode",0);
			postListMap.put("errorMsg","Success!");
			modelAndView.addAllObjects(postListMap);
			modelAndView.setViewName("jsonView");
			
			if (logger.isDebugEnabled()) {
		         logger.debug("End handleRequestInternal-Method~!");
		      }
		}catch(Exception e){
			logger.fatal(e.getMessage());
			
			postListMap.clear();
			postListMap.put("errorCode",-1);
			postListMap.put("errorMsg","Show list failed!");
			modelAndView.addAllObjects(postListMap);
			modelAndView.setViewName("jsonView");
		}
		
		return modelAndView;
	}
	
}
