using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
namespace MaterialManagement.Services
{
    /// <summary>
    /// Summary description for ExportService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class ExportService : System.Web.Services.WebService
    {
        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }
        [WebMethod]
        public ExportInfo LoadEX(string Seq)
        {
            string sql = "Select * from Out_history  WHERE Seq =@Seq";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@Seq", Seq);
            DataSet ds = new DataSet();
            ds = mgrDataSQL.ReturnDataSet(sql, param);
            ExportInfo pl = new ExportInfo();
            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow r = ds.Tables[0].Rows[0];
                pl.Seq = r["Seq"].ToString().Trim();
                pl.QCode = r["QCode"].ToString().Trim();
                pl.Pur_Date = r["Pur_Date"].ToString().Trim();
                pl.Out_date = r["Out_date"].ToString().Trim();
                pl.inventory = r["inventory"].ToString().Trim();
                pl.Quantity = r["Quantity"].ToString();
                pl.Line = r["Line"].ToString().Trim();
                pl.CodeCenter = r["CodeCenter"].ToString().Trim();
                pl.CostAccount = r["CostAccount"].ToString().Trim();
                pl.Requestor = r["Requestor"].ToString().Trim();
                pl.Remark = r["Remark"].ToString().Trim();
                pl.Note = r["Note"].ToString().Trim();
                pl.locator = r["Locator"].ToString().Trim();
            }
            return pl;
        }
        [WebMethod]
        public int Delete(string Seq)
        {
            string sql = "Delete  [MATERIAL_MGM].[dbo].[Out_history] where Seq =@Seq";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@Seq", Seq);
            return mgrDataSQL.ExecuteNonQuery(sql, param);
        }
        [WebMethod]
        public int UpdateExport(string Seq,string QCode, string import_date, string out_date, string txtLine, string txtInvenQty, string txtQuantity, string txtCostAcount, string txtRequestor, string txtRemark, string txtCodeCenter,string txtNote,string locator)
        {
            //  QCode: QCode, import_date: import_date, out_date: out_date, txtLine: txtLine, txtInvenQty: txtInvenQty, txtQuantity: txtQuantity, txtCostAcount: txtCostAcount, txtRequestor: txtRequestor, txtRemark: txtRemark
            string sql = "Update [MATERIAL_MGM].[dbo].[Out_history] set Out_date=@Out_date,Quantity=@Quantity,Line=@Line,CodeCenter=@CodeCenter,CostAccount=@CostAccount,Requestor=@Requestor,Remark=@Remark,Note=@Note,Locator= @locator where Seq = @Seq";
            string codecenter = "";
            if (txtCodeCenter == "")
            {
                codecenter = GetLineCode(txtLine);
            }
            else
            {
                codecenter = txtCodeCenter;
            }
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@Seq", Seq);
          //param.Add("@import_date", import_date);
            param.Add("@out_date", out_date);
            param.Add("@Line", txtLine);
            param.Add("@Quantity", txtQuantity);
            param.Add("@Requestor", txtRequestor);
           // param.Add("@inventory", txtInvenQty);
            param.Add("@CodeCenter", codecenter);
            param.Add("@CostAccount", txtCostAcount);
            param.Add("@Remark", txtRemark);
            param.Add("@Note", txtNote);
            param.Add("@locator", locator);
            int a = mgrDataSQL.ExecuteNonQuery(sql, param);
            //int newqty = int.Parse(txtInvenQty) - int.Parse(txtQuantity);
            //updateQuantity(QCode, import_date, newqty);
            return a;
        }
        private string GetLineCode(string line)
        {
            string sql = "Select CostCenter from TB_Line where LineName = @line";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@line", line);
            return mgrDataSQL.ExecuteScalar(sql, param).ToString().Trim();
        }
    }
}
