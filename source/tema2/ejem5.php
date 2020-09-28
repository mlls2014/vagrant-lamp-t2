<!DOCTYPE html>
<!--
 Ejercicio nº5: Uso de ARRAYS
 Crear un array de nombre 'meses' que almacene los nombres de los 12 meses del
año e imprimir por pantalla los valores almacenados a través de un bucle FOR
-->
<html>
    <head>
        <meta charset="UTF-8">
        <title>CursoPhp-Ejercicio nº5</title>
    </head>
    <body>
		<?php
		    echo "<h1>Ejercicio nº5 - Arrays</h1>";
			$meses = array("Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre");
		 	/* Bucle FOR */
			echo "<h2> Contenido del Array 'Meses':</h2>";
			for($i=0;$i< count($meses);$i++)
			{	
				// Mostramos el valor de la posición iésima del array
				echo "<b> - meses[" . $i . "] :</b>" . $meses[$i] . "</br>";
			}	 
		 ?>
    </body>
</html>
