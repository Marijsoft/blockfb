{*******************************************************}
{                                                       }
{       Blocca tutti i servizi di FessMerd              }
{                                                       }
{       Copyright (C) 2018 AL                           }
{                                                       }
{*******************************************************}



unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

type
  TStreamHandle = pointer;

implementation

{$R *.dfm}
uses
  system.ioutils{$IFDEF LINUX64 or MACOS}, Posix.Stdio, Posix.Unistd, Posix.Base,
  Posix.Fcntl{$ENDIF};

{$IFDEF LINUX64}
function popen(const command: MarshaledAString; const _type: MarshaledAString): TStreamHandle; cdecl; external libc name _PU + 'popen';

function pclose(filehandle: TStreamHandle): int32; cdecl; external libc name _PU + 'pclose';

function fgets(buffer: pointer; size: int32; Stream: TStreamHAndle): pointer; cdecl; external libc name _PU + 'fgets';

function BufferToString(Buffer: pointer; MaxSize: uint32): string;
var
  cursor: ^uint8;
  EndOfBuffer: nativeuint;
begin
  Result := '';
  if not assigned(Buffer) then
  begin
    exit;
  end;
  cursor := Buffer;
  EndOfBuffer := NativeUint(cursor) + MaxSize;
  while (NativeUint(cursor) < EndOfBuffer) and (cursor^ <> 0) do
  begin
    Result := Result + chr(cursor^);
    cursor := pointer(succ(NativeUInt(cursor)));
  end;
end;
{$ENDIF}

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  fuckfb: TStringList;
  filehost: string;
  Handle: TStreamHandle;
  Data: array[0..511] of uint8;
begin
  Memo1.Lines.Add('Backup..');
{$IFDEF MSWINDOWS}
  CopyFile('C:\WINDOWS\system32\drivers\etc\hosts', 'C:\WINDOWS\system32\drivers\etc\hosts.bk', true);
  Memo1.Lines.Add('Start to blocked all of facebook');
  filehost := 'C:\WINDOWS\system32\drivers\etc\hosts';
{$ENDIF}
{$IFDEF LINUX64}
  Handle := popen('cp /etc/hosts /etc/hostsb', 'r');
  try
    while fgets(@Data[0], Sizeof(Data), Handle) <> nil do
    begin
      Write(BufferToString(@Data[0], sizeof(Data)));
    end;
  finally
    pclose(Handle);
  end;
//TFile.Copy('/etc/hosts','/etc/hostsb',True);
  Memo1.Lines.Add('Start to blocked all of facebook');
  filehost := '/etc/hosts';
{$ENDIF}
{$IFDEF MACOS}
  CopyFile('/etc/hosts', '/etc/hostsb', True);
  Memo1.Lines.Add('Start to blocked all of facebook');
  filehost := '/etc/hosts';
{$ENDIF}
  fuckfb := TStringList.Create;
  try
    fuckfb.LoadFromFile(filehost);
    fuckfb.AddStrings(Memo2.Lines);
    Memo1.Lines.Add('Apply blocked');
    fuckfb.SaveToFile(filehost);
  finally
    fuckfb.Free;
  end;
  Memo1.Lines.Add('Total block of facebook completed!');
  BitBtn1.Enabled := false;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  DeleteFile('C:\WINDOWS\system32\drivers\etc\hosts');
  RenameFile('C:\WINDOWS\system32\drivers\etc\hosts.bk', 'C:\WINDOWS\system32\drivers\etc\hosts');
  DeleteFile('C:\WINDOWS\system32\drivers\etc\hosts.bk');
{$ENDIF}
{$IFDEF LINUX64 or MACOS}
  DeleteFile('/etc/hosts');
  RenameFile('/etc/hostsb', '/etc/hosts');
  DeleteFile('/etc/hostsb');
{$ENDIF}
  Memo1.Lines.Add('Access to facebook restored!');
  BitBtn1.Enabled := true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  if FileExists('C:\WINDOWS\system32\drivers\etc\hosts.bk', True) then
  begin
    BitBtn1.Enabled := false;
    BitBtn2.Enabled := true;
  end
  else
  begin
    BitBtn1.Enabled := true;
    BitBtn2.Enabled := false;
  end;
{$ENDIF}
{$IFDEF LINUX64 or MACOS}
  if FileExists('/etc/hostsb', True) then
    BitBtn1.Enabled := false;
{$ENDIF}
{$IFDEF LINUX64 or MACOS}
  if not FileExists('/etc/hostsb') then
    BitBtn2.Enabled := False;
{$ENDIF}
end;

end.

