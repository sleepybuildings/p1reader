(************************************

	P1 Reader
	Copyright (c) 2016, Thomas Smit - All rights reserved
	http://www.sleepybuildings.nl
	
*************************************)

{$mode objfpc}{$H+}

program p1reader;


uses cthreads, crt, sysutils, Reader, Config;

const
	APP_VERSION = '0.03';


procedure StartReader();
var
	Reader: TReader;
	Config: TConfig;
begin
	Writeln('Press [ESC] to stop');
	
	Config := TConfig.Instance();
	if (Length(Config.MeterDevice) = 0) or (Config.MeterBaudrate <= 0) then
	begin
		Writeln('Invalid configuration!');
		exit;
	end;
	
	Reader := TReader.Create(true);
	try
		Reader.Device := Config.MeterDevice;
		Reader.Baudrate := Config.MeterBaudrate;
		
		Reader.Start;
		
		while true do
		begin
			Sleep(100);
			if KeyPressed and (ReadKey = #27) then
			begin
				Writeln('');
				Writeln('Stopping Reader...');
				
				Reader.Terminate;
				Reader.WaitFor;
				
				break;
			end;
		end;
	finally
		Reader.Free;
	end;		
end;


procedure PrintBanner();
begin
	Writeln('P1 Reader ', APP_VERSION, ' - Copyright (c) 2016, Thomas Smit - All rights reserved.');
	Writeln(' - https://github.com/sleepybuildings/p1reader');
	Writeln('');
end;		


procedure PrintCommandlineArguments();
begin
	Writeln('Usage:');
	Writeln(#9, ExtractFilename(ParamStr(0)), ' configfilename');
	Writeln('');
end;


procedure Start();
begin
	if ParamCount < 1 then
	begin
		PrintCommandlineArguments;
		Halt;
	end;
	
	try
		TConfig.Instance.LoadConfig(ParamStr(1));
	Except
		On E: Exception do
		begin
			Writeln('Configuration error: ' + E.Message);
			Exit;
		end;	
	end;		
	
	StartReader();
end;	

begin
	PrintBanner;
	Start;			
end.