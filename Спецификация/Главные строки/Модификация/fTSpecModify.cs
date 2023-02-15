using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Windows.Forms;
using System.Data;
using System.Data.SqlClient;


namespace Spec
{
    public partial class fTSpecModify : Form, ALTONIKA.IEditForm
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
        public fTSpecModify()
        {
            InitializeComponent();
        }
        #endregion


        #region Events sections

        private void fModify_Load(object sender, EventArgs e)
        {
            try
            {
                switch (_State)
                {

                    case ALTONIKA.DataBar.DataBarCurrentStateEnum.isUpdating:
                        {
                            this.Text = "Редактирование элемента спецификации";
                            break;
                        }

                    case ALTONIKA.DataBar.DataBarCurrentStateEnum.isReading:
                        {
                            this.Text = "Просмотр элемента спецификации";
                            break;
                        }

                    case ALTONIKA.DataBar.DataBarCurrentStateEnum.isDeleting:
                        {
                            this.Text = "Удаление элемента спецификации";
                            break;
                        }

                
                
                }





                ErrorMessage.FormError = this;
                ErrorMessage.SQLConnection = _SqlConn;

                FillAll();
              
                //this.lkpOper.EditValueChanged += new System.EventHandler(this.lkpOper_EditValueChanged);
                

            }
            catch (Exception E)
            {
                ErrorMessage.Ex = E;
                ErrorMessage.ShowDialog();
            }

        }

        private void btnCancel_Click(object sender, EventArgs e)
        {

            ExitForm();

        }

        private void btnSave_Click(object sender, EventArgs e)
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

                case -1:
                    {
                        MessageBox.Show("", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        break;
                    }

                case 1:
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
            int i = RecordDelete();

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
                       // MessageBox.Show("На эту запись имеются ссылки в базе данных. Запись удалить нельзя.", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
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




            clcQuantity.Focus();
            clcQuantity.SelectAll();
            





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


               

                //Заполнение текстовых полей
                SetButtonsStatus();
                TextFill();

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
                SqlCommand cmd;
                SqlDataAdapter ad;
                SqlParameter prm;





                //операции
                using (DataTable tTable = new DataTable())
                {
                    cmd = new SqlCommand();
                    cmd.Connection = _SqlConn;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "stpTechPathGetData";
                    prm = new SqlParameter("@Switch", 7);
                    cmd.Parameters.Add(prm);
                    ad = new SqlDataAdapter();
                    ad.SelectCommand = cmd;
                    ad.Fill(tTable);
                   // lkpOper.Properties.DataSource = tTable.DefaultView;
                }


             
             
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
                btnClear.Visible = false;
                btnSave.Visible = false;
                btnDel.Visible = false;
            }
            if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isUpdating)
            {
                lblInfo0.Text = "Тип операции:";
                lblInfo.Text = " Редактирование...";
                btnClear.Visible = true;
                btnSave.Visible = true;
                btnDel.Visible = false;
            }
            if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isInserting)
            {
                lblInfo0.Text = "Тип операции:";
                lblInfo.Text = " Добавление...";
                btnClear.Visible = true;
                btnSave.Visible = true;
                btnDel.Visible = false;
            }
            if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isDeleting)
            {
                lblInfo0.Text = "Тип операции:";
                lblInfo.Text = " Подтверждение удаления";
                btnClear.Visible = false;
                btnSave.Visible = false;
                btnDel.Visible = true;



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

               
               txtRecordID.Text = _KeyFieldValue.ToString();
               
               



                
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




                        txtComponentName.Text = ALTONIKA.Tools.IsNull(dread["ComponentName"].ToString(), string.Empty).ToString();
                        SetForeColor(txtComponentName, System.Drawing.Color.Black);

                        clcQuantity.EditValue = dread["Quantity"] == DBNull.Value ? 0 : (decimal)dread["Quantity"];
                        SetForeColor(clcQuantity, System.Drawing.Color.Black);

                        txtPosMask.Text = ALTONIKA.Tools.IsNull(dread["PosMaskCalc"].ToString(), string.Empty).ToString();
                        SetForeColor(txtPosMask, System.Drawing.Color.Black);

                        txtRepDescript.Text = ALTONIKA.Tools.IsNull(dread["RepDescript"].ToString(), string.Empty).ToString();
                        SetForeColor(txtRepDescript, System.Drawing.Color.Black);

                        txtPMSign.Text = ALTONIKA.Tools.IsNull(dread["PMSign"].ToString(), string.Empty).ToString();
                        SetForeColor(txtPMSign, System.Drawing.Color.Black);


                        txtRemark.Text = ALTONIKA.Tools.IsNull(dread["Note"].ToString(), string.Empty).ToString();
                        SetForeColor(txtRemark, System.Drawing.Color.Black);


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
               


                txtRepDescript.Text = "нет";
                txtPosMask.Text = string.Empty;
                clcQuantity.Value = 0;
                txtRemark.Text = String.Empty;
               


            }
            catch (Exception E)
            {
                ErrorMessage.Ex = E;
                ErrorMessage.ShowDialog();
            }

        }


        [ALTONIKA.SQLCommandDescript(System.Data.CommandType.StoredProcedure, "stpSpecificationUpdate", "редактирование")]
        private int DataModify()
        {

            int _returnValue = -255;
            try
            {




                ///*должны быть заполнены*/
                // if (txtTabN.Text == string.Empty) { return 1; }


                SqlCommand cmd = new SqlCommand();
                cmd.Connection = _SqlConn;
                cmd.CommandText = "stpSpecificationUpdate";
                cmd.CommandType = CommandType.StoredProcedure;


                SqlParameter prm;

                /*Возвращаемый параметр*/
                prm = new SqlParameter();
                prm.ParameterName = "@RETURN_VALUE";
                prm.Direction = ParameterDirection.ReturnValue;
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = DBNull.Value;
                cmd.Parameters.Add(prm);

                /*@SpecID*/
                prm = new SqlParameter();
                prm.ParameterName = "@SpecID";
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = _KeyFieldValue;
                cmd.Parameters.Add(prm);


                /*@Quantity*/
                prm = new SqlParameter();
                prm.ParameterName = "@Quantity";
                prm.SqlDbType = SqlDbType.Decimal;
                prm.Value = Decimal.Parse(clcQuantity.EditValue.ToString());
                cmd.Parameters.Add(prm);


                /*@PosMask*/
                prm = new SqlParameter();
                prm.ParameterName = "@PosMask";
                prm.SqlDbType = SqlDbType.VarChar;
                prm.Value = txtPosMask.Text;
                cmd.Parameters.Add(prm);


                /*@RepDescript */
                prm = new SqlParameter();
                prm.ParameterName = "@RepDescript ";
                prm.SqlDbType = SqlDbType.VarChar;
                prm.Value = txtRepDescript.Text;
                cmd.Parameters.Add(prm);


                ///*@SPID*/
                //prm = new SqlParameter();
                //prm.ParameterName = "@SPID";
                //prm.SqlDbType = SqlDbType.Int;
                //prm.Value = _SPID;
                //cmd.Parameters.Add(prm);



                /*@Note*/
                prm = new SqlParameter();
                prm.ParameterName = "@Note";
                prm.SqlDbType = SqlDbType.VarChar;
                prm.Value = txtRemark.Text;
                cmd.Parameters.Add(prm);



                cmd.ExecuteNonQuery();
                _returnValue = Convert.ToInt32(cmd.Parameters["@RETURN_VALUE"].Value);


                switch (_returnValue)
                {
                    case 1:

                        MessageBox.Show("Комплект находится в комплектовании. Редактирование невозможно.", "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return _returnValue;
                    case 2:
                        MessageBox.Show("Редактирование спецификации комплекта со статусом В производстве запрещено", "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return _returnValue;
                    case 3:
                        MessageBox.Show("Ошибка при добавлении записи в архивную таблицу внутри транзакции!", "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return _returnValue;
                    case 4:
                        MessageBox.Show("Ошибка при изменении записи в основной таблице внутри транзакции! Обратитесь к разработчикам!", "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return _returnValue;
                    case 0:
                        return _returnValue;

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

        [ALTONIKA.SQLCommandDescript(System.Data.CommandType.StoredProcedure, "stpSpecificationOneRowDelete", "удаление")]
        private int RecordDelete()
        {

            int _returnValue = -255;
            try
            {




                ///*должны быть заполнены*/
                // if (txtTabN.Text == string.Empty) { return 1; }


                SqlCommand cmd = new SqlCommand();
                cmd.Connection = _SqlConn;
                cmd.CommandText = "stpSpecificationOneRowDelete";
                cmd.CommandType = CommandType.StoredProcedure;


                SqlParameter prm;

                /*Возвращаемый параметр*/
                prm = new SqlParameter();
                prm.ParameterName = "@RETURN_VALUE";
                prm.Direction = ParameterDirection.ReturnValue;
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = DBNull.Value;
                cmd.Parameters.Add(prm);

                /*@TPID*/
                prm = new SqlParameter();
                prm.ParameterName = "@SpecID";
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = _KeyFieldValue;
                cmd.Parameters.Add(prm);
            


                cmd.ExecuteNonQuery();
                _returnValue = Convert.ToInt32(cmd.Parameters["@RETURN_VALUE"].Value);


                if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isDeleting)
                {
                    switch (_returnValue)
                    {
                        case 1:
                            MessageBox.Show("Нельзя удалить элемент из спецификации, так как комплект находится в процессе комплектования", "Спецификация: удаление записи", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            return _returnValue;
                        case 2:
                            MessageBox.Show("Редактирование спецификации комплекта со статусом [В производстве] запрещено", "Спецификация: удаление записи", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            return _returnValue;
                        case 3:
                            MessageBox.Show("Нельзя удалить элемент из спецификации, так как по нему есть долг", "Спецификация: удаление записи", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            return _returnValue;
                        case 4:
                            MessageBox.Show("Ошибка в хранимой процедуре", "Спецификация: добавление в архив", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            return _returnValue;
                        case 5:
                            MessageBox.Show("Ошибка в хранимой процедуре", "Спецификация: удаление записи позиционного обозначения", MessageBoxButtons.OK, MessageBoxIcon.Error);
                            return _returnValue;

                        case 6:
                            MessageBox.Show("Ошибка в хранимой процедуре", "Спецификация: удаление записи спецификации", MessageBoxButtons.OK, MessageBoxIcon.Error);
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
                //if (lkpOper.ItemIndex == -1) return;
              
                //clcQTY.Value = (int)lkpKeeObj.Properties.GetDataSourceValue("QTY", lkpKeeObj.ItemIndex);
            }
            catch (Exception E)
            {
                ErrorMessage.Ex = E;
                ErrorMessage.ShowDialog();
            }
        }

        private void lkpOper_EditValueChanged(object sender, EventArgs e)
        {
            try
            {
                //if (lkpOper.ItemIndex == -1)
                //{
                //    txtTechSectorName.Text = string.Empty;
                //    return;
                //}
           
                //txtTechSectorName.Text = lkpOper.Properties.GetDataSourceValue("TechSectorName", lkpOper.ItemIndex).ToString();
                SetControlForeColor(sender, e);
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





    }
}
