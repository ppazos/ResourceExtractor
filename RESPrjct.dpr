program RESPrjct;

{%ToDo 'RESPrjct.todo'}

uses
  Forms,
  RES in 'RES.pas' {Form1},
  UMapa in 'UMapa.pas',
  UPersonas in 'UPersonas.pas',
  ULiPer in 'ULiPer.pas',
  URSC in 'URSC.pas',
  UCity in 'UCity.pas',
  UIMG in 'UIMG.pas',
  UNewSim in 'UNewSim.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
