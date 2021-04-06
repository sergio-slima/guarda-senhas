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
  FireDAC.Comp.Client, System.Actions, FMX.ActnList, uFancyDialog;

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
    EdtPesquisarFavoritos: TEdit;
    Line1: TLine;
    Line2: TLine;
    BtnPesquisarFavoritos: TImage;
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
    RtgTpo: TRectangle;
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
    ImgExcluir: TImage;
    ImgVerSenha: TImage;
    Img00: TImage;
    Img07: TImage;
    Img06: TImage;
    Img05: TImage;
    Img04: TImage;
    Img03: TImage;
    Img02: TImage;
    Img01: TImage;
    lvFavoritos: TListView;
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
    procedure lvSenhasUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure RtgTpoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BtnPesquisarFavoritosClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure lvSenhasItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
  private
    fancy : TFancyDialog;

    procedure ClickLogout;
    procedure LimpaEdits;
    procedure MudarAba(img: TImage);
    procedure VerSenha;
    procedure ListarSenhas(descricao: string);
    procedure ListarFavoritos(descricao: string);
    procedure AddSenhas(id_senha, descricao, login, senha, favorito, tipo: String);
    procedure AddFavoritos(id_senha, descricao, login, senha, favorito, tipo: String);
    procedure Deletar(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    id_categoria_global : integer;
    id_usuario_global : integer;
    ind_fechar_telas : boolean;
    id_senha_global: integer;

    CodTipo_Selecao : String;
    NomTipo_Selecao : String;
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

procedure TFormPrincipal.RtgTpoClick(Sender: TObject);
begin
  if not Assigned(FormTipos) then
    Application.CreateForm(TFormTipos, FormTipos);

  FormTipos.ShowModal(procedure(ModalResult: TModalResult)
                             begin
                               if CodTipo_Selecao <> '' then
                                 EdtTipo.Text := NomTipo_Selecao;
                             end);
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

procedure TFormPrincipal.AddSenhas(id_senha, descricao, login, senha, favorito, tipo: String);
var
  item : TListViewItem;
  txt : TListItemText;
  img : TListItemImage;
begin
  try
    item := lvSenhas.Items.Add;
    with item do
    begin

      Detail := id_senha;

      // Descricao
      txt := TListItemText(Objects.FindDrawable('TxtDescricao'));
      txt.Text := descricao;

       // Login
      txt := TListItemText(Objects.FindDrawable('TxtLogin'));
      txt.Text := login;

       // Imagem Tipo
      img := TListItemImage(Objects.FindDrawable('ImageTipo'));
      if tipo = '01' then
        img.Bitmap := Img01.Bitmap
      else if tipo = '02' then
        img.Bitmap := Img02.Bitmap
      else if tipo = '03' then
        img.Bitmap := Img03.Bitmap
      else if tipo = '04' then
        img.Bitmap := Img04.Bitmap
      else if tipo = '05' then
        img.Bitmap := Img05.Bitmap
      else if tipo = '06' then
        img.Bitmap := Img06.Bitmap
      else if tipo = '07' then
        img.Bitmap := Img07.Bitmap
      else if tipo = '00' then
        img.Bitmap := Img00.Bitmap;

       // Imagem Ver
      img := TListItemImage(Objects.FindDrawable('ImageVer'));
      img.Bitmap := ImgVerSenha.Bitmap;

       // Imagem Excluir
      img := TListItemImage(Objects.FindDrawable('ImageExcluir'));
      img.Bitmap := ImgExcluir.Bitmap;

    end;
  except on ex:Exception do
    fancy.Show(TIconDialog.Error, 'Erro', 'Erro ao adicionar lista de senhas: '+ex.message, 'OK');
  end;
end;

procedure TFormPrincipal.AddFavoritos(id_senha, descricao, login, senha, favorito, tipo: String);
var
  item : TListViewItem;
  txt : TListItemText;
  img : TListItemImage;
begin
  try
    item := lvFavoritos.Items.Add;
    with item do
    begin

      Detail := id_senha;

      // Descricao
      txt := TListItemText(Objects.FindDrawable('TxtDescricao'));
      txt.Text := descricao;

       // Login
      txt := TListItemText(Objects.FindDrawable('TxtLogin'));
      txt.Text := login;

       // Imagem Tipo
      img := TListItemImage(Objects.FindDrawable('ImageTipo'));
      if tipo = '01' then
        img.Bitmap := Img01.Bitmap
      else if tipo = '02' then
        img.Bitmap := Img02.Bitmap
      else if tipo = '03' then
        img.Bitmap := Img03.Bitmap
      else if tipo = '04' then
        img.Bitmap := Img04.Bitmap
      else if tipo = '05' then
        img.Bitmap := Img05.Bitmap
      else if tipo = '06' then
        img.Bitmap := Img06.Bitmap
      else if tipo = '07' then
        img.Bitmap := Img07.Bitmap
      else if tipo = '00' then
        img.Bitmap := Img00.Bitmap;

       // Imagem Ver
      img := TListItemImage(Objects.FindDrawable('ImageVer'));
      img.Bitmap := ImgVerSenha.Bitmap;

       // Imagem Ver
      img := TListItemImage(Objects.FindDrawable('ImageExcluir'));
      img.Bitmap := ImgExcluir.Bitmap;

    end;
  except on ex:Exception do
    fancy.Show(TIconDialog.Error, 'Erro', 'Erro ao adicionar lista de senhas: '+ex.message, 'OK');
  end;
end;

procedure TFormPrincipal.EdtPesquisarSenhasExit(Sender: TObject);
begin
  //CarregarCategorias(EdtPesquisarSenhas.Text);
end;

procedure TFormPrincipal.Deletar(Sender: TObject);
var
  erro: String;
begin
  if not DM.ExcluirSenhas(id_senha_global, erro) then
  begin
    fancy.Show(TIconDialog.Error, 'Erro', 'Erro ao excluir: '+erro, 'OK');
    exit;
  end else
  begin
    fancy.Show(TIconDialog.Success, 'Success', 'Registro excluido!', 'OK');
    ListarSenhas('');
  end;
end;

procedure TFormPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fancy.DisposeOf;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
begin
  fancy := TFancyDialog.Create(FormPrincipal);

  Img01.Visible := False;
  Img02.Visible := False;
  Img03.Visible := False;
  Img04.Visible := False;
  Img05.Visible := False;
  Img06.Visible := False;
  Img07.Visible := False;
  Img00.Visible := False;

  imgVerSenha.Visible := False;
  imgExcluir.Visible := False;

  TabControl.ActiveTab := TabAba1;

end;

procedure TFormPrincipal.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
{$IFDEF ANDROID}
var
  FService: IFMXVirtualKeyboardService;
{$ENDIF}
begin
{$IFDEF ANDROID}
  if (Key = vkHardwareBack) then
  begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));

    if (FService <> nil) and (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
    begin
      //botao back pressionado e teclado visivel
      //apenas fecha teclado
    end else
    begin
      if (TabControl.ActiveTab = Tab02) or
         (TabControl.ActiveTab = Tab03) then
      begin
        Key := 0;
        ActTab01.Execute;
      end else
      begin
        Key := 0;
        fancy.Show(TIconDialog.Question, 'Logout', 'Deseja sair?', 'Sim', ClickLogout, 'Não');
      end;
    end;
  end;
{$ENDIF}
end;

procedure TFormPrincipal.FormResize(Sender: TObject);
begin
  //LbxCategorias.Columns := Trunc(LbxCategorias.Width / 105);
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
  ActTab01.Execute;
  ListarSenhas('');
end;

procedure TFormPrincipal.BtnNovoClick(Sender: TObject);
begin
  ImgVer.Visible:=False;
  ImgNaoVer.Visible:=True;
  ActTab03.Execute;
end;

procedure TFormPrincipal.BtnPesquisarClick(Sender: TObject);
begin
  ListarSenhas(EdtPesquisarSenhas.Text);
end;

procedure TFormPrincipal.BtnPesquisarFavoritosClick(Sender: TObject);
begin
  ListarFavoritos(EdtPesquisarFavoritos.Text);
end;

procedure TFormPrincipal.BtnSalvarClick(Sender: TObject);
var
  erro, favorito: string;
begin
  if (EdtDescricao.Text = '') then
  begin
    ShowMessage('Digite uma descrição!');
    Exit;
  end;

  if (EdtLogin.Text = '') or
     (EdtSenha.Text = '') then
  begin
    ShowMessage('Digite o login e senha!');
    Exit;
  end;

  if swFavorito.isChecked then
    favorito:= 'S'
  else
    favorito:= 'N';

  if not DM.SalvarSenhas(EdtDescricao.Text,
                         EdtLogin.Text,
                         EdtSenha.Text,
                         favorito,
                         codtipo_selecao,
                         id_usuario_global,
                         erro) then
  begin
    fancy.Show(TIconDialog.Error, 'Ops!', erro, 'OK');
    Exit;
  end else
  begin
    fancy.Show(TIconDialog.Success, 'Concluido!', 'Conta Cadastrada com Sucesso!', 'OK');
    ListarSenhas('');
    ActTab01.Execute;
    LimpaEdits;
  end;

end;

procedure TFormPrincipal.BtnVoltarClick(Sender: TObject);
begin
  ActTab01.Execute;

  LimpaEdits;
end;

procedure TFormPrincipal.ClickLogout;
begin
  Close;
end;

procedure TFormPrincipal.BtnFavoritoClick(Sender: TObject);
begin
  EdtPesquisarFavoritos.Text:= '';
  ListarFavoritos('');
  ActTab02.Execute;
end;

procedure TFormPrincipal.BtnHomeClick(Sender: TObject);
begin
  EdtPesquisarSenhas.Text:= '';
  ListarSenhas('');
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

procedure TFormPrincipal.LimpaEdits;
begin
  EdtDescricao.Text:= '';
  EdtLogin.Text:= '';
  EdtSenha.Text:= '';
  EdtTipo.Text:= '';
  swFavorito.IsChecked:= False;
end;

procedure TFormPrincipal.ListarFavoritos(descricao: string);
var
  qry : TFDQuery;
begin

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := DM.Conexao;

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('SELECT * FROM SENHAS');
    qry.SQL.Add('WHERE FAVORITO = :FAVORITO');
    qry.SQL.Add('AND ID_USUARIO = :ID_USUARIO');
    if EdtPesquisarFavoritos.Text <> '' then
    begin
      qry.SQL.Add('AND DESCRICAO LIKE :DESCRICAO');
      qry.ParamByName('DESCRICAO').Value := '%'+EdtPesquisarFavoritos.Text+'%';
    end;
    qry.SQL.Add('ORDER BY DESCRICAO');
    qry.ParamByName('FAVORITO').Value := 'S';
    qry.ParamByName('ID_USUARIO').Value := id_usuario_global;
    qry.Open;

    lvFavoritos.Items.Clear;

    lvFavoritos.BeginUpdate;
    if qry.RecordCount > 0 then
    begin
      while not qry.eof do
      begin
        AddFavoritos(qry.FieldByName('id_senha').Value,
                     qry.FieldByName('descricao').AsString,
                     qry.FieldByName('login').AsString,
                     qry.FieldByName('senha').AsString,
                     qry.FieldByName('favorito').AsString,
                     qry.FieldByName('tipo').AsString);

        qry.next;
      end;
    end;
    lvFavoritos.EndUpdate;

  finally
    qry.DisposeOf;
  end;
end;

procedure TFormPrincipal.ListarSenhas(descricao: string);
var
  qry : TFDQuery;
begin

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := DM.Conexao;

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('SELECT * FROM SENHAS');
    qry.SQL.Add('WHERE ID_USUARIO = :ID_USUARIO');
    if EdtPesquisarSenhas.Text <> '' then
    begin
      qry.SQL.Add('AND DESCRICAO LIKE :DESCRICAO');
      qry.ParamByName('DESCRICAO').Value := '%'+EdtPesquisarSenhas.Text+'%';
    end;
    qry.ParamByName('ID_USUARIO').Value := id_usuario_global;
    qry.SQL.Add('ORDER BY DESCRICAO');
    qry.Open;

    lvSenhas.Items.Clear;

    lvSenhas.BeginUpdate;
    if qry.RecordCount > 0 then
    begin
      while not qry.eof do
      begin
        AddSenhas(qry.FieldByName('id_senha').Value,
                  qry.FieldByName('descricao').AsString,
                  qry.FieldByName('login').AsString,
                  qry.FieldByName('senha').AsString,
                  qry.FieldByName('favorito').AsString,
                  qry.FieldByName('tipo').AsString);

        qry.next;
      end;
    end;
    lvSenhas.EndUpdate;

  finally
    qry.DisposeOf;
  end;
end;

procedure TFormPrincipal.lvSenhasItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  // CLIQUE NA IMAGEM
  if TListView(sender).Selected <> nil then
  begin
    if ItemObject is TListItemImage then
    begin
      if TListItemImage(ItemObject).Name = 'ImageVer' then
      begin
        fancy.Show(TIconDialog.Success, 'Ops!', 'Em desenvolvimento!', 'OK');
      end;
      if TListItemImage(ItemObject).Name = 'ImageExcluir' then
      begin
        id_senha_global:= StrToInt(lvSenhas.Items[ItemIndex].detail);
        fancy.Show(TIconDialog.Question, 'Excluir', 'Deseja excluir?', 'Sim', Deletar, 'Não');
      end;
    end;
  end;


end;

procedure TFormPrincipal.lvSenhasUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
  txt : TListItemText;
begin
  txt := TListItemText(AItem.Objects.FindDrawable('TxtDescricao'));
  txt.Width:= lvSenhas.Width - 100;

  txt := TListItemText(AItem.Objects.FindDrawable('TxtLogin'));
  txt.Width:= lvSenhas.Width - 100;
end;

end.
