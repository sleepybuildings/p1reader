(************************************

	P1 Reader
	Copyright (c) 2016, Thomas Smit - All rights reserved
	http://www.sleepybuildings.nl
	
*************************************)

{$mode objfpc}{$H+}


unit MySQL;

interface

uses mysql55conn, sqldb, Sysutils, TelegramParser, StorageInterface, Classes;

type	
	TMySQL = class(TInterfacedObject, IStorageInterface)
	private 
		procedure RunInsert(QueryStr: TStringlist);
	public
		procedure HandleTelegram(Telegram: PTelegram);
	end;
	
implementation

uses Config;

procedure TMySQL.HandleTelegram(Telegram: PTelegram);
var
	Query: TStringList;
begin
	Query := TStringList.Create;
	try
		with Query do
		begin
			Add('INSERT INTO ');
			Add(TConfig.Instance.MySQLTable);
			Add('(version, send_at, meter_in_normal, meter_in_low, power_in, l1) VALUES(');
			
			Add(IntToStr(Telegram^.Version));
			Add(', NOW(), ');
			Add(Format('%.3f, %.3f, %.3f, %.3f', [
				Telegram^.MeterInNormal,
				Telegram^.MeterInLow,
				Telegram^.PowerIn,
				Telegram^.L1
			]));
			
			Add(')');		
		end;
		
		RunInsert(Query);
	finally
		Query.Free;
	end;			
end;		


procedure TMySQL.RunInsert(QueryStr: TStringlist);
var
	Connection: TMySQL55Connection;
	Query: TSQLQuery;
	Transaction: TSQLTransaction;
	Config: TConfig;
begin
	Config := TConfig.Instance();
	
	Connection := TMySQL55Connection.Create(nil); 
	Transaction := TSQLTransaction.Create(nil);
	Query := TSQLQuery.Create(nil);
	try
		Connection.Hostname     := Config.MySQLHostname;
		Connection.Username     := Config.MySQLUsername;
		Connection.Password     := Config.MySQLPassword;
		Connection.DatabaseName := Config.MySQLDatabase;
		
		try
			Connection.Transaction := Transaction;
			Connection.Open;
			
			Query.Sql.Assign(QueryStr);
			Query.Database := Connection;
			Query.Transaction := Transaction;
				
			Query.ExecSQL();
			Transaction.Commit;
			
		except
			// Meh
			on e: exception do Writeln('MySQL Driver error: ' + e.message + ' for query ' + QueryStr.Text);
		end;	
	finally
		Query.Free;
		Transaction.Free;
		Connection.Free;
	end;
end;		


end.