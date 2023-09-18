//==============================================================================
// DESENVOLVIDO POR FRANCISCO AURINO | 98 98892-3379
//==============================================================================




unit uNFe.Fazenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.OleCtrls,
  SHDocVw, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids, System.DateUtils,  Winapi.ShellAPI,
  IdIOHandler, IdIOHandlerSocket,IdHTTP, IdSSLOpenSSL, RegularExpressions,
  IdIOHandlerStack, IdSSL,  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  Vcl.ExtDlgs, Vcl.Imaging.pngimage;


type
  TfrmNfeFazenda = class(TForm)
    Panel1: TPanel;
    btnInformes: TButton;
    StatusBar1: TStatusBar;
    btnAvisos: TButton;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    resultado: TMemo;
    StringGrid1: TStringGrid;
    procedure btnInformesClick(Sender: TObject);
    procedure btnAvisosClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StatusBar1Click(Sender: TObject);
  private
    { Private declarations }
     type TInformes = record Data: string; titulo: string; Link: string; end;
     function GetFazenda: string;
     procedure InsertInformesEntryToList(const Entry: TInformes; List: TStringList);
     procedure AddRecordToGrid(Data, titulo, Link: string ; row : integer);
     function  EstaNoIntervaloDoMes(v: string): Boolean;
     function  ExtractDataFromHTML(const HTMLContent: string; Row : integer ; RegExString : string ): TStringList;
     function  StripHTMLTags(const Text: string): string;
     function  EncodeString(const InputText: string): string;
     procedure LimparStringGrid(StringGrid: TStringGrid);
  public
    { Public declarations }
  end;
var frmNfeFazenda: TfrmNfeFazenda;
implementation
{$R *.dfm}
function TfrmNfeFazenda.EstaNoIntervaloDoMes(v: string): Boolean;
var
  a: TDateTime;
  b, c: TDateTime;
  d: string;
begin
  d := FormatDateTime('dd/mm/yyyy', StrToDate(v));
  a := StrToDate(d);
  b := EncodeDate(YearOf(Now), MonthOf(Now), 1);
  c := EndOfTheMonth(Now);
  Result := (a >= b) and (a <= c);
end;
function TfrmNfeFazenda.GetFazenda: string;
var
  a: TIdHTTP;
  b: TStringStream;
begin
  a := TIdHTTP.Create(nil);
  b := TStringStream.Create('');
  try
    a.Request.Accept := 'text/html, */*';
    a.Request.UserAgent := 'Mozilla/3.0 (compatible; IndyLibrary)';
    a.Request.ContentType := 'application/x-www-form-urlencoded';
    a.HandleRedirects := True;
    a.Get('https://www.nfe.fazenda.gov.br/portal/principal.aspx', b);
    result := b.DataString;
  finally
    b.Free;
    a.Free;
  end;
end;
procedure TfrmNfeFazenda.LimparStringGrid(StringGrid: TStringGrid);
var
  r, c: Integer;
begin
  resultado.Clear;
  for r := 0 to StringGrid.RowCount - 1 do
  begin
    for c := 0 to StringGrid.ColCount - 1 do
    begin
      StringGrid.Cells[c, r] := '';
    end;
  end;
end;
procedure TfrmNfeFazenda.InsertInformesEntryToList(const Entry: TInformes; List: TStringList);
var
  s: string;
begin
  s := 'Data: ' + Entry.Data + sLineBreak + 'Mensagem: ' + Entry.titulo + sLineBreak + 'Link: ' + Entry.Link;
  List.Add(s);
end;
procedure TfrmNfeFazenda.AddRecordToGrid(Data, titulo, Link: string ; row : integer);
begin
    StringGrid1.Options       := StringGrid1.Options + [goColSizing];
    StringGrid1.Cells[0, 0]   := 'Info';
    StringGrid1.Cells[1, 0]   := 'Mensagem';
    StringGrid1.Cells[2, 0]   := 'Link';
    StringGrid1.ColWidths[0]  := 80;
    StringGrid1.ColWidths[1]  := 350;
    StringGrid1.ColWidths[2]  := 500;
    StringGrid1.ColCount      := 3;
    StringGrid1.RowCount      := StringGrid1.RowCount + 1;
    StringGrid1.Cells[0, row] := Data;
    StringGrid1.Cells[1, row] := titulo;
    StringGrid1.Cells[2, row] := 'https://www.nfe.fazenda.gov.br/portal/' + Link;
end;
function TfrmNfeFazenda.EncodeString(const InputText: string): string;
begin
  Result := UTF8Decode(InputText);
end;
procedure TfrmNfeFazenda.StatusBar1Click(Sender: TObject);
begin
     ShellExecute(0, 'open', PChar('https://wa.me/559888923379'), nil, nil, SW_SHOWNORMAL);
end;
procedure TfrmNfeFazenda.StringGrid1DblClick(Sender: TObject);
begin
  ShellExecute(0, 'open', PChar(StringGrid1.Cells[2, StringGrid1.Row]), nil, nil, SW_SHOWNORMAL);
end;
function TfrmNfeFazenda.StripHTMLTags(const Text: string): string;
var
  t: Boolean;
  I: Integer;
begin
  Result := '';
  t := False;
  for I := 1 to Length(Text) do
  begin
    if Text[I] = '<' then  t := True
    else if Text[I] = '>' then t := False
    else if not t then Result := Result + Text[I];
  end;
end;
function TfrmNfeFazenda.ExtractDataFromHTML(const HTMLContent: string; Row : integer ; RegExString : string ): TStringList;
var
  r: TRegEx;
  m: TMatch;
  THtml: TStringList;
begin
  THtml := TStringList.Create;
  try
    r := TRegEx.Create(RegExString, [roIgnoreCase]);
    m := r.Match(HTMLContent);
        while m.Success do
    begin
       THtml.Add('Data: ' + EncodeString(m.Groups[2].Value.Trim) +
                    ' Mensagem: ' + EncodeString(m.Groups[3].Value.Trim) +
                    ' Link: ' + 'https://www.nfe.fazenda.gov.br/portal/'+ StringReplace(EncodeString(m.Groups[1].Value.Trim), 'amp;', '', [rfReplaceAll])
                   );
      THtml.Add('');

      AddRecordToGrid(
                      EncodeString(m.Groups[2].Value.Trim), EncodeString(m.Groups[3].Value.Trim),
                      StringReplace(EncodeString(m.Groups[1].Value.Trim), 'amp;', '', [rfReplaceAll]) ,
                      Row
                      );

      if EstaNoIntervaloDoMes( EncodeString(m.Groups[2].Value.Trim) ) then
      begin
       StatusBar1.Panels[1].Text := 'Data:'+EncodeString(m.Groups[2].Value.Trim) +' | '+ 'Mensagem:'+ EncodeString(m.Groups[3].Value.Trim) ;
      end;
      m := m.NextMatch;
    end;
  except
    THtml.Free;
    raise;
  end;

  Result := THtml;
end;
procedure TfrmNfeFazenda.btnAvisosClick(Sender: TObject);
var
  h: string;
  d: TStringList;
  r: TRegEx;
  m: TMatch;
  l : integer;
begin
  LimparStringGrid( StringGrid1 ) ;
  d := TStringList.Create;
  h := GetFazenda;
  r := TRegEx.Create('<caption>(.*?)</caption><tr>\s*<td>(.*?)</td>', [roSingleLine]);
  m := r.Match(h);
  l := 0 ;
  while m.Success do
  begin
    l := l + 1;
    d.Add(EncodeString(m.Groups[1].Value.Trim) );
    d.Add(EncodeString(m.Groups[2].Value.Trim) );
    d.Add('');
    if l <> 1  then resultado.Lines.AddStrings(d)  ;
    AddRecordToGrid(
                  EncodeString(m.Groups[1].Value.Trim),
                  EncodeString(m.Groups[2].Value.Trim),
                  '',
                  l
                  );
    m := m.NextMatch;
  end;

end;
procedure TfrmNfeFazenda.btnInformesClick(Sender: TObject);
var
  h: string;
  pi, pf, pr: Integer;
  s, dd: string;
  d: TStringList;
  r : integer;
begin
  LimparStringGrid( StringGrid1 ) ;
  h     := GetFazenda;
  pi    := Pos('<table cellspacing="0" rules="all" border="1" id="ctl00_ContentPlaceHolder1_gdvInformes"', h);
  pf    := Pos('</table>', h, pi);
  s     := Copy(h, pi, pf - pi);
  r := 1;
  while Pos('<tr>', s) > 0 do
  begin
   pr := Pos('<td>', s);
   if pr > 0 then
    begin
      dd := Copy(s, pr + 4, Pos('</td>', s, pr) - pr - 4);
      d := ExtractDataFromHTML(dd, r, '<a id="[^"]*_hlkDataInforme" href="([^"]*)">([^<]*)</a>\s*<a id="[^"]*_hlkTituloInforme"[^>]*>([^<]*)</a>');
      resultado.Lines.AddStrings(d) ;
      s := Copy(s, Pos('</tr>', s, pr) + 5, Length(s));
       r := r + 1 ;
    end
   else
      Break;
  end;
end;
end.
//==============================================================================
// DESENVOLVIDO POR FRANCISCO AURINO | 98 98892-3379
//==============================================================================
