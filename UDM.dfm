object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 184
  Width = 264
  object Conexao: TFDConnection
    Params.Strings = (
      'Database=D:\Sergio\Projetos\guarda-senhas\banco.sqlite'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 40
    Top = 32
  end
end
