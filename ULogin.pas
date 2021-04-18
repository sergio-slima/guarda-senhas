unit ULogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit,
  uFormat, uFancyDialog, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  {$IFDEF ANDROID}
  Android.KeyguardManager,
  {$ENDIF}
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.Ani;

type
  TFormLogin = class(TForm)
    TabControl1: TTabControl;
    TabInicial: TTabItem;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
    Rectangle1: TRectangle;
    Image1: TImage;
    Layout1: TLayout;
    Layout3: TLayout;
    Rectangle3: TRectangle;
    EdtSenha: TEdit;
    BtnAcessar: TRectangle;
    LblAcessar: TLabel;
    Layout4: TLayout;
    Layout5: TLayout;
    Rectangle4: TRectangle;
    EdtConta_Nascimento: TEdit;
    Rectangle5: TRectangle;
    EdtConta_Senha: TEdit;
    BtnCadastrar: TRectangle;
    LblCadastrar: TLabel;
    Rectangle7: TRectangle;
    EdtConta_Email: TEdit;
    layout_menu: TLayout;
    Arc1: TArc;
    FloatAnimation1: TFloatAnimation;
    img_digital: TImage;
    LblDigital: TLabel;
    Layout2: TLayout;
    BtnBiometria: TSwitch;
    LblLeitor: TLabel;
    Image4: TImage;
    Image3: TImage;
    Image2: TImage;
    BtnEnUs: TImage;
    BtnResetar: TImage;
    BtnPtBr: TImage;
    FDQuery1: TFDQuery;
    BtnVoltar: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnAcessarClick(Sender: TObject);
    procedure BtnCadastrarClick(Sender: TObject);
    procedure LblNovaContaClick(Sender: TObject);
    procedure LblResetarContaClick(Sender: TObject);
    procedure LblLoginClick(Sender: TObject);
    procedure EdtConta_NascimentoTyping(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LblLeitorClick(Sender: TObject);
    procedure img_digitalClick(Sender: TObject);
    procedure BtnEnUsClick(Sender: TObject);
    procedure BtnPtBrClick(Sender: TObject);
    procedure BtnResetarClick(Sender: TObject);
    procedure BtnVoltarClick(Sender: TObject);
  private
    { Private declarations }
    fancy : TFancyDialog;

    procedure AtualizarLanguage(valor: string);
    procedure UpdateLanguage(valor: string);

    {$IFDEF ANDROID}
    procedure Autenticar;
    {$ENDIF}
    procedure Sucesso(Sender: TObject);
    procedure Erro(Sender: TObject);
  public
    { Public declarations }
    id_language: String;
    status_user: String;
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
    //LblLogin.Text:= 'I already have an account. Click to login';
//    LblNovaConta.Text:= 'New Account';
//    LblResetarConta.Text:= 'I forgot my password';
    LblAcessar.Text:= 'Log in';
    LblCadastrar.Text:= 'Sign up';
    LblLeitor.Text:= 'Sensor Digital';
    LblDigital.Text:= 'Touch digital sensor for authentication';
    EdtSenha.TextPrompt:= 'Password';
    EdtConta_Email.TextPrompt:= 'Email';
    EdtConta_Nascimento.TextPrompt:= 'Birth Date';
    EdtConta_Senha.TextPrompt:= 'Password';
    BtnEnUs.Visible:= True;
    BtnPtBr.Visible:= False;
  end
  else
  begin
   // LblLogin.Text:= 'Já tenho conta. Clique para fazer login.';
//    LblNovaConta.Text:= 'Cadastrar nova conta';
//    LblResetarConta.Text:= 'Esqueci minha senha';
    LblAcessar.Text:= 'Acessar';
    LblCadastrar.Text:= 'Cadastrar nova conta';
    LblLeitor.Text:= 'Leitor Digital';
    LblDigital.Text:= 'Toque no sensor de digital para autenticação';
    EdtSenha.TextPrompt:= 'Senha';
    EdtConta_Email.TextPrompt:= 'Email';
    EdtConta_Nascimento.TextPrompt:= 'Data Nascimento';
    EdtConta_Senha.TextPrompt:= 'Senha';
    BtnEnUs.Visible:= False;
    BtnPtBr.Visible:= True;
  end;
end;

{$IFDEF ANDROID}
procedure TFormLogin.Autenticar;
var
  Android: TEventResultClass;
begin
  Android:= TEventResultClass.Create(Self);

  if Android.DeviceSecure then
    Android.StartActivityKeyGuard(Sucesso, Erro);
end;
{$ENDIF}

procedure TFormLogin.BtnAcessarClick(Sender: TObject);
var
  erro: string;
  id_usuario: integer;
begin
  if EdtSenha.Text = '' then
  begin
    if id_language = 'US' then
      fancy.Show(TIconDialog.Warning, 'Ops!', 'Password required.', 'TRY AGAIN')
    else
      fancy.Show(TIconDialog.Warning, 'Ops!', 'Digite sua senha.', 'OK');
    Exit;
  end;
  if not DM.ValidaSenha(EdtSenha.Text, erro) then
  begin
    fancy.Show(TIconDialog.Error, 'Erro', erro, 'OK');
    Exit;
  end;

  if not Assigned(FormPrincipal) then
    Application.CreateForm(TFormPrincipal, FormPrincipal);

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
      fancy.Show(TIconDialog.Warning, 'Ops!', 'All required fields', 'TRY AGAIN')
    else
      fancy.Show(TIconDialog.Warning, 'Ops!', 'Preencha todos os campos', 'OK');
    Exit;
  end;

  if status_user = 'N' then
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

      EdtConta_Email.Text:= '';
      EdtConta_Nascimento.Text:= '';
      EdtConta_Senha.Text:= '';
    end;
  end else
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
        fancy.Show(TIconDialog.Success, 'Success!', 'Cadastrado com Sucesso. Faça o Login!', 'OK');

      TabControl1.ActiveTab := TabLogin;

      EdtConta_Email.Text:= '';
      EdtConta_Nascimento.Text:= '';
      EdtConta_Senha.Text:= '';
    end;
  end;
end;

procedure TFormLogin.EdtConta_NascimentoTyping(Sender: TObject);
begin
  Formatar(EdtConta_Nascimento, TFormato.Dt);
end;

procedure TFormLogin.Erro(Sender: TObject);
begin
  fancy.Show(TIconDialog.Error, 'Error!', 'Failed na authentication', 'OK');
  Exit;
end;

procedure TFormLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fancy.DisposeOf;
end;

procedure TFormLogin.FormCreate(Sender: TObject);
var
  language, erro: string;
begin
  fancy := TFancyDialog.Create(FormLogin);

  layout_menu.Margins.Bottom := -220;
  status_user:= 'N';
  TabControl1.ActiveTab := TabInicial;

  if DM.ValidaLanguage(language, erro) then
    id_language:= language
  else
    fancy.Show(TIconDialog.Error, 'Error!', erro, 'OK');

  AtualizarLanguage(id_language);

end;

procedure TFormLogin.FormShow(Sender: TObject);
var
  erro: string;
begin
  if not DM.ValidaSenha('', erro) then
    TabControl1.GotoVisibleTab(2, TTabTransition.Slide)
  else
    TabControl1.GotoVisibleTab(1, TTabTransition.Slide);

end;

procedure TFormLogin.BtnEnUsClick(Sender: TObject);
begin
  UpdateLanguage('PT');

end;

procedure TFormLogin.BtnPtBrClick(Sender: TObject);
begin
  UpdateLanguage('US');
end;

procedure TFormLogin.BtnResetarClick(Sender: TObject);
begin
  status_user:= 'R';

  if id_language = 'US' then
  begin
    LblCadastrar.Text:='Reset Password';
    EdtConta_Senha.TextPrompt:='New Password';
  end else
  begin
    LblCadastrar.Text:='Resetar Senha';
    EdtConta_Senha.TextPrompt:='Nova Senha';
  end;
  TabControl1.GotoVisibleTab(2, TTabTransition.Slide);
end;

procedure TFormLogin.BtnVoltarClick(Sender: TObject);
begin
  TabControl1.GotoVisibleTab(1, TTabTransition.Slide);
end;

procedure TFormLogin.img_digitalClick(Sender: TObject);
begin
  {$IFDEF ANDROID}
  Autenticar;
  {$ENDIF}
end;

procedure TFormLogin.LblLeitorClick(Sender: TObject);
begin
    if layout_menu.Tag = 0 then
    begin
        BtnBiometria.IsChecked:= True;
        layout_menu.Tag := 1;
        layout_menu.AnimateFloat('Margins.Bottom', 0, 0.3,
                                 TAnimationType.&In, TInterpolationType.Circular);
    end
    else
    begin
        BtnBiometria.IsChecked:= False;
        layout_menu.Tag := 0;
        layout_menu.AnimateFloat('Margins.Bottom', -220, 0.3,
                                 TAnimationType.&In, TInterpolationType.Circular);
    end;
end;

procedure TFormLogin.LblLoginClick(Sender: TObject);
begin
  //TabControl1.ActiveTab := TabLogin;
  TabControl1.GotoVisibleTab(1, TTabTransition.Slide);
end;

procedure TFormLogin.LblNovaContaClick(Sender: TObject);
begin
//  TabControl1.ActiveTab := TabNovaConta;
  if id_language = 'US' then
    LblCadastrar.Text:='Register New Account'
  else
    LblCadastrar.Text:='Cadastrar nova conta';
  TabControl1.GotoVisibleTab(2, TTabTransition.Slide);
end;

procedure TFormLogin.LblResetarContaClick(Sender: TObject);
begin
//  TabControl1.ActiveTab := TabNovaConta;
//  if id_language = 'US' then
//    LblCadastrar.Text:='Reset Password'
//  else
//    LblCadastrar.Text:='Resetar senha';
//  TabControl1.GotoVisibleTab(2, TTabTransition.Slide);
end;

procedure TFormLogin.Sucesso(Sender: TObject);
begin
  if not Assigned(FormPrincipal) then
    Application.CreateForm(TFormPrincipal, FormPrincipal);

  Application.MainForm := FormPrincipal;
  FormPrincipal.Show;
  FormLogin.Close;
end;

procedure TFormLogin.UpdateLanguage(valor: string);
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := DM.Conexao;
    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('UPDATE CONFIG SET LANGUAGE = :LANGUAGE');
    qry.SQL.Add('WHERE LANGUAGE = :LANG_ATUAL');
    qry.ParamByName('LANGUAGE').Value := valor;
    qry.ParamByName('LANG_ATUAL').Value := id_language;
    qry.ExecSQL;

    qry.DisposeOf;

    AtualizarLanguage(valor);
  except on ex:Exception do
    fancy.Show(TIconDialog.Error, 'Error!', ex.Message, 'OK');
  end;
end;

end.
