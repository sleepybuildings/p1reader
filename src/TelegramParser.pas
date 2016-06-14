(************************************

	P1 Reader
	(c) Thomas Smit 2016
	http://www.sleepybuildings.nl
	
*************************************)

{$IFDEF FPC}
	{$MODE objfpc}
	{$H+}
{$ENDIF}

unit TelegramParser;

interface

uses SysUtils, Classes, Math;

type
	PTelegram = ^TTelegram;
	TTelegram = record
		Version: integer;
		SendAt: TDateTime;
		MeterInNormal: Double;  // kWh
		MeterInLow: Double;     // kWh
		PowerIn: Double;        // kW
		L1: Double;             // kW
	end;

	TTelegramParser = class(TObject)
	protected
		FFormatSettings: TFormatSettings;
		procedure ParseLine(Line: string; Telegram: PTelegram);
		procedure PrintTelegram(Telegram: PTelegram);	
	public
		constructor Create();
		function Parse(Telegram: TStrings): PTelegram;
	end;

implementation


constructor TTelegramParser.Create();
begin
	FillChar(FFormatSettings, Sizeof(FFormatSettings), 0);
	FFormatSettings.DecimalSeparator := '.';
end;


function TTelegramParser.Parse(Telegram: TStrings): PTelegram;
var
	index: integer;
begin
	New(Result);
	
	Result^.SendAt := Now(); // Valt ook uit te lezen, voornu dit..
	
	for index := 0 to Telegram.Count - 1 do
		ParseLine(Telegram[index], Result);
		
	//PrintTelegram(Result);
end;


procedure TTelegramParser.ParseLine(Line: string; Telegram: PTelegram);
const
   CODE_VERSION     = '1-3:0.2.8';
	CODE_IN_NORMAL   = '1-0:1.8.1';
	CODE_IN_LOW      = '1-0:1.8.2';
	CODE_POWER_IN    = '1-0:1.7.0';
	CODE_L1          = '1-0:21.7.0';
var
	Strpos: integer;
	Code: string;

	function GetNextStringValue(): string;
	var
		TokenStart, TokenEnd: integer;
	begin
		TokenStart := Pos('(', Line) + 1;
		TokenEnd := Pos(')', Line);
		
		if TokenEnd = 0 then
			TokenEnd := Length(Line);
			
		Result := Copy(Line, TokenStart, TokenEnd - TokenStart);
		Line := Copy(Line, TokenEnd + 1, Length(Line));		
		
		TokenStart := Pos('*', Result);
		if TokenStart > 0 then
			Result := Copy(Result, 0, TokenStart - 1);
	end;
	
	
	function GetNextIntegerValue(): integer;
	begin
		result := 0;
		if not TryStrToInt(GetNextStringValue, result) then
			result := 0;
	end;
	
	
	function GetNextFloatValue(): Double;
	begin
		result := 0;
		if not TryStrToFloat(GetNextStringValue, result, FFormatSettings) then
			result := 0;
	end;
	
	
begin
	Strpos := Pos('(', Line);
	Code   := Copy(Line, 0, Strpos - 1);
	Line   := Copy(Line, Strpos, Length(Line) - Strpos + 1);

	case Code of
		CODE_VERSION:     Telegram^.Version := GetNextIntegerValue;
		CODE_IN_NORMAL:   Telegram^.MeterInNormal := GetNextFloatValue;
		CODE_IN_LOW:      Telegram^.MeterInLow := GetNextFloatValue;
		CODE_POWER_IN:    Telegram^.PowerIn := GetNextFloatValue;
		CODE_L1:          Telegram^.L1 := GetNextFloatValue;
	end;
end;


procedure TTelegramParser.PrintTelegram(Telegram: PTelegram);	
begin
	Writeln('Version:         ', Telegram^.Version);
	Writeln('MeterInNormal:   ', Format('%.3f', [Telegram^.MeterInNormal]), ' kWh');
	Writeln('MeterInLow:      ', Format('%.3f', [Telegram^.MeterInLow]), ' kWh');
	Writeln('PowerIn:         ', Format('%.3f', [Telegram^.PowerIn]), ' kW');
	Writeln('CurrentL1:       ', Format('%.3f', [Telegram^.L1]), ' kW');
end;		


end.
