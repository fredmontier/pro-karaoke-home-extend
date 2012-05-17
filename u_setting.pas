unit u_setting;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,Registry,
  Dialogs, u_dm, DynamicSkinForm, StdCtrls, SkinCtrls, Mask, SkinBoxCtrls,
  RzButton, RzRadChk, AdvEdit, AdvGlowButton, StrUtils, RzCmboBx, RzShellCtrls, ComCtrls, RzTreeVw,
  RzFilSys, spDialogs;

type
  Tfrm_setting = class(TForm)
    spDynamicSkinForm1: TspDynamicSkinForm;
    spSkinButton1: TspSkinButton;
    spSkinGroupBox1: TspSkinGroupBox;
    Edit1: TspSkinEdit;
    PanelSetting: TspSkinPanel;
    AdvGlowButton1: TAdvGlowButton;
    FontType: TAdvEdit;
    FontSize: TAdvEdit;
    spSkinPanel2: TspSkinPanel;
    LabelSample: TLabel;
    FontDialog: TspSkinFontDialog;
    spSkinStdLabel1: TspSkinStdLabel;
    edPass: TspSkinPasswordEdit;
    RzCheckBox1: TRzCheckBox;
    procedure spSkinButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AdvGlowButton1Click(Sender: TObject);
  private
    function getDurasi(Lama: real): TDateTime;
    procedure setCtrlAltDelete;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_setting: Tfrm_setting;

implementation

uses u_main;

{$R *.dfm}

procedure EnableCTRLALTDEL(YesNo : boolean);
const
sRegPolicies = '\Software\Microsoft\Windows\CurrentVersion\Policies';
begin
  with TRegistry.Create do
  try
    RootKey:=HKEY_CURRENT_USER;
    if OpenKey(sRegPolicies+'\System\',True) then
    begin
      case YesNo of
        False:
          begin
            WriteInteger('DisableTaskMgr',1);
          end;
        True:
          begin
            WriteInteger('DisableTaskMgr',0);
          end;
      end;
    end;
    CloseKey;
    if OpenKey(sRegPolicies+'\Explorer\',True) then
    begin
      case YesNo of
        False:
          begin
            WriteInteger('NoChangeStartMenu',1);
            WriteInteger('NoClose',1);
            WriteInteger('NoLogOff',1);
          end;
        True:
          begin
            WriteInteger('NoChangeStartMenu',0);
            WriteInteger('NoClose',0);
            WriteInteger('NoLogOff',0);
          end;
      end;
    end;
    CloseKey;
  finally
    Free;
  end;
end;


function Tfrm_setting.getDurasi(Lama: real): TDateTime;
var ADurasi: String;
begin
  ADurasi := FloatToStr(Lama * 60);
  DM.openSQL(dm.qexec,'select date_add(NOW(), interval '+ADurasi+' minute)');
  Result := dm.qexec.Fields[0].AsDateTime;
end;

procedure Tfrm_setting.AdvGlowButton1Click(Sender: TObject);
begin
  if FontDialog.Execute then
  begin
    FontType.Text := FontDialog.Font.Name;
    FontSize.Text := IntToStr(FontDialog.Font.Size);
    LabelSample.Caption := 'PRO KARAOKE!';
    LabelSample.Font.Name := FontDialog.Font.Name;
    LabelSample.Font.Size := FontDialog.Font.Size;
    LabelSample.Font.Color := FontDialog.Font.Color;
  end;
end;

procedure Tfrm_setting.FormShow(Sender: TObject);
begin
  Edit1.Text := '0';
  RzCheckBox1.Checked := not DM.ALTDEL;
  edPass.Text := dm.getStringFromSQL(DM.qexec,'select password from user_dat where username=''admin''');
end;

procedure Tfrm_setting.setCtrlAltDelete;
var RegDatabase : TRegistry;
begin
  try
    RegDatabase := TRegistry.Create;
    RegDatabase.OpenKey(DATABASE_PATH, True);
    RegDatabase.WriteString('EnableCtrlAltDelete',IfThen(DM.ALTDEL=True,'Yes','No'));
  finally
    RegDatabase.CloseKey;
    RegDatabase.Free;
  end;
end;

procedure Tfrm_setting.spSkinButton1Click(Sender: TObject);
var ServerVideo: String;
begin
  ServerVideo := '';
//  ShowMessage(FormatDateTime('yyyy-mm-dd hh:mm:ss', getDurasi(StrToFloat(Edit1.Text))));
  if (Length(Edit1.Text) > 0) AND (StrToFloat(Edit1.Text) > 0) then begin
    DM.execSQL(DM.qexec,'update room set selesai = '+QuotedStr(FormatDateTime('yyyy-mm-dd hh:mm:ss', getDurasi(StrToFloat(Edit1.Text)))));
    DM.TeknisiMode := True;
  end;
//  if (Length(edPass.Text) > 0) then
    DM.execSQL(DM.qexec,'update user_dat set password = '+QuotedStr(edPass.Text));
  if (Length(FontType.Text) > 0) AND (Length(FontSize.Text) > 0) then begin
    DM.execSQL(DM.qexec,'update setting set '+
    'FontName = '+QuotedStr(FontType.Text)+','+
    'FontSize='+FontSize.Text+','+
    'FontStyle='+QuotedStr(ColorToString(FontDialog.Font.Color)));
    form1.gerScreenSize(1024, 768);
  end;
  DM.ALTDEL := not RzCheckBox1.Checked;
  EnableCTRLALTDEL(DM.ALTDEL);
  setCtrlAltDelete;
  close;
end;

end.
