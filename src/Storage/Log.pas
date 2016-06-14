(************************************

	P1 Reader
	(c) Thomas Smit 2016
	http://www.sleepybuildings.nl
	
*************************************)

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}
  
{$I+}

unit Log;

interface

uses TelegramParser, StorageInterface;

type	
	TLog = class(TInterfacedObject, IStorageInterface)
	public
		procedure HandleTelegram(Telegram: PTelegram);
	end;
	
implementation

uses Config, Sysutils;


procedure TLog.HandleTelegram(Telegram: PTelegram);
var
	Handle: TextFile;
	LogFilename: string;
begin
	LogFilename := TConfig.Instance.LogFilename;
	
	if Length(LogFilename) = 0 then
		LogFilename := 'p1reader.log';
		
	AssignFile(Handle, LogFilename);		
	try
		if not FileExists(LogFilename) then
			Rewrite(Handle)
		else	
			Append(Handle);
		
		Write(Handle, LineEnding);
		Write(Handle, Telegram^.Version);
		Write(Handle, ',');
		Write(Handle, DateTimeToStr(Telegram^.SendAt));
		Write(Handle, ',');
		Write(Handle, Format('%.3f', [Telegram^.MeterInNormal]));
		Write(Handle, ',');
		Write(Handle, Format('%.3f', [Telegram^.MeterInLow]));
		Write(Handle, ',');
		Write(Handle, Format('%.3f', [Telegram^.PowerIn]));
		Write(Handle, ',');
		Write(Handle, Format('%.3f', [Telegram^.L1]));
		
		CloseFile(Handle);
	except
		on E: EInOutError do
			Writeln('Logger driver: Cannot write logfilename: ' + E.message);
	end;		
end;		
	

end.