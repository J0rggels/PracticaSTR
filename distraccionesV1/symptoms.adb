--Jorge Pérez de Paz
--Isamel Racine Niang Losada

with tools; use tools;
with Ada.Real_Time; use Ada.Real_Time;

package body symptoms is

protected body Datos is

    function GetVolantazo return boolean is
    begin
    	Execution_Time(Milliseconds(3));
        return Volantazo;
    end GetVolantazo;

    function GetCabezaInclinada return boolean is
    begin
        Execution_Time(Milliseconds(6));
        return CabezaInclinada;
    end GetCabezaInclinada;

    function GetDistancia return TipoDistancia is
    begin
        Execution_Time(Milliseconds(2));
        return Distancia;
    end GetDistancia;

    procedure SetVolantazo (Vol : boolean) is
    begin
        Execution_Time(Milliseconds(5));
        Volantazo := Vol;
    end SetVolantazo;

    procedure SetCabezaInclinada(Cabeza : boolean) is
    begin
        Execution_Time(Milliseconds(4));
        CabezaInclinada := Cabeza;
    end SetCabezaInclinada;

    procedure SetDistancia (Dist : TipoDistancia) is
    begin
        Execution_Time(Milliseconds(3));
        Distancia := Dist;
    end SetDistancia;

end Datos;

begin
    null;
end symptoms;

