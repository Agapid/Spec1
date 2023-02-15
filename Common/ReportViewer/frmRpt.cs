using System;
using System.Collections.Generic;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.IO;
using Microsoft.Win32;

namespace Spec
{
  /// <summary>
  /// Форма отчетов.
  /// </summary>
  public partial class frmRpt : Form
  {
    private string UserPassword = "";
    private string UserName = "";
    private string ReportName = "";
    private string ReportFileName = "";
    private SqlCommand Cmd = new SqlCommand();
    private SqlDataAdapter Ad = new SqlDataAdapter();
    private CreateParameter CrPar = new CreateParameter();
    private DataSet Ds = new DataSet();
    private ArrayList ParamValues;
    private DataTable ReportOptions;
    private SqlConnection cnn;

    private PLM.Encryption Encript = new PLM.Encryption();

    /// <summary>
    /// Инициализация формы для отображения отчета.
    /// </summary>
    /// <param name="RptPath">Путь к отчету.</param>
    /// <param name="con">Активная коннекция.</param>
    /// <param name="UserPass">Пароль пользователя.</param>
    /// <param name="User">Имя пользователя.</param>
    /// <param name="ParValues">Массив значений входных параметров для отчета.</param>
    /// <param name="RptOptions">Таблица с параметрами запросной формы.</param>
    public frmRpt(SqlConnection con, string UserPass, string User, ArrayList ParValues, DataTable RptOptions)
    {
      cnn = con;
      UserPassword = UserPass;
      UserName = User;
      ParamValues = ParValues;
      ReportOptions = RptOptions;

      InitializeComponent();
    }

    /// <summary>
    /// Открытие формы.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void Form1_Load(object sender, EventArgs e)
    {
      //MessageBox.Show(this.crystalReportViewer1.Controls.Count.ToString());
      ReportFileName = DateTime.Now.Year.ToString() + DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Hour.ToString() + DateTime.Now.Minute.ToString() + DateTime.Now.Second.ToString() + DateTime.Now.Millisecond.ToString() + ".rpt";
      if (ReportOptions.Columns.Count > 3)
      {
        ReportFileName = ReportOptions.Rows[0]["ReportPath"].ToString();
        ReportName = ReportOptions.Rows[0]["ReportName"].ToString();
      }
      else
      {
        ReportFileName = ReportOptions.Rows[0]["ReportPath"].ToString();
        ReportName = ReportOptions.Rows[0]["ReportName"].ToString();
      }

      //для нового режима работы
      RegistryKey rk = Registry.CurrentUser;
      RegistryKey rkSubPass = rk.CreateSubKey("Software\\PLM\\App");

      if (rkSubPass.GetValue("PLMl") != null && rkSubPass.GetValue("PLMl").ToString().Length > 2 && rkSubPass.GetValue("PLMl").ToString().Substring(0, 2) == "[]")
          UserName = rkSubPass.GetValue("PLMl") == null ? "" : Encript.Decode(rkSubPass.GetValue("PLMl").ToString(), false);
      else
          UserName = rkSubPass.GetValue("PLMl") == null ? "" : Encript.Decode(rkSubPass.GetValue("PLMl").ToString(), true);

      if (rkSubPass.GetValue("PLMp") != null && rkSubPass.GetValue("PLMp").ToString().Length > 2 && rkSubPass.GetValue("PLMp").ToString().Substring(0, 2) == "[]")
          UserPassword = rkSubPass.GetValue("PLMp") == null ? "" : Encript.Decode(rkSubPass.GetValue("PLMp").ToString(), false);
      else
          UserPassword = rkSubPass.GetValue("PLMp") == null ? "" : Encript.Decode(rkSubPass.GetValue("PLMp").ToString(), true);


      Cursor = Cursors.AppStarting;
      this.Text = ReportName;

      try
      {
        try
        {
          this.reportDocument1.FileName = GetReportPath(ReportFileName);
        }
        catch (Exception a)
        {
          MessageBox.Show(a.Message);
          MessageBox.Show("Программа не может открыть отчет! Возможно у вас нет прав доступа к отчетам!", "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);
          return;
        }

        this.reportDocument1.ReportOptions.EnableSaveDataWithReport = false;
        this.reportDocument1.ReportOptions.EnableSaveSummariesWithReport = false;

        SetParamValues();
        //this.reportDocument1.SetDatabaseLogon("", "", cnn.DataSource, cnn.Database);
        this.reportDocument1.DataSourceConnections[0].SetConnection(cnn.DataSource, cnn.Database, UserName, UserPassword);
        if (UserName != "" && UserPassword != "")
        {
          this.reportDocument1.DataSourceConnections[0].IntegratedSecurity = false;
          this.reportDocument1.DataSourceConnections[0].SetLogon(UserName, UserPassword);
        }
        this.crystalReportViewer1.ReportSource = this.reportDocument1;
        this.crystalReportViewer1.Show();

        this.crystalReportViewer1.ToolPanelView = CrystalDecisions.Windows.Forms.ToolPanelViewType.ParameterPanel;
        //this.crystalReportViewer1.ToolPanelView = CrystalDecisions.Windows.Forms.ToolPanelViewType.None;
        this.crystalReportViewer1.ToolPanelView = CrystalDecisions.Windows.Forms.ToolPanelViewType.GroupTree;
        Cursor = Cursors.Default;
        CountLaunch();
      }
      catch (CrystalDecisions.CrystalReports.Engine.ParameterFieldException E)
      {
        Cursor = Cursors.Default;
        MessageBox.Show(E.Message, "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);
        //MessageBox.Show("Произошла ошибка при загрузке отчета! Обратитесь к разработчикам!", "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);
        //rpt = null;
        //app = null;

      }
    }
    /// <summary>
    /// обрабатываем закрытие формы.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    private void Form1_FormClosing(object sender, FormClosingEventArgs e)
    {
      if (File.Exists(Application.CommonAppDataPath + @"\Temp\" + ReportFileName))
      {
        File.Delete(Application.CommonAppDataPath + @"\Temp\" + ReportFileName);
      }
      this.reportDocument1.Close();
    }
    /// <summary>
    /// Читаем в базе и преобразуем в файл отчет.
    /// </summary>
    /// <param name="FileName">Имя файла.</param>
    /// <returns></returns>
    private string GetReportPath(string FileName)
    {
      Ad = new SqlDataAdapter("dbo.stpItemReportGetReportData", cnn);
      Ad.SelectCommand.CommandType = CommandType.StoredProcedure;
      Ad.SelectCommand.Parameters.Add(new SqlParameter("@ReportPath", SqlDbType.VarChar, 50));
      Ad.SelectCommand.Parameters["@ReportPath"].Value = FileName;

      try
      {
        Ad.Fill(Ds, "tblReportData");
        DataRow dr = Ds.Tables["tblReportData"].Rows[0];

        Byte[] mb = (Byte[])dr["ReportData"];
        long k;
        k = mb.Length;
        if (!Directory.Exists(Application.CommonAppDataPath + @"\Temp")) Directory.CreateDirectory(Application.CommonAppDataPath + @"\Temp");

        FileStream fs = new FileStream(Application.CommonAppDataPath + @"\Temp\" + FileName, FileMode.OpenOrCreate, FileAccess.Write);
        fs.Write(mb, 0, (int)k);
        fs.Close();
        fs = null;
      }
      catch (SqlException a)
      {
        MessageBox.Show(a.Message + " Обратитесь к разработчикам!", "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);
      }
      return Application.CommonAppDataPath + @"\Temp\" + FileName;
    }
    /// <summary>
    /// Присваиваем параметрам значения.
    /// </summary>
    private void SetParamValues()
    {
      if (ParamValues != null)
      {
        Array ParVal = ParamValues.ToArray();
        int i = 0;

        foreach (DataRow dr in ReportOptions.Rows)
        {
          if ((bool)dr["Accept"] == true)
          {
            //this.reportDocument1.ParameterFields[0].EnableNullValue
            switch (dr["ControlName"].ToString())
            {
              case "Calendar":
                if (ParVal.GetValue(i) == null || ParVal.GetValue(i).ToString() == "")
                {
                  this.reportDocument1.ParameterFields[dr["ParamName"].ToString()].CurrentValues.AddValue(null);
                }
                else
                {
                  this.reportDocument1.ParameterFields[dr["ParamName"].ToString()].CurrentValues.AddValue(Convert.ToDateTime(ParVal.GetValue(i)));
                }
                break;
              case "DropDownList":
                switch (this.reportDocument1.ParameterFields[dr["ParamName"].ToString()].ParameterValueType)
                {
                  case CrystalDecisions.Shared.ParameterValueKind.StringParameter:
                    if (ParVal.GetValue(i) == null || ParVal.GetValue(i).ToString() == "")
                    {
                      this.reportDocument1.ParameterFields[dr["ParamName"].ToString()].CurrentValues.AddValue(null);
                    }
                    else
                    {
                      this.reportDocument1.ParameterFields[dr["ParamName"].ToString()].CurrentValues.AddValue(ParVal.GetValue(i).ToString());
                    }
                    break;
                  case CrystalDecisions.Shared.ParameterValueKind.NumberParameter:
                    if (ParVal.GetValue(i) == null || ParVal.GetValue(i).ToString() == "")
                    {
                      this.reportDocument1.ParameterFields[dr["ParamName"].ToString()].CurrentValues.AddValue(null);
                    }
                    else
                    {
                      this.reportDocument1.ParameterFields[dr["ParamName"].ToString()].CurrentValues.AddValue(Convert.ToInt32(ParVal.GetValue(i).ToString()));
                    }
                    break;
                  case CrystalDecisions.Shared.ParameterValueKind.CurrencyParameter:
                    if (ParVal.GetValue(i) == null || ParVal.GetValue(i).ToString() == "")
                    {
                      this.reportDocument1.ParameterFields[dr["ParamName"].ToString()].CurrentValues.AddValue(null);
                    }
                    else
                    {
                      this.reportDocument1.ParameterFields[dr["ParamName"].ToString()].CurrentValues.AddValue(Convert.ToInt32(ParVal.GetValue(i).ToString()));
                    }
                    break;
                }
                break;
              case "TextBox":
                if (ParVal.GetValue(i) == null || ParVal.GetValue(i).ToString() == "")
                {
                  this.reportDocument1.ParameterFields[dr["ParamName"].ToString()].CurrentValues.AddValue(null);
                }
                else
                {
                  this.reportDocument1.ParameterFields[dr["ParamName"].ToString()].CurrentValues.AddValue(ParVal.GetValue(i).ToString());
                }
                break;
              case "CheckBox":
                this.reportDocument1.ParameterFields[dr["ParamName"].ToString()].CurrentValues.AddValue(Convert.ToBoolean(ParVal.GetValue(i)));
                break;
            }
          }
          i = i + 1;
        }
      }
    }
    /// <summary>
    /// Процедура для подсчета количества запусков.
    /// </summary>
    private void CountLaunch()
    {
      Cmd = new SqlCommand("dbo.stpItemReportLaunchCount", cnn);
      Cmd.CommandType = CommandType.StoredProcedure;
      Cmd.Parameters.Add(CrPar.CreateParam("@RETURN_VALUE", SqlDbType.Int, 4, ParameterDirection.ReturnValue, "0"));
      //Cmd.Parameters.Add(CrPar.CreateParam("@ReportID", SqlDbType.Int, 4, ParameterDirection.Input, ReportID.ToString()));
      Cmd.Parameters.Add(CrPar.CreateParam("@ReportPath", SqlDbType.VarChar, 50, ParameterDirection.Input, ReportOptions.Rows[0]["ReportPath"].ToString()));
      try
      {
        Cmd.ExecuteNonQuery();
        switch ((int)Cmd.Parameters["@RETURN_VALUE"].Value)
        {
          case 1:
            MessageBox.Show("Произошла ошибка при подсчете количества запусков отчета! Обратитесь к разработчикам!", "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);
            return;
          case 0:
            break;
        }
      }
      catch (SqlException e)
      {
        MessageBox.Show(e.Message + " Обратитесь к разработчикам!", "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);
        return;
      }
    }
  }
}
