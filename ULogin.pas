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
    Image2: TImage;
    Label1: TLabel;
    Rectangle2: TRectangle;
    EdtLogin_Email: TEdit;
    Rectangle3: TRectangle;
    EdtLogin_Senha: TEdit;
    BtnLogin: TRectangle;
    Label2: TLabel;
    Layout4: TLayout;
    Image3: TImage;
    Layout5: TLayout;
    Rectangle4: TRectangle;
    EdtConta_Nome: TEdit;
    Rectangle5: TRectangle;
    EdtConta_Senha: TEdit;
    BtnCadastrar: TRectangle;
    Label3: TLabel;
    Layout6: TLayout;
    Label4: TLabel;
    Rectangle7: TRectangle;
    EdtConta_Email: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.fmx}

uses UDM, UPrincipal;

procedure TFormLogin.BtnLoginClick(Sender: TObject);
var
  erro: string;
  id_usuario: integer;
begin
  if not DM.ValidaLogin(EdtLogin_Email.Text, EdtLogin_Senha.Text, id_usuario, erro) then
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

procedure TFormLogin.FormCreate(Sender: TObject);
begin
  TabControl1.ActiveTab := TabInicial;

  //configurar servidor
  {$IFDEF DEBUG}
  DM.RESTClient.BaseURL := 'http://localhost:8082';
  {$ELSE}
  DM.RESTClient.BaseURL := 'http://localhost:8082';
  {$ENDIF}
end;

procedure TFormLogin.FormShow(Sender: TObject);
begin
  TabControl1.GotoVisibleTab(1, TTabTransition.Slide);
end;

end.
