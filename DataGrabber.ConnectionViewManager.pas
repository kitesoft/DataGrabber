{
  Copyright (C) 2013-2018 Tim Sinaeve tim.sinaeve@gmail.com

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
}

unit DataGrabber.ConnectionViewManager;

interface

uses
  System.SysUtils, System.Classes, System.Diagnostics, System.Actions,
  System.ImageList,
  Vcl.ActnList, Vcl.Menus, Vcl.ImgList, Vcl.Controls,

  Spring.Collections,

  DataGrabber.DataInspector, DataGrabber.FieldInspector,

  DataGrabber.Interfaces, DataGrabber.ConnectionProfiles,

  DDuce.Logger;

{$REGION 'documentation'}
{
  The ConnectionViewManager is a singleton instance which manages:
    - the application settings  (TDGSettings)
    - the ConnectionView instances (ConnectionViews)
    - the active connection view (ActiveConnectionView)
    - all actions that can be executed on the active connectionview
}
{$ENDREGION}

type
  TdmConnectionViewManager = class(TDataModule, IConnectionViewManager)
    {$REGION 'designer controls'}
    aclActions                    : TActionList;
    actAddConnectionView          : TAction;
    actAutoSizeCols               : TAction;
    actChinookExampleQuery        : TAction;
    actClearGrouping              : TAction;
    actCollapseAll                : TAction;
    actCopy                       : TAction;
    actDataInspector              : TAction;
    actDebug                      : TAction;
    actDesigner                   : TAction;
    actExecute                    : TAction;
    actExecuteLiveResultSet       : TAction;
    actExpandAll                  : TAction;
    actFireDACInfo                : TAction;
    actFormatSQL                  : TAction;
    actGroupByBoxVisible          : TAction;
    actGroupBySelection           : TAction;
    actHideConstantColumns        : TAction;
    actHideEmptyColumns           : TAction;
    actHideSelectedColumns        : TAction;
    actInspect                    : TAction;
    actInspectConnection          : TAction;
    actInspectDataSet             : TAction;
    actInspectFDManager           : TAction;
    actInspectFields              : TAction;
    actInspectGrid                : TAction;
    actMergeColumnCells           : TAction;
    actPreview                    : TAction;
    actPrint                      : TAction;
    actRtti                       : TAction;
    actSelectionAsCommaText       : TAction;
    actSelectionAsFields          : TAction;
    actSelectionAsQuotedCommaText : TAction;
    actSelectionAsQuotedFields    : TAction;
    actSelectionAsText            : TAction;
    actSelectionAsTextTable       : TAction;
    actSelectionAsWhereIn         : TAction;
    actSelectionAsWiki            : TAction;
    actSettings                   : TAction;
    actShowAllColumns             : TAction;
    actShowMetaData               : TAction;
    actToggleFullScreen           : TAction;
    actToggleStayOnTop            : TAction;
    imlMain                       : TImageList;
    mniAutoSizeCols               : TMenuItem;
    mniClearGrouping              : TMenuItem;
    mniCollapseAll                : TMenuItem;
    mniCopy                       : TMenuItem;
    mniCopyTextTable              : TMenuItem;
    mniCopyWikiTable              : TMenuItem;
    mniExecute                    : TMenuItem;
    mniExpandAll                  : TMenuItem;
    mniFormatSQL1                 : TMenuItem;
    mniGroupByBoxVisible          : TMenuItem;
    mniGroupBySelection           : TMenuItem;
    mniHideConstantColumns        : TMenuItem;
    mniHideEmptyColumns           : TMenuItem;
    mniHideSelectedColumns        : TMenuItem;
    mniInspect                    : TMenuItem;
    mniInspectConnection          : TMenuItem;
    mniInspectConnectionManager   : TMenuItem;
    mniInspectDataSet             : TMenuItem;
    mniInspectFields              : TMenuItem;
    mniInspectGrid                : TMenuItem;
    mniMergeColumns               : TMenuItem;
    mniN1                         : TMenuItem;
    mniN3                         : TMenuItem;
    mniSelection                  : TMenuItem;
    mniSelectionAsCommaText       : TMenuItem;
    mniSelectionAsFields          : TMenuItem;
    mniSelectionAsQuotedCommaText : TMenuItem;
    mniSelectionAsQuotedFields    : TMenuItem;
    mniSelectionAsTextTable       : TMenuItem;
    mniSettings                   : TMenuItem;
    mniShowAllColumns             : TMenuItem;
    N1                            : TMenuItem;
    N2                            : TMenuItem;
    N3                            : TMenuItem;
    N4                            : TMenuItem;
    N5                            : TMenuItem;
    N6                            : TMenuItem;
    ppmConnectionView             : TPopupMenu;
    ppmEditorView                 : TPopupMenu;
    Liveresults1: TMenuItem;
    actResultsAsWiki: TAction;
    mniCopyResults: TMenuItem;
    ResultsasWiki1: TMenuItem;
    actCopyConnectionViewAsWiki: TAction;
    actAbout: TAction;
    {$ENDREGION}

    {$REGION 'action handlers'}
    procedure actAddConnectionViewExecute(Sender: TObject);
    procedure actAutoSizeColsExecute(Sender: TObject);
    procedure actChinookExampleQueryExecute(Sender: TObject);
    procedure actClearGroupingExecute(Sender: TObject);
    procedure actCollapseAllExecute(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actDataInspectorExecute(Sender: TObject);
    procedure actDesignerExecute(Sender: TObject);
    procedure actExecuteExecute(Sender: TObject);
    procedure actExecuteLiveResultSetExecute(Sender: TObject);
    procedure actExpandAllExecute(Sender: TObject);
    procedure actFireDACInfoExecute(Sender: TObject);
    procedure actGroupByBoxVisibleExecute(Sender: TObject);
    procedure actGroupBySelectionExecute(Sender: TObject);
    procedure actHideConstantColumnsExecute(Sender: TObject);
    procedure actHideEmptyColumnsExecute(Sender: TObject);
    procedure actHideSelectedColumnsExecute(Sender: TObject);
    procedure actInspectConnectionExecute(Sender: TObject);
    procedure actInspectDataSetExecute(Sender: TObject);
    procedure actInspectExecute(Sender: TObject);
    procedure actInspectFDManagerExecute(Sender: TObject);
    procedure actInspectFieldsExecute(Sender: TObject);
    procedure actInspectGridExecute(Sender: TObject);
    procedure actMergeColumnCellsExecute(Sender: TObject);
    procedure actPreviewExecute(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure actSelectionAsCommaTextExecute(Sender: TObject);
    procedure actSelectionAsFieldsExecute(Sender: TObject);
    procedure actSelectionAsQuotedCommaTextExecute(Sender: TObject);
    procedure actSelectionAsQuotedFieldsExecute(Sender: TObject);
    procedure actSelectionAsTextExecute(Sender: TObject);
    procedure actSelectionAsTextTableExecute(Sender: TObject);
    procedure actSelectionAsWhereInExecute(Sender: TObject);
    procedure actSelectionAsWikiExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure actShowAllColumnsExecute(Sender: TObject);
    procedure actShowMetaDataExecute(Sender: TObject);
    procedure actToggleFullScreenExecute(Sender: TObject);
    procedure actToggleStayOnTopExecute(Sender: TObject);
    procedure actResultsAsWikiExecute(Sender: TObject);
    procedure actCopyConnectionViewAsWikiExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    {$ENDREGION}

  private
    FSettings             : ISettings;
    FConnectionViewList   : IList<IConnectionView>;
    FActiveConnectionView : IConnectionView;
    FStopWatch            : TStopwatch;
    FDataInspector        : TfrmDataInspector;
    FFieldInspector       : TfrmFieldInspector;

    procedure SettingsChanged(Sender: TObject);

    {$REGION 'property access methods'}
    function GetSettings: ISettings;
    function GetActiveConnectionView: IConnectionView;
    procedure SetActiveConnectionView(const Value: IConnectionView);
    function GetActiveDataView: IDataView;
    function GetActiveData: IData;
    function GetActionList: TActionList;
    function GetAction(AName: string): TCustomAction;
    function GetConnectionViewPopupMenu: TPopupMenu;
    function GetDefaultConnectionProfile: TConnectionProfile;
    function GetItem(AIndex: Integer): IConnectionView;
    function GetCount: Integer;
    {$ENDREGION}

  protected
    procedure Execute(const ASQL: string);
    procedure ApplySettings;
    procedure UpdateActions;
    procedure UpdateConnectionViewCaptions;

  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    constructor Create(
      AOwner    : TComponent;
      ASettings : ISettings
    ); reintroduce; virtual;

    function AddConnectionView: IConnectionView;
    function DeleteConnectionView(AIndex: Integer): Boolean; overload;
    function DeleteConnectionView(AConnectionView: IConnectionView): Boolean; overload;

    property ActiveConnectionView: IConnectionView
      read GetActiveConnectionView write SetActiveConnectionView;

    property ActiveDataView: IDataView
      read GetActiveDataView;

    property ActiveData: IData
      read GetActiveData;

    property Settings: ISettings
      read GetSettings;

    property ActionList: TActionList
      read GetActionList;

    property Items[AIndex: Integer]: IConnectionView
      read GetItem; default;

    property Count: Integer
      read GetCount;

    property Actions[AName: string]: TCustomAction
      read GetAction;

    property ConnectionViewPopupMenu: TPopupMenu
      read GetConnectionViewPopupMenu;

    property DefaultConnectionProfile: TConnectionProfile
      read GetDefaultConnectionProfile;
  end;

implementation

{$R *.dfm}

uses
  Vcl.Forms, Vcl.Clipbrd, Vcl.Dialogs,
  FireDAC.Comp.Client,
  FireDAC.Stan.Consts,

  Spring,

  DDuce.ObjectInspector.zObjectInspector, DDuce.AboutDialog,

  DataGrabber.Settings.Dialog, DataGrabber.Factories, DataGrabber.Resources,
  DataGrabber.MetaData.Dialog;

{$REGION 'construction and destruction'}
constructor TdmConnectionViewManager.Create(AOwner: TComponent;
  ASettings: ISettings);
begin
  inherited Create(AOwner);
  FSettings := ASettings;
end;

procedure TdmConnectionViewManager.AfterConstruction;
begin
  inherited AfterConstruction;
  FSettings.Load;
  FSettings.OnChanged.Add(SettingsChanged);
  FConnectionViewList := TCollections.CreateInterfaceList<IConnectionView>;
  FDataInspector      := TfrmDataInspector.Create(Self);
  FFieldInspector     := TfrmFieldInspector.Create(Self);

  // disable actions that are not fully implemented yet
  actPreview.Visible       := False;
  actPrint.Visible         := False;
  actDesigner.Visible      := False;
  actRtti.Visible          := False;
  actDataInspector.Visible := False;
end;

procedure TdmConnectionViewManager.BeforeDestruction;
begin
  FSettings.Save;
  FConnectionViewList := nil;
  FreeAndNil(FDataInspector);
  FreeAndNil(FFieldInspector);
  inherited BeforeDestruction;
end;
{$ENDREGION}

{$REGION 'action handlers'}
// editor
procedure TdmConnectionViewManager.actSettingsExecute(Sender: TObject);
begin
  ExecuteSettingsDialog(Settings,
    procedure
    begin
      ApplySettings;
      UpdateActions;
    end
  );
end;

procedure TdmConnectionViewManager.actCollapseAllExecute(Sender: TObject);
begin
  (ActiveDataView as IGroupable).CollapseAll;
end;

procedure TdmConnectionViewManager.actCopyConnectionViewAsWikiExecute(
  Sender: TObject);
begin
  Clipboard.AsText := ActiveConnectionView.ExportAsWiki;
end;

procedure TdmConnectionViewManager.actCopyExecute(Sender: TObject);
begin
  ActiveConnectionView.Copy;
end;

// grid
{$REGION 'DataView actions'}
procedure TdmConnectionViewManager.actGroupByBoxVisibleExecute(Sender: TObject);
begin
  Settings.GroupByBoxVisible := (Sender as TAction).Checked;
end;

procedure TdmConnectionViewManager.actGroupBySelectionExecute(Sender: TObject);
begin
  (ActiveDataView as IGroupable).GroupBySelectedColumns;
end;

procedure TdmConnectionViewManager.actShowAllColumnsExecute(Sender: TObject);
begin
  if ActiveDataView.ResultSet.ShowAllFields then
    ActiveDataView.UpdateView;
end;

procedure TdmConnectionViewManager.actShowMetaDataExecute(Sender: TObject);
var
  F: TfrmMetaData;
begin
  F := TfrmMetaData.Create(Self, ActiveData.Connection);
  F.ShowModal;
end;

procedure TdmConnectionViewManager.actToggleFullScreenExecute(Sender: TObject);
var
  A : TAction;
begin
  A := Sender as TAction;
  if A.Checked then
    Settings.FormSettings.WindowState := wsMaximized
  else
    Settings.FormSettings.WindowState := wsNormal;
end;

procedure TdmConnectionViewManager.actToggleStayOnTopExecute(Sender: TObject);
var
  A : TAction;
begin
  A := Sender as TAction;
  if A.Checked then
    Settings.FormSettings.FormStyle := fsStayOnTop
  else
    Settings.FormSettings.FormStyle := fsNormal;
end;

procedure TdmConnectionViewManager.actSelectionAsCommaTextExecute(
  Sender: TObject);
begin
  Clipboard.AsText := ActiveDataView.SelectionToCommaText(False);
end;

procedure TdmConnectionViewManager.actSelectionAsFieldsExecute(Sender: TObject);
begin
  Clipboard.AsText := ActiveDataView.SelectionToFields(False);
end;

procedure TdmConnectionViewManager.actSelectionAsQuotedCommaTextExecute(
  Sender: TObject);
begin
  Clipboard.AsText := ActiveDataView.SelectionToCommaText(True);
end;

procedure TdmConnectionViewManager.actSelectionAsQuotedFieldsExecute(
  Sender: TObject);
begin
  Clipboard.AsText := ActiveDataView.SelectionToFields;
end;

procedure TdmConnectionViewManager.actSelectionAsTextExecute(Sender: TObject);
begin
  Clipboard.AsText := ActiveDataView.SelectionToDelimitedTable;
end;

procedure TdmConnectionViewManager.actSelectionAsTextTableExecute(
  Sender: TObject);
begin
  Clipboard.AsText := ActiveDataView.SelectionToTextTable(True);
end;

procedure TdmConnectionViewManager.actSelectionAsWhereInExecute(
  Sender: TObject);
begin
  ShowMessage('Not supported yet.');
end;

procedure TdmConnectionViewManager.actSelectionAsWikiExecute(Sender: TObject);
begin
  Clipboard.AsText := ActiveDataView.SelectionToWikiTable(True);
end;

procedure TdmConnectionViewManager.actHideConstantColumnsExecute(
  Sender: TObject);
begin
  ActiveDataView.ResultSet.ConstantFieldsVisible := not
    ActiveDataView.ResultSet.ConstantFieldsVisible;
  ActiveDataView.UpdateView;
end;

procedure TdmConnectionViewManager.actHideEmptyColumnsExecute(Sender: TObject);
begin
  ActiveDataView.ResultSet.EmptyFieldsVisible := not
    ActiveDataView.ResultSet.EmptyFieldsVisible;
  ActiveDataView.UpdateView;
end;

procedure TdmConnectionViewManager.actHideSelectedColumnsExecute(
  Sender: TObject);
begin
  ActiveDataView.HideSelectedColumns;
end;

procedure TdmConnectionViewManager.actInspectConnectionExecute(Sender: TObject);
begin
  InspectComponent(ActiveData.Connection);
end;

procedure TdmConnectionViewManager.actInspectDataSetExecute(Sender: TObject);
begin
  InspectComponent(ActiveDataView.DataSet);
end;

procedure TdmConnectionViewManager.actInspectExecute(Sender: TObject);
begin
  ShowMessage('Not supported yet.');
end;

procedure TdmConnectionViewManager.actInspectFDManagerExecute(Sender: TObject);
begin
  InspectObject(FDManager);
end;

procedure TdmConnectionViewManager.actInspectFieldsExecute(Sender: TObject);
begin
  if Assigned(FFieldInspector) then
  begin
    FFieldInspector.DataSet := ActiveDataView.DataSet;
    FFieldInspector.Show;
  end;
end;

procedure TdmConnectionViewManager.actInspectGridExecute(Sender: TObject);
begin
  if Assigned(ActiveDataView) then
    ActiveDataView.Inspect;
end;

procedure TdmConnectionViewManager.actMergeColumnCellsExecute(
  Sender: TObject);
begin
  Settings.MergeColumnCells := (Sender as TAction).Checked;
end;

procedure TdmConnectionViewManager.actAboutExecute(Sender: TObject);
var
  F : TfrmAboutDialog;
begin
  F := TfrmAboutDialog.Create(Self);
  try
    F.ShowModal;
  finally
    F.Free;
  end;
end;

procedure TdmConnectionViewManager.actAddConnectionViewExecute(Sender: TObject);
begin
  AddConnectionView;
end;

procedure TdmConnectionViewManager.actAutoSizeColsExecute(Sender: TObject);
begin
  if Assigned(ActiveDataView) then
    ActiveDataView.AutoSizeColumns;
end;
{$ENDREGION}

// data
{$REGION 'ActiveData actions'}
procedure TdmConnectionViewManager.actDataInspectorExecute(Sender: TObject);
begin
  FSettings.DataInspectorVisible := actDataInspector.Checked;
  FDataInspector.ResultSet := ActiveDataView.ResultSet;
  if actDataInspector.Checked then
    FDataInspector.Show;
end;

procedure TdmConnectionViewManager.actChinookExampleQueryExecute(Sender: TObject);
begin
  ActiveConnectionView.EditorView.Text := CHINOOK_EXAMPLE_QUERY;
end;

procedure TdmConnectionViewManager.actClearGroupingExecute(Sender: TObject);
begin
  (ActiveDataView as IGroupable).ClearGrouping;
end;

procedure TdmConnectionViewManager.actExecuteExecute(Sender: TObject);
begin
  ActiveData.DataEditMode := False;
  Execute(ActiveConnectionView.EditorView.Text);
end;

procedure TdmConnectionViewManager.actExecuteLiveResultSetExecute(
  Sender: TObject);
begin
  ActiveData.DataEditMode := True;
  Execute(ActiveConnectionView.EditorView.Text);
end;

procedure TdmConnectionViewManager.actExpandAllExecute(Sender: TObject);
begin
  (ActiveDataView as IGroupable).ExpandAll;
end;

procedure TdmConnectionViewManager.actFireDACInfoExecute(Sender: TObject);
begin
  ShowMessageFmt('FireDAC version %s', [C_FD_Version]);
end;

procedure TdmConnectionViewManager.actPrintExecute(Sender: TObject);
begin
  //(ActiveData as IDataReport).PrintReport;
end;

procedure TdmConnectionViewManager.actResultsAsWikiExecute(Sender: TObject);
begin
  Clipboard.AsText := ActiveConnectionView.ExportAsWiki;
end;

procedure TdmConnectionViewManager.actDesignerExecute(Sender: TObject);
begin
//  (ActiveData as IDataReport).DesignReport;
//  (ActiveData as IDataReport).EditProperties;
end;

procedure TdmConnectionViewManager.actPreviewExecute(Sender: TObject);
begin
//  (ActiveData as IDataReport).ReportTitle := 'DataGrabber';
//  (ActiveData as IDataReport).PreviewReport;
end;
{$ENDREGION}
{$ENDREGION}

{$REGION 'property access methods'}
function TdmConnectionViewManager.GetActionList: TActionList;
begin
  Result := aclActions;
end;

function TdmConnectionViewManager.GetActiveConnectionView: IConnectionView;
begin
  Result := FActiveConnectionView;
end;

procedure TdmConnectionViewManager.SetActiveConnectionView(
  const Value: IConnectionView);
begin
  FActiveConnectionView := Value;
end;

procedure TdmConnectionViewManager.SettingsChanged(Sender: TObject);
begin
  actToggleFullScreen.Checked := Settings.FormSettings.WindowState = wsMaximized;
end;

function TdmConnectionViewManager.GetActiveData: IData;
begin
  if Assigned(FActiveConnectionView) then
    Result := FActiveConnectionView.Data
  else
    Result := nil;
end;

function TdmConnectionViewManager.GetActiveDataView: IDataView;
begin
  if Assigned(FActiveConnectionView) then
    Result := FActiveConnectionView.ActiveDataView
  else
    Result := nil;
end;

function TdmConnectionViewManager.GetConnectionViewPopupMenu: TPopupMenu;
begin
  Result := ppmConnectionView;
end;

function TdmConnectionViewManager.GetCount: Integer;
begin
  Result := FConnectionViewList.Count;
end;

function TdmConnectionViewManager.GetDefaultConnectionProfile: TConnectionProfile;
begin
  Result := FSettings.ConnectionProfiles.Find(FSettings.DefaultConnectionProfile);
end;

function TdmConnectionViewManager.GetItem(AIndex: Integer): IConnectionView;
begin
  Result := FConnectionViewList[AIndex];
end;

function TdmConnectionViewManager.GetAction(AName: string): TCustomAction;
var
  I: Integer;
begin
  I := ActionList.ActionCount - 1;
  while (I >= 0) and (CompareText(TAction(ActionList[I]).Name, AName) <> 0) do
    Dec(I);
  if I >= 0 then
    Result := ActionList[I] as TCustomAction
  else
    Result := nil;
end;

function TdmConnectionViewManager.GetSettings: ISettings;
begin
  Result := FSettings;
end;
{$ENDREGION}

{$REGION 'protected methods'}
procedure TdmConnectionViewManager.ApplySettings;
begin
  ActiveConnectionView.ApplySettings;
end;

function TdmConnectionViewManager.DeleteConnectionView(
  AIndex: Integer): Boolean;
begin
  if AIndex < Count then
  begin
    FConnectionViewList.Delete(AIndex);
    Result := True;
  end
  else
    Result := False;
end;

function TdmConnectionViewManager.DeleteConnectionView(
  AConnectionView: IConnectionView): Boolean;
var
  N : Integer;
begin
  Guard.CheckNotNull(AConnectionView, 'AConnectionView');
  N := FConnectionViewList.IndexOf(AConnectionView);
  if N <> -1 then
  begin
    FConnectionViewList.Delete(N);
    Result := True;
  end
  else
    Result := False;
end;

procedure TdmConnectionViewManager.Execute(const ASQL: string);
begin
  FStopWatch.Reset;
  ActiveData.SQL := ASQL;
  FStopWatch.Start;
  ActiveData.Execute;
  FStopWatch.Stop;
//  if Assigned(FDataInspector) and FDataInspector.Visible then
//  begin
//    FDataInspector.Data := ActiveData;
//  end;
  if Assigned(FFieldInspector) and FFieldInspector.Visible then
  begin
    FFieldInspector.DataSet := ActiveDataView.DataSet;
  end;
end;

procedure TdmConnectionViewManager.UpdateActions;
var
  B: Boolean;
begin
  if Assigned(FSettings) then
  begin
    actToggleStayOnTop.Checked := FSettings.FormSettings.FormStyle = fsStayOnTop;
    actDataInspector.Checked   := FSettings.DataInspectorVisible;
  end;

  if Assigned(ActiveData) and Assigned(ActiveConnectionView) then
  begin
    actExecute.Enabled := not ActiveConnectionView.EditorView.Text.Trim.IsEmpty;
    actExecuteLiveResultSet.Enabled := actExecute.Enabled;

    B := ActiveData.Active;
    actPreview.Enabled             := B;
    actPrint.Enabled               := B;
    actDesigner.Enabled            := B;

    B := Assigned(ActiveDataView) and Assigned(ActiveDataView.ResultSet);
    actHideEmptyColumns.Enabled    := B;
    actHideConstantColumns.Enabled := B;
    actHideSelectedColumns.Enabled := B;
    actShowAllColumns.Enabled      := B;

    actHideEmptyColumns.Checked    := B and
      not ActiveDataView.ResultSet.EmptyFieldsVisible;
    actHideConstantColumns.Checked := B and
      not ActiveDataView.ResultSet.ConstantFieldsVisible;
    actAutoSizeCols.Visible      := B;
    actAutoSizeCols.Enabled      := actAutoSizeCols.Visible;
    actGroupBySelection.Visible  := B and Supports(ActiveDataView, IGroupable);
    actGroupBySelection.Enabled  := actGroupBySelection.Visible;
    actGroupByBoxVisible.Visible := B and Supports(ActiveDataView, IGroupable);
    actGroupByBoxVisible.Checked := Settings.GroupByBoxVisible;
    actExpandAll.Visible         := B and Supports(ActiveDataView, IGroupable);
    actCollapseAll.Visible       := B and Supports(ActiveDataView, IGroupable);
    actClearGrouping.Visible     := B and Supports(ActiveDataView, IGroupable);
    actMergeColumnCells.Visible  := B and Supports(ActiveDataView, IMergable);
    actMergeColumnCells.Enabled  := actMergeColumnCells.Visible;
    actMergeColumnCells.Checked  := Settings.MergeColumnCells;
  end;
end;

procedure TdmConnectionViewManager.UpdateConnectionViewCaptions;
var
  CV : IConnectionView;
  I  : Integer;
begin
  for I := 0 to FConnectionViewList.Count - 1 do
  begin
    CV := FConnectionViewList[I] as IConnectionView;
    if Assigned(CV.ActiveConnectionProfile) then
      CV.Form.Caption := Format('(%d) %s', [I + 1, CV.ActiveConnectionProfile.Name]);
  end;
end;
{$ENDREGION}

{$REGION 'public methods'}
function TdmConnectionViewManager.AddConnectionView: IConnectionView;
var
  CP : TConnectionProfile;
  CV : IConnectionView;
  D  : IData;
begin
  if Assigned(FActiveConnectionView) then
    CP := FActiveConnectionView.ActiveConnectionProfile
  else
    CP := DefaultConnectionProfile;
  D  := TDataGrabberFactories.CreateData(Self, CP.ConnectionSettings);
  CV := TDataGrabberFactories.CreateConnectionView(Self, Self, D);
  FConnectionViewList.Add(CV);
  ActiveConnectionView := CV;
  UpdateConnectionViewCaptions;
  Result := CV;
end;
{$ENDREGION}

end.
