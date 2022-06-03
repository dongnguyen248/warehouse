using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace MaterialManagement
{
    public class mgrDataSQL
    {
        public static string connStr = ConfigurationManager.ConnectionStrings["cnnString"].ConnectionString;
        public static DataSet ReturnDataSet(string sql, Dictionary<string, object> param = null, string orderBy = "")
        {
            using (SqlConnection connect = new SqlConnection(connStr))
            {
                DataSet dataset = new DataSet();
                try
                {
                    connect.Open();
                    if (orderBy != "")
                        sql += " ORDER BY " + orderBy;
                    using (SqlDataAdapter adapter = new SqlDataAdapter(sql, connect))
                    {
                        if (param != null)
                        {
                            foreach (var item in param)
                            {
                                adapter.SelectCommand.Parameters.AddWithValue(item.Key.ToString(), item.Value);
                            }
                        }

                        adapter.Fill(dataset);
                    }
                    return dataset;
                }
                catch (SqlException ex)
                {
                    throw ex;
                }
                finally
                {
                    connect.Dispose();
                }
            }
        }
        public static DataTable ReturnDataTable(string sql, Dictionary<string, object> param = null)
        {
            using (SqlConnection connect = new SqlConnection(connStr))
            {
                DataTable dtb = new DataTable();
                try
                {
                    connect.Open();
                    using (SqlDataAdapter adapter = new SqlDataAdapter(sql, connect))
                    {
                        if (param != null)
                        {
                            foreach (var item in param)
                            {
                                adapter.SelectCommand.Parameters.AddWithValue(item.Key.ToString(), item.Value);
                            }
                        }
                        adapter.Fill(dtb);
                    }
                    return dtb;
                }
                catch (SqlException ex)
                {
                    throw ex;
                }
                finally
                {
                    connect.Dispose();
                }
            }
        }
        public static int ExecuteNonQuery(string sql, Dictionary<string, object> param = null)
        {
            using (SqlConnection connect = new SqlConnection(connStr))
            {
                try
                {
                    connect.Open();
                    using (SqlCommand command = new SqlCommand(sql, connect))
                    {

                        if (param != null)
                        {
                            foreach (var item in param)
                            {
                                command.Parameters.AddWithValue(item.Key.ToString(), item.Value);
                            }
                        }

                        int count = command.ExecuteNonQuery();

                        return count;
                    }
                }
                catch (SqlException ex)
                {
                    throw ex;
                }
                finally
                {
                    connect.Dispose();
                }
            }
        }
        public static DataTable ExecuteReader(string sql, Dictionary<string, object> param = null)
        {
            using (SqlConnection connect = new SqlConnection(connStr))
            {
                DataTable dtb = new DataTable();
                try
                {
                    connect.Open();
                    using (SqlCommand command = new SqlCommand(sql, connect))
                    {
                        if (param != null)
                        {
                            foreach (var item in param)
                            {
                                command.Parameters.AddWithValue(item.Key.ToString(), item.Value);
                            }
                        }

                        SqlDataReader reader = command.ExecuteReader();
                        dtb.Load(reader);
                    }
                    return dtb;
                }
                catch (SqlException ex)
                {
                    throw ex;
                }
                finally
                {
                    connect.Dispose();
                }
            }
        }
        public static object ExecuteScalar(string sql, Dictionary<string, object> param = null)
        {
            using (SqlConnection connect = new SqlConnection(connStr))
            {
                try
                {
                    using (SqlCommand command = new SqlCommand(sql, connect))
                    {
                        if (param != null)
                        {
                            foreach (var item in param)
                            {
                                command.Parameters.AddWithValue(item.Key.ToString(), item.Value);
                            }
                        }
                        connect.Open();
                        object result = command.ExecuteScalar();
                        return result;
                    }
                }
                catch (SqlException ex)
                {
                    throw ex;
                }
                finally
                {
                    connect.Dispose();
                }
            }
        }
       
    }
    public class ExportInfo
    {
        public string Seq;
        public string QCode;
        public string Pur_Date;
        public string Out_date;
        public string inventory;
        public string Quantity;
        public string Line;
        public string CodeCenter;
        public string CostAccount;
        public string Requestor;
        public string Remark;
        public string Note;
        public string locator;
    }
    public class ImportInfo
    {
        public string Seq;
        public string QCode;
        public string Pur_Date;
        public string Quantity;
        public string Price;
        public string Supplier;
        public string Buyer;
        public string Receiver;
        public string Po;
        public string Allocated;
        public string Remark;
        public string locator;
    }
}