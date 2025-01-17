program horseprj;

{$APPTYPE CONSOLE}

{$R *.res}

uses Horse, System.SysUtils, Horse.Jhonson, System.JSON;


begin

  THorse.Use(Jhonson());

  THorse.Get('/clientes',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      clientes : TJSONArray;
    begin

      try

        clientes := TJSONArray.Create;
        clientes.Add(TJSONObject.Create(TJSONPair.Create('nome', 'ATFC')));
        clientes.Add(TJSONObject.Create(TJSONPair.Create('nome', 'ABC')));

        Writeln('Request GET /clientes');
        Res.Send<TJSONArray>(clientes);

      except on ex:exception do
        Res.Send(TJSONObject.Create.AddPair('Mensagem', ex.Message)).Status(500);
      end;

    end);

  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse)
    begin
      Writeln('Request GET /ping');
      Res.Send('pong');
    end);

  THorse.Post('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      LBody: TJSONObject;
    begin
      // Req.Body gives access to the content of the request in string format.
      // Using jhonson middleware, we can get the content of the request in JSON format.
      Writeln('Request POST /ping');
      LBody := Req.Body<TJSONObject>;
      Res.Send<TJSONObject>(LBody);
    end);

  THorse.Listen(9000);

end.
