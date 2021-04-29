unit uMD5;

interface

uses IdHashMessageDigest, Classes, SysUtils;

Const
  sChave: String = 'A!b@cD#Ef$gH%ijkl&MN;:OPQ*RStu(VWXy)ZC-aBC-deF.,GhI+JKL=mn{opq[rsT}Uvwx|Yzc]159?48/26370\';

  function MD5(const Value: string): string;
  function Encripta(Texto:String):String;
  function Criptografar(wStri: String): String;

implementation

function MD5(const Value: string): string;
var
  xMD5: TIdHashMessageDigest5;
begin
  xMD5 := TIdHashMessageDigest5.Create;
  try
    Result := LowerCase(xMD5.HashStringAsHex(Value));
  finally
    xMD5.Free;
  end;
end;

function Encripta(Texto:String):String;
var
  i: Integer;
  Aux: String;
  Senha: Int64;
begin
  Aux:= Texto;
  Senha:= 0;
  for i := 1 to Length(Aux) do
    Senha:=Senha+(((Pos(Aux[i],sChave)+1)-i)*Pos(Aux[i],sChave)*i*i);

  Result:=IntToStr(Senha);
end;

function Criptografar(wStri: String): String;
var
  Simbolos : array [0..4] of String;
  x        : Integer;
begin
    Simbolos[1]:='FEDCBALMNOPQGHIJRSTUVYWKXZ ~!@#$%^&*()';
    Simbolos[2]:= '3210456987abcjlmnopqdefghirstuywkvxz';
    Simbolos[3]:= 'ÂÀ©Øû×ƒçêùÿ5Üø£úñÑªº¿®¬¼ëèïÙýÄÅÉæÆôöò»Á';
    Simbolos[4]:= 'áâäàåíóÇüé¾¶§÷ÎÏ-+ÌÓß¸°¨·¹³²Õµþîì¡«½';

    for x := 1 to Length(Trim(wStri)) do
		begin
        if pos(copy(wStri,x,1),Simbolos[1])>0 then
        Result := Result+copy(Simbolos[2],
                  pos(copy(wStri,x,1),Simbolos[1]),1)

        else
				if pos(copy(wStri,x,1),Simbolos[2])>0 then
                   Result := Result+copy(Simbolos[1],
                             pos(copy(wStri,x,1),Simbolos[2]),1)

        else
				if pos(copy(wStri,x,1),Simbolos[3])>0 then
                   Result := Result+copy(Simbolos[4],
                             pos(copy(wStri,x,1),Simbolos[3]),1)

        else
				if pos(copy(wStri,x,1),Simbolos[4])>0 then
                   Result := Result+copy(Simbolos[3],
                          pos(copy(wStri,x,1),Simbolos[4]),1);
    end;
end;

end.
