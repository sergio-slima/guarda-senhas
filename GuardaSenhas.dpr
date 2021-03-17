program GuardaSenhas;

uses
  System.StartUpCopy,
  FMX.Forms,
  UDbvs in 'UDbvs.pas' {FormDesbravadores},
  UDM in 'UDM.pas' {DM: TDataModule},
  UInicial in 'UInicial.pas' {FormInicial},
  ULogin in 'ULogin.pas' {FormLogin},
  UPrincipal in 'UPrincipal.pas' {FormPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormDesbravadores, FormDesbravadores);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFormInicial, FormInicial);
  Application.CreateForm(TFormLogin, FormLogin);
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TFormInicial, FormInicial);
  Application.FormFactor.Orientations := [TFormOrientation.Portrait];
end.
