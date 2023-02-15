using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PLM
{
    /// <summary>
    /// Summary description for Encryption.
    /// </summary>
    public class Encryption
    {
        /// <summary>
        /// Процедура кодирует строковое значение.
        /// </summary>
        /// <param name="Str">Значение, которое нужно закодировать.</param>
        /// <param name="flgAscii">Если было закодированно с использованием ASCII, то ставим true, иначе false.</param>
        /// <returns></returns>
        public string Encode(string Str, bool flgAscii)
        {
            string EncodeStr = "";
            if (flgAscii)
            {
                for (int i = 0; i < Str.Length; i++)
                {
                    if (Convert.ToInt16(((byte[])System.Text.ASCIIEncoding.ASCII.GetBytes(Str.Substring(i, 1))).GetValue(0)) < 10)
                        EncodeStr = EncodeStr + "00" + ((byte[])System.Text.ASCIIEncoding.ASCII.GetBytes(Str.Substring(i, 1))).GetValue(0).ToString();
                    if (Convert.ToInt16(((byte[])System.Text.ASCIIEncoding.ASCII.GetBytes(Str.Substring(i, 1))).GetValue(0)) < 100 && Convert.ToInt16(((byte[])System.Text.ASCIIEncoding.ASCII.GetBytes(Str.Substring(i, 1))).GetValue(0)) >= 10)
                        EncodeStr = EncodeStr + "0" + ((byte[])System.Text.ASCIIEncoding.ASCII.GetBytes(Str.Substring(i, 1))).GetValue(0).ToString();
                    if (Convert.ToInt16(((byte[])System.Text.ASCIIEncoding.ASCII.GetBytes(Str.Substring(i, 1))).GetValue(0)) >= 100)
                        EncodeStr = EncodeStr + ((byte[])System.Text.ASCIIEncoding.ASCII.GetBytes(Str.Substring(i, 1))).GetValue(0).ToString();
                }
            }
            else
            {
                foreach (char ch in Str)
                {
                    string Zero = Convert.ToInt16(ch) < 10 ? "000" : (Convert.ToInt16(ch) > 10 && Convert.ToInt16(ch) < 100 ? "00" : (Convert.ToInt16(ch) >= 100 && Convert.ToInt16(ch) < 1000 ? "0" : ""));
                    EncodeStr = EncodeStr + Zero + (Convert.ToInt16(ch).ToString());
                }
                EncodeStr = "[]" + EncodeStr;
                Decode(EncodeStr, false);
            }

            return EncodeStr;
        }
        /// <summary>
        /// Процедура раскодирует строковое значение.
        /// </summary>
        /// <param name="Str">Значение, которое нужно раскодировать.</param>
        /// <param name="flgAscii">Если было закодированно с использованием ASCII, то ставим true, иначе false.</param>
        /// <returns></returns>
        public string Decode(string Str, bool flgAscii)
        {
            string DecodeStr = "";

            if (flgAscii)
            {
                int c = (int)(Str.Length / 3);
                byte[] sb = new byte[c];
                for (int i = 0; i < c; i++)
                {
                    sb.SetValue(Convert.ToByte(Str.Substring((int)(i * 3), 3)), i);
                }

                for (int i = 0; i < sb.Length; i++)
                {
                    DecodeStr = DecodeStr + ((char[])System.Text.ASCIIEncoding.ASCII.GetChars(sb)).GetValue(i).ToString();
                }
            }
            else
            {
                Str = Str.Substring(2);
                int c = (int)(Str.Length / 4);

                for (int i = 0; i < c; i++)
                {
                    DecodeStr = DecodeStr + Convert.ToChar(Convert.ToInt16(Str.Substring((int)(i * 4), 4))).ToString();
                }
            }

            return DecodeStr;
        }
    }
}

