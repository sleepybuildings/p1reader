(************************************

	P1 Reader
	(c) Thomas Smit 2016
	http://www.sleepybuildings.nl
	
*************************************)

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

unit Config;

interface

uses SysUtils, Classes;

type	
	TConfig = class(TObject)
	protected
		FMeterDevice: string;
		FMeterBaudrate: integer;
		
	public
		procedure LoadConfig(Filename: String);
		class function Instance(): TConfig;
		
		property MeterDevice: string read FMeterDevice;
		property MeterBaudRate: integer read FMeterBaudrate;
	end;
	
	
implementation

uses Inifiles;

var
	ConfigInstance: TConfig;


class function TConfig.Instance(): TConfig;
begin
	Result := ConfigInstance;
end;


procedure TConfig.LoadConfig(Filename: string);
const
	SECTION_METER = 'meter';
	SECTION_MYSQL = 'mysql';
var
	IniFile: TIniFile;
	
	function ReadInteger(const Section, Entry: string): integer;
	begin
		Result := 0;
		TryStrToInt(IniFile.ReadString(Section, Entry, '0'), result);
	end;	
	
begin
	if not FileExists(Filename) then
		raise Exception.Create('Configuration file not found');
	
	IniFile := TINiFile.Create(Filename);
	try		
		FMeterDevice := IniFile.ReadString(SECTION_METER, 'device', '');
		FMeterBaudrate := ReadInteger(SECTION_METER, 'baudrate');
		
		
	finally
		IniFile.Free;
	end;		
end;


initialization
	ConfigInstance := TConfig.Create;

finalization
	ConfigInstance.Free;

end.