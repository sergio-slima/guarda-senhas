unit UPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.TabControl, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, System.JSON, FMX.Advertising,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, System.Actions, FMX.ActnList;

type
  TFormPrincipal = class(TForm)
    Layout1: TLayout;
    ImgAba1: TImage;
    ImgAba2: TImage;
    ImgAba3: TImage;
    ImgAba4: TImage;
    TabControl: TTabControl;
    TabAba1: TTabItem;
    TabAba2: TTabItem;
    TabAba3: TTabItem;
    Layout4: TLayout;
    Image5: TImage;
    Layout2: TLayout;
    RtgCidade: TRectangle;
    EdtPesquisarSenhas: TEdit;
    BtnPesquisar: TImage;
    Layout3: TLayout;
    Label1: TLabel;
    BtnHome: TImage;
    Layout6: TLayout;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    lvExplorar: TListView;
    Line1: TLine;
    Line2: TLine;
    Image1: TImage;
    BtnNovo: TImage;
    Layout5: TLayout;
    BannerAd1: TBannerAd;
    lvSenhas: TListView;
    BtnFavorito: TImage;
    ActionList1: TActionList;
    ActTab01: TChangeTabAction;
    ActTab02: TChangeTabAction;
    Layout7: TLayout;
    Rectangle7: TRectangle;
    EdtDescricao: TEdit;
    Layout8: TLayout;
    Rectangle2: TRectangle;
    EdtSenha: TEdit;
    ImgNaoVer: TImage;
    ImgVer: TImage;
    Layout9: TLayout;
    Rectangle3: TRectangle;
    EdtTipo: TEdit;
    Rectangle4: TRectangle;
    Label2: TLabel;
    swFavorito: TSwitch;
    Rectangle5: TRectangle;
    EdtLogin: TEdit;
    Layout10: TLayout;
    Label3: TLabel;
    BtnVoltar: TImage;
    Line3: TLine;
    BtnSalvar: TImage;
    ActTab03: TChangeTabAction;
    procedure FormShow(Sender: TObject);
    procedure ImgAba4Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure EdtPesquisarSenhasExit(Sender: TObject);
    procedure LbxCategoriasItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure BtnPesquisarClick(Sender: TObject);
    procedure BtnVoltarClick(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure ImgNaoVerClick(Sender: TObject);
    procedure ImgVerClick(Sender: TObject);
    procedure BtnFavoritoClick(Sender: TObject);
    procedure BtnHomeClick(Sender: TObject);
  private
    procedure MudarAba(img: TImage);
    procedure VerSenha;
    procedure AddFiltrarSenhas(id_senha, descricao, login, senha, favorito: String; id_categoria: integer);
    { Private declarations }
  public
    { Public declarations }
    id_categoria_global : integer;
    id_usuario_global : integer;
    ind_fechar_telas : boolean;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.fmx}

uses UDM, UTipo;

procedure TFormPrincipal.MudarAba(img: TImage);
begin
  ImgAba1.Opacity := 0.5;
  ImgAba2.Opacity := 0.5;
  ImgAba3.Opacity := 0.5;
  ImgAba4.Opacity := 0.5;

  img.Opacity := 1;
  TabControl.GotoVisibleTab(img.Tag, TTabTransition.Slide);


end;

procedure TFormPrincipal.VerSenha;
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

procedure TFormPrincipal.AddFiltrarSenhas(id_senha, descricao, login, senha,
  favorito: String; id_categoria: integer);
begin
/////////
end;

procedure TFormPrincipal.EdtPesquisarSenhasExit(Sender: TObject);
begin
  //CarregarCategorias(EdtPesquisarSenhas.Text);
end;

procedure TFormPrincipal.FormResize(Sender: TObject);
begin
  //LbxCategorias.Columns := Trunc(LbxCategorias.Width / 105);
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
  ActTab01.Execute;
  //CarregarCategorias(EdtPesquisarSenhas.Text);
  //CarregarExplorar('','');
  //CarregarAgendamentos;
end;

procedure TFormPrincipal.BtnNovoClick(Sender: TObject);
begin
  ImgVer.Visible:=False;
  ImgNaoVer.Visible:=True;
  ActTab03.Execute;
end;

procedure TFormPrincipal.BtnPesquisarClick(Sender: TObject);
var
  qry : TFDQuery;
begin

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := DM.Conexao;

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('SELECT * FROM SENHAS');
    qry.SQL.Add('WHERE DESCRICAO LIKE :DESCRICAO');
    qry.ParamByName('DESCRICAO').Value := '%';
    qry.Open;

    lvSenhas.BeginUpdate;
    if qry.RecordCount > 0 then
    begin
      while not qry.eof do
      begin
        AddFiltrarSenhas();

        qry.next;
      end;
    end;
    lvSenhas.EndUpdate;

  finally
    qry.DisposeOf;
  end;
end;

procedure TFormPrincipal.BtnSalvarClick(Sender: TObject);
var
  erro, favorito: string;
begin
  if (EdtDescricao.Text = '') then
  begin
    ShowMessage('Digite uma descri��o!');
    Exit;
  end;

  if (EdtLogin.Text = '') or
     (EdtSenha.Text = '') then
  begin
    ShowMessage('Digite o login e senha!');
    Exit;
  end;

  if swFavorito.isChecked then
    favorito = 'S'
  else
    favorito = 'N';

  if not DM.SalvarSenhas(EdtDescricao.Text,
                         EdtLogin.Text,
                         EdtSenha.Text,
                         favorito,
                         erro) then
  begin
    ShowMessage(erro);
    Exit;
  end else
  begin
    ShowMessage('Conta cadastrado com sucesso. Fa�a o Login!');
    Close
  end;

end;

procedure TFormPrincipal.BtnVoltarClick(Sender: TObject);
begin
  ActTab01.Execute;
end;

procedure TFormPrincipal.BtnFavoritoClick(Sender: TObject);
begin
  ActTab02.Execute;
end;

procedure TFormPrincipal.BtnHomeClick(Sender: TObject);
begin
  ActTab01.Execute;
end;

procedure TFormPrincipal.ImgAba4Click(Sender: TObject);
begin
  MudarAba(TImage(Sender));
end;

procedure TFormPrincipal.ImgNaoVerClick(Sender: TObject);
begin
  VerSenha;
end;

procedure TFormPrincipal.ImgVerClick(Sender: TObject);
begin
  VerSenha;
end;

procedure TFormPrincipal.LbxCategoriasItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  //CarregarExplorar(EdtPesquisarSenhas.Text, '', item.Tag);
  MudarAba(ImgAba2);
end;

end.
