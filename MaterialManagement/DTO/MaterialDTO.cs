using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MaterialManagement.DTO
{
    public class MaterialDTO
    {

        public int Id { get; set; }
        public string QCode { get; set; }
        public string Zone { get; set; }
        public string Location { get; set; }
        public string Item { get; set; }
        public string Spec { get; set; }
        public string Unit { get; set; }
        public string Qty { get; set; }
        public float Price { get; set; }
        public string Remark { get; set; }
        public string PurDate { get; set; }
    }
}
