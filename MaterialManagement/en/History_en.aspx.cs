using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace MaterialManagement.en
{
    public partial class History_en : System.Web.UI.Page
    {
        protected DataTable DTB { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DTB = LoadDT();
            }
        }
        private DataTable LoadDT()
        {
            string sql = "Select * from TB_History order by ModifyDate";
            return mgrDataSQL.ReturnDataTable(sql);
        }
    }
}