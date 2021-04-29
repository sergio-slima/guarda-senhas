program SavePass;

uses
  System.StartUpCopy,
  FMX.Forms,
  UTipo in 'UTipo.pas' {FormTipos},
  UDM in 'UDM.pas' {DM: TDataModule},
  UInicial in 'UInicial.pas' {FormInicial},
  ULogin in 'ULogin.pas' {FormLogin},
  UPrincipal in 'UPrincipal.pas' {FormPrincipal},
  {$IFDEF ANDROID}
  Android.KeyguardManager in 'Units\Android.KeyguardManager.pas',
  DW.Androidapi.JNI.KeyguardManager in 'Units\DW.Androidapi.JNI.KeyguardManager.pas',
  {$ENDIF }
  uFancyDialog in 'uFancyDialog.pas',
  uFormat in 'uFormat.pas' {$R *.res},
  uMD5 in 'units\uMD5.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFormInicial, FormInicial);
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
  Application.Run;
end.
