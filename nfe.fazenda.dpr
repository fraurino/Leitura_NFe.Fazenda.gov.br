program nfe.fazenda;

uses
  Vcl.Forms,
  uNFe.Fazenda in 'uNFe.Fazenda.pas' {frmNfeFazenda},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmNfeFazenda, frmNfeFazenda);
  Application.Run;
end.
