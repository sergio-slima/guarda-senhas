unit USenha;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit;

type
  TFormSenhas = class(TForm)
    Layout3: TLayout;
    Label1: TLabel;
    BtnExplorar_Voltar: TImage;
    Line2: TLine;
    Image1: TImage;
    Layout1: TLayout;
    Rectangle7: TRectangle;
    EdtDescricao: TEdit;
    Rectangle1: TRectangle;
    EdtSenha: TEdit;
    Layout2: TLayout;
    ImgNaoVer: TImage;
    ImgVer: TImage;
    Rectangle2: TRectangle;
    EdtTipo: TEdit;
    Layout4: TLayout;
    Rectangle3: TRectangle;
    Label2: TLabel;
    swFavorito: TSwitch;
    Rectangle4: TRectangle;
    EdtLogin: TEdit;
    procedure FormShow(Sender: TObject);
    procedure ImgVerClick(Sender: TObject);
    procedure ImgNaoVerClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
    procedure VerSenha;
  public
    { Public declarations }
  end;

var
  FormSenhas: TFormSenhas;

implementation

{$R *.fmx}

procedure TFormSenhas.FormShow(Sender: TObject);
begin
  ImgVer.Visible:=False;
  ImgNaoVer.Visible:=True;
end;

procedure TFormSenhas.Image1Click(Sender: TObject);
var
  erro: string;
begin
  if (EdtDescricao.Text = '') then
  begin
    ShowMessage('Digite uma descrição!');
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
      TabControl1.GotoVisibleTab(1, TTabTransition.Slide);
    end;
end;

procedure TFormSenhas.ImgNaoVerClick(Sender: TObject);
begin
  VerSenha;
end;

procedure TFormSenhas.ImgVerClick(Sender: TObject);
begin
  VerSenha;
end;

procedure TFormSenhas.VerSenha;
begin
  if EdtSenha.Password = True then
  begin
    EdtSenha.Password:=False;
    ImgNaoVer.Visible:=False;
    ImgVer.Visible:=True;
  end else
  begin
    EdtSenha.Password:=True;
    ImgVer.Visible:=False;
    ImgNaoVer.Visible:=True;
  end;
end;

end.
