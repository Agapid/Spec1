namespace Spec
{
    partial class AXReportView
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.axCRV = new CrystalDecisions.Windows.Forms.CrystalReportViewer();
            this.reportDoc = new CrystalDecisions.CrystalReports.Engine.ReportDocument();
            this.SuspendLayout();
            // 
            // axCRV
            // 
            this.axCRV.ActiveViewIndex = -1;
            this.axCRV.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.axCRV.Cursor = System.Windows.Forms.Cursors.Default;
            this.axCRV.Dock = System.Windows.Forms.DockStyle.Fill;
            this.axCRV.Location = new System.Drawing.Point(0, 0);
            this.axCRV.Name = "axCRV";
            this.axCRV.ShowRefreshButton = false;
            this.axCRV.Size = new System.Drawing.Size(992, 714);
            this.axCRV.TabIndex = 0;
            this.axCRV.ReportRefresh += new CrystalDecisions.Windows.Forms.RefreshEventHandler(this.axCRV_ReportRefresh);
            this.axCRV.Load += new System.EventHandler(this.axCRV_Load);
            // 
            // AXReportView
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(992, 714);
            this.Controls.Add(this.axCRV);
            this.Name = "AXReportView";
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.Load += new System.EventHandler(this.AXReportView_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private CrystalDecisions.Windows.Forms.CrystalReportViewer axCRV;
        private CrystalDecisions.CrystalReports.Engine.ReportDocument reportDoc;
    }
}