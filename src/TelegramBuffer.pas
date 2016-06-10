(************************************

	P1 Reader
	(c) Thomas Smit 2016
	http://www.sleepybuildings.nl
	
*************************************)

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

unit TelegramBuffer;

interface

uses SysUtils, Classes;

type
	TOnCompleteTelegram = procedure(ReceivedTelegram: TStrings) of object;
	
	TTelegramBuffer = class(TObject)
	protected
		FBuffer: TStrings;
		FOnCompleteTelegram: TOnCompleteTelegram;
		procedure doOnCompleteTelegram;
	public
		constructor Create();
		destructor Destroy; override;
		
		procedure AddLine(ReceivedLine: string);
		
		property OnCompleteTelegram: TOnCompleteTelegram read FOnCompleteTelegram write FOnCompleteTelegram;
	end;
	
implementation


constructor TTelegramBuffer.Create();
begin
	FBuffer := TStringList.Create;
	FBuffer.Capacity := 22;
end;


destructor TTelegramBuffer.Destroy();
begin
	FBuffer.Free;
	
	inherited Destroy;
end;

procedure TTelegramBuffer.AddLine(ReceivedLine: string);
begin
	if Length(ReceivedLine) = 0 then
		Exit;
				
	case ReceivedLine[1] of
		(*)'!': begin
			// Negeer nog even 
		end;
		*)
		'!': doOnCompleteTelegram();
		else FBuffer.Add(ReceivedLine);
	end;		
end;	


(*
	Maak een copy van de buffer en geef die door
*)
procedure TTelegramBuffer.doOnCompleteTelegram();
var
	Telegram: TStringList;
begin
	if Assigned(FOnCompleteTelegram) then
	begin
		Telegram := TStringList.Create;
		Telegram.assign(FBuffer);
		FBuffer.Clear;
				
		FOnCompleteTelegram(Telegram);
	end;	
end;


end.