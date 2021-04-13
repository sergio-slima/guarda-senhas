{###############################################################################}
{                  Classe KeyGuardManager - Biometria Android                   }
{                           Janeiro de 2020                                     }
{###############################################################################}
{                                                                               }
{###############################################################################}
{    Developer.: Gabriel de Oliveira silva  - gabriel.o.s@hotmail.com           }
{    Developer.: Gabriel de Souza Lopes     - gabslopes34@hotmail.com           }
{###############################################################################}

unit Android.KeyguardManager;

interface

uses
  System.Messaging, System.Classes, FMX.Dialogs,

  {$IFDEF ANDROID}
    Androidapi.JNI.GraphicsContentViewText,
    Androidapi.Helpers,
    FMX.Helpers.Android,
    Androidapi.jni.app,
    Androidapi.jni.Net,
    Androidapi.jni.Support,
    Androidapi.JNIBridge,
    Androidapi.NativeActivity,
    Androidapi.jni.JavaTypes,
    Androidapi.jni.Os,
    DW.Androidapi.JNI.KeyguardManager,
  {$ENDIF}
  FMX.Types, FMX.Platform, FMX.Forms, FMX.Controls;

type
  TCallbackProc = procedure(Sender: TObject) of Object;
  TIntent = JIntent;

  TEventResultClass = class(TFmxObject)
  private
    FKeyguardManager: JKeyguardManager;
    PrcSuccess, PrcError : TCallbackProc;
    procedure ActivityResultMessageHandler(const ASender: TObject; const AMessage: TMessage);
  public
    ResultCode: integer;
    RequestCode: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function DeviceSecure: Boolean;
    function StartActivityKeyGuard(CallBackSuccess : TCallbackProc = nil;
                                   CallBackError : TCallbackProc = nil): boolean;
    procedure OnActivityResult(Sender: TObject; const ARequestCode: Integer; const AResultCode: Integer;
                                const AIntent: TIntent);

  end;
implementation

{ TEventResultClass }

procedure TEventResultClass.ActivityResultMessageHandler(const ASender: TObject; const AMessage: TMessage);
var
  Message: TMessageResultNotification;
begin
  if (AMessage is TMessageResultNotification) then
  begin
    Message := TMessageResultNotification(AMessage);
    OnActivityResult(Self, Message.RequestCode, Message.ResultCode, Message.Value);
  end;
end;

constructor TEventResultClass.Create(AOwner: TComponent);
var
  LService: JObject;
begin
  inherited;
  LService := TAndroidHelper.Context.getSystemService(TJContext.JavaClass.KEYGUARD_SERVICE);
  FKeyguardManager := TJKeyguardManager.Wrap((LService as ILocalObject).GetObjectID);
  TMessageManager.DefaultManager.SubscribeToMessage(TMessageResultNotification, ActivityResultMessageHandler);
end;

destructor TEventResultClass.Destroy;
begin
  TMessageManager.DefaultManager.Unsubscribe(TMessageResultNotification, ActivityResultMessageHandler);
  inherited;
end;

function TEventResultClass.DeviceSecure: Boolean;
begin
  Result := FKeyguardManager.isDeviceSecure;
end;

procedure TEventResultClass.OnActivityResult(Sender: TObject; const ARequestCode, AResultCode: Integer;
  const AIntent: TIntent);
begin
  if aRequestCode = 000 then
  begin
    if AResultCode = -1 then
    begin
      //ShowMessage('Valido');
      if Assigned(PrcSuccess) then
        PrcSuccess(nil);
    end
    else
    begin
      if Assigned(PrcError) then
        PrcError(nil);
    end;
  end;

end;

function TEventResultClass.StartActivityKeyGuard(CallBackSuccess : TCallbackProc = nil;
                                                 CallBackError : TCallbackProc = nil): boolean;
var
  Intent: JIntent;
begin
  Result := false;

  PrcSuccess := CallBackSuccess;
  PrcError := CallBackError;

  Intent := FKeyguardManager.createConfirmDeviceCredentialIntent
    (StrToJCharSequence('Mensagem KeyGuard'), StrToJCharSequence(''));

  TAndroidHelper.Activity.startActivityForResult(Intent, 000);
  Result := true;
end;

end.
