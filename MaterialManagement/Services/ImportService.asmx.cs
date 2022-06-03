using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
namespace MaterialManagement.Services
{
    /// <summary>
    /// Summary description for ImportServicen
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class ImportService : System.Web.Services.WebService
    {

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }
        [WebMethod]
       public int ModifyImport(string Seq, string QCode, string Imp_date, float txtQty, float txtPrice,string Po, string txtImp_Supplier, string txtImp_Buyer, string txtImp_Receiver, string OldQCode, string OldImp_Date,string GET,string Remark,string locator)
        {
            //DataTable Material = GetMaterial(QCode);
            if ((QCode != OldQCode) || (Imp_date != OldImp_Date))
            {
              int t1=  UpdateImport(Seq, QCode, Imp_date, txtQty, txtPrice,Po, txtImp_Supplier, txtImp_Buyer, txtImp_Receiver,GET,Remark,locator);
              if (CheckQCode(QCode) == false)
              {
                  int t2 = UpdateMaterial(QCode, Imp_date, OldQCode, OldImp_Date);
              }
              else
              {
                  DeleteQcode(OldQCode);
              }
              int t3 = UpdateExport(QCode, Imp_date, OldQCode, OldImp_Date,txtQty);
              return t1;
            }else {
             int a=  UpdateImport(Seq, QCode, Imp_date, txtQty, txtPrice,Po, txtImp_Supplier, txtImp_Buyer, txtImp_Receiver,GET,Remark,locator);
               UpdateExport(QCode, Imp_date, txtQty);
               return a;
            }  
        }
        [WebMethod]
       public ImportInfo LoadImp(string Seq)
        {
            string sql = "Select * from [MATERIAL_MGM].[dbo].[Import_History]  WHERE Seq =@Seq";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@Seq", Seq);
            DataSet ds = new DataSet();
            ds = mgrDataSQL.ReturnDataSet(sql, param);
            ImportInfo pl = new ImportInfo();
            if (ds.Tables[0].Rows.Count > 0)
            {
                DataRow r = ds.Tables[0].Rows[0];
                pl.Seq = r["Seq"].ToString().Trim();
                pl.QCode = r["QCode"].ToString().Trim();
                pl.Pur_Date = r["Pur_Date"].ToString().Trim();
                pl.Quantity =r["Quantity"].ToString().Trim();
                pl.Price = Math.Round(Convert.ToDouble(r["Price"].ToString().Trim()),2).ToString();
                //pl.Quantity = r["Quantity"].ToString();
                pl.Supplier = r["Supplier"].ToString().Trim();
                pl.Buyer = r["Buyer"].ToString().Trim();
                pl.Receiver = r["Receiver"].ToString().Trim();
                pl.Po = r["Po"].ToString().Trim();
                pl.Allocated = r["Allocated"].ToString().Trim();
                pl.Remark = r["Remark"].ToString().Trim();
                pl.locator = r["locator"].ToString().Trim();
            }
            return pl;
        }
        [WebMethod]
      public int Delete(string Seq)
        {
            string sql = "Delete  [MATERIAL_MGM].[dbo].[Import_History] where Seq =@Seq";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@Seq", Seq);
            return mgrDataSQL.ExecuteNonQuery(sql, param);
        }
      public int UpdateImport(string Seq, string QCode, string Imp_date, float txtQty, float txtPrice,string Po, string txtImp_Supplier, string txtImp_Buyer, string txtImp_Receiver,string Get,string Remark,string locator)
        {
            string sql = "Update [MATERIAL_MGM].[dbo].[Import_History] set QCode= @QCode,Pur_Date= @Imp_date,Quantity=@txtQty,Price=@txtPrice,Po = @Po, Supplier=@txtImp_Supplier,Buyer=@txtImp_Buyer,Receiver=@txtImp_Receiver,Allocated=@Get,Remark = @Remark,locator = @locator where Seq = @Seq";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@QCode", QCode);
            param.Add("@Imp_date", Imp_date);
            param.Add("@txtQty", txtQty);
            param.Add("@txtPrice", txtPrice);
            param.Add("@txtImp_Supplier", txtImp_Supplier);
            param.Add("@txtImp_Buyer", txtImp_Buyer);
            param.Add("@txtImp_Receiver", txtImp_Receiver);
            param.Add("@Po", Po);
            param.Add("@Get", Get);
            param.Add("@Seq", Seq);
            param.Add("@Remark", Remark);
            param.Add("@locator", locator);
            int a = mgrDataSQL.ExecuteNonQuery(sql, param);
            return a;
        }
        public int UpdateMaterial(string NewQCode, string NewImpDate, string OldQCode, string OldImpDate)
        {
            string sql = "Update [MATERIAL_MGM].[dbo].[MATERIAL] set QCode = @NewQCode, Pur_Date = @NewImpDate where QCode=@OldQCode and Pur_Date = @OldImpDate";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@NewQCode", NewQCode);
            param.Add("@NewImpDate", NewImpDate);
            param.Add("@OldQCode", OldQCode);
            param.Add("@OldImpDate", OldImpDate);
            int n = mgrDataSQL.ExecuteNonQuery(sql,param);
            return n;
        }
        public void DeleteQcode(string Qcode)
        {
            string sql = "Select * from Update [MATERIAL_MGM].[dbo].[MATERIAL] where Qcode = @Qcode ";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@Qcode", Qcode);
            int n = mgrDataSQL.ExecuteNonQuery(sql, param);
        }
        public int UpdateExport(string NewQCode, string NewImpDate, string OldQCode, string OldImpDate,float Qty)
        {
            string sql = "Update [MATERIAL_MGM].[dbo].[Out_history] set QCode = @NewQCode, Pur_Date = @NewImpDate,inventory=@Qty where QCode=@OldQCode and Pur_Date = @OldImpDate";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@NewQCode", NewQCode);
            param.Add("@NewImpDate", NewImpDate);
            param.Add("@OldQCode", OldQCode);
            param.Add("@OldImpDate", OldImpDate);
            param.Add("@Qty", Qty);
            int n = mgrDataSQL.ExecuteNonQuery(sql, param);
            return n;
        }
        public void UpdateExport(string QCode, string ImpDate, float Qty)
        {
            string sql = "Update [MATERIAL_MGM].[dbo].[Out_history] set inventory=@Qty where QCode=@QCode and Pur_Date = @Pur_Date";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@QCode", QCode);
            param.Add("@Pur_Date", ImpDate);
            param.Add("@Qty", Qty);
            mgrDataSQL.ExecuteNonQuery(sql, param);  
        }
        public bool CheckQCode(string QCode)
        {
            string sql = "Select QCode from  [MATERIAL_MGM].[dbo].[MATERIAL]  WHERE QCode =@QCode";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@QCode", QCode.Trim());
            DataTable dtb = mgrDataSQL.ReturnDataTable(sql, param);
            Material mt = new Material();
            if (dtb.Rows.Count > 0)
            {
                // string infor = "Check:Qcode:" + QCode + ",check:true " + DateTime.Now.ToString("yyyy-mm-dd");
               // mt.writeblog(QCode, infor);
                return true;
            }
            else
            {
               // string infor = "Check:Qcode " + QCode + ",check:false " + DateTime.Now.ToString("yyyy-mm-dd");
              //  mt.writeblog(QCode, infor);
                return false;
            }
        }
    }
}
