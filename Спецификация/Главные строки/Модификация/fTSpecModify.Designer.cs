namespace Spec
{
    partial class fTSpecModify
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
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(fTSpecModify));
            DevExpress.XtraEditors.DXErrorProvider.ConditionValidationRule conditionValidationRule2 = new DevExpress.XtraEditors.DXErrorProvider.ConditionValidationRule();
            this.notifyIcon1 = new System.Windows.Forms.NotifyIcon(this.components);
            this.toolStrip1 = new System.Windows.Forms.ToolStrip();
            this.btnSave = new System.Windows.Forms.ToolStripButton();
            this.btnDel = new System.Windows.Forms.ToolStripButton();
            this.btnClear = new System.Windows.Forms.ToolStripButton();
            this.btnCancel = new System.Windows.Forms.ToolStripButton();
            this.img = new System.Windows.Forms.ImageList(this.components);
            this.styleController1 = new DevExpress.XtraEditors.StyleController(this.components);
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.lblInfo0 = new System.Windows.Forms.ToolStripStatusLabel();
            this.lblInfo = new System.Windows.Forms.ToolStripStatusLabel();
            this.btnDefaultExit = new System.Windows.Forms.Button();
            this.dxValidationProvider1 = new DevExpress.XtraEditors.DXErrorProvider.DXValidationProvider(this.components);
            this.txtRecordID = new DevExpress.XtraEditors.TextEdit();
            this.txtRemark = new DevExpress.XtraEditors.MemoEdit();
            this.labelControl7 = new DevExpress.XtraEditors.LabelControl();
            this.txtTechSectorName = new DevExpress.XtraEditors.LabelControl();
            this.txtComponentName = new DevExpress.XtraEditors.TextEdit();
            this.labelControl3 = new DevExpress.XtraEditors.LabelControl();
            this.clcQuantity = new DevExpress.XtraEditors.CalcEdit();
            this.txtPosMask = new DevExpress.XtraEditors.TextEdit();
            this.labelControl1 = new DevExpress.XtraEditors.LabelControl();
            this.txtRepDescript = new DevExpress.XtraEditors.TextEdit();
            this.labelControl5 = new DevExpress.XtraEditors.LabelControl();
            this.txtPMSign = new DevExpress.XtraEditors.TextEdit();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.toolStrip1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.styleController1)).BeginInit();
            this.statusStrip1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dxValidationProvider1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtRecordID.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtRemark.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtComponentName.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.clcQuantity.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtPosMask.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtRepDescript.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtPMSign.Properties)).BeginInit();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.SuspendLayout();
            // 
            // notifyIcon1
            // 
            this.notifyIcon1.Text = "notifyIcon1";
            this.notifyIcon1.Visible = true;
            // 
            // toolStrip1
            // 
            this.toolStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.btnSave,
            this.btnDel,
            this.btnClear,
            this.btnCancel});
            this.toolStrip1.Location = new System.Drawing.Point(0, 0);
            this.toolStrip1.Name = "toolStrip1";
            this.toolStrip1.Size = new System.Drawing.Size(779, 25);
            this.toolStrip1.TabIndex = 0;
            this.toolStrip1.Text = "toolStrip1";
            // 
            // btnSave
            // 
            this.btnSave.Image = ((System.Drawing.Image)(resources.GetObject("btnSave.Image")));
            this.btnSave.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(86, 22);
            this.btnSave.Text = "Сохранить";
            this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
            // 
            // btnDel
            // 
            this.btnDel.Image = ((System.Drawing.Image)(resources.GetObject("btnDel.Image")));
            this.btnDel.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnDel.Name = "btnDel";
            this.btnDel.Size = new System.Drawing.Size(71, 22);
            this.btnDel.Text = "Удалить";
            this.btnDel.Click += new System.EventHandler(this.btnDel_Click);
            // 
            // btnClear
            // 
            this.btnClear.Image = ((System.Drawing.Image)(resources.GetObject("btnClear.Image")));
            this.btnClear.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnClear.Name = "btnClear";
            this.btnClear.Size = new System.Drawing.Size(79, 22);
            this.btnClear.Text = "Очистить";
            this.btnClear.Click += new System.EventHandler(this.btnClear_Click);
            // 
            // btnCancel
            // 
            this.btnCancel.Image = ((System.Drawing.Image)(resources.GetObject("btnCancel.Image")));
            this.btnCancel.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(69, 22);
            this.btnCancel.Text = "Отмена";
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // img
            // 
            this.img.ImageStream = ((System.Windows.Forms.ImageListStreamer)(resources.GetObject("img.ImageStream")));
            this.img.TransparentColor = System.Drawing.Color.Transparent;
            this.img.Images.SetKeyName(0, "UPDATE.ICO");
            this.img.Images.SetKeyName(1, "DELETE.ICO");
            this.img.Images.SetKeyName(2, "Bin.ico");
            this.img.Images.SetKeyName(3, "CANCEL.ICO");
            // 
            // styleController1
            // 
            this.styleController1.ButtonsStyle = DevExpress.XtraEditors.Controls.BorderStyles.Office2003;
            this.styleController1.LookAndFeel.UseDefaultLookAndFeel = false;
            // 
            // statusStrip1
            // 
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.lblInfo0,
            this.lblInfo});
            this.statusStrip1.Location = new System.Drawing.Point(0, 334);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(779, 22);
            this.statusStrip1.TabIndex = 5;
            this.statusStrip1.Text = "statusStrip1";
            this.statusStrip1.ItemClicked += new System.Windows.Forms.ToolStripItemClickedEventHandler(this.statusStrip1_ItemClicked);
            // 
            // lblInfo0
            // 
            this.lblInfo0.Name = "lblInfo0";
            this.lblInfo0.Size = new System.Drawing.Size(0, 17);
            // 
            // lblInfo
            // 
            this.lblInfo.BackColor = System.Drawing.SystemColors.Control;
            this.lblInfo.Name = "lblInfo";
            this.lblInfo.Size = new System.Drawing.Size(0, 17);
            // 
            // btnDefaultExit
            // 
            this.btnDefaultExit.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.btnDefaultExit.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnDefaultExit.Location = new System.Drawing.Point(7, 346);
            this.btnDefaultExit.Name = "btnDefaultExit";
            this.btnDefaultExit.Size = new System.Drawing.Size(10, 10);
            this.btnDefaultExit.TabIndex = 6;
            this.btnDefaultExit.TabStop = false;
            this.btnDefaultExit.UseVisualStyleBackColor = true;
            this.btnDefaultExit.Click += new System.EventHandler(this.btnDefaultExit_Click);
            // 
            // txtRecordID
            // 
            this.txtRecordID.EnterMoveNextControl = true;
            this.txtRecordID.Location = new System.Drawing.Point(700, 5);
            this.txtRecordID.Name = "txtRecordID";
            this.txtRecordID.Properties.Appearance.BackColor = System.Drawing.SystemColors.Info;
            this.txtRecordID.Properties.Appearance.Options.UseBackColor = true;
            this.txtRecordID.Properties.ReadOnly = true;
            this.txtRecordID.Size = new System.Drawing.Size(66, 20);
            this.txtRecordID.StyleController = this.styleController1;
            this.txtRecordID.TabIndex = 0;
            this.txtRecordID.TabStop = false;
            conditionValidationRule2.ConditionOperator = DevExpress.XtraEditors.DXErrorProvider.ConditionOperator.IsBlank;
            conditionValidationRule2.ErrorText = "This value is not valid";
            conditionValidationRule2.ErrorType = DevExpress.XtraEditors.DXErrorProvider.ErrorType.Information;
            this.dxValidationProvider1.SetValidationRule(this.txtRecordID, conditionValidationRule2);
            // 
            // txtRemark
            // 
            this.txtRemark.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtRemark.EnterMoveNextControl = true;
            this.txtRemark.Location = new System.Drawing.Point(166, 143);
            this.txtRemark.Name = "txtRemark";
            this.txtRemark.Size = new System.Drawing.Size(588, 50);
            this.txtRemark.StyleController = this.styleController1;
            this.txtRemark.TabIndex = 3;
            this.txtRemark.EditValueChanged += new System.EventHandler(this.SetControlForeColor);
            this.txtRemark.Enter += new System.EventHandler(this.Control_Enter);
            // 
            // labelControl7
            // 
            this.labelControl7.Appearance.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.labelControl7.Appearance.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Far;
            this.labelControl7.AutoSizeMode = DevExpress.XtraEditors.LabelAutoSizeMode.None;
            this.labelControl7.Location = new System.Drawing.Point(20, 156);
            this.labelControl7.Name = "labelControl7";
            this.labelControl7.Size = new System.Drawing.Size(140, 19);
            this.labelControl7.TabIndex = 37;
            this.labelControl7.Text = "Примечание:";
            // 
            // txtTechSectorName
            // 
            this.txtTechSectorName.Location = new System.Drawing.Point(234, 17);
            this.txtTechSectorName.Name = "txtTechSectorName";
            this.txtTechSectorName.Size = new System.Drawing.Size(0, 13);
            this.txtTechSectorName.TabIndex = 87;
            // 
            // txtComponentName
            // 
            this.txtComponentName.EditValue = "n/a";
            this.txtComponentName.Location = new System.Drawing.Point(14, 24);
            this.txtComponentName.Name = "txtComponentName";
            this.txtComponentName.Properties.Appearance.BackColor = System.Drawing.SystemColors.MenuBar;
            this.txtComponentName.Properties.Appearance.Font = new System.Drawing.Font("Tahoma", 14.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.txtComponentName.Properties.Appearance.Options.UseBackColor = true;
            this.txtComponentName.Properties.Appearance.Options.UseFont = true;
            this.txtComponentName.Properties.Appearance.Options.UseTextOptions = true;
            this.txtComponentName.Properties.Appearance.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Center;
            this.txtComponentName.Properties.BorderStyle = DevExpress.XtraEditors.Controls.BorderStyles.NoBorder;
            this.txtComponentName.Properties.ReadOnly = true;
            this.txtComponentName.Size = new System.Drawing.Size(665, 28);
            this.txtComponentName.TabIndex = 0;
            this.txtComponentName.TabStop = false;
            // 
            // labelControl3
            // 
            this.labelControl3.Appearance.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.labelControl3.Appearance.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Far;
            this.labelControl3.AutoSizeMode = DevExpress.XtraEditors.LabelAutoSizeMode.None;
            this.labelControl3.Location = new System.Drawing.Point(-10, 33);
            this.labelControl3.Name = "labelControl3";
            this.labelControl3.Size = new System.Drawing.Size(170, 13);
            this.labelControl3.TabIndex = 91;
            this.labelControl3.Text = "Количество:";
            // 
            // clcQuantity
            // 
            this.clcQuantity.EnterMoveNextControl = true;
            this.clcQuantity.Location = new System.Drawing.Point(166, 26);
            this.clcQuantity.Name = "clcQuantity";
            this.clcQuantity.Properties.DisplayFormat.FormatString = "##0.####";
            this.clcQuantity.Properties.DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            this.clcQuantity.Properties.EditFormat.FormatString = "##0.####";
            this.clcQuantity.Properties.EditFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            this.clcQuantity.Properties.Mask.EditMask = "##0.####";
            this.clcQuantity.Size = new System.Drawing.Size(68, 20);
            this.clcQuantity.StyleController = this.styleController1;
            this.clcQuantity.TabIndex = 0;
            // 
            // txtPosMask
            // 
            this.txtPosMask.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtPosMask.EnterMoveNextControl = true;
            this.txtPosMask.Location = new System.Drawing.Point(166, 65);
            this.txtPosMask.Name = "txtPosMask";
            this.txtPosMask.Size = new System.Drawing.Size(588, 20);
            this.txtPosMask.TabIndex = 1;
            // 
            // labelControl1
            // 
            this.labelControl1.Appearance.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.labelControl1.Appearance.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Far;
            this.labelControl1.AutoSizeMode = DevExpress.XtraEditors.LabelAutoSizeMode.None;
            this.labelControl1.Location = new System.Drawing.Point(-1, 72);
            this.labelControl1.Name = "labelControl1";
            this.labelControl1.Size = new System.Drawing.Size(161, 13);
            this.labelControl1.TabIndex = 92;
            this.labelControl1.Text = "Позиционное обозначение:";
            // 
            // txtRepDescript
            // 
            this.txtRepDescript.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtRepDescript.EnterMoveNextControl = true;
            this.txtRepDescript.Location = new System.Drawing.Point(166, 106);
            this.txtRepDescript.Name = "txtRepDescript";
            this.txtRepDescript.Size = new System.Drawing.Size(588, 20);
            this.txtRepDescript.TabIndex = 2;
            // 
            // labelControl5
            // 
            this.labelControl5.Appearance.Font = new System.Drawing.Font("Tahoma", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.labelControl5.Appearance.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Far;
            this.labelControl5.AutoSizeMode = DevExpress.XtraEditors.LabelAutoSizeMode.None;
            this.labelControl5.Location = new System.Drawing.Point(-1, 113);
            this.labelControl5.Name = "labelControl5";
            this.labelControl5.Size = new System.Drawing.Size(161, 13);
            this.labelControl5.TabIndex = 94;
            this.labelControl5.Text = "Описание замены:";
            // 
            // txtPMSign
            // 
            this.txtPMSign.Location = new System.Drawing.Point(685, 24);
            this.txtPMSign.Name = "txtPMSign";
            this.txtPMSign.Properties.Appearance.BackColor = System.Drawing.SystemColors.MenuBar;
            this.txtPMSign.Properties.Appearance.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.txtPMSign.Properties.Appearance.Options.UseBackColor = true;
            this.txtPMSign.Properties.Appearance.Options.UseFont = true;
            this.txtPMSign.Properties.ReadOnly = true;
            this.txtPMSign.Size = new System.Drawing.Size(64, 26);
            this.txtPMSign.TabIndex = 4;
            this.txtPMSign.TabStop = false;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.txtPMSign);
            this.groupBox1.Controls.Add(this.txtComponentName);
            this.groupBox1.Location = new System.Drawing.Point(7, 31);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(760, 57);
            this.groupBox1.TabIndex = 98;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Элемент, вид элемента:";
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.txtRemark);
            this.groupBox2.Controls.Add(this.labelControl7);
            this.groupBox2.Controls.Add(this.txtRepDescript);
            this.groupBox2.Controls.Add(this.txtTechSectorName);
            this.groupBox2.Controls.Add(this.labelControl5);
            this.groupBox2.Controls.Add(this.clcQuantity);
            this.groupBox2.Controls.Add(this.txtPosMask);
            this.groupBox2.Controls.Add(this.labelControl3);
            this.groupBox2.Controls.Add(this.labelControl1);
            this.groupBox2.Location = new System.Drawing.Point(7, 103);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(760, 224);
            this.groupBox2.TabIndex = 99;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Редактируемые поля:";
            // 
            // fTSpecModify
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.MenuBar;
            this.CancelButton = this.btnDefaultExit;
            this.ClientSize = new System.Drawing.Size(779, 356);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.btnDefaultExit);
            this.Controls.Add(this.txtRecordID);
            this.Controls.Add(this.toolStrip1);
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "fTSpecModify";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Редактирование элемента спецификации";
            this.Activated += new System.EventHandler(this.fDefectCardModify_Activated);
            this.Load += new System.EventHandler(this.fModify_Load);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.fDefectCardModify_KeyDown);
            this.toolStrip1.ResumeLayout(false);
            this.toolStrip1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.styleController1)).EndInit();
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dxValidationProvider1)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtRecordID.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtRemark.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtComponentName.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.clcQuantity.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtPosMask.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtRepDescript.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtPMSign.Properties)).EndInit();
            this.groupBox1.ResumeLayout(false);
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.NotifyIcon notifyIcon1;
        private System.Windows.Forms.ToolStrip toolStrip1;
        private System.Windows.Forms.ToolStripButton btnSave;
        private System.Windows.Forms.ImageList img;
        private System.Windows.Forms.ToolStripButton btnDel;
        private System.Windows.Forms.ToolStripButton btnClear;
        private System.Windows.Forms.ToolStripButton btnCancel;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.ToolStripStatusLabel lblInfo;
        private System.Windows.Forms.Button btnDefaultExit;
        private System.Windows.Forms.ToolStripStatusLabel lblInfo0;
        private DevExpress.XtraEditors.StyleController styleController1;
        private DevExpress.XtraEditors.DXErrorProvider.DXValidationProvider dxValidationProvider1;
        private DevExpress.XtraEditors.TextEdit txtRecordID;
        private DevExpress.XtraEditors.MemoEdit txtRemark;
        private DevExpress.XtraEditors.LabelControl labelControl7;
        private DevExpress.XtraEditors.LabelControl txtTechSectorName;
        private DevExpress.XtraEditors.TextEdit txtComponentName;
        private DevExpress.XtraEditors.LabelControl labelControl3;
        private DevExpress.XtraEditors.CalcEdit clcQuantity;
        private DevExpress.XtraEditors.TextEdit txtPosMask;
        private DevExpress.XtraEditors.LabelControl labelControl1;
        private DevExpress.XtraEditors.TextEdit txtRepDescript;
        private DevExpress.XtraEditors.LabelControl labelControl5;
        private DevExpress.XtraEditors.TextEdit txtPMSign;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.GroupBox groupBox2;
    }
}