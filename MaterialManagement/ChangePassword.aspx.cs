using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MaterialManagement
{
    public partial class ChangePassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["USERNAME"] == null)
                    Response.Redirect("~/Login.aspx");
                if (!string.IsNullOrEmpty(Request.QueryString["username"]))
                {
                    txtUsername.Text = Request.QueryString["username"].ToString().Trim();
                }
            }
        }

        protected void btnChangePassword_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNewPassword.Text) || string.IsNullOrWhiteSpace(txtPassword.Text) || string.IsNullOrWhiteSpace(txtConfirm.Text))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "Info", "alert('Please fill out all password field.');", true);
                return;
            }
            if (string.Compare(txtNewPassword.Text, txtConfirm.Text) != 0)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "Info", "alert('Password confirm does not match.');", true);
                return;
            }
            string username = Request.QueryString["username"].ToString().Trim();
            Users u = new Users();
            int result = u.ChangePassword(username, txtPassword.Text.Trim(), txtNewPassword.Text.Trim());
            if (result > 0 )
                ClientScript.RegisterStartupScript(this.GetType(), "Info", "alert('Change password success.');", true);
            else
                ClientScript.RegisterStartupScript(this.GetType(), "Info", "alert('Change password fail.');", true);
        }
    }
}