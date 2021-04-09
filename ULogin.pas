unit ULogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  uFormat, uFancyDialog, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TFormLogin = class(TForm)
    TabControl1: TTabControl;
    TabInicial: TTabItem;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
    Rectangle1: TRectangle;
    Image1: TImage;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    LblNovaConta: TLabel;
    Rectangle3: TRectangle;
    EdtSenha: TEdit;
    BtnAcessar: TRectangle;
    LblAcessar: TLabel;
    Layout4: TLayout;
    Image3: TImage;
    Layout5: TLayout;
    Rectangle4: TRectangle;
    EdtConta_Nascimento: TEdit;
    Rectangle5: TRectangle;
    EdtConta_Senha: TEdit;
    BtnCadastrar: TRectangle;
    LblCadastrar: TLabel;
    Layout6: TLayout;
    LblLogin: TLabel;
    Rectangle7: TRectangle;
    EdtConta_Email: TEdit;
    Image2: TImage;
    LblResetarConta: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnAcessarClick(Sender: TObject);
    procedure BtnCadastrarClick(Sender: TObject);
    procedure LblNovaContaClick(Sender: TObject);
    procedure LblResetarContaClick(Sender: TObject);
    procedure LblLoginClick(Sender: TObject);
    procedure EdtConta_NascimentoTyping(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    fancy : TFancyDialog;

    procedure AtualizarLanguage(valor: string);
  public
    { Public declarations }
    conta_status: String;
    id_language: String;
  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.fmx}

uses UDM, UPrincipal;

procedure TFormLogin.AtualizarLanguage(valor: string);
begin
  if valor = 'US' then
  begin
    LblLogin.Text:= 'I already have an account. Click to login';
    LblNovaConta.Text:= 'New Account';
    LblResetarConta.Text:= 'I forgot my password';
    LblAcessar.Text:= 'Log in';
    LblCadastrar.Text:= 'Sign up';
    EdtSenha.TextPrompt:= 'Password';
    EdtConta_Email.TextPrompt:= 'Email';
    EdtConta_Nascimento.TextPrompt:= 'Birth Date';
    EdtConta_Senha.TextPrompt:= 'Password';
  end
  else if valor = 'PT' then
  begin
    LblLogin.Text:= 'Já tenho conta. Clique para fazer login.';
    LblNovaConta.Text:= 'Cadastrar nova conta';
    LblResetarConta.Text:= 'Esqueci minha senha';
    LblAcessar.Text:= 'Acessar';
    LblCadastrar.Text:= 'Cadastrar nova conta';
    EdtSenha.TextPrompt:= 'Senha';
    EdtConta_Email.TextPrompt:= 'Email';
    EdtConta_Nascimento.TextPrompt:= 'Data Nascimento';
    EdtConta_Senha.TextPrompt:= 'Senha';
  end;
end;

procedure TFormLogin.BtnAcessarClick(Sender: TObject);
var
  erro: string;
  id_usuario: integer;
begin
  if EdtSenha.Text = '' then
  begin
    if id_language = 'US' then
      fancy.Show(TIconDialog.Info, 'Ops!', 'Password required.', 'TRY AGAIN')
    else
      fancy.Show(TIconDialog.Info, 'Ops!', 'Digite sua senha.', 'OK');
    Exit;
  end;
  if not DM.ValidaSenha(EdtSenha.Text, id_usuario, erro) then
  begin
    fancy.Show(TIconDialog.Error, 'Erro', erro, 'OK');
    Exit;
  end;

  if not Assigned(FormPrincipal) then
    Application.CreateForm(TFormPrincipal, FormPrincipal);

  FormPrincipal.id_usuario_global := id_usuario;
  FormPrincipal.Show;
  Application.MainForm := FormPrincipal;
  FormLogin.Close;
end;

procedure TFormLogin.BtnCadastrarClick(Sender: TObject);
var
  erro: string;
  id_usuario: integer;
begin
  if (EdtConta_Email.Text = '') and
     (EdtConta_Nascimento.Text = '') and
     (EdtConta_Senha.Text = '') then
  begin
    if id_language = 'US' then
      fancy.Show(TIconDialog.Info, 'Ops!', 'All required fields', 'TRY AGAIN')
    else
      fancy.Show(TIconDialog.Info, 'Ops!', 'Preencha todos os campos', 'OK');
    Exit;
  end;

  if conta_status = 'N' then
  begin
    if not DM.CadastrarSenha(EdtConta_Email.Text,
                             EdtConta_Nascimento.Text,
                             EdtConta_Senha.Text,
                             erro) then
    begin
      ShowMessage(erro);
      Exit;
    end else
    begin
      if id_language = 'US' then
        fancy.Show(TIconDialog.Success, 'Success!', 'Registered Successfully. Login!', 'OK')
      else
        fancy.Show(TIconDialog.Success, 'Success!', 'Cadastrado com Sucesso. Faça o Login!', 'OK');
      TabControl1.ActiveTab := TabLogin;
    end;
  end else if conta_status = 'A' then
  begin
    if not DM.ResetarSenha(EdtConta_Email.Text,
                           EdtConta_Nascimento.Text,
                           EdtConta_Senha.Text,
                           erro) then
    begin
      ShowMessage(erro);
      Exit;
    end else
    begin
      if id_language = 'US' then
        fancy.Show(TIconDialog.Success, 'Success!', 'Registered Successfully. Login!', 'OK')
      else
        fancy.Show(TIconDialog.Success, 'Success!', 'Senha Resetada com Sucesso. Faça o Login!', 'OK');
      TabControl1.GotoVisibleTab(1, TTabTransition.Slide);
    end;
  end;
end;

procedure TFormLogin.EdtConta_NascimentoTyping(Sender: TObject);
begin
  Formatar(EdtConta_Nascimento, TFormato.Dt);
end;

procedure TFormLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fancy.DisposeOf;
end;

procedure TFormLogin.FormCreate(Sender: TObject);
begin
  fancy := TFancyDialog.Create(FormLogin);

  TabControl1.ActiveTab := TabInicial;
end;

procedure TFormLogin.FormShow(Sender: TObject);
var
  language, erro: string;
begin
  TabControl1.GotoVisibleTab(1, TTabTransition.Slide);

  if DM.ValidaLanguage(language, erro) then
    id_language:= language
  else
    fancy.Show(TIconDialog.Error, 'Error!', erro, 'OK');
end;

procedure TFormLogin.LblLoginClick(Sender: TObject);
begin
  //TabControl1.ActiveTab := TabLogin;
  TabControl1.GotoVisibleTab(1, TTabTransition.Slide);
end;

procedure TFormLogin.LblNovaContaClick(Sender: TObject);
begin
//  TabControl1.ActiveTab := TabNovaConta;
  conta_status:= 'N';
  if id_language = 'US' then
    LblCadastrar.Text:='Register New Account'
  else
    LblCadastrar.Text:='Cadastrar nova conta';
  TabControl1.GotoVisibleTab(2, TTabTransition.Slide);
end;

procedure TFormLogin.LblResetarContaClick(Sender: TObject);
begin
//  TabControl1.ActiveTab := TabNovaConta;
  conta_status:= 'A';
  if id_language = 'US' then
    LblCadastrar.Text:='Reset Password'
  else
    LblCadastrar.Text:='Resetar senha';
  TabControl1.GotoVisibleTab(2, TTabTransition.Slide);
end;

end.
