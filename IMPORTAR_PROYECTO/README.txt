Pasos a seguir para importar el proyecto y escribir cualquier programa:
REQUISITO PREVIO: Instalar Vivado, recomendable la última versión disponible.

1. Extraer el fichero "CPU_Pablo_Rivero.xpr.zip" en el directorio donde deseemos 
guardar el proyecto. Se extraerá una única carpeta llamada CPU.

2. Entrar a la carpeta CPU y hacer doble click sobre el fichero "CPU.xpr". Este fichero se 
puede reconocer porque tiene el logo de Vivado y dice ser del tipo "Vivado Project File".
Esto abrirá el proyecto en Vivado con todos los Sources del proyecto ya incluidos.

3. Para poder ejecutar un programa, necesitamos coger uno de los ficheros de texto ip.coe
disponibles en GitHub y colocarlo en la carpeta raíz CPU. Cualquiera de los 2 programas es válido.
Ahora bien, para que la memoria se inicie según el contenido escrito es necesario ir a 
Vivado >> Sources >> Design Sources >> Hacer click derecho sobre el componente 
"BRAM: blk_mem_gen_0" >> Reset Output Products
Una vez reseteado, volvemos a hacer click derecho en él >> Generate Output Products

De esta manera, la BRAM ha sido inicializada según los valores que marca el fichero ip.coe  elegido.
SI QUEREMOS ESCRIBIR NUESTRO PROPIO PROGRAMA solo es necesario modificar el fichero ip.coe con
los números hexadecimales correspondientes y volver a realizar el paso 3. Ahora bien, para poder 
escribir nuestro propio programa y conocer los números hexadecimales que necesitamos es necesario
leer y entender previamente el Repertorio de Instrucciones descrito en la memoria del TFG.

-Para realizar una Simulación Funcional:
4. En Project Manager >> SIMULATION >> Click derecho en
Run Simulation >> Reset Behavioral Simulation.
Una vez reseteada, se procede a realizarla pinchando en Run Simulation >> 
Run Behavioral Simulation.

5. En Scope pinchar en uut, ir al componente de interés >> Click derecho >> Add to Wave Window
De esta manera, podemos añadir todos los componentes que queramos estudiar. 
Es recomendable, en función de si trabajamos con números signed o unsigned, hacer click
derecho en la señal de interés (ventana Untitled 1, columna Name) >> Radix >> 
elegir signed/unsigned decimal

-Para cargar sobre la FPGA (necesaria placa de desarrollo Nexys A7 100-T)
4. Para generar fichero .bit vamos a la ventana Proyect Manager >> PROGRAM AND DEBUG >> 
Generate Bitstream

5. Conectar la placa de desarrollo al ordenador por puerto USB

6. Ir de nuevo a la ventana Proyect Manager >> PROGRAM AND DEBUG >> Open Hardware Manager

7. En la ventana Hardware >> click en Auto Connect

8. Click en Program Device 

--------------------------------------------------------------------------------------------
Para cualquier consulta: privero004@ikasle.ehu.eus  o  pabloriv508@gmail.com
