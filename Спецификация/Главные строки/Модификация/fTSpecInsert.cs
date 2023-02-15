using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Windows.Forms;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;

namespace Spec
{
    public partial class fTSpecInsert : Form, ALTONIKA.IEditForm
    {


        #region Declare sections
        ALTONIKA.fErrorMessage ErrorMessage = new ALTONIKA.fErrorMessage();


        DataSet dsMain = new DataSet();
        private int _Mode = 0;
      

        private int _KeeObjID = 0;
        private DateTime _MakedDate;
        private DateTime _KeeTime;
        private DateTime _InComeDate;
        private string _Remark = string.Empty;
        private int _QTY = 0;



        #endregion


        #region Initialization sections
        public fTSpecInsert()
        {
            InitializeComponent();
        }
        #endregion


        #region Events sections

        private void fModify_Load(object sender, EventArgs e)
        {
            try
            {

                ErrorMessage.FormError = this;
                ErrorMessage.SQLConnection = _SqlConn;

                FillAll();

                lkpComponent.EditValueChanged += new System.EventHandler(this.lkpComponent_EditValueChanged);
                

            }
            catch (Exception E)
            {
                ErrorMessage.Ex = E;
                ErrorMessage.ShowDialog();
            }

        }

        private void btnCancel_Click(object sender, EventArgs e)
        {

            //CancelButtonClickEventArgs clickCancelEvArg = new CancelButtonClickEventArgs();
            //OnCancelButtonClick(clickCancelEvArg);

            ExitForm();

        }

        private void btnSave_Click(object sender, EventArgs e)
        {

            if (int.Parse(lkpComponent.EditValue.ToString()) == -1)
            {
                MessageBox.Show("Не выбран элемент", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            if (int.Parse(clcQuantity.Value.ToString()) == 0)
            {
                MessageBox.Show("Не указано количество", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }

            

            int i = DataModify();

            switch (i)
            {

                case 0:
                    {
                        
                        SaveButtonClickEventArgs clickSaveEvArg = new SaveButtonClickEventArgs();
                        OnSaveButtonClick(clickSaveEvArg);
                        this.DialogResult = DialogResult.OK;
                        break;
                    }

                case -1:
                    {
                        MessageBox.Show("", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        break;
                    }

               

                default:
                    {
                        this.DialogResult = DialogResult.Cancel;
                        break;
                    }

            }

        }

        private void btnDel_Click(object sender, EventArgs e)
        {
            int i = DataModify();

            switch (i)
            {

                case 0:
                    {
                        
                        SaveButtonClickEventArgs clickSaveEvArg = new SaveButtonClickEventArgs();
                        OnSaveButtonClick(clickSaveEvArg);
                        this.DialogResult = DialogResult.OK;
                        break;
                    }
                case 1:
                    {
                        MessageBox.Show("На эту запись имеются ссылки в базе данных. Запись удалить нельзя.", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        break;
                    }

                default:
                    {
                        this.DialogResult = DialogResult.Cancel;
                        break;
                    }

            }
        }

        private void btnClear_Click(object sender, EventArgs e)
        {
            TextClear();
        }

        private void btnDefaultExit_Click(object sender, EventArgs e)
        {
            ExitForm();
        }

     

     

        private void fDefectCardModify_KeyDown(object sender, KeyEventArgs e)
        {
            if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isUpdating || _State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isInserting)
            {
                if (e.Modifiers == Keys.Control)
                    if (e.KeyCode == Keys.Enter)
                    {
                        btnSave_Click(btnSave, new EventArgs());
                    }
            }

        }

       


      

     

        private void fDefectCardModify_Activated(object sender, EventArgs e)
        {


            if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isInserting)
            {
                //lkpOper.Focus();
                //lkpOper.SelectAll();
            }

            else
            {
                txtRemark.Focus();
                txtRemark.SelectAll();
            }



            //if ((int)lkpOper.EditValue == -1)
            //{
                
            //}


        }



        private void SetControlForeColor(object sender, EventArgs e)
        {
            //btnSave.Enabled = true;
            SetForeColor(sender);
        }
        private void Control_Enter(object sender, EventArgs e)
        {
            if (sender is DevExpress.XtraEditors.BaseEdit)
            {
                ((DevExpress.XtraEditors.BaseEdit)sender).SelectAll();

            }

        }
      

        #endregion


        #region Proc sections


        private void SetForeColor(object ctl)
        {
            try
            {
                if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isUpdating)
                {
                    ((Control)ctl).ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    ((Control)ctl).ForeColor = System.Drawing.Color.Black;
                }

            }
            catch (Exception E)
            {
                ErrorMessage.Ex = E;
                ErrorMessage.ShowDialog();
            }
        }
        private void SetForeColor(object ctl, System.Drawing.Color colr)
        {
            try
            {

                ((Control)ctl).ForeColor = colr;

            }
            catch (Exception E)
            {
                ErrorMessage.Ex = E;
                ErrorMessage.ShowDialog();
            }
        }

        /// <summary>
        /// Общее заполнение люкапов и таблиц с данными
        /// </summary>
        private void FillAll()
        {
            try
            {
                Cursor.Current = Cursors.WaitCursor;


                //Заполнение выпадающих списков
                LookupsFill();

                //Заполнение текстовых полей
                SetButtonsStatus();

                //TextFill();

            }
            catch (Exception E)
            {
                ErrorMessage.Ex = E;
                ErrorMessage.ShowDialog();
            }



        }

        [ALTONIKA.SQLCommandDescript(System.Data.CommandType.StoredProcedure, "", "Заполнение люкапа")]
        public void LookupsFill()
        {
            try
            {
       
                Cursor.Current = Cursors.WaitCursor;
                /*Дататэйбл загрузили в вызывающей форме для экономии времени загрузки этой формы*/

                lkpComponent.Properties.DataSource = _LookupTable;
                lkpComponent.EditValue = -1;
             
             
                Cursor.Current = Cursors.Default;
            }
            catch (Exception E)
            {
                ErrorMessage.Ex = E;
                ErrorMessage.ShowDialog();
            }
        }
        private void SetButtonsStatus()
        {
            if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isReading)
            {
                lblInfo0.Text = "Тип операции:";
                lblInfo.Text = " Просмотр";
               
                btnSave.Visible = false;
                
            }
            if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isUpdating)
            {
                lblInfo0.Text = "Тип операции:";
                lblInfo.Text = " Редактирование...";
               
                btnSave.Visible = true;
               
            }
            if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isInserting)
            {
                lblInfo0.Text = "Тип операции:";
                lblInfo.Text = " Добавление...";
               
                btnSave.Visible = true;
               
            }
            if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isDeleting)
            {
                lblInfo0.Text = "Тип операции:";
                lblInfo.Text = " Подтверждение удаления";
               
                btnSave.Visible = false;
              



            }

            this.Update();




        }




        /// <summary>
        /// Заполнение контролов на форме значениями из базы
        /// </summary>

        
        public void TextFill()
        {
            SqlDataReader dread = null;
            try
            {



             


                Cursor.Current = Cursors.WaitCursor;

                if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isInserting)
                {
                    txtRecordID.Text = string.Empty;
                   // lkpOper.Properties.ReadOnly = false;

                }
                else
                {
                    txtRecordID.Text = _KeyFieldValue.ToString();
                   // lkpOper.Properties.ReadOnly = true;
                }

                
                

                SqlCommand cmd = new SqlCommand();
                cmd.Connection = _SqlConn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "stpSpecificationMainGridRowSelect";

                SqlParameter prm = new SqlParameter();
                prm.SqlDbType = SqlDbType.Int;
                prm.ParameterName = "@RecordID";
                if (_KeyFieldValue == null)
                {
                    prm.Value = 0;
                }
                else
                {
                    prm.Value = _KeyFieldValue;
                }


                cmd.Parameters.Add(prm);
                dread = cmd.ExecuteReader();

                if (dread.HasRows)
                {
                    while (dread.Read())
                    {


                      //  lkpOper.EditValue = (Convert.ToInt32(Convert.IsDBNull(dread["TSOID"]) ? 0 : dread["TSOID"]));
                      //  SetForeColor(lkpOper, System.Drawing.Color.Black);


                        if (dread["DateBAccount"] == DBNull.Value)
                        {
                         //   dtDate.EditValue = null;
                        }
                        else
                        {
                           // dtDate.DateTime = Convert.ToDateTime(dread["DateBAccount"]);
                        }
                        //SetForeColor(dtDate, System.Drawing.Color.Black);

                        txtRemark.Text = ALTONIKA.Tools.IsNull(dread["Note"].ToString(), string.Empty).ToString();
                        SetForeColor(txtRemark, System.Drawing.Color.Black);


                        //clcQTY.EditValue = dread["QTY"] == DBNull.Value ? 0 : (int)dread["QTY"];

                        //if (lkpKeeObj.ItemIndex > -1)
                        //{
                        //    clcQTY.Value = (int)lkpKeeObj.Properties.GetDataSourceValue("QTY", lkpKeeObj.ItemIndex);
                        //}
                        //else
                        //{
                        //    clcQTY.EditValue = null;
                        //}
                       // SetForeColor(clcQTY, System.Drawing.Color.Black);



                        //if (dread["MakedDate"] == DBNull.Value)
                        //{
                        //    dtMakedDate.EditValue = null;
                        //}
                        //else
                        //{
                        //    dtMakedDate.DateTime = Convert.ToDateTime(dread["MakedDate"]);
                        //}
                        //SetForeColor(dtMakedDate, System.Drawing.Color.Black);

                        //if (dread["KeeTime"] == DBNull.Value)
                        //{
                        //    dtKeeTime.EditValue = null;
                        //}
                        //else
                        //{
                        //    dtKeeTime.DateTime = Convert.ToDateTime(dread["KeeTime"]);
                        //}
                        //SetForeColor(dtKeeTime, System.Drawing.Color.Black);

                    }
                }
                dread.Close();


                if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isInserting)
                {
                    TextClear();
                }
                

                Cursor.Current = Cursors.Default;

            }
            catch (Exception E)
            {
                dread.Close();
                ErrorMessage.Ex = E;
                ErrorMessage.ShowDialog();
            }

        }


        private void TextClear()
        {
            try
            {
               
               // lkpOper.EditValue = null;
                //clcQTY.EditValue = null;
                //dtMakedDate.EditValue = null;
                //dtKeeTime.EditValue = null;

              //  dtDate.DateTime = DateTime.Today.AddDays(-(DateTime.Today.Day - 1));
                
                txtRemark.Text = String.Empty;
               


            }
            catch (Exception E)
            {
                ErrorMessage.Ex = E;
                ErrorMessage.ShowDialog();
            }

        }


        [ALTONIKA.SQLCommandDescript(System.Data.CommandType.StoredProcedure, "stpSpecificationInsert", "Добавление нового элемента в спецификацию")]
        private int DataModify()
        {

            int _returnValue = -255;
            try
            {




                ///*должны быть заполнены*/
                // if (txtTabN.Text == string.Empty) { return 1; }


                SqlCommand cmd = new SqlCommand();
                cmd.Connection = _SqlConn;
                cmd.CommandText = "stpSpecificationInsert";
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
                if ((int)_CompleteSetID == -1)
                {
                    prm.Value = DBNull.Value;
                }
                else
                {
                    prm.Value = _CompleteSetID;
                }
                cmd.Parameters.Add(prm);




                /*@ComponentID*/
                prm = new SqlParameter();
                prm.ParameterName = "@ComponentID";
                prm.SqlDbType = SqlDbType.Char;
                prm.Size = 25;
                prm.Value = txtComponentID.Text;
                cmd.Parameters.Add(prm);


                /*@Quantity*/
                prm = new SqlParameter();
                prm.ParameterName = "@Quantity";
                prm.SqlDbType = SqlDbType.Decimal;
                prm.Value = clcQuantity.Value;
                cmd.Parameters.Add(prm);

                /*@SPID*/
                prm = new SqlParameter();
                prm.ParameterName = "@SPID";
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = int.Parse(txtSPID.Text);
                cmd.Parameters.Add(prm);


                /*@RepDescript*/
                prm = new SqlParameter();
                prm.ParameterName = "@RepDescript";
                prm.SqlDbType = SqlDbType.VarChar;
                prm.Value = txtRepDescript.Text;
                cmd.Parameters.Add(prm);

                
                
                /*@Note*/
                prm = new SqlParameter();
                prm.ParameterName = "@Note";
                prm.SqlDbType = SqlDbType.VarChar;
                prm.Value = txtRemark.Text;
                cmd.Parameters.Add(prm);


               

                           


                cmd.ExecuteNonQuery();
                _returnValue = Convert.ToInt32(cmd.Parameters["@RETURN_VALUE"].Value);


                if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isInserting)
                {
                    switch (_returnValue)
                    {
                        case 1:
                            MessageBox.Show("Такой элемент в этой спецификации уже существует", "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);

                            return _returnValue;
                        case 2:
                            MessageBox.Show("Редактирование спецификации комплекта со статусом В производстве запрещено", "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);

                            return _returnValue;
                        case 3:
                            MessageBox.Show("Не соответствуют территориальные принадлежности", "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);

                            return _returnValue;
                        case 4:
                            MessageBox.Show("Ошибка при добавлении записи в основную таблицу внутри транзакции! Обратитесь к разработчикам!", "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);

                            return _returnValue;
                        case 5:
                            MessageBox.Show("Ошибка при добавлении записи в архивную таблицу внутри транзакции!", "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);

                            return _returnValue;
                        
                        case 0:
                            return _returnValue;

                    }
                }


        

                return _returnValue;
            }
            catch (Exception E)
            {
                ErrorMessage.Ex = E;
                ErrorMessage.ShowDialog();
                return _returnValue;
            }
        }

        private void ExitForm ()
        {
            /*генерируем событие клика по соответствующей кнопке на тулбаре (для наружнего подписчика, если он есть)*/
            CancelButtonClickEventArgs clickCancelEvArg = new CancelButtonClickEventArgs();
            OnCancelButtonClick(clickCancelEvArg);

            this.DialogResult = DialogResult.Cancel;
            this.Close();


        }
        #endregion


        #region Property sections
        private System.Data.SqlClient.SqlConnection _SqlConn;
        public SqlConnection SqlConn
        {
            set
            {
               
                _SqlConn = value;
            }
            get
            {
                return _SqlConn;
            }
        }


        private ALTONIKA.DataBar.DataBarCurrentStateEnum _State = ALTONIKA.DataBar.DataBarCurrentStateEnum.isUnknown;
        public ALTONIKA.DataBar.DataBarCurrentStateEnum BarState
        {
            set
            {

                _State = value;
            }
            get
            {
                return _State;
            }
        }

        object _KeyFieldValue = DBNull.Value;
        public object KeyFieldValue
        {
            get
            {
                return _KeyFieldValue;
            }
            set
            {
                _KeyFieldValue = value;
            }
        }


        /// <summary>
        /// CompleteSetID
        /// </summary>
        object _CompleteSetID = DBNull.Value;
        public object CompleteSetID
        {
            get
            {
                return _CompleteSetID;
            }
            set
            {
                _CompleteSetID = value;
            }
        }

        /// <summary>
        /// SpecID
        /// </summary>
        object _SpecID = DBNull.Value;
        public object SpecID
        {
            get
            {
                return _SpecID;
            }
            set
            {
                _SpecID = value;
            }
        }


        /// <summary>
        /// LookupTable
        /// </summary>
        DataTable _LookupTable = new DataTable("LookupTable");
        public DataTable LookupTable
        {
            get
            {
                return _LookupTable;
            }
            set
            {
                _LookupTable = value;
            }
        }

        
        


        #endregion


        #region Пользовательские события

        /// <summary>
        /// 
        /// </summary>
        [
        Category(""),
        Description("")
        ]
        public event SaveButtonClickEventHandler SaveButtonClick;
        /// <summary>
        /// Зажигаем событие Сохранить
        /// </summary>
        /// <param name="e"></param>
        protected virtual void OnSaveButtonClick(SaveButtonClickEventArgs e)
        {

            //если на событие есть подписчик, передаем ему делагата
            if (SaveButtonClick != null)
            {
                SaveButtonClick(this, e);
            }

        }



        /// <summary>
        /// 
        /// </summary>
        [
        Category(""),
        Description("")
        ]
        public event CancelButtonClickEventHandler CancelButtonClick;
        /// <summary>
        /// Зажигаем событие Отмена
        /// </summary>
        /// <param name="e"></param>
        protected virtual void OnCancelButtonClick(CancelButtonClickEventArgs e)
        {

            //если на событие есть подписчик, передаем ему делагата
            if (CancelButtonClick != null)
            {
                CancelButtonClick(this, e);
            }

        }



        #endregion

        private void lkpKeeObj_EditValueChanged(object sender, EventArgs e)
        {
            try
            {
               // if (lkpOper.ItemIndex == -1) return;
              
                //clcQTY.Value = (int)lkpKeeObj.Properties.GetDataSourceValue("QTY", lkpKeeObj.ItemIndex);
            }
            catch (Exception E)
            {
                ErrorMessage.Ex = E;
                ErrorMessage.ShowDialog();
            }
        }

        private void lkpComponent_EditValueChanged(object sender, EventArgs e)
        {

            try
            {




                DataRow dr = ViewSearch.GetDataRow(ViewSearch.FocusedRowHandle);

                if (dr != null)
                {


                    //txtFocusedRowHandle.Text = ViewSearch.FocusedRowHandle.ToString();


                    txtPMSign.Text = ALTONIKA.Tools.IsNull(dr["PMSign"].ToString(), "").ToString();
                    txtComponentID.Text = ALTONIKA.Tools.IsNull(dr["ComponentID"].ToString(), "").ToString();
                    txtElementID.Text = ALTONIKA.Tools.IsNull(dr["ElementID"].ToString(), 0).ToString();
                    txtSPID.Text = ALTONIKA.Tools.IsNull(dr["SPID"].ToString(), 0).ToString();



                    /*запросить с сервера статус комплекта*/






                    //ChangeControlsEnable(GetCurrentCompleteStatus(int.Parse(lkpSearch.EditValue.ToString())));

                }

                

                //int _EnableModify = (int)ALTONIKA.Tools.IsNull(dr["EnableModify"], 0);
                //int _EnableModify1 = (int)ALTONIKA.Tools.IsNull(dr["EnableModify1"], 0);









          

            }
            catch (Exception E)
            {

                ErrorMessage.Ex = E;
                ErrorMessage.ShowDialog();
            }

        }

        private void statusStrip1_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {

        }

        private void lkpComponent_QueryPopUp(object sender, CancelEventArgs e)
        {
            lkpComponent.Properties.PopupFormSize = new Size(lkpComponent.Width, 500);
        }





    }
}
