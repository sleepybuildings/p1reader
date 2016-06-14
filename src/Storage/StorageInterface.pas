(************************************

	P1 Reader
	(c) Thomas Smit 2016
	http://www.sleepybuildings.nl
	
*************************************)

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

unit StorageInterface;

interface
	
uses TelegramParser;

const
	SStorageInterfaceGuid = '{5D1ABCAA-B65A-41D3-86EE-0F26AA3BCD45}';

type	
	IStorageInterface = interface
		[SStorageInterfaceGuid]
		procedure HandleTelegram(Telegram: PTelegram);
	end;
	
implementation

end.