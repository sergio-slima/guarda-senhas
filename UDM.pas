unit UDM;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Client,
  REST.Authenticator.Basic, Data.Bind.Components, Data.Bind.ObjectScope,
  System.JSON, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client;

type
  TDM = class(TDataModule)
    Conexao: TFDConnection;
  private
    { Private declarations }
  public
    { Public declarations }
    function ValidaLogin(senha: String; out id_usuario: integer; out erro: string): Boolean;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

function TDM.ValidaLogin(senha: String; out id_usuario: integer; out erro: string): Boolean;
var
  qry : TFDQuery;
begin
  Result:= False;
  erro := '';

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := DM.Conexao;

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('SELECT ID_USUARIO, EMAIL, NASCIMENTO, SENHA');
    qry.SQL.Add('FROM USUARIOS');
    qry.SQL.Add('WHERE SENHA = :SENHA');
    qry.ParamByName('SENHA').Value := senha;
    qry.Open;

    if qry.RecordCount > 0 then
    begin
      id_usuario:= qry.FieldByName('id_usuario').AsInteger;
      Result := True;
    end else
      erro:= 'Senha inválida ou não existe!';
  finally
    qry.DisposeOf;
  end;
end;

end.
