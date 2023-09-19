//==============================================================================
// DESENVOLVIDO POR FRANCISCO AURINO | 98 98892-3379
//==============================================================================
unit uNFe.Fazenda;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.OleCtrls, System.StrUtils,
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
    pgServicos: TPageControl;
    tsNFe: TTabSheet;
    tsCTe: TTabSheet;
    resultado: TMemo;
    StringGrid1: TStringGrid;
    btnIBPTinforma: TButton;
    Label1: TLabel;
    procedure btnInformesClick(Sender: TObject);
    procedure btnAvisosClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure pgServicosChange(Sender: TObject);
    procedure pgServicosChanging(Sender: TObject; var AllowChange: Boolean);
    procedure btnIBPTinformaClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
     type TInformes = record Data: string; titulo: string; Link: string; end;
     function GetFazenda(url : string ): string;
     procedure InsertInformesEntryToList(const Entry: TInformes; List: TStringList);
     procedure AddRecordToGrid(Data, titulo, Link: string ; row : integer);
     function  EstaNoIntervaloDoMes(v: string): Boolean;
     function  ExtractDataFromHTML(const HTMLContent: string; Row : integer ; RegExString : string; service : integer ): TStringList;
     function  StripHTMLTags(const Text: string): string;
     function  EncodeString(const InputText: string): string;
     procedure LimparStringGrid(StringGrid: TStringGrid);

     procedure NFeInformes;
     procedure NFeAvisos;
     procedure CteInformes;
     procedure deolhonoibpt;

     const
     urlNfePortal : string = 'https://www.nfe.fazenda.gov.br/portal/';
     urlNFe : string = 'https://www.nfe.fazenda.gov.br/portal/principal.aspx';
     urlCTe : string = 'http://www.cte.fazenda.gov.br/portal/';
     urlNFeNT : String = 'https://www.nfe.fazenda.gov.br/portal/listaConteudo.aspx?tipoConteudo=04BIflQt1aY=';

     Tag_NFe : string = '<table cellspacing="0" rules="all" border="1" id="ctl00_ContentPlaceHolder1_gdvInformes"';
     Tag_CTe : string = '<table class="tabelaSemBordas" cellspacing="0" rules="all" border="1" id="ctl00_ContentPlaceHolder1_gdvInformes"' ;

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
function TfrmNfeFazenda.GetFazenda(url : string): string;
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
    a.Get(url, b);
    result := b.DataString;
  finally
    b.Free;
    a.Free;
  end;
end;
procedure TfrmNfeFazenda.Label1Click(Sender: TObject);
begin
     ShellExecute(0, 'open', PChar('https://wa.me/559888923379'), nil, nil, SW_SHOWNORMAL);
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



procedure TfrmNfeFazenda.NFeAvisos;
var
  h: string;
  d: TStringList;
  r: TRegEx;
  m: TMatch;
  l : integer;
begin
  LimparStringGrid( StringGrid1 ) ;
  d := TStringList.Create;
  h := GetFazenda(urlNFe);
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

procedure TfrmNfeFazenda.NFeInformes;
var
  h: string;
  pi, pf, pr: Integer;
  s, dd: string;
  d: TStringList;
  r : integer;
begin
  LimparStringGrid( StringGrid1 ) ;
  h     := GetFazenda(urlNFe);
  pi    := Pos(tag_NFe, h);
  pf    := Pos('</table>', h, pi);
  s     := Copy(h, pi, pf - pi);
  r := 1;
  while Pos('<tr>', s) > 0 do
  begin
   pr := Pos('<td>', s);
   if pr > 0 then
    begin
      dd := Copy(s, pr + 4, Pos('</td>', s, pr) - pr - 4);
      d := ExtractDataFromHTML(dd, r, '<a id="[^"]*_hlkDataInforme" href="([^"]*)">([^<]*)</a>\s*<a id="[^"]*_hlkTituloInforme"[^>]*>([^<]*)</a>',pgServicos.ActivePageIndex);
      resultado.Lines.AddStrings(d) ;
      s := Copy(s, Pos('</tr>', s, pr) + 5, Length(s));
       r := r + 1 ;
    end
   else
      Break;
  end;
end;

procedure TfrmNfeFazenda.pgServicosChange(Sender: TObject);
begin
  LimparStringGrid( StringGrid1 ) ;
  btnAvisos.Enabled := not pgservicos.ActivePageIndex.ToBoolean;
end;

procedure TfrmNfeFazenda.pgServicosChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  LimparStringGrid( StringGrid1 ) ;
  btnAvisos.Enabled := not pgservicos.ActivePageIndex.ToBoolean;
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
    StringGrid1.Cells[2, row] := Link;
end;
function TfrmNfeFazenda.EncodeString(const InputText: string): string;
begin
  Result := UTF8Decode(InputText);
end;
procedure TfrmNfeFazenda.StringGrid1DblClick(Sender: TObject);
var
url : string ;
begin
  case pgservicos.ActivePageIndex of
    0 : url := urlNfePortal;
    1 : url := urlCTe;
  end;
  ShellExecute(0, 'open', PChar( StringGrid1.Cells[2, StringGrid1.Row]), nil, nil, SW_SHOWNORMAL);
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
function TfrmNfeFazenda.ExtractDataFromHTML(const HTMLContent: string; Row : integer ; RegExString : string ; service : integer ): TStringList;
var
  r: TRegEx;
  m: TMatch;
  url : string ;
  THtml: TStringList;
begin
  THtml := TStringList.Create;
  try
    case service of
     0 : url := urlNfePortal;
     1 : url := urlCTe;
    end;
    r := TRegEx.Create(RegExString, [roIgnoreCase, roMultiLine]);
    m := r.Match(HTMLContent);

    while m.Success do
    begin
        case service of
          0:
          begin
            THtml.Add('Data: ' + EncodeString(m.Groups[2].Value.Trim) +
            ' Mensagem: ' + EncodeString(m.Groups[3].Value.Trim) +
            ' Link: ' + url + StringReplace(EncodeString(m.Groups[1].Value.Trim), 'amp;', '', [rfReplaceAll])
            );
            THtml.Add('');

            AddRecordToGrid(
            EncodeString(m.Groups[2].Value.Trim),
            EncodeString(m.Groups[3].Value.Trim),
            url  + StringReplace(EncodeString(m.Groups[1].Value.Trim), 'amp;', '', [rfReplaceAll]) ,
            Row
            );
          end;
          1:
          begin
            THtml.Add('Data: ' + EncodeString(m.Groups[2].Value.Trim) +
            ' Mensagem: ' + EncodeString(m.Groups[3].Value.Trim) +
            ' Link: ' + url + StringReplace(EncodeString(m.Groups[4].Value.Trim), 'amp;', '', [rfReplaceAll])
            );
            THtml.Add('');

            AddRecordToGrid(
            EncodeString(m.Groups[2].Value.Trim),
            EncodeString(m.Groups[3].Value.Trim),
            StringReplace(url + EncodeString(m.Groups[4].Value.Trim), 'amp;', '', [rfReplaceAll]) ,
            Row
            );
          end;
        end;

      if EstaNoIntervaloDoMes( EncodeString(m.Groups[2].Value.Trim) ) then
      begin
       StatusBar1.Panels[1].Text := 'Data:'+EncodeString(m.Groups[2].Value.Trim) +' | '+ 'Mensagem:'+ EncodeString(m.Groups[3].Value.Trim) ;
      end ;

      m := m.NextMatch;
    end;
  except
    THtml.Free;
    raise;
  end;

  Result := THtml;
end;
procedure TfrmNfeFazenda.btnAvisosClick(Sender: TObject);
begin
  case pgServicos.ActivePageIndex of
   0 : NFeAvisos ;

  end;
end;
procedure TfrmNfeFazenda.btnIBPTinformaClick(Sender: TObject);
begin
    deolhonoibpt;
end;

procedure TfrmNfeFazenda.btnInformesClick(Sender: TObject);
begin
  case pgServicos.ActivePageIndex of
    0 : NFeInformes;
    1 : CteInformes;
  end;

end;
procedure TfrmNfeFazenda.CteInformes;
function ETB(const Source, Start, EndStr: string): string;
var
  StartPos, EndPos: Integer;
begin
  StartPos := Pos(Start, Source);
  if StartPos = 0 then
    Result := ''
  else
  begin
    Inc(StartPos, Length(Start));
    EndPos := Pos(EndStr, Source, StartPos);
    if EndPos = 0 then
      Result := Copy(Source, StartPos, MaxInt)
    else
      Result := Copy(Source, StartPos, EndPos - StartPos);
  end;
end;

var
  h: string;
  pi, pf, pr: Integer;
  s, dd: string;
  d: TStringList;
  r : integer;
  i : integer;
  Line: string;
begin
  LimparStringGrid( StringGrid1 ) ;
  h     := GetFazenda(urlCTe);


  pi    := Pos(tag_Cte, h);
  pf    := Pos('</table>', h, pi);
  s     := Copy(h, pi, pf - pi);
  r := 1;
  while Pos('<tr>', s) > 0 do
  begin
   pr := Pos('<td>', s);
   if pr > 0 then
    begin
        dd := Copy(s, pr + 4, Pos('</td>', s, pr) - pr - 4);
        d := ExtractDataFromHTML(dd, r,
        '<a id="[^"]*_hlkDataInforme" href="([^"]*)">([^<]*)</a>\s*' +
        '<a id="[^"]*_hlkTituloInforme"[^>]*>([^<]*)</a>\s*' +
        '<a id="[^"]*_hlkLeiaMais" href="([^"]*)">([^<]*)</a>', pgServicos.ActivePageIndex);
       resultado.Lines.AddStrings(d) ;
      s := Copy(s, Pos('</tr>', s, pr) + 5, Length(s));
       r := r + 1 ;
    end
   else
      Break;
  end;

end;

procedure TfrmNfeFazenda.deolhonoibpt;
function TrimReplace(const text : string) : string ;
begin
  Result := StringReplace(Text, #13#10, ' ', [rfReplaceAll]);
  Result := StringReplace(Result, '  ', ' ', [rfReplaceAll]);
end;
function TrimFULL(const Text: string): string;
var
  i: Integer;
  IsSpace: Boolean;
begin
  Result := '';
  IsSpace := False;
  for i := 1 to Length(Text) do
  begin
    if Text[i] = ' ' then
    begin
      if not IsSpace then
      begin
        Result := Result + ' ';
        IsSpace := True;
      end;
    end
    else
    begin
      Result := Result + Text[i];
      IsSpace := False;
    end;
  end;
end;
function StripHTMLTags(const HTML: string): string;
var
  TagBegin, TagEnd: Integer;
  InsideTag: Boolean;
begin
  Result := '';
  InsideTag := False;

  for TagBegin := 1 to Length(HTML) do
  begin
    if HTML[TagBegin] = '<' then
      InsideTag := True
    else if HTML[TagBegin] = '>' then
      InsideTag := False
    else if not InsideTag then
      Result := Result + HTML[TagBegin];
  end;
  Result := Trim(Result);
end;
function ExtractMessageFromHTML(const HTML: string): string;

var
  StartPos, EndPos: Integer;
  MessageWithTags, MessageWithoutTags: string;
begin
  StartPos := Pos('Para cumprimento da Lei 12.741/12', HTML);
  if StartPos = 0 then
  begin
    Result := 'Mensagem não encontrada.';
    Exit;
  end;
  EndPos := Pos('<a href="/Site/API"><img src="/Content/images/modal/modal_botao.png" /></a>', HTML);
  if EndPos = 0 then
  begin
    Result := 'Fim da mensagem não encontrado.';
    Exit;
  end;
  MessageWithTags := Copy(HTML, StartPos, EndPos - StartPos);
  MessageWithoutTags := StripHTMLTags(MessageWithTags);

  Result := EncodeString (TrimFULL(MessageWithoutTags.Trim));
end;
var
  HTML: string;
  MessageText: string;
begin
  HTML := GetFazenda('https://deolhonoimposto.ibpt.org.br/');
  MessageText := ExtractMessageFromHTML(HTML);
  statusbar1.Panels[1].Text :=TrimFULL (TrimReplace (MessageText)) ;
  resultado.Lines.Add( TrimFULL (TrimReplace (MessageText)) )
end;

end.
//==============================================================================
// DESENVOLVIDO POR FRANCISCO AURINO | 98 98892-3379
//==============================================================================
