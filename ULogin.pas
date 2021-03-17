unit ULogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Objects, FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit;

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
    Label2: TLabel;
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
    Label4: TLabel;
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
  private
    { Private declarations }
  public
    { Public declarations }
    conta_status: String;
  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.fmx}

uses UDM, UPrincipal;

procedure TFormLogin.BtnAcessarClick(Sender: TObject);
var
  erro: string;
  id_usuario: integer;
begin
  if not DM.ValidaSenha(EdtSenha.Text, id_usuario, erro) then
  begin
    ShowMessage(erro);
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
    ShowMessage('Preencha todos os campos!');
    Exit;
  end;

  if conta_status = 'N' then
  begin
    if not DM.CadastrarSenha(EdtConta_Email.Text, EdtConta_Nascimento.Text, EdtConta_Senha.Text, erro) then
    begin
      ShowMessage(erro);
      Exit;
    end else
    begin
      ShowMessage('Conta cadastrado com sucesso. Faça o Login!');
      TabControl1.ActiveTab := TabLogin;
    end;
  end else if conta_status = 'A' then
    if not DM.ResetarSenha(EdtConta_Email.Text, EdtConta_Nascimento.Text, EdtConta_Senha.Text, erro) then
    begin
      ShowMessage(erro);
      Exit;
    end else
    begin
      ShowMessage('Senha resetada com sucesso. Faça o Login!');
      TabControl1.ActiveTab := TabLogin;
    end;
end;

procedure TFormLogin.FormCreate(Sender: TObject);
begin
  TabControl1.ActiveTab := TabInicial;

end;

procedure TFormLogin.FormShow(Sender: TObject);
begin
  TabControl1.GotoVisibleTab(1, TTabTransition.Slide);
end;

procedure TFormLogin.LblNovaContaClick(Sender: TObject);
begin
  TabControl1.ActiveTab := TabNovaConta;
  conta_status:= 'N';
  LblCadastrar.Text:='Cadastrar nova conta';
end;

procedure TFormLogin.LblResetarContaClick(Sender: TObject);
begin
  TabControl1.ActiveTab := TabNovaConta;
  conta_status:= 'A';
  LblCadastrar.Text:='Resetar senha';
end;

end.
