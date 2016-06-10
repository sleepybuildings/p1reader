program p1reader;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}

uses synaser, sysutils;

var 
	Serial: TblockSerial;
	x: integer = 0;
	
	
begin
	Serial := TBlockSerial.Create;
	try	
		//Serial.RaiseException := true;
		Serial.Connect('/dev/ttyUSB0');
		sleep(1000); 
		Serial.Config(115200, 8, 'N', 6, false, false);
		sleep(1000);
		
	//	while not (Serial.LastError <> 0) do
		while true do
		begin
			inc(x);
			writeln(x, ' READ ', Serial.Recvstring(1000));	
			
			(*if Serial.LastError = ErrPortNotOpen then
			begin
				writeln('ErrPortNotOpen');
				break;
			end;	
			*)		
			
			//if Serial.LastError <> 0 then break;
			
		end;	
		
		writeln('last error: ', Serial.LastError, ' -> ', Serial.GetErrorDesc(Serial.LastError));
		
		
	finally
		Serial.CloseSocket;
		Serial.Free;
	end;
			
end.