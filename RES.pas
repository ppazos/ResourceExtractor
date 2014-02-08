unit RES;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Buttons, StdCtrls, Mask, ExtCtrls, UMapa, ULiPer, UPersonas, UIMG, UCity,
  Menus;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    MainMenu1: TMainMenu;
    ComenzarSimulacion1: TMenuItem;
    Salir1: TMenuItem;
    form1ComboBox1SelText1: TMenuItem;
    Label6: TLabel;
    Image2: TImage;
    Button6: TButton;
    Edit2: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Button7: TButton;
    procedure FormCreate(Sender: TObject);
    procedure MouseCoords(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure Image1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure form1ComboBox1SelText1Click(Sender: TObject);
    procedure Salir1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

Const
   //Cantidad de BMPs Utilizados para dibujar el mapa y otras cosas (p.e. Seleccionar).
   //En un futuro cercano, también guardará los BMPs de Persona.
      CantBMP = 7;
      Blok_Width = 52;
      Blok_Height = 25; //tamaño de los rombos (de los bitmaps).

var
  Form1: TForm1;
  x_mouse, y_mouse: Integer;

  Oro_en_turno, Comida_en_turno, Madera_en_turno: Integer; {Cantidades tentativas a extraer en el turno actual}

  Ciudad: UCity.Ciudad;
  Mapa: UMapa.PtrMapa;
  CBMP: UIMG.ConjBMP;
  MargenTop: Integer;
  MargenIzq: Integer; //Usadas para mover el mapa.
  SimulacionTerminada: Boolean;
  worker: TBitmap; {Guardo temporariamente la imagen del tipo acá}

  procedure Juego();
  procedure DibujarMapa(Mapa: UMapa.PtrMapa; c: UIMG.ConjBMP; Top, Left: Integer);
  procedure DeterminaLugar(Mapa: PtrMapa; xm,ym,top,left: integer; var h: integer; var v: integer; Tam: Integer);
  {Determina lugar del mapa donde se hizo click, podría estar en un Operaciones.PAS}
  procedure DeterminaPX(x,y: integer; var px_x: integer; var px_y: integer; Tam: Integer);
  {Dada La posicion de un terreno, da el lugar de dibujo de su BMP}
  procedure DibujarPersonasPob();
  {Dibuja las personas que están en la poblacion de la ciudad en el status}

implementation

uses UNewSim;

{$R *.dfm}

//**************************************************************************************************

   procedure Juego();
   begin
      //Ciudad := UNewSim.Ciudad;
      DibujarMapa(UCity.MapaDeCiudad(UNewSim.Ciudad), CBMP, MargenTop, MargenIzq);
      SimulacionTerminada := false; {Empieza la simulacion}
   end;

   procedure DibujarMapa(Mapa: UMapa.PtrMapa; c: UIMG.ConjBMP; Top, Left: Integer);

   {NUEVO: Ahora tembién tiene que dibujar a las personas que trabajan!!!}

   (*
     OBSERVACIONES: 1) tendría que solo dibujar lo que es visible en Image1.
                    2) habría que poner como parámetro de entrada a partir de que rombo tiene que dibujar,
                       así puedo mover el mapa variando ese parametro, y si el mapa es más grande que Image1
                       puedo moverlo y verlo todo.
                    3) este proc empieza a digujar sin márgen superior, ni izquierdo, si tuviera un margen
                       negativo para arriba, es como si me moviera para abajo.
   *)
   var
      pos_x, pos_y, x,y: Integer;
      img: UIMG.PtrBMP;
      LDP: ULiPer.ListaDePersonas;
   begin

      {tapa el mapa dibujado abajo}
      form1.Image1.Canvas.Rectangle(0,0,form1.Image1.Width,form1.Image1.Height);

      //A partir de acá realmente empieza el dibujar mapa.
      pos_x := trunc(Blok_Width*(High(Mapa^) + 1)/2) - trunc(Blok_Width/2) + Left;
      pos_y := 1 + Top; // para que deje margen de  1px arriva

      for y:=0 to High(Mapa^) do //Tendrian que ser repeats o whiles que dibujen solo dentro de image1 y no todo el mapa.
      begin
         for x:=0 to High(Mapa^[y]) do
         begin
         (*Para construcciones que son mas altas que el height del rombo, hay que hacer otros casos, sabiendo
         cuantos px sobran, puedo poner la imagen en el lugar correcto. *)
            img := nil;  //en cada vuelta se pone nil.

            case (UMapa.ObtenerNumTerrenoMapa(x,y,Mapa)) of
               0: img := UIMG.ObtenerBMPConjBMP(1,c); //PASTO
               1: if (UMapa.ObtenerRecursoTerreno(x,y,Mapa) > 300) then {300 es un valor medio}
                     img := UIMG.ObtenerBMPConjBMP(2,c) //ORO mucho
                  else
                     img := UIMG.ObtenerBMPConjBMP(3,c); //oro berreta
               2: if (UMapa.ObtenerRecursoTerreno(x,y,Mapa) > 300) then {300 es un valor medio}
                     img := UIMG.ObtenerBMPConjBMP(4,c) //GRANJA buena
                  else
                     img := UIMG.ObtenerBMPConjBMP(5,c); //GRANJA berreta
               3: img := UIMG.ObtenerBMPConjBMP(7,c); //CASA
               4: img := UIMG.ObtenerBMPConjBMP(6,c); //ARBOL
            end;

            Form1.Image1.Canvas.Draw(pos_x, pos_y, img^);

            (*if (Mapa^[y,x].TerSel) then
            begin
               RES.Form1.Image1.Canvas.Draw(pos_x, pos_y, Selected.BMP);
            end;*)

            pos_x := pos_x + trunc(Blok_Width/2);
            pos_y := pos_y + trunc((Blok_Height + 1)/2);

         end; //for x
         pos_x := pos_x - (High(Mapa^[y]) + 2)*trunc(Blok_Width/2);
         pos_y := pos_y - (High(Mapa^))*trunc((Blok_Height + 1)/2);
      end; //for y

      {DIBUJA PERSONAS TABAJANDO}
      LDP := UCity.GetLDPTrabCiudad(UNewSim.Ciudad); {primer nodo de la LDPTrab}
      while not(ULiPer.EsVaciaLDP(LDP)) do {si LDP <> nil}
      begin
         UPersonas.ObtenerLugarTrabajando(ULiPer.PrimerPerLDP(LDP),x,y); {Obtiene el lugar donde trabaja la persona}

         {Pasar lugar del mapa a pixels}
         DeterminaPX(x,y,pos_x,pos_y,UMapa.ObtenerTamMapa(UCity.MapaDeCiudad(UNewSim.Ciudad)));

         {Dibujo}
         Form1.Image1.Canvas.Draw(pos_x + Left, pos_y + Top, worker); {Los dibuja considerando los margenes}
         {recurso del terreno}                  {+10 para que se ponga al lado de la persona}
         form1.Image1.Canvas.TextOut(pos_x + Left + 32,pos_y + Top,inttostr(UMapa.ObtenerRecursoTerreno(x,y,UCity.MapaDeCiudad(UNewSim.Ciudad))));

         LDP := ULiPer.SigPerLDP(LDP); {Siguiente persona}
      end;
      {DIBUJA PERSONAS TABAJANDO}

   end; //dibujar mapa

//*******************************************************************************************************

procedure TForm1.FormCreate(Sender: TObject);
begin

   {TEMPORARIO, CARGA IMG DEL TIPO}
   {---------------------------------------------------}
   worker := Tbitmap.Create();
   worker.LoadFromFile('img\worker.bmp');
   worker.Transparent := true;
   worker.TransparentColor := worker.Canvas.Pixels[0,0];
   {---------------------------------------------------}

   {Da tamaño inicial a Image1 y dibuja el primer rectángulo de fondo}
   with form1.Image1 do
   begin
      Width := 9*Blok_Width;
      Height := 15*(Blok_Height + 1) + 2; //el +2 es para que se vea el margen que dejé up y dwn
      Canvas.Brush.Color := rgb(150,0,0);
      Canvas.Pen.Color := ClBlack;
      Canvas.Rectangle(0,0,Width,Height);
   end;
   with form1.Image2 do
   begin
      Canvas.Brush.Color := rgb(120,180,255);
      Canvas.Pen.Color := ClBlack;
      Canvas.Rectangle(0,0,Width,Height);
   end;

   MargenTop := 0; MargenIzq := 0; //Margenes iniciales.
   CBMP := UIMG.CargaBMPConjBMP(); {Hay que hacerlo al principio sino cuando quiero dibujar no tengo BMPs}

   Oro_en_turno := 0;     {Las cantidades iniciales que se van a extraer son 0}
   Comida_en_turno := 0;
   Madera_en_turno := 0;
   SimulacionTerminada := true; {Al Principio no hay simulacion}

end; {OnLoad}


procedure TForm1.MouseCoords(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  //var x1,x2,y1,y2: Integer;
begin
   x_mouse := X;
   y_mouse := Y;
   form1.label1.Caption := inttostr(x) + ',' + inttostr(y);

   (*
   Marca posicion del mouse en Image1.
   DibujarMapa (Mapa, CBMP, MargenTop, MargenDer);
   x1 := x_mouse - 2*y_mouse;
   y1 := trunc((form1.Image1.Width - x_mouse)/2) + y_mouse;
   x2 := x_mouse + 2*y_mouse;
   y2 := trunc(x_mouse/2) + y_mouse;
   form1.Image1.Canvas.Polyline([point(x1,0),point(form1.Image1.Width,y1)]);
   form1.Image1.Canvas.Polyline([point(x2,0),point(0,y2)]);
   *)
end;

procedure TForm1.Image1Click(Sender: TObject);
var T,h,v,r: integer; Nom: String;
    //px_x,px_y: integer
    NumTer: Integer;
    LDP: ULiPer.ListaDePersonas;
    Resulto: Boolean; {Para ver si se puso una persona a trabajar}
begin

if not(SimulacionTerminada) then {Si empezó la simulacion}
begin

   T := UCity.TamanioMapaCiudad(UNewSim.Ciudad);
   //DeterminaLugar(Mapa: PtrMapa; xm,ym: integer; var h: integer; var v: integer; Tam: Integer);
   {PROBLEMA, el lugar del mapa TAMBIÉN DEPENDE DE LSO MÁRGENES !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
   //DeterminaLugar(Mapa: PtrMapa; xm,ym,top,left: integer; var h: integer; var v: integer; Tam: Integer);
   DeterminaLugar(UCity.MapaDeCiudad(UNewSim.Ciudad),x_mouse,y_mouse,MargenTop,MargenIzq,h,v,T); {v,h = -1 si hago clik afuera del mapa}
   if (v <> -1) then //si hice click adentro del mapa
   begin
      { INFO DEL TERRENO }
      r := UCity.ObtenerRecursoTerrenoCiudad(h,v,UNewSim.Ciudad);
      {
      Nom := UCity.ObtenerNomTerMapaCiudad(h,v,UNewSim.Ciudad);
      ShowMessage(inttostr(h) + ',' + inttostr(v) + ' - ' + inttostr(r) + ' - ' + Nom);
      }

      //DeterminaPX(h,v,px_x,px_y,UMapa.ObtenerTamMapa(UCity.MapaDeCiudad(UNewSim.Ciudad)));
      //ShowMessage(inttostr(px_x) + ',' + inttostr(px_y));

      if (UMapa.EstaLibreTerrenoMapa(UCity.MapaDeCiudad(UNewSim.Ciudad),h,v)) then //si el lugar está libre
      begin //puedo poner una persona a trabajar en ese terreno
         //ShowMessage('El terreno esta libre');

         UCity.AgregarPerTrabCiudad(h,v,UNewSIm.Ciudad, Resulto);
         ///////////////////////////////////////////////////////
         // SE HACE TODO DENTRO DE LA FUNCION APTC            //
         // ver si hay personas sin trabajar                  //
         //agrego la persona al stack de personas trabajando  //
         //la quito del de las personas que no trabajan       //
         //el terreno x.y pasa a estar ocupado                //
         ///////////////////////////////////////////////////////

         if (Resulto) then {Si se puso a trabajar a alguien}
         begin
            {Dibujo el mapa de nuevo para ver la persona que puse}
            DibujarMapa (UCity.MapaDeCiudad(UNewSim.Ciudad), CBMP, MargenTop, MargenIzq);

            if (r > 0) then {Si hay recursos en el terreno donde puse a la persona}
            begin

               LDP := UCity.GetLDPTrabCiudad(UNewSim.Ciudad); {primer nodo de la LDPTrab, es la persona que acabo de poner}
               NumTer := UMapa.ObtenerNumTerrenoMapa(h,v,UCity.MapaDeCiudad(UNewSim.Ciudad)); {Veo que recurso voy a extraer}
               case NumTer of {No pongo otros casos porque son pasto o casa y no extraigo nada de ahí}
                  1: Oro_en_turno := Oro_en_turno + UPersonas.CantidadExtraccionPersona (ULiPer.PrimerPerLDP(LDP)); {Lo que extrae la persona}
                  2: Comida_en_turno := Comida_en_turno + UPersonas.CantidadExtraccionPersona (ULiPer.PrimerPerLDP(LDP)); {Lo que extrae la persona}
                  4: Madera_en_turno := Madera_en_turno + UPersonas.CantidadExtraccionPersona (ULiPer.PrimerPerLDP(LDP)); {Lo que extrae la persona}
               end;
               
            end;
         end; {Si se puso a trabajar a alguien}

         {Actualizo Status}
         form1.Edit2.Text := inttostr(UCity.NumPerTrabCiudad(UNewSIm.Ciudad));
         form1.Edit3.Text := inttostr(Madera_en_turno); {Madera a extraer}
         form1.Edit4.Text := inttostr(Oro_en_turno); {Oro a extraer}
         form1.Edit5.Text := inttostr(Comida_en_turno); {Comida a extraer}
         {Actualizar personas trabajando !!!!!!!!!!!!!!!!}

         //OBS: en cada turno debo hacer un control de todas las personas que trabajan, y a cada terreno ocupado
         //por una de estas personas, restarle lo que dicha persona saca por turno

      end
      else if not(UMapa.IsFreeTerWorkMap(UCity.MapaDeCiudad(UNewSim.Ciudad),h,v)) then {si hay alguien trabajando}
      begin
         
         {Restar las cantidades supuestas a extraer en el turno}
         LDP := UCity.GetLDPTrabCiudad(UNewSim.Ciudad); {primer nodo de la LDPTrab, es la persona que acabo de poner}
         NumTer := UMapa.ObtenerNumTerrenoMapa(h,v,UCity.MapaDeCiudad(UNewSim.Ciudad)); {Veo que recurso voy a extraer}
         case NumTer of {No pongo otros casos porque son pasto o casa y no extraigo nada de ahí}
            1: Oro_en_turno := Oro_en_turno - UPersonas.CantidadExtraccionPersona (ULiPer.PrimerPerLDP(LDP)); {Lo que extrae la persona}
            2: Comida_en_turno := Comida_en_turno - UPersonas.CantidadExtraccionPersona (ULiPer.PrimerPerLDP(LDP)); {Lo que extrae la persona}
            4: Madera_en_turno := Madera_en_turno - UPersonas.CantidadExtraccionPersona (ULiPer.PrimerPerLDP(LDP)); {Lo que extrae la persona}
         end;

         UCity.QuitarPerTrabCiudad(h,v,UNewSim.Ciudad);

         {Dibujo el mapa de nuevo para ver la persona que saqué}
         DibujarMapa (UCity.MapaDeCiudad(UNewSim.Ciudad), CBMP, MargenTop, MargenIzq);

         {Actualizo Status}
         form1.Edit2.Text := inttostr(UCity.NumPerTrabCiudad(UNewSim.Ciudad));
         form1.Edit3.Text := inttostr(Madera_en_turno); {Madera a extraer}
         form1.Edit4.Text := inttostr(Oro_en_turno); {Oro a extraer}
         form1.Edit5.Text := inttostr(Comida_en_turno); {Comida a extraer}

         {Actualizar personas trabajando !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1}

      end
      else
         ShowMessage('Terreno ocupado por una construccion');

   end;

end; {Si empezo la simulacion}

end; {Image1Click}

procedure TForm1.Button5Click(Sender: TObject);  {Scroll}
begin
   if ((UMapa.DeterminarWidthMapa(UCity.MapaDeCiudad(UNewSim.Ciudad)) + MargenIzq) > trunc(form1.Image1.Width*4/5)) then
   begin
      MargenIzq := MargenIzq - Trunc(Blok_Width/2);
      DibujarMapa (UCity.MapaDeCiudad(UNewSim.Ciudad), CBMP, MargenTop, MargenIzq);
   end;
end;

procedure TForm1.Button3Click(Sender: TObject); {Scroll}
begin
   if (MargenIzq < trunc(form1.Image1.Width/5)) then
   begin
      MargenIzq := MargenIzq + Trunc(Blok_Width/2);
      DibujarMapa (UCity.MapaDeCiudad(UNewSim.Ciudad), CBMP, MargenTop, MargenIzq);
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);  {Scroll}  {----------------------------------------}
begin
   if (MargenTop < trunc(form1.Image1.Height/5)) then
   begin
      MargenTop := MargenTop + Trunc((Blok_Height + 1)/2);
      DibujarMapa (UCity.MapaDeCiudad(UNewSim.Ciudad), CBMP, MargenTop, MargenIzq);
   end;
end;

procedure TForm1.Button4Click(Sender: TObject);  {Scroll}  {----------------------------------------}
begin
   if ((UMapa.DeterminarHeightMapa(UCity.MapaDeCiudad(UNewSim.Ciudad)) + MargenTop) > trunc(form1.Image1.Height*4/5)) then
   begin
      MargenTop := MargenTop - Trunc((Blok_Height + 1)/2);
      DibujarMapa (UCity.MapaDeCiudad(UNewSim.Ciudad), CBMP, MargenTop, MargenIzq);
   end;
end;

procedure Actualiza();
begin
   {Si el juego está terminado}
      {Mostrar Status final}
   {Sino}
      {Dibujar Mapa}
      {Dibujar Trabajadores}

end;

procedure TForm1.form1ComboBox1SelText1Click(Sender: TObject);  {-------------------------------------------}
begin
   form2.Show;
end;

procedure TForm1.Salir1Click(Sender: TObject);
begin
   Close;
end;

           //falta hacer con respecto a top.

procedure DeterminaLugar(Mapa: PtrMapa; xm,ym,top,left: integer; var h: integer; var v: integer; Tam: Integer); {----}
{Determina lugar del mapa donde se hizo click, podría estar en un Operaciones.PAS}
var cota1, cota2 : Integer;
begin
   // si hizo click dentro del mapa, xm e ym son la posicion del mouse, la saco de Form1
   if (trunc((xm - Tam*(Blok_Height+1) - left)/2) < ym) and //sup der
      (trunc((xm + Tam*(Blok_Height+1) - left)/2) > ym) and //inf izq
      (trunc((Tam*(Blok_Height+1) - xm + left)/2) < ym) and // sup izq
      (trunc((3*Tam*(Blok_Height+1) - xm + left)/2) > ym) // inf der
   then
   begin
      //form1.Image1.Canvas.Polyline([point(11*26,0),point(0,5*26+13)]);
      //form1.Image1.Canvas.Polyline([point(200+10*26+26,100),point(0,-5*26-13)]);
      //ShowMessage ('Adentro');
      //determino x del mapa.
      h := 0; {Empuieza en 0}
      cota1 := trunc((Tam*(Blok_Height+1) - xm +left)/2); //recta arriba izq
      cota2 := cota1 + Blok_Height + 1; //cota 1 corrida
      while (ym > cota2) do
      begin
         cota1 := cota1 + Blok_Height + 1;
         cota2 := cota2 + Blok_Height + 1;
         h := h + 1;
      end; // el h que salga va a ser el horizontal

      //determino y del mapa.
      v := 0; {Empieza en 0}
      cota1 := trunc((xm - Tam*(Blok_Height+1) - left)/2); //sup der
      cota2 := cota1 + Blok_Height + 1;
      while (ym > cota2) do
      begin
         cota1 := cota1 + Blok_Height + 1;
         cota2 := cota2 + Blok_Height + 1;
         v := v + 1;
      end; // el v que salga va a ser el horizontal
   end
   else
   begin
   //si no se hizo click dentro del mapa devuelvo -1 -1
      h := -1;
      v := -1;
   end;
end; {determinalugar}


procedure DeterminaPX(x,y: integer; var px_x: integer; var px_y: integer; Tam: Integer); {------------------}
{Dada La posicion de un terreno, da el lugar de dibujo de su BMP}
begin
   px_x := trunc(Blok_Width*(x + Tam - 1 - y)/2);
   px_y := trunc((Blok_Height + 1)*(y + x)/2);
end;


procedure TForm1.Button6Click(Sender: TObject); {-----------------------------------------------------------}
{Crea una nueva persona que no trabaja}
begin
   {Si hay una simulacion en curso, sino, no hay ciudad}
   if (UCity.ObtenerCantPersonasCiudad(UNewSim.Ciudad) < UCity.ObtenerCantMaxPerCiudad(UNewSim.Ciudad)) then
   begin
      UCity.NuevaPersonaCiudad(UNewSim.Ciudad);
      DibujarPersonasPob(); {Dibuja las personas que están en la poblacion de la ciudad en el status}
   end;
end;


procedure DibujarPersonasPob(); {---------------------------------------------------------------------------}
{Dibuja las personas que están en la poblacion de la ciudad en el status}
   var x,i: integer;
begin
   {Dibuja persona en la población}
   x := 0;
   for i:=1 to UCity.ObtenerCantPersonasCiudad(UNewSim.Ciudad) do
   begin
      form1.Image2.Canvas.Draw(x,0,worker);
      x := x + 8;
   end;
   form1.Image2.Canvas.TextOut(2,2,inttostr(UCity.ObtenerCantPersonasCiudad(UNewSim.Ciudad)));
end;

procedure TForm1.Button7Click(Sender: TObject);
   var x,y,ext,ter: Integer;
       LDP: ULiPer.ListaDePersonas;
       M:UMapa.PtrMapa;
       recTer: Integer;
begin

   {Recorrer la poblacion trabajando}
   {PERSONAS TABAJANDO}
   LDP := UCity.GetLDPTrabCiudad(UNewSim.Ciudad); {primer nodo de la LDPTrab}
   while not(ULiPer.EsVaciaLDP(LDP)) do {si LDP <> nil}
   begin
     UPersonas.ObtenerLugarTrabajando(ULiPer.PrimerPerLDP(LDP),x,y); {Obtiene el lugar donde trabaja la persona}
     {Sumar la cantidad que extrageron de recurso}
     {Restar la cantidad extraida del terreno}
     M := UCity.MapaDeCiudad(UNewSim.Ciudad);

     ext := UPersonas.CantidadExtraccionPersona(ULiPer.PrimerPerLDP(LDP)); {cantidad que extrae la persona}
     ter := UMapa.ObtenerNumTerrenoMapa(x,y,M);
     {Sumar cada recurso extraido}
     case ter of
        1: UCity.SumaOroCiudad(ext,UNewSim.Ciudad); {oro}
        2: UCity.SumaComidaCiudad(ext,UNewSim.Ciudad); {com}
        4: UCity.SumaMaderaCiudad(ext,UNewSim.Ciudad); {mad}
     end;

     recTer := UMapa.ObtenerRecursoTerreno(x,y,M); {recursos del terreno x,y}
     {Resta ext el recurso del terreno x,y del mapa de la ciudad UNewSim.Ciudad}
     {Ver si quedan recursos en el terreno}
     if (recTer = 0) then
     begin
        {hay que hacer que el terreno sea pasto, ya no hay más para extraer.}
        UMapa.SetTerNum(x,y,0,M); {0 es el numero del pasto}

        {Como ya no voy a sacar recursos de ese terreno, resto lo que se extraia a lo que se va a extraer por turno}
        case ter of
           1: Oro_en_turno := Oro_en_turno - ext; {oro}
           2: Comida_en_turno := Comida_en_turno - ext; {com}
           4: Madera_en_turno := Madera_en_turno - ext; {mad}
        end;
        {cuando no hay mas para extraer puedo:
           1: sacar a la persona que trabaja en el terreno
           2: buscar un nuevo terreno de ese tipo y ponerla a trabajar ahí
        }
     end
     else if (recTer < ext) then {si lo que queda es menor que lo que extraigo}
        UMapa.QuitarRecursoTerrenoMapa(recTer,x,y,M)              {que extraiga la diferencia}
     else {todavia quedan recursos}
        UMapa.QuitarRecursoTerrenoMapa(ext,x,y,M);

     LDP := ULiPer.SigPerLDP(LDP); {Siguiente persona}
   end;
   {PERSONAS TABAJANDO}

   {Actualizar status}
   form1.Edit2.Text := inttostr(UCity.NumPerTrabCiudad(UNewSim.Ciudad)); {Personas Trabajando}
   form1.Edit3.Text := inttostr(Madera_en_turno); {Madera a extraer}
   form1.Edit4.Text := inttostr(Oro_en_turno); {Oro a extraer}
   form1.Edit5.Text := inttostr(Comida_en_turno); {Comida a extraer}

   {recursos en storage}
   Edit6.Text := inttostr(UCity.MaderaEnCiudad(UNewSim.Ciudad)); {Madera}
   Edit7.Text := inttostr(UCity.OroEnCiudad(UNewSim.Ciudad)); {Oro}
   Edit8.Text := inttostr(UCity.ComidaEnCiudad(UNewSim.Ciudad)); {Comida}

   {Dibujo el mapa de nuevo para ver la persona que saqué}
   DibujarMapa (UCity.MapaDeCiudad(UNewSim.Ciudad), CBMP, MargenTop, MargenIzq);
   
end;

end.
