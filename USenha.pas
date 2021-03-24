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
    EdtConta_Email: TEdit;
    Rectangle1: TRectangle;
    Edit1: TEdit;
    Layout2: TLayout;
    Image2: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSenhas: TFormSenhas;

implementation

{$R *.fmx}

end.
