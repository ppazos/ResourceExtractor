unit UCity;

interface
   uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Buttons, StdCtrls, Mask, ExtCtrls, UPersonas, ULiper, UMapa;

   type Ciudad = ^NodoCiudad;
        NodoCiudad = record
           {MAPA DE LA CIUDAD}
           Mapa : UMapa.PtrMapa;

           {PERSOANS DE LA CIUDAD}
           Pob: ULiper.ListaDePersonas; {lista de personas + cantidades}
           PobTrab: ULiPer.ListaDePersonas; {Lista de punteros a las personas de la poblacion que están trabajando}
           MaxPer: Integer;     {Numero maximo de personas que puede tener la ciudad}
           NumPer: Integer;     {Numero de personas que tiene la ciudad}
           NumPerTrab: Integer; {Numero de Personas que estan trabajando}

           {RECURSOS DE LA CIUDAD "SILOS"}
           Madera: Integer;
           Oro: Integer;
           Comida: Integer;
        end;

   function CrearCiudad(Tam, Mad, Com, Oro, CantMaxPersonas: Integer): Ciudad;
   {Crea una nueva ciudad con su poblacion, mapa y recursos, el mapa tiene tamaño t, Mad Madera, Com Comida, Oro Oro}

   {RECURSoS}
   procedure SumaMaderaCiudad (k: Integer; var C: Ciudad);
   {Suma una cantidad k a la cantidad de madera en la ciudad C, k puede ser negativo, en el caso de sacar k madera.
   Si k es negativo: PRE: la cantidad actual tiene que ser mayor a k en valor absoluto}
   procedure SumaOroCiudad (k: Integer; var C: Ciudad);
   {Idem anterior}
   procedure SumaComidaCiudad (k: Integer; var C: Ciudad);
   {Idem Anterior}

   {SILO STUFF}
   //procedure DefinirSiloCiudad (C: Ciudad; Nom: String; CantMax: Integer);
   {Define info de cada silo}
   //procedure InsertarRecursoSiloCiudad(var C: Ciudad; Nom: String; Cant: Integer);
   {Agrega "Cant" de recurso al silo especificado}
   //procedure QuitarRecursoSiloCiudad(var C: Ciudad; Nom: String; Cant: Integer);
   {Quita "Cant" de recurso al silo especificado}

   
   procedure NuevaPersonaCiudad(var C: Ciudad);
   {Agrega una nueva persona a la poblacion}
   Procedure AgregarPerTrabCiudad (x,y: Integer; var C: Ciudad; var Resulto: Boolean);
   {Toma una persona de la poblacion de la ciudad C y la pone en la poblacion que trabaja,
   aclarando la posicion del terreno donde trabaja en x,y, si no hay personas para poner a trabajar, resulto = false}
   Procedure QuitarPerTrabCiudad (x,y: Integer; var C: Ciudad);
   {PRE: el terreno x,y tiene a alguien trabaajndo. Toma la persona que está trabajando en el terreno x,y,
    y pasa a no trabajar mas}

   function MaderaEnCiudad(C: Ciudad): Integer;
   function ComidaEnCiudad(C: Ciudad): Integer;
   function OroEnCiudad(C: Ciudad): Integer;

   function EsVaciaCiudad(C: Ciudad): Boolean;
   {True si C es nil}
   function EsVaciaPobCiudad (C: Ciudad): Boolean;
   {TRUE si no hay nadie sin trabajar}
   function EsVaciaPobTrabCiudad (C: Ciudad): Boolean;
   {TRUE si hay no hay personas trabajando}

   procedure DestruirCiudad(var C: Ciudad);

   function MapaDeCiudad (C: Ciudad): UMapa.PtrMapa;
   {Retorna el mapa de la ciudad C}

   function TamanioMapaCiudad(C: Ciudad): Integer;
   {Devuelve el tamaño del mapa de la ciudad C}

   function ObtenerCantPersonasCiudad(C: Ciudad): Integer;
   {Devuelve la cantidad de personas en la ciudad, es la suma de las que trabajan y las que no}
   function ObtenerCantMaxPerCiudad(C: Ciudad): Integer;
   {Devuelve la cantidad máxima de personas que puede tener la ciudad C}
   function NumPerTrabCiudad (C: Ciudad): Integer;
   {Devuelve el numero de personas que están trabajando en la ciudad C}

   function GetLDPTrabCiudad (C: Ciudad): ULiPer.ListaDePersonas;
   {Devuelve el puntero el primer nodo de la lista de personas trabajando en la ciudad}

   function ObtenerNomTerMapaCiudad(x,y: Integer; C: Ciudad): String;
   {Devuelve el nombre del terreno x,y del mapa de la ciudad C}

   function ObtenerRecursoTerrenoCiudad(x,y: Integer; C: Ciudad): Integer;
   {Devuelve la cantidad de recurso del terreno x,y del mapa de la ciudad}

implementation

   function CrearCiudad(Tam, Mad, Com, Oro, CantMaxPersonas: Integer): Ciudad;
   {Crea una nueva ciudad con su poblacion, mapa y recursos, el mapa tiene tamaño t, Mad Madera, Com Comida, Oro Oro}
      var C: Ciudad;
   begin
      new(C);

      C^.Mapa := UMapa.CrearMapa(Tam); {matriz de numeros}
      //C^.Silos := URSC.CrearSilo(CantRecursos); {Crea Los Silos Vacios}
      C^.Pob := ULiPer.CrearListaDePersonas(); {Crea Población Vacia}
      C^.PobTrab := ULiPer.CrearListaDePersonas(); {crea poblacion vacia que trabaja}
      C^.MaxPer := CantMaxPersonas;
      C^.NumPer := 0;
      C^.NumPerTrab := 0;
      C^.Madera := Mad;
      C^.Comida := Com;
      C^.Oro := Oro;
      CrearCiudad := C;

   end; {CrearCiudad}

   procedure SumaMaderaCiudad (k: Integer; var C: Ciudad);
   {Suma una cantidad k a la cantidad de madera en la ciudad C, k puede ser negativo, en el caso de sacar k madera.
   Si k es negativo: PRE: la cantidad actual tiene que ser mayor a k en valor absoluto}
   begin
      C^.Madera := C^.Madera + k;
   end;

   procedure SumaOroCiudad (k: Integer; var C: Ciudad);
   {Idem anterior}
   begin
      C^.Oro := C^.Oro + k;
   end;

   procedure SumaComidaCiudad (k: Integer; var C: Ciudad);
   {Idem Anterior}
   begin
      C^.Comida := C^.Comida + k;
   end;

   function MaderaEnCiudad(C: Ciudad): Integer;
   begin
      MaderaEnCiudad := C^.Madera;
   end;

   function ComidaEnCiudad(C: Ciudad): Integer;
   begin
      ComidaEnCiudad := C^.Comida;
   end;

   function OroEnCiudad(C: Ciudad): Integer;
   begin
      OroEnCiudad := C^.Oro;
   end;
   
   {
   procedure DefinirSiloCiudad (C: Ciudad; Nom: String; CantMax: Integer);
   //Define info de cada silo
   begin
      URSC.DefinirSilo(C^.Silos, Nom, CantMax);
   end;

   procedure InsertarRecursoSiloCiudad(var C: Ciudad; Nom: String; Cant: Integer);
   //Agrega "Cant" de recurso al silo especificado
   begin
      URSC.AgregarRecursoSilo(C^.Silos, Nom, Cant);
   end;

   procedure QuitarRecursoSiloCiudad(var C: Ciudad; Nom: String; Cant: Integer);
   //Quita "Cant" de recurso al silo especificado
   begin
      URSC.QuitarRecursoSilo (C^.Silos, Nom, Cant);
   end;
   }



   function ObtenerCantPersonasCiudad(C: Ciudad): Integer; {----------------------------------}
   {Devuelve la cantidad de personas en la ciudad, es la suma de las que trabajan y las que no}
   begin
      ObtenerCantPersonasCiudad := C^.NumPer;
   end;

   function ObtenerCantMaxPerCiudad(C: Ciudad): Integer;  {----------------------------------}
   begin
      ObtenerCantMaxPerCiudad := C^.MaxPer;
   end;

   function NumPerTrabCiudad (C: Ciudad): Integer;
   {Devuelve el numero de personas que están trabajando en la ciudad C}
   begin
      NumPerTrabCiudad := C^.NumPerTrab;
   end;

   function ObtenerRecursoTerrenoCiudad (x,y: Integer; C: Ciudad): Integer;  {----------------------------------}
   {Devuelve la cantidad de recurso del terreno x,y del mapa de la ciudad}
   begin
      ObtenerRecursoTerrenoCiudad := UMapa.ObtenerRecursoTerreno(x,y,C^.Mapa);
   end;

   function ObtenerNomTerMapaCiudad(x,y: Integer; C: Ciudad): String;  {----------------------------------}
   {Devuelve el nombre del terreno x,y del mapa de la ciudad C}
   begin
      ObtenerNomTerMapaCiudad := UMapa.ObtenerNomTerreno(x,y,C^.Mapa);
   end;

   procedure NuevaPersonaCiudad(var C: Ciudad); {------------------------------------------------}
   {Agrega una nueva persona a la poblacion (QUE NO TABAJA)}
   begin
      ULiPer.AgregarPersonaLDP (C^.Pob);
      C^.NumPer := C^.NumPer + 1; {Cuento a la nueva persona}
   end;

   Procedure AgregarPerTrabCiudad (x,y: Integer; var C: Ciudad; var Resulto: Boolean); {------------------}
   {Toma una persona de la poblacion de la ciudad C y la pone en la poblacion que trabaja,
   aclarando la posicion del terreno donde trabaja en x,y, si no hay personas para poner a trabajar, resulto = false}
      var Per: UPersonas.Persona;
   begin
      Resulto := false; {Todavía no hizo nada}
      if not(ULiPer.EsVaciaLDP(C^.Pob)) then {Si hay personas sin trabajar}
      begin
         ULiPer.MoverPerLDP(C^.Pob,C^.PobTrab); {Mueve el primero, si hay, desde Pob a PobTrab, pob <> nil !!!!}
         Per := ULiPer.PrimerPerLDP(C^.PobTrab); {Primer persona de la poblacion que
                                                                  trabaja, la que acabo de ingresar}
         UPersonas.PonerATrabajarPersona(Per,x,y); {establece que el status de la persona es trabajando,
                                                      en el terreno x,y del mapa}
         UMapa.TerrenoOcupadoTrabMapa (x,y, C^.Mapa);{El terreno x,y del mapa pasa a estar ocupado por una persona}

         C^.NumPerTrab := C^.NumPerTrab + 1; {Cuento el que puse a trabajar}

         Resulto := true; {Se puso una persona a trabajar}
      end;
   end; {AgregarPerTrabCiudad}

   Procedure QuitarPerTrabCiudad (x,y: Integer; var C: Ciudad);
   {PRE: el terreno x,y tiene a alguien trabaajndo. Toma la persona que está trabajando en el terreno x,y,
    y pasa a no trabajar mas}
      var Per: UPersonas.Persona;
   begin
      ULiPer.LlevarTopPerTrabTerLDP(x,y,C^.PobTrab); {Pone al que trabaja en x,y al principio de la PobTrab}
      ULiPer.MoverPerLDP(C^.PobTrab, C^.Pob); {Mueve el primero de Pobtrab a Pob}
   //ShowMessage('Mueve al principio');
      Per := ULiPer.PrimerPerLDP(C^.Pob); {Toma el primero de Pob, el que acabo de mover}
   //ShowMessage('Obtiene la primer persona');
      UPersonas.PonerADescansarPersona(Per); {Lo pone a descansar}
   //ShowMessage('Pone a descansar');
      UMapa.TerrenoLibreTrabMapa(x,y,C^.Mapa); {No hay nadie trabajando en el terreno x,y}
   //ShowMessage('Tererno Libre');
      C^.NumPerTrab := C^.NumPerTrab - 1; {Cuento el que saco}
   end; {QuitarPerTrabCiudad}

   function MapaDeCiudad (C: Ciudad): UMapa.PtrMapa; {------------------------------------------------}
   {Retorna el mapa de la ciudad C}
   begin
      MapaDeCiudad := C^.Mapa;
   end;

   function TamanioMapaCiudad(C: Ciudad): Integer; {------------------------------------------------}
   {Devuelve el tamaño del mapa de la ciudad C}
   begin
      TamanioMapaCiudad := UMapa.ObtenerTamMapa(C^.Mapa);
   end;

   function EsVaciaCiudad(C: Ciudad): Boolean; {------------------------------------------------}
   {True si C es nil}
   begin
      EsVaciaCiudad := (C = nil);
   end;

   function EsVaciaPobCiudad (C: Ciudad): Boolean;
   {TRUE si no hay nadie sin trabajar}
   begin
      EsVaciaPobCiudad := (C^.NumPer = 0);
   end;

   function EsVaciaPobTrabCiudad (C: Ciudad): Boolean;
   {TRUE si hay no hay personas trabajando}
   begin
      EsVaciaPobTrabCiudad := (C^.NumPerTrab = 0); {true si no hay personas trabajando}
   end;

   function GetLDPTrabCiudad (C: Ciudad): ULiPer.ListaDePersonas;
   {Devuelve el puntero el primer nodo de la lista de personas trabajando en la ciudad}
   begin
      GetLDPTrabCiudad := C^.PobTrab;
   end;

   procedure DestruirCiudad(var C: Ciudad); {------------------------------------------------}
   begin
      ULiPer.DestruirListaDePersonas (C^.Pob);
      ULiPer.DestruirListaDePersonas (C^.PobTrab);
      //URSC.DestruirSilo(C^.Silos);
      UMapa.DestruirMapa (C^.Mapa);
      dispose(C);
      C := nil;
   end;

end.
