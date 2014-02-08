unit UMapa;

interface

   uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Buttons, StdCtrls, Mask, ExtCtrls;

   type
      PtrMapa = ^TerMatriz; //Pointer a una matriz
      TerNFO = record
                  TerNum: Integer;// numero del terreno.
                  TerType: String; //nombre del tipo de terreno.
                  TerFree: Boolean; //true si el terreno está vacío, fakse si está ocupado.
                  TerFreeTrab: Boolean; // true si no hay una persona trabajando en ese terreno.
                  TerCant: integer; //cantidad de recurso que tiene el terreno.
                  TerSel: Boolean; //True si el terreno está seleccionado, False si no.
               end;
      //El tamanio de la matriz va a ser definido por CrearMapa usando: SetLength(DynArray, num_Lugares);
      TerMatriz = Array of Array of TerNFO; //Matriz dinámica; {array dinamico}

      {Stats = ^NodoS;
      S = record
             CantGranjas, CantOro, CantArbol: Integer;
          end;
      }

   Const
      Blok_Width = 52; {Tamaños de los BMPs que dibujan el mapa}
      Blok_Height = 25;
      Cant_min_Recurso = 300; {Cantidad minima de recurso que puede tener un terreno}
                              {Podría tener una cantidad minima para cada tipo de terreno}

   var
      Selected: Record
                   { x,y del terreno seleccionado, -1,-1 no hay terreno seleccionado. }
                   x,y: integer;
                   BMP: TBitmap; //Bitmap que aparece cuando selecciono un terreno.
                end;

   function CrearMapa(t: Integer): PtrMapa; //crea un nuevo mapa aleatorio.
   (* procedure CargaBMP(); EN IMG *)//carga los BMPs que se van a usar para dibujar el mapa.

   function ObtenerNumTerrenoMapa (x,y: Integer; Mapa: PtrMapa): Integer;
   (*Obtiene el numero del terreno x,y del mapa*)

   function ObtenerRecursoTerreno (x,y: Integer; Mapa: PtrMapa): Integer;
   {Devuelve la cantidad de recurso que tiene el terreno x,y del mapa}

   function ObtenerNomTerreno (x,y: Integer; Mapa: PtrMapa): String;
   {Devuelve el nombre del terreno x,y del mapa}

   {procedure AssignNFO(Mapa: PtrMapa);} //asigna cantidad de recursos, etc a cada terreno.
   (* procedure DibujarMapa(Mapa: PtrMapa); EN IMG*)

   function DeterminarWidthMapa(M: PtrMapa): Integer;
   {Dado un mapa, devuelve el largo en pixels}

   function DeterminarHeightMapa(M: PtrMapa): Integer;
   {Dado un mapa, devuelve el alto en pixels}

   function ObtenerTamMapa (M: PtrMapa): Integer;
   {Dado un mapa, devuelve el tamaño en cantidad de rombos}

   function EstaLibreTerrenoMapa (M: PtrMapa; x,y: Integer): Boolean;
   {TRUE si el lugar x,y del mapa esta libre, no ocupado}

   function IsFreeTerWorkMap (M: PtrMapa; x,y: Integer): Boolean;
   {TRUE si no hay una persona trabajando en el tereno x,y del mapa M}

   function EsVacioMapa(M: PtrMapa): Boolean;
   {TRUE si es nil}


   procedure SetTerNum (x,y,newNum: Integer; var M: PtrMapa);
   {cambia el terreno x,y del mapa M por newNum}


   procedure QuitarRecursoTerrenoMapa (k,x,y: Integer; var M: PtrMapa);
   {quita k de recurso al terreno x,y del mapa M}

   Procedure TerrenoOcupadoMapa (x,y: Integer; var M: PtrMapa);
   {el terreno x,y del mapa pasa a estar ocupado por una construccion}
   Procedure TerrenoLibreMapa (x,y: Integer; var M: PtrMapa);
   {el terreno x,y del mapa deja estar libre por una construccion}
   Procedure TerrenoOcupadoTrabMapa (x,y: Integer; var M: PtrMapa); {-- Para cuando pongo una persona a trabajar en x,y --}
   {el terreno x,y del mapa pasa a estar ocupado por el trabajador}
   Procedure TerrenoLibreTrabMapa (x,y: Integer; var M: PtrMapa); {-- Para cuando saco la persona que estaba en x,y --}
   {el terreno x,y del mapa deja de estar ocupado por el trabajador}

   //DeterminarLugar talvez vaya en otro TAD como funciones complementarias,
   //ya que solo sirve para hacer select y cosas parecidas.
   //procedure DeterminaLugar(Mapa: PtrMapa; xm,ym: integer; var h: integer; var v: integer); //teniendo las coordenadas del mouse devuelve el lugar del mapa donde está el mouse.
   procedure DestruirMapa(var Mapa: PtrMapa);

implementation

   function CrearMapa(t: Integer): PtrMapa;
   (*Crea un mapa con el tamaño especificado*)
   //Dada un tamaño, devuelve una matriz cuadrada aleatoria de ese tamaño.

   const //probabilidades de los terrenos.
      Prob0 = 55; //va de 0 a 99
      Prob1 = 67; //prob oro
      Prob2 = 79; //prob granja
      Prob3 = 90; //arbol
      Prob4 = 99; //casa
   var
      Mapa: PtrMapa;
      cant_casas: integer;
      cant_oro: integer;
      {cant_granja: integer; }
      x,y,j,i: integer;
      Max_Oro: Integer; //debe haber Minimo también, para que por los menos halla algún terreno de ese tipo
      Max_Casas: Integer;

   begin
      Max_Oro := Round(t*t/6);
      Max_Casas := Round(t*t/9);

      cant_casas := 0;
      cant_oro := 0;
      {cant_granja := 0; }

      new(Mapa); //reservo el array dinámico.

      {Setea el tamaño del mapa}
      SetLength(Mapa^, t); (*Determino lugares de y (t lugares empezando en 0 hasta t-1)*)

      for x:=0 to HIGH(Mapa^)  do  (*Determino los lugares en la x, para cada y tengo t lugares de x*)
      begin
         SetLength(Mapa^[x], t);
      end;
      //si el valor final de x fuera distinto que el de y, crearía mapas "no cuadrados".

      Randomize(); //Sin este Rand, el primer mapa siempre es igual. NO QUITAR!!!

      //y=0 to t-1;
      for y := LOW(Mapa^) to HIGH(Mapa^) do (*t es el tamaño del mapa, va de 0 a t-1 xq el array dinámico empieza en 0*)
      begin
         //x=0 to t-1;
         for x := LOW(Mapa^[y]) to HIGH(Mapa^[y]) do
         begin

         //*********** DETERMINO VALOR DEL TERRENO *************************
            j := Random(100); //elijo valor entre 0,99
            if (j < Prob0) then
            begin
               i:= 0; //pasto
            end
            else if (j in [Prob0..Prob1]) then
            begin
               i := 1; //oro
            end
            else if (j in [Prob1..Prob2]) then
            begin
               i := 2; //granja
            end
            else if (j in [Prob2..Prob3]) then
            begin
               i := 3; //casa
            end
            else
            begin
               i := 4; //arbol
            end;

         //*********** DETERMINO VALOR DEL TERRENO *****************************

            if (cant_casas = Max_Casas) and (i=3) then //si ya estoy en el numero máximo de casas.
            begin
               i := 0; //pongo en pasto
            end;
            if (cant_oro = Max_Oro) and (i=1) then //si ya estoy en el numero máximo de oro.
            begin
               i := 0; //pongo en pasto
            end;

            //Cuento terrenos para controlar cantidades.
            case i of
               1: cant_oro := cant_oro + 1;
               {2: cant_granja := cant_granja + 1; }
               3: cant_casas := cant_casas + 1;
            end;

            Mapa^[y,x].TerNum := i;

            {ASIGNA INFORMACION}
            case Mapa^[y,x].TerNum of
               0: begin
                  Mapa^[y,x].TerType := 'Pasto';
                  Mapa^[y,x].TerCant := 0; //el pasto no tiene recursos
                  Mapa^[y,x].TerFree := True; //todos los terrenos menos los construidos están libres.
                  end; (*caso 0*)
               1: begin
                  Mapa^[y,x].TerType := 'Oro';
                  Mapa^[y,x].TerCant := Random(500) + Cant_min_Recurso; {Por lo menos tiene Cant_min_Recurso}
                  Mapa^[y,x].TerFree := True; //todos los terrenos menos los construidos están libres.
                  end; (*caso 1 oro*)
               2: begin
                  Mapa^[y,x].TerType := 'Granja';
                  Mapa^[y,x].TerCant := Random(500) + Cant_min_Recurso; {Por lo menos tiene Cant_min_Recurso}
                  Mapa^[y,x].TerFree := True; //todos los terrenos menos los construidos están libres.
                  end; (*caso 2 granja*)
               3: begin
                  Mapa^[y,x].TerType := 'Casa';
                  Mapa^[y,x].TerCant := 0; //recurso 0 por ser casa
                  Mapa^[y,x].TerFree := False; //Si hay una casa, siempre está ocupado.
                  end; (*caso 3 casa*)
               4: begin
                  Mapa^[y,x].TerType := 'Árbol';
                  Mapa^[y,x].TerCant := Random(500) + Cant_min_Recurso; {Por lo menos tiene Cant_min_Recurso}
                  Mapa^[y,x].TerFree := True; //todos los terrenos menos los construidos están libres.
                  end; (*caso 4 arbol*)
            end;
            {ASIGNA INFORMACION}

            Mapa^[y,x].TerFreeTrab := True; //Al principio no hay personas trabajando en ningun terreno.

         end; (*for x*)
      end; (*for y*)

      {Podría llamar a assign info desde acá y no tendría que ser llamada desde el principal}

      CrearMapa := Mapa;

   end; (*Crear mapa*)


   function ObtenerNumTerrenoMapa (x,y: Integer; Mapa: PtrMapa): Integer;
   (*Obtiene el numero del terreno x,y del mapa*)
   begin
      ObtenerNumTerrenoMapa := Mapa^[y,x].TerNum; //se pone y,x por como fue creado el mapa.
   end; (*ObtenerNumTerrenoMapa*)


   function ObtenerRecursoTerreno (x,y: Integer; Mapa: PtrMapa): Integer;
   {Devuelve la cantidad de recurso que tiene el terreno x,y del mapa}
   begin
      ObtenerRecursoTerreno := Mapa^[y,x].TerCant;
   end;

   function ObtenerNomTerreno (x,y: Integer; Mapa: PtrMapa): String; {-----------------}
   {Devuelve el nombre del terreno x,y del mapa}
   begin
      ObtenerNomTerreno := Mapa^[y,x].TerType;
   end;

   procedure DestruirMapa(var Mapa: PtrMapa);  {---------------------------------------}
   (*Precondición Mapa <> nil, aunque lo puedo chekear adentro*)
   begin
      Dispose(Mapa);
      Mapa := nil;
   end;

   function DeterminarWidthMapa (M: PtrMapa): Integer; {-------------------------------}
   {Dado un mapa, devuelve el largo en pixels}
   begin
      DeterminarWidthMapa := (HIGH(M^) + 1)*Blok_Width;
   end;

   function DeterminarHeightMapa (M: PtrMapa): Integer;
   {Dado un mapa, devuelve el alto en pixels}
   begin
      DeterminarHeightMapa := (HIGH(M^[0]) + 1)*(Blok_Height + 1) + 2; //+2 para que se vea un margen up y dwn.
   end;

   function ObtenerTamMapa (M: PtrMapa): Integer;  {----------------------------------}
   {Dado un mapa, devuelve el tamaño en cantidad de rombos}
   begin
      ObtenerTamMapa := (HIGH(M^) + 1);
   end;

   procedure QuitarRecursoTerrenoMapa (k,x,y: Integer; var M: PtrMapa); {-----------------------------}
   {quita k de recurso al terreno x,y del mapa M}
   begin
      M^[y,x].TerCant := M^[y,x].TerCant - k;
   end;

   function EstaLibreTerrenoMapa (M: PtrMapa; x,y: Integer): Boolean; {------ PRE ------}
   {TRUE si el lugar x,y del mapa esta libre, no ocupado}
   begin
      EstaLibreTerrenoMapa := M^[y,x].TerFree and M^[y,x].TerFreeTrab;
   end;

   function IsFreeTerWorkMap (M: PtrMapa; x,y: Integer): Boolean; {--------- PRE ------}
   {TRUE si no hay una persona trabajando en el tereno x,y del mapa M}
   begin
      IsFreeTerWorkMap := M^[y,x].TerFreeTrab;
   end;

   function EsVacioMapa(M: PtrMapa): Boolean; {------------------------------ PRE ------}
   begin
      EsVacioMapa := (M = nil);
   end;

   Procedure TerrenoOcupadoMapa (x,y: Integer; var M: PtrMapa); {-- Para cuando hago una construccion en x,y --}
   {el terreno x,y del mapa pasa a estar ocupado opr ubna construccion}
   begin
      M^[y,x].TerFree := false;
   end;

   Procedure TerrenoLibreMapa (x,y: Integer; var M: PtrMapa); {-- Para cuando rompo una construccion en x,y --}
   {el terreno x,y del mapa deja de estar ocupado por una construccion}
   begin
      M^[y,x].TerFree := true;
   end;

   Procedure TerrenoOcupadoTrabMapa (x,y: Integer; var M: PtrMapa); {-- Para cuando pongo una persona a trabajar en x,y --}
   {el terreno x,y del mapa pasa a estar ocupado por el trabajador}
   begin
      M^[y,x].TerFreeTrab := false;
   end;

   Procedure TerrenoLibreTrabMapa (x,y: Integer; var M: PtrMapa); {-- Para cuando saco la persona que estaba en x,y --}
   {el terreno x,y del mapa deja de estar ocupado por el trabajador}
   begin
      M^[y,x].TerFreeTrab := true;
   end;


   procedure SetTerNum (x,y,newNum: Integer; var M: PtrMapa);
   {cambia el terreno x,y del mapa M por newNum}
   begin
      M^[y,x].TerNum := newNum;
   end;
   
end.
