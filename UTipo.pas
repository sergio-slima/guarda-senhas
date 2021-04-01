unit UTipo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit;

type
  TFormTipos = class(TForm)
    Layout3: TLayout;
    Label1: TLabel;
    BtnExplorar_Voltar: TImage;
    Line2: TLine;
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    Image1: TImage;
    procedure BtnExplorar_VoltarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormTipos: TFormTipos;

implementation

{$R *.fmx}

uses UDM;

procedure TFormTipos.BtnExplorar_VoltarClick(Sender: TObject);
begin
  Close;
end;

end.
