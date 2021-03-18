unit UDM;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Client,
  REST.Authenticator.Basic, Data.Bind.Components, Data.Bind.ObjectScope,
  System.JSON, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDM = class(TDataModule)
    Conexao: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ValidaSenha(senha: String; out id_usuario: integer; out erro: string): Boolean;
    function CadastrarSenha(email, nascimento, senha: String; out erro: string): Boolean;
    function ResetarSenha(email, nascimento, senha: String; out erro: string): Boolean;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
   {$IF DEFINED(ANDROID)}

   conexao.Params.Values['Database'] :=
                      TPath.Combine(TPath.GetDocumentsPath, 'banco.sqlite');

   conexao.Open();

   // table usuarios
   conexao.ExecSQL('CREATE TABLE IF NOT EXISTS usuarios (id_usuario INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, email VARCHAR(70) NOT NULL, nascimento DATE NOT NULL, senha VARCHAR(50) NOT NULL);');


//   if ValidaVersao('1.1') then
//   begin
//    // Primeira versão
//   end;

   {$ENDIF}

   conexao.Connected := True;
end;

function TDM.ValidaSenha(senha: String; out id_usuario: integer; out erro: string): Boolean;
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

function TDM.CadastrarSenha(email, nascimento, senha: String; out erro: string): Boolean;
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
    qry.SQL.Add('INSERT INTO (EMAIL, NASCIMENTO, SENHA)');
    qry.SQL.Add('VALUES (:EMAIL, :NASCIMENTO, :SENHA)');
    qry.ParamByName('EMAIL').Value := email;
    qry.ParamByName('NASCIMENTO').Value := nascimento;
    qry.ParamByName('SENHA').Value := senha;
    qry.ExecSQL;

    qry.DisposeOf;
    Result:= True;
  except
    erro:= 'Erro ao cadastrar a conta!';
  end;
end;

function TDM.ResetarSenha(email, nascimento, senha: String; out erro: string): Boolean;
var
  qry : TFDQuery;
  id_usuario: integer;
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
    qry.SQL.Add('WHERE EMAIL = :EMAIL');
    qry.SQL.Add('WHERE NASCIMENTO = :NASCIMENTO');
    qry.ParamByName('EMAIL').Value := email;
    qry.ParamByName('NASCIMENTO').Value := nascimento;
    qry.Open;

    if qry.RecordCount > 0 then
    begin
      id_usuario:= qry.FieldByName('id_usuario').AsInteger;

      qry.Close;
      qry.SQL.Clear;
      qry.SQL.Add('UPDATE USUARIOS SET SENHA = :SENHA');
      qry.SQL.Add('WHERE ID_USUARIO = :ID_USUARIO');
      qry.ParamByName('ID_USUARIO').Value := id_usuario;
      qry.ParamByName('SENHA').Value := senha;
      qry.ExecSQL;

      Result:= True;
    end else
    begin
      erro:= 'Conta não existe!';
    end;

  finally
    qry.DisposeOf;
  end;
end;

end.
