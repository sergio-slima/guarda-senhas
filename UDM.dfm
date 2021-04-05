object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 184
  Width = 264
  object Conexao: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\Sergio\Documents\Embarcadero\Studio\Projects\g' +
        'uarda-senhas\banco.sqlite'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 40
    Top = 32
  end
end
