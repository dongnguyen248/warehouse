using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;

namespace MaterialManagement
{
    public class Users
    {
        public string USERNAME { get; set; }
        public string PASSWORD { get; set; }
        public int ROLE { get; set; } // 1 is admin

        public Users() { }

        public string Encode(string value)
        {
            var hash = System.Security.Cryptography.SHA1.Create();
            var encoder = new System.Text.ASCIIEncoding();
            var combined = encoder.GetBytes(value ?? "");
            return BitConverter.ToString(hash.ComputeHash(combined)).ToLower().Replace("-", "");
        }

        public int Insert(string USERNAME, string PASSWORD, int role)
        {
            // 123456
            string sql = "INSERT INTO TB_USER(USERNAME,PASSWORD, ROLE) VALUES(@USERNAME,@PASSWORD,@role)";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@USERNAME", USERNAME);
            param.Add("@PASSWORD", Encode(PASSWORD));
            param.Add("@role", role);
            return mgrDataSQL.ExecuteNonQuery(sql, param);
        }

        public DataTable GetUsers()
        {
            string sql = "SELECT username FROM TB_USER";
            return mgrDataSQL.ExecuteReader(sql);
        }
        public Users GetUserById(string id)
        {
            string sql = "SELECT * FROM TB_USER WHERE USERNAME=@USERNAME";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@USERNAME", USERNAME);
            DataTable dtb = mgrDataSQL.ExecuteReader(sql, param);

            Users sale = new Users();
            if (dtb.Rows.Count > 0)
            {
                sale.USERNAME = dtb.Rows[0]["USERNAME"].ToString().Trim();
                sale.ROLE =Convert.ToInt32( dtb.Rows[0]["ROLE"].ToString());
            }
                
            return sale;
        }


        public bool CheckExist(string USERNAME)
        {
            string sql = "SELECT USERNAME FROM TB_USER WHERE USERNAME=@USERNAME";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@USERNAME", USERNAME);
            DataTable dtb = mgrDataSQL.ExecuteReader(sql, param);
            if (dtb.Rows.Count > 0)
                return true;
            return false;
        }

        public int Login(string USERNAME, string PASSWORD)
        {
            string sql = "SELECT * FROM TB_USER WHERE USERNAME=@USERNAME AND PASSWORD=@PASSWORD ";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@USERNAME", USERNAME);
            param.Add("@PASSWORD", PASSWORD);
            DataTable dtb = mgrDataSQL.ExecuteReader(sql, param);
            int num = dtb.Rows.Count;
            if (num > 0)
            {
                HttpContext.Current.Session["USERNAME"] = dtb.Rows[0]["USERNAME"].ToString().Trim();
                HttpContext.Current.Session["ROLE"] = Convert.ToInt32(dtb.Rows[0]["ROLE"].ToString());
            }
            return num;
        }


        public int ChangePassword(string USERNAME, string pass, string newpass)
        {
            string sql = "UPDATE TB_USER SET PASSWORD=@NEWPASS WHERE USERNAME=@USERNAME AND PASSWORD=@PASSWORD";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@USERNAME", USERNAME);
            param.Add("@PASSWORD",this.Encode( pass));
            param.Add("@NEWPASS", this.Encode(newpass));

            return mgrDataSQL.ExecuteNonQuery(sql, param);
        }

        public int ResetPassword(string USERNAME, string pass = "123456")
        {
            string newpass = this.Encode(pass);
            string sql = "UPDATE TB_USER SET PASSWORD=@NEWPASS WHERE USERNAME=@USERNAME";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@USERNAME", USERNAME);
            param.Add("@NEWPASS", newpass);

            return mgrDataSQL.ExecuteNonQuery(sql, param);
        }
       
       
    }
}