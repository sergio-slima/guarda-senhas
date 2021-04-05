program GuardaSenhas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UTipo in 'UTipo.pas' {FormTipos},
  UDM in 'UDM.pas' {DM: TDataModule},
  UInicial in 'UInicial.pas' {FormInicial},
  ULogin in 'ULogin.pas' {FormLogin},
  UPrincipal in 'UPrincipal.pas' {FormPrincipal},
  uFancyDialog in 'uFancyDialog.pas',
  uFormat in 'uFormat.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFormInicial, FormInicial);
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.Run;
end.
