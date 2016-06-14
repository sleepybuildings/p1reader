program parsertest;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

uses classes, sysutils, TelegramParser;

var
	Parser: TTelegramparser;
	Msg: TStringlist;
	
	
begin
	Parser :=  TTelegramparser.Create;
	Msg := TStringlist.Create;
	
	try
		Msg.LoadFromFile('/home/pi/testmsg.txt');
		Parser.Parse(Msg);
	finally
		Msg.Free;
		Parser.Free;
	end;		
end.
