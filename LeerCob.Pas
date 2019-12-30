program cobrar;
uses
crt;
type
RegCobranza = record
 Pcobro: integer;
 NclienteFact: integer;
 NumCuota: integer;
 Monto: real
end;
Cobranza = file of RegCobranza;
var
ArchCob: Cobranza;
RegCob: RegCobranza;
a:integer;
begin
	assign(ArchCob, 'C:\COBRANZA.Dat');
	reset(ArchCob);
	writeln('Punto Cobro', 'Cliente':10, 'N Cuota':10, 'Monto':8);
	for a:=0 to filesize(ArchCob)-1 do
	begin
		read(ArchCob, RegCob);
		writeln(RegCob.Pcobro:6, RegCob.NclienteFact:12, RegCob.NumCuota:10, RegCob.Monto:9:2);
		readkey()
	end;
	close(ArchCob)
end.
