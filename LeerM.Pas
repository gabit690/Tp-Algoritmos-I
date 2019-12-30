program Master;
uses
crt;
type
RegCuota = record
 Valor: real;
 Estado: char
end;
Acuotas = Array[1..12] of RegCuota;
RegMaestro = record
 NumClienteFact: integer;
 ValorVenta: real;
 CantCuotas: integer;
 Cuotas: Acuotas
end;
Maestro = file of RegMaestro;
var
ArchM: Maestro;
RegM: RegMaestro;
a, b:integer;
begin
	assign(ArchM, 'C:\MAESTRO.Dat');
	reset(ArchM);
	writeln('Cantidad de Registros: ', Filesize(ArchM));
	writeln('1: IMPRIMIR DATOS SIMPLES, 2: IMPRIMIR ARREGLO');
	readln(b);
	if b=1 then begin
		writeln('Cliente', 'Importe':10, 'Cuotas':9);
		for a:=0 to filesize(ArchM)-1 do
		begin
			read(ArchM, RegM);
			writeln(RegM.NumClienteFact:4, RegM.ValorVenta:14:2, RegM.CantCuotas:10);
			readkey()
		end
	end
	else begin
		if b=2 then begin
			for a:=0 to filesize(ArchM)-1 do
			begin
				writeln('Valor':8,'Estado':8);
				read(ArchM, RegM);
				for b:=1 to RegM.CantCuotas do
				begin
					writeln(RegM.Cuotas[b].Valor:7:2, RegM.Cuotas[b].Estado:7);
					readkey()
				end;
				clrscr
			end
		end
	end;
	close(ArchM)
end.
