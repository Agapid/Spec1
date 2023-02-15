using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Windows.Forms;
using DevExpress.XtraGrid.Views.Grid;
using System.Data;
using System.Data.SqlClient;
using System.Collections;

using System.IO;
using ALTONIKA;



namespace Spec
{
    public partial class fSpecStatusComment : Form
    {
        private System.Data.SqlClient.SqlConnection cnn;
        public fSpecStatusComment()
        {
            InitializeComponent();
        }

        private void simpleButton2_Click(object sender, EventArgs e)
        {
            this.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.Close();
        }

        private void simpleButton1_Click(object sender, EventArgs e)
        {
            _BodyText = txtRemark.Text;

            if (_BodyText.Any(c => char.IsLetter(c)))
            {

                this.DialogResult = System.Windows.Forms.DialogResult.OK;
                this.Close();

            }
            else
            {
                MessageBox.Show("Введите примечание", "", MessageBoxButtons.OK, MessageBoxIcon.Information);
                txtRemark.Focus();
            }
           

            
            
        }
        private string _BodyText = string.Empty;
        public string BodyText
        {
            get
            {
                return _BodyText;
            }
        }

        private string _completeSetName = string.Empty;
        public string CompleteSetName
        {
            get
            {
                return _completeSetName;
            }
            set
            {
                _completeSetName = value;
            }
        }



        private string _infoText = string.Empty;
        public string InfoText
        {
            get
            {
                return _infoText;
            }
            set
            {
                lblInfo.Text = value;

            }
        }

        private Color _infoColor = Color.DarkGreen;
        public Color InfoColor
        {
            get
            {
                return _infoColor;
            }
            set
            {
                lblInfo.ForeColor = value;

            }
        }
       


        private void fSpecStatusComment_Load(object sender, EventArgs e)
        {

            txtRemark.Text = "\r\n\r\n\r\n" + DateTime.Now.ToString() ;
            txtRemark.DeselectAll();

            EmailsAddressFill();

        }

        
      
        private void EmailsAddressFill()
        {
            SqlDataReader dread = null;
            try
            {




                Cursor.Current = Cursors.WaitCursor;

                SqlCommand cmd = new SqlCommand();
                cmd.Connection = cnn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "stpSpecifCommonLookUp";

                SqlParameter prm = new SqlParameter();
                prm.SqlDbType = SqlDbType.Int;
                prm.ParameterName = "@LookUpID";
                prm.Value = 1;
                cmd.Parameters.Add(prm);
                dread = cmd.ExecuteReader();

                if (dread.HasRows)
                {
                    while (dread.Read())
                    {

                        lstEmails.Items.Add(dread["Email"].ToString());

                    }
                }
                dread.Close();
                Cursor.Current = Cursors.Default;






            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }

            finally
            { dread.Close();}
        }


        public SqlConnection SqlConn
        {
            set
            {

                cnn = value;
            }
            get
            {
                return cnn;
            }
        }



    }
}
