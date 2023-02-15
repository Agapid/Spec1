using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using CrystalDecisions.Shared;
using CrystalDecisions.Windows.Forms;
using CrystalDecisions.CrystalReports.Engine;
using System.Collections;
using System.Text.RegularExpressions;
using System.IO;

namespace Spec
{
    public partial class AXReportView : Form
    {
        public AXReportView()
        {
            InitializeComponent();
        }

        public AXReportView(AXReportView existingAXReportView)
        {
            try
            {
                InitializeComponent();
                _reportName = existingAXReportView.ReportName;
                ParameterValues = existingAXReportView.ParameterValues;
                this.SqlConn = existingAXReportView.SqlConn;
                this.WindowState = FormWindowState.Normal;
                
            }
            catch (Exception E)
            {
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (" + this.Name + ")", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }


        }



        #region Declare section            /**************Declare begin*****************/
        private bool useOutSide = false;
        private System.Data.SqlClient.SqlConnection cnn;



        private string userName = "";
        private string userPassword = "";

        private string _reportName = string.Empty;

        public Hashtable ParameterValues = new Hashtable();



        #endregion
        private void AXReportView_Load(object sender, EventArgs e)
        {
            try
            {
               


                DataSet ds = new DataSet();
                if (ds.Tables.Contains("ul")) ds.Tables["ul"].Clear();
                SqlDataAdapter ad = new SqlDataAdapter("EXEC stpGetLP", cnn);
                ad.Fill(ds, "ul");

                foreach (DataRowView drv in ds.Tables["ul"].DefaultView)
                {
                    userName = drv.Row["Login"].ToString();
                    userPassword = drv.Row["Password"].ToString();
                }



   
                this.reportDoc.FileName = GetRPTFileFromDB();
                this.reportDoc.ReportOptions.EnableSaveDataWithReport = false;
                this.reportDoc.ReportOptions.EnableSaveSummariesWithReport = false;

                
                ParameterFields pds = reportDoc.ParameterFields;
   
                foreach (ParameterField pfd in pds)
                {
                    object parameterValue;
                    parameterValue = ParameterValues[pfd.Name.ToString()];
                    pfd.CurrentValues.AddValue(parameterValue); 
                }

                this.reportDoc.DataSourceConnections[0].SetConnection(cnn.DataSource, cnn.Database, userName, userPassword);
                if (userName.Trim() == string.Empty)
                {
                    this.reportDoc.DataSourceConnections[0].IntegratedSecurity = true;
                }
                else
                {
                    this.reportDoc.DataSourceConnections[0].IntegratedSecurity = false;
                }
                
                this.reportDoc.DataSourceConnections[0].SetLogon(userName, userPassword);
                this.axCRV.ReportSource = this.reportDoc;
                if (_ExportFileName != string.Empty)
                {
                    ExportOptions CrExportOptions;
                    DiskFileDestinationOptions CrDiskFileDestinationOptions = new DiskFileDestinationOptions();
                    PdfRtfWordFormatOptions CrFormatTypeOptions = new PdfRtfWordFormatOptions();
                    CrDiskFileDestinationOptions.DiskFileName = _ExportFileName;
                    CrExportOptions = reportDoc.ExportOptions;
                    {
                        CrExportOptions.ExportDestinationType = ExportDestinationType.DiskFile;
                        CrExportOptions.ExportFormatType = ExportFormatType.PortableDocFormat;
                        CrExportOptions.DestinationOptions = CrDiskFileDestinationOptions;
                        CrExportOptions.FormatOptions = CrFormatTypeOptions;
                    }
                    reportDoc.Export();
                    this.Dispose(true);
                    
                    return;

                }
                else
                {
                    this.axCRV.Show();
                }
                
                this.axCRV.ToolPanelView = CrystalDecisions.Windows.Forms.ToolPanelViewType.ParameterPanel;
                this.axCRV.ToolPanelView = CrystalDecisions.Windows.Forms.ToolPanelViewType.GroupTree;

            }
            catch (Exception E)
            {
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (" + this.Name + ")", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }


        #region Proc section            /**************Процедуры begin*****************/
        private string GetRPTFileFromDB()
        {

            DataSet Ds = new DataSet();
            SqlDataAdapter Ad = new SqlDataAdapter("dbo.stpItemReportGetReportData", cnn);
            Ad.SelectCommand.CommandType = CommandType.StoredProcedure;
            Ad.SelectCommand.Parameters.Add(new SqlParameter("@ReportPath", SqlDbType.VarChar, 50));
            Ad.SelectCommand.Parameters["@ReportPath"].Value = _reportName;

            string rptFile = string.Empty;
            try
            {

                Ad.Fill(Ds, "tblReportData");
                DataRow dr = Ds.Tables["tblReportData"].Rows[0];

                Byte[] mb = (Byte[])dr["ReportData"];
                long k;
                k = mb.Length;
                if (!Directory.Exists(Application.CommonAppDataPath + @"\Temp")) Directory.CreateDirectory(Application.CommonAppDataPath + @"\Temp");
                rptFile = Application.CommonAppDataPath + @"\Temp\" + _reportName;

                if (File.Exists(rptFile))
                {

                    File.Delete(rptFile);
                }

                FileStream fs = new FileStream(rptFile, FileMode.OpenOrCreate, FileAccess.Write);
                fs.Write(mb, 0, (int)k);
                fs.Close();
                fs = null;
            }
            catch (Exception E)
            {
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (" + this.Name + ")", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            return rptFile;
        }
        public string ExportToPDF(string f)
        {
            return f;  
        }
        public void ShowToScreen()
        {

        }
        #endregion                      /**************Процедуры end*******************/
        #region Property section        /**************Свойства begin******************/
        public SqlConnection SqlConn
        {
            set
            {
                useOutSide = true;
                cnn = value;
            }
            get
            {
                return cnn;
            }
        }
        public string ReportName
        {
            set
            {
                _reportName = value;
            }
            get
            {
                return _reportName;
            }
        }

        string _ExportFileName = string.Empty;
        public string ExportFileName
        {
            set
            {
                _ExportFileName = value;
            }
            get
            {
                return _ExportFileName;
            }
        }

        //bool _OnlyExport = false;
        //public Boolean OnlyExport
        //{
        //    set
        //    {
        //        _OnlyExport = value;
        //    }
        //    get
        //    {
        //        return _OnlyExport;
        //    }
        //}
        #endregion                      /**************Свойства end********************/

        private void axCRV_Load(object sender, EventArgs e)
        {
            
        }

        private void axCRV_ReportRefresh(object source, ViewerEventArgs e)
        {
            try
            {

                AXReportView rv = new AXReportView(this);
                rv.Show();
                rv.Focus();
                this.Visible = false;

            }
            catch (Exception E)
            {
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (" + this.Name + ")", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

        }

        private void simpleButton1_Click(object sender, EventArgs e)
        {
         
        }
    }
}
