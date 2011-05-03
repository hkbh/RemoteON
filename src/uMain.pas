unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvSmoothListBox, DBAdvSmoothListBox, dxRibbonForm, dxSkinsCore,
  dxSkinOffice2010Black, cxLookAndFeels, dxSkinsForm, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZConnection;

type
  TForm4 = class(TdxRibbonForm)
    DBAdvSmoothListBox1: TDBAdvSmoothListBox;
    dxSkinController1: TdxSkinController;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    DataSource1: TDataSource;
    ZQuery2: TZQuery;
    procedure FormShow(Sender: TObject);
    procedure DBAdvSmoothListBox1ItemButtonClick(Sender: TObject;
      itemindex: Integer);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  if DataSource1.DataSet.Active then  
  DBAdvSmoothListBox1.Footer.Caption := DataSource1.DataSet.FieldByName('alias').AsString + ' ' +
    DataSource1.DataSet.FieldByName('mac').AsString;
end;

procedure TForm4.DBAdvSmoothListBox1ItemButtonClick(Sender: TObject;
  itemindex: Integer);
begin
  // ShowMessage(inttostr(itemindex));
end;

procedure TForm4.FormShow(Sender: TObject);
begin
  if FileExists(ExtractFilePath(ParamStr(0)) + 'settings.db3') then  
  try
    ZConnection1.Database := ExtractFilePath(ParamStr(0)) + 'settings.db3';
    ZConnection1.Connect;
    ZQuery1.Open;
    ZQuery2.Open;
  except on E: exception do
    ShowMessage(E.Message);
  end;
end;

end.