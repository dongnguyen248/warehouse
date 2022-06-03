using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using COMExcel = Microsoft.Office.Interop.Excel;
using System.IO; 
using System.Data;
namespace MaterialManagement
{
   public partial class his_export : Page
    {
        public static DataTable DTB { get; set; }
        public DataTable DTBLine { get; set; }
        public static string userid;
        public Double sumQty { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["USERNAME"] != null)
                {
                  userid = Session["USERNAME"].ToString();
                }
                string txtdate = DateTime.Now.Year + "-" + Change(DateTime.Now.Month);
                DTB = LoadDT2(txtdate);
                ViewState["DTB2"] = DTB;
                AddLine(LoadLine());
                //DTBLine = LoadLine();
                DateTime date = DateTime.Today;
                var firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
                //var lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);
                txtfrom.Text = firstDayOfMonth.ToString("yyyy-MM-dd");
                txtto.Text = DateTime.Today.ToString("yyyy-MM-dd");
            }
        }
        private string Change(int a)
        {
            if (a > 9)
                return a.ToString();
            else
                return "0" + a.ToString();
        }
        private void AddLine(DataTable DTB2)
        {
            dropline.Items.Clear();
            dropline.Items.Add("ALL");
            for (int i = 0; i < DTB2.Rows.Count; i++)
            {
              dropline.Items.Add(DTB2.Rows[i][1].ToString().Trim());
            }
        }
        private DataTable LoadDT2(string txtdate)
        {
            string sql = "";
            Dictionary<string, object> param = new Dictionary<string, object>();
            if (Session["USERNAME"] != null && userid != "110719")
            {
                sql = "select distinct top 100  o.Seq,m.QCODE,o.Pur_Date,o.Out_date,m.ITEM,m.SPEC,m.UNIT,Round(i.PRICE,2) as Price,Round(o.inventory,2) 'inventory',Round(o.Quantity,2) 'Quantity',Round((o.inventory-o.Quantity),2) 'QtyNow',Round((o.Quantity*i.PRICE),1) 'amount',Line,CodeCenter,CostAccount,Requestor,o.Remark,o.Locator from dbo.MATERIAL m, [MATERIAL_MGM].[dbo].[Out_history] o,Import_History i  where m.qcode = o.qcode  and o.QCode=i.QCode and o.Pur_Date = i.Pur_Date AND round(o.Imp_Price,2) = round(i.price,2)  and SUBSTRING(o.Out_Date, 0, 8) = @txtdate and ((o.userid=@userid) or (o.userid is null))  order by o.Out_Date desc";
                param.Add("@userid", userid);
            }
            else
            {
                sql = "select distinct top 100  o.Seq,m.QCODE,o.Pur_Date,o.Out_date,m.ITEM,m.SPEC,m.UNIT,Round(i.PRICE,2) as Price,Round(o.inventory,2) 'inventory',Round(o.Quantity,2) 'Quantity',Round((o.inventory-o.Quantity),2) 'QtyNow',Round((o.Quantity*i.PRICE),1) 'amount',Line,CodeCenter,CostAccount,Requestor,o.Remark,o.Locator from dbo.MATERIAL m, [MATERIAL_MGM].[dbo].[Out_history] o,Import_History i  where m.qcode = o.qcode  and o.QCode=i.QCode and o.Pur_Date = i.Pur_Date AND round(o.Imp_Price,2) = round(i.price,2) and SUBSTRING(o.Out_Date, 0, 8) = @txtdate  order by o.Out_Date desc";
            }
            param.Add("@txtdate", txtdate);
            return mgrDataSQL.ReturnDataTable(sql, param);
        }
        private void Download(string filename, string filepath)
        {
            HttpContext.Current.Response.ContentType = "APPLICATION/OCTET-STREAM";
            string Header = "Attachment; Filename=" + filename;
            HttpContext.Current.Response.AppendHeader("Content-Disposition", Header);
            // Dim Dfile As New System.IO.FileInfo(sFilePath)
            FileInfo Dfile = new FileInfo(filepath);
            HttpContext.Current.Response.WriteFile(Dfile.FullName);
            HttpContext.Current.Response.End();
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string txtfrm = txtfrom.Text.Trim();
            string txtt = txtto.Text.Trim();
            string txtcode = txtQCode.Text.Trim();
            string txtAccCost = txtAccountCost.Text.Trim();
            string dk = "";
            var line = dropline.SelectedValue;
                        Dictionary<string, object> param = new Dictionary<string, object>();

            //@IssueDate,@EmpCode, @FullName,@Type,@Amount,@Description,@Note
            if (txtfrm != "")
            {
                dk += "And o.Out_Date >=@txtfrm ";
                param.Add("@txtfrm", txtfrm);
            }
            if (txtt != "")
            {
                dk += "And o.Out_date <=@txtt ";
                param.Add("@txtt", txtt);
            }
            if (txtcode != "")
            {
                dk += "And o.Qcode like '%' + @txtcode + '%'";
                param.Add("@txtcode", txtcode);
            }

            if (txtAccCost != "")
            {
                dk += "And o.CostAccount like '%' + @txtAccCost + '%'";
                param.Add("@txtAccCost", txtAccCost);
            }

            if (line != "ALL" && (line.Contains("Main")==false))
            {
                dk += " And Line = @line ";
                param.Add("@line", line);
            }
            if (line.Contains("Main"))
            {
                dk += "And o.Remark like  @line +'%'";
                param.Add("@line", line);
            }
          string sql = "";
          if (Session["USERNAME"] != null && userid != "110719" && userid != "quantri")
            {
                sql = " select distinct  o.Seq,m.QCODE,o.Pur_Date,o.Out_date,m.ITEM,m.SPEC,m.UNIT,Round(i.PRICE,2)as Price,Round(o.inventory,2) 'inventory',Round(o.Quantity,2) 'Quantity',Round((o.inventory-o.Quantity),2) 'QtyNow',Round((o.Quantity*i.PRICE),1) 'amount',Line,CodeCenter,CostAccount,Requestor,o.Remark,o.Locator from dbo.MATERIAL m, [MATERIAL_MGM].[dbo].[Out_history] o,Import_History i  where m.qcode = o.qcode  and o.QCode=i.QCode and o.Pur_Date = i.Pur_Date and round(o.Imp_Price,2) = round(i.price,2) " + dk + " and (o.userid=@userid or o.userid is null) order by o.Out_Date desc";
               param.Add("@userid", userid);
            }
            else
            {
                //distinct
                sql = " select distinct  o.Seq,m.QCODE,o.Pur_Date,o.Out_date,m.ITEM,m.SPEC,m.UNIT,Round(i.PRICE,2)as Price,Round(o.inventory,2) 'inventory',Round(o.Quantity,2) 'Quantity',Round((o.inventory-o.Quantity),2) 'QtyNow',Round((o.Quantity*i.PRICE),1) 'amount',Line,CodeCenter,CostAccount,Requestor,o.Remark,o.Locator from dbo.MATERIAL m, [MATERIAL_MGM].[dbo].[Out_history] o,Import_History i  where m.qcode = o.qcode  and o.QCode=i.QCode and o.Pur_Date = i.Pur_Date and round(o.Imp_Price,2) = round(i.price,2)  " + dk + " order by o.Out_Date desc";
            }
            DTB = mgrDataSQL.ReturnDataTable(sql, param);
            ViewState["DTB2"] = DTB;
        }
        private DataTable LoadLine()
        {
            string sql = "Select * from TB_Line";
            return mgrDataSQL.ReturnDataTable(sql);
        }
        protected void lnkExcel_Click(object sender, EventArgs e)
        {
            DataTable data = (DataTable)ViewState["DTB2"];
            Ultilities.Export(data, "Allocate_Report");
        }
      protected void btnReport_Click(object sender, EventArgs e)
      {
          var sql = @"
select t.Pur_Date, t.QCode, t.ITEM, t.SPEC, t.UNIT, t.Price,t.inven1 'inventory',  t.IN_QTY, t.OUT_QTY, t.inven1 + t.IN_QTY 'last_inven', 0 'amount', t.Supplier as 'line', 
   'warehouse' as 'costcenter', 'NO.' as 'codeaccount', remark, '' Note,  '' as 'name', t.locator,
   INSPECTION,INSPECTION_DATE,INSPECTOR,RESULT
     from   (
	 SELECT ii.Pur_Date, ii.QCode, m.ITEM, m.spec,  m.UNIT, ii.PRICE, ii.Supplier , INSPECTION,INSPECTION_DATE,INSPECTOR,RESULT,
   ii.Remark,ii.locator, isnull((SELECT SUM(I.Quantity) 'IN_QTY' FROM   Import_History I LEFT JOIN MATERIAL M ON I.QCode = M.QCODE  where  I.Pur_Date < ii.Pur_Date and    i.QCode = ii.QCode), 0)
    -(select SUM(OUT_QTY) 'OUT_QTY' from   (select 0 'OUT_QTY' union all select SUM(O.Quantity) 'OUT_QTY'  from   Out_history o LEFT JOIN (select i.Pur_Date, i.PRICE , m.QCODE, I.Quantity,
	 m.ITEM, m.ZONE, m.LOCATION, m.SPEC, m.UNIT from   MATERIAL m left join Import_History i on m.QCODE = i.QCode ) mi ON O.QCode = Mi.QCODE and    o.Pur_Date = mi.Pur_Date  
	  WHERE  left(O.Out_date, 4)+ SUBSTRING(O.Out_date, 6, 2) + SUBSTRING(O.Out_date, 9, 2) < ii.Pur_Date  and    o.QCode = ii.QCode) S) 'inven1', (ii.Quantity) 'IN_QTY',  0 'OUT_QTY' 
	    FROM   Import_History ii LEFT JOIN MATERIAL M ON ii.QCode = M.QCODE  where  ii.Pur_Date BETWEEN @begin and @end ) t    union all select distinct v.out_date,  v.qcode, mi.item, 
		 mi.SPEC,  mi.UNIT, round(mi.Price, 2) 'Price',  v.inventory,  0 'In_Qty', v.quantity 'Out_Qty',  v.inventory -v.quantity 'last_inven', round(mi.Price*v.quantity, 2) 'amount', 
		  v.line,  v.codecenter, v.costaccount, remark ,  Note, '' as 'name', v.locator,INSPECTION,INSPECTION_DATE,'' AS INSPECTOR,RESULT  from   V_Out_history v LEFT JOIN (select i.Pur_Date, i.PRICE , m.QCODE, I.Quantity, m.ITEM, m.ZONE,
		   m.LOCATION, m.SPEC, m.UNIT,INSPECTION,INSPECTION_DATE,'' AS INSPECTOR, RESULT  from   MATERIAL m left join Import_History i on m.QCODE = i.QCode ) mi ON v.QCode = Mi.QCODE and    v.Pur_Date = mi.Pur_Date and  
		     round(v.Imp_Price, 2) = round(mi.Price, 2) 
    where  v.out_date between @begin and @end";
     //  string sql="   select t.Pur_Date, t.QCode, t.ITEM, t.SPEC, t.UNIT, t.Price,t.inven1 'inventory',  t.IN_QTY, t.OUT_QTY, t.inven1 + t.IN_QTY 'last_inven', 0 'amount', t.Supplier as 'line', 'warehouse' as 'costcenter', 'NO' as 'codeaccount', remark, '' Note,  '' as 'name', t.locator ";
     //         sql+=" from   (SELECT ii.Pur_Date, ii.QCode, m.ITEM, m.spec,  m.UNIT, ii.PRICE, ii.Supplier ,ii.Remark,ii.locator, isnull((SELECT SUM(I.Quantity) 'IN_QTY' FROM   Import_History I LEFT JOIN MATERIAL M ON I.QCode = M.QCODE ";
     //      sql +=" where  I.Pur_Date < ii.Pur_Date and    i.QCode = ii.QCode), 0) -(select SUM(OUT_QTY) 'OUT_QTY' from   (select 0 'OUT_QTY' union all select SUM(O.Quantity) 'OUT_QTY' ";
     //     sql+=" from   Out_history o LEFT JOIN (select i.Pur_Date, i.PRICE , m.QCODE, I.Quantity, m.ITEM, m.ZONE, m.LOCATION, m.SPEC, m.UNIT from   MATERIAL m left join Import_History i on m.QCODE = i.QCode ) mi ON O.QCode = Mi.QCODE and    o.Pur_Date = mi.Pur_Date ";
     //   sql+="  WHERE  left(O.Out_date, 4)+ SUBSTRING(O.Out_date, 6, 2) + SUBSTRING(O.Out_date, 9, 2) < ii.Pur_Date  and    o.QCode = ii.QCode) S) 'inven1', (ii.Quantity) 'IN_QTY',  0 'OUT_QTY'   FROM   Import_History ii LEFT JOIN MATERIAL M ON ii.QCode = M.QCODE ";
     //  sql+=" where  ii.Pur_Date BETWEEN @begin and @end  ) t    union all select distinct v.out_date,  v.qcode, mi.item,  mi.SPEC,  mi.UNIT, round(mi.Price, 2) 'Price',  v.inventory,  0 'In_Qty', v.quantity 'Out_Qty',  v.inventory -v.quantity 'last_inven', round(mi.Price*v.quantity, 2) 'amount', ";
     // sql+=" v.line,  v.codecenter, v.costaccount, remark ,  Note, '' as 'name', v.locator  from   V_Out_history v LEFT JOIN (select i.Pur_Date, i.PRICE , m.QCODE, I.Quantity, m.ITEM, m.ZONE, m.LOCATION, m.SPEC, m.UNIT ";
     //  sql+=" from   MATERIAL m left join Import_History i on m.QCODE = i.QCode ) mi ON v.QCode = Mi.QCODE and    v.Pur_Date = mi.Pur_Date and    round(v.Imp_Price, 2) = round(mi.Price, 2) ";
     //sql+=" where  v.out_date between @begin and @end ";
          string bgDate = txtfrom.Text.Trim().Replace("-", "").Replace("-", "");
        string EndDate = txtto.Text.Trim().Replace("-", "").Replace("-", "");
    if (bgDate == "" || EndDate == "")
    {
        MessageBox.Show(this,"Bạn phải chọn ngày bắt đầu và ngày kết thúc để xuất báo cáo!");
        return;
    }
    Dictionary<string, object> param = new Dictionary<string, object>();
    param.Add("@begin", bgDate);
    param.Add("@end",EndDate);
    DataTable DT = mgrDataSQL.ReturnDataTable(sql,param);
    string fileName = HttpContext.Current.Server.MapPath("Report\\WH_TEMPLATE.xlsx");
    COMExcel.Application exapp = new COMExcel.Application();
    COMExcel.Workbook exBook;
    COMExcel.Worksheet exSheet, exSheet2;
    exBook = exapp.Workbooks.Open(fileName);
    exSheet = exBook.Worksheets[1];
    exSheet2 = exBook.Worksheets[2];
    //Write to excel file
    exSheet.Cells[1, 2] = DateTime.Now.Month.ToString() +"-"+DateTime.Now.Year.ToString();
    for (int i = 0; i < DT.Rows.Count; i++)
    {
        exSheet.Cells[i + 2, 1] = i+1;
        for (int j = 0; j < 22; j++)
        {
            exSheet.Cells[i + 2, j+2] = DT.Rows[i][j];
        }
    }
    Amount_Daily(GetDailyAmount(txtfrom.Text.Trim(), txtto.Text.Trim()), fileName, exSheet2);
    string f = "Daily_WH_Report_" + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xls";
    exSheet.SaveAs(HttpContext.Current.Server.MapPath("Report") + "\\" + f);
   // exSheet2.SaveAs(HttpContext.Current.Server.MapPath("Report") + "\\" + f);
    exBook.Close(null, null, null);
    exapp.Workbooks.Close();
    exapp.Quit();
    System.Runtime.InteropServices.Marshal.ReleaseComObject(exSheet);
    System.Runtime.InteropServices.Marshal.ReleaseComObject(exSheet2);
    System.Runtime.InteropServices.Marshal.ReleaseComObject(exBook);
    System.Runtime.InteropServices.Marshal.ReleaseComObject(exapp);
    exSheet = null;
    exSheet2 = null;
    exBook = null;
    exapp = null;
    GC.Collect();
    Download(f, HttpContext.Current.Server.MapPath("Report") + "\\" + f);
   // Ultilities.Export(DT, "Import_export_report");
        }
        private void Amount_Daily(DataTable dtb, string filename, COMExcel.Worksheet exSheet)
        {
         // group 1
                exSheet.Cells[4, 2] = DateTime.Now.ToShortDateString();
                exSheet.Cells[5, 2] = dtb.Rows[0][0];
                exSheet.Cells[6, 2] = dtb.Rows[1][0];
                exSheet.Cells[7, 2] = dtb.Rows[2][0];
                exSheet.Cells[8, 2] = Convert.ToDecimal(dtb.Rows[0][0].ToString()) + Convert.ToDecimal(dtb.Rows[1][0].ToString()) + Convert.ToDecimal(dtb.Rows[2][0].ToString());
                // group 2
                exSheet.Cells[4, 5] = DateTime.Now.ToShortDateString();
                exSheet.Cells[5, 5] = dtb.Rows[3][0];
                exSheet.Cells[6, 5] = dtb.Rows[4][0];
                exSheet.Cells[7, 5] = dtb.Rows[5][0];
                exSheet.Cells[8, 5] = dtb.Rows[6][0];
                exSheet.Cells[9, 5] = dtb.Rows[7][0];
                exSheet.Cells[10, 5] = dtb.Rows[8][0];
                exSheet.Cells[11, 5] = dtb.Rows[9][0];
                exSheet.Cells[12, 5] = dtb.Rows[10][0];
                exSheet.Cells[13, 5] = dtb.Rows[11][0];   
            exSheet.Cells[14, 5] = Convert.ToDecimal(dtb.Rows[3][0].ToString()) + Convert.ToDecimal(dtb.Rows[4][0].ToString()) + Convert.ToDecimal(dtb.Rows[5][0].ToString()) + Convert.ToDecimal(dtb.Rows[6][0].ToString()) + Convert.ToDecimal(dtb.Rows[7][0].ToString()) + Convert.ToDecimal(dtb.Rows[8][0].ToString()) + Convert.ToDecimal(dtb.Rows[9][0].ToString()) + Convert.ToDecimal(dtb.Rows[10][0].ToString()) + Convert.ToDecimal(dtb.Rows[11][0].ToString()); 
                // group 3
                exSheet.Cells[4, 8] = DateTime.Now.ToShortDateString();
                exSheet.Cells[5, 8] = dtb.Rows[12][0];
                exSheet.Cells[6, 8] = dtb.Rows[13][0];
                exSheet.Cells[7, 8] = dtb.Rows[14][0];
                exSheet.Cells[8, 8] = dtb.Rows[15][0];
                exSheet.Cells[9, 8] = dtb.Rows[16][0];
                exSheet.Cells[10, 8] = dtb.Rows[17][0];
                exSheet.Cells[11, 8] = Convert.ToDecimal(dtb.Rows[12][0].ToString()) + Convert.ToDecimal(dtb.Rows[13][0].ToString()) + Convert.ToDecimal(dtb.Rows[14][0].ToString()) + Convert.ToDecimal(dtb.Rows[15][0].ToString()) + Convert.ToDecimal(dtb.Rows[16][0].ToString()) + Convert.ToDecimal(dtb.Rows[17][0].ToString());

                // group 4
                exSheet.Cells[4, 11] = DateTime.Now.ToShortDateString();
                exSheet.Cells[5, 11] = dtb.Rows[18][0];
                exSheet.Cells[6, 11] = dtb.Rows[19][0];
                exSheet.Cells[7, 11] = dtb.Rows[20][0];
                exSheet.Cells[8, 11] = dtb.Rows[21][0];
                exSheet.Cells[9, 11] = dtb.Rows[22][0];     
                exSheet.Cells[10, 11] = Convert.ToDecimal(dtb.Rows[18][0].ToString()) + Convert.ToDecimal(dtb.Rows[19][0].ToString()) + Convert.ToDecimal(dtb.Rows[20][0].ToString()) + Convert.ToDecimal(dtb.Rows[21][0].ToString()) + Convert.ToDecimal(dtb.Rows[22][0].ToString());
                // group 5
                exSheet.Cells[4, 14] = DateTime.Now.ToShortDateString();
                exSheet.Cells[5, 14] = dtb.Rows[23][0];
                exSheet.Cells[6, 14] = dtb.Rows[24][0];
                exSheet.Cells[7, 14] = dtb.Rows[25][0];
                exSheet.Cells[8, 14] = dtb.Rows[26][0];
                exSheet.Cells[9, 14] = dtb.Rows[27][0];
                exSheet.Cells[10, 14] = Convert.ToDecimal(dtb.Rows[23][0].ToString()) + Convert.ToDecimal(dtb.Rows[24][0].ToString()) + Convert.ToDecimal(dtb.Rows[25][0].ToString()) + Convert.ToDecimal(dtb.Rows[26][0].ToString()) + Convert.ToDecimal(dtb.Rows[27][0].ToString()); 
        }
    private DataTable GetDailyAmount(string dbegin, string dEnd)
        { 
         string sql ="  select round(isnull(sum(Quantity * imp_price),0),2) 'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='CNG'  union all  ";
                sql+=" select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='N2' union all "; 
                sql+=" select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='NH3'  union all";  
                sql+=" select round(isnull(sum(Quantity * imp_price),0),2)'Amount ' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='KRAFT PAPER' union all ";  
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'PE FOR APL, STL' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='PE FOR APL, STL'  union all ";  
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'PAPER SPOOL' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='PAPER SPOOL' union all "; 
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'G/STONE' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='G/STONE'  union all "; 
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'ALKALI' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='ALKALI' union all "; 
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'ACID-APL' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='ACID-APL'  union all ";  
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'WATER TREAT' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='WATER TREAT' union all "; 
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'SALT' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='SALT'  union all "; 
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'ETC-PRO' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='ETC-PRO' union all ";
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='OIL'  union all ";  
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='BEARING' union all "; 
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='ELECTRIC SPARE'  union all  ";
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'Amount ' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='MECHANICAL SPARE' union all "; 
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='TOOL'  union all "; 
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='ETC-MAINT' union all "; 
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='PE COVER'  union all "; 
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='IN-OUTER RING' union all "; 
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='STEEL BAND'  union all "; 
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='WOODEN PALLET' union all "; 
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='WATER PROOF, VINYL, ETC'  union all ";  
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='ROLL'  union all ";
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='ROLLING OIL' union all ";
                sql += "select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='BACKUP BEARING'  union all ";
                sql+="select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='ANODE'  union all ";
                sql += "select round(isnull(sum(Quantity * imp_price),0),2)'Amount' from [MATERIAL_MGM].[dbo].[Out_history] where Out_date >= @begin and Out_date <= @End and Note='OIL FILTER' ";
                Dictionary<string, object> param = new Dictionary<string, object>();
                param.Add("@begin", dbegin);
                param.Add("@End", dEnd);
                return mgrDataSQL.ReturnDataTable(sql,param);
        }
       
    }
}