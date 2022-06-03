using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
namespace MaterialManagement
{
    public partial class His_import : Page
    {
        public static DataTable DTB { get; set; }
        public double SumQty { get; set; }
        public static string userid;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["USERNAME"] != null)
                {
                    userid = Session["USERNAME"].ToString();
                }
                string txtdate = DateTime.Now.Year.ToString()+ Change(DateTime.Now.Month);
                DTB = LoadDT2(txtdate);
                ViewState["DTB2"] = DTB;
                AddLine(LoadLine());
                AddNhaCC(LoadNhaCC());
                DateTime date = DateTime.Today;
                var firstDayOfMonth = new DateTime(date.Year, date.Month, 1);
                txtfrom.Text = firstDayOfMonth.ToString("yyyy-MM-dd");
                txtto.Text = DateTime.Today.ToString("yyyy-MM-dd");
            }
        }
        private void AddNhaCC(DataTable DTB3)
        {
            dropNhaCC.Items.Clear();
            dropNhaCC.Items.Add("ALL");
           for (int i = 0; i < DTB3.Rows.Count; i++)
            {
                if (DTB3.Rows[i][0].ToString().Trim() != "")
                {
                    dropNhaCC.Items.Add(DTB3.Rows[i][0].ToString().Trim());
                }
            }
        }
        private void AddLine(DataTable DTB2)
        {
            dropline.Items.Clear();
            dropline.Items.Add("ALL");
            for (int i = 0; i < DTB2.Rows.Count; i++)
            {
                dropline.Items.Add(DTB2.Rows[i][0].ToString().Trim());
            }
        }
        private DataTable LoadLine()
        {
            string sql = "Select LineName from TB_Line";
            return mgrDataSQL.ReturnDataTable(sql);
        }
        private DataTable LoadLine2(string date1, string date2)
        {
            string sql = "  select distinct Receiver from[MATERIAL_MGM].[dbo].[Import_History] where Pur_Date >=@date1 and Pur_Date <=@date2 order by Receiver";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@date1", date1);
            param.Add("@date2", date2);
            return mgrDataSQL.ReturnDataTable(sql, param);
        }
        private DataTable LoadNhaCC()
        {
            string sql = "select distinct supplier from [MATERIAL_MGM].[dbo].[Import_History] order by Supplier ";
            return mgrDataSQL.ReturnDataTable(sql);
        }
        private DataTable LoadNhaCC2(string date1,string date2)
        {
            string sql = "select distinct supplier from[MATERIAL_MGM].[dbo].[Import_History] where Pur_Date >=@date1 and Pur_Date <=@date2 order by Supplier";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@date1",date1);
            param.Add("@date2",date2);
            return mgrDataSQL.ReturnDataTable(sql,param);
        }
        //private DataTable LoadDT1(string txtfrom, string txtto)
        //{
        //    string sql = " select top 50 seq, m.QCODE,i.Pur_Date,m.ITEM,sum(i.Quantity) 'Quantity',Round(i.Price,2)as Price,Po,Supplier,Buyer,Receiver  from dbo.MATERIAL m, dbo.Import_History i where m.qcode = i.qcode and  i.Pur_Date <=@txtfrom And i.Pur_Date <=@txtto  group by Seq,m.QCODE,m.ITEM,m.UNIT,i.Pur_Date,i.Price,Po,Supplier,Buyer,Receiver order by i.Pur_Date Desc ";
        //    Dictionary<string, object> param = new Dictionary<string, object>();
        //    //@IssueDate,@EmpCode, @FullName,@Type,@Amount,@Description,@Note
        //    param.Add("@txtfrom", txtfrom);
        //    param.Add("@txtto", txtto);
        //    return mgrDataSQL.ReturnDataTable(sql,param);
        //}
        private DataTable LoadDT2(string txtdate)
        {
            string sql = "";
            Dictionary<string, object> param = new Dictionary<string, object>();
            if (Session["USERNAME"] != null && userid != "110719")
            {
                sql = "select Seq, m.QCODE,i.Pur_Date,m.ITEM,m.SPEC,Round(sum(i.Quantity),2) 'Quantity',Round(i.Price,2)as Price,Po,Supplier,Buyer,Receiver,Allocated,i.Remark as Remark_New,m.[REMARK],m.LOCATION,locator  from dbo.MATERIAL m, dbo.Import_History i where m.qcode = i.qcode and SUBSTRING(i.Pur_Date, 0, 7) = @txtdate and (userid=@userid or userid is null)  group by Seq,m.QCODE,m.ITEM,m.SPEC,m.UNIT,i.Pur_Date,i.Price,Po,Supplier,Buyer,Receiver,Allocated,i.Remark,m.[REMARK],m.LOCATION,locator order by i.Pur_Date desc";
                param.Add("@userid", userid);
            }
            else
            {
                sql = "select Seq, m.QCODE,i.Pur_Date,m.ITEM,m.SPEC,Round(sum(i.Quantity),2) 'Quantity',Round(i.Price,2)as Price,Po,Supplier,Buyer,Receiver,Allocated,i.Remark as Remark_New,m.[REMARK],m.LOCATION,locator  from dbo.MATERIAL m, dbo.Import_History i where m.qcode = i.qcode and SUBSTRING(i.Pur_Date, 0, 7) = @txtdate  group by Seq,m.QCODE,m.ITEM,m.SPEC,m.UNIT,i.Pur_Date,i.Price,Po,Supplier,Buyer,Receiver,Allocated,i.Remark,m.[REMARK],m.LOCATION,locator order by i.Pur_Date desc";     
            }
            param.Add("@txtdate", txtdate);
            //@IssueDate,@EmpCode, @FullName,@Type,@Amount,@Description,@Note
            return mgrDataSQL.ReturnDataTable(sql, param);
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string txtfrm = txtfrom.Text.Trim().Replace("-","").Replace("-","");
            string txtt = txtto.Text.Trim().Replace("-", "").Replace("-", "");
            string txtcode = txtQCode.Text.Trim();
            string txtPoNum = txtPoNumber.Text.Trim();
            string dk = "";
            string chk = "";
            string line = dropline.SelectedValue;
            string supplier = dropNhaCC.SelectedValue;
            if (chkdanhan.Checked)
            {
                chk = "1";
            }
            else
            {
                chk = "0";
            }
            Dictionary<string, object> param = new Dictionary<string, object>();
            //@IssueDate,@EmpCode, @FullName,@Type,@Amount,@Description,@Note
            if(txtfrm !="")
            {
                dk += "And i.Pur_Date >=@txtfrm ";
                 param.Add("@txtfrm", txtfrm);
            }
            if (txtt != "")
            {
                dk += "And i.Pur_date <=@txtt ";
                param.Add("@txtt", txtt);
            }
            if (txtcode != "")
            {
               dk += "And i.Qcode like '%' + @txtcode + '%'";
                param.Add("@txtcode", txtcode);
            }
            if (txtPoNum != "")
            {
                dk += "And i.Po like '%' + @txtPoNum + '%'";
                param.Add("@txtPoNum", txtPoNum);
            }
            if (chk == "1")
            {
                dk += " And Allocated='1' ";
            }
            if (line != "ALL")
            {
                dk += " And Receiver like '%' +@line +'%' ";
                param.Add("@line",line);
            }
            if (supplier != "ALL")
            {
                dk += " And Supplier like '%'+@Supplier+ '%'  ";
                param.Add("@Supplier", supplier);
            }
 //Dictionary<string, object> param = new Dictionary<string, object>();
            string sql = "";
            if (Session["USERNAME"] != null && userid != "110719")
            {
                sql = " select Seq,m.QCODE,i.Pur_Date,m.ITEM,m.SPEC,Round(sum(i.Quantity),2) 'Quantity',Round(i.Price,2)as Price,Po,Supplier,Buyer,Receiver,Allocated,i.Remark,m.LOCATION,locator from dbo.MATERIAL m, dbo.Import_History i where m.qcode = i.qcode " + dk + " and (i.userid=@userid or i.userid is null) group by Seq,m.QCODE,m.ITEM,m.SPEC,m.UNIT,i.Pur_Date,i.Price,Po,Supplier,Buyer,Receiver,Allocated,i.Remark,m.LOCATION,locator ";
                param.Add("@userid", userid);
            }
            else
            {
                sql = " select Seq,m.QCODE,i.Pur_Date,m.ITEM,m.SPEC,Round(sum(i.Quantity),2) 'Quantity',Round(i.Price,2)as Price,Po,Supplier,Buyer,Receiver,Allocated,i.Remark,m.LOCATION,locator from dbo.MATERIAL m, dbo.Import_History i where m.qcode = i.qcode " + dk + " group by Seq,m.QCODE,m.ITEM,m.SPEC,m.UNIT,i.Pur_Date,i.Price,Po,Supplier,Buyer,Receiver,Allocated,i.Remark,m.LOCATION,locator ";
            }
          //  string sql = " select Seq,m.QCODE,i.Pur_Date,m.ITEM,sum(i.Quantity) 'Quantity',Round(i.Price,2)as Price,Po,Supplier,Buyer,Receiver,Allocated,i.Remark from dbo.MATERIAL m, dbo.Import_History i where m.qcode = i.qcode " + dk + " group by Seq,m.QCODE,m.ITEM,m.UNIT,i.Pur_Date,i.Price,Po,Supplier,Buyer,Receiver,Allocated,i.Remark ";
            DTB = mgrDataSQL.ReturnDataTable(sql,param);
            ViewState["DTB2"] = DTB;
        }
        private string Change(int a)
        {
            if (a > 9)
                return a.ToString();
            else
                return "0" + a.ToString();
        }
        protected void lnkExcel_Click(object sender, EventArgs e)
        {
            DataTable data = (DataTable)ViewState["DTB2"];
            Ultilities.Export(data, "Import_Report");
        }
        protected void txtto_TextChanged(object sender, EventArgs e)
        {
            if (txtfrom.Text != "" && txtto.Text != "")
            {
                string d1 = txtfrom.Text.Replace("-", "").Replace("-", "");
                string d2 = txtto.Text.Replace("-", "").Replace("-", "");
                AddNhaCC(LoadNhaCC2(d1, d2));
                AddLine(LoadLine2(d1, d2));
            }
        }
        protected void txtfrom_TextChanged(object sender, EventArgs e)
        {
            if (txtfrom.Text != "" && txtto.Text != "")
            {
                string d1 = txtfrom.Text.Replace("-", "").Replace("-", "");
                string d2= txtto.Text.Replace("-", "").Replace("-", "");

                AddNhaCC(LoadNhaCC2(d1,d2));
                AddLine(LoadLine2(d1,d2));
            }
        }
    }
}