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
    FDQuery1: TFDQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnAcessarClick(Sender: TObject);
    procedure BtnCadastrarClick(Sender: TObject);
    procedure LblNovaContaClick(Sender: TObject);
    procedure LblResetarContaClick(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure EdtConta_NascimentoTyping(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    fancy : TFancyDialog;

    procedure BuscarLanguage;
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
  if EdtSenha.Text = '' then
  begin
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
      fancy.Show(TIconDialog.Success, 'Success', 'Cadastrado com Sucesso. Faça o Login!', 'OK');
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
      fancy.Show(TIconDialog.Success, 'Success', 'Senha Resetada com Sucesso. Faça o Login!', 'OK');
      TabControl1.GotoVisibleTab(1, TTabTransition.Slide);
    end;
  end;
end;

procedure TFormLogin.BuscarLanguage;
var
  qry : TFDQuery;
begin

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := DM.Conexao;

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('SELECT * FROM CONFIG');
    qry.Open;

    if qry.RecordCount > 0 then
      FormPrincipal.id_language_global:= qry.FieldByName('LANGUAGE').AsString
    else
      fancy.Show(TIconDialog.Error, 'Error', 'Language not found!', 'OK');
  finally
    qry.DisposeOf;
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
begin
  TabControl1.GotoVisibleTab(1, TTabTransition.Slide);

  BuscarLanguage;
end;

procedure TFormLogin.Label4Click(Sender: TObject);
begin
  //TabControl1.ActiveTab := TabLogin;
  TabControl1.GotoVisibleTab(1, TTabTransition.Slide);
end;

procedure TFormLogin.LblNovaContaClick(Sender: TObject);
begin
//  TabControl1.ActiveTab := TabNovaConta;
  conta_status:= 'N';
  LblCadastrar.Text:='Cadastrar nova conta';
  TabControl1.GotoVisibleTab(2, TTabTransition.Slide);
end;

procedure TFormLogin.LblResetarContaClick(Sender: TObject);
begin
//  TabControl1.ActiveTab := TabNovaConta;
  conta_status:= 'A';
  LblCadastrar.Text:='Resetar senha';
  TabControl1.GotoVisibleTab(2, TTabTransition.Slide);
end;

end.
