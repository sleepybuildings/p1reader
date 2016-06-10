(************************************

	P1 Reader
	(c) Thomas Smit 2016
	http://www.sleepybuildings.nl
	
*************************************)

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

unit Reader;

interface

uses TelegramBuffer, classes, SerialReader;

type
	TReader = class(TThread)
	private
		FBaudrate: integer;
		FDevice: string;
		
		FBuffer: TTelegramBuffer;
		FSerialReader: TSerialReader;
		
		(* Binding events *)
		procedure OnReceivedLine(Line: string);
		procedure OnTelegramReceived(ReceivedTelegram: TStrings);
			
		procedure SetBaudRate(BaudRate: integer);
		procedure SetDevice(Device: string);		

	protected
		procedure Execute; override;
	public
		constructor Create(CreateSuspended: boolean);
		destructor Destroy; override;
		
 		property Baudrate: integer write SetBaudRate;
 		property Device: string write SetDevice;
	end;

implementation


constructor TReader.Create(CreateSuspended: boolean);
begin
	inherited Create(CreateSuspended);
	
	FBuffer := TTelegramBuffer.Create;
	FBuffer.OnCompleteTelegram := OnTelegramReceived;
	
	FSerialReader := TSerialReader.Create();
	FSerialReader.OnReceivedLine := OnReceivedLine;
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
begin
	writeLn('COMPLETE TELEGRAM!!!');
	
end;	


end.