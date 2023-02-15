using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace Spec
{
    static class Program
    {
        /// <summary>
        /// Главная точка входа для приложения.
        /// </summary>
        [STAThread]
        static void Main()
        {





            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            


            try
            {

                //Trusted
                var connectionString = ConfigurationManager.ConnectionStrings["A3ConnectionString"].ConnectionString;
                               //Благочиннов
                //var connectionString = ConfigurationManager.ConnectionStrings["A3ConnectionString_BL"].ConnectionString;

                //Бурцев
                //var connectionString = ConfigurationManager.ConnectionStrings["A3ConnectionString_BU"].ConnectionString;
                


                //string connectionString = "Server=MARS; Database=Budget; Trusted_Connection=True";


                SqlConnection cnn = new SqlConnection(connectionString);
                cnn.Open();
                Application.EnableVisualStyles();
                Application.SetCompatibleTextRenderingDefault(false);




                //fTechExecOperationsView f = new fTechExecOperationsView();
                fSpecView f = new fSpecView();
                //fChartTest f = new fChartTest();
                //fPLMParamsModify f = new fPLMParamsModify();
                //fTechOperView f = new fTechOperView();
                //fFromExcel1 f = new fFromExcel1();
               
                
                f.SqlConn = cnn;

                Application.Run(f);


            }

            catch (ArgumentNullException ane)
            {

                MessageBox.Show(ane.Message, " Main-ArgumentNullException");

            }

            catch (FormatException fex)
            {

                MessageBox.Show(fex.Message, " Main-FormatException");

            }

            catch (NullReferenceException nre)
            {

                MessageBox.Show(nre.Message, " Main-NullReferenceException");

            }

            catch (InvalidCastException ice)
            {

                MessageBox.Show(ice.Message, " Main-InvalidCastException");

            }

            catch (Exception ex)
            {

                MessageBox.Show(ex.Message, " o Main");

            }

        }
    }
}
