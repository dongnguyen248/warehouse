using System;
using System.Collections.Generic;
using System.Web;

namespace MaterialManagement

{
    /// <summary>
    /// Summary description for FileUploadHandler
    /// </summary>
    public class FileUploadHandler : IHttpHandler
    {
        public void DownloadImage(HttpContext context)
        {
       
          string fff=  context.Request.QueryString["file"];
            HttpFileCollection files = context.Request.Files;
           // string ff = context.Request["filename"].Trim();
            string f = context.Server.MapPath("~/BarCode/" + fff);
            Ultilities.DownLoadFile(f);
        }
        public void ProcessRequest(HttpContext context)
        {

            string fff = context.Request.QueryString["file"];
            if (fff != "")
            {
                HttpFileCollection files = context.Request.Files;
                // string ff = context.Request["filename"].Trim();
                string f = context.Server.MapPath("~/BarCode/" + fff+".png");
                Ultilities.DownLoadFile(f);
            }
            if (context.Request.Files.Count > 0)
            {
                HttpFileCollection files = context.Request.Files;
                string QCode = context.Request["QCode"].Trim();
                string id = context.Request["ID"].Trim();
               // string seq = GetSEQ(idx);
                for (int i = 0; i < files.Count; i++)
                {
                    HttpPostedFile file = files[i];
                    string fname = context.Server.MapPath("~/images/" + QCode +"_"+ file.FileName);
                    file.SaveAs(fname);
                    string f = QCode + "_" + file.FileName;
                //    insertfile(idx, seq, file.FileName);
                  //  updatetime(idx);
                    updateimage(id, f);
                }
                context.Response.ContentType = "text/plain";
                context.Response.Write("File Uploaded Successfully!");
            }
        }
        public void updateimage(string idx,string fname)
        {
         // string lastup = DateTime.Now.ToString("yyyyMMdd") + " " + createuptimes();
            string sql = "Update  [MATERIAL_MGM].[dbo].[MATERIAL] set picture=@fname where id =@idx";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@fname", fname);
            param.Add("@idx", idx.Trim());
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
        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}