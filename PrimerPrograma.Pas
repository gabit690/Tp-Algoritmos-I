program TP;
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
Maestro = file of RegMaestro;	{Archivo de ventas finan. registradas}
RegCobranza = record
 Pcobro: integer;
 NclienteFact: integer;
 NumCuota: integer;
 Monto: real
end;
Cobranza = file of RegCobranza;	{Archivo de pagos registrados}
RegIndice = record
 Sucursal: integer;
 Rinicial: integer;
 Rfinal: integer
end;
Indice = file of RegIndice;		{Archivo para indexar registros segun punto de cobro}
RegOrden = record
 NumCF: integer;
 CuotasImp: integer
end;
Orden = file of RegOrden;		{Archivo para ordenar por cant. de cuotas imp.}
var
ArchM: Maestro;
RegM: RegMaestro;
ArchCob: Cobranza;
RegCob: RegCobranza;
ArchI: Indice;
RegI, RegI2: RegIndice;
ArchO: Orden;
RegO, RegO2: RegOrden;
Op: integer;	{Contendra la eleccion del menu principal}
{PROCEDIMIENTOS}
procedure Continuar();
begin	{Mantiene el contenido de pantalla para mostrar notificaciones}
 writeln();
 write('Presione una tecla para continuar...');
 readkey()
end;
procedure ControlArchivoM(var ArchM:Maestro);
begin	{Crea el archivo si no existia previamente}
 {$I-}
 assign(ArchM, 'C:\MAESTRO.Dat');
 reset(ArchM);
 close(ArchM);	
 {$I+}
 if IOResult <> 0 then begin
  rewrite(ArchM);
  close(ArchM)
 end
end;
procedure ImprimirMenu();
begin	{Muestra el menu para seleccionar una tarea}
 clrscr;
 writeln('*************** BIENVENIDO AL PROGRAMA ***************');
 writeln();
 writeln('<<< Seleccione la operacion a realizar >>>');
 writeln();
 writeln('1: Registrar Ventas.');
 writeln('2: Registrar Cobros y Actualizar Ventas.');
 writeln('3: Obtener Informes.');
 writeln('4: Terminar Programa.');
end;
procedure TomarDatos(var Importe: real; var Ccuotas: integer);
begin	{Arma un registro de venta}
 repeat
  clrscr;
  writeln('***************   INGRESO DE IMPORTE   ***************');
  writeln();
  writeln('<<< Ingrese el IMPORTE de venta >>> ');
  {$I-}
  writeln();
  write('Su respuesta: ');
  readln(Importe);
  {$I+}
  if IOResult<>0 then begin
   writeln();
   writeln('!!! ERROR, La respuesta ingresada es invalida !!!');
   Continuar()
  end
  else begin  
   if Importe<=0 then begin
    writeln();
    writeln('!!! Importe no permitido !!!');
    Continuar()
   end
  end
 until Importe>0;
 repeat
  clrscr;
  writeln('***************   INGRESO DE CUOTAS   ***************');
  writeln();
  writeln('<<< Ingrese cantidad de CUOTAS >>>');
  {$I-}
  writeln();
  write('Su respuesta: ');
  readln(Ccuotas);
  {$I+}
  if IOResult<>0 then begin
   writeln();
   writeln('!!! ERROR, La respuesta ingresada es invalida !!!');
   Continuar()
  end
  else begin
   if (Ccuotas<=0) or (Ccuotas>12) then begin
	writeln();
	writeln('!!! Cantidad de cuotas no permitidas !!!');
	Continuar()
   end
  end
 until (Ccuotas>=1) and (Ccuotas<=12);
end;
procedure TratarReg(var ArchM: Maestro; var RegM: RegMaestro; var Importe: Real; var Ccuotas: integer);
var
  Rta2: string;
  Salir: boolean;
  I : integer;
begin	{Registra la venta si se confirman los datos ingresados}
 Salir:= false;
 repeat
  clrscr;
  writeln('*************** VERIFICACION DE DATOS ***************');
  writeln();
  writeln('Importe: $', Importe:1:2);
  writeln('Cantidad de cuotas: ', Ccuotas);
  writeln();
  writeln('<<< Confirma la venta??? >>>');
  writeln();
  writeln('s: Si');
  writeln('n: No');
  writeln();
  write('Su respuesta: ');
  readln(Rta2);
  if (Rta2='s') or (Rta2='S') then begin
   RegM.NumClienteFact:= Filesize(ArchM)+1;
   RegM.CantCuotas:= Ccuotas;
   RegM.ValorVenta:= Importe;
   for I:=1 to Ccuotas do
   begin
    RegM.Cuotas[I].Valor:= Importe/Ccuotas;
    RegM.Cuotas[I].Estado:= 'I'
   end; 
   write(ArchM, RegM);
   Salir:= true;
   writeln();
   writeln('!!! Se registro la venta !!!')
  end
  else begin
   if (Rta2='n') or (Rta2='N') then begin
    writeln();
    writeln('!!! La venta fue cancelada !!!');
    Salir:= true
   end
   else begin
    writeln();
    writeln('!!! ERROR, La respuesta ingresada es invalida !!!')
   end
  end;  
  Continuar()
 until Salir = true
end;
procedure IngresarVentas(var ArchM: Maestro; var RegM: RegMaestro);
var
  Rta: string;
  Importe: real;
  Ccuotas: integer;
begin	{Opera el archivo de ventas financiadas}
 reset(ArchM);
 seek(ArchM, filesize(ArchM));
 repeat
  clrscr;
  writeln('***************   REGISTRO DE VENTAS   ***************');
  writeln();
  writeln('<<< Desea registrar una venta financiada??? >>>');
  writeln();
  writeln('s: Si');
  writeln('n: No');
  writeln();
  write('Su respuesta: ');
  readln(Rta);
  if (Rta='s') or (Rta='S') then begin
   TomarDatos(Importe, Ccuotas);
   TratarReg(ArchM, RegM, Importe, Ccuotas)
  end
  else begin
   if (Rta<>'n') and (Rta<>'N') then begin
    writeln();
    writeln('!!! ERROR, La respuesta ingresada es invalida !!!');
    Continuar()
   end
  end
 until (Rta='n') or (Rta='N');
 close(ArchM);
 writeln();
 writeln('*************** CERRAR REGISTRO VENTAS ***************')
end;
procedure IngresarDatos(var Ncliente, Ncuota: integer; var MontoCob: real);
begin {Arma el registro del cobro realizado}
 repeat
  clrscr;
  writeln('***************   INGRESO DE CLIENTE   ***************');
  writeln();
  writeln('<<< Ingrese numero de cliente >>>');
  {$I-}
  writeln();
  write('Su respuesta: ');
  readln(Ncliente);
  {$I+}
  if IOResult<>0 then begin
   writeln();
   writeln('!!! ERROR, La respuesta ingresada es invalida !!!');
   Continuar()
  end
  else begin
   if Ncliente<=0 then begin
	writeln();
	writeln('!!! Ingrese un valor valido !!!');
	Continuar()
   end
  end
 until Ncliente>0;
 repeat
  clrscr;
  writeln('*************** INGRESO DE CUOTAS ***************');
  writeln();
  writeln('<<< Ingrese numero de cuota >>>');
  {$I-}
  writeln();
  write('Su respuesta: ');
  readln(Ncuota);
  {$I+}
  if IOResult<>0 then begin
   writeln();
   writeln('!!! ERROR, La respuesta ingresada es invalida !!!');
   Continuar()
  end
  else begin
   if Ncuota<=0 then begin
	writeln();
	writeln('!!! Ingrese un valor valido !!!');
	Continuar()
   end
  end
 until Ncuota>0;
 repeat
  clrscr;
  writeln('***************    INGRESO DE MONTO    ***************');
  writeln();
  writeln('<<< Ingrese monto abonado >>>');
  {$I-}
  writeln();
  write('Su respuesta: ');
  readln(MontoCob);
  {$I+}
  if IOResult<>0 then begin
   writeln();
   writeln('!!! ERROR, La respuesta ingresada es invalida !!!');
   Continuar()
  end
  else begin
   if MontoCob<=0 then begin
	writeln();
	writeln('!!! Ingrese un valor valido !!!');
	Continuar()
   end
  end
 until MontoCob>0
end;
procedure VerificarReg(var ArchCob: Cobranza; var RegCob: RegCobranza; var Ncliente, Ncuota, PuntoC: integer; var MontoCob: real; var RegI: RegIndice);
var
 Rta5: string;
 Finalizar: boolean;
begin {Controla la validez del pago registrado}
 Finalizar:= false;
 repeat
  clrscr;
  writeln('*************** VERIFICACION DE DATOS ***************');
  writeln();
  writeln('Numero de cliente: ', Ncliente);
  writeln('Numero de cuota: ', Ncuota);
  writeln('Monto abonado: $', MontoCob:1:2);
  writeln();
  writeln('<<< Confirma el registro??? >>>');
  writeln();
  writeln('s: Si');
  writeln('n: No');
  writeln();
  write('Su respuesta: ');
  readln(Rta5);
  if (Rta5='s') or (Rta5='S') then begin
   RegCob.Pcobro:= PuntoC;
   RegCob.NclienteFact:= Ncliente;
   RegCob.NumCuota:= Ncuota;
   RegCob.Monto:= MontoCob;
   RegI.Rfinal:= RegI.Rfinal+1;
   write(ArchCob, RegCob);
   Finalizar:= true;
   writeln();
   writeln('!!! Se ha registrado el cobro !!!')
  end
  else begin
   if (Rta5='n') or (Rta5='N') then begin
		writeln();
		writeln('!!! El registro fue cancelado !!!');
		Finalizar:= true
   end
   else begin
		writeln();
		writeln('!!! ERROR, La respuesta ingresada es invalida !!!')
   end
  end;
  Continuar()
 until Finalizar = true
end;
procedure RegistrarCobros(var ArchCob: Cobranza; var RegCob: RegCobranza; var ArchI: Indice; var RegI: RegIndice);
var
  Rta3, Rta4: string;
  PuntoC, Ncliente, Ncuota: integer;
  Terminar, error, FinPuntos: boolean;
  MontoCob: real;
begin	{Crea el archivo de cobros}
 RegI.Rinicial:= 0;
 RegI.Rfinal:= 0;
 FinPuntos:= false;
 repeat
  clrscr;
  writeln('***************   REGISTRO DE COBROS   ***************');
  writeln();
  writeln('<<< Desea ingresar registros de un punto de cobro??? >>>');
  writeln();
  writeln('s: Si');
  writeln('n: No');
  writeln();
  write('Su respuesta: ');
  readln(Rta3);
  if (Rta3='s') or (Rta3='S') then begin	
   repeat
    clrscr;
    error:= false;
    writeln('***************    PUNTOS DE COBRO    ***************');
    writeln();
    writeln('<<< Ingrese identificacion del punto de cobro >>>');
    writeln();
    writeln('1: Punto de cobro Numero 1.');
    writeln('2: Punto de cobro Numero 2.');
    writeln('3: Punto de cobro Numero 3.');
    writeln('4: Punto de cobro Numero 4.');
    writeln('5: Punto de cobro Numero 5.');
    writeln('0: Terminar.');
    {$I-}
    writeln();
    write('Su respuesta: ');
    readln(PuntoC);
    {$I+}
    if IOResult<>0 then begin
     writeln();
     writeln('!!! ERROR, La respuesta ingresada es invalida !!!');
     error:= true;
     Continuar()
    end
    else begin  
     if (PuntoC>0) and (PuntoC<=5) then begin	
      Terminar:= false;
      while not Terminar do
      begin
       IngresarDatos(Ncliente, Ncuota, MontoCob);
       VerificarReg(ArchCob, RegCob, Ncliente, Ncuota, PuntoC, MontoCob, RegI);
       repeat
        clrscr;
        writeln('*************** PUNTO DE COBRO NUM. ', PuntoC, ' ***************');
        writeln();
        writeln('<<< Tiene mas registros del punto de cobro??? >>>');
        writeln();
        writeln('s: Si');
        writeln('n: No');
        writeln();
        write('Su respuesta: ');
        readln(Rta4);
        if (Rta4='n') or (Rta4='N') then begin
         Terminar:= true;
         if RegI.Rfinal > RegI.Rinicial then begin
          RegI.Sucursal:= PuntoC;
          RegI.Rfinal:= RegI.Rfinal-1;
          write(ArchI, RegI);
          RegI.Rinicial:= RegI.Rfinal+1;
          RegI.Rfinal:= RegI.Rfinal+1
         end
        end
        else begin
         if (Rta4<>'s') and (Rta4<>'S') then begin
          writeln();
          writeln('!!! ERROR, La respuesta ingresada es invalida !!!');
          Continuar()
         end
        end
       until (Rta4='s') or (Rta4='S') or (Rta4='n') or (Rta4='N')
      end
     end  
     else begin		
      if PuntoC<>0 then begin
       writeln();
       writeln('!!! Punto de cobro inexistente !!!');
       Continuar()
      end
      else begin
		FinPuntos:=true
      end
     end
    end
   until (PuntoC=0) and (error=false)	
  end
  else begin 		
   if (Rta3<>'n') and (Rta3<>'N') then begin
    writeln();
    writeln('!!! ERROR, La respuesta ingresada es invalida !!!');
    Continuar()
   end
  end
 until (Rta3='n') or (Rta3='N') or (FinPuntos=true);
 writeln();
 writeln('*************** FIN REGISTRO DE COBROS ***************')
end;
procedure OrdenarIndice(var ArchI: Indice; var RegI, RegI2: RegIndice);
var
  a,b: integer;
begin	{Ordena el archivo indice por punto de cobro de manera ascendente}
 reset(ArchI);
 for a:= 0 to (filesize(ArchI)-2) do 
 begin
  seek(ArchI, a);
  read(ArchI, RegI);
  for b:=(a+1) to (filesize(ArchI)-1) do
  begin
   seek(ArchI, b);
   read(ArchI, RegI2);
   if RegI.Sucursal > RegI2.Sucursal then begin
	seek(ArchI, a);
    write(ArchI, RegI2);
    seek(ArchI, b);
    write(ArchI, RegI);
    RegI:=RegI2
   end
  end
 end
end;
procedure AperturaPcobro(var RegI: RegIndice; var PuntCobAnt, Problemas: integer);
begin	{Secciona las novedades por punto de cobro}
 writeln('PUNTO DE COBRO: ':35, RegI.Sucursal);
 PuntCobAnt:= RegI.Sucursal;
 Problemas:= 0
end;
procedure ProcesoPcobro(var ArchM: Maestro; var RegM: RegMaestro; var ArchCob: Cobranza; var RegCob: RegCobranza; var ArchI: Indice; var RegI: RegIndice; var Problemas, PuntCobAnt: integer; var fin:boolean);
var
 b, i: integer;
 AntImp: boolean;
begin	{Procesa datos de un punto de cobro determinado}
 while (not fin) and (PuntCobAnt=RegI.Sucursal) do
 begin
  for b:= RegI.Rinicial to RegI.Rfinal do
  begin
   seek(ArchCob, b);
   read(ArchCob, RegCob);
   if RegCob.NclienteFact > Filesize(ArchM) then begin
    writeln('El cliente numero ', RegCob.NclienteFact, ' no existe.');
    Problemas:= Problemas+1
   end
   else begin
    seek(ArchM, RegCob.NclienteFact-1);
    read(ArchM, RegM);
    if RegCob.NumCuota > 12 then begin
     writeln('El cliente numero ', RegCob.NclienteFact, ' pago una cuota mayor a 12.');
     Problemas:= Problemas+1
    end
    else begin
     if RegCob.NumCuota > RegM.CantCuotas then begin
      writeln('El cliente numero ', RegCob.NclienteFact, ' pago una cuota mayor a la elegida.');
      Problemas:= Problemas+1
     end
     else begin
      if RegM.Cuotas[RegCob.NumCuota].Estado = 'P' then begin
       writeln('El cliente numero ', RegCob.NclienteFact, ' ya habia pagado la cuota numero ', RegCob.NumCuota, '.');
       Problemas:= Problemas+1
      end
      else begin
       i:=1;
       AntImp:= false;
       if RegCob.NumCuota > 1 then begin
        repeat
         if RegM.Cuotas[i].Estado = 'I' then begin
          writeln('El cliente numero ', RegCob.NclienteFact, ' no pago la cuota numero ', i, '.');
          Problemas:= Problemas+1;
          AntImp:= true
         end;
         i:= i+1
        until (i=RegCob.NumCuota) or (AntImp=true)
       end;
       if (i=1) or (AntImp=false) then begin
        if RegCob.Monto < RegM.Cuotas[RegCob.NumCuota].Valor then begin
         writeln('El cliente numero ', RegCob.NclienteFact, ' pago un Monto insuficiente, faltan $', RegM.Cuotas[RegCob.NumCuota].Valor-RegCob.Monto:1:2, '.');
         Problemas:= Problemas+1
        end
        else begin
         if RegCob.Monto > RegM.Cuotas[RegCob.NumCuota].Valor then begin
          writeln('El cliente numero ', RegCob.NclienteFact, ' pago demas, sobran $', RegCob.Monto-RegM.Cuotas[RegCob.NumCuota].Valor:1:2, '.');
          Problemas:= Problemas+1;
          RegM.Cuotas[RegCob.NumCuota].Estado:= 'P';
          seek(ArchM, RegCob.NclienteFact-1);
          write(ArchM, RegM)
         end
         else begin
		  RegM.Cuotas[RegCob.NumCuota].Estado:= 'P';
          seek(ArchM, RegCob.NclienteFact-1);
          write(ArchM, RegM)
         end
        end
       end
      end
     end
    end
   end
  end;
  if not EoF(ArchI) then begin
   read(ArchI, RegI)
  end
  else begin
	fin:= true
  end
 end
end;
procedure ActYnovedades(var ArchM: Maestro; var RegM: RegMaestro; var ArchCob: Cobranza; var RegCob: RegCobranza; var ArchI: Indice; var RegI: RegIndice);
var
 PuntCobAnt, Problemas: integer;
 fin: boolean;
begin	{Actualiza el Maestro y genera las novedades}
 reset(ArchCob);
 reset(ArchI);
 writeln('***************       NOVEDADES       ***************');
 writeln();
 read(ArchI, RegI);
 fin:=false;
 while not fin do
 begin
  AperturaPcobro(RegI, PuntCobAnt, Problemas);
  ProcesoPcobro(ArchM, RegM, ArchCob, RegCob, ArchI, RegI, Problemas, PuntCobAnt, fin);
  if Problemas = 0 then begin
   writeln('No se detectaron problemas.')  
  end
 end;
 close(ArchM);
 writeln();
 writeln('***************    FIN DE NOVEDADES    ***************')
end;
procedure OrdenarImpagas(var ArchO: Orden; var RegO, RegO2: RegOrden);
var
 a,b: integer;
begin {Ordena clientes segun mayor cantidad de cuotas impagas}
 reset(ArchO);
 for a:= 0 to (filesize(ArchO)-2) do
 begin
  seek(ArchO, a);
  read(ArchO, RegO);
  for b:=(a+1) to (filesize(ArchO)-1) do
  begin
   seek(ArchO, b);
   read(ArchO, RegO2);
   if RegO.CuotasImp < RegO2.CuotasImp then begin
    seek(ArchO, b);
    write(ArchO, RegO);
    seek(ArchO, a);
    write(ArchO, RegO2);
    RegO:=RegO2
   end
  end
 end
end;
procedure LeerImpagas(var ArchO: Orden; var RegO: RegOrden);
var
 i: integer;
begin {Lee el archivo Orden, ordenado previamente, e imprime su contenido}
 reset(ArchO);
 for i:= 0 to (filesize(ArchO)-1) do
 begin
	read(ArchO, RegO);
	writeln(RegO.NumCF:13,RegO.CuotasImp:25)
 end
end;
procedure ObtenerInformes(var ArchM: Maestro; var RegM: RegMaestro; var ArchO: Orden; var RegO, RegO2: RegOrden);
var
 Impagas, I: integer;
begin	{Genera informe sobre cuotas impagas mayores a 5}
 writeln('***************        INFORMES        ***************');
 writeln();
 writeln('NUMERO DE CLIENTE':21, 'CANTIDAD DE CUOTAS IMPAGAS':30);
 assign(ArchO, 'C:\ORDEN.Dat');
 rewrite(ArchO);
 while not EoF(ArchM) do {Obtiene clientes que deban mas 5 cuotas y crea el archivo para ordenarlo}
 begin
  read(ArchM, RegM);
  Impagas:= 0;
  for I:= 1 to RegM.CantCuotas do
  begin
   if RegM.Cuotas[I].Estado='I' then begin
    Impagas:= Impagas+1
   end;
  end;
  if Impagas>5 then begin
   RegO.NumCF:= RegM.NumClienteFact;
   RegO.CuotasImp:= Impagas;
   write(ArchO, RegO)
  end
 end;
 if Filesize(ArchO)>1 then begin
  OrdenarImpagas(ArchO, RegO, RegO2);
  LeerImpagas(ArchO, RegO)
 end
 else begin
  if Filesize(ArchO)= 1 then begin
   reset(ArchO);
   read(ArchO, RegO);
   writeln();
   writeln(RegO.NumCF:13, RegO.CuotasImp:25)	{Solo hay un registro que lo cumple}
  end
  else begin
   writeln();
   writeln('Ningun cliente debe mas de 5 cuotas')
  end
 end;
 close(ArchO);	{BORRAR ARCHIVO ORDEN???}
 close(ArchM);
 writeln();
 writeln('***************   FIN DE LOS INFORMES   ***************')
end;
{FIN DECLARACION PROCEDIMIENTOS}
begin
 ControlArchivoM(ArchM);
 repeat
  ImprimirMenu();
  {$I-}
  writeln();
  write('Su respuesta: ');
  readln(Op);
  {$I+}
  if IOResult <> 0 then begin
   writeln();
   writeln('!!! ERROR, La respuesta ingresada es invalida !!!')
  end
  else begin
   case Op of
    1: begin	{Registrar ventas financiadas}
        clrscr;
        IngresarVentas(ArchM, RegM)
       end;
    2: begin	{Registrar pago de clientes}
        reset(ArchM);
	    if filesize(ArchM)>0 then begin
         assign(ArchCob, 'C:\COBRANZA.Dat');
         rewrite(ArchCob);
         assign(ArchI, 'C:\INDICES.Dat');
         rewrite(ArchI);	{Archivos creados}
 	     RegistrarCobros(ArchCob, RegCob, ArchI, RegI);
         if filesize(ArchCob)>0 then begin
          Continuar();
          clrscr;
          if filesize(ArchI)>1 then begin
		   OrdenarIndice(ArchI, RegI, RegI2)
		  end;
		  ActYnovedades(ArchM, RegM, ArchCob, RegCob, ArchI, RegI)
		 end;
         close(ArchCob);
         close(ArchI){¿¿¿BORRAR ESTOS ARCHIVOS???}
        end
        else begin
         writeln();
         writeln('!!! No se detectan ventas registradas !!!')
        end
       end;
    3: begin	{Consigue los resultados pedidos}
	    reset(ArchM);
	    if Filesize(ArchM)>0 then begin 
	     clrscr;
	     ObtenerInformes(ArchM, RegM, ArchO, RegO, RegO2)
	    end
	    else begin
	     writeln();
	     writeln('!!! No se detectan ventas registradas !!!')
	    end
       end;
    4: begin	{Cerrar programa}
	    writeln();
	    writeln('***************    HASTA LA PROXIMA    ***************')
	   end
   end;
   if (Op < 1) or (Op > 4) then begin
    writeln();
    writeln('!!! La operacion solicitada no existe !!!')
   end 
  end;
  Continuar()
 until Op=4
end.
