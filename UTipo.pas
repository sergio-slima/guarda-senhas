unit UTipo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, uFancyDialog;

type
  TFormTipos = class(TForm)
    Layout3: TLayout;
    LblCategoria: TLabel;
    BtnExplorar_Voltar: TImage;
    Line2: TLine;
    Layout1: TLayout;
    Img01: TImage;
    lvTipos: TListView;
    Img02: TImage;
    Img03: TImage;
    Img04: TImage;
    Img05: TImage;
    Img06: TImage;
    Img07: TImage;
    Img00: TImage;
    procedure BtnExplorar_VoltarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvTiposItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
    fancy : TFancyDialog;

    procedure ListarTipos(pesquisar: string; clear: boolean);
    procedure AddTipos(codigo, nome: string);
  public
    { Public declarations }
  end;

var
  FormTipos: TFormTipos;

implementation

{$R *.fmx}

uses UDM, UPrincipal;

procedure TFormTipos.AddTipos(codigo, nome: string);
var
  item : TListViewItem;
  txt : TListItemText;
  img : TListItemImage;
  i, idade: integer;
begin
  // Adicionando na ListView

  try
    item := lvTipos.Items.Add;
    item.Detail := codigo;
    item.TagString := nome;

    with item do
    begin

      // ID
      txt := TListItemText(Objects.FindDrawable('TxtCodigo'));
      txt.Text := codigo;

      // NOme
      txt := TListItemText(Objects.FindDrawable('TxtNome'));
      txt.Text := nome;

      // Imagem Tipo
      img := TListItemImage(Objects.FindDrawable('ImageTipo'));
      if codigo = '01' then
        img.Bitmap := Img01.Bitmap
      else if codigo = '02' then
        img.Bitmap := Img02.Bitmap
      else if codigo = '03' then
        img.Bitmap := Img03.Bitmap
      else if codigo = '04' then
        img.Bitmap := Img04.Bitmap
      else if codigo = '05' then
        img.Bitmap := Img05.Bitmap
      else if codigo = '06' then
        img.Bitmap := Img06.Bitmap
      else if codigo = '07' then
        img.Bitmap := Img07.Bitmap
      else if codigo = '00' then
        img.Bitmap := Img00.Bitmap;

    end;
  except on ex:Exception do
    fancy.Show(TIconDialog.Error, 'Erro', 'Erro ao adicionar vendedor: '+ex.Message, 'OK');
  end;
end;

procedure TFormTipos.BtnExplorar_VoltarClick(Sender: TObject);
begin
  Close;
end;

procedure TFormTipos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction.caFree;
  FormTipos := nil;

  fancy.DisposeOf;
end;

procedure TFormTipos.FormCreate(Sender: TObject);
var
  language, erro: string;
begin
    fancy := TFancyDialog.Create(FormTipos);

    Img01.Visible := False;
    Img02.Visible := False;
    Img03.Visible := False;
    Img04.Visible := False;
    Img05.Visible := False;
    Img06.Visible := False;
    Img07.Visible := False;
    Img00.Visible := False;

  if DM.ValidaLanguage(language, erro) then
  begin
    if language = 'US' then
      LblCategoria.Text:= 'Categories'
    else
      LblCategoria.Text:= 'Categorias';
  end
  else
    fancy.Show(TIconDialog.Error, 'Error!', erro, 'OK');
end;

procedure TFormTipos.FormShow(Sender: TObject);
begin
  FormPrincipal.CodTipo_Selecao := '';
  FormPrincipal.NomTipo_Selecao := '';

  lvTipos.Tag := 0;
  ListarTipos('', True);
end;

procedure TFormTipos.ListarTipos(pesquisar: string; clear: boolean);
var
  language, erro: string;
begin
  if DM.ValidaLanguage(language, erro) then
  begin
    if language = 'US' then
    begin
      LblCategoria.Text:= 'Categorias';

      AddTipos('01', 'Emails');
      AddTipos('02', 'Networks');
      AddTipos('03', 'Sytems');
      AddTipos('04', 'Games');
      AddTipos('05', 'Schools');
      AddTipos('06', 'Bank');
      AddTipos('07', 'Cards');
      AddTipos('00', 'Others');
    end
    else
    begin
      LblCategoria.Text:= 'Categorias';

      AddTipos('01', 'Emails');
      AddTipos('02', 'Redes Sociais');
      AddTipos('03', 'Sistemas');
      AddTipos('04', 'Jogos');
      AddTipos('05', 'Cursos');
      AddTipos('06', 'Banco');
      AddTipos('07', 'Cartões');
      AddTipos('00', 'Outros');
    end;
  end
  else
    fancy.Show(TIconDialog.Error, 'Error!', erro, 'OK');

end;

procedure TFormTipos.lvTiposItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  FormPrincipal.CodTipo_Selecao := AItem.Detail;
  FormPrincipal.NomTipo_Selecao := AItem.TagString;

  Close;
end;

end.
