--Jorge Pérez de Paz
--Isamel Racine Niang Losada

with tools; use tools;
with Ada.Real_Time; use Ada.Real_Time;

package body measures is

protected body Datos is

    function GetVelocidad return Integer is
    begin
        Execution_Time(Milliseconds(3));
        return Velocidad;
    end GetVelocidad;

    function GetDistancia return Integer is
    begin
        Execution_Time(Milliseconds(8));
        return Distancia;
    end GetDistancia;

    procedure SetVelocidad (Vel : Integer) is
    begin
        Execution_Time(Milliseconds(7));
        Velocidad := Vel;
    end SetVelocidad;

    procedure SetDistancia (Dist : Integer) is
    begin
        Execution_Time(Milliseconds(2));
        Distancia := Dist;
    end SetDistancia;

end Datos;

begin
    null;
end measures;
