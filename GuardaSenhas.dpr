program GuardaSenhas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UForm in 'UForm.pas' {Form1},
  UDM in 'UDM.pas' {DM: TDataModule},
  UInicial in 'UInicial.pas' {FormInicial},
  ULogin in 'ULogin.pas' {FormLogin},
  UPrincipal in 'UPrincipal.pas' {FormPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFormInicial, FormInicial);
  Application.CreateForm(TFormLogin, FormLogin);
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Application.CreateForm(TDM, DM);
  Application.CreateForm(TFormInicial, FormInicial);
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];

