using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MaterialManagement.en
{
    public partial class EditUser_en : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                if (Session["ROLE"] == null)
                    Response.Redirect("~/Login.aspx");
                int role = Convert.ToInt32(Session["ROLE"].ToString());
                if (role != 1)
                    Response.Redirect("~/Login.aspx");
                LoadUser();
            }
        }
        protected void LoadUser()
        {
            Users u = new Users();
            ddlUsername.DataSource = u.GetUsers();

            ddlUsername.DataTextField = "USERNAME";
            ddlUsername.DataValueField = "USERNAME";
            ddlUsername.DataBind();
        }

        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            Users u = new Users();
            if (!string.IsNullOrWhiteSpace(ddlUsername.SelectedValue))
            {
                int result = u.ResetPassword(ddlUsername.SelectedValue.Trim());
                if (result > 0)
                    ClientScript.RegisterStartupScript(this.GetType(), "Info", "alert('Reset password success.');", true);
                else
                    ClientScript.RegisterStartupScript(this.GetType(), "Info", "alert('Reset password fail.');", true);
            }
            LoadUser();
        }
    }
}