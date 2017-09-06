package kr.co.seoulit.common.view;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.seoulit.accounting.slip.to.SlipBean;

import org.springframework.web.servlet.view.document.AbstractPdfView;

import com.lowagie.text.BadElementException;
import com.lowagie.text.Cell;
import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Table;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfWriter;

public class PDFView extends AbstractPdfView
{
	private String[] slipTitleKo = {"전표번호","결의일자","품의내역명","유형","대차차액","작성자코드","작성명","결의부서코드","결의부서명","기표번호","승인상태","승인자"};
	private List<String> slipTitleEn = new ArrayList<String>();

	@Override
	protected void buildPdfDocument(Map map, Document document, PdfWriter writer,
			HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		String title = (String)map.get("title");
		if(title.equals("SlipList"))
		{
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

			List<SlipBean> slipList = (List<SlipBean>)map.get("list");
			Table table = new Table(slipTitleKo.length,slipList.size()+1);
			table.setPadding(5);
		
			
			BaseFont bkKorean = BaseFont.createFont("c:\\windows\\fonts\\batang.ttc,0",BaseFont.IDENTITY_H,BaseFont.EMBEDDED);
			Font font = new Font(bkKorean);
			
			setHeader(slipList,table,font);
			for(SlipBean slipBean : slipList)
			{
				setTableValue(slipBean,table,font);	
			}
			document.add(table);
		}
		
		response.setContentType("Application/Msexcel");
        response.setHeader("Content-Disposition", "ATTachment; Filename="+title+"-pdf"+System.currentTimeMillis()+".pdf");

		
		
	}

	private void setTableValue(SlipBean slipBean, Table table, Font font) throws Exception
	{
		Class slipclass = Class.forName("kr.co.seoulit.accounting.slip.to.SlipBean");
		Method[] methods = slipclass.getDeclaredMethods();
		int cellNum;
		String[] tempValues = new String[slipTitleKo.length];
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
					Object returnValue = method.invoke(slipBean,null);
					
					if(returnValue instanceof String)
						tempValues[cellNum]=(String)returnValue;	
					else if(returnValue instanceof Integer)
						tempValues[cellNum]=(Integer)returnValue+"";	
				}
	
			}
		}	
		
		for(String value : tempValues)
		{
			System.out.println("value="+value);
			table.addCell(new Paragraph(value,font));
		}
		
	}

	private void setHeader(List<SlipBean> slipList, Table table,
			Font font) throws BadElementException
	{
		for(int i=0;i<slipTitleKo.length;i++)
		{
			Cell cell = new Cell(new Paragraph(slipTitleKo[i],font));
			cell.setHeader(true);
			table.addCell(cell);	
		}		
		table.endHeaders();
	}

}
