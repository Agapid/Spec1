using System;
using System.Windows;
using System.Windows.Forms;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Spec
{


    public class OldNewRecordCompare
    {

        #region Свойства

        string _FirmName = string.Empty;
        string _ProductName = string.Empty;
        string _OperName = string.Empty;
        string _TechSectorName = string.Empty;


        string _TPLName_old = string.Empty;
        string _PreparTime_old = string.Empty;
        string _BasicTime_old = string.Empty;
        string _flgBasic_old = string.Empty;
        string _Factor_old = string.Empty;
        string _DateBAccount_old = string.Empty;
        string _Remark_old = string.Empty;


        string _TPLName_new = string.Empty;
        string _PreparTime_new = string.Empty;
        string _BasicTime_new = string.Empty;
        string _flgBasic_new = string.Empty;
        string _Factor_new = string.Empty;
        string _DateBAccount_new = string.Empty;
        string _Remark_new = string.Empty;



        public string FirmName
        {
            get
            {
                return _FirmName;
            }
            set
            {
                _FirmName = value;
            }
        }



        public string ProductName
        {
            get
            {
                return _ProductName;
            }
            set
            {
                _ProductName = value;
            }
        }

        public string OperName
        {
            get
            {
                return _OperName;
            }
            set
            {
                _OperName = value;
            }
        }
        public string TechSectorName
        {
            get
            {
                return _TechSectorName;
            }
            set
            {
                _TechSectorName = value;
            }
        }
        public string TPLName_old
        {
            get
            {
                return _TPLName_old;
            }
            set
            {
                _TPLName_old = value;
            }
        }
        public string PreparTime_old
        {
            get
            {
                return _PreparTime_old;
            }
            set
            {
                _PreparTime_old = value;
            }
        }
        public string BasicTime_old
        {
            get
            {
                return _BasicTime_old;
            }
            set
            {
                _BasicTime_old = value;
            }
        }
        public string flgBasic_old
        {
            get
            {
                return _flgBasic_old;
            }
            set
            {
                _flgBasic_old = value;
            }
        }
        public string Factor_old
        {
            get
            {
                return _Factor_old;
            }
            set
            {
                _Factor_old = value;
            }
        }
        public string DateBAccount_old
        {
            get
            {
                return _DateBAccount_old;
            }
            set
            {
                _DateBAccount_old = value;
            }
        }

        public string Remark_old
        {
            get
            {
                return _Remark_old;
            }
            set
            {
                _Remark_old = value;
            }
        }

        public string TPLName_new
        {
            get
            {
                return _TPLName_new;
            }
            set
            {
                _TPLName_new = value;
            }
        }
        public string PreparTime_new
        {
            get
            {
                return _PreparTime_new;
            }
            set
            {
                _PreparTime_new = value;
            }
        }
        public string BasicTime_new
        {
            get
            {
                return _BasicTime_new;
            }
            set
            {
                _BasicTime_new = value;
            }
        }
        public string flgBasic_new
        {
            get
            {
                return _flgBasic_new;
            }
            set
            {
                _flgBasic_new = value;
            }
        }
        public string Factor_new
        {
            get
            {
                return _Factor_new;
            }
            set
            {
                _Factor_new = value;
            }
        }
        public string DateBAccount_new
        {
            get
            {
                return _DateBAccount_new;
            }
            set
            {
                _DateBAccount_new = value;
            }
        }
        public string Remark_new
        {
            get
            {
                return _Remark_new;
            }
            set
            {
                _Remark_new = value;
            }
        }
        #endregion



        public string GetCompareString()
        {
            string retValue = string.Empty;




            retValue = "Изделие: " + _ProductName + "\r\n";
            retValue += "Операция: " + _OperName + "\r\n";
            retValue += "Участок: " + _TechSectorName + "\r\n";
            retValue += "Оборудование: " + _TPLName_old + "\r\n" + "\r\n" + "\r\n";



            if (_TPLName_old != _TPLName_new)
            {
                retValue += "Оборудование было:  " + _TPLName_old + "\r\n";
                retValue += "Оборудование стало:  " + _TPLName_new + "\r\n";

            }

            if (_PreparTime_old != _PreparTime_new)
            {
                retValue += "Подготовительное время было:  " + _PreparTime_old + "\r\n";
                retValue += "Подготовительное время стало:  " + _PreparTime_new + "\r\n";

            }

            if (_BasicTime_old != _BasicTime_new)
            {
                retValue += "Основное время было:  " + _BasicTime_old + "\r\n";
                retValue += "Основное время стало:  " + _BasicTime_new + "\r\n";

            }

            if (_flgBasic_old == "1" && _flgBasic_new == "0")
            {
                retValue += "Оборудование перестало быть основным  " + "\r\n";
            }

            if (_flgBasic_old == "0" && _flgBasic_new == "1")
            {
                retValue += "Оборудование стало основным  " + "\r\n";
            }


            if (_Factor_old != _Factor_new)
            {
                retValue += "Коэффициент было:  " + _Factor_old + "\r\n";
                retValue += "Коэффициент стало:  " + _Factor_new + "\r\n";

            }


            if (_Remark_old != _Remark_new)
            {
                retValue += "Примечание было:  " + _Remark_old + "\r\n";
                retValue += "Примечание стало:  " + _Remark_new + "\r\n";

            }



            if (DateBAccount_old != DateBAccount_new)
            {
                retValue += "Дата начала учета было:  " + DateBAccount_old + "\r\n";
                retValue += "Дата начала учета стало:  " + DateBAccount_new + "\r\n";

            }

            

            return retValue;

        }


    }





}
