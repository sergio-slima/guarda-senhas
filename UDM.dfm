object DM: TDM
  OldCreateOrder = False
  Height = 333
  Width = 441
  object RESTClient: TRESTClient
    Authenticator = HTTPBasicAuthenticator
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:8082'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 48
    Top = 16
  end
  object ReqLogin: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'sergio@hotmail.com'
      end
      item
        Name = 'senha'
        Value = '123'
      end>
    Resource = 'usuario/login'
    SynchronizedEvents = False
    Left = 248
    Top = 24
  end
  object HTTPBasicAuthenticator: THTTPBasicAuthenticator
    Username = 'admin'
    Password = 'admin'
    Left = 48
    Top = 64
  end
  object ReqCategoria: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'sergio@hotmail.com'
      end
      item
        Name = 'senha'
        Value = '123'
      end>
    Resource = 'categoria/listar'
    SynchronizedEvents = False
    Left = 248
    Top = 80
  end
  object ReqEmpresa: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'sergio@hotmail.com'
      end
      item
        Name = 'senha'
        Value = '123'
      end>
    Resource = 'empresa/listar'
    SynchronizedEvents = False
    Left = 256
    Top = 128
  end
  object ReqServico: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'sergio@hotmail.com'
      end
      item
        Name = 'senha'
        Value = '123'
      end>
    Resource = 'servico/listar'
    SynchronizedEvents = False
    Left = 256
    Top = 184
  end
  object ReqHorario: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'heber@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '123456'
      end>
    Resource = 'servico/horario'
    SynchronizedEvents = False
    Left = 352
    Top = 80
  end
  object ReqAgendar: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'heber@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '123456'
      end>
    Resource = 'servico/agendar'
    SynchronizedEvents = False
    Left = 352
    Top = 16
  end
  object ReqReserva: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'heber@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '123456'
      end>
    Resource = 'reserva/listar'
    SynchronizedEvents = False
    Left = 352
    Top = 136
  end
  object ReqExcluir: TRESTRequest
    Client = RESTClient
    Params = <
      item
        Name = 'email'
        Value = 'heber@99coders.com.br'
      end
      item
        Name = 'senha'
        Value = '123456'
      end>
    Resource = 'reserva/excluir'
    SynchronizedEvents = False
    Left = 352
    Top = 192
  end
end
