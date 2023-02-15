using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Windows.Forms;
using System.Data;
using System.Data.SqlClient;
using ALTONIKA;

namespace Spec
{

    public partial class fPosMaskMake : Form, ALTONIKA.IEditForm
    {

        public OldNewRecordCompare cmpr = new OldNewRecordCompare();
        #region Declare sections

        private int _Mode = 0;


        
        
        ALTONIKA.fErrorMessage ErrorMessage = new ALTONIKA.fErrorMessage();



        





        #endregion


        #region Initialization sections
        public fPosMaskMake()
        {
            InitializeComponent();
        }
        #endregion


        #region Events sections

        private void fModify_Load(object sender, EventArgs e)
        {
            try
            {

                
                FillAll();
                ErrorMessage.FormError = this;
                ErrorMessage.SQLConnection = _SqlConn;

            }
            catch (Exception E)
            {
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (" + this.Name + ")", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

        }

        private void btnCancel_Click(object sender, EventArgs e)
        {

            ExitForm();

        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            try
            {

                /*Добавление новой зааписи*/
                if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isInserting)
                {
                    DataInsert();

                }



                /*Редактирование записи*/
                if (_State == ALTONIKA.DataBar.DataBarCurrentStateEnum.isUpdating)
                {
                    DataUpdate();

                }

               
            }

            catch (Exception E)
            {
                ErrorMessage.Ex = E;
                ErrorMessage.ShowDialog();

            }



        }

        private void btnDel_Click(object sender, EventArgs e)
        {
            int i = RecordDelete();

            switch (i)
            {

                case 0:
                    {
                        /*генерируем событие клика по соответствующей кнопке на тулбаре (для наружнего подписчика, если он есть)*/
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

        private void fDefectCardModify_Activated(object sender, EventArgs e)
        {
            txtPosMask.Focus();
            txtPosMask.SelectAll();

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
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (" + this.Name + ")", MessageBoxButtons.OK, MessageBoxIcon.Error);
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
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (" + this.Name + ")", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        /// <summary>
        /// Общее заполнение люкапов и таблиц с данными
        /// </summary>
        private void FillAll()
        {
            try
            {
              

     

                //Заполнение текстовых полей
                SetButtonsStatus();
                TextFill();

            }
            catch (Exception E)
            {
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (" + this.Name + ")", MessageBoxButtons.OK, MessageBoxIcon.Error);
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

        [ALTONIKA.SQLCommandDescript(System.Data.CommandType.StoredProcedure, "stpSpecPosMaskRowSelect", "Заполнение popup формы редактирования")]
        public void TextFill()
        {
            try
            {

                Cursor.Current = Cursors.WaitCursor;

               

                SqlCommand cmd = new SqlCommand();
                cmd.Connection = _SqlConn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "stpSpecPosMaskRowSelect";

                SqlParameter prm = new SqlParameter();
                prm.SqlDbType = SqlDbType.Int;
                prm.ParameterName = "@RecordID";
                prm.Value = _SPMID;

                //if (_KeyFieldValue == null)
                //{
                //    prm.Value = 0;
                //}
                //else
                //{
                //    prm.Value = _KeyFieldValue;
                //}


                cmd.Parameters.Add(prm);
                SqlDataReader dread = cmd.ExecuteReader();

                if (dread.HasRows)
                {
                    while (dread.Read())
                    {



                        txtPosMask.Text = dread["PosMask"].ToString();
                        SetForeColor(txtPosMask, System.Drawing.Color.Black);
                      

                      
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
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (" + this.Name + ")", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

        }


        private void TextClear()
        {
            try
            {

                txtPosMask.Text = string.Empty;
                
               



            }
            catch (Exception E)
            {
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (" + this.Name + ")", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

        }


        [ALTONIKA.SQLCommandDescript(System.Data.CommandType.StoredProcedure, "stpSpecificationPosMaskOneRowDelete", "удаление")]
        private int RecordDelete()
        {

            int _returnValue = -255;
            try
            {




                ///*должны быть заполнены*/
                // if (txtTabN.Text == string.Empty) { return 1; }


                SqlCommand cmd = new SqlCommand();
                cmd.Connection = _SqlConn;
                cmd.CommandText = "stpSpecificationPosMaskOneRowDelete";
                cmd.CommandType = CommandType.StoredProcedure;


                SqlParameter prm;

                /*Возвращаемый параметр*/
                prm = new SqlParameter();
                prm.ParameterName = "@RETURN_VALUE";
                prm.Direction = ParameterDirection.ReturnValue;
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = DBNull.Value;
                cmd.Parameters.Add(prm);

                /*@SPMID*/
                prm = new SqlParameter();
                prm.ParameterName = "@SPMID";
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
        private void DataInsert()
        {

            int _returnValue = -255;
            try
            {


                if (txtPosMask.Text.Trim() == string.Empty)
                {
                    MessageBox.Show("Позиционное обозначение не указано", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                /*Сделать проверки: первый символ должен быть цифрой, проверить на наличие киррилицы*/

       


                SqlCommand cmd = new SqlCommand();
                cmd.Connection = _SqlConn;
                cmd.CommandText = "stpSpecificationPosMaskInsert";
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter prm;

                /*Возвращаемый параметр*/
                prm = new SqlParameter();
                prm.ParameterName = "@RETURN_VALUE";
                prm.Direction = ParameterDirection.ReturnValue;
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = 0;
                cmd.Parameters.Add(prm);

              


                /*@SpecID*/
                prm = new SqlParameter();
                prm.ParameterName = "@SpecID";
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = _SpecID;
                cmd.Parameters.Add(prm);



                
                /*@PosMask*/
                prm = new SqlParameter();
                prm.ParameterName = "@PosMask";
                prm.SqlDbType = SqlDbType.VarChar;
                prm.Size = 10;
                prm.Value = txtPosMask.Text;
                cmd.Parameters.Add(prm);




              
                cmd.ExecuteNonQuery();
                _returnValue = Convert.ToInt32(cmd.Parameters["@RETURN_VALUE"].Value);



                switch (_returnValue)
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
                            MessageBox.Show("Для данного комплекта уже есть такое позиционное обозначение (первая проверка). Операция прервана.", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            break;
                        }

                    case 2:
                        {
                            MessageBox.Show("Редактирование спецификации комплекта со статусом 'В производстве' запрещено!. Операция прервана.", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            break;
                        }

                    case 3:
                        {
                            MessageBox.Show("Для данного элемента нужно указать позиционное обозначение. Операция прервана.", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            break;
                        }

                    case 4:
                        {
                            MessageBox.Show("Позиционное обозначение должно начинаться с цифры. Операция прервана.", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            break;
                        }

                    case 5:
                        {
                            MessageBox.Show("Позиционное обозначение должно содержать в себе цифры и латинские буквы. Операция прервана.", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            break;
                        }

                    case 6:
                        {
                            MessageBox.Show("Для данного комплекта уже есть такое позиционное обозначение (вторая проверка). Операция прервана.", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            break;
                        }



                    default:
                        {
                            this.DialogResult = DialogResult.Cancel;
                            break;
                        }

                }

              
            }
            catch (Exception E)
            {
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (" + this.Name + ")", MessageBoxButtons.OK, MessageBoxIcon.Error);
              
            }
        }


        private void DataUpdate()
        {

            int _returnValue = -255;
            try
            {


                if (txtPosMask.Text.Trim() == string.Empty)
                {
                    MessageBox.Show("Позиционное обозначение не указано", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                /*Сделать проверки: первый символ должен быть цифрой, проверить на наличие киррилицы*/




                SqlCommand cmd = new SqlCommand();
                cmd.Connection = _SqlConn;
                cmd.CommandText = "stpSpecificationPosMaskUpdate";
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter prm;

                /*Возвращаемый параметр*/
                prm = new SqlParameter();
                prm.ParameterName = "@RETURN_VALUE";
                prm.Direction = ParameterDirection.ReturnValue;
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = 0;
                cmd.Parameters.Add(prm);




                /*@SPMID*/
                prm = new SqlParameter();
                prm.ParameterName = "@SPMID";
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = _KeyFieldValue;
                cmd.Parameters.Add(prm);


                /*@SpecID*/
                prm = new SqlParameter();
                prm.ParameterName = "@SpecID";
                prm.SqlDbType = SqlDbType.Int;
                prm.Value = _SpecID;
                cmd.Parameters.Add(prm);




                /*@PosMask*/
                prm = new SqlParameter();
                prm.ParameterName = "@PosMask";
                prm.SqlDbType = SqlDbType.VarChar;
                prm.Size = 10;
                prm.Value = txtPosMask.Text;
                cmd.Parameters.Add(prm);



              


                cmd.ExecuteNonQuery();
                _returnValue = Convert.ToInt32(cmd.Parameters["@RETURN_VALUE"].Value);



                switch (_returnValue)
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
                            MessageBox.Show("Для данного комплекта уже есть такое позиционное обозначение (первая проверка). Операция прервана.", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            break;
                        }

                    case 2:
                        {
                            MessageBox.Show("Редактирование спецификации комплекта со статусом 'В производстве' запрещено!. Операция прервана.", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            break;
                        }

                    case 3:
                        {
                            MessageBox.Show("Для данного элемента нужно указать позиционное обозначение. Операция прервана.", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            break;
                        }

                    case 4:
                        {
                            MessageBox.Show("Позиционное обозначение должно начинаться с цифры. Операция прервана.", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            break;
                        }

                    case 5:
                        {
                            MessageBox.Show("Позиционное обозначение должно содержать в себе цифры и латинские буквы. Операция прервана.", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            break;
                        }

                    case 6:
                        {
                            MessageBox.Show("Для данного комплекта уже есть такое позиционное обозначение (вторая проверка). Операция прервана.", "Внимание", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                            break;
                        }



                    default:
                        {
                            this.DialogResult = DialogResult.Cancel;
                            break;
                        }

                }


            }
            catch (Exception E)
            {
                MessageBox.Show(E.Message.ToString(), "Источник: " + E.TargetSite.Name + " (" + this.Name + ")", MessageBoxButtons.OK, MessageBoxIcon.Error);

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


        private DataTable GetEmailAddress()
        {
            DataTable dtResult = new DataTable();
            try
            {


                SqlCommand cmd = new SqlCommand();
                cmd.Connection = _SqlConn;
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.CommandText = "stpTechPathGetData";

                SqlParameter prm = new SqlParameter();
                prm.SqlDbType = SqlDbType.Int;
                prm.ParameterName = "@Switch";
                prm.Value = 12;

                cmd.Parameters.Add(prm);
                SqlDataAdapter ad = new SqlDataAdapter(cmd);
                ad.Fill(dtResult);
               



                return dtResult;
            }

            catch (SqlException e)
            {
                MessageBox.Show("Произошла ошибка при обращении к серверу! Обратитесь к разработчикам! " + e.Message, "PLM", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return dtResult;
               
            }

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

      //  вот это найти в новой версии моего Бара и либо перемновать, либо как-то улучшить
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
        /// SPMID
        /// </summary>
        object _SPMID;
        public object SPMID
        {
            get
            {
                return _SPMID;
            }
            set
            {
                _SPMID = value;
            }
        }

        /// <summary>
        /// SpecID
        /// </summary>
        object _SpecID;
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
        /// TPID
        /// </summary>
        object _TPID;
        public object TPID
        {
            get
            {
                return _TPID;
            }
            set
            {
                _TPID = value;
            }
        }

        /// <summary>
        /// TSOID
        /// </summary>
        object _TSOID;
        public object TSOID
        {
            get
            {
                return _TSOID;
            }
            set
            {
                _TSOID = value;
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

       



    }
}
