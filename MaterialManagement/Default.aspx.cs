using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using KeepAutomation.Barcode.Bean;
using KeepAutomation.Barcode;
using System.IO;

namespace MaterialManagement
{
    public partial class Default : System.Web.UI.Page
    {
        //protected DataTable Zones { get; set; }
        //protected DataTable Loc { get; set; }
        //protected DataTable Unit { get; set; }
        //protected DataTable Supplier { get; set; }
        public static DataTable DTB { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtNow.Value = DateTime.Now.Year + "-" + Change(DateTime.Now.Month) + "-" + Change(DateTime.Now.Day);
                string param1 = HttpContext.Current.Request.QueryString.Get("value");
                if (!string.IsNullOrEmpty(param1))
                {
                    string dk = " And LOCATION like '" + param1 + "%' ";
                    hdQuery.Value = dk;
                }
                //hdQuery.Value = "";
                //LoadData();
                //  Material mt = new Material();
                DTB = new DataTable();
            }
        }
        private string Change(int a)
        {
            if (a > 9)
                return a.ToString();
            else
                return "0" + a.ToString();
        }
        //private void LoadData()
        //{
        //    Material mt = new Material();
        //    Zones = mt.GetZone();
        //    Loc = mt.GetLocation();
        //    Unit = mt.GetUnit();
        //    Supplier = mt.GetSupplier();
        //}
        protected void btnExport_Click(object sender, EventArgs e)
        {
            Material mt = new Material();
            DataTable data = mt.Search2(hdQuery.Value);
            Ultilities.Export(data, "Material");
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string dk = "";
            var txtNameDive = TextNameDevice.Text.Trim();
            var txtQcode = TextQcode.Text.Trim();
            var txtZone = TextZone.Text.Trim();
            var txtLocation = TextLocation.Text.Trim();
            var txtSpec = TextSpec.Text.Trim();

            dk += "and Zone like '%" + txtZone + "%' and LOCATION like '%" + txtLocation + "%' and m.QCode like '%" + txtQcode + "%' and Item like '%" + txtNameDive + "%'  and Spec like '%" + txtSpec + "%'";

            hdQuery.Value = dk;
        }    
    }
    public static class MessageBox
    {
        public static void Show(this Page Page, String Message)
        {
            Page.ClientScript.RegisterStartupScript(
            Page.GetType(),
            "MessageBox",
            "<script language='javascript'>alert('" + Message + "');</script>"
         );
        }
    }
}