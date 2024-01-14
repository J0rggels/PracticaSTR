package tasks is

    task Cabeza_Inclinada is
        pragma priority (15);
    end Cabeza_Inclinada;
    
    task Distancia_Seguridad is
        pragma priority (13);
    end Distancia_Seguridad;

    task Giro_Volante is
        pragma priority (12);
    end Giro_Volante;

    task Display is
        pragma priority (11);
    end Display;

    task Riesgos is
        pragma priority (14);
    end Riesgos;

end tasks;z
