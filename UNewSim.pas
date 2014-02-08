unit UNewSim;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UMapa, UPersonas, UIMG, UCity;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Button1: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  Ciudad: UCity.Ciudad;
  Tam: Integer; {Tamaño que va a tener el mapa, dependiendo de los seleccionado.}
  CantPer: Integer; {Cantidad inicial de personas.}
  CantMaxPer: Integer; {Cantidad Maxima de personas en la poblacio}
  Oro, Comida, Madera: Integer;

implementation

uses RES;

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
   Ciudad := nil; {Realmente no se que es un puntero, talvez hacer ini en UCity}
   Tam := -1;
   CantPer := -1;
   Oro := -1;
   Comida := -1;
   Madera := -1;
   CantMaxPer := -1;

   form2.Edit1.Text := '10'; {Texto por defecto}
   form2.Edit2.Text := '10';
   form2.Edit3.Text := '10';
   form2.Edit4.Text := '10';

   //form2.ComboBox1.Text := 'Elija...';
   form2.ComboBox1.AddItem('1',self);            {0}
   form2.ComboBox1.AddItem('2',self);
   form2.ComboBox1.AddItem('3',self);
   form2.ComboBox1.AddItem('4',self);
   form2.ComboBox1.AddItem('5',self);
   form2.ComboBox1.AddItem('6',self);
   form2.ComboBox1.AddItem('7',self);
   form2.ComboBox1.AddItem('8',self);
   form2.ComboBox1.AddItem('9',self);
   form2.ComboBox1.AddItem('10',self);           {9}

   //form2.ComboBox2.Text := 'Elija...';
   form2.ComboBox2.AddItem('5',self);            {0}
   form2.ComboBox2.AddItem('6',self);
   form2.ComboBox2.AddItem('7',self);
   form2.ComboBox2.AddItem('8',self);
   form2.ComboBox2.AddItem('9',self);
   form2.ComboBox2.AddItem('10',self);
   form2.ComboBox2.AddItem('15',self);           {6}

end;

procedure TForm2.Edit1Change(Sender: TObject);
begin
   with form2.Edit1 do
   begin
      if (Text <> '') then
         Oro := strtoint(Text);
   end;
end;

procedure TForm2.Edit2Change(Sender: TObject);
begin
   with form2.Edit2 do
   begin
      if (Text <> '') then
         Comida := strtoint(Text);
   end;
end;

procedure TForm2.Edit3Change(Sender: TObject);
begin
   with form2.Edit3 do
   begin
      if (Text <> '') then
         Madera := strtoint(Text);
   end;
end;

procedure TForm2.Edit4Change(Sender: TObject);
begin
   with form2.Edit4 do
   begin
      if (Text <> '') then
         CantMaxPer := strtoint(Text);
   end;
end;

procedure Comenzar(tam, oro, com, mad, CantPer: Integer);
   var i: Integer;
begin

   if not(UCity.EsVaciaCiudad(Ciudad)) then  {Si la ciudad actual No es vacia, destruirla antes de crear una nueva.}
      UCity.DestruirCiudad(Ciudad);

   {Creo una nueva ciudad}
   //function CrearCiudad(Tam, Mad, Com, Oro, CantMaxPersonas: Integer): Ciudad;
   {Crea una nueva ciudad con su poblacion, mapa y recursos, el mapa tiene tamaño t, Mad Madera, Com Comida, Oro Oro}
   Ciudad := UCity.CrearCiudad(Tam, mad, com, oro, CantMaxPer); {Tamaño del mapa, cantidad de recursos (silos)}

   {Crear personas iniciales.}
   for i := 1 to CantPer do
      UCity.NuevaPersonaCiudad(Ciudad);

   {Actualizo status de fomr 1}
   with form1 do
   begin
      Edit2.Text := '0'; {Personas Trabajando}
      Edit3.Text := '0'; {Madera a extraer}
      Edit4.Text := '0'; {Oro a extraer}
      Edit5.Text := '0'; {Comida a extraer}
      Edit6.Text := inttostr(mad); {Madera inicial}
      Edit7.Text := inttostr(oro); {Oro}
      Edit8.Text := inttostr(com); {Comida}
      Button7.SetFocus; {pone el focus en el boton}
   end;

   RES.Juego();
   RES.DibujarPersonasPob();
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
   if (Oro <= 0) then
   begin
      ShowMessage('Ingrese un número positivo de Oro');
      form2.Edit1.SetFocus;
   end
   else if (Comida <= 0) then
   begin
      ShowMessage('Ingrese un número positivo de Comida');
      form2.Edit2.SetFocus;
   end
   else if (Madera <= 0) then
   begin
      ShowMessage('Ingrese un número positivo de Madera');
      form2.Edit3.SetFocus;
   end
   else if (CantMaxPer <= 0) then
   begin
      ShowMessage('Ingrese un número positivo para la cantidad máxima de personas');
      form2.Edit4.SetFocus;
   end
   else if (CantPer = -1) then
      ShowMessage('Elija la cantidad de personas')
   else if (Tam = -1) then
      ShowMessage('Elija el tamaño del mapa')
   else
   begin
      Comenzar(Tam, Oro, Comida, Madera, CantPer); {Llama con las Vars globales}
      form2.Close;
   end;

end;

procedure TForm2.ComboBox1Change(Sender: TObject);
begin
   case form2.ComboBox1.ItemIndex of {indice seleccionado desde 0}
      0: CantPer := 1; {Se modifice la variable global CantPer, que va a ser el tamaño del mapa}
      1: CantPer := 2;
      2: CantPer := 3;
      3: CantPer := 4;
      4: CantPer := 5;
      5: CantPer := 6;
      6: CantPer := 7;
      7: CantPer := 8;
      8: CantPer := 9;
      9: CantPer := 10;
   end;
end;

procedure TForm2.ComboBox2Change(Sender: TObject);
begin
   case form2.ComboBox2.ItemIndex of {indice seleccionado desde 0}
      0: Tam := 5; {Se modifice la variable global Tam, que va a ser el tamaño del mapa}
      1: Tam := 6;
      2: Tam := 7;
      3: Tam := 8;
      4: Tam := 9;
      5: Tam := 10;
      6: Tam := 15;
   end;
end;



end.
