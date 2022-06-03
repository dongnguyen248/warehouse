using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace MaterialManagement.en
{
    public partial class His_export_en : System.Web.UI.Page
    {
        public static DataTable DTB { get; set; }
        public DataTable DTBLine { get; set; }
        public static string userid;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["USERNAME"] != null)
                {
                    userid = Session["USERNAME"].ToString();
                }
                string txtdate = DateTime.Now.Year + "-" + DateTime.Now.Month;
                DTB = LoadDT2(txtdate);
                ViewState["DTB2"] = DTB;
                AddLine(LoadLine());
                //DTBLine = LoadLine();
            }
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
            if (Session["USERNAME"] != null && userid != "admin")
            {
                sql = "select top 100  o.Seq,m.QCODE,o.Pur_Date,o.Out_date,m.ITEM,m.SPEC,m.UNIT,Round(i.PRICE,2) as Price,o.inventory,o.Quantity,(o.inventory-o.Quantity) 'QtyNow',Round((o.Quantity*i.PRICE),1) 'amount',Line,CodeCenter,CostAccount,Requestor,o.Remark from dbo.MATERIAL m, [MATERIAL_MGM].[dbo].[Out_history] o,Import_History i  where m.qcode = o.qcode  and o.QCode=i.QCode and o.Pur_Date = i.Pur_Date  and SUBSTRING(o.Out_Date, 0, 8) = @txtdate and ((o.userid=@userid) or (o.userid is null))  order by o.Out_Date desc";
                param.Add("@userid", userid);
            }
            else
            {
                sql = "select top 100  o.Seq,m.QCODE,o.Pur_Date,o.Out_date,m.ITEM,m.SPEC,m.UNIT,Round(i.PRICE,2) as Price,o.inventory,o.Quantity,(o.inventory-o.Quantity) 'QtyNow',Round((o.Quantity*i.PRICE),1) 'amount',Line,CodeCenter,CostAccount,Requestor,o.Remark from dbo.MATERIAL m, [MATERIAL_MGM].[dbo].[Out_history] o,Import_History i  where m.qcode = o.qcode  and o.QCode=i.QCode and o.Pur_Date = i.Pur_Date  and SUBSTRING(o.Out_Date, 0, 8) = @txtdate  order by o.Out_Date desc";
            }
            param.Add("@txtdate", txtdate);
            return mgrDataSQL.ReturnDataTable(sql, param);
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string txtfrm = txtfrom.Text.Trim();
            string txtt = txtto.Text.Trim();
            string txtcode = txtQCode.Text.Trim();
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
            if (line != "ALL")
            {
                dk += " And Line = @line ";
                param.Add("@line", line);
            }
            string sql = "";
            if (Session["USERNAME"] != null && userid != "admin")
            {
                sql = " select o.Seq,m.QCODE,o.Pur_Date,o.Out_date,m.ITEM,m.SPEC,m.UNIT,Round(i.PRICE,2)as Price,o.inventory,o.Quantity,(o.inventory-o.Quantity) 'QtyNow',Round((o.Quantity*i.PRICE),1) 'amount',Line,CodeCenter,CostAccount,Requestor,o.Remark from dbo.MATERIAL m, [MATERIAL_MGM].[dbo].[Out_history] o,Import_History i  where m.qcode = o.qcode  and o.QCode=i.QCode and o.Pur_Date = i.Pur_Date  " + dk + " and (o.userid=@userid or o.userid is null) order by o.Out_Date desc";
                param.Add("@userid", userid);
            }
            else
            {
                sql = " select o.Seq,m.QCODE,o.Pur_Date,o.Out_date,m.ITEM,m.SPEC,m.UNIT,Round(i.PRICE,2)as Price,o.inventory,o.Quantity,(o.inventory-o.Quantity) 'QtyNow',Round((o.Quantity*i.PRICE),1) 'amount',Line,CodeCenter,CostAccount,Requestor,o.Remark from dbo.MATERIAL m, [MATERIAL_MGM].[dbo].[Out_history] o,Import_History i  where m.qcode = o.qcode  and o.QCode=i.QCode and o.Pur_Date = i.Pur_Date  " + dk + " order by o.Out_Date desc";
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
            string sql = "select t.Pur_Date,t.QCode,t.ITEM,t.SPEC,t.UNIT,t.Price,t.inven1 'inventory',t.IN_QTY,t.OUT_QTY,t.inven1 + t.IN_QTY 'last_inven',0 'amount',t.Supplier as 'line','warehouse' as 'costcenter','NO' as 'codeaccount',''as 'remark' ,'' as 'note','' as 'name' ";
            sql += " from (sELECT ii.Pur_Date,ii.QCode,m.ITEM,m.spec,m.UNIT,ii.PRICE,ii.Supplier ,isnull((SELECT  SUM(I.Quantity) 'IN_QTY' ";
            sql += " FROM Import_History I LEFT JOIN MATERIAL M ";
            sql += " ON I.QCode = M.QCODE ";
            sql += " where I.Pur_Date < ii.Pur_Date ";
            sql += " and i.QCode = ii.QCode),0) -(select SUM(OUT_QTY) 'OUT_QTY' ";
            sql += " from (select  0 'OUT_QTY' union all ";
            sql += " select SUM(O.Quantity) 'OUT_QTY' ";
            sql += " from Out_history o ";
            sql += " LEFT JOIN ";
            sql += " (select i.Pur_Date,i.PRICE ,m.QCODE,I.Quantity, m.ITEM,m.ZONE,m.LOCATION,m.SPEC,m.UNIT ";
            sql += " from MATERIAL m left join Import_History i ";
            sql += " on m.QCODE = i.QCode ) mi ";
            sql += " ON O.QCode = Mi.QCODE and o.Pur_Date = mi.Pur_Date ";
            sql += " WHERE left(O.Out_date,4)+ SUBSTRING(O.Out_date,6,2) + SUBSTRING(O.Out_date,9,2) < ii.Pur_Date ";
            sql += " and o.QCode = ii.QCode) S)  'inven1',(ii.Quantity) 'IN_QTY',0 'OUT_QTY' ";
            sql += " FROM Import_History ii LEFT JOIN MATERIAL M ";
            sql += "ON ii.QCode = M.QCODE ";
            sql += " where ii.Pur_Date BETWEEN @begin AND @end ) t ";
            sql += " union all ";
            sql += "select v.out_date,v.qcode,mi.item,mi.SPEC,mi.UNIT,round(mi.Price,2) 'Price', v.inventory,0 'In_Qty',v.quantity 'Out_Qty', ";
            sql += " v.inventory -v.quantity 'last_inven',round(mi.Price*v.quantity,2) 'amount', ";
            sql += " v.line,v.codecenter,v.costaccount,''as 'remark' ,'' as 'note','' as 'name' ";
            sql += " from V_Out_history v ";
            sql += " LEFT JOIN ";
            sql += " (select i.Pur_Date,i.PRICE ,m.QCODE,I.Quantity, m.ITEM,m.ZONE,m.LOCATION,m.SPEC,m.UNIT ";
            sql += " from MATERIAL m left join Import_History i on m.QCODE = i.QCode ) mi ";
            sql += " ON v.QCode = Mi.QCODE and v.Pur_Date = mi.Pur_Date ";
            sql += " where v.out_date between @begin and @end";
            string bgDate = txtfrom.Text.Trim().Replace("-", "").Replace("-", "");
            string EndDate = txtto.Text.Trim().Replace("-", "").Replace("-", "");
            if (bgDate == "" || EndDate == "")
            {
                MessageBox.Show(this, "Bạn phải chọn ngày bắt đầu và ngày kết thúc để xuất báo cáo!");
                return;
            }
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@begin", bgDate);
            param.Add("@end", EndDate);
            DataTable DT = mgrDataSQL.ReturnDataTable(sql, param);
            Ultilities.Export(DT, "Import_export_report");
        }
    }
}