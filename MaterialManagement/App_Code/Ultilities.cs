using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

namespace MaterialManagement
{
    public class Ultilities
    {
       
        public static void DownLoadFile(string filePath)
        {
            if (filePath != "")
            {
                int ChunkSize = 10000;
                System.IO.FileInfo toDownload =
                new System.IO.FileInfo(filePath);
                if (System.IO.File.Exists(filePath))
                {
                    HttpContext.Current.Response.Clear();
                    using (FileStream iStream = System.IO.File.OpenRead(filePath))
                    {
                        long dataLengthToRead = iStream.Length;
                        Byte[] buffer = new Byte[dataLengthToRead];
                        HttpContext.Current.Response.ContentType = "application/octet-stream";
                        String userAgent = HttpContext.Current.Request.Headers.Get("User-Agent");
                        String filename = toDownload.Name;
                        if (userAgent.Contains("MSIE 7.0"))
                            filename = toDownload.Name.Replace(" ", "%20");
                        HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment; filename=\"" + filename + "\"");
                        while (ChunkSize > 0 && HttpContext.Current.Response.IsClientConnected)
                        {
                            if (ChunkSize > dataLengthToRead)
                            {
                                ChunkSize = int.Parse(dataLengthToRead.ToString());
                            }
                            int lengthRead = iStream.Read(buffer, 0, ChunkSize);
                            HttpContext.Current.Response.OutputStream.Write(buffer, 0, lengthRead);
                            HttpContext.Current.Response.Flush();
                            dataLengthToRead = dataLengthToRead - lengthRead;
                        }
                    }
                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                }
                else
                {
                    HttpContext.Current.Response.Write("File can not found!");
                }
            }
            else
            {
                HttpContext.Current.Response.Write("Please select a file to download!");
            }
        }
        public static void Export(DataTable dtb, string fileTitle = "Export")
        {
            try
            {
                GridView gv = new GridView();
                gv.DataSource = dtb;
                gv.DataBind();

                for (int i = 0; i < gv.Rows.Count; i++)
                {
                    for (int j = 0; j < gv.Columns.Count; j++)
                    {
                        gv.Rows[i].Cells[j].Text.Trim();

                        gv.Rows[i].Cells[j].Attributes.Add("class", "text");
                        gv.Rows[i].Cells[j].Style.Add("mso-number-format", "\\@");
                    }
                }

                string fname = fileTitle + DateTime.Now.ToString("yyyyMMddHHmmss") + ".xls";
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.Buffer = true;
                HttpContext.Current.Response.ContentType = "application/ms-excel";
                HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + fname);
                HttpContext.Current.Response.Charset = "";
                HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.Unicode;
                HttpContext.Current.Response.BinaryWrite(System.Text.Encoding.Unicode.GetPreamble());

                StringWriter sw = new StringWriter();
                HtmlTextWriter htw = new HtmlTextWriter(sw);

                gv.RenderControl(htw);

                HttpContext.Current.Response.Output.Write(sw.ToString());
                HttpContext.Current.Response.Flush();
                HttpContext.Current.Response.End();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static void ExportToExcel(ref string html, string fileName)
        {

            html = html.Replace("&gt;", ">");
            html = html.Replace("&lt;", "<");
            HttpContext.Current.Response.ClearContent();
            HttpContext.Current.Response.AddHeader("content-disposition", "attachment;filename=" + fileName + "_" + DateTime.Now.ToString("yyyy_MM_dd_HH_mm") + ".xls");
            HttpContext.Current.Response.ContentType = "application/xls";
            HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.Unicode;
            HttpContext.Current.Response.BinaryWrite(System.Text.Encoding.Unicode.GetPreamble());

            HttpContext.Current.Response.Write(html);
            HttpContext.Current.Response.Flush();
            HttpContext.Current.Response.End();
        }


    }
}