using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.Data;
using System.Web.Script.Serialization;
namespace MaterialManagement
{
    public partial class Costchart : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string y = DateTime.Now.Year.ToString();
                settime();
                Drawingcolumnchart(y);
                hddate.Value = DateTime.Now.ToString("yyyyMM");
            }
        }
        public void Drawingcolumnchart(string year)
        {
            //string frday = DateTime.Now.Year.ToString() + createday(m) + "01";
            //string today = DateTime.Now.Year.ToString() + createday(m) + "31";
            string sql = "select * from [MATERIAL_MGM].[dbo].[TB_cost] where times like '"+year+"%' order by times";

            List<string> listwgt = new List<string>();
            List<string> listname = new List<string>();
            DataTable dtb = mgrDataSQL.ReturnDataTable(sql);
            int num = dtb.Rows.Count;
            if (num > 0)
            {
                for (int i = 0; i < num; i++)
                {
                    DataRow r = dtb.Rows[i];
                   // listcust.Add(r[0].ToString());
                    AddValue(listname,listwgt,r);
                }
                for (int i = 0; i < 12; i++)
                {
                    int n = listwgt.Count;
                    if (n < 45)
                    {
                        AddValue(listname,listwgt);
                    }
                }
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                string jsonname = serializer.Serialize(listname);
                string jsonwgt = serializer.Serialize(listwgt);
                hdname.Value = jsonname;
                hdwgt.Value = jsonwgt;
            }
        }
   private void AddValue(List<string> Lname,List<string> L, DataRow r)
    {
        Lname.Add("A");
        Lname.Add("B");
        Lname.Add("C");
        Lname.Add("D");
        for (int i = 2; i <= 5; i++)
        {
         L.Add(Math.Round( Convert.ToDouble(r[i].ToString().Trim().Replace(",",""))/1000,0).ToString());
        }
    }
   private void AddValue(List<string> Lname, List<string> L)
   {
       Lname.Add(".");
       Lname.Add(".");
       Lname.Add(".");
       Lname.Add(".");
       for (int i = 2; i <= 5; i++)
       {
           L.Add("0");
       }
   }
   protected void lnkdrawing_Click(object sender, EventArgs e)
   {
       string year = dropYear.SelectedItem.Text;
       settime();
       Drawingcolumnchart(year);
   }
   private void settime()
   {
       string year = dropYear.SelectedItem.Text;
       lbl01.Text = year + "01";
       lbl02.Text = year + "02";
       lbl03.Text = year + "03";
       lbl04.Text = year + "04";
       lbl05.Text = year + "05";
       lbl06.Text = year + "06";
       lbl07.Text = year + "07";
       lbl08.Text = year + "08";
       lbl09.Text = year + "09";
       lbl10.Text = year + "10";
       lbl11.Text = year + "11";
       lbl12.Text = year + "12";
   }
    }
}