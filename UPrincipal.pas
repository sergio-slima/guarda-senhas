unit UPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.TabControl, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, System.JSON, uFunctions;

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
    Label4: TLabel;
    RtgCidade: TRectangle;
    EdtCidade: TEdit;
    Image6: TImage;
    LbxCategorias: TListBox;
    Layout3: TLayout;
    Label1: TLabel;
    BtnExplorar_Voltar: TImage;
    Layout5: TLayout;
    Label2: TLabel;
    Layout6: TLayout;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    lvExplorar: TListView;
    BtnExplorar_Buscar: TRectangle;
    Label3: TLabel;
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
    procedure FormShow(Sender: TObject);
    procedure ImgAba4Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BtnExplorar_VoltarClick(Sender: TObject);
    procedure lvExplorarItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure EdtCidadeExit(Sender: TObject);
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

uses UFrameCategoria, UFrameAgendamento, UDetalheEmpresa, UDM;

procedure TFormPrincipal.CarregarExplorar(cidade, termo: String; id_categoria: integer);
var
  i: integer;
  jsonArray: TJSONArray;
  erro: string;
begin
  lvExplorar.Items.Clear;

  // acessar dados servidor
  if not DM.ListarEmpresa(cidade, termo, 'N', '', id_categoria, jsonArray, erro) then
  begin
    ShowMessage(erro);
    Exit;
  end;

  for i := 0 to jsonArray.Size - 1 do
  begin
    with lvExplorar.Items.Add do
    begin
      Height := 90;
      Tag := jsonArray.Get(i).GetValue<integer>('ID_EMPRESA', 0);

      TListItemText(Objects.FindDrawable('TxtNome')).Text := jsonArray.Get(i).GetValue<string>('NOME', '');
      TListItemText(Objects.FindDrawable('TxtEndereco')).Text := jsonArray.Get(i).GetValue<string>('ENDERECO', '') + sLineBreak +
                                                                 jsonArray.Get(i).GetValue<string>('BAIRRO', '') + ' - ' +
                                                                 jsonArray.Get(i).GetValue<string>('CIDADE', '') + sLineBreak +
                                                                 jsonArray.Get(i).GetValue<string>('FONE', '');
    end;
  end;
end;

procedure TFormPrincipal.lvExplorarItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
  i: integer;
  jsonArray: TJSONArray;
  erro: string;
begin
  ind_fechar_telas:= false;

  if not Assigned(FormDetalheEmpresa) then
    Application.CreateForm(TFormDetalheEmpresa, FormDetalheEmpresa);

  if not DM.ListarEmpresa(EdtCidade.Text, '', 'S', Aitem.Tag.ToString, id_categoria_global, jsonArray, erro) then
  begin
    ShowMessage(erro);
    Exit;
  end;

  if jsonArray.Size = 0 then
  begin
    ShowMessage('Detalhes da empresa não encontrado');
    jsonArray.DisposeOf;
    Exit;
  end;

  FormDetalheEmpresa.id_empr := jsonArray.Get(0).GetValue<integer>('ID_EMPRESA', 0);
  FormDetalheEmpresa.LblNome.Text := jsonArray.Get(0).GetValue<string>('NOME', '');
  FormDetalheEmpresa.LblEndereco.Text := jsonArray.Get(0).GetValue<string>('ENDERECO', '') + sLineBreak +
                                         jsonArray.Get(0).GetValue<string>('BAIRRO', '') + ' - ' +
                                         jsonArray.Get(0).GetValue<string>('CIDADE', '') + sLineBreak +
                                         jsonArray.Get(0).GetValue<string>('FONE', '');

  if jsonArray.Get(0).GetValue<string>('FOTO', '') <> '' then
    FormDetalheEmpresa.ImgFoto.Bitmap := TFunctions.BitmapFromBase64(jsonArray.Get(0).GetValue<string>('FOTO', ''))
  else
    FormDetalheEmpresa.ImgFoto.Bitmap := FormDetalheEmpresa.ImgFoto.Bitmap;

  FormDetalheEmpresa.ShowModal(procedure(Modal:TModalResult)
  begin
    if ind_fechar_telas then
      MudarAba(ImgAba3);
  end);

  jsonArray.DisposeOf;
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
var
  i: integer;
  item: TListBoxItem;
  frame: TFrameAgendamento;
  jsonArray: TJSONArray;
  erro: string;
begin
  LbxAgendamentos.Items.Clear;
  ImgSem_Reserva.Visible := false;

  //acesar servidor
  if not DM.ListarReserva(id_usuario_global, jsonArray, erro) then
  begin
    ShowMessage(erro);
    Exit;
  end;

  for I := 0 to jsonArray.Size - 1 do
  begin
    item := TListBoxItem.Create(LbxAgendamentos);
    item.Text := '';
    item.Height := 230;

    frame := TFrameAgendamento.Create(item);
    frame.Parent := item;
    frame.Align := TAlignLayout.Client;

    frame.LblServico.Text := jsonArray.Get(i).GetValue<string>('DESCRICAO', '');
    frame.LblNome.Text := jsonArray.Get(i).GetValue<string>('NOME', '');
    frame.LblData.Text := jsonArray.Get(i).GetValue<string>('DATA_RESERVA', '');
    frame.LblHora.Text := jsonArray.Get(i).GetValue<string>('HORA', '');
    frame.LblValor.Text := 'R$ ' + FormatFloat('#,##0.00', jsonArray.Get(i).GetValue<double>('VALOR', 0));
    frame.LblEndereco.Text := jsonArray.Get(i).GetValue<string>('ENDERECO', '') + sLineBreak +
                              jsonArray.Get(i).GetValue<string>('BAIRRO', '') + ' - ' +
                              jsonArray.Get(i).GetValue<string>('CIDADE', '') + sLineBreak +
                              jsonArray.Get(i).GetValue<string>('FONE', '');
    frame.BtnExcluir.Tag := jsonArray.Get(i).GetValue<integer>('ID_RESERVA', 0);

    LbxAgendamentos.AddObject(item);
  end;
  ImgSem_Reserva.Visible := jsonArray.Size = 0;

  jsonArray.DisposeOf;
end;

procedure TFormPrincipal.CarregarCategorias(cidade: string);
var
  i: integer;
  item: TListBoxItem;
  frame: TFrameCategoria;
  jsonArray: TJSONArray;
  erro, icone64: String;
begin
  if cidade = '' then
    Exit;

  LbxCategorias.Items.Clear;

  //acessar servidor
  if not DM.ListarCategoria(cidade, jsonArray, erro) then
  begin
    ShowMessage(erro);
    Exit;
  end;


  for I := 0 to jsonArray.Size - 1 do
  begin
    item := TListBoxItem.Create(LbxCategorias);
    item.Text := '';
    item.Width := 105;
    item.Height := 150;
    item.Selectable := false;
    item.Tag := jsonArray.Get(i).GetValue<integer>('ID_CATEGORIA', 0);

    frame := TFrameCategoria.Create(item);
    frame.Parent := item;
    frame.Align := TAlignLayout.Client;

    frame.LblCategoria.Text := jsonArray.Get(i).GetValue<string>('DESCRICAO', '');

    icone64 := jsonArray.Get(i).GetValue<string>('ICONE', '');

    try
      if icone64 <> '' then
        frame.ImgCategoria.Bitmap := TFunctions.BitmapFromBase64(icone64);
    except
    end;

    LbxCategorias.AddObject(item);
  end;

  jsonArray.DisposeOf;
end;

procedure TFormPrincipal.EdtCidadeExit(Sender: TObject);
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
