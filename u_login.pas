unit u_login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SkinCtrls, ShellAPI, jpeg, ExtCtrls, StdCtrls, Buttons,
  DynamicSkinForm, SkinData;

type
  Tf_login = class(TForm)
    Image1: TImage;
    spSkinStdLabel3: TspSkinStdLabel;
    spSkinStdLabel4: TspSkinStdLabel;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    DSF: TspDynamicSkinForm;
    spSkinData1: TspSkinData;
    cs1024_768: TspCompressedStoredSkin;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AppMessage(var Msg: TMSG; var HAndled: Boolean);
  end;

var
  f_login: Tf_login;

implementation

uses u_dm, u_main;

{$R *.dfm}

function encodePassword(pass:string):string;
var i:integer;
    decodepass:string;
    ch:byte;
begin
   decodepass:='';
   for i:= 1 to length(pass) do
   begin
      ch:=ord(pass[i])-10;
      decodepass:=chr(ch)+decodepass;
   end;
   result:=decodepass;
end;

procedure Tf_login.AppMessage(var Msg: TMSG; var Handled: Boolean);
begin
  // let your application handle all messages initially
  Handled := False;
  case Msg.Message of
    WM_SYSKEYDOWN:
    begin
      if Msg.wParam = VK_F4 {or VK_LWIN or VK_RWIN} then
        Handled := True; // don't allow ALT-F4
      if Msg.wParam = VK_MENU or VK_RMENU then
        Handled := True; // don't allow ALT-F4
    end;
  end;

  if((WM_SYSCOMMAND = Msg.Message) and
    (SC_SCREENSAVE = Msg.wParam) )then
    Handled := True;
end;

procedure Tf_login.Button1Click(Sender: TObject);
begin
  dm.tuser_dat.Open;
  if (dm.tuser_dat.Locate('username',edit1.text,[]))then
  begin
    if encodePassword(dm.tuser_datpassword.Value)=Edit2.Text then
    begin
      ModalResult:=mrOk;
      Form1.username.Caption:=dm.tuser_datusername.Value;
    end else begin
      ShowMessage('Gagal Login! Password tidak benar!');
      Edit2.SetFocus;
    end;
  end else
  begin
    ShowMessage('Gagal Login! User tidak dikenal!');
    Edit1.SetFocus;
  end;
end;

procedure Tf_login.Button2Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure Tf_login.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform (CM_DialogKey, VK_TAB, 0);
  end;
end;

procedure Tf_login.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform (CM_DialogKey, VK_TAB, 0);
    Button1.OnClick(self);
  end;
end;

procedure Tf_login.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  dm.tuser_dat.Close;
  Timer1.Enabled:=false;
end;

procedure ShowStartButton(bvisible: Boolean);
var
h: hwnd;
TaskWindow: hwnd;
begin
if bvisible then
begin
h := FindWindowEx(GetDesktopWindow, 0, 'Button', nil);
TaskWindow := FindWindow('Shell_TrayWnd', nil);
ShowWindow(h, 1);
Windows.SetParent(h, TaskWindow);
end
else
begin
h := FindWindowEx(FindWindow('Shell_TrayWnd', nil), 0, 'Button', nil);
ShowWindow(h, 0);
Windows.SetParent(h, 0);
end;
end;

procedure Tf_login.FormShow(Sender: TObject);
var
  wndTaskbar: HWND;
  hMutex: THandle;
begin
  Timer1.Enabled:=true;
  hMutex := CreateMutex(nil, False, 'termBlaster');
  if WaitForSingleObject (HMutex, 0) = WAIT_TIMEOUT then
  begin
    MessageDlg ('Aplikasi sudah running!', mtInformation, [mbOK], 0);
    Application.Terminate;
    exit;
  end;  wndTaskbar := FindWindow('Shell_TrayWnd', nil);
  if wndTaskbar <> 0 then
  begin
    EnableWindow(wndTaskbar, False);
    ShowWindow(wndTaskbar, SW_HIDE);
    ShowStartButton(False); // or true to reshow
  end;

 ShellExecute(Handle,'open',PChar(ExtractFilePath(Application.ExeName)+'power.cmd'),'','',SW_SHOWNORMAL);
 Application.OnMessage := AppMessage;
 dm.tuser_dat.Open;
end;

procedure Tf_login.Timer1Timer(Sender: TObject);
begin
  try
  dm.ac.Connected := True ;
  dm.qexec2.SQL.Clear;
  dm.qexec2.SQL.Add('select * from room where id_room=''SERVER''');
  dm.qexec2.Open;
  if dm.qexec2.FieldByName('status').AsString='O' then
  begin
    timer1.Enabled:=false;
    ShowMessage('Hilang Koneksi dengan Server, Aplikasi akan dimatikan!');
    Application.Terminate;

    dm.qexec.SQL.Clear;
    dm.qexec.SQL.Add('update room set status=''O'' where id_room='''+form1.Room.Text+'''');
    dm.qexec.Execute;
  end;

  dm.qexec2.SQL.Clear;
  dm.qexec2.SQL.Add('select * from room where id_room='''+Label1.Caption+'''');
  dm.qexec2.Open;
  if dm.qexec2.FieldByName('status').AsString='A' then
  ModalResult:=mrOk;
  except
    timer1.Enabled:=false;
    dm.ac.Connected := False;
    form1.spSkinMessage1.MessageDlg('Hilang koneksi dengan SERVER, aplikasi akan dimatikan!.', mtInformation,
      [mbOk], 0);
    Application.Terminate;
  end;
end;

end.
