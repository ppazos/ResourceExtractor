unit URSC;

interface
   uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Buttons, StdCtrls, Mask, ExtCtrls;

   type
   TipoRecurso = Record
          Nombre: String; //Nombre del Recurso.
          CantActual: Integer; //Cantidad almacenada del recurso.
          CantMax: Integer; //Cantidad máxima de recurso que se puede almacenar.
   end;

   //Este tipo es el qu voy a usar dentro de este TAD y desde los otros TADS (Units).
   PtrSilo = ^TipoSilo;

   //Aquí se guardan los recursos de cada ciudad;
   TipoSilo = record
      Silos: Array of TipoRecurso; {dinamico}
      CantSilos: Integer; {Numero de silos usados hasta el momento}
   end;


   function CrearSilo(t: Integer): PtrSilo;
   (*Crea un nuevo silo, inicializando las variables...*)

   procedure DefinirSilo(var S: PtrSilo; Nom: String; CantMax: Integer);
   {PREC: HIGH(S)+1 > CantSilos, inicia info del silo}

   procedure CambiarCantMaxSilo (Nom: String; var S: PtrSilo; NuevaCant: Integer);
   {Cambia le tamaño del silo del recurso Nom por NuevaCant}

   procedure AgregarRecursoSilo (var S: PtrSilo; Nom: String; Cant: Integer);
   {PREC: La cantidad actual de recurso es menor que la cantidad máxima de almacenamiento.
    Agrega Cant a la cantidad del recurso Nom en S}

   procedure QuitarRecursoSilo (var S: PtrSilo; Nom: String; Cant: Integer);
   {Quita Cant a la cantidad del recurso Nom en S}

   function ObtenerCantidadRecursoSilo (S: PtrSilo; Nom: String): Integer;
   {Devuelve la cantidad de recursos que hay en el silo Nom}

   procedure DestruirSilo(var S: PtrSilo);

implementation


   function CrearSilo(t: Integer): PtrSilo;
   (* Crea t nuevos silos, la idea es que t de establece desde el principal. *)
      var S: PtrSilo;
   begin
      new(S);
      SetLength(S^.Silos, t); {Setea cantidad de silos, uno por cada recurso}
      S^.CantSilos := 0;
      CrearSilo := S;
   end;


   procedure DefinirSilo(var S: PtrSilo; Nom: String; CantMax: Integer);
   {PREC: HIGH(S)+1 > CantSilos, inicia info del silo}
   begin
      S^.Silos[S^.CantSilos].Nombre := Nom;
      S^.Silos[S^.CantSilos].CantActual := 0;
      S^.Silos[S^.CantSilos].CantMax := CantMax;
      S^.CantSilos := S^.CantSilos + 1;
   end;

   {Falta:
   ObtenerCantSilos, medio al dope, si se cuantos silos tengo que definir.

   {------------------------------------------------------------------------------}
   procedure AgregarRecursoSilo (var S: PtrSilo; Nom: String; Cant: Integer);
   {PREC: La cantidad actual de recurso es menor que la cantidad máxima de almacenamiento.
    Agrega Cant a la cantidad del recurso Nom en S}
      var n: Integer;
   begin
      n := 0;
      while (S^.Silos[n].Nombre <> Nom) do
         n := n + 1;
      S^.Silos[n].CantActual := S^.Silos[n].CantActual + Cant;
   end; {AgregarRecursoSilo}


   procedure QuitarRecursoSilo (var S: PtrSilo; Nom: String; Cant: Integer);
   {Quita Cant a la cantidad del recurso Nom en S}
      var n: Integer;
   begin
      n := 0;
      while (S^.Silos[n].Nombre <> Nom) do
         n := n + 1;
      S^.Silos[n].CantActual := S^.Silos[n].CantActual - Cant;
   end; {QuitaRecursoSilo}
   {------------------------------------------------------------------------------}

   function ObtenerCantidadRecursoSilo (S: PtrSilo; Nom: String): Integer;
   {Devuelve la cantidad de recursos que hay en el silo Nom}
      var n: Integer;
   begin
      n := 0;
      while (S^.Silos[n].Nombre <> Nom) do
         n := n + 1;
      ObtenerCantidadRecursoSilo := S^.Silos[n].CantActual;
   end; {ObtenerCantidadRecursoSilo}

   {------------------------------------------------------------------------------}

   procedure CambiarCantMaxSilo (Nom: String; var S: PtrSilo; NuevaCant: Integer);
   {PREc: NOM tiene ue existir, y S <> vacio, Cambia le tamaño del silo del recurso Nom por NuevaCant}
      var n: Integer;
   begin
      n := 0;

      while (S^.Silos[n].Nombre <> Nom) do
         n := n + 1;

      S^.Silos[n].CantMax := NuevaCant;

   end; {CambiaCantMaxSilo}

   procedure DestruirSilo(var S: PtrSilo);
   begin
      Dispose(S);
      S := nil;
   end;


end.