namespace Spec
{
    partial class fTSpecInsert
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(fTSpecInsert));
            DevExpress.XtraEditors.DXErrorProvider.ConditionValidationRule conditionValidationRule1 = new DevExpress.XtraEditors.DXErrorProvider.ConditionValidationRule();
            DevExpress.XtraGrid.StyleFormatCondition styleFormatCondition1 = new DevExpress.XtraGrid.StyleFormatCondition();
            DevExpress.XtraGrid.StyleFormatCondition styleFormatCondition2 = new DevExpress.XtraGrid.StyleFormatCondition();
            this.notifyIcon1 = new System.Windows.Forms.NotifyIcon(this.components);
            this.toolStrip1 = new System.Windows.Forms.ToolStrip();
            this.btnSave = new System.Windows.Forms.ToolStripButton();
            this.btnCancel = new System.Windows.Forms.ToolStripButton();
            this.img = new System.Windows.Forms.ImageList(this.components);
            this.styleController1 = new DevExpress.XtraEditors.StyleController(this.components);
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.lblInfo0 = new System.Windows.Forms.ToolStripStatusLabel();
            this.lblInfo = new System.Windows.Forms.ToolStripStatusLabel();
            this.btnDefaultExit = new System.Windows.Forms.Button();
            this.dxValidationProvider1 = new DevExpress.XtraEditors.DXErrorProvider.DXValidationProvider(this.components);
            this.txtRecordID = new DevExpress.XtraEditors.TextEdit();
            this.labelControl2 = new DevExpress.XtraEditors.LabelControl();
            this.txtRemark = new DevExpress.XtraEditors.MemoEdit();
            this.labelControl7 = new DevExpress.XtraEditors.LabelControl();
            this.txtTechSectorName = new DevExpress.XtraEditors.LabelControl();
            this.labelControl3 = new DevExpress.XtraEditors.LabelControl();
            this.clcQuantity = new DevExpress.XtraEditors.CalcEdit();
            this.txtRepDescript = new DevExpress.XtraEditors.TextEdit();
            this.labelControl5 = new DevExpress.XtraEditors.LabelControl();
            this.txtPMSign = new DevExpress.XtraEditors.TextEdit();
            this.labelControl6 = new DevExpress.XtraEditors.LabelControl();
            this.lkpComponent = new DevExpress.XtraEditors.SearchLookUpEdit();
            this.txtComponentID = new DevExpress.XtraEditors.TextEdit();
            this.labelControl1 = new DevExpress.XtraEditors.LabelControl();
            this.labelControl4 = new DevExpress.XtraEditors.LabelControl();
            this.txtElementID = new DevExpress.XtraEditors.TextEdit();
            this.labelControl8 = new DevExpress.XtraEditors.LabelControl();
            this.txtSPID = new DevExpress.XtraEditors.TextEdit();
            this.ViewSearch = new DevExpress.XtraGrid.Views.Grid.GridView();
            this.ComponentName = new DevExpress.XtraGrid.Columns.GridColumn();
            this.SectionName = new DevExpress.XtraGrid.Columns.GridColumn();
            this.PMSign = new DevExpress.XtraGrid.Columns.GridColumn();
            this.ElementID = new DevExpress.XtraGrid.Columns.GridColumn();
            this.ComponentID = new DevExpress.XtraGrid.Columns.GridColumn();
            this.SectionID = new DevExpress.XtraGrid.Columns.GridColumn();
            this.SPID = new DevExpress.XtraGrid.Columns.GridColumn();
            this.toolStrip1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.styleController1)).BeginInit();
            this.statusStrip1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.dxValidationProvider1)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtRecordID.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtRemark.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.clcQuantity.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtRepDescript.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtPMSign.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.lkpComponent.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtComponentID.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtElementID.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtSPID.Properties)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.ViewSearch)).BeginInit();
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
            this.btnCancel});
            this.toolStrip1.Location = new System.Drawing.Point(0, 0);
            this.toolStrip1.Name = "toolStrip1";
            this.toolStrip1.Size = new System.Drawing.Size(811, 25);
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
            this.statusStrip1.Location = new System.Drawing.Point(0, 341);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(811, 22);
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
            this.btnDefaultExit.Location = new System.Drawing.Point(7, 353);
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
            this.txtRecordID.Location = new System.Drawing.Point(9, 306);
            this.txtRecordID.Name = "txtRecordID";
            this.txtRecordID.Properties.Appearance.BackColor = System.Drawing.SystemColors.Info;
            this.txtRecordID.Properties.Appearance.Options.UseBackColor = true;
            this.txtRecordID.Properties.ReadOnly = true;
            this.txtRecordID.Size = new System.Drawing.Size(117, 20);
            this.txtRecordID.StyleController = this.styleController1;
            this.txtRecordID.TabIndex = 0;
            this.txtRecordID.TabStop = false;
            conditionValidationRule1.ConditionOperator = DevExpress.XtraEditors.DXErrorProvider.ConditionOperator.IsBlank;
            conditionValidationRule1.ErrorText = "This value is not valid";
            conditionValidationRule1.ErrorType = DevExpress.XtraEditors.DXErrorProvider.ErrorType.Information;
            this.dxValidationProvider1.SetValidationRule(this.txtRecordID, conditionValidationRule1);
            this.txtRecordID.Visible = false;
            // 
            // labelControl2
            // 
            this.labelControl2.Appearance.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Far;
            this.labelControl2.AutoSizeMode = DevExpress.XtraEditors.LabelAutoSizeMode.None;
            this.labelControl2.Location = new System.Drawing.Point(9, 45);
            this.labelControl2.Name = "labelControl2";
            this.labelControl2.Size = new System.Drawing.Size(139, 13);
            this.labelControl2.TabIndex = 4;
            this.labelControl2.Text = "Элемент:";
            // 
            // txtRemark
            // 
            this.txtRemark.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtRemark.EnterMoveNextControl = true;
            this.txtRemark.Location = new System.Drawing.Point(156, 198);
            this.txtRemark.Name = "txtRemark";
            this.txtRemark.Size = new System.Drawing.Size(643, 50);
            this.txtRemark.StyleController = this.styleController1;
            this.txtRemark.TabIndex = 4;
            this.txtRemark.EditValueChanged += new System.EventHandler(this.SetControlForeColor);
            this.txtRemark.Enter += new System.EventHandler(this.Control_Enter);
            // 
            // labelControl7
            // 
            this.labelControl7.Appearance.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Far;
            this.labelControl7.AutoSizeMode = DevExpress.XtraEditors.LabelAutoSizeMode.None;
            this.labelControl7.Location = new System.Drawing.Point(32, 211);
            this.labelControl7.Name = "labelControl7";
            this.labelControl7.Size = new System.Drawing.Size(117, 19);
            this.labelControl7.TabIndex = 37;
            this.labelControl7.Text = "Примечание:";
            // 
            // txtTechSectorName
            // 
            this.txtTechSectorName.Location = new System.Drawing.Point(554, 83);
            this.txtTechSectorName.Name = "txtTechSectorName";
            this.txtTechSectorName.Size = new System.Drawing.Size(0, 13);
            this.txtTechSectorName.TabIndex = 87;
            // 
            // labelControl3
            // 
            this.labelControl3.Appearance.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Far;
            this.labelControl3.AutoSizeMode = DevExpress.XtraEditors.LabelAutoSizeMode.None;
            this.labelControl3.Location = new System.Drawing.Point(3, 124);
            this.labelControl3.Name = "labelControl3";
            this.labelControl3.Size = new System.Drawing.Size(147, 13);
            this.labelControl3.TabIndex = 91;
            this.labelControl3.Text = "Количество элементов:";
            // 
            // clcQuantity
            // 
            this.clcQuantity.EditValue = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.clcQuantity.EnterMoveNextControl = true;
            this.clcQuantity.Location = new System.Drawing.Point(156, 117);
            this.clcQuantity.Name = "clcQuantity";
            this.clcQuantity.Properties.DisplayFormat.FormatString = "##0.####";
            this.clcQuantity.Properties.DisplayFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            this.clcQuantity.Properties.EditFormat.FormatString = "##0.####";
            this.clcQuantity.Properties.EditFormat.FormatType = DevExpress.Utils.FormatType.Numeric;
            this.clcQuantity.Properties.Mask.EditMask = "##0.####";
            this.clcQuantity.Size = new System.Drawing.Size(100, 20);
            this.clcQuantity.StyleController = this.styleController1;
            this.clcQuantity.TabIndex = 2;
            // 
            // txtRepDescript
            // 
            this.txtRepDescript.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.txtRepDescript.EditValue = "нет";
            this.txtRepDescript.EnterMoveNextControl = true;
            this.txtRepDescript.Location = new System.Drawing.Point(156, 156);
            this.txtRepDescript.Name = "txtRepDescript";
            this.txtRepDescript.Size = new System.Drawing.Size(643, 20);
            this.txtRepDescript.TabIndex = 3;
            // 
            // labelControl5
            // 
            this.labelControl5.Appearance.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Far;
            this.labelControl5.AutoSizeMode = DevExpress.XtraEditors.LabelAutoSizeMode.None;
            this.labelControl5.Location = new System.Drawing.Point(11, 163);
            this.labelControl5.Name = "labelControl5";
            this.labelControl5.Size = new System.Drawing.Size(139, 13);
            this.labelControl5.TabIndex = 94;
            this.labelControl5.Text = "Описание замены:";
            // 
            // txtPMSign
            // 
            this.txtPMSign.EnterMoveNextControl = true;
            this.txtPMSign.Location = new System.Drawing.Point(156, 80);
            this.txtPMSign.Name = "txtPMSign";
            this.txtPMSign.Size = new System.Drawing.Size(100, 20);
            this.txtPMSign.TabIndex = 1;
            // 
            // labelControl6
            // 
            this.labelControl6.Appearance.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Far;
            this.labelControl6.AutoSizeMode = DevExpress.XtraEditors.LabelAutoSizeMode.None;
            this.labelControl6.Location = new System.Drawing.Point(12, 87);
            this.labelControl6.Name = "labelControl6";
            this.labelControl6.Size = new System.Drawing.Size(139, 13);
            this.labelControl6.TabIndex = 96;
            this.labelControl6.Text = "Вид элемента:";
            // 
            // lkpComponent
            // 
            this.lkpComponent.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.lkpComponent.EditValue = "";
            this.lkpComponent.EnterMoveNextControl = true;
            this.lkpComponent.Location = new System.Drawing.Point(156, 36);
            this.lkpComponent.Name = "lkpComponent";
            this.lkpComponent.Properties.Appearance.Font = new System.Drawing.Font("Tahoma", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(204)));
            this.lkpComponent.Properties.Appearance.Options.UseFont = true;
            this.lkpComponent.Properties.BorderStyle = DevExpress.XtraEditors.Controls.BorderStyles.HotFlat;
            this.lkpComponent.Properties.Buttons.AddRange(new DevExpress.XtraEditors.Controls.EditorButton[] {
            new DevExpress.XtraEditors.Controls.EditorButton()});
            this.lkpComponent.Properties.DisplayMember = "ComponentName";
            this.lkpComponent.Properties.NullText = "";
            this.lkpComponent.Properties.PopupFilterMode = DevExpress.XtraEditors.PopupFilterMode.Contains;
            this.lkpComponent.Properties.ShowClearButton = false;
            this.lkpComponent.Properties.ValueMember = "ElementID";
            this.lkpComponent.Properties.View = this.ViewSearch;
            this.lkpComponent.Properties.ViewType = DevExpress.XtraEditors.Repository.GridLookUpViewType.GridView;
            this.lkpComponent.Size = new System.Drawing.Size(643, 28);
            this.lkpComponent.StyleController = this.styleController1;
            this.lkpComponent.TabIndex = 0;
            this.lkpComponent.QueryPopUp += new System.ComponentModel.CancelEventHandler(this.lkpComponent_QueryPopUp);
            // 
            // txtComponentID
            // 
            this.txtComponentID.EnterMoveNextControl = true;
            this.txtComponentID.Location = new System.Drawing.Point(317, 100);
            this.txtComponentID.Name = "txtComponentID";
            this.txtComponentID.Size = new System.Drawing.Size(100, 20);
            this.txtComponentID.TabIndex = 97;
            this.txtComponentID.Visible = false;
            // 
            // labelControl1
            // 
            this.labelControl1.Appearance.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Far;
            this.labelControl1.AutoSizeMode = DevExpress.XtraEditors.LabelAutoSizeMode.Horizontal;
            this.labelControl1.Location = new System.Drawing.Point(317, 87);
            this.labelControl1.Name = "labelControl1";
            this.labelControl1.Size = new System.Drawing.Size(66, 13);
            this.labelControl1.TabIndex = 98;
            this.labelControl1.Text = "ComponentID";
            this.labelControl1.Visible = false;
            // 
            // labelControl4
            // 
            this.labelControl4.Appearance.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Far;
            this.labelControl4.AutoSizeMode = DevExpress.XtraEditors.LabelAutoSizeMode.Horizontal;
            this.labelControl4.Location = new System.Drawing.Point(433, 87);
            this.labelControl4.Name = "labelControl4";
            this.labelControl4.Size = new System.Drawing.Size(49, 13);
            this.labelControl4.TabIndex = 100;
            this.labelControl4.Text = "ElementID";
            this.labelControl4.Visible = false;
            // 
            // txtElementID
            // 
            this.txtElementID.EnterMoveNextControl = true;
            this.txtElementID.Location = new System.Drawing.Point(433, 102);
            this.txtElementID.Name = "txtElementID";
            this.txtElementID.Size = new System.Drawing.Size(100, 20);
            this.txtElementID.TabIndex = 99;
            this.txtElementID.Visible = false;
            // 
            // labelControl8
            // 
            this.labelControl8.Appearance.TextOptions.HAlignment = DevExpress.Utils.HorzAlignment.Far;
            this.labelControl8.AutoSizeMode = DevExpress.XtraEditors.LabelAutoSizeMode.Horizontal;
            this.labelControl8.Location = new System.Drawing.Point(554, 87);
            this.labelControl8.Name = "labelControl8";
            this.labelControl8.Size = new System.Drawing.Size(23, 13);
            this.labelControl8.TabIndex = 102;
            this.labelControl8.Text = "SPID";
            this.labelControl8.Visible = false;
            // 
            // txtSPID
            // 
            this.txtSPID.EnterMoveNextControl = true;
            this.txtSPID.Location = new System.Drawing.Point(554, 102);
            this.txtSPID.Name = "txtSPID";
            this.txtSPID.Size = new System.Drawing.Size(100, 20);
            this.txtSPID.TabIndex = 101;
            this.txtSPID.Visible = false;
            // 
            // ViewSearch
            // 
            this.ViewSearch.Columns.AddRange(new DevExpress.XtraGrid.Columns.GridColumn[] {
            this.ComponentName,
            this.SectionName,
            this.PMSign,
            this.ElementID,
            this.ComponentID,
            this.SectionID,
            this.SPID});
            this.ViewSearch.FocusRectStyle = DevExpress.XtraGrid.Views.Grid.DrawFocusRectStyle.RowFocus;
            styleFormatCondition1.Appearance.ForeColor = System.Drawing.Color.Green;
            styleFormatCondition1.Appearance.Options.UseForeColor = true;
            styleFormatCondition1.Condition = DevExpress.XtraGrid.FormatConditionEnum.Expression;
            styleFormatCondition1.Expression = "[CompleteStatusValue] == 0";
            styleFormatCondition1.Value1 = 1;
            styleFormatCondition2.Appearance.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(64)))), ((int)(((byte)(0)))));
            styleFormatCondition2.Appearance.Options.UseForeColor = true;
            styleFormatCondition2.Condition = DevExpress.XtraGrid.FormatConditionEnum.Expression;
            styleFormatCondition2.Expression = "[CompleteStatusValue]  == 1";
            this.ViewSearch.FormatConditions.AddRange(new DevExpress.XtraGrid.StyleFormatCondition[] {
            styleFormatCondition1,
            styleFormatCondition2});
            this.ViewSearch.Name = "ViewSearch";
            this.ViewSearch.OptionsBehavior.AllowIncrementalSearch = true;
            this.ViewSearch.OptionsBehavior.Editable = false;
            this.ViewSearch.OptionsBehavior.ReadOnly = true;
            this.ViewSearch.OptionsFind.AlwaysVisible = true;
            this.ViewSearch.OptionsSelection.EnableAppearanceFocusedCell = false;
            this.ViewSearch.OptionsView.ShowAutoFilterRow = true;
            this.ViewSearch.OptionsView.ShowFilterPanelMode = DevExpress.XtraGrid.Views.Base.ShowFilterPanelMode.ShowAlways;
            this.ViewSearch.OptionsView.ShowFooter = true;
            this.ViewSearch.OptionsView.ShowGroupedColumns = true;
            this.ViewSearch.OptionsView.ShowGroupPanel = false;
            // 
            // ComponentName
            // 
            this.ComponentName.Caption = "Элемент";
            this.ComponentName.FieldName = "ComponentName";
            this.ComponentName.Name = "ComponentName";
            this.ComponentName.Visible = true;
            this.ComponentName.VisibleIndex = 0;
            this.ComponentName.Width = 555;
            // 
            // SectionName
            // 
            this.SectionName.Caption = "Раздел";
            this.SectionName.FieldName = "SectionName";
            this.SectionName.Name = "SectionName";
            this.SectionName.Visible = true;
            this.SectionName.VisibleIndex = 1;
            this.SectionName.Width = 163;
            // 
            // PMSign
            // 
            this.PMSign.Caption = "Вид элемента";
            this.PMSign.FieldName = "PMSign";
            this.PMSign.Name = "PMSign";
            this.PMSign.Visible = true;
            this.PMSign.VisibleIndex = 2;
            this.PMSign.Width = 68;
            // 
            // ElementID
            // 
            this.ElementID.Caption = "ElementID";
            this.ElementID.FieldName = "ElementID";
            this.ElementID.Name = "ElementID";
            // 
            // ComponentID
            // 
            this.ComponentID.Caption = "ComponentID";
            this.ComponentID.FieldName = "ComponentID";
            this.ComponentID.Name = "ComponentID";
            this.ComponentID.Width = 68;
            // 
            // SectionID
            // 
            this.SectionID.Caption = "SectionID";
            this.SectionID.FieldName = "SectionID";
            this.SectionID.Name = "SectionID";
            this.SectionID.Width = 68;
            // 
            // SPID
            // 
            this.SPID.Caption = "SPID";
            this.SPID.FieldName = "SPID";
            this.SPID.Name = "SPID";
            this.SPID.Width = 68;
            // 
            // fTSpecInsert
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.MenuBar;
            this.CancelButton = this.btnDefaultExit;
            this.ClientSize = new System.Drawing.Size(811, 363);
            this.Controls.Add(this.labelControl8);
            this.Controls.Add(this.txtSPID);
            this.Controls.Add(this.labelControl4);
            this.Controls.Add(this.txtElementID);
            this.Controls.Add(this.labelControl1);
            this.Controls.Add(this.txtComponentID);
            this.Controls.Add(this.lkpComponent);
            this.Controls.Add(this.txtPMSign);
            this.Controls.Add(this.labelControl6);
            this.Controls.Add(this.txtRepDescript);
            this.Controls.Add(this.labelControl5);
            this.Controls.Add(this.labelControl3);
            this.Controls.Add(this.clcQuantity);
            this.Controls.Add(this.txtTechSectorName);
            this.Controls.Add(this.labelControl7);
            this.Controls.Add(this.txtRemark);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.btnDefaultExit);
            this.Controls.Add(this.labelControl2);
            this.Controls.Add(this.txtRecordID);
            this.Controls.Add(this.toolStrip1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.KeyPreview = true;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "fTSpecInsert";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Добавление элемента в спецификацию";
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
            ((System.ComponentModel.ISupportInitialize)(this.clcQuantity.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtRepDescript.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtPMSign.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.lkpComponent.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtComponentID.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtElementID.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.txtSPID.Properties)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.ViewSearch)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.NotifyIcon notifyIcon1;
        private System.Windows.Forms.ToolStrip toolStrip1;
        private System.Windows.Forms.ToolStripButton btnSave;
        private System.Windows.Forms.ImageList img;
        private System.Windows.Forms.ToolStripButton btnCancel;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.ToolStripStatusLabel lblInfo;
        private System.Windows.Forms.Button btnDefaultExit;
        private System.Windows.Forms.ToolStripStatusLabel lblInfo0;
        private DevExpress.XtraEditors.StyleController styleController1;
        private DevExpress.XtraEditors.DXErrorProvider.DXValidationProvider dxValidationProvider1;
        private DevExpress.XtraEditors.TextEdit txtRecordID;
        private DevExpress.XtraEditors.LabelControl labelControl2;
        private DevExpress.XtraEditors.MemoEdit txtRemark;
        private DevExpress.XtraEditors.LabelControl labelControl7;
        private DevExpress.XtraEditors.LabelControl txtTechSectorName;
        private DevExpress.XtraEditors.LabelControl labelControl3;
        private DevExpress.XtraEditors.CalcEdit clcQuantity;
        private DevExpress.XtraEditors.TextEdit txtRepDescript;
        private DevExpress.XtraEditors.LabelControl labelControl5;
        private DevExpress.XtraEditors.TextEdit txtPMSign;
        private DevExpress.XtraEditors.LabelControl labelControl6;
        private DevExpress.XtraEditors.SearchLookUpEdit lkpComponent;
        private DevExpress.XtraGrid.Views.Grid.GridView ViewSearch;
        private DevExpress.XtraGrid.Columns.GridColumn ComponentName;
        private DevExpress.XtraGrid.Columns.GridColumn SectionName;
        private DevExpress.XtraGrid.Columns.GridColumn PMSign;
        private DevExpress.XtraGrid.Columns.GridColumn ComponentID;
        private DevExpress.XtraGrid.Columns.GridColumn SectionID;
        private DevExpress.XtraGrid.Columns.GridColumn SPID;
        private DevExpress.XtraGrid.Columns.GridColumn ElementID;
        private DevExpress.XtraEditors.TextEdit txtComponentID;
        private DevExpress.XtraEditors.LabelControl labelControl1;
        private DevExpress.XtraEditors.LabelControl labelControl4;
        private DevExpress.XtraEditors.TextEdit txtElementID;
        private DevExpress.XtraEditors.LabelControl labelControl8;
        private DevExpress.XtraEditors.TextEdit txtSPID;
    }
}