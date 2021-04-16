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
  FireDAC.Comp.Client, System.Actions, FMX.ActnList, uFancyDialog,

  FMX.VirtualKeyboard, FMX.Platform;

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
    Layout2: TLayout;
    RtgCidade: TRectangle;
    EdtPesquisarSenhas: TEdit;
    BtnPesquisar: TImage;
    Layout3: TLayout;
    LblFavoritos: TLabel;
    BtnHome: TImage;
    Layout6: TLayout;
    Rectangle1: TRectangle;
    EdtPesquisarFavoritos: TEdit;
    Line1: TLine;
    Line2: TLine;
    BtnPesquisarFavoritos: TImage;
    BtnNovo: TImage;
    Layout5: TLayout;
    lvSenhas: TListView;
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
    LblFavorito: TLabel;
    swFavorito: TSwitch;
    Rectangle5: TRectangle;
    EdtLogin: TEdit;
    Layout10: TLayout;
    LblCadastrar: TLabel;
    BtnVoltar: TImage;
    Line3: TLine;
    BtnSalvar: TImage;
    ActTab03: TChangeTabAction;
    ImgExcluir: TImage;
    ImgBuscarSenha: TImage;
    Img00: TImage;
    Img07: TImage;
    Img06: TImage;
    Img05: TImage;
    Img04: TImage;
    Img03: TImage;
    Img02: TImage;
    Img01: TImage;
    lvFavoritos: TListView;
    BtnFavorito: TImage;
    BannerAd1: TBannerAd;
    Image1: TImage;
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

    procedure ClickLogout(Sender: TObject);
    procedure LimpaEdits;
    procedure MudarAba(img: TImage);
    procedure VerSenha;
    procedure ListarSenhas(descricao: string);
    procedure ListarFavoritos(descricao: string);
    procedure AddSenhas(id_senha, descricao, login, senha, favorito, tipo: String);
    procedure AddFavoritos(id_senha, descricao, login, senha, favorito, tipo: String);
    procedure Deletar(Sender: TObject);
    procedure AtualizarLanguage(valor: string);
    { Private declarations }
  public
    { Public declarations }
    id_categoria_global : integer;
    ind_fechar_telas : boolean;
    id_senha_global: integer;
    id_language: String;

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
      img := TListItemImage(Objects.FindDrawable('ImageBuscar'));
      img.Bitmap := ImgBuscarSenha.Bitmap;

       // Imagem Excluir
      img := TListItemImage(Objects.FindDrawable('ImageExcluir'));
      img.Bitmap := ImgExcluir.Bitmap;

    end;
  except on ex:Exception do
    fancy.Show(TIconDialog.Error, 'Erro', 'Erro ao adicionar lista de senhas: '+ex.message, 'OK');
  end;
end;

procedure TFormPrincipal.AtualizarLanguage(valor: string);
begin
  if id_language = 'US' then
  begin
    LblFavoritos.Text:= 'Favorites';
    EdtPesquisarFavoritos.TextPrompt:= 'Search...';

    EdtPesquisarSenhas.TextPrompt:= 'Search...';

    LblCadastrar.Text:= 'Register';
    EdtDescricao.TextPrompt:= 'Description';
    EdtLogin.TextPrompt:= 'Username';
    EdtSenha.TextPrompt:= 'Password';
    EdtTipo.TextPrompt:= 'Category';
    LblFavorito.Text:= 'Favorite:';
  end else
  begin
    LblFavoritos.Text:= 'Favoritos';
    EdtPesquisarFavoritos.TextPrompt:= 'Pesquisar...';

    EdtPesquisarSenhas.TextPrompt:= 'Pesquisar...';

    LblCadastrar.Text:= 'Cadastrar';
    EdtDescricao.TextPrompt:= 'Descri��o';
    EdtLogin.TextPrompt:= 'Login';
    EdtSenha.TextPrompt:= 'Senha';
    EdtTipo.TextPrompt:= 'Categoria';
    LblFavorito.Text:= 'Favorito:';
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
      img.Bitmap := ImgBuscarSenha.Bitmap;

       // Imagem Ver
      img := TListItemImage(Objects.FindDrawable('ImageExcluir'));
      img.Bitmap := ImgExcluir.Bitmap;

    end;
  except on ex:Exception do
    begin
      if id_language = 'US' then
        fancy.Show(TIconDialog.Error, 'Error!', 'Error adding password list: '+ex.message, 'OK')
      else
        fancy.Show(TIconDialog.Error, 'Error!', 'Erro ao adicionar lista de senhas: '+ex.message, 'OK');
    end;
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
    if id_language = 'US' then
      fancy.Show(TIconDialog.Error, 'Error!', 'Error in deleting: '+erro, 'TRY AGAIN')
    else
      fancy.Show(TIconDialog.Error, 'Erro!', 'Erro ao excluir: '+erro, 'OK');
    exit;
  end else
  begin
    if id_language = 'US' then
      fancy.Show(TIconDialog.Success, 'Success!', 'Record deleted successfully!', 'OK')
    else
      fancy.Show(TIconDialog.Success, 'Success!', 'Registro excluido com sucesso!', 'OK');
    ListarSenhas('');
  end;
end;

procedure TFormPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fancy.DisposeOf;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
var
  language, erro: string;
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

  imgBuscarSenha.Visible := False;
  imgExcluir.Visible := False;

  TabControl.ActiveTab := TabAba1;

  if DM.ValidaLanguage(language, erro) then
    id_language:= language
  else
    fancy.Show(TIconDialog.Error, 'Error!', erro, 'OK');

  AtualizarLanguage(id_language);

{$IFDEF ANDROID}
  BannerAd1.AdUnitID := 'ca-app-pub-5318830765545492/2572953526';
{$ENDIF}
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
      if (TabControl.ActiveTab = TabAba2) or
         (TabControl.ActiveTab = TabAba3) then
      begin
        Key := 0;
        ActTab01.Execute;
      end else
      begin
        Key := 0;
        if id_language = 'US' then
          fancy.Show(TIconDialog.Question, 'Logout!', 'Close application?', 'Yes', ClickLogout, 'No')
        else
          fancy.Show(TIconDialog.Question, 'Logout!', 'Deseja sair?', 'Sim', ClickLogout, 'N�o');
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
  TabControl.ActiveTab:= TabAba1;
  ListarSenhas('');

{$IFDEF ANDROID}
  BannerAd1.LoadAd;
{$ENDIF}
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
    if id_language = 'US' then
      fancy.Show(TIconDialog.Warning, 'Warning!', 'Description required', 'TRY AGAIN')
    else
      fancy.Show(TIconDialog.Warning, 'Ops!', 'Digite uma descri��o', 'OK');
    Exit;
  end;

  if (EdtLogin.Text = '') or
     (EdtSenha.Text = '') then
  begin
    if id_language = 'US' then
      fancy.Show(TIconDialog.Warning, 'Warning!', 'Username e password required', 'TRY AGAIN')
    else
      fancy.Show(TIconDialog.Warning, 'Ops!', 'Digite um login e senha', 'OK');
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
                         erro) then
  begin
    fancy.Show(TIconDialog.Error, 'Ops!', erro, 'OK');
    Exit;
  end else
  begin
    if id_language = 'US' then
      fancy.Show(TIconDialog.Success, 'Success!', 'Registration successfully completed!', 'OK')
    else
      fancy.Show(TIconDialog.Success, 'Concluido!', 'Registro realizado com sucesso!', 'OK');
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

procedure TFormPrincipal.ClickLogout(Sender: TObject);
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
    if EdtPesquisarFavoritos.Text <> '' then
    begin
      qry.SQL.Add('AND DESCRICAO LIKE :DESCRICAO');
      qry.ParamByName('DESCRICAO').Value := '%'+EdtPesquisarFavoritos.Text+'%';
    end;
    qry.SQL.Add('ORDER BY DESCRICAO');
    qry.ParamByName('FAVORITO').Value := 'S';
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
    if EdtPesquisarSenhas.Text <> '' then
    begin
      qry.SQL.Add('WHERE DESCRICAO LIKE :DESCRICAO');
      qry.ParamByName('DESCRICAO').Value := '%'+EdtPesquisarSenhas.Text+'%';
    end;
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
var
  senha, erro: String;
begin
  // CLIQUE NA IMAGEM
  if TListView(sender).Selected <> nil then
  begin
    if ItemObject is TListItemImage then
    begin
      if TListItemImage(ItemObject).Name = 'ImageBuscar' then
      begin
        id_senha_global:= StrToInt(lvSenhas.Items[ItemIndex].detail);
        if DM.BuscarSenha(StrToInt(lvSenhas.Items[ItemIndex].detail), senha, erro) then
        begin
          if id_language = 'US' then
            fancy.Show(TIconDialog.Info, 'Password:', senha, 'OK')
          else
            fancy.Show(TIconDialog.Info, 'Senha:', senha, 'OK');
        end else
        begin
          if id_language = 'US' then
            fancy.Show(TIconDialog.Error, 'Ops!', erro, 'OK')
          else
            fancy.Show(TIconDialog.Error, 'Ops!', erro, 'OK');
        end;

      end;
      if TListItemImage(ItemObject).Name = 'ImageExcluir' then
      begin
        id_senha_global:= StrToInt(lvSenhas.Items[ItemIndex].detail);
        if id_language = 'US' then
          fancy.Show(TIconDialog.Question, 'Delete!', 'Delete record?', 'Yes', Deletar, 'No')
        else
          fancy.Show(TIconDialog.Question, 'Excluir!', 'Deseja excluir?', 'Sim', Deletar, 'N�o');
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
  txt.Width:= lvSenhas.Width - 150;

  txt := TListItemText(AItem.Objects.FindDrawable('TxtLogin'));
  txt.Width:= lvSenhas.Width - 150;
end;

end.
