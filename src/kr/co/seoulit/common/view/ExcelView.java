package kr.co.seoulit.common.view;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.seoulit.accounting.slip.to.SlipBean;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.web.servlet.view.document.AbstractExcelView;


public class ExcelView extends AbstractExcelView
{
	private String[] slipTitleKo = {"전표번호","결의일자","품의내역명","유형","대차차액","작성자코드","작성명","결의부서코드","결의부서명","기표번호","승인상태","승인자"};
	private List<String> slipTitleEn = new ArrayList<String>();
	
	
	@Override
	protected void buildExcelDocument(Map map, HSSFWorkbook workbook,
			HttpServletRequest requset, HttpServletResponse response) throws Exception
	{
		String title = (String)map.get("title");
		HSSFSheet sheet = null;
        HSSFRow row = null;
		if(title.equals("SlipList")){
			slipTitleEn.add("slipcode");
			slipTitleEn.add("writedate");
			slipTitleEn.add("request");
			slipTitleEn.add("sliptype");
			slipTitleEn.add("balancediff");
			slipTitleEn.add("writeempcode");
			slipTitleEn.add("writeempname");
			slipTitleEn.add("resolvedeptcode");
			slipTitleEn.add("resolvedeptname");
			slipTitleEn.add("kipyono");
			slipTitleEn.add("okstate");
			slipTitleEn.add("empcode");
			@SuppressWarnings("unchecked")
			List<SlipBean> slipList = (List<SlipBean>)map.get("list");
		
			sheet = createSheet(workbook);
			createColumnLabel(sheet);
		
			int rowNum = 1;
			for(SlipBean slipBean : slipList){
				createSlipRow(sheet, slipBean, rowNum++);
			}
		
		}
		response.setContentType("Application/Msexcel");
        response.setHeader("Content-Disposition", "ATTachment; Filename="+title+"-excel"+System.currentTimeMillis()+".xls");
	}
	private HSSFSheet createSheet(HSSFWorkbook workbook){
		HSSFSheet sheet = workbook.createSheet();
		workbook.setSheetName(0, "전표리스트");
		sheet.setColumnWidth(1,(400*20));
		return sheet;
	}
	private void createColumnLabel(HSSFSheet sheet)
	{
		HSSFRow row = sheet.createRow(0);
		
		for(int i=0;i<slipTitleKo.length;i++)
		{
			HSSFCell cell = row.createCell(i);
			cell.setCellValue(slipTitleKo[i]);			
		}	
	}
	private void createSlipRow(HSSFSheet sheet,SlipBean slipBean,int rowNum) throws ClassNotFoundException, IllegalAccessException, IllegalArgumentException, InvocationTargetException
	{
		HSSFRow row = sheet.createRow(rowNum);
		
		Class slipclass = Class.forName("kr.co.seoulit.accounting.slip.to.SlipBean");
		Method[] methods = slipclass.getDeclaredMethods();
		int cellNum;
		for(Method method : methods)
		{
			
			String mName = method.getName();
			if(mName.startsWith("get"))
			{
				String rowTitle = mName.substring(3).toLowerCase();
				System.out.println(rowTitle);
				cellNum = slipTitleEn.indexOf(rowTitle);
				if(cellNum != -1)
				{
					HSSFCell cell = row.createCell(cellNum);
					
					Object returnValue = method.invoke(slipBean,null);
					
					if(returnValue instanceof String)
					{
						cell.setCellValue((String)returnValue);	
					}
					else if(returnValue instanceof Integer)
					{
						cell.setCellValue((Integer)returnValue+"");
					}
						
				}
	
			}
			

		}	

	}
}
