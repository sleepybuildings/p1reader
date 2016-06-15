(************************************

	P1 Reader
	Copyright (c) 2016, Thomas Smit - All rights reserved
	http://www.sleepybuildings.nl
	
*************************************)

{$IFDEF FPC}
	{$MODE objfpc}
	{$H+}
{$ENDIF}

unit Reader;

interface

uses TelegramBuffer, classes, SerialReader, StorageInterface, MySQL;

type
	TReader = class(TThread)
	private
		FBaudrate: integer;
		FDevice: string;
		
		FBuffer: TTelegramBuffer;
		FSerialReader: TSerialReader;
		
		FStorageDriverName: string;
		
		(* Binding events *)
		procedure OnReceivedLine(Line: string);
		procedure OnTelegramReceived(ReceivedTelegram: TStrings);
			
		procedure SetBaudRate(BaudRate: integer);
		procedure SetDevice(Device: string);		

	protected
		procedure Execute; override;
		function GetStorageDriver: IStorageInterface;	
	public
		constructor Create(CreateSuspended: boolean);
		destructor Destroy; override;
		
 		property Baudrate: integer write SetBaudRate;
 		property Device: string write SetDevice;
	end;

implementation

uses TelegramParser, Config, Log;

constructor TReader.Create(CreateSuspended: boolean);
begin
	inherited Create(CreateSuspended);
	
	FBuffer := TTelegramBuffer.Create;
	FBuffer.OnCompleteTelegram := @OnTelegramReceived;
	
	FSerialReader := TSerialReader.Create();
	FSerialReader.OnReceivedLine := @OnReceivedLine;
	
	FStorageDriverName := TConfig.Instance().StorageDriverName;
end;

destructor TReader.Destroy;
begin
	FSerialReader.Free;
	FBuffer.Free;
		
	inherited Destroy;
end;	


procedure TReader.SetBaudRate(BaudRate: integer);
begin	
	FSerialReader.Baudrate := BaudRate;
end;	
		
procedure TReader.SetDevice(Device: string);		
begin
	FSerialReader.Device := Device;
end;

procedure TReader.Execute;
begin	
	FSerialReader.Open;
	
	while not Terminated do
	begin
		FSerialReader.ReadLine();
	end;	
end;		

procedure TReader.OnReceivedLine(Line: string);
begin
	FBuffer.AddLine(Line);
end;
		
procedure TReader.OnTelegramReceived(ReceivedTelegram: TStrings);
var
	Parser: TTelegramParser;
	Telegram: PTelegram;
	StorageDriver: IStorageInterface;
begin
	Parser := TTelegramParser.Create;
	try
		Telegram := Parser.Parse(ReceivedTelegram);
		try			
			
			StorageDriver := GetStorageDriver;
			if Assigned(StorageDriver) then
				StorageDriver.HandleTelegram(Telegram);
			
		finally
			Dispose(Telegram);
		end;
	finally
		Parser.Free;
	end;		
end;	


function TReader.GetStorageDriver: IStorageInterface;	
begin
	Result := nil;
	
	case FStorageDriverName of
		'log':   Result := TLog.Create;
		'mysql': Result := TMySQL.Create;
		
		// De log driver is de default, voor het geval dat...
		else Result := TLog.Create
	end;
end;	


end.