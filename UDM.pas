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
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, System.IOUtils;

type
  TDM = class(TDataModule)
    Conexao: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    id_language: string;

    function ValidaSenha(senha: String; out erro: string): Boolean;
    function CadastrarSenha(email, nascimento, senha: String; out erro: string): Boolean;
    function ResetarSenha(email, nascimento, senha: String; out erro: string): Boolean;

    function SalvarSenhas(descricao, login, senha, favorito, tipo: String; out erro: string): Boolean;
    function ExcluirSenhas(id_senha: integer; out erro: string): Boolean;
    function BuscarSenha(id_senha: integer; out email: string; out senha: string; out erro: string): Boolean;

    function ValidaLanguage(out language: string; out erro: string): Boolean;
    function ValidaTelaInicial: Boolean;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses UPrincipal;

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
var
  language, erro: String;
begin
   {$IF DEFINED(ANDROID)}

   conexao.Params.Values['Database'] :=
                      TPath.Combine(TPath.GetDocumentsPath, 'banco.sqlite');

   conexao.Open();

   // table usuarios
   conexao.ExecSQL('CREATE TABLE IF NOT EXISTS usuarios (id_usuario INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, email VARCHAR(70) NOT NULL, nascimento DATE NOT NULL, senha VARCHAR(50) NOT NULL);');

   // table senhas
   conexao.ExecSQL('CREATE TABLE IF NOT EXISTS senhas (id_senha INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, descricao VARCHAR(50) NOT NULL, login VARCHAR(100) NOT NULL, senha VARCHAR(50) NOT NULL, tipo VARCHAR(2) NOT NULL, favorito CHAR(1) NOT NULL);');

   // table configuracoes
   conexao.ExecSQL('CREATE TABLE IF NOT EXISTS config (id_config INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, language VARCHAR(2) NOT NULL, tela_inicial CHAR(1) NOT NULL);');

//   if ValidaVersao('1.1') then
//   begin
//    // Primeira versão
//   end;

   {$ENDIF}

   conexao.Connected := True;


   if ValidaLanguage(language, erro) then
     id_language:= language;

end;

function TDM.ExcluirSenhas(id_senha: integer; out erro: string): Boolean;
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
    qry.SQL.Add('DELETE FROM SENHAS');
    qry.SQL.Add('WHERE ID_SENHA = :ID_SENHA');
    qry.ParamByName('ID_SENHA').Value := id_senha;
    qry.ExecSQL;

    Result := True;
    qry.DisposeOf;
  except on e:Exception do
    erro:= e.Message;
  end;
end;

function TDM.ValidaLanguage(out language: string; out erro: string): Boolean;
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
    qry.SQL.Add('SELECT * FROM CONFIG');
    qry.Open;
    if qry.RecordCount > 0 then
    begin
      language:= qry.FieldByName('LANGUAGE').AsString;
      Result := True;
    end else
    begin
      if id_language = 'US' then
        erro:= 'Language not found!'
      else
        erro:= 'Línguagem não encontrada!';
    end;
  finally
    qry.DisposeOf;
  end;
end;

function TDM.ValidaSenha(senha: String; out erro: string): Boolean;
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
    if senha <> '' then
    begin
      qry.SQL.Add('WHERE SENHA = :SENHA');
      qry.ParamByName('SENHA').Value := senha;
    end;
    qry.Open;

    if qry.RecordCount > 0 then
    begin
      Result := True;
    end else
    begin
      if id_language = 'US' then
        erro:= 'Senha inválida ou não existe!'
      else
        erro:= 'Password invalid or no exist!';
    end;
  finally
    qry.DisposeOf;
  end;
end;

function TDM.ValidaTelaInicial: Boolean;
var
  qry : TFDQuery;
begin
  Result:= False;

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := DM.Conexao;

    qry.Close;
    qry.SQL.Clear;
    qry.SQL.Add('SELECT * FROM CONFIG WHERE TELA_INICIAL = :TELA_INICIAL');
    qry.ParamByName('TELA_INICIAL').AsString:= 'S';
    qry.Open;
    if qry.RecordCount > 0 then
      Result := True;

  finally
    qry.DisposeOf;
  end;
end;

function TDM.BuscarSenha(id_senha: integer; out email: string; out senha: string; out erro: string): Boolean;
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
    qry.SQL.Add('SELECT * FROM SENHAS');
    qry.SQL.Add('WHERE EMAIL = :EMAIL AND ID_SENHA = :ID_SENHA');
    qry.ParamByName('ID_SENHA').Value := id_senha;
    qry.Open;

    if qry.RecordCount > 0 then
    begin
      email:= qry.FieldByName('EMAIL').AsString;
      senha:= qry.FieldByName('SENHA').AsString;
      Result := True;
    end else
    begin
      if id_language = 'US' then
        erro:= 'Password not found!'
      else
        erro:= 'Senha não encontrada!';
    end;

    Result := True;
    qry.DisposeOf;
  except on e:Exception do
    erro:= e.Message;
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
    qry.SQL.Add('INSERT INTO USUARIOS (EMAIL, NASCIMENTO, SENHA)');
    qry.SQL.Add('VALUES (:EMAIL, :NASCIMENTO, :SENHA)');
    qry.ParamByName('EMAIL').Value := email;
    qry.ParamByName('NASCIMENTO').Value := FormatDateTime('yyyy-mm-dd', StrToDateTime(nascimento));
    qry.ParamByName('SENHA').Value := senha;
    qry.ExecSQL;

    qry.DisposeOf;
    Result:= True;
  except
    begin
      if id_language = 'US' then
        erro:= 'Registry error!'
      else
        erro:= 'Erro ao cadastrar conta!';
    end;
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
    qry.SQL.Add('AND NASCIMENTO = :NASCIMENTO');
    qry.ParamByName('EMAIL').Value := email;
    qry.ParamByName('NASCIMENTO').Value := FormatDateTime('yyyy-mm-dd', StrToDateTime(nascimento));
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
      if id_language = 'US' then
        erro:= 'Account not registered!'
      else
        erro:= 'Conta não existe!';
    end;

  finally
    qry.DisposeOf;
  end;
end;

function TDM.SalvarSenhas(descricao, login, senha, favorito, tipo: String;
  out erro: string): Boolean;
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
    qry.SQL.Add('INSERT INTO SENHAS (DESCRICAO, LOGIN, SENHA, FAVORITO, TIPO)');
    qry.SQL.Add('VALUES (:DESCRICAO, :LOGIN, :SENHA, :FAVORITO, :TIPO)');
    qry.ParamByName('DESCRICAO').Value := descricao;
    qry.ParamByName('LOGIN').Value := login;
    qry.ParamByName('SENHA').Value := senha;
    qry.ParamByName('FAVORITO').Value := favorito;
    qry.ParamByName('TIPO').Value := tipo;
    qry.ExecSQL;

    qry.DisposeOf;
    Result:= True;
  except
    begin
      if id_language = 'US' then
        erro:= 'Registry error!'
      else
        erro:= 'Erro ao cadastrar registro!';
    end;
  end;
end;

end.
