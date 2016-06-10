(************************************

	P1 Reader
	(c) Thomas Smit 2016
	http://www.sleepybuildings.nl
	
*************************************)

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

program p1reader;

uses cthreads, crt, sysutils, Reader;//, SerialReader;

const
	APP_VERSION = '0.01';

procedure StartReader(Device: string; Baudrate: integer);
var
	Reader: TReader;
begin
	Writeln('Press [ESC] to stop');
	
	Reader := TReader.Create(true);
	try
		Reader.Device := Device;
		Reader.Baudrate := Baudrate;
		
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
	Writeln('P1 Reader ', APP_VERSION, ' - (c) Thomas Smit 2016');
	Writeln('');
end;		


procedure PrintCommandlineArguments();
begin
	Writeln('Usage:');
	Writeln(#9, ExtractFilename(ParamStr(0)), ' devicename baudrate');
	Writeln('');
end;


procedure WaitForUser();
begin
end;	

procedure Start();
var
	Baudrate: integer;
begin
	if (ParamCount < 2) or not TryStrToInt(Paramstr(2), Baudrate) then
	begin
		PrintCommandlineArguments;
		Halt;
	end;
	
	StartReader(ParamStr(1), Baudrate);
end;	

begin
	PrintBanner;
	Start;			
end.