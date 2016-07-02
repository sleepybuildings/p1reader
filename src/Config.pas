(************************************

	P1 Reader
	Copyright (c) 2016, Thomas Smit - All rights reserved
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
		FStorageDriverName: string;
		FLogFilename: string;
		
		FMySQLHostname: string;
		FMySQLUsername: string;
		FMySQLPassword: string;
		FMySQLDatabase: string;
		FMySQLTable: string;
		
		FExternalCmd: string;
		FExternalArgs: string;
	public
		procedure LoadConfig(Filename: String);
		class function Instance(): TConfig;
		
		property MeterDevice: string read FMeterDevice;
		property MeterBaudRate: integer read FMeterBaudrate;
		
		property StorageDriverName: string read FStorageDriverName;
		property LogFilename: string read FLogFilename;
		
		property MySQLHostname: string read FMySQLHostname;
		property MySQLUsername: string read FMySQLUsername;
		property MySQLPassword: string read FMySQLPassword;
		property MySQLDatabase: string read FMySQLDatabase;
		property MySQLTable:    string read FMySQLTable;
		
		property ExternalArgs:  string read FExternalArgs;
		property ExternalCmd:   string read FExternalCmd;
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
	SECTION_METER    = 'meter';
	SECTION_MYSQL    = 'mysql';
	SECTION_GENERIC  = 'generic';
	SECTION_EXTERNAL = 'external';
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
		
		FStorageDriverName := IniFile.ReadString(SECTION_GENERIC, 'storage', '');
		FLogFilename := IniFile.ReadString(SECTION_GENERIC, 'log', '');
		
		FMySQLHostname := IniFile.ReadString(SECTION_MYSQL, 'hostname', '127.0.0.1');
		FMySQLUsername := IniFile.ReadString(SECTION_MYSQL, 'username', '');
		FMySQLPassword := IniFile.ReadString(SECTION_MYSQL, 'password', '');
		FMySQLDatabase := IniFile.ReadString(SECTION_MYSQL, 'database', '');
		FMySQLTable    := IniFile.ReadString(SECTION_MYSQL, 'tablename','');
		
		FExternalCmd   := IniFile.ReadString(SECTION_EXTERNAL, 'cmd',  '');
		FExternalArgs  := IniFile.ReadString(SECTION_EXTERNAL, 'args', '');
		
	finally
		IniFile.Free;
	end;		
end;


initialization
	ConfigInstance := TConfig.Create;

finalization
	ConfigInstance.Free;

end.