program parsertest;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

uses classes, sysutils, TelegramParser;

var 
	Telegram: TTelegram;
	Parser: TTelegramparser;
	Msg: TStringlist;
	
	
begin
	Parser :=  TTelegramparser.Create;
	Msg := TStringlist.Create;
	
	try
		Msg.LoadFromFile('~/testmsg.txt');
		Telegram := Parser.Parse(Msg);
	finally
		Msg.Free;
		Parser.Free;
	end;		
end.