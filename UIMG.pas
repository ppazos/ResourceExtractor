unit UIMG;

interface
   uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Buttons, StdCtrls, Mask, ExtCtrls;
   (*
     Acá voy a tener todas las cosas de Graficos:
     CargarBMPs, DibujarMapa, todo de los gráficos de los terrenos,
     todo lo que actúe sobre Form1.Image1.
     Debo usar UMapa para ver el tipo mapa (la matriz), ya que la función
     dibujarMapa debe tener de entrada dicha matriz, la cual fue generada
     en uMapa por CrearMapa
   *)

   Const
   //Cantidad de BMPs Utilizados para dibujar el mapa y otras cosas (p.e. Seleccionar).
   //En un futuro cercano, también guardará los BMPs de Persona.
      CantBMP = 7;
      Blok_Width = 52;
      Blok_Height = 25; //tamaño de los rombos (de los bitmaps).

   type
      RangoBMP = 1..CantBMP;
   //guarda bmps cuando se cargan para luego usarlos.
   //El pointer lo puedo necesitar para algunos procs.
      PtrBMP = ^TBitmap;
      ConjBMP = ^GuardaBMP;
      //GuardaBMP = array [RangoBMP] of TBitmap;
      GuardaBMP = RECORD
                  Buffer: array [RangoBMP] of PtrBMP; //No uso directamente el array porque no puedo hacer new();
                  end;

   //function CrearConjBMP (): ConjBMP;
   (*Crea un nuevo buffer (conjunto de bitmaps) vacio, reserva la memoria para guardar los BMPS*)

   //procedure CargaBMPConjBMP(var c: ConjBMP);
   function CargaBMPConjBMP(): ConjBMP; //crea y carga, todo al mismo tiempo.
   (*Carga los BMPs que vamos a usar en el buffer*)

   function ObtenerBMPConjBMP (i: RangoBMP; c: ConjBMP): PtrBMP;
   (*Dado el índice, devuelve un putero al BMP en esa posición dentro de c*)

   (*function ObtenerBMPConjBMP (Tipo: String; Cant: Integer; c: ConjBMP): TBitmap; *)
   (*Dado el tipo del recurso o terreno, y la cantidad de recurso, devuelve un puntero al bitmap corresp.*)

   procedure DestruirConjBMP (var c: ConjBMP);
   (*Libera toda la memoria reservada por el buffer c*)


implementation

   (*function CrearConjBMP (): ConjBMP;
      var Aux: ConjBMP;
   begin
      new(Aux);
      CrearConjBMP := Aux;
   end;*)

   //procedure CargaBMPConjBMP(var c: ConjBMP);
   function CargaBMPConjBMP(): ConjBMP;
   var u,e: string; c: ConjBMP;
   begin

      new(c);

      u := 'img\'; //Directorio donde están las imágenes.
      e := '.bmp'; //Extensión de los archivos.

      new(c^.Buffer[1]); //puedo hacer un for e inicializar todas de una.
      c^.Buffer[1]^ := TBitmap.Create; c^.Buffer[1]^.LoadFromFile(u + 'pasto1' + e);
      c^.Buffer[1]^.Transparent := True; c^.Buffer[1]^.TransparentColor := c^.Buffer[1]^.Canvas.Pixels[0,0];
      new(c^.Buffer[2]);
      c^.Buffer[2]^ := TBitmap.Create; c^.Buffer[2]^.LoadFromFile(u + 'oro1' + e);
      c^.Buffer[2]^.Transparent := True; c^.Buffer[2]^.TransparentColor := c^.Buffer[2]^.Canvas.Pixels[0,0];
      new(c^.Buffer[3]);
      c^.Buffer[3]^ := TBitmap.Create; c^.Buffer[3].LoadFromFile(u + 'oro2' + e);
      c^.Buffer[3]^.Transparent := True; c^.Buffer[3].TransparentColor := c^.Buffer[3]^.Canvas.Pixels[0,0];
      new(c^.Buffer[4]);
      c^.Buffer[4]^ := TBitmap.Create; c^.Buffer[4].LoadFromFile(u + 'granja1' + e);
      c^.Buffer[4]^.Transparent := True; c^.Buffer[4].TransparentColor := c^.Buffer[4]^.Canvas.Pixels[0,0];
      new(c^.Buffer[5]);
      c^.Buffer[5]^ := TBitmap.Create; c^.Buffer[5]^.LoadFromFile(u + 'granja2' + e);
      c^.Buffer[5]^.Transparent := True; c^.Buffer[5]^.TransparentColor := c^.Buffer[5]^.Canvas.Pixels[0,0];
      new(c^.Buffer[6]);
      c^.Buffer[6]^ := TBitmap.Create; c^.Buffer[6]^.LoadFromFile(u + 'arbol1' + e);
      c^.Buffer[6]^.Transparent := True; c^.Buffer[6]^.TransparentColor := c^.Buffer[6].Canvas.Pixels[0,0];
      new(c^.Buffer[7]);
      c^.Buffer[7]^ := TBitmap.Create; c^.Buffer[7]^.LoadFromFile(u + 'casa' + e);
      c^.Buffer[7]^.Transparent := True; c^.Buffer[7]^.TransparentColor := c^.Buffer[7]^.Canvas.Pixels[0,0];
      
      //CARGO LA IMAGEN SELECTED
      (*
      Selected.BMP := TBitmap.Create;
      Selected.BMP.LoadFromFile(u + 'select' + e);
      Selected.BMP.Transparent := True;
      Selected.BMP.TransparentColor := Selected.BMP.Canvas.Pixels[0,0];
      *)

      CargaBMPConjBMP := c;

   end; (*CargarBMPS*)

   function ObtenerBMPConjBMP (i: RangoBMP; c: ConjBMP): PtrBMP;
   (* Dado en índice, devuelve un pointer al ese bitmap*)
   var P: PtrBMP;
   begin
      P := c^.Buffer[i];
      ObtenerBMPConjBMP := P;
   end;

   (*Dado el tipo del recurso o terreno, y la cantidad de recurso, devuelve un puntero al bitmap corresp.*)
   (*
   function ObtenerBMPConjBMP (Tipo: String; Cant: Integer; c: ConjBMP): TBitmap;
      var AuxPBMP: TBitmap;
   begin
        AuxPBMP := nil;
       	if (Tipo = 'Pasto') then
        begin
       	   AuxPBMP := c^[1];
        end
        else if (Tipo = 'Oro') then
        begin
       	   if (Cant > 500) then
              AuxPBMP := c^[2]
           else
              AuxPBMP := c^[3];
        end
        else if (Tipo = 'Granja') then
        begin
       	   if (Cant > 500) then
              AuxPBMP := c^[4]
           else
              AuxPBMP := c^[5];
        end
        else if (Tipo = 'Arbol') then
        begin
           AuxPBMP := c^[6]
        end
        else if (Tipo = 'Pasto') then
        begin
       	   AuxPBMP := c^[7];
        end
        else
        begin
           ShowMessage('No se pudo obtener el BMP, tipo de terreno desconocido: ' + Tipo);
        end;
        ObtenerBMPConjBMP := AuxPBMP;
   end;
   *)(*ObtenerBMPConjBMP*)

   procedure DestruirConjBMP (var c: ConjBMP);
      var i: Integer;
   begin
       	(*
          Hay que hacer un for de 1 hasta la cantidad de BMPs, e ir haciendo:
          Si elBitmap fue creado así:
             Bitmap := TBitmap.Create;
             Bitmap.LoadFromFile('bor6.bmp');
          Liberarlo así:
             Bitmap.Free;
          Luego hacer Dispose para liberar la estructura.
        *)
        for i := 1 to CantBMP do
        begin
           c^.Buffer[i].Free;
        end;
   end;

//DIBUJAR MAPA.

end.
