program ProKaraokeHomeExtend;

uses
  Forms,
  u_dm in 'u_dm.pas' {dm: TDataModule},
  u_effect in 'u_effect.pas' {f_effect},
  u_layar in 'u_layar.pas' {Form3},
  u_login in 'u_login.pas' {f_login},
  u_main in 'u_main.pas' {Form1},
  u_open_song in 'u_open_song.pas' {f_open_song},
  u_saran in 'u_saran.pas' {f_saran},
  u_save_song in 'u_save_song.pas' {f_save_song},
  xVideo in 'xVideo.pas',
  u_record in 'u_record.pas' {FrmRecord},
  uPassword in 'uPassword.pas' {FrmPassword},
  u_Help in 'u_Help.pas' {frm_Help},
  uPopup in 'uPopup.pas' {FrmPupop},
  uSplashScreen in 'uSplashScreen.pas' {FrmSpalshScreen},
  u_setting in 'u_setting.pas' {frm_setting};

{$R *.res}

begin
  with TFrmSpalshScreen.Create(Application) do
  begin
    try
      Show;
      Application.Initialize;
      while Timer1.Enabled do Application.ProcessMessages;
//      while execute = false do Application.ProcessMessages;
    finally
      Free;
    end;
  end;

//  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Tf_open_song, f_open_song);
  Application.CreateForm(Tf_login, f_login);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(Tf_effect, f_effect);
  Application.CreateForm(Tf_saran, f_saran);
  Application.CreateForm(Tf_save_song, f_save_song);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFrmRecord, FrmRecord);
  Application.CreateForm(TFrmPassword, FrmPassword);
  Application.CreateForm(Tfrm_Help, frm_Help);
  Application.CreateForm(TFrmPupop, FrmPupop);
  Application.CreateForm(TFrmSpalshScreen, FrmSpalshScreen);
  Application.CreateForm(Tfrm_setting, frm_setting);
  Application.Run;
end.
