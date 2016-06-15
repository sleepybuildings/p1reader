program sql;

{$mode objfpc}{$H+}

(*

	CREATE TABLE `test` (
	  `test` varchar(20) NOT NULL DEFAULT ''
	) ENGINE=InnoDB;

*)

uses mysql55conn, sqldb;

var
	Connection: TMySQL55Connection;
	Query: TSQLQuery;
	Transaction: TSQLTransaction;

begin
	
	Connection := TMySQL55Connection.Create(nil);
	Transaction := TSQLTransaction.Create(nil);
	try
		Connection.Hostname := '127.0.0.1';
		Connection.Username := '';
		Connection.Password := '';
		Connection.DatabaseName := '';
		
		Connection.Transaction := Transaction;
		Connection.Connected := true;
		
		Query := TSQLQuery.Create(nil);
		try
			Query.Sql.Text := 'INSERT INTO test (test) VALUES("lalalalaal")';
			Query.Database := Connection;
			Query.Transaction := Transaction;
			
			Query.ExecSQL();
			Transaction.Commit;
			Writeln('write?');
		finally
			Query.Free;
		end;	
		
	finally
		Transaction.Free;
		Connection.Free;
	end;		

end.