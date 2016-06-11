(************************************

	P1 Reader
	(c) Thomas Smit 2016
	http://www.sleepybuildings.nl
	
*************************************)

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

unit TelegramParser;

interface

uses SysUtils, Classes;

type
		
	TTelegram = record
		t1: double;
	
	end;
	
	TTelegramParser = class(TObject)
	protected
	public
		constructor Create();
	
		function Parse(Telegram: TStrings): TTelegram;
	end;
	
implementation


constructor TTelegramParser.Create();
begin

end;

function TTelegramParser.Parse(Telegram: TStrings): TTelegram;
begin
	
	
end;	



end.