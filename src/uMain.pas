unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvSmoothListBox, DBAdvSmoothListBox, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZConnection, AdvOfficePager, AdvPageControl,
  ComCtrls, AdvAppStyler, IdBaseComponent, IdComponent,
  IdUDPBase, IdUDPClient;

type
  TForm4 = class(TForm)
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    DataSource1: TDataSource;
    ZQuery2: TZQuery;
    AdvPageControl1: TAdvPageControl;
    AdvTabSheet1: TAdvTabSheet;
    AdvTabSheet2: TAdvTabSheet;
    DBAdvSmoothListBox1: TDBAdvSmoothListBox;
    AdvFormStyler1: TAdvFormStyler;
    procedure DBAdvSmoothListBox1ItemDblClick(Sender: TObject;
      itemindex: Integer);
    procedure FormShow(Sender: TObject);
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

function HexStringToBinString(const HexStr: string): string;
var
i, l: integer;
begin
Result := '';
l := length(HexStr);
l := l div 2;
SetLength(Result, l);
for i := 1 to l do
 if HexToBin(PChar(Copy(HexStr, (i - 1) * 2 + 1, 2)), PChar(@Result[i]), 1) = 0 then
   raise Exception.Create('Invalid hex value');
end;

procedure SendMagicPacket(MACAddress: string);
var
s, packet: string;
i: integer;
begin
if Length(MACAddress) <> 12 then
 raise Exception.CreateFmt('Некорректный МАС адрес: %s', [MACAddress]);
packet := HexStringToBinString('FFFFFFFFFFFF');
s := HexStringToBinString(MACAddress);
for i := 1 to 16 do
 packet := packet + s;
with TIdUDPClient.Create(nil) do
 try
  Active := true;
  BroadcastEnabled := true;
  Broadcast(packet, 9);
 finally
  Free;
 end;
end;

procedure TForm4.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  if DataSource1.DataSet.Active then  
  DBAdvSmoothListBox1.Footer.Caption := DataSource1.DataSet.FieldByName('alias').AsString + ' ' +
    DataSource1.DataSet.FieldByName('mac').AsString;
end;

procedure TForm4.DBAdvSmoothListBox1ItemDblClick(Sender: TObject;
  itemindex: Integer);
begin
  //ShowMessage(DataSource1.DataSet.FieldByName('mac').AsString);
  SendMagicPacket(DataSource1.DataSet.FieldByName('mac').AsString);
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
