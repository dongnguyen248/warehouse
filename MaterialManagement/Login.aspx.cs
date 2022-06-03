using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MaterialManagement
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string param = Request.QueryString["logout"];
                if (!string.IsNullOrWhiteSpace(param))
                {
                    Session.Abandon();
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtEmID.Text))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "Info", "alert('Username missing.');", true);
                return;
            }
            if (string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "Info", "alert('Password missing.');", true);
                return;
            }
            // try to login
            Users u = new Users();
            string password = u.Encode(txtPassword.Text.Trim());
            int login = u.Login(txtEmID.Text.Trim(), password);
            string lang = dropLang.SelectedItem.Text;
            if (login > 0 )
            {
                if (lang == "VietNamese")
                {
                    Response.Redirect("~/Default.aspx");
                }
                else
                {
                    Response.Redirect("~/en/Default_En.aspx");
                }
            }
            else
               
            {
                ClientScript.RegisterStartupScript(this.GetType(), "Info", "alert('Login Fail. Please check your username and password');", true);
            }
        }
    }
}