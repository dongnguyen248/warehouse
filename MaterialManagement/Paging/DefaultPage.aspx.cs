using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Data;
using System.Web.Script.Services;
namespace MaterialManagement.Paging
{
    public partial class DefaultPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        [WebMethod(Description = "Server Side DataTables support", EnableSession = true)]
        [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
        public static void Data(object parameters, string query)
        {
            var req = DataTableParameters.Get(parameters);
           //req.SearchValue 
            var resultSet = new DataTableResultSet();
            resultSet.draw = req.Draw;
            Material material = new Material();
            DataTable dtb = new DataTable();
            int total = 0;

            // search by table
            //dtb = material.Search(query, req.Start + 1, req.Start + req.Length + 1);
            dtb = material.Search(query, req.Start + 1, req.Start + req.Length + 1);

            total = material.GetRowCount(query);

            //if (!string.IsNullOrWhiteSpace(query))
            //{
            //    // search by table
            //    dtb = material.Search(query, req.Start + 1, req.Start + req.Length + 1);
            //    total = material.GetRowCount(query);
            //}
            //else
            //{
            //    // get all
            //    dtb = material.GetPaging(req.Start + 1, req.Start + req.Length + 1);
            //    total = material.GetRowCount(query);
            //}
            if (total > 0)
            {
                resultSet.recordsTotal = total;/* total number of records in table */
                resultSet.recordsFiltered = total; /* number of records after search - box filtering is applied */
            }
            else if (dtb.Rows.Count > 0)
            {
                resultSet.recordsTotal = Convert.ToInt32(dtb.Rows[0]["total"].ToString());/* total number of records in table */
                resultSet.recordsFiltered = Convert.ToInt32(dtb.Rows[0]["total"].ToString()); /* number of records after search - box filtering is applied */
            }
            foreach (DataRow recordFromDb in dtb.Rows)
            { /* this is pseudocode */
                var columns = new List<string>();
                string stk = Math.Round(Convert.ToDecimal(recordFromDb["Stock"].ToString().Trim()),2).ToString();
                //columns.Add("<input type='checkbox' class='ckb' /><input type='hidden' class='id' value='" + recordFromDb["id"].ToString().Trim() + "' /> <input type='hidden' class='seq' value='" + recordFromDb["seq"].ToString().Trim() + "' />");
                columns.Add("<input type='checkbox' class='ckb' /><input type='hidden' class='id' value='" + recordFromDb["id"].ToString().Trim() + "' />");
                columns.Add(recordFromDb["ZONE"].ToString().Trim());
                columns.Add(recordFromDb["LOCATION"].ToString().Trim());
                columns.Add(recordFromDb["QCODE"].ToString().Trim());
                columns.Add(recordFromDb["ITEM"].ToString().Trim());
                columns.Add(recordFromDb["SPEC"].ToString().Trim());
                columns.Add(recordFromDb["UNIT"].ToString().Trim());
               // columns.Add(recordFromDb["Stock"].ToString().Trim());
                columns.Add(stk);
                columns.Add(recordFromDb["PRICE"].ToString().Trim());
                columns.Add(recordFromDb["Pur_Date"].ToString().Trim());
                columns.Add(recordFromDb["REMARK"].ToString().Trim());
                columns.Add(recordFromDb["REMARK_NEW"].ToString().Trim());
                columns.Add(recordFromDb["locator"].ToString().Trim());
                /* you may add as many columns as you need. Each column is a string in the List<string> */
                resultSet.data.Add(columns);
            }
            SendResponse(HttpContext.Current.Response, resultSet);
        }
        private static void SendResponse(HttpResponse response, DataTableResultSet result)
        {
            response.Clear();
            response.Headers.Add("X-Content-Type-Options", "nosniff");
            response.Headers.Add("X-Frame-Options", "SAMEORIGIN");
            response.ContentType = "application/json; charset=utf-8";
            response.Write(result.ToJSON());
            response.Flush();
            response.End();
        }
    }
}