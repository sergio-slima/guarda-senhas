unit UInicial;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  System.Actions, FMX.ActnList;

type
  TFormInicial = class(TForm)
    TabControl: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    LytProximo: TLayout;
    Layout2: TLayout;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Layout3: TLayout;
    Image2: TImage;
    Label3: TLabel;
    Label4: TLabel;
    Layout4: TLayout;
    Image3: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Layout5: TLayout;
    Image4: TImage;
    Label7: TLabel;
    StyleBook1: TStyleBook;
    BtnVoltar: TSpeedButton;
    BtnProximo: TSpeedButton;
    ActionList1: TActionList;
    LytBotoes: TLayout;
    BtnLogin: TSpeedButton;
    BtnNovaConta: TSpeedButton;
    ActTab1: TChangeTabAction;
    ActTab2: TChangeTabAction;
    ActTab3: TChangeTabAction;
    ActTab4: TChangeTabAction;
    procedure FormCreate(Sender: TObject);
    procedure NavegacaoAba(cont: integer);
    procedure BtnVoltarClick(Sender: TObject);
    procedure BtnProximoClick(Sender: TObject);
    procedure BtnLoginClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnNovaContaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormInicial: TFormInicial;

implementation

{$R *.fmx}

uses ULogin;

procedure TFormInicial.BtnLoginClick(Sender: TObject);
begin
  if not Assigned(FormLogin) then
    Application.CreateForm(TFormLogin, FormLogin);

  Application.MainForm := FormLogin;
  FormLogin.TabControl1.ActiveTab := FormLogin.TabLogin;
  FormLogin.Show;
  FormInicial.Close;
end;

procedure TFormInicial.BtnNovaContaClick(Sender: TObject);
begin
  if not Assigned(FormLogin) then
    Application.CreateForm(TFormLogin, FormLogin);

  Application.MainForm := FormLogin;
  FormLogin.TabControl1.ActiveTab := FormLogin.TabConta;
  FormLogin.Show;
  FormInicial.Close;
end;

procedure TFormInicial.BtnProximoClick(Sender: TObject);
begin
  NavegacaoAba(1);
end;

procedure TFormInicial.BtnVoltarClick(Sender: TObject);
begin
  NavegacaoAba(-1);
end;

procedure TFormInicial.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FormInicial := nil;
end;

procedure TFormInicial.FormCreate(Sender: TObject);
begin
  TabControl.TabPosition := TTabPosition.None;
  TabControl.ActiveTab := TabItem1;
  lytProximo.Visible:=True;
  lytBotoes.Visible:=False;
  NavegacaoAba(-1);
end;

procedure TFormInicial.NavegacaoAba(cont: integer);
begin
  //Proximo..
  if cont > 0 then
  begin
    case TabControl.TabIndex of
      0: ActTab2.Execute;
      1: ActTab3.Execute;
      2: ActTab4.Execute;
    end;
  end
  else
  //Voltar..
  begin
    case TabControl.TabIndex of
      3: ActTab3.Execute;
      2: ActTab2.Execute;
      1: ActTab1.Execute;
    end;
  end;

  // tratando botao
  BtnVoltar.Visible:= True;
  BtnProximo.Visible:= True;

  if TabControl.TabIndex = 0 then
    BtnVoltar.Visible := False
  else if TabControl.TabIndex = 3 then
  begin
    lytProximo.Visible:= False;
    lytBotoes.Visible:=True;
  end;
end;

end.
