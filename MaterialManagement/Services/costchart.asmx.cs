using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;

namespace MaterialManagement.Services
{
    /// <summary>
    /// Summary description for costchart
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class costchart : System.Web.Services.WebService
    {

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }
        [WebMethod]
        public int InsertCost(string txtMonth, string txtSum,string txtPacking, string txtMaintain,string txtProduct, string txtOther)
        {
            string sql = "Insert into [MATERIAL_MGM].[dbo].[TB_cost] values(@txtMonth,@txtSum,@txtPacking,@txtMaintain,@txtProduct,@txtOther)";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@txtMonth", txtMonth);
            param.Add("@txtSum", txtSum);
            param.Add("@txtPacking", txtPacking);
            param.Add("@txtMaintain", txtMaintain);
            param.Add("@txtProduct", txtProduct);
            param.Add("@txtOther", txtOther);
            return mgrDataSQL.ExecuteNonQuery(sql,param);
        }
    }
}
