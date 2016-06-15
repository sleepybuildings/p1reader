program sql;

{$mode objfpc}{$H+}

(*

	CREATE TABLE `test` (
	  `test` varchar(20) NOT NULL DEFAULT ''
	) ENGINE=InnoDB;

*)

uses mysql55conn, sqldb, sysutils;

var
	Connection: TMySQL55Connection;
	Query: TSQLQuery;
	Transaction: TSQLTransaction;

begin
	
	Connection := TMySQL55Connection.Create(nil);
	Transaction := TSQLTransaction.Create(nil);
	Query := TSQLQuery.Create(nil);
	
	try
		Connection.Hostname := '127.0.0.1';
		Connection.Username := '';
		Connection.Password := '';
		Connection.DatabaseName := '';
		
		try
			
		
			Connection.Transaction := Transaction;
			Connection.Connected := true;
		
			Query.Sql.Text := 'INSERT INTO test (test) VALUES("koe vis eend")';
			Query.Database := Connection;
			Query.Transaction := Transaction;
		
			Query.ExecSQL();
			Transaction.Commit;
		
			Writeln('write: ', Query.Sql.Text);
		except
			on e: exception do Writeln('MySQL error: ' + e.message);
		end;	
			
		
	finally
		Query.Free;
		
		Transaction.Free;
		Connection.Free;
	end;		

end.