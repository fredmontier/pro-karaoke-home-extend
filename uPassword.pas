unit uPassword;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, u_dm, DynamicSkinForm, StdCtrls, SkinCtrls, SkinBoxCtrls, Mask;

type
  TFrmPassword = class(TForm)
    spDynamicSkinForm1: TspDynamicSkinForm;
    UserName: TspSkinEdit;
    Password: TspSkinPasswordEdit;
    spSkinStdLabel1: TspSkinStdLabel;
    spSkinStdLabel2: TspSkinStdLabel;
    BtnOK: TspSkinButton;
    BtnCancel: TspSkinButton;
    procedure FormShow(Sender: TObject);
    procedure UserNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
//    function cakAtuh(AStr: String): boolean;
  end;

var
  FrmPassword: TFrmPassword;

implementation

uses u_setting;

{$R *.dfm}

//function TFrmPassword.cakAtuh(AStr: String): boolean;
//begin
//  if AStr = 'Teknisi' then
//  begin
//    Result := dm.getIntegerFromSQL(dm.qexec, 'select count (*) from user_dat '+
//    'where username='+quotedStr(UserName.Text)+' and password='+quotedStr(Password.Text)) > 0;
//    if Result then
//      dm.execSQL(dm.qexec,'update room set status=''C'' where id_room='+QuotedStr(DM.RoomID));
//  end else
//   if AStr = 'Close' then
//    Result := True else
//    Result := false;
//end;

procedure TFrmPassword.FormShow(Sender: TObject);
begin
  UserName.Text := 'Admin';
  Password.Clear;
  Password.SetFocus;
end;

procedure TFrmPassword.PasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=vk_return then  
    BtnOK.OnClick(Sender);
end;

procedure TFrmPassword.BtnOKClick(Sender: TObject);
var ACount: byte;
begin
ACount := 0;
if (DM.IDTmp = 'Teknisi') OR (DM.IDTmp = 'Close') then
begin
    ACount := dm.getIntegerFromSQL(dm.qexec, 'select count(*) from user_dat '+
    'where username='+quotedStr(UserName.Text)+' and password='+quotedStr(Password.Text));
    if ACount > 0 then
    begin
      if DM.IDTmp = 'Teknisi' then
      begin
//        dm.execSQL(dm.qexec,'update room set status=''C'' where id_room='+QuotedStr(DM.RoomID));
//        dm.execSQL(dm.qexec,'insert into teknisi_log (UserName, StartDate) '+
//        'values ('+QuotedStr(UserName.Text)+','+QuotedStr(FormatDateTime('yyyy-mm-dd hh:mm:ss',Dm.serverNow))+')');
//        DM.IDTeknisi := IntToStr(dm.getIntegerFromSQL(DM.qexec,'select @@identity'));
//        DM.inform('User dan Password Sesuai ...',dm.spSkinMessage1);
        frm_setting.ShowModal;
      end else
      if DM.IDTmp = 'Close' then
      begin
        dm.execSQL(dm.qexec,'update room set status=''A'' where id_room='+QuotedStr(DM.RoomID));
        dm.getScreenResolution;
        Application.Terminate;
      end;
      Close;
    end else
    begin
      dm.alert('Password tidak dikenal ..!', dm.spSkinMessage1);
//      BtnOK.ModalResult := mrNone;
    end;
end;
end;

procedure TFrmPassword.UserNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=vk_return then
    Password.SetFocus;
end;

end.
