unit ULiPer;

(*
  LISTA DE PERSONAS:
  Lo que aquí se trata de modelar es el conjunto de todas las personas que
  conforman la población de un mapa. Y tratando de que sea lo más funcional
  posible tiene varios métodos para poder crear, borrar, cambiar y consultar
  datos de los nodos que conforman la lista de personas (dichos nodos son las
  personas).
*)

interface

   uses UPersonas; //para sar el tipo persona y sus operaciones.
   (*
     Ahora viene la implementación de la lista de personas, hay dos cosas que ver:
     1) La cantidad de personas es acotada, por lo que se puede representar con un
        array, y tengo la ventaja que la memoria es contigua y es más fácil el acceso
        y el recorrer, pero es muy dificil para borrar una persona, habría que borrar
        los datos y mover todas las personas que están arriba un lugar para atrás.
     2) Usando punteros para crear la lista. Habría que acotar la creación de personas
        para que no sea infinita. Tal vez es más complicado para recorrer, aunque para
        recorrer uso un puntero auxiliar que jugaría como índice en el caso array, así
        que por lo de recorrer sería el mismo trabajo. Para agregar una persona nueva
        tampoco habría mucho problema (sobre todo si se agrega al principio de la lista).
        Y para eliminar serñia más fácil que en el caso array, busco con cierto criterio
        (lugar donde trabaja la persona o nombre de la persona), y elimino fisicamente
        la info, y elimino el nodo de la persona.

        ME QUEDO CON LA LISTA DE PUNTEROS!!! (es más natural que el array, aunque un poco menos eficiente)

        La cantidad máxima de personas va a estar dada por el tamaño del mapa.
   *)

type
   ListaDePersonas = ^NodoLDP;

   NodoLDP = Record {Lista simple encadenada}
             Persona: UPersonas.Persona;
             Siguiente: ListaDePersonas;
          End;

   Function CrearListaDePersonas(): ListaDePersonas;
   Procedure AgregarPersonaLDP (var L: ListaDePersonas);

   Procedure MoverPerLDP (var LP: ListaDePersonas; var LP1: ListaDePersonas);
   {PRE: LP <> nil. Mueve el primer nodo de LP a LP1}
   Procedure LlevarTopPerTrabTerLDP (x,y: Integer; var L: ListaDePersonas);
   {Lleva a la persona que está trabajando en el terreno x,y al principio de la lista L}

   Function PrimerPerLDP (L: ListaDePersonas): Persona;
   {Da la persona del primer nodo de L}

   Function ObtenerPersonaTrabajandoCoordsLDP (x,y: Integer; L: ListaDePersonas): Persona;
   
   function EsVaciaLDP (L: ListaDePersonas): Boolean;
   (*Entrada LDP, TRUE si L es vacia, si no tiene personas, si es NIL*)

   Function SigPerLDP (L: ListaDePersonas): ListaDePersonas;
   {Devuelve el siguiente nodo de L}

   procedure EliminarPrimeroLDP (var L: ListaDePersonas);
   {procedure BorrarPersonaTrabajandoCoordsLDP (x,y: Integer; var L: ListaDePersonas); }
   {procedure BorrarPrimerPersonaLDP (var L: ListaDePersonas);}
   procedure DestruirListaDePersonas (var L: ListaDePersonas);

implementation

   (* ---------------- CONSTRUCTORAS ----------------+++++++++++++++++++++++++++++++++ *)

   function CrearListaDePersonas(): ListaDePersonas;
   (*Retorna una nueva lista de personas vacía*)
   var L: ListaDePersonas;
   begin
      L := nil;
      CrearListaDePersonas := L;
   end; (*CrearListaDePersonas*)

   procedure AgregarPersonaLDP (var L: ListaDePersonas);
   (*PREC: LA catidad de personas debe ser menor que el máximo de personas.
     Agrega una pesona a la lista de personas L*)
      var AuxLDP: ListaDePersonas;
   begin
      New(AuxLDP);
      AuxLDP^.Persona := UPersonas.CrearPersona();
      AuxLDP^.Siguiente := L;
      L := AuxLDP;                    {AGREGO EL NUEVO NODO AL PRINCIPIO}
   end;

   // +++++++++++++++++ PROPIAS DE LDP +++++++++++++++++++++++++++++++++++++++++++++++++++++

   Procedure MoverPerLDP (var LP: ListaDePersonas; var LP1: ListaDePersonas);
   {PRE: LP <> nil. Mueve el primer nodo de LP a LP1}
      var tmp: ListaDePersonas;
   begin
      tmp := LP; {Guardo el primero}
      LP := tmp^.Siguiente; {Quito el primero}

      tmp^.Siguiente := LP1; {Agrego el nodo a LP1}
      LP1 := tmp;
   end;

   Procedure LlevarTopPerTrabTerLDP (x,y: Integer; var L: ListaDePersonas);
   {Lleva a la persona que está trabajando en el terreno x,y al principio de la lista L}
      var tmp, tmp1: ListaDePersonas; a,b: Integer;
   begin
      tmp := L;
      UPersonas.ObtenerLugarTrabajando(tmp^.Persona,a,b);
      if not((a = x) and (b = y)) then {Si no es el primero}
      begin
         UPersonas.ObtenerLugarTrabajando(tmp^.Siguiente^.Persona,a,b); {ver con el segundo}
         while not((a = x) and (b = y)) do {mientras que no encuentre}
         begin
            tmp := tmp^.Siguiente;
            UPersonas.ObtenerLugarTrabajando(tmp^.Siguiente^.Persona,a,b);
         end;
         tmp1 := tmp^.Siguiente;
         tmp^.Siguiente := tmp1^.Siguiente;
         tmp1^.Siguiente := L;
         L := tmp1;
      end; {si no es el primero}
   end;

   // +++++++++++++++++++++++ SELECTORAS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

   Function PrimerPerLDP (L: ListaDePersonas): Persona;   {----------------------------------------}
   (*Devuelve la primer persona de la lista*)
   begin
      PrimerPerLDP := L^.Persona;
   end; (*ObtenerPrimerPerListaDePersonas*)


   Function SigPerLDP (L: ListaDePersonas): ListaDePersonas;      {----------------------------------------}
   {Devuelve el siguiente nodo de L}
   begin
      SigPerLDP := L^.Siguiente;
   end;

   function ObtenerPersonaTrabajandoCoordsLDP (x,y: Integer; L: ListaDePersonas): Persona; {Por ejemplo sirve para ver cuanto extrae la persona de ese terreno, o para ver algun dato de esa persona}
   (* PRECONDICION: Debe haber una persona trabajando en la posicion x,y del mapa.
      HayAlguienTrabajancoCoords(x,y,L) = TRUE;
      Devuelve la persona que está trabajando en la posicion x,y. *)
      var a,b: Integer; Lista: ListaDePersonas;
   begin
      (*Busca recursivamente a la persona*)
      Lista := L;
      UPersonas.ObtenerLugarTrabajando(Lista^.Persona,a,b); (*cargo las coord de trabajo en ab*)
      while (x <> a) and (y <> b) do
         Lista := Lista^.Siguiente; {Por la precondicion se que hay alguien en el lugar, Lista sale con el nodo de esa persona}

      ObtenerPersonaTrabajandoCoordsLDP := Lista^.Persona;
   end;

   // ++++++++++++++++++++ PREDICADOS ++++++++++++++++++++++++++++++++++++++++++++++


   function EsVaciaLDP (L: ListaDePersonas): Boolean;
   (*Entrada LDP, TRUE si L es vacia, si no tiene personas, si es NIL*)
   begin
      EsVaciaLDP := (L = nil);
   end;


   // +++++++++++++++++++ DESTRUCTORAS ++++++++++++++++++++++++++++++++++++++++

   (*REVISAR ************************************************* *)
   {
   procedure EliminarPersonaNoTrabajandoLDP (var L: ListaDePersonas);
   (* Elimina la primer persona que encuentre que no está trabajando en la LDP.
      Precondición: HayAlguienSinTrabajarLDP (L) = TRUE*)
   var AuxLDP, AuxLDP1: ListaDePersonas;
   begin
      if (UPersonas.EstaTrabajandoPersona(L^.Persona)) then
      begin
         AuxLDP := L;

         while (UPersonas.EstaTrabajandoPersona(AuxLDP^.Siguiente^.Persona)) do
         begin
            AuxLDP := AuxLDP^.Siguiente;
         end;

         AuxLDP1 := AuxLDP^.Siguiente; (*Apunta al que tengo que eliminar*)
         AuxLDP^.Siguiente := AuxLDP1^.Siguiente;
         AuxLDP1^.Siguiente := nil;
         DestruirListaDePersonas (AuxLDP1);
      end
      else (*Si la primer persona NO está trabajando*)
      begin (*Elimino el primer nodo*)
         AuxLDP := L;
         L := L^.Siguiente;
         DestruirListaDePersonas(AuxLDP);
      end;
   end; (*EliminarPersonaNoTrabajandoLDP*)
   }

   procedure EliminarPrimeroLDP (var L: ListaDePersonas);  {------------------------------------}
   (*Elimina el primer nodo de la LDP*)
      var AuxLDP: ListaDePersonas;
   begin
      AuxLDP := L^.Siguiente; {Guardo el resto de la lista}
      UPersonas.DestruirPersona (L^.Persona);
      dispose(L);
      L := AuxLDP;
   end; (*EliminarPrimeroLDP*)
   {
   procedure BorrarPrimerPersonaLDP (var L: ListaDePersonas);
   (* PRECONDICIÓN: EsVaciaListaDePersonas(L) = FALSE;
      Borra fisicamente a la primer persona de la lista. *)
      var AuxLDP: ListaDePersonas;
   begin
      AuxLDP := L;
      L := L^.Siguiente;
      DestruirListaDePersonas(AuxLDP);
   end;
   }
   {
   procedure BorrarPersonaListaDePersonas (P: Persona; var L: ListaDePersonas);
   (*Borra a la persona P de la lista de personas, tiene que hacer borrado fisico*)
   begin
   end;
   }
   {
   procedure BorrarPersonaTrabajandoCoordsLDP (x,y: Integer; var L: ListaDePersonas);
   (* PRECONDICION: Tiene que haber una persona trabajando en esas coordenadas.
      (HayAlguienTrabajandoCoords (x,y,L) = TRUE)
      Borra a la persona que está trabajando en la posición x,y del mapa. *)
   begin
   end;
   }

   procedure DestruirListaDePersonas (var L: ListaDePersonas);  {------------------------------------}
   (*Borra fisicamente la estructura de la lista y su contenido*)
   begin
      while not(EsVaciaLDP(L)) do
      begin
         EliminarPrimeroLDP (L); {Elimina nodos de la lista simple}
      end;
      Dispose(L);
   end;

end.
