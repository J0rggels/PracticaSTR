--Jorge Pérez de Paz
--Isamel Racine Niang Losada

package symptoms is

type TipoDistancia is (SEGURA, INSEGURA, IMPRUDENTE, COLISION);

Protected Datos is
    pragma priority (15);
    function GetVolantazo return boolean;
    function GetCabezaInclinada return boolean;
    function GetDistancia return TipoDistancia;
    procedure SetVolantazo (Vol : boolean);
    procedure SetCabezaInclinada(Cabeza : boolean);
    procedure SetDistancia (Dist : TipoDistancia);
private
    Distancia: TipoDistancia := SEGURA;
    Volantazo: boolean := false;
    CabezaInclinada: boolean := false;
end Datos;

end symptoms;
