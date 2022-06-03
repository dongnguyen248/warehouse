using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace MaterialManagement
{
    public class barcode
    {
        public void createbarcode()
        {
            Bitmap temp = new Bitmap(1, 1);
            temp.SetPixel(0, 0, this.BackColor);
            pictureBox1.Image = (Image)temp;


            int W = Convert.ToInt32(200);
            int H = Convert.ToInt32(50);

            BarcodeLib.TYPE type = BarcodeLib.TYPE.UNSPECIFIED;
            type = BarcodeLib.TYPE.CODE39;

            try
            {
                if (type != BarcodeLib.TYPE.UNSPECIFIED)
                {
                    //To generate label
                    b.IncludeLabel = true;

                    //===== Encoding performed here =====
                    pictureBox1.Image = b.Encode(type, dt.Trim(), this.b.ForeColor, this.b.BackColor, W, H);
                    //===================================
                }

                pictureBox1.Width = pictureBox1.Image.Width;
                pictureBox1.Height = pictureBox1.Image.Height;

                pictureBox1.Image.Save(imgsavepath + barcodeimage);

                Application.Exit();
            }
            catch (Exception ex)
            {
                Application.Exit();
            }
        } 
    }
}