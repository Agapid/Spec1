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

    public partial class fSpecView : Form
    {


        #region Declare sections



        #region  Таблицы с данными, SqlConnection, DataSet, DataView, CurrencyManagers


        private System.Data.SqlClient.SqlConnection cnn;
        private DataSet dsMain = new DataSet();
        private string tMain = "tMain";
        private string tT = "tT";
       
        private DataView dvLookUpSSID = new DataView();


        //Переменная хранит ссылку на модальную форму редактирования
        fTSpecModify fModify = new fTSpecModify();
        fTSpecInsert fInsert = new fTSpecInsert();

        ALTONIKA.fErrorMessage ErrorMessage = new ALTONIKA.fErrorMessage();

        fPosMaskMake fDetailsModify = new fPosMaskMake();

        DataTable dtCompleteSets = new DataTable();

        DataTable dtInsertFormLookupTable = new DataTable("InsertFormLookupTable");

        private string UserPassword = "";
        private string UserName = "";
        #endregion

        private CreateParameter CrParam = new CreateParameter();

        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////
        #region CompleteStatus 
        public enum CompleteStatusValueEnum
        { 
            InFactory = 0,
            InEdit = 1,
            Unknown = -1

        }

        private struct CurrentCompleteStatuses
        {
            public CompleteStatusValueEnum StatusValue;
            public string StatusCreator;
            public string StatusDate;
 
            public void Print()
            {
                MessageBox.Show("ddd");
            }

        }


        private CurrentCompleteStatuses CompleteStatus;
        #endregion
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////

        #endregion


        #region Initialization sections
        public fSpecView()
        {
            InitializeComponent();
        }

        //[STAThread]
        //public static void Main()
        //{
        //    try
        //    {
        //        Application.Run(new fTestView());
        //    }
        //    catch (Exception E)
        //    {
        //        MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (" + Application.ProductName + ")", MessageBoxButtons.OK, MessageBoxIcon.Error);
        //    }
        //}

        #endregion 


        #region Events sections
        private void Form1_Load(object sender, EventArgs e)
        {
            
            try
            {

                ErrorMessage.FormError = this;
                ErrorMessage.SQLConnection = cnn;


                LookupsFill();

                RefreshData();



                /*Настройка и запуск главного грида*/
                CBarMain.BarSqlConnection = cnn;
                CBarMain.ManagedGridView = viewMain;
                CBarMain.ManagedDockManager = dockManager1;
                CBarMain.StpSQLUserInfoName = "stpQUALUserInfo";
                CBarMain.KeyFieldName = "RecordID";

                CBarMain.InsertForm = (ALTONIKA.IEditForm)fInsert;
                CBarMain.EditForm = (ALTONIKA.IEditForm)fModify;


                fModify.SaveButtonClick += new SaveButtonClickEventHandler(this.SaveButtonClick);
                fModify.CancelButtonClick += new CancelButtonClickEventHandler(this.CancelButtonClick);


                fInsert.SaveButtonClick += new SaveButtonClickEventHandler(this.SaveButtonClick);
                fInsert.CancelButtonClick += new CancelButtonClickEventHandler(this.CancelButtonClick);

                this.lkpSearch.EditValueChanged += new System.EventHandler(this.lkpSearch_EditValueChanged);


                CBarMain.Start();


                /*Настройка и запуск подчиненного грида*/
                CBarDetails.BarSqlConnection = cnn;
                CBarDetails.ManagedGridView = viewDetails;
                CBarDetails.KeyFieldName = "RecordID";
                CBarDetails.StpSQLUserInfoName = "stpQUALUserInfo";

                //FillgrdDetails();
                CBarDetails.EditForm = (ALTONIKA.IEditForm)fDetailsModify;
                //подписываемся на события Сохранить и Отмена внешней модальной формы
                fDetailsModify.SaveButtonClick += new SaveButtonClickEventHandler(this.DetailsSaveButtonClick);
                //fModifyTime.CancelButtonClick += new CancelButtonClickEventHandler(this.CancelButtonClick);
                CBarDetails.Start();



                ChangeControlsEnable(GetCurrentCompleteStatus(int.Parse(lkpSearch.EditValue.ToString())));


 


            }
            catch (Exception E)
            {

                ErrorMessage.Ex = E;
                ErrorMessage.ShowDialog();


            }
        }



        private void CBarMain_BeginDelete(object sender, ControlBarButtonClickEventArgs e)
        {
            try
            {
                //fModify.CompleteSetID = ALTONIKA.Tools.IsNull(lkpComplProdMod.Properties.GetDataSourceValue("CompleteSetID", lkpComplProdMod.ItemIndex).ToString(), 0);
                //fModify.ModuleID = ALTONIKA.Tools.IsNull(lkpComplProdMod.Properties.GetDataSourceValue("ModuleID", lkpComplProdMod.ItemIndex).ToString(), 0);
                //fModify.ProductNPID = ALTONIKA.Tools.IsNull(lkpComplProdMod.Properties.GetDataSourceValue("ProductNPID", lkpComplProdMod.ItemIndex).ToString(), 0);

                fModify.CompleteSetID = ALTONIKA.Tools.IsNull(txtCompleteSetID.Text, 0);



                if (fModify.ShowDialog() == DialogResult.Cancel)
                {
                    e.CancelOperation = true;
                    return;
                }
                RefreshData();



            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }
        }

        private void CBarMain_BeginEdit(object sender, ControlBarButtonClickEventArgs e)
        {
            try
            {
          
                fModify.CompleteSetID = ALTONIKA.Tools.IsNull(txtCompleteSetID.Text, 0);



                if (fModify.ShowDialog() == DialogResult.Cancel)
                {
                    e.CancelOperation = true;
                    return;
                }
                RefreshEditRow();

            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }
        }

        private void CBarMain_BeginInsert(object sender, ControlBarButtonClickEventArgs e)
        {
            try
            {

                //fModify.CompleteSetID = ALTONIKA.Tools.IsNull(lkpComplProdMod.Properties.GetDataSourceValue("CompleteSetID", lkpComplProdMod.ItemIndex).ToString(), 0);
                //fModify.ModuleID = ALTONIKA.Tools.IsNull(lkpComplProdMod.Properties.GetDataSourceValue("ModuleID", lkpComplProdMod.ItemIndex).ToString(), 0);
                //fModify.ProductNPID = ALTONIKA.Tools.IsNull(lkpComplProdMod.Properties.GetDataSourceValue("ProductNPID", lkpComplProdMod.ItemIndex).ToString(), 0);

                fInsert.CompleteSetID = ALTONIKA.Tools.IsNull(txtCompleteSetID.Text, 0);
                fInsert.LookupTable = dtInsertFormLookupTable;


                if (fInsert.ShowDialog() == DialogResult.Cancel)
                {
                    e.CancelOperation = true;
                    return;
                }
                RefreshData();
                viewMain.MoveLast();

               // FillgrdDetails();

            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }
        }

        private void CBarMain_BeginRefresh(object sender, ControlBarButtonClickEventArgs e)
        {
            RefreshData();
        }

        private void CBarMain_BeginView(object sender, ControlBarButtonClickEventArgs e)
        {
            try
            {

                if (fModify.ShowDialog() == DialogResult.Cancel)
                {
                    e.CancelOperation = true;
                    return;
                }

            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }
        }


        private void CBarMain_PositionChanged(object sender, ALTONIKA.ControlBarPositionChangeEventArgs e)
        {

            FillgrdDetails();
        }


        private void lkpSearch_EditValueChanged(object sender, EventArgs e)
        {

            try
            {




                DataRow dr = ViewSearch.GetDataRow(ViewSearch.FocusedRowHandle);

                if (dr != null)
                {


                    txtFocusedRowHandle.Text = ViewSearch.FocusedRowHandle.ToString();
                    txtCompleteSetID.Text = ALTONIKA.Tools.IsNull(dr["CompleteSetID"].ToString(), 0).ToString();



                    /*запросить с сервера статус комплекта*/






                    //ChangeControlsEnable(GetCurrentCompleteStatus(int.Parse(lkpSearch.EditValue.ToString())));

                }

                RefreshData();

                //int _EnableModify = (int)ALTONIKA.Tools.IsNull(dr["EnableModify"], 0);
                //int _EnableModify1 = (int)ALTONIKA.Tools.IsNull(dr["EnableModify1"], 0);









                lkpSearch.Focus();
                lkpSearch.SelectAll();

            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }


        }

        private void btnInFactory_Click(object sender, EventArgs e)
        {
            string bodyText = string.Empty;

            fSpecStatusComment f = new fSpecStatusComment();
            f.CompleteSetName = "Комплект " + lkpSearch.Text;
            f.SqlConn = cnn;
            f.InfoText = "Перевести в производcтво";
            f.InfoColor = Color.DarkGreen;
            f.ShowDialog();
            if (f.DialogResult != System.Windows.Forms.DialogResult.OK) { return; }


            try
            {




                SqlCommand cmd = new SqlCommand();
                cmd.Connection = cnn;
                cmd.CommandText = "stpCompleteSetsStatusSET";
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter prm;

                /*Возвращаемый параметр*/
                prm = new SqlParameter();
                prm.ParameterName = "@RETURN_VALUE";
                prm.Direction = ParameterDirection.ReturnValue;
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = DBNull.Value;
                cmd.Parameters.Add(prm);

                /*@CompleteSetID*/
                prm = new SqlParameter();
                prm.ParameterName = "@CompleteSetID";
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = (int)lkpSearch.EditValue;
                cmd.Parameters.Add(prm);

                /*@OpCode*/
                prm = new SqlParameter();
                prm.ParameterName = "@OpCode";
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = 0;
                cmd.Parameters.Add(prm);


                cmd.ExecuteNonQuery();

                /*обновляем информацию в струутуре о текущем статсусе*/
                ChangeControlsEnable(GetCurrentCompleteStatus(int.Parse(lkpSearch.EditValue.ToString())));

                DataRow[] dr = dtCompleteSets.Select("CompleteSetID=" + lkpSearch.EditValue.ToString());
                foreach (DataRow row in dr)
                {
                    row["CompleteStatusValue"] = 0;
                    row["CompleteStatusName"] = "В производстве";
                    row["CompleteStatusCreator"] = "";

                }



                SendMail("Спецификация отредактирована.", f.BodyText);

            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }
        }
        private void btnInEdit_Click(object sender, EventArgs e)
        {
            string bodyText = string.Empty;


            fSpecStatusComment f = new fSpecStatusComment();
            f.CompleteSetName = "Комплект " + lkpSearch.Text;
            f.SqlConn = cnn;
            f.InfoText = "Перевести на редактирование";
            f.InfoColor = Color.DarkRed;
            f.ShowDialog();
            if (f.DialogResult != System.Windows.Forms.DialogResult.OK) { return; }





            try
            {
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = cnn;
                cmd.CommandText = "stpCompleteSetsStatusSET";
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter prm;

                /*Возвращаемый параметр*/
                prm = new SqlParameter();
                prm.ParameterName = "@RETURN_VALUE";
                prm.Direction = ParameterDirection.ReturnValue;
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = DBNull.Value;
                cmd.Parameters.Add(prm);

                /*@CompleteSetID*/
                prm = new SqlParameter();
                prm.ParameterName = "@CompleteSetID";
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = (int)lkpSearch.EditValue;
                cmd.Parameters.Add(prm);



                /*@OpCode*/
                prm = new SqlParameter();
                prm.ParameterName = "@OpCode";
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = 1;
                cmd.Parameters.Add(prm);


                cmd.ExecuteNonQuery();

                /*обновляем информацию в струутуре о текущем статсусе*/
                ChangeControlsEnable(GetCurrentCompleteStatus(int.Parse(lkpSearch.EditValue.ToString())));


                DataRow[] dr = dtCompleteSets.Select("CompleteSetID=" + lkpSearch.EditValue.ToString());
                foreach (DataRow row in dr)
                {
                    row["CompleteStatusValue"] = 1;
                    row["CompleteStatusName"] = "На редактировании";
                    row["CompleteStatusCreator"] = CompleteStatus.StatusCreator;


                }


                SendMail(" Спецификация отправлена на редактирование.", f.BodyText);



            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }
        }

        private void lkpSearch_QueryPopUp(object sender, System.ComponentModel.CancelEventArgs e)
        {
            lkpSearch.Properties.PopupFormSize = new Size(lkpSearch.Width, 500);
        }


        #endregion 


        #region Proc sections
        #region                         /**************Заливка данных begin*****************/




        [ALTONIKA.SQLCommandDescript(System.Data.CommandType.StoredProcedure, "stpSpecificationMainGridSelect", "Запполнение грида со спецификацией")]
        public void FillgrdMain()

        {
            try
            {
                viewMain.BeginUpdate();
                Cursor.Current = Cursors.WaitCursor;


                viewMain.GroupPanelText = " ";
              
                //DataRow dr = ViewSearch.GetDataRow(ViewSearch.FocusedRowHandle);
               
                if (dsMain.Tables.Contains(tMain))
                {
                    dsMain.Tables[tMain].Clear();
                }

                /*зачем обращаться к базе, если знаем, что результата не будет*/
               // if ((int)lkpSearch.EditValue == 0) return;

                SqlCommand cmd = new SqlCommand();
                cmd.Connection = cnn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "stpSpecificationMainGridSelect";




                SqlParameter prm = new SqlParameter();
                prm.ParameterName = "@CompleteSetID";
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = Convert.ToInt32(txtCompleteSetID.Text);
                cmd.Parameters.Add(prm);




                SqlDataAdapter ad = new SqlDataAdapter();
                ad.SelectCommand = cmd;
                ad.Fill(dsMain, tMain);
                grdMain.DataSource = this.dsMain;
                grdMain.DataMember = tMain;
                viewMain.EndUpdate();



                if (dsMain.Tables[tMain].Rows.Count == 0)
                {
                   // btnCopyPath.Enabled = true;
                }
                else
                {
                   // btnCopyPath.Enabled = false;
                }


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

        }


        [ALTONIKA.SQLCommandDescript(System.Data.CommandType.StoredProcedure, "stpSpecPosMaskSelect", "Просмотр детализации")]
        public void FillgrdDetails()
        {
            try
            {

                DataRow dr = viewMain.GetDataRow(viewMain.FocusedRowHandle);


                Cursor.Current = Cursors.WaitCursor;


                viewDetails.GroupPanelText = " ";

                if (dsMain.Tables.Contains(tT))
                {
                    dsMain.Tables[tT].Clear();
                }

                if (dr == null) { return; }


                SqlCommand cmd = new SqlCommand();
                cmd.Connection = cnn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "stpSpecPosMaskSelect";

                SqlParameter prm = new SqlParameter();
                prm.ParameterName = "@SpecID";
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = CBarMain.KeyFieldValue;
                cmd.Parameters.Add(prm);


                //SqlParameter prm = new SqlParameter();
                //prm.ParameterName = "@SpecID";
                //prm.SqlDbType = SqlDbType.Int;
                //prm.Value = ALTONIKA.Tools.IsNull(dr["TPID"], 0);
                //cmd.Parameters.Add(prm);







                SqlDataAdapter ad = new SqlDataAdapter();
                ad.SelectCommand = cmd;
                ad.Fill(dsMain, tT);
                viewDetails.BeginUpdate();
                grdDetails.DataSource = this.dsMain;
                grdDetails.DataMember = tT;
                viewDetails.EndUpdate();


                //EnableDataModifyLight это что?////
                //if (dsMain.Tables[tT].Rows.Count == 0)
                //{
                //    btnCopyPath.Enabled = true;
                //    CBarDetails.DisableDataModifyLight();
                //}
                //else
                //{
                //    btnCopyPath.Enabled = false;
                //    CBarDetails.EnableDataModifyLight();
                //}




                grdDetails.Refresh();
                this.viewDetails.OptionsView.ShowChildrenInGroupPanel = true;






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

        }


        



  

        public void FocusRow(GridView view, int rowHandle)
        {
            view.FocusedRowHandle = rowHandle;
        }



        [ALTONIKA.SQLCommandDescript(System.Data.CommandType.StoredProcedure, "", "Заполнение люкапа с комплектами")]
        public void LookupsFill()
        {
            try
            {

                Cursor.Current = Cursors.WaitCursor;
                SqlCommand cmd;
                SqlDataAdapter ad;
                SqlParameter prm;

                //int p = 0;
                //if (lkpSearch.EditValue != null)
                //{
                //    if (lkpSearch.EditValue.ToString() != string.Empty)
                //    {
                //        p = (int)lkpSearch.EditValue;    
                //    }

                //}

                //Комплекты
                //using (DataTable tSt = new DataTable())
                //{
                cmd = new SqlCommand();
                cmd.Connection = cnn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "stpSpecifCompleteLookUp";
                //prm = new SqlParameter("@LookUpID", 65);
                //cmd.Parameters.Add(prm);
                ad = new SqlDataAdapter();
                ad.SelectCommand = cmd;
                ad.Fill(dtCompleteSets);

                lkpSearch.Properties.DataSource = dtCompleteSets.DefaultView;
                lkpSearch.EditValue = -1;


                ChangeControlsEnable(GetCurrentCompleteStatus(int.Parse(lkpSearch.EditValue.ToString())));






                /*Заполнить DataTable с элементами для того, чтобы передавать
                 * эту таблицу в форму добавления нового элемента для люкапа элементов.
                 * Здесь мы эту таблицу заполняем один раз вместо того, чтобь заполнять ее каждый
                 * раз при открытии формы добавления.
                 * 
                */
               
                cmd = new SqlCommand();
                cmd.Connection = cnn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "stpSpecifComponentLookUp";
                    
                ad = new SqlDataAdapter();
                ad.SelectCommand = cmd;
                ad.Fill(dtInsertFormLookupTable);

            



               







                //}


                ///*FocusedRowHandle ???????????????????????????????????????????*/
                //DataRow dr = ViewSearch.GetDataRow(ViewSearch.FocusedRowHandle);

                ////int rowHandle = ViewSearch.LocateByValue(0, CompleteSetID, p, OnRowSearchComplete);
                //int rowHandle = ViewSearch.LocateByValue(0, CompleteSetID, p);



                //if (dr != null)
                //{
                //    CurrentCompleteStatus = (CompleteStatuses)int.Parse(dr["CompleteStatusValue"].ToString());
                //}

                //CompleteStatusCheck();




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
        }


        public void RefreshData()
        {
            try
            {

                int _FocusedRowHandle = CBarMain.FocusedRowHandle;
                int _CurManPosForReturnAfterModify = CBarMain.CurManPosForReturnAfterModify;
                int _TopRowIndex = CBarMain.TopRowIndex;
                this.CBarMain.PositionChanged -= new ALTONIKA.ControlBarPositionChangeEventHandler(this.CBarMain_PositionChanged);



                FillgrdMain();




                this.CBarMain.PositionChanged += new ALTONIKA.ControlBarPositionChangeEventHandler(this.CBarMain_PositionChanged);
                
               
                CBarMain.FocusedRowHandle = _FocusedRowHandle;
                CBarMain.CurManPosForReturnAfterModify = _CurManPosForReturnAfterModify;
                CBarMain.TopRowIndex = _TopRowIndex;

                ChangeControlsEnable(GetCurrentCompleteStatus(int.Parse(lkpSearch.EditValue.ToString())));

            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }

        }
        private void RefreshEditRow()
        {
            try
            {

               

                
                Cursor.Current = Cursors.WaitCursor;

                SqlCommand cmd = new SqlCommand();
                cmd.Connection = cnn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "stpSpecificationMainGridRowSelect";

                SqlParameter prm = new SqlParameter();
                prm.SqlDbType = SqlDbType.Int;
                prm.ParameterName = "@RecordID";
                prm.Value = CBarMain.KeyFieldValue;
                cmd.Parameters.Add(prm);
                SqlDataReader dread = cmd.ExecuteReader();

                if (dread.HasRows)
                {
                    while (dread.Read())
                    {

                        foreach (DevExpress.XtraGrid.Columns.GridColumn gc in viewMain.Columns)
                        {

                            viewMain.SetRowCellValue(viewMain.FocusedRowHandle, gc, dread[gc.Name].ToString());

                        }

                        //viewMain.SetRowCellValue(viewMain.FocusedRowHandle, KeeObjName, ALTONIKA.Tools.IsNull(dread["KeeObjName"], string.Empty));
                        //if (dread["MakedDate"] == DBNull.Value)
                        //{
                        //    viewMain.SetRowCellValue(viewMain.FocusedRowHandle, MakedDate, null);
                        //}
                        //else
                        //{
                        //    viewMain.SetRowCellValue(viewMain.FocusedRowHandle, MakedDate, Convert.ToDateTime(dread["MakedDate"]));
                        //}

                        //if (dread["KeeTime"] == DBNull.Value)
                        //{
                        //    viewMain.SetRowCellValue(viewMain.FocusedRowHandle, KeeTime, null);
                        //}
                        //else
                        //{
                        //    viewMain.SetRowCellValue(viewMain.FocusedRowHandle, KeeTime, Convert.ToDateTime(dread["KeeTime"]));
                        //}

                        //if (dread["InComeDate"] == DBNull.Value)
                        //{
                        //    viewMain.SetRowCellValue(viewMain.FocusedRowHandle, InComeDate, null);
                        //}
                        //else
                        //{
                        //    viewMain.SetRowCellValue(viewMain.FocusedRowHandle, InComeDate, Convert.ToDateTime(dread["InComeDate"]));
                        //}

                        //viewMain.SetRowCellValue(viewMain.FocusedRowHandle, Remark, ALTONIKA.Tools.IsNull(dread["Remark"], string.Empty));
                        //viewMain.SetRowCellValue(viewMain.FocusedRowHandle, QTY, ALTONIKA.Tools.IsNull(dread["QTY"], string.Empty));
                        

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

        }





        private void ChangeControlsEnable(CurrentCompleteStatuses complStat)
        {
            try
            {

                txtCompleteStatusValue.Text = complStat.StatusValue.ToString();
                txtEditValue.Text = lkpSearch.EditValue.ToString();
                txtOldEditValue.Text = lkpSearch.OldEditValue.ToString();


                switch (complStat.StatusValue)
                {
                    case CompleteStatusValueEnum.InFactory:
                        btnInFactory.Enabled = false;
                        btnInEdit.Enabled = true;

                        pnlGreen.Visible = true;
                        pnlRed.Visible = false;

                        /*В датабаре нужно заблокировать возможность модифификации данных*/
                      //  CBarMain.VisibleAllModifyButtons = false;

                       // CBarMain.VisibleButtonEdit = false;
                        CBarMain.VisibleAllModifyButtons = false;
                        CBarDetails.VisibleAllModifyButtons = false;
                        btn1.Visible = false;


                        break;

                    case CompleteStatusValueEnum.InEdit:
                        btnInFactory.Enabled = true;
                        btnInEdit.Enabled = false;

                        pnlGreen.Visible = false;
                        pnlRed.Visible = true;

                       // CBarMain.VisibleAllModifyButtons = true;
                      //  CBarMain.VisibleButtonEdit = true;
                        CBarMain.VisibleAllModifyButtons = true;
                        CBarDetails.VisibleAllModifyButtons = true;
                        btn1.Visible = true;

                        break;

                    case CompleteStatusValueEnum.Unknown:
                        btnInFactory.Enabled = false;
                        btnInEdit.Enabled = false;

                        pnlGreen.Visible = false;
                        pnlRed.Visible = false;


                        CBarMain.VisibleAllModifyButtons = false;
                        CBarDetails.VisibleAllModifyButtons = false;
                        btn1.Visible = false;

                        //CBarMain.DisableDataModify();
                        //CBarDetails.DisableDataModify();

                        break;

                }

                lblCompleteStatusInfo.Text = complStat.StatusCreator + " " + complStat.StatusDate;

                //DataRow dr = ViewSearch.GetDataRow(ViewSearch.FocusedRowHandle);
                //if (dr != null)
                //{
                //    lblCompleteStatusInfo.Text = ALTONIKA.Tools.IsNull(dr["CompleteStatusCreator"].ToString(), "").ToString() + " " + ALTONIKA.Tools.IsNull(dr["CompleteStatusDate"].ToString(), "").ToString();
                //}

            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }
        }

        /// <summary>
        /// возвращает текущий статус комплекта и в виде структуры CurrentCompleteStatuses, 
        /// которая в своих полях содержит информацию из полей таблицы tblCompleteSetsStatus
        /// </summary>
        /// <param name="_completeSetID"></param>
        /// <returns></returns>
        private CurrentCompleteStatuses GetCurrentCompleteStatus(int _completeSetID)
        {
            CurrentCompleteStatuses result;
            result.StatusCreator = string.Empty;
            result.StatusDate = string.Empty;
            result.StatusValue = CompleteStatusValueEnum.Unknown;
            SqlDataReader dread = null;
            try
            {



                using (SqlCommand cmd = new SqlCommand("stpSpecifGetCompleteStatus", cnn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    SqlParameter prm = new SqlParameter("@CompleteSetID", _completeSetID);
                    cmd.Parameters.Add(prm);


                    dread = cmd.ExecuteReader();

                    if (dread.HasRows)
                    {
                        while (dread.Read())
                        {
                            /*заполняем поля структуры*/
                            result.StatusCreator = dread["CompleteStatusCreator"].ToString();
                            result.StatusDate = dread["CompleteStatusDate"].ToString();
                            result.StatusValue = (CompleteStatusValueEnum)int.Parse(dread["CompleteStatusValue"].ToString());

                        }
                    }
                    dread.Close();
                   

                }
                //переменная уровня модуля. Может использоваться в любом месте программы для чтения статуса и других атрибутов.
                CompleteStatus = result;
                return result;
            }



            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
                return result;
            }
            finally
            {

                dread.Close();
            }

        }

        private void SendMail(string mailType, string bodyText)
        {
            try
            {

                SqlCommand cmd = new SqlCommand();
                cmd.Connection = cnn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "stpFillDdls";

                SqlParameter prm = new SqlParameter();
                prm.SqlDbType = SqlDbType.Int;
                prm.ParameterName = "@CheckSelect";
                prm.Value = 18;
                cmd.Parameters.Add(prm);


                SqlDataAdapter ad = new SqlDataAdapter();
                ad.SelectCommand = cmd;
                DataTable dtt = new DataTable();
                ad.Fill(dtt);

                EML em = new EML(cnn);
                em.Subject = "Комплект " + lkpSearch.Text + " " + mailType;
                em.Body = bodyText;
                em.BodyTextType = EML.TextType.TEXT;
                foreach (DataRowView drv in dtt.DefaultView)
                {


                    em.MailAddressTo = drv["Email"].ToString();
                    em.Send();
                }



            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }


        }

        #endregion                      /**************Заливка данных end*****************/


        public void ShowMe()
        {
            Show();
        }




  

        /// <summary>
        /// возвращает текущий статус комплекта и в виде структуры CurrentCompleteStatuses, 
        /// которая в своих полях содержит информацию из полей таблицы tblCompleteSetsStatus
        /// </summary>
        /// <param name="_completeSetID"></param>
        /// <returns></returns>
  
        #endregion 


        #region Property sections
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

        public string _login = "";
        public string Login
        {
            set
            {

                _login = value;
            }
            get
            {
                return _login;
            }
        }
        public string _pass = "";
        public string Pass
        {
            set
            {

                _pass = value;
            }
            get
            {
                return _pass;
            }
        }


        #endregion 


        #region Обработка событий формы редактирования
        private void SaveButtonClick(object sender, SaveButtonClickEventArgs e)
        {
            try
            {


                CBarMain.SetState(ALTONIKA.DataBar.DataBarCurrentStateEnum.isReading, false);

              
        

            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }
 
        }

        private void DetailsSaveButtonClick(object sender, SaveButtonClickEventArgs e)
        {
            try
            {



                MessageBox.Show("Обновляем главную строку");
                CBarMain.SetState(ALTONIKA.DataBar.DataBarCurrentStateEnum.isReading, false);




            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }
 
        }

        

        private void CancelButtonClick(object sender, CancelButtonClickEventArgs e)
        {
            /*обновляем информацию в струутуре о текущем статсусе*/
            //ChangeControlsEnable(GetCurrentCompleteStatus(int.Parse(lkpSearch.EditValue.ToString())));
            CBarMain.EnableDataModify();
         
        }

        private void StatusSetButtonClick(object sender, SaveButtonClickEventArgs e)
        {



            RefreshData();

 
        }
        
        #endregion

  

       


        private void button1_Click(object sender, EventArgs e)
        {
            CBarMain.DisableDataModify();
          

        }

        private void button2_Click(object sender, EventArgs e)
        {
            CBarMain.EnableDataModify();
          
        }

        private void button3_Click(object sender, EventArgs e)
        {
           
        }

        private void CBarDetails_BeginDelete(object sender, ControlBarButtonClickEventArgs e)
        {
            try
            {
                //fOborudModify.CompleteSetID = ALTONIKA.Tools.IsNull(lkpComplProdMod.Properties.GetDataSourceValue("CompleteSetID", lkpComplProdMod.ItemIndex).ToString(), 0);
                //fOborudModify.ModuleID = ALTONIKA.Tools.IsNull(lkpComplProdMod.Properties.GetDataSourceValue("ModuleID", lkpComplProdMod.ItemIndex).ToString(), 0);
                //fOborudModify.ProductNPID = ALTONIKA.Tools.IsNull(lkpComplProdMod.Properties.GetDataSourceValue("ProductNPID", lkpComplProdMod.ItemIndex).ToString(), 0);

                //  fDetailsModify.CompleteSetID = ALTONIKA.Tools.IsNull(txtCompleteSetID.Text, 0);



                DataRow dr = viewDetails.GetDataRow(viewDetails.FocusedRowHandle);
                fDetailsModify.SpecID = CBarMain.KeyFieldValue;
                fDetailsModify.SPMID = ALTONIKA.Tools.IsNull(dr["SPMID"], 0);



                if (fDetailsModify.ShowDialog() == DialogResult.Cancel)
                {
                    e.CancelOperation = true;
                    return;
                }
               
                CBarDetails.SetState(ALTONIKA.DataBar.DataBarCurrentStateEnum.isReading, false);
                FillgrdDetails();



            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }
        }

        private void CBarDetails_BeginEdit(object sender, ControlBarButtonClickEventArgs e)
        {
            try
            {
                //fOborudModify.CompleteSetID = ALTONIKA.Tools.IsNull(lkpComplProdMod.Properties.GetDataSourceValue("CompleteSetID", lkpComplProdMod.ItemIndex).ToString(), 0);
                //fOborudModify.ModuleID = ALTONIKA.Tools.IsNull(lkpComplProdMod.Properties.GetDataSourceValue("ModuleID", lkpComplProdMod.ItemIndex).ToString(), 0);
                //fOborudModify.ProductNPID = ALTONIKA.Tools.IsNull(lkpComplProdMod.Properties.GetDataSourceValue("ProductNPID", lkpComplProdMod.ItemIndex).ToString(), 0);


                //  fOborudModify.CompleteSetID = ALTONIKA.Tools.IsNull(txtCompleteSetID.Text, 0);




                DataRow dr = viewDetails.GetDataRow(viewDetails.FocusedRowHandle);
                fDetailsModify.SpecID = CBarMain.KeyFieldValue;
                fDetailsModify.SPMID = ALTONIKA.Tools.IsNull(dr["SPMID"], 0);


                //fOborudModify.cmpr.FirmName = ALTONIKA.Tools.IsNull(txtFirm.Text, "").ToString();
                //fOborudModify.cmpr.ProductName = ALTONIKA.Tools.IsNull(txtInfo.Text, "").ToString();
                //fOborudModify.cmpr.OperName = ALTONIKA.Tools.IsNull(dr["OperName"], "").ToString();
                //fOborudModify.cmpr.TechSectorName = ALTONIKA.Tools.IsNull(dr["TechSectorName"], "").ToString();



                if (fDetailsModify.ShowDialog() == DialogResult.Cancel)
                {
                    e.CancelOperation = true;
                    return;
                }
                
                CBarDetails.SetState(ALTONIKA.DataBar.DataBarCurrentStateEnum.isReading, false);

                FillgrdDetails();

            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }
        }

        private void CBarDetails_BeginInsert(object sender, ControlBarButtonClickEventArgs e)
        {
            try
            {


                //fOborudModify.CompleteSetID = ALTONIKA.Tools.IsNull(txtCompleteSetID.Text, 0);

                //что там со значением ключа?
                DataRow dr = viewDetails.GetDataRow(viewDetails.FocusedRowHandle);
                fDetailsModify.SpecID = CBarMain.KeyFieldValue;
                fDetailsModify.SPMID = ALTONIKA.Tools.IsNull(dr["SPMID"], 0);


                if (fDetailsModify.ShowDialog() == DialogResult.Cancel)
                {
                    e.CancelOperation = true;
                    return;
                }
                CBarDetails.SetState(ALTONIKA.DataBar.DataBarCurrentStateEnum.isReading, false);
                FillgrdDetails();




            }
            catch (Exception E)
            {
                ALTONIKA.fErrorMessage fError = new ALTONIKA.fErrorMessage();
                fError.FormError = this;
                fError.SQLConnection = cnn;
                fError.Ex = E;
                fError.ShowDialog();
            }
        }





      




  









    







   

 

       

     

     

        
 
    
    




















    }
}
