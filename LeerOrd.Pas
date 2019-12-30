program Ord;
uses
crt;
type
RegOrden = record
 NumCF: integer;
 CuotasImp: integer
end;
Orden = file of RegOrden;
var
ArchO: Orden;
RegO: RegOrden;
a:integer;
begin
	assign(ArchO, 'C:\ORDEN.Dat');
	reset(ArchO);
	writeln('Cantidad de Registros: ', Filesize(ArchO));
	writeln('Numero Cliente','Impagas':12);
	for a:=0 to filesize(ArchO)-1 do
	begin
		read(ArchO, RegO);
		writeln(RegO.NumCF:7, RegO.CuotasImp:8);
		readkey()
	end;
	close(ArchO)
end.
