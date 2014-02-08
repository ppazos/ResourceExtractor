procedure DibujarMapa(Mapa: UMapa.PtrMapa; c: UIMG.ConjBMP; Top, Left: Integer);

   var
      pos_x, pos_y, x,y: Integer;
      img: UIMG.PtrBMP;
      Intersec: Integer;
      RSI: Integer;
      QueSiga: Boolean;
   begin

      {Borra contenido anterior}
      form1.Image1.Canvas.Brush.Color := rgb(150,0,0); {Va a ser el color del fondo del mapa}
      form1.Image1.Canvas.Pen.Color := ClBlack; {Color del borde de Image1}
      form1.Image1.Canvas.Rectangle(0, 0, form1.Image1.Width, form1.Image1.Height);
      {Borra contenido anterior}

      {IMPORTANTE: dependiendo de los márgenes, puede ser más productivo dibujar el mapa de otras maneras, son 4 casos}

      Intersec := trunc((Blok_Width*UMapa.ObtenerTamMapa(Mapa) - Top*Blok_Width/(Blok_Height + 1) + Left)/2);
      QueSiga := True;
      y := 0;
      while (QueSiga) do {hay un caso, que si la RSD int A < 0 y la interseccion con bottom también es < 0, no dibujo más}

         if (Intersec > 0) and (Intersec < UMapa.DeterminarWidthMapa(Mapa) + Blok_Width) then
         {si Int < 0, depende de la interseccion con los demas bordes}
         begin
            x := 0; {Empieza una nueva fila}
            RSI := Trunc(-Intersec/2 + 2*Top + Blok_Width*UMapa.ObtenerTamMapa(Mapa)/2 + Left);
            while (RSI < 0) do
            begin
               RSI := RSI + Trunc((Blok_Height + 1)/2);
               x := x + 1;
            end;

            case (UMapa.ObtenerNumTerrenoMapa(x,y,Mapa)) of
               0: img := UIMG.ObtenerBMPConjBMP(1,c); //PASTO
               1: img := UIMG.ObtenerBMPConjBMP(2,c); //ORO
               2: img := UIMG.ObtenerBMPConjBMP(4,c); //GRANJA
               3: img := UIMG.ObtenerBMPConjBMP(7,c); //CASA
               4: img := UIMG.ObtenerBMPConjBMP(6,c); //ARBOL
            end;

            pos_x := Intersec - Trunc(Blok_Width/2); {Lugar donde debe digujar el primer rombo}
            pos_y := 0;

            while (pos_x < UMapa.DeterminarWidthMapa(Mapa) - Trunc(Blok_Width/2)) do {Mientras no se vaya del margen derecho}
            begin
               Form1.Image1.Canvas.Draw(pos_x, pos_y, img^);
               pos_x := pos_x + trunc(Blok_Width/2);
               pos_y := pos_y + trunc((Blok_Height + 1)/2);
            end;
         end;

      end; {Sigue hasta que completa el dibujo del mapa}

{
      pos_x := trunc(Blok_Width*(High(Mapa^) + 1)/2) - trunc(Blok_Width/2) + Left;
      pos_y := 1 + Top; // para que deje margen de  1px arriva

      for y:=0 to High(Mapa^) do
      begin
         for x:=0 to High(Mapa^[y]) do
         begin

            img := nil;  //en cada vuelta se pone nil.

            case (UMapa.ObtenerNumTerrenoMapa(x,y,Mapa)) of
               0: img := UIMG.ObtenerBMPConjBMP(1,c); //PASTO
               1: img := UIMG.ObtenerBMPConjBMP(2,c); //ORO
               2: img := UIMG.ObtenerBMPConjBMP(4,c); //GRANJA
               3: img := UIMG.ObtenerBMPConjBMP(7,c); //CASA
               4: img := UIMG.ObtenerBMPConjBMP(6,c); //ARBOL
            end;

            Form1.Image1.Canvas.Draw(pos_x, pos_y, img^);

            pos_x := pos_x + trunc(Blok_Width/2);
            pos_y := pos_y + trunc((Blok_Height + 1)/2);

         end;

         pos_x := pos_x - (High(Mapa^[y]) + 2)*trunc(Blok_Width/2);
         pos_y := pos_y - (High(Mapa^))*trunc((Blok_Height + 1)/2);

      end;
}
   end; //dibujar mapa