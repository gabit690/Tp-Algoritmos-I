program Indi;
uses
crt;
type
RegIndice = record
 Sucursal: integer;
 Rinicial: integer;
 Rfinal: integer
end;
Indice = file of RegIndice;
var
ArchI: Indice;
RegI: RegIndice;
a:integer;
begin
	assign(ArchI, 'C:\INDICES.Dat');
	reset(ArchI);
	writeln('Sucursal','Inicial':10, 'Final':8);
	for a:=0 to filesize(ArchI)-1 do
	begin
		read(ArchI, RegI);
		writeln(RegI.Sucursal:5, RegI.Rinicial:10, RegI.Rfinal:10);
		readkey();
	end;
	close(ArchI)
end.
