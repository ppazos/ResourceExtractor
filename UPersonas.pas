unit UPersonas;

(*
  PERSONAS:
  Aquí se intenta modelar el tipo de dato persona con todos los atributos que sean
  relevantes para el RES. Los metodos que están aquí actúan sobre las personas,
  creando, borrando y consultando datos.
*)

interface

const
   MaxPersonas = 20; (*Esto tiene que ser una variable definida en el programa principal
   que se actualiza dinámicamente dependiendo de la cantida de casas.
   *)
   //Luego, la idea es que el másximo de personas lo ponga el user Como en AOE.
   //Y que al crear nuevas casas, puedo mover mi cota de personas hasta alcanzar el máximo.

type
   Persona = ^PersonaNFO; //Persona es un pointer to PersonaNFO
   PersonaNFO = Record
      (*Se podría poner Nombre a cada persona*)
      OroExt: Integer; //oro extraido por la persona hasta el momento.
      ComidaExt: Integer; //comida extraida por la persona hasta el momento.
      MaderaExt: Integer; //Madera extraída por la persona hasta el momento.

      CantExtraccion: Integer; //cantidad de recurso que extrae por turno.

      Edad: Integer; //edad actual desde la creación de la persona.
      case Trabajando: Boolean of
      //Si está trabajando, Trab_x Trab_y guarda la posición del terreno donde trabaja.
      //sería bueno que fuera un pointer así puedo hacer ObtenerLugarTrabajando();
         true: (Trab_x, Trab_y: integer); //Caso está trabajando.
         false: (); //Caso: No está trabajando.
   end;

(*CONS*)
   function CrearPersona(): Persona;
   (* Reserva memoria e inicializa todas las variables de Persona, crea un nueva persona. *)
(*AUX*)
   procedure PonerATrabajarPersona (var P: Persona; x, y: Integer);
   (* Prec: El lugar x,y no está ocupado. Pone a trabajar a la persona P en el lugar x,y *)

   procedure PonerADescansarPersona (var P: Persona);
   (* Hace que la persona P deje de trabajar. Si no estaba trabajamdo, no tiene efecto. *)
(*PRED*)
   function EstaTrabajandoPersona (P: Persona): Boolean;
   (* TRUE si la persona P está trabajado *)
(*SEL*)
   procedure ObtenerLugarTrabajando (P: Persona; var a,b: integer);
   (* PREC: P tiene que estar trabajando. Devuelve las coordenadas donde P está trabajando. *)

   function ObtenerEdadPersona (P: Persona): Integer;
   (* Cantidad de turnos que pasaron desde que la persona fue creada *)

   procedure EstadisticasPersona (P: Persona; VAR oro, mad, com: Integer);
   (* Devuelve la cantidad de oro, madera, comida extraída por esa persona hasta el momento *)

   function CantidadExtraccionPersona (P: Persona): Integer;
   (* Devuelve la cantidad de recurso que extrae la persona P por turno. *)
(*DEST*)
   procedure DestruirPersona (var P: Persona);
   (* Libera memoria reservada por P, ¡Mata a la persona!, ASESINO! *)


implementation

   function CrearPersona(): Persona;
      var P: Persona;
   begin
      new(P); (*Reservo memoria*)
      P^.OroExt := 0; P^.ComidaExt := 0; P^.MaderaExt := 0;
      P^.Edad := 0;
      P^.Trabajando := False;
      P^.CantExtraccion := 1; (* ¡¡¡ Tiene que ser >= 1 !!!*)
      CrearPersona := P;
   end;


   procedure PonerATrabajarPersona (var P: Persona; x, y: Integer);
   (* PREC: el lugar x,y del mapa NO ESTA ocupado.
     Pone a trabajar a la persona P, en el lugar x,y del mapa. No importa si ya estaba trabajando en otro terreno. *)
   begin
      P^.Trabajando := True;
      P^.Trab_x := x;
      P^.Trab_y := y;
   end; (*PonerATrabajarPersona*)


   procedure PonerADescansarPersona (var P: Persona);
   (* Hace que P no trabaje más, sin importar que no esté trabajando, si es así, no tiene efecto. *)
   begin
      P^.Trabajando := False;
   end; (*PonerADescansarPersona*)


   function EstaTrabajandoPersona (P: Persona): Boolean;
   (*TRUE si P está trabajando*)
   begin
      EstaTrabajandoPersona := P^.Trabajando;
   end; (*EstaTrabajandoPersona*)


   procedure ObtenerLugarTrabajando (P: Persona; var a,b: integer);
   (* Precondición: EstaTrabajandoPersona(P) = TRUE.
      Devuelve en a,b las coordenadas del lugar donde está trabajando*)
   begin
      a := P^.Trab_x;
      b := P^.Trab_y;
   end; (*ObtenerLugarTrabajando*)


   procedure EstadisticasPersona (P: Persona; VAR oro, mad, com: Integer);
   (* Devuelve la cantidad de oro, madera, comida extraída por esa persona hasta el momento *)
   begin
      oro := P^.OroExt; mad := P^.MaderaExt; com := P^.ComidaExt;
   end; (*Estadisticas persona*)


   function CantidadExtraccionPersona (P: Persona): Integer;
   (* Devuelve la cantidad de recurso que extrae la persona P por turno. *)
   begin
      CantidadExtraccionPersona := P^.CantExtraccion;
   end; (*CantidadExtraccionPersona*)


   function ObtenerEdadPersona (P: Persona): Integer;
   (*Devuelve la edad de P*)
   begin
      ObtenerEdadPersona := P^.Edad;
   end; (*ObtenerEdadPersona*)


   procedure DestruirPersona (var P: Persona);
   (* Elimina fisicamente a la persona P *)
   begin
      dispose(P);
   end; (*DestruirPersona*)

end.
