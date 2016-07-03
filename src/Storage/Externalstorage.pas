(************************************

	P1 Reader
	Copyright (c) 2016, Thomas Smit - All rights reserved
	http://www.sleepybuildings.nl
	
*************************************)

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}
  
{$I+}

unit Externalstorage;

interface

uses Process, TelegramParser, StorageInterface;

type	
	TExternalstorage = class(TInterfacedObject, IStorageInterface)
	private 	
		procedure Push(const data: string);
	public
		procedure HandleTelegram(Telegram: PTelegram);
	end;
	
implementation

uses Config, Sysutils;


procedure TExternalstorage.Push(const data: string);
var
	Config: TConfig;
	Process: TProcess;
begin
	Config := TConfig.Instance();

	Process := TProcess.Create(nil);
	try
		Process.CommandLine := Config.ExternalCmd + ' ' + Config.ExternalArgs;
		
//		Process.Executable := Config.ExternalCmd;
//		Process.Parameters.Add(Config.ExternalArgs);
		
		Process.Options := Process.Options + [poUsePipes];
		Process.Execute;
		
		Process.Input.Write(data[1] , Length(data));
		
		Process.WaitOnExit();
		
	finally
		Process.Free;
	end;			
end;

	
procedure TExternalstorage.HandleTelegram(Telegram: PTelegram);
var
	Output: string;
begin		
	Output := IntToStr(Telegram^.Version);
	Output := Output + ',';
	Output := Output + DateTimeToStr(Telegram^.SendAt);
	Output := Output + ',';
	Output := Output + Format('%.3f', [Telegram^.MeterInNormal]);
	Output := Output + ',';
	Output := Output + Format('%.3f', [Telegram^.MeterInLow]);
	Output := Output + ',';
	Output := Output + Format('%.3f', [Telegram^.PowerIn]);
	Output := Output + ',';
	Output := Output + Format('%.3f', [Telegram^.L1]);
	Output := Output + LineEnding;

	Push(Output);
end;		
	

end.