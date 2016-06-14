(************************************

	P1 Reader
	Copyright (c) 2016, Thomas Smit - All rights reserved
	http://www.sleepybuildings.nl
	
*************************************)

{$IFDEF FPC} 
  {$MODE DELPHI}
{$ENDIF}

unit SerialReader;

interface

uses SysUtils, Synaser, TelegramBuffer;

type
	TOnReceivedLine = procedure(Line: String) of object;
	
	TSerialReader = class(TObject)
	private
		FBaudrate: integer;
		FDevice: string;
		FConnection: TBlockSerial;
		FOnReceivedLine: TOnReceivedLine;
		procedure DoOnReceivedLine(Line: string);
	public
		constructor Create();
		destructor Destroy; override;
		
		procedure Open;
		procedure Close;	
		procedure ReadLine;	
		
		property Baudrate: integer read FBaudrate write FBaudrate;
		property Device: string read FDevice write FDevice;
		property OnReceivedLine: TOnReceivedLine read FOnReceivedLine write FOnReceivedLine;
	end;
	
implementation

constructor TSerialReader.Create();
begin
	FConnection := TBlockSerial.Create();
end;


destructor TSerialReader.Destroy();
begin
	Close;
	FConnection.Free;
	
	inherited Destroy;
end;


procedure TSerialReader.Open();
begin
	if Length(FDevice) = 0 then
		raise Exception.Create('Device is empty!');
		
	FConnection.Connect(FDevice);
	FConnection.Config(FBaudrate, 8, 'N', 6, false, false);
	
	if FConnection.LastError = ErrPortNotOpen then
		raise Exception.Create('Port not open!');
end;
	

procedure TSerialReader.Close();
begin
	FConnection.CloseSocket;
end;	


procedure TSerialReader.ReadLine();
var 
	Received: string;
begin
	Received := FConnection.Recvstring(1000);
	
	if Length(Received) > 0 then
		DoOnReceivedLine(Received);
end;	


procedure TSerialReader.DoOnReceivedLine(Line: string);
begin
	if Assigned(FOnReceivedLine) then
		FOnReceivedLine(Line);
end;		

end.