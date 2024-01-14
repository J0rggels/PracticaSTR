--Jorge Pérez de Paz
--Isamel Racine Niang Losada

with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with Devices; use Devices;

with symptoms; use symptoms;
with measures; use measures;

package body tasks is
    task body Cabeza_Inclinada is
    Current_Head : HeadPosition_Samples_Type;
    Old_Head: HeadPosition_Samples_Type:= (+1,-1);
    Giro: Steering_Samples_Type := 0;
    Siguiente_Instante : Time;
    Intervalo : Time_Span := Milliseconds (400);
    
    I : Time;
    F : Time_Span;
    begin
        Siguiente_Instante := Big_Bang + Intervalo;
        loop
            Starting_Notice("Cabeza_Inclinada");
            
            I := Clock;
            
            Reading_HeadPosition (Current_Head);
            Reading_Steering (Giro);
            
            if (abs(Current_Head(x)) > 30 and abs(Old_Head(x)) > 30) then
                symptoms.Datos.SetCabezaInclinada(true);
            elsif (((Current_Head(y) > 30 and Old_Head(y) > 30) and Giro <= 0) or
            ((Current_Head(y) < -30 and Old_Head(y) < -30) and Giro >= 0)) then
                symptoms.Datos.SetCabezaInclinada(true);
            else
                symptoms.Datos.SetCabezaInclinada(false);
            end if;
            
            F := Clock - I;
            Put(" |Duracion ---->>> ");
            Put(Duration'Image(To_Duration(F)));
            Old_Head := Current_Head;

            Finishing_Notice("Cabeza_Inclinada");

           delay until Siguiente_Instante;
    	   Siguiente_Instante := Siguiente_Instante + Intervalo;
        end loop;
    end Cabeza_Inclinada;
    
    task body Distancia_Seguridad is
    V: Speed_Samples_Type;
    D: Distance_Samples_Type;
    DS : float := 0.0;
    Siguiente_Instante : Time;
    Intervalo : Time_Span := Milliseconds (300);
    
    I : Time;
    F : Time_Span;
    begin
    	Siguiente_Instante := Big_Bang + Intervalo;
        loop
            Starting_Notice("Distancia_Seguridad");
            
            I := Clock;
            
            Reading_Speed (V);
            Reading_Distance (D);
            measures.Datos.SetDistancia(Integer(D));
            
            DS := (float(V) / 10.0) ** 2;
            if (float(D) < DS / 3.0) then
                symptoms.Datos.SetDistancia(COLISION);
            elsif (float(D) < DS / 2.0) then
                symptoms.Datos.SetDistancia(IMPRUDENTE);
            elsif (float(D) < DS) then
                symptoms.Datos.SetDistancia(INSEGURA);
            else
                symptoms.Datos.SetDistancia(SEGURA);
            end if;
            
            F := Clock - I;
            Put(" |Duracion ---->>> ");
            Put(Duration'Image(To_Duration(F)));

            Finishing_Notice("Distancia_Seguridad");

            delay until Siguiente_Instante;
            Siguiente_Instante := Siguiente_Instante + Intervalo;
        end loop;
    end Distancia_Seguridad;


    task body Giro_Volante is
    Current_Giro: Steering_Samples_Type;
    Old_Giro: Steering_Samples_Type := 0;
    V: Speed_Samples_Type;
    Siguiente_Instante : Time;
    Intervalo : Time_Span := Milliseconds (350);
    
    I : Time;
    F : Time_Span;
    begin
    	Siguiente_Instante := Big_Bang + Intervalo;
        loop
            Starting_Notice("Giro_Volante");
            
            I := Clock;
            
            Reading_Steering (Current_Giro);
            Reading_Speed (V);
            if (abs(Current_Giro - Old_Giro) > 20 and V >= 40) then
                symptoms.Datos.SetVolantazo(true);
            else
                symptoms.Datos.SetVolantazo(false);
            end if;
            
            F := Clock - I;
            Put(" |Duracion ---->>> ");
            Put(Duration'Image(To_Duration(F)));
            
            Old_Giro := Current_Giro;
            Finishing_Notice("Giro_Volante");

            delay until Siguiente_Instante;
            Siguiente_Instante := Siguiente_Instante + Intervalo;
        end loop;
    end Giro_Volante;

    task body Display is
    V: Speed_Samples_Type := 0;
    D: Distance_Samples_Type := 0;
    Dist : TipoDistancia;
    Siguiente_Instante : Time;
    Intervalo : Time_Span := Milliseconds (1000);
    
    I : Time;
    F : Time_Span;
    begin
        Siguiente_Instante := Big_Bang + Intervalo;
        loop
            Starting_Notice("Display");
            
            I := Clock;
            
            Dist := symptoms.Datos.GetDistancia;
            Reading_Speed (V);
            Reading_Distance (D);
            Put("Velocidad: ");
      	    Print_an_Integer (measures.Datos.GetVelocidad); 
            New_Line;
            Put("Distancia: ");
            Print_an_Integer (measures.Datos.GetDistancia);
            New_Line;
            Put_Line("Sintomas");
            
            -- DISTANCIA
            if symptoms.Datos.GetCabezaInclinada and
            Dist = COLISION then
                Put_Line("COLISION INMINENTE");
            elsif Dist = IMPRUDENTE then
                Put_Line("DISTANCIA IMPRUDENTE");
            elsif Dist = INSEGURA then
                Put_Line("DISTANCIA INSEGURA");
            end if;

            -- CABEZA INCLINADA
            if symptoms.Datos.GetCabezaInclinada = true then
                Put_Line("CABEZA INCLINADA");
            end if;

            -- VOLANTAZO
            if symptoms.Datos.GetVolantazo = true then
                Put_Line("VOLANTAZO");
            end if;
            
            F := Clock - I;
            Put(" |Duracion ---->>> ");
            Put(Duration'Image(To_Duration(F)));

            Finishing_Notice("Display");

    	    delay until Siguiente_Instante;
    	    Siguiente_Instante := Siguiente_Instante + Intervalo;
        end loop;
    end Display;
    
    task body Riesgos is
    V: Speed_Samples_Type := 0;
    Dist : TipoDistancia;
    Cab : Boolean;
    Siguiente_Instante : Time;
    Intervalo : Time_Span := Milliseconds (150);

    I : Time;
    F : Time_Span;
    begin
        Siguiente_Instante := Big_Bang + Intervalo;
        loop
            Starting_Notice("Riesgos");
            
            I := Clock;
            
            Reading_Speed (V);
            measures.Datos.SetVelocidad(Integer(V));
            
            Dist := symptoms.Datos.GetDistancia;
            Cab := symptoms.Datos.GetCabezaInclinada;

            -- DISTANCIA
            if Cab and Dist = COLISION then
                Beep(5);
                Activate_Brake;
            elsif Dist = IMPRUDENTE then
                Beep(4);
                Light(On);
            elsif Dist = INSEGURA then
                Light(On);
            end if;


            -- CABEZA INCLINADA
            if Cab then
                if V >= 70 then
                    Beep(3);
                else
                    Beep(2);
                end if;
            end if;

            -- VOLANTAZO
            if symptoms.Datos.GetVolantazo = true then
                Beep(1);
            end if;
            
            F := Clock - I;
            Put(" |Duracion ---->>> ");
            Put(Duration'Image(To_Duration(F)));

            Finishing_Notice("Riesgos");

            delay until Siguiente_Instante;
    	    Siguiente_Instante := Siguiente_Instante + Intervalo;
        end loop;
    end Riesgos;


end tasks;



