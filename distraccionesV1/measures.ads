--Jorge Pérez de Paz
--Isamel Racine Niang Losada

package measures is

Protected Datos is
    pragma priority (14);
    function GetDistancia return Integer;
    function GetVelocidad return Integer;
    procedure SetVelocidad (Vel : Integer);
    procedure SetDistancia (Dist : Integer);
private
    Distancia: Integer := 0;
    Velocidad: Integer := 0;
end Datos;

end measures;
