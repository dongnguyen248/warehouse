using System.Collections.Generic;
using System.Data;

namespace MaterialManagement
{
    public class Material
    {
        public int ID { get; set; }
        public string QCODE { get; set; }
        public string ZONE { get; set; }
        public string LOCATION { get; set; }
        public string ITEM { get; set; }
        public string SPEC { get; set; }
        public string UNIT { get; set; }
        public float QTY { get; set; }
        public int PRICE { get; set; }
        public string REMARK { get; set; }
        public Material() { }
        public int Insert(string QCODE, string ZONE, string LOCATION, string ITEM, string SPEC, string UNIT,
            string REMARK, string Pur_Date)
        {
            string sql = "INSERT INTO MATERIAL(QCODE,ZONE,LOCATION,ITEM,SPEC,UNIT,REMARK,Pur_Date) VALUES(@QCODE,@ZONE,@LOCATION,@ITEM,@SPEC,@UNIT,@REMARK,@Pur_Date)";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@QCODE", QCODE);
            param.Add("@ZONE", ZONE);
            param.Add("@LOCATION", LOCATION);
            param.Add("@ITEM", ITEM);
            param.Add("@SPEC", SPEC);
            param.Add("@UNIT", UNIT);
            param.Add("@REMARK", REMARK);
            param.Add("@Pur_Date", Pur_Date);
            return mgrDataSQL.ExecuteNonQuery(sql, param);
        }
        public int GetRowCount(string query = null)
        {
            //string sql = " SELECT COUNT(id) FROM(SELECT ROW_NUMBER() OVER (order by id) AS ROWNUM, c.id,c.QCODE,c.Pur_Date,c.ZONE	,c.LOCATION,	c.ITEM,	c.SPEC,	c.UNIT,c.import - c.export 'Stock',c.Price,c.REMARK from ( ";
            //sql += " SELECT a.*,isnull(round(sum(o.Quantity),2),0) 'export' FROM ( ";
            //sql += " select m.ID,m.QCODE,m.ZONE,m.LOCATION,m.ITEM,m.SPEC,m.UNIT,i.Pur_Date,m.REMARK,Round(i.Price,2) as Price, Round(sum(i.Quantity),2) 'import' ";
            //sql += " from dbo.MATERIAL m, dbo.Import_History i ";
            //sql += " where m.qcode = i.qcode " + query + " group by m.id,m.QCODE,m.ZONE,m.LOCATION,m.ITEM,m.spec,m.UNIT,i.Pur_Date,m.REMARK,i.Price) a left JOIN [dbo].[Out_history] o on ";
            //sql += " a.QCODE=o.QCode and a.Pur_Date = o.Pur_Date and round(a.Price,2) =round(o.Imp_Price,2) group by a.id,a.QCODE,a.ZONE,a.LOCATION,a.ITEM,a.spec,a.UNIT,a.Pur_Date,a.REMARK,a.Price,a.import) c where c.import - c.export >0 ) as u ";
            string sql = string.Format(@"
SELECT COUNT(*) FROM( SELECT  a.import,isnull(round(sum(o.Quantity),2),0) 'export' 
FROM (  
   select m.QCODE,i.Pur_Date,Round(i.Price,2) as Price, Round(sum(i.Quantity),2) 'import'  
   from dbo.MATERIAL m, dbo.Import_History i  where m.qcode = i.qcode {0}
    group by m.id,m.QCODE,i.Pur_Date,i.Price
	) a left JOIN [dbo].[Out_history] o on  a.QCODE=o.QCode and a.Pur_Date = o.Pur_Date and round(a.Price,2) =round(o.Imp_Price,2)
group by a.QCODE, a.Pur_Date,a.Price,a.import) c where c.import - c.export >0
", query);
            var result = mgrDataSQL.ExecuteScalar(sql);
            if (result == null)
            {
                return 0;
            }
            return (int)result;
        }
        public DataTable GetPaging(int start = 1, int end = 10)
        {
            string sql = "SELECT * FROM(SELECT ROW_NUMBER() OVER (order by ZONE,qcode) AS ROWNUM, c.id,c.QCODE,c.Pur_Date,c.ZONE	,c.LOCATION,	c.ITEM,	c.SPEC,	c.UNIT,c.import - c.export 'Stock',c.Price,c.REMARK,c.locator from ( ";
            sql += " SELECT a.*,isnull(round(sum(o.Quantity),2),0)  'export' FROM ( ";
            sql += " select m.ID,m.QCODE,m.ZONE,m.LOCATION,m.ITEM,m.SPEC,m.UNIT,i.Pur_Date,m.REMARK,i.locator,Round(i.Price,2) as Price, Round(sum(i.Quantity),2) 'import' ";
            sql += "from dbo.MATERIAL m, dbo.Import_History i ";
            sql += "where m.qcode = i.qcode group by m.id,m.QCODE,m.ZONE,m.LOCATION,m.ITEM,m.spec,m.UNIT,i.Pur_Date,m.REMARK,i.locator,i.Price) a left JOIN [dbo].[Out_history] o on a.QCODE=o.QCode and a.Pur_Date = o.Pur_Date and round(a.Price,2) =round(o.Imp_Price,2) ";
            sql += "group by a.id,a.QCODE,a.ZONE,a.LOCATION,a.ITEM,a.spec,a.UNIT,a.Pur_Date,a.REMARK,a.Price,a.locator,a.import) c ";
            sql += ") as u  WHERE Stock>0 and RowNum >= @start   AND RowNum < @end ORDER BY QCODE";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@start", start);
            param.Add("@end", end);
            return mgrDataSQL.ExecuteReader(sql, param);
        }
        public DataTable Search(string query, int start = 1, int end = 10)
        {
         //   string sql = string.Format(@" SELECT * FROM(SELECT c.id,c.QCODE,c.Pur_Date,c.ZONE,c.LOCATION,c.ITEM,c.SPEC,c.UNIT,c.import - c.export Stock,c.Price,c.REMARK,c.Remark_new,c.locator, c.Seq
         //from (  SELECT a.*,isnull(round(sum(o.Quantity),2),0) 'export' FROM (  select i.Seq, m.ID,m.QCODE,m.ZONE,m.LOCATION,m.ITEM,m.SPEC,m.UNIT,i.Pur_Date,m.REMARK,i.Remark Remark_new,i.locator,Round(i.Price,2) as Price, 
         //Round(sum(i.Quantity),2) 'import' from dbo.MATERIAL m, dbo.Import_History i where m.qcode = i.qcode {0} group by m.id,m.QCODE,m.ZONE,m.LOCATION,
         //m.ITEM,m.spec,m.UNIT,i.Pur_Date,m.REMARK,i.Remark,i.locator,i.Price, i.Seq) a left JOIN [dbo].[Out_history] o on a.QCODE=o.QCode and a.Pur_Date = o.Pur_Date and round(a.Price,2) =round(o.Imp_Price,2)    
         // group by a.id,a.QCODE,a.ZONE,a.LOCATION,a.ITEM,a.spec,a.UNIT,a.Pur_Date,a.REMARK,a.Remark_new,a.Price,a.locator,a.import, a.Seq) c   WHERE   c.import - c.export>0 ORDER BY Id OFFSET @offset ROWS FETCH NEXT @rows ROWS ONLY ) as u ORDER BY QCODE", query);

            int offset = start - 1;
            int rows = end - start;

            string sql = string.Format(@" SELECT * FROM(SELECT c.id,c.QCODE,c.Pur_Date,c.ZONE,c.LOCATION,c.ITEM,c.SPEC,c.UNIT,c.import - c.export Stock,c.Price,c.REMARK,c.Remark_new,c.locator
            from (  SELECT a.*,isnull(round(sum(o.Quantity),2),0) 'export' FROM (  select m.ID,m.QCODE,m.ZONE,m.LOCATION,m.ITEM,m.SPEC,m.UNIT,i.Pur_Date,m.REMARK,i.Remark Remark_new,i.locator,Round(i.Price,2) as Price, 
            Round(sum(i.Quantity),2) 'import' from dbo.MATERIAL m, dbo.Import_History i where m.qcode = i.qcode {0} group by m.id,m.QCODE,m.ZONE,m.LOCATION,
            m.ITEM,m.spec,m.UNIT,i.Pur_Date,m.REMARK,i.Remark,i.locator,i.Price) a left JOIN [dbo].[Out_history] o on a.QCODE=o.QCode and a.Pur_Date = o.Pur_Date and round(a.Price,2) =round(o.Imp_Price,2)    
             group by a.id,a.QCODE,a.ZONE,a.LOCATION,a.ITEM,a.spec,a.UNIT,a.Pur_Date,a.REMARK,a.Remark_new,a.Price,a.locator,a.import) c   WHERE   c.import - c.export>0 ORDER BY Id OFFSET @offset ROWS FETCH NEXT @rows ROWS ONLY ) as u ORDER BY QCODE", query);
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@offset", offset);
            param.Add("@rows", rows);
            return mgrDataSQL.ExecuteReader(sql, param);
        }
        public DataTable Search2(string query)
        {
            //string sql = "SELECT c.id,c.QCODE,c.Pur_Date,c.ZONE	,c.LOCATION,c.ITEM,	c.SPEC,	c.UNIT,c.import - c.export 'Stock',c.Price,c.REMARK,c.Remark_new,c.locator from ( ";
            //sql += " SELECT a.*,isnull(round(sum(o.Quantity),2),0) 'export' FROM ( ";
            //sql += " select m.ID,m.QCODE,m.ZONE,m.LOCATION,m.ITEM,m.SPEC,m.UNIT,i.Pur_Date,m.REMARK,i.Remark Remark_new,i.locator,Round(i.Price,2) as Price,Round(sum(i.Quantity),2) 'import'";
            //sql += " from dbo.MATERIAL m, dbo.Import_History i ";
            //sql += "where m.qcode = i.qcode " + query + " group by m.id,m.QCODE,m.ZONE,m.LOCATION,m.ITEM,m.spec,m.UNIT,i.Pur_Date,m.REMARK,i.Remark,i.locator,i.Price, i.Seq) a left JOIN [dbo].[Out_history] o on a.QCODE=o.QCode and a.Pur_Date = o.Pur_Date and round(a.Price,2) =round(o.Imp_Price,2)  group by a.id,a.QCODE,a.ZONE,a.LOCATION,a.ITEM,a.spec,a.UNIT,a.Pur_Date,a.REMARK,a.Remark_new,a.locator,a.Price,a.import) c where (c.import - c.export)>0 ORDER BY QCODE ";


            string sql = string.Format(@" SELECT * FROM(SELECT c.id,c.QCODE,c.Pur_Date,c.ZONE,c.LOCATION,c.ITEM,c.SPEC,c.UNIT,c.import - c.export Stock,c.Price,c.REMARK,c.Remark_new,c.locator
            from (  SELECT a.*,isnull(round(sum(o.Quantity),2),0) 'export' FROM (  select m.ID,m.QCODE,m.ZONE,m.LOCATION,m.ITEM,m.SPEC,m.UNIT,i.Pur_Date,m.REMARK,i.Remark Remark_new,i.locator,Round(i.Price,2) as Price, 
            Round(sum(i.Quantity),2) 'import' from dbo.MATERIAL m, dbo.Import_History i where m.qcode = i.qcode {0} group by m.id,m.QCODE,m.ZONE,m.LOCATION,
            m.ITEM,m.spec,m.UNIT,i.Pur_Date,m.REMARK,i.Remark,i.locator,i.Price) a left JOIN [dbo].[Out_history] o on a.QCODE=o.QCode and a.Pur_Date = o.Pur_Date and round(a.Price,2) =round(o.Imp_Price,2)    
             group by a.id,a.QCODE,a.ZONE,a.LOCATION,a.ITEM,a.spec,a.UNIT,a.Pur_Date,a.REMARK,a.Remark_new,a.Price,a.locator,a.import) c   WHERE   c.import - c.export>0) as u ORDER BY QCODE", query);

            return mgrDataSQL.ExecuteReader(sql);
        }
        public DataTable Export(string query = null)
        {
            string sql = "SELECT * FROM MATERIAL ";
            if (!string.IsNullOrEmpty(query))
                sql = sql + query;
            //sql = sql + " order by Date desc";
            return mgrDataSQL.ExecuteReader(sql);
        }
        public int Update(int id, string QCODE, string ZONE, string LOCATION, string ITEM, string SPEC, string UNIT, string REMARK, string Pur_Date)
        {
            // string sql = "UPDATE MATERIAL SET QCODE=@QCODE,ZONE=@ZONE,LOCATION=@LOCATION,ITEM=@ITEM,SPEC=@SPEC,UNIT=@UNIT,REMARK=@REMARK,Pur_Date=@Pur_Date WHERE ID=@ID";
            string sql = "UPDATE MATERIAL SET QCODE=@QCODE,ZONE=@ZONE,LOCATION=@LOCATION,ITEM=@ITEM,SPEC=@SPEC,UNIT=@UNIT,Pur_Date=@Pur_Date WHERE ID=@ID";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@ID", id);
            param.Add("@QCODE", QCODE);
            param.Add("@ZONE", ZONE);
            param.Add("@LOCATION", LOCATION);
            param.Add("@ITEM", ITEM);
            param.Add("@SPEC", SPEC);
            param.Add("@UNIT", UNIT);
            param.Add("@REMARK", REMARK);
            param.Add("@Pur_Date", Pur_Date);
            return mgrDataSQL.ExecuteNonQuery(sql, param);
        }
        public int UpdateRemarkImportHistory(int Seq, string REMARK)
        {
            string sql = "UPDATE Import_History SET REMARK=@REMARK WHERE seq=@SEQ";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@SEQ", Seq);
            param.Add("@REMARK", REMARK);

            return mgrDataSQL.ExecuteNonQuery(sql, param);
        }
        public int Delete(int ID)
        {
            string sql = "DELETE FROM MATERIAL  WHERE ID=@ID";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@ID", ID);

            return mgrDataSQL.ExecuteNonQuery(sql, param);
        }
        public DataTable GetZone()
        {
            string sql = "SELECT DISTINCT(ZONE) FROM MATERIAL";
            return mgrDataSQL.ExecuteReader(sql);
        }
        public DataTable GetLocation()
        {
            string sql = "SELECT DISTINCT(LOCATION) FROM MATERIAL";
            return mgrDataSQL.ExecuteReader(sql);
        }
        public DataTable GetUnit()
        {
            string sql = "SELECT DISTINCT(UNIT) FROM MATERIAL";
            return mgrDataSQL.ExecuteReader(sql);
        }
        public DataTable GetSupplier()
        {
            string sql = "SELECT DISTINCT(Supplier) FROM [MATERIAL_MGM].[dbo].[Import_History]";
            return mgrDataSQL.ExecuteReader(sql);
        }
        public void writeblog(string Qcode, string info)
        {
            string sql = "Insert into tblog values ( @Qcode,  @info)";
            Dictionary<string, object> param = new Dictionary<string, object>();
            param.Add("@Qcode", Qcode);
            param.Add("@info", info);
            mgrDataSQL.ExecuteNonQuery(sql, param);
        }
    }
}