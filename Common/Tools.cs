using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data;
using System.Data.SqlClient;

namespace Spec.Common
{
    class Tools
    {
        static public string IsNull(object checkingValue, string substValue)
        {
            try
            {
                if (checkingValue == DBNull.Value)
                {
                    return substValue;

                }
                else
                {
                    return checkingValue.ToString();
                }

            }
            catch (Exception E)
            {
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (Tools)", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return "Error";
            }
        }


        static public int IsNull(object checkingValue, int substValue)
        {
            try
            {
                if (checkingValue == DBNull.Value || checkingValue == string.Empty)
                {
                    return substValue;

                }
                else
                {
                    return Convert.ToInt32(checkingValue);
                }

            }
            catch (Exception E)
            {
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (Tools)", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return 0;
            }
        }


        static public int openYY = 0;
        static public int openMM = 0;
        static public string openMMName = String.Empty;
        static public int openPeriod = 0;
        static public int RestrictOZP = 1;

        static public void GetOpenPeriod(SqlConnection cnn)
        {
            try
            {
                string tblScalar = "Scalar";
                DataSet dsMain = new DataSet();
                if (dsMain.Tables.Contains(tblScalar)) dsMain.Tables.Remove(tblScalar);
                SqlDataAdapter adOpt = new SqlDataAdapter();
                SqlCommand cmdOpt = new SqlCommand();
                cmdOpt.Connection = cnn;
                cmdOpt.CommandText = "SELECT OpenPeriodID, OpenPeriod,  OpenPeriodYY, OpenPeriodMM, OpenPeriodMMName, RestrictOZP  FROM v_SLROpenPeriod WHERE OpenPeriodID=1";
                cmdOpt.CommandType = System.Data.CommandType.Text;
                adOpt.SelectCommand = cmdOpt;
                DataTable dtOpt = new DataTable();
                adOpt.Fill(dtOpt);

                foreach (DataRowView drv in dtOpt.DefaultView)
                {
                    openYY = (int)drv.Row["OpenPeriodYY"];
                    openMM = (int)drv.Row["OpenPeriodMM"];
                    openMMName = (string)drv.Row["OpenPeriodMMName"];
                    openPeriod = (int)drv.Row["OpenPeriod"];
                    RestrictOZP = (int)drv.Row["RestrictOZP"];
                }



            }
            catch (Exception E)
            {
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (" + ")", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }


        }


        //static public void GetOpenPeriod(SqlConnection cnn)
        //{
        //    try
        //    {
        //        string tblScalar = "Scalar";
        //        DataSet dsMain = new DataSet();
        //        if (dsMain.Tables.Contains(tblScalar)) dsMain.Tables.Remove(tblScalar);
        //        SqlDataAdapter adSc = new SqlDataAdapter();
        //        SqlCommand cmdSc = new SqlCommand();
        //        cmdSc.Connection = cnn;
        //        cmdSc.CommandText = "SELECT OpenPeriodID, OpenPeriod,  OpenPeriodYY, OpenPeriodMM, OpenPeriodMMName  FROM v_SLROpenPeriod WHERE OpenPeriodID=1";
        //        cmdSc.CommandType = System.Data.CommandType.Text;
        //        adSc.SelectCommand = cmdSc;
        //        adSc.Fill(dsMain, tblScalar);
        //        foreach (DataRowView drv in dsMain.Tables[tblScalar].DefaultView)
        //        {
        //            openYY = (int)drv.Row["OpenPeriodYY"];
        //            openMM = (int)drv.Row["OpenPeriodMM"];
        //            openMMName = (string)drv.Row["OpenPeriodMMName"];

        //        }
        //    }
        //    catch (Exception E)
        //    {
        //        MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (" + ")", MessageBoxButtons.OK, MessageBoxIcon.Error);
        //    }


        //}

        static public string GetScalarResult(SqlConnection cnn, string CommandText, SqlParameter prm)
        {
            string returnResult = string.Empty;
            try
            {
                DataSet ds = new DataSet();
                string tblScalar = "tblScalar";
                if (ds.Tables.Contains(tblScalar)) ds.Tables.Remove(tblScalar);

                SqlCommand cmd = new SqlCommand();
                cmd.Connection = cnn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = CommandText;
                cmd.Parameters.Add(prm);


                SqlDataAdapter ad = new SqlDataAdapter();
                ad.SelectCommand = cmd;
                ad.Fill(ds, tblScalar);


                foreach (DataRowView drv in ds.Tables[tblScalar].DefaultView)
                {
                    returnResult = drv.Row[0].ToString();
                }
                return returnResult;



            }
            catch (Exception E)
            {
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (GetScalarResult)", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return returnResult;
            }
        }


    }

    /// <summary>
    /// Класс для создания SQL-параметра к хранимым процедурам
    /// </summary>
    public class CreateParameter
    {
        //создаем параметр для хранимой процедуры
        /// <summary>
        /// Функция для создания SQL-параметра к хранимым процедурам
        /// </summary>
        /// <param name="ParamName">Имя параметра</param>
        /// <param name="DataType">Тип данных параметра</param>
        /// <param name="ParLength">Длина параметра в байтах</param>
        /// <param name="ParDirection">Директива параметра</param>
        /// <param name="Value">Значение параметра</param>
        /// <returns></returns>
        public SqlParameter CreateParam(string ParamName, SqlDbType DataType, int ParLength, ParameterDirection ParDirection, string Value)
        {
            SqlParameter Par = new SqlParameter();
            Par.ParameterName = ParamName;
            Par.SqlDbType = DataType;
            Par.Size = ParLength;
            Par.Direction = ParDirection;
            Par.IsNullable = true;
            if (Value == "" || Value == null)
            {
                Par.Value = null;
            }
            else
            {
                switch (DataType)
                {
                    case SqlDbType.BigInt:
                        Par.Value = Convert.ToInt64(Value);
                        break;
                    case SqlDbType.Bit:
                        Par.Value = Convert.ToBoolean(Value);
                        break;
                    case SqlDbType.Char:
                        Par.Value = Value.ToString();
                        break;
                    case SqlDbType.DateTime:
                        if (Value == "//")
                        {
                            Par.Value = null;
                        }
                        else
                        {
                            Par.Value = Convert.ToDateTime(Value);
                        }
                        break;
                    case SqlDbType.SmallDateTime:
                        if (Value == "//")
                        {
                            Par.Value = null;
                        }
                        else
                        {
                            Par.Value = Convert.ToDateTime(Value);
                        }
                        break;
                    case SqlDbType.Decimal:
                        Par.Value = Convert.ToDecimal(Value);
                        break;
                    case SqlDbType.Float:
                        Par.Value = Convert.ToDouble(Value);
                        break;
                    case SqlDbType.Int:
                        Par.Value = Convert.ToInt32(Value);
                        break;
                    case SqlDbType.Money:
                        Par.Value = Value;
                        break;
                    case SqlDbType.TinyInt:
                        Par.Value = Convert.ToInt16(Value);
                        break;
                    case SqlDbType.VarChar:
                        Par.Value = Value.ToString();
                        break;
                    case SqlDbType.Text:
                        Par.Value = Value.ToString();
                        break;
                }
            }
            return Par;
        }
    }



      /// <summary>
  /// Класс выполняющий некоторые проверки
  /// </summary>
  public class CheckFunctions
  {
    /// <summary>
    /// Проверка на числовое значение.
    /// </summary>
    /// <param name="CheckedString">Значение которое нужно проверить. Если функция вернула 0, то все нормально, если 1, то ошибка.</param>
    /// <returns></returns>
    public int CheckNumeric(string CheckedString)
    {
      try
      {
        //Convert.ToInt64(CheckedString);
        Convert.ToDouble(CheckedString);
        return 0;
      }
      catch
      {
        return 1;
      }
    }

    /// <summary>
    /// Проверка на дату
    /// </summary>
    /// <param name="CheckedString">Значение которое нужно проверить. Если функция вернула 0, то все нормально, если 1, то ошибка.</param>
    /// <returns></returns>
    public int CheckDate(string CheckedString)
    {
      try
      {
        Convert.ToDateTime(CheckedString);
        return 0;
      }
      catch
      {
        return 1;
      }
    }
    /// <summary>
    /// Функция сравнивает две таблицы и возвращает таблицу с записями, которые нужно добавить в базу данных
    /// </summary>
    /// <param name="ComparedTable">Сравниваемая таблица. Таблица, записи которой были изменены.</param>
    /// <param name="TemplateTable">Таблица-образец. Таблица, записи которой не были изменены.</param>
    /// <param name="ColumnName">Имя ключегого поля, по которому сравнивать записи.</param>
    /// <returns></returns>
    public DataTable GetRecordForInsert(DataTable ComparedTable, DataTable TemplateTable, string ColumnName)
    {
      DataTable tbl = ComparedTable.Clone();
      if (TemplateTable == null) TemplateTable = ComparedTable.Clone();
      if (ComparedTable.Rows.Count <= TemplateTable.Rows.Count) return tbl;
      foreach (DataRow dr in ComparedTable.Rows)
      {
        try
        {
          if (TemplateTable.Select(ColumnName + " = " + dr[ColumnName].ToString()).Length == 0) tbl.ImportRow(dr);
        }
        catch
        {
          if (TemplateTable.Select(ColumnName + " = '" + dr[ColumnName].ToString() + "'").Length == 0) tbl.ImportRow(dr);
        }
      }
      return tbl;
    }
    /// <summary>
    /// Функция меняет запятую в числовом значении на точку.
    /// </summary>
    /// <param name="NumericValue">Значание в котором нужно заменить запятую на точку</param>
    /// <returns></returns>
    public string NumericCondition(string NumericValue)
    {
      NumericValue = NumericValue.Trim().Replace(",", ".");
      return NumericValue;
    }
    /// <summary>
    /// Процедура для позиционирования на нужную запись в комбобоксе.
    /// </summary>
    /// <param name="cmb">Комбобокс, в котором нужно спозиционироваться.</param>
    /// <param name="tbl">Таблица с данными, которыми звполнен комбобокс.</param>
    /// <param name="ColumnName">Имя колонки в таблице, по которой будет произведен поиск.</param>
    /// <param name="FindValue">Значение искомого параметра.</param>
    public void ComboBoxReposition(System.Windows.Forms.ComboBox cmb, DataTable tbl, string ColumnName, string FindValue)
    {
      if (tbl == null || tbl.Rows.Count == 0) return;
      int i = 0;
      foreach (DataRow dr in tbl.Rows)
      {
        if (dr[ColumnName].ToString() == FindValue)
        {
          cmb.SelectedIndex = i;
          return;
        }
        i = i + 1;
      }
    }
    /// <summary>
    /// Процедура позиционирования на строке в экстрагриде по заданному полю и значению.
    /// </summary>
    /// <param name="gv">GridView, которое содержит строки.</param>
    /// <param name="KeyField">Название поля, по которому будет осуществлен поиск строки.</param>
    /// <param name="KeyValue">Значение поля.</param>
    public void GridViewPosition(DevExpress.XtraGrid.Views.Grid.GridView gv, string KeyField, string KeyValue)
    {
      //так как в гриде записи можгут быть по разному отсортированны пользователем, то будем опираться на представление
      for (int i = 0; i < gv.RowCount; i++)
      {
        if (gv.GetDataRow(i) != null)
        {
          if (gv.GetDataRow(i)[KeyField].ToString() == KeyValue)
          {
            gv.FocusedRowHandle = i;
            return;
          }
        }
      }
    }
    /// <summary>
    /// Процедура позиционирования на строке в экстрагриде по двум заданным полям и значениям.
    /// </summary>
    /// <param name="gv">GridView, которое содержит строки.</param>
    /// <param name="KeyField1">Название поля 1, по которому будет осуществлен поиск строки.</param>
    /// <param name="KeyValue1">Значение поля 1.</param>
    /// <param name="KeyField2">Название поля 2, по которому будет осуществлен поиск строки.</param>
    /// <param name="KeyValue2">Значение поля 1.</param>
    public void GridViewPosition(DevExpress.XtraGrid.Views.Grid.GridView gv, string KeyField1, string KeyValue1, string KeyField2, string KeyValue2)
    {
      //так как в гриде записи можгут быть по разному отсортированны пользователем, то будем опираться на представление
      for (int i = 0; i < gv.RowCount; i++)
      {
        if (gv.GetDataRow(i)[KeyField1].ToString() == KeyValue1 && gv.GetDataRow(i)[KeyField2].ToString() == KeyValue2)
        {
          gv.FocusedRowHandle = i;
          return;
        }
      }
    }
    /// <summary>
    /// Процедура позиционирования на строке в экстрагриде по заданному полю и значению.
    /// </summary>
    /// <param name="gv">GridView, которое содержит строки.</param>
    /// <param name="KeyField">Название поля, по которому будет осуществлен поиск строки.</param>
    /// <param name="KeyValue">Значение поля.</param>
    public void GridViewPosition(DevExpress.XtraGrid.Views.BandedGrid.AdvBandedGridView gv, string KeyField, string KeyValue)
    {
      //так как в гриде записи можгут быть по разному отсортированны пользователем, то будем опираться на представление
      for (int i = 0; i < gv.RowCount; i++)
      {
        if (gv.GetDataRow(i) != null)
        {
          if (gv.GetDataRow(i)[KeyField].ToString() == KeyValue)
          {
            gv.FocusedRowHandle = i;
            return;
          }
        }
      }
    }
    /// <summary>
    /// Функция проверяет на наличие редактируемых строк в таблице.
    /// Если есть такие записи, то возвращает True, если нет, то False.
    /// </summary>
    /// <param name="tbl">Таблица, в которой производится поиск.</param>
    /// <returns></returns>
    public bool FindModifiedRows(DataTable tbl)
    {
      if (tbl == null) return false;
      if (tbl.Rows.Count == 0) return false;
      foreach (DataRow dr in tbl.Rows)
      {
        if (dr.RowState == DataRowState.Modified)
        {
          return true;
        }
      }
      return false;
    }
    /// <summary>
    /// Функция проверяет на наличие редактируемых строк в массиве строк.
    /// Если есть такие записи, то возвращает True, если нет, то False.
    /// </summary>
    /// <param name="tbl">Таблица, в которой производится поиск.</param>
    /// <returns></returns>
    public bool FindModifiedRows(DataRow[] ra)
    {
      if (ra == null) return false;
      if (ra.Length == 0) return false;
      for (int i = 0; i < ra.Length; i++)
      {
        DataRow dr = (DataRow)ra.GetValue(i);
        if (dr.RowState == DataRowState.Modified)
        {
          return true;
        }
      }
      return false;
    }
    /// <summary>
    /// Функция проверяет на наличие добавленных строк в таблице.
    /// Если есть такие записи, то возвращает True, если нет, то False.
    /// </summary>
    /// <param name="tbl">Таблица, в которой производится поиск.</param>
    /// <returns></returns>
    public bool FindAddedRows(DataTable tbl)
    {
      if (tbl == null) return false;
      if (tbl.Rows.Count == 0) return false;
      foreach (DataRow dr in tbl.Rows) if (dr.RowState == DataRowState.Added) return true;
      return false;
    }
    /// <summary>
    /// Функция проверяет на наличие добавленных строк в массиве строк.
    /// Если есть такие записи, то возвращает True, если нет, то False.
    /// </summary>
    /// <param name="tbl">Таблица, в которой производится поиск.</param>
    /// <returns></returns>
    public bool FindAddedRows(DataRow[] ra)
    {
      if (ra == null) return false;
      if (ra.Length == 0) return false;
      for (int i = 0; i < ra.Length; i++)
      {
        DataRow dr = (DataRow)ra.GetValue(i);
        if (dr.RowState == DataRowState.Added)
        {
          return true;
        }
      }
      return false;
    }
    /// <summary>
    /// Функция проверяет на наличие удаленных строк в таблице.
    /// Если есть такие записи, то возвращает True, если нет, то False.
    /// </summary>
    /// <param name="tbl">Таблица, в которой производится поиск.</param>
    /// <returns></returns>
    public bool FindDeletedRows(DataTable tbl)
    {
      if (tbl == null) return false;
      if (tbl.Rows.Count == 0) return false;
      foreach (DataRow dr in tbl.Rows) if (dr.RowState == DataRowState.Deleted) return true;
      return false;
    }
    /// <summary>
    /// Функция возвращает значение заданного поля из заданной таблицы.
    /// </summary>
    /// <param name="tbl">Таблица для поиска.</param>
    /// <param name="FindField">Поле, по которому будет происходить поиск.</param>
    /// <param name="FindFieldValue">Искомое значение.</param>
    /// <param name="ReturnField">Поле, значение которого нужно вернуть.</param>
    /// <returns>string</returns>
    public string GetFieldValue(DataTable tbl, string FindField, string FindFieldValue, string ReturnField)
    {
      string ReturnValue = "";
      if (tbl.Select(FindField + " = " + FindFieldValue).Length == 0) return "";
      ReturnValue = ((DataRow)tbl.Select(FindField + " = " + FindFieldValue).GetValue(0))[ReturnField].ToString();
      return ReturnValue;
    }
    /// <summary>
    /// Процедура позиционирует LookUp по заданному значению заданного поля.
    /// </summary>
    /// <param name="lup"></param>
    /// <param name="KeyField"></param>
    /// <param name="KeyValue"></param>
    public void LookUpPosition(DevExpress.XtraEditors.LookUpEdit lup, string KeyField, string KeyValue)
    {
      DataTable tbl = (DataTable)lup.Properties.DataSource;
      for (int i = 0; i < tbl.Rows.Count; i++)
      {
        string aaa = tbl.Rows[i][KeyField].ToString();
        if (tbl.Rows[i][KeyField].ToString().Trim() == KeyValue.Trim())
        {
          lup.ItemIndex = i;
          return;
        }
      }
    }
    /// <summary>
    /// Функция меняет в значении строки точку на разделитель дробной части, который установлен в системе.
    /// </summary>
    /// <param name="StrValue">Значение строки в которой нужно заменить точку на разделитель дробной части.</param>
    /// <returns>string</returns>
    public string SetDecimalSeparator(string StrValue)
    {
      string DecSep = System.Globalization.NumberFormatInfo.CurrentInfo.CurrencyDecimalSeparator;
      StrValue = StrValue.Replace(".", DecSep);
      return StrValue;
    }
  }
}

