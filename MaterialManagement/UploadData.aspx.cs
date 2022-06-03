using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.IO;
using COMExcel = Microsoft.Office.Interop.Excel;
using System.Diagnostics;
using System.Runtime.InteropServices;
namespace MaterialManagement
{
    public partial class UploadData : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["USERNAME"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }
        protected void btnUpDateList_Click(object sender, EventArgs e)
        {
            string f = Server.MapPath("file/" + fupload.FileName);
            fupload.SaveAs(f);
            DataTable DTB = new DataTable();
            string sql = "Select QCODE,LOCATION from MATERIAL ";
            DTB = mgrDataSQL.ReturnDataTable(sql);
            UpdateData(DTB, f);
            InsertHistory("UPDATE LIST DATA", fupload.FileName);
        }
        private void UpdateData(DataTable DTB1, string filename)
        {
            COMExcel.Application exapp = new COMExcel.Application();
            COMExcel.Workbook exBook;
            COMExcel.Worksheet exSheet;
            COMExcel.Range range;
            exBook = exapp.Workbooks.Open(filename);
            exSheet = exBook.Worksheets[1];
             range = exSheet.UsedRange;
            int count = range.Rows.Count;
            string QCode="", Zone="", Location="", ITEM="", SPEC="", UNIT="", REMARK="", picture="";
            string QTY ="";
            string PRICE = ""; double p = 0;
            for (int i = 2; i <= count; i++)
            {
                Zone = NN(exSheet.Cells[i, 1].value);
                Location = NN(exSheet.Cells[i, 2].value);
                QCode = NN(exSheet.Cells[i, 3].value);
                ITEM = NN(exSheet.Cells[i, 4].value);
                SPEC = NN(exSheet.Cells[i, 5].value);
                UNIT = NN(exSheet.Cells[i, 6].value);
                QTY = NN(exSheet.Cells[i, 7].value);
                p = Math.Round(Convert.ToDouble(DD(exSheet.Cells[i, 8].value)),0);
                PRICE = p.ToString();
                REMARK = NN(range.Cells[i, 9].value);
               picture = NN(range.Cells[i, 10].value);
                //if (IsExist(DTB1, QCode, Location))
                //{
                // EditData(QCode, Zone, Location, ITEM, SPEC, UNIT, QTY, PRICE, REMARK);
                //}
                //else
                Insert(QCode, Zone, Location, ITEM, SPEC, UNIT,QTY, PRICE, REMARK, picture);
            }
            exBook.Close(null, null, null);
            exapp.Workbooks.Close();
            exapp.Quit();
            System.Runtime.InteropServices.Marshal.ReleaseComObject(exSheet);
            System.Runtime.InteropServices.Marshal.ReleaseComObject(exBook);
            System.Runtime.InteropServices.Marshal.ReleaseComObject(exapp);
            exSheet = null;
            exBook = null;
            exapp = null;
            GC.Collect();
            MessageBox.Show(this,"Update Finished");
        }
        public string DD(object a)
        {
            if (a == null)
                return "0";
            else
                return a.ToString().Trim();
        }
        public string NN(object a)
        {
            if (a == null)
                return "";
            else
                return a.ToString().Trim();
        }
        public void Insert(string QCODE, string ZONE, string LOCATION, string ITEM, string SPEC, string UNIT, string QTY, string Price, string REMARK,string Pic)
        {
            string sql = "INSERT INTO MATERIAL (QCODE,ZONE,LOCATION,ITEM,SPEC,UNIT,QTY,PRICE,REMARK,picture) VALUES(@QCODE,@ZONE,@LOCATION,@ITEM,@SPEC,@UNIT,@QTY,@PRICE,@REMARK,@Pic)";
            Dictionary<string, object> param = new Dictionary<string, object>();
            //@IssueDate,@EmpCode, @FullName,@Type,@Amount,@Description,@Note
            param.Add("@QCODE", QCODE);
            param.Add("@ZONE", ZONE);
            param.Add("@LOCATION", LOCATION);
            param.Add("@ITEM", ITEM);
            param.Add("@SPEC", SPEC);
            param.Add("@UNIT", UNIT);
            param.Add("@QTY", QTY);
            param.Add("@PRICE", Price);
            param.Add("@REMARK", REMARK);
            param.Add("@Pic", Pic);
            mgrDataSQL.ExecuteNonQuery(sql, param);
        }
        public void EditData(string QCode, string Zone, string Location, string ITEM, string SPEC, string UNIT, string QTY, string PRICE, string REMARK)
        {
            string sql = "UPDATE MATERIAL SET ZONE=@ZONE,ITEM=@ITEM,SPEC=@SPEC,UNIT=@UNIT,QTY=@QTY,Price=@Price,REMARK=@REMARK WHERE QCode=@QCode and Location = @Location";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@QCODE", QCode);
            param.Add("@ZONE", Zone);
            param.Add("@Location", Location);
            param.Add("@ITEM", ITEM);
            param.Add("@SPEC", SPEC);
            param.Add("@UNIT", UNIT);
            param.Add("@QTY", QTY);
            param.Add("@Price", PRICE);
            param.Add("@REMARK", REMARK);
           // param.Add("@picture", picture);
          mgrDataSQL.ExecuteNonQuery(sql, param);
        }   
      private bool IsExist(DataTable DTB1, string QCode, string Location)
        {
            for (int i = 0; i < DTB1.Rows.Count; i++)
            {
                var Q = DTB1.Rows[i]["QCode"].ToString().Trim();
                var L= DTB1.Rows[i]["LOCATION"].ToString().Trim();

                if ((QCode == Q) && (Location == L))
                {
                    return true;
                }
            }
            return false;
        }
     protected void btnFileUpload_Click(object sender, EventArgs e)
        {
            try
            {
                if (image_upload.HasFile && image_upload.PostedFiles.All(x => x.ContentType == "image/jpeg" && x.ContentLength < 102400))
                {
                    foreach (var file in image_upload.PostedFiles)
                    {
                        file.SaveAs(Server.MapPath("~/images/") + Path.GetFileName(file.FileName));
                       // image_upload.SaveAs(System.IO.Path.Combine(Server.MapPath("~/Images/"), file.FileName));
                    }
                    InsertHistory("UPLOAD LIST IMAGES", image_upload.PostedFiles.Count.ToString()+" IMAGES");
                    MessageBox.Show(this, "File(s) uploaded successfully");
                } 
            }
            catch (Exception ex)
            {
                MessageBox.Show(this, "Error in uploading file" + ex.Message);
            }
        }
        public void InsertHistory(string Operation, string content)
        {
            string struser = Session["USERNAME"].ToString();
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
    }
}