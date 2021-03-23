unit UPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.TabControl, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, System.JSON;

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
    TabAba4: TTabItem;
    Layout4: TLayout;
    Image5: TImage;
    Layout2: TLayout;
    RtgCidade: TRectangle;
    EdtPesquisarSenhas: TEdit;
    Image6: TImage;
    LbxCategorias: TListBox;
    Layout3: TLayout;
    Label1: TLabel;
    BtnExplorar_Voltar: TImage;
    Layout6: TLayout;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    lvExplorar: TListView;
    Layout7: TLayout;
    Label5: TLabel;
    LbxAgendamentos: TListBox;
    Layout8: TLayout;
    Label6: TLabel;
    Layout9: TLayout;
    Rectangle4: TRectangle;
    EdtPerfil_Nome: TEdit;
    BtnPerfilSalvar: TRectangle;
    Label7: TLabel;
    Rectangle7: TRectangle;
    EdtPerfil_Email: TEdit;
    BtnPerfilSenha: TRectangle;
    Label8: TLabel;
    Line1: TLine;
    Line2: TLine;
    Line3: TLine;
    Line4: TLine;
    ImgSem_Reserva: TImage;
    Image1: TImage;
    Image2: TImage;
    Layout5: TLayout;
    procedure FormShow(Sender: TObject);
    procedure ImgAba4Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BtnExplorar_VoltarClick(Sender: TObject);
    procedure EdtPesquisarSenhasExit(Sender: TObject);
    procedure LbxCategoriasItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    procedure MudarAba(img: TImage);
    procedure CarregarCategorias(cidade: string);
    procedure CarregarExplorar(cidade, termo: String; id_categoria: integer);
    { Private declarations }
  public
    { Public declarations }
    id_categoria_global : integer;
    id_usuario_global : integer;
    ind_fechar_telas : boolean;
    procedure CarregarAgendamentos;
  end;

var
  FormPrincipal: TFormPrincipal;

implementation

{$R *.fmx}

uses UDM;

procedure TFormPrincipal.CarregarExplorar(cidade, termo: String; id_categoria: integer);
begin
end;

procedure TFormPrincipal.MudarAba(img: TImage);
begin
  ImgAba1.Opacity := 0.5;
  ImgAba2.Opacity := 0.5;
  ImgAba3.Opacity := 0.5;
  ImgAba4.Opacity := 0.5;

  img.Opacity := 1;
  TabControl.GotoVisibleTab(img.Tag, TTabTransition.Slide);

  // Aba de agendamentos confirmados
  if img.Tag = 2 then
    CarregarAgendamentos;

end;

procedure TFormPrincipal.BtnExplorar_VoltarClick(Sender: TObject);
begin
  MudarAba(ImgAba1);
end;

procedure TFormPrincipal.CarregarAgendamentos;
begin
end;

procedure TFormPrincipal.CarregarCategorias(cidade: string);
begin
end;

procedure TFormPrincipal.EdtPesquisarSenhasExit(Sender: TObject);
begin
  CarregarCategorias(EdtCidade.Text);
end;

procedure TFormPrincipal.FormResize(Sender: TObject);
begin
  LbxCategorias.Columns := Trunc(LbxCategorias.Width / 105);
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
begin
  MudarAba(ImgAba1);
  CarregarCategorias(EdtCidade.Text);
  //CarregarExplorar('','');
  //CarregarAgendamentos;
end;

procedure TFormPrincipal.ImgAba4Click(Sender: TObject);
begin
  MudarAba(TImage(Sender));
end;

procedure TFormPrincipal.LbxCategoriasItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
  CarregarExplorar(EdtCidade.Text, '', item.Tag);
  MudarAba(ImgAba2);
end;

end.
