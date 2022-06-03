using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.IO;
using KeepAutomation.Barcode.Bean;
using KeepAutomation.Barcode;
using MaterialManagement.DTO;

namespace MaterialManagement
{
    /// <summary>
    /// Summary description for DefaultService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class DefaultService : System.Web.Services.WebService
    {
        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }
        [WebMethod]
        public List<string> GetSupplier(string prefix)
        {
            List<string> supplier = new List<string>();
            string sql = "SELECT DISTINCT(Supplier) FROM [MATERIAL_MGM].[dbo].[Import_History] where supplier like '%'+ @prefix +'%'";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@prefix", prefix);
            DataTable dtb = mgrDataSQL.ReturnDataTable(sql, param);
            if (dtb.Rows.Count > 0)
            {
                for (int i = 0; i < dtb.Rows.Count; i++)
                {
                    supplier.Add(dtb.Rows[i][0].ToString().Trim());
                }
            }
            return supplier;
        }
        [WebMethod]
        public List<string> GetZone(string prefix)
        {
            List<string> Zone = new List<string>();
            //string sql = "SELECT DISTINCT(Zone) FROM [MATERIAL_MGM].[dbo].[MATERIAL] where Zone like '%'+ @prefix +'%'";
            //Dictionary<string, object> param = new Dictionary<string, object>();
            //param.Add("@prefix", prefix);
            //DataTable dtb = mgrDataSQL.ReturnDataTable(sql, param);
            //if (dtb.Rows.Count > 0)
            //{
            //    for (int i = 0; i < dtb.Rows.Count; i++)
            //    {
            //        Zone.Add(dtb.Rows[i][0].ToString().Trim());
            //    }
            //}
            String[] myArr = new String[] { "PSL", "OUTSIDE FACTORY", "KEEP BY USER", "HUGE MATERIALS ZONE", "ELECTRIC WAREHOUSE", "SECOND WAREHOUSE", "KRAFT PAPER SPACE", "UPDATING", "EVERY MONTHS ISSUE", "LINE", "FACTORY", "MAIN WAREHOUSE", "WWT" };
            Zone.AddRange(myArr);

            return Zone;
        }
        [WebMethod]
        public List<string> GetLocation(string prefix)
        {
            List<string> LOCATION = new List<string>();
            string sql = "SELECT DISTINCT(LOCATION) FROM [MATERIAL_MGM].[dbo].[MATERIAL] where LOCATION like '%'+ @prefix +'%'";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@prefix", prefix);
            DataTable dtb = mgrDataSQL.ReturnDataTable(sql, param);
            if (dtb.Rows.Count > 0)
            {
                for (int i = 0; i < dtb.Rows.Count; i++)
                {
                    LOCATION.Add(dtb.Rows[i][0].ToString().Trim());
                }
            }
            return LOCATION;
        }
        [WebMethod]
        public List<string> Getlocator(string prefix)
        {
            List<string> locator = new List<string>();
            string sql = "SELECT DISTINCT(locator) FROM [MATERIAL_MGM].[dbo].[Import_History] where locator like '%'+ @prefix +'%'";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@prefix", prefix);
            DataTable dtb = mgrDataSQL.ReturnDataTable(sql, param);
            if (dtb.Rows.Count > 0)
            {
                for (int i = 0; i < dtb.Rows.Count; i++)
                {
                    locator.Add(dtb.Rows[i][0].ToString().Trim());
                }
            }
            return locator;
        }

        [WebMethod]
        public MaterialDTO ItemAndSpec(string prefix)
        {
            string sql = "SELECT DISTINCT SPEC,ITEM FROM [MATERIAL_MGM].[dbo].MATERIAL where QCODE like '%'+ @prefix +'%' ";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@prefix", prefix.Trim());

            DataTable dtb = mgrDataSQL.ReturnDataTable(sql, param);
            MaterialDTO material = new MaterialDTO();
            if (dtb.Rows.Count > 0)
            {
                material.Spec = dtb.Rows[0][0].ToString();
                material.Item = dtb.Rows[0][1].ToString();
            }

            return material;
        }



        [WebMethod]
        public List<string> GetUnit(string prefix)
        {
            List<string> UNIT = new List<string>();
            string sql = "SELECT DISTINCT(UNIT) FROM [MATERIAL_MGM].[dbo].[MATERIAL] where UNIT like '%'+ @prefix +'%'";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@prefix", prefix);
            DataTable dtb = mgrDataSQL.ReturnDataTable(sql, param);
            if (dtb.Rows.Count > 0)
            {
                for (int i = 0; i < dtb.Rows.Count; i++)
                {
                    UNIT.Add(dtb.Rows[i][0].ToString().Trim());
                }
            }
            return UNIT;
        }
        [WebMethod]
        public int GenerateBarcode(string Qcode)
        {
            BarCode barcode = new BarCode();
            barcode.Symbology = KeepAutomation.Barcode.Symbology.Code128B;

            barcode.CodeToEncode = Qcode;
            string path = Server.MapPath("BarCode/" + Qcode + ".png");
            if (path.Contains("\\Services"))
            {
                path = path.Replace("\\Services", "");
            }
            barcode.generateBarcodeToImageFile(path);
            return 1;
        }
        [WebMethod(EnableSession = true)]
        public int Insert(string QCode, string Zone, string Location, string Item, string Spec, string Unit, string Qty, string Price, string Po, string Remark, string Pur_Date, string Supplier, string Buyer, string Receiver, string Get, string locator, string chkInpection, string Inpector, string Inpecdate, string Resultinpection)
        {
            string UserID = HttpContext.Current.Session["USERNAME"].ToString();
            if (string.IsNullOrWhiteSpace(QCode))
            {
                QCode = GenerateId();
            }
            if (CheckQCode(QCode))
            {
                Import_His(QCode, Pur_Date, Qty, Price, Po, Supplier, Buyer, Receiver, Get, UserID, locator, chkInpection, Inpector, Inpecdate, Resultinpection);
                Material mt = new Material();
                // string infor = "Import number:Qcode "+ QCode + "check:true;Pur_Date " + Pur_Date;
                //  mt.writeblog(QCode, infor);
                return 1;
            }
            else
            {
                Material mt = new Material();
                int a = mt.Insert(QCode, Zone, Location, Item, Spec, Unit, Remark, Pur_Date);
                Import_His(QCode, Pur_Date, Qty, Price, Po, Supplier, Buyer, Receiver, Get, UserID, locator, chkInpection, Inpector, Inpecdate, Resultinpection);
                //    string infor = "Create new material:Qcode " + QCode + "check:false; Pur_Date " + Pur_Date;
                //  mt.writeblog(QCode, infor);
                //  InsertHistory("INSERT DATA", data);
                if (a > 0)
                    return findID();
                return -1;
            }
        }
        [WebMethod]
        public int Update(int ID, string QCode, string Zone, string Location, string Item, string Spec, string Unit, string Qty, string Price, string Remark, string Pur_Date, string chkInpection, string Inpector, string Inpecdate, string Resultinpection, int Seq)
        {
            // string data = "QCode:" + QCode + ";Zone:" + Zone + ";Location:" + Location + ";Item:" + Item;
            Material mt = new Material();
            //UpdateQtyImport(QCode, Pur_Date, Qty, Price);
           var result =  UpdateInpection(chkInpection, Inpector, Inpecdate, Resultinpection, Seq);
            string oldQcode = GetOldeQcode(ID).Trim();
            string info = "Update OldQcode " + oldQcode + " NewQcode:" + QCode + " Zone: " + Zone + " Location:" + Location + " Pur_Date: " + Pur_Date;
            //   mt.writeblog(QCode, info);
            if (oldQcode != QCode)
            {
                if (CheckQCode(QCode))
                {
                    return 0;
                }
                else
                    return mt.Update(ID, QCode, Zone, Location, Item, Spec, Unit, Remark, Pur_Date);
            }
            else
            {
                mt.UpdateRemarkImportHistory(Seq, Remark);
                return mt.Update(ID, QCode, Zone, Location, Item, Spec, Unit, Remark, Pur_Date);
            }

        }
        public int  UpdateInpection(string chkInpection, string Inpector, string Inpecdate, string Resultinpection, int Seq)
        {
            string sql = "Update Import_History set [INSPECTION] = @INSPECTION ,[INSPECTION_DATE] = @INSPECTION_DATE,[INSPECTOR] = @INSPECTOR,[RESULT] = @RESULT where Seq = @Seq";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@INSPECTION", chkInpection);
            param.Add("@INSPECTION_DATE", Inpecdate);
            param.Add("@INSPECTOR", Inpector);
            param.Add("@RESULT", Resultinpection);
            param.Add("@Seq", Seq);
            return mgrDataSQL.ExecuteNonQuery(sql, param);
        }
        [WebMethod(EnableSession = true)]
        public int OutPut(string QCode, string import_date, string out_date, string txtLine, string txtInvenQty, string txtQuantity, string txtCostAcount, string txtRequestor, string txtRemark, string txtCodeCenter, string txtNote, string price, string locator)
        {
            string UserID = HttpContext.Current.Session["USERNAME"].ToString();
            //  QCode: QCode, import_date: import_date, out_date: out_date, txtLine: txtLine, txtInvenQty: txtInvenQty, txtQuantity: txtQuantity, txtCostAcount: txtCostAcount, txtRequestor: txtRequestor, txtRemark: txtRemark
            string sql = "Insert into [MATERIAL_MGM].[dbo].[Out_history](QCode,Pur_Date,Out_date,inventory,Quantity,Line,CodeCenter,CostAccount,Requestor,Remark,userid,Note,Imp_Price,Locator) values(@QCode,@import_date,@out_date,@inventory,@txtQuantity,@Line,@CodeCenter,@CostAccount,@txtRequestor,@Remark,@UserID,@Note,@price,@locator)";
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
            param.Add("@QCode", QCode);
            param.Add("@import_date", import_date);
            param.Add("@out_date", out_date);
            param.Add("@Line", txtLine);
            param.Add("@txtQuantity", txtQuantity);
            param.Add("@txtRequestor", txtRequestor);
            param.Add("@inventory", txtInvenQty);
            param.Add("@CodeCenter", codecenter);
            param.Add("@CostAccount", txtCostAcount);
            param.Add("@Remark", txtRemark);
            param.Add("@UserID", UserID);
            param.Add("@Note", txtNote);
            param.Add("@price", price);
            param.Add("@locator", locator);
            int a = mgrDataSQL.ExecuteNonQuery(sql, param);
            UnGet(QCode, import_date, price);
            //int newqty = int.Parse(txtInvenQty) - int.Parse(txtQuantity);
            //updateQuantity(QCode, import_date, newqty);
            return a;
        }
        [WebMethod(EnableSession = true)]
        public int ImportMaterial(string QCode, string Imp_date, string txtQty, string txtPrice, string Po, string txtImp_Supplier, string txtImp_Buyer, string txtImp_Receiver, string Get, string locator,
            string INSPECTION, string INSPECTION_DATE, string INSPECTOR, string RESULT
         )
        {
            string UserID = HttpContext.Current.Session["USERNAME"].ToString();
            Import_His(QCode, Imp_date, txtQty, txtPrice, Po, txtImp_Supplier, txtImp_Buyer, txtImp_Receiver, Get, UserID, locator, INSPECTION, INSPECTOR, INSPECTION_DATE, RESULT);
            return 1;
        }
        [WebMethod]
        public int Delete(int ID)
        {
            // string data = "QCode:"+ GETQCode(ID);
            //  InsertHistory("DELETE DATA", data);
            Material mt = new Material();
            return mt.Delete(ID);
        }
        [WebMethod]
        public int AddUser(string Username, string Password, int Role)
        {
            Users u = new Users();
            bool exist = u.CheckExist(Username);
            if (exist)
                return -1;
            return u.Insert(Username, Password, Role);
        }
        [WebMethod(EnableSession = true)]
        public void LogOut()
        {

            Session.Abandon();
        }
        private string GetLineCode(string line)
        {
            string sql = "Select CostCenter from TB_Line where LineName = @line";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@line", line);
            return mgrDataSQL.ExecuteScalar(sql, param).ToString();
        }
        private DataTable GetMaterial(string Qcode)
        {
            string sql = "Select * from [MATERIAL_MGM].[dbo].[MATERIAL] where QCODE=@Qcode ";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@Qcode", Qcode);
            return mgrDataSQL.ReturnDataTable(sql, param);
        }
        public int findID()
        {
            string sql = "Select max(id) from [MATERIAL_MGM].[dbo].[MATERIAL]";
            return Convert.ToInt32(mgrDataSQL.ExecuteScalar(sql));
        }
        public void updateQuantity(string Qcode, string Pur_Date, string NewQty)
        {
            string sql = "Update MATERIAL set QTY = @NewQty where QCode=@QCode and Pur_Date=@Pur_Date";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@Qcode", Qcode);
            param.Add("@Pur_Date", Pur_Date);
            param.Add("@NewQty", NewQty);
            mgrDataSQL.ExecuteNonQuery(sql, param);
        }
        public void Import_His(string QCode, string Pur_Date, string Quantity, string Price, string Po, string Supplier, string Buyer, string Receiver, string Get, string UserID, string locator, string chkInpection, string Inpector, string Inpecdate, string Resultinpection)
        {
            string sql = "Insert into Import_History(QCode,Pur_Date,Quantity,Price,Po,Supplier,Buyer,Receiver,Allocated,userid,locator,INSPECTION,INSPECTION_DATE,INSPECTOR,RESULT) values(@Qcode,@Pur_Date,@Quantity,@Price,@Po,@Supplier,@Buyer,@Receiver,@Allocated,@userid,@locator,@chkInpection,@Inpecdate,@Inpector,@Resultinpection)";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@Qcode", QCode);
            param.Add("@Pur_Date", Pur_Date);
            param.Add("@Quantity", Quantity);
            param.Add("@Price", Price);
            param.Add("@Po", Po);
            param.Add("@Supplier", Supplier);
            param.Add("@Buyer", Buyer);
            param.Add("@Receiver", Receiver);
            param.Add("@Allocated", Get);
            param.Add("@userid", UserID);
            param.Add("@locator", locator);
            param.Add("@chkInpection", chkInpection);
            param.Add("@Inpecdate", Inpecdate);
            param.Add("@Inpector", Inpector);
            param.Add("@Resultinpection", Resultinpection);
            mgrDataSQL.ExecuteNonQuery(sql, param);
        }
        //---- thanh edit
        public void Import_His(string QCode, string Pur_Date, string Quantity, string Price, string Po, string Supplier, string Buyer, string Receiver, string Get, string UserID, string locator)
        {
            string sql = "Insert into Import_History(QCode,Pur_Date,Quantity,Price,Po,Supplier,Buyer,Receiver,Allocated,userid,locator) values(@Qcode,@Pur_Date,@Quantity,@Price,@Po,@Supplier,@Buyer,@Receiver,@Allocated,@userid,@locator)";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@Qcode", QCode);
            param.Add("@Pur_Date", Pur_Date);
            param.Add("@Quantity", Quantity);
            param.Add("@Price", Price);
            param.Add("@Po", Po);
            param.Add("@Supplier", Supplier);
            param.Add("@Buyer", Buyer);
            param.Add("@Receiver", Receiver);
            param.Add("@Allocated", Get);
            param.Add("@userid", UserID);
            param.Add("@locator", locator);
            mgrDataSQL.ExecuteNonQuery(sql, param);
        }
        //-------end
        private void UpdateQtyImport(string Qcode, string Pur_Date, string Qty, string Price)
        {
            string sql = "Update Import_History set Quantity=@Quantity, Price = @Price where Qcode = @Qcode and Pur_Date = @Pur_Date ";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@Qcode", Qcode);
            param.Add("@Pur_Date", Pur_Date);
            param.Add("@Quantity", Qty);
            param.Add("@Price", Price);
            mgrDataSQL.ExecuteNonQuery(sql, param);
        }
        public void InsertHistory(string Operation, string content)
        {
            string struser = "Admin";
            string t = DateTime.Now.ToString("yyyyMMdd") + " " + createuptimes();
            string sql = "Insert into TB_History (UserName,IP,Operation,Contention,ModifyDate) values (@User,@IP,@Operation,@Contention,@ModifyDate)";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@User", struser);
            param.Add("@IP", GetIP().Trim());
            param.Add("@Operation", Operation.Trim());
            param.Add("@Contention", content);
            param.Add("@ModifyDate", t);
            mgrDataSQL.ExecuteNonQuery(sql, param);
        }
        public string GETQCode(int id)
        {
            string sql = "Select QCODE from  [MATERIAL_MGM].[dbo].[MATERIAL] where id=@ID ";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@ID", id);
            return mgrDataSQL.ExecuteScalar(sql, param).ToString();
        }
        public string createuptimes()
        {
            string strtime = "";
            string h, m;
            h = DateTime.Now.Hour.ToString();
            m = DateTime.Now.Minute.ToString();
            if (h.Length == 1)
            {
                h = "0" + h;
            }
            if (m.Length == 1)
            {
                m = "0" + m;
            }
            strtime = h + ":" + m;
            return strtime;
        }
        public string GetIP()  // Get IP Address
        {
            string ipaddress;
            ipaddress = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            if (ipaddress == "" || ipaddress == null)
                ipaddress = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
            return ipaddress;
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
                //string infor = "Check:Qcode:" + QCode + ",check:true " + DateTime.Now.ToString("yyyy-mm-dd");
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
        public void UnGet(string Qcode, string pur_date, string price)
        {
            string sql = "Update Import_History set Allocated = '0' where Qcode=@Qcode and Pur_Date = @Pur_Date and round(Price,2)=@Price";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@QCode", Qcode);
            param.Add("@Pur_Date", pur_date);
            param.Add("@Price", Math.Round(Convert.ToDouble(price), 2));
            mgrDataSQL.ExecuteNonQuery(sql, param);
        }
        public string GetOldeQcode(int id)
        {
            string sql = "Select Qcode from [MATERIAL_MGM].[dbo].[MATERIAL] where ID = @ID";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@ID", id);
            return mgrDataSQL.ExecuteScalar(sql, param).ToString();
        }
        public string GenerateId()
        {
            string id = "";
            string sql = " select top 1 CONVERT(INT, SUBSTRING(QCode,3,LEN(QCode)) )AS CODE  from  [MATERIAL_MGM].[dbo].[MATERIAL]  WHERE QCode LIKE 'NO%' order by CODE desc";
            DataTable DTB = mgrDataSQL.ReturnDataTable(sql);
            if (DTB.Rows.Count == 0)
            {
                id = "NO" + "01";
            }
            else
            {
                // string subfix = dtb.Rows[0]["ID"].ToString().Trim();
                string str = DTB.Rows[0][0].ToString();
                string num = (Convert.ToInt32(str) + 1).ToString();
                int t = Convert.ToInt32(num);
                if (t < 10)
                {
                    id = "NO0" + num;
                }
                else
                {
                    id = "NO" + num;
                }
            }
            return id;
        }
        public int UpdateImport(string QCode, string OldQcode)
        {
            string sql = "Update [MATERIAL_MGM].[dbo].[Import_History] set QCode= @QCode where Qcode = @OldQcode";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@QCode", QCode);
            param.Add("@OldQcode", OldQcode);
            int a = mgrDataSQL.ExecuteNonQuery(sql, param);
            return a;
        }
        public int UpdateExport(string QCode, string OldQcode)
        {
            string sql = "Update [MATERIAL_MGM].[dbo].[Out_history] set QCode= @QCode where Qcode = @OldQcode";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@QCode", QCode);
            param.Add("@OldQcode", OldQcode);
            int a = mgrDataSQL.ExecuteNonQuery(sql, param);
            return a;
        }
        [WebMethod]
        public Dictionary<string, object> SelectInpectionBySeq(int id)
        {
            string sql = "Select [INSPECTION],cast(NULLIF([INSPECTION_DATE],'') as datetime) as INSPECTION_DATE,[INSPECTOR],[RESULT] from [MATERIAL_MGM].[dbo].[Import_History] where seq = @ID";
            Dictionary<string, object> param1 = new Dictionary<string, object>();
            param1.Add("@ID", id);
            var restult = mgrDataSQL.ReturnDataTable(sql, param1);
            //var t = restult.Rows[0]["INSPECTION"].ToString();
            Dictionary<string, object> param = new Dictionary<string, object>();
            if (!string.IsNullOrEmpty(restult.Rows[0]["INSPECTION_DATE"].ToString()))
            {
                param.Add("INSPECTION_DATE", Convert.ToDateTime(restult.Rows[0]["INSPECTION_DATE"]).ToString("yyyy-MM-dd"));
            }
            param.Add("INSPECTION", restult.Rows[0]["INSPECTION"]);
            param.Add("INSPECTOR", restult.Rows[0]["INSPECTOR"]);
            param.Add("RESULT", restult.Rows[0]["RESULT"]);
            return param;
        }
    }
}
