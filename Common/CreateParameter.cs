using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System;
using System.Data;
using System.Data.SqlClient;

namespace Spec
{

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
                    case SqlDbType.Int:
                        Par.Value = Convert.ToInt32(Value);
                        break;
                    case SqlDbType.Money:
                        Par.Value = Value;
                        break;
                    case SqlDbType.SmallInt:
                        Par.Value = Convert.ToInt16(Value);
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
}
