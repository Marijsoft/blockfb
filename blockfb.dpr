program blockfb;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Vcl.Themes{$IFDEF MSWINDOWS},
  Vcl.Styles{$ENDIF};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Tablet Light');
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
