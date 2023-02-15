using System;

namespace Spec
{


    #region Для форм редактирования записей. Описывает два события: событие сохранения записи и событие отмены.


    /// <summary>
    /// 
    /// </summary>
    public class SaveButtonClickEventArgs : EventArgs
    {

        
        /// <summary>
        /// 
        /// </summary>
        public SaveButtonClickEventArgs()
        {

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


        private int _keyFieldNewValue = 0;
        public int KeyFieldNewValue
        {
            set
            {
                _keyFieldNewValue = value;
            }
            get
            {
                return _keyFieldNewValue;
            }

        }
    }







    /// <summary>
    /// 
    /// </summary>
    public delegate void SaveButtonClickEventHandler(object sender, SaveButtonClickEventArgs e);



    /// <summary>
    /// 
    /// </summary>
    public class CancelButtonClickEventArgs : EventArgs
    {

        
        /// <summary>
        /// 
        /// </summary>
        public CancelButtonClickEventArgs()
        {

        }

    }

    /// <summary>
    /// 
    /// </summary>
    public delegate void CancelButtonClickEventHandler(object sender, CancelButtonClickEventArgs e);




    #endregion



}
