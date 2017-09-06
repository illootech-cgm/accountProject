package kr.co.seoulit.base.dao;

import java.util.ArrayList;

import kr.co.seoulit.base.to.PostBean;

public interface PostDAO {
	public ArrayList<PostBean> searchPostList(String dong);
	public ArrayList<PostBean> searchSidoList();
	public ArrayList<PostBean> searchSigunguList(String sido);
	public ArrayList<PostBean> searchRoadList(String sido, String sigungu,String roadname);
	
	
}
