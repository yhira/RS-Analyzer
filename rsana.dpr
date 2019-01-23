program rsana;

uses
  Forms,
  Main in 'Main.pas' {RSAnalyzerForm},
  RemoteStation in 'RemoteStation.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'RS-Analyzer';
  Application.CreateForm(TRSAnalyzerForm, RSAnalyzerForm);
  Application.Run;
end.
