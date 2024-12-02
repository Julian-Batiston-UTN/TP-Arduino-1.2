bool val=false;

//"LED´s" utilizo botones para simular los leds
int led_1=7;
int led_2=6;

//Botones
int Boton_1=5;
int Boton_2=4;
//Boton switch
int switch_boton=2;

void setup(){
  Serial.begin(9600);

  //Pin led de arduino para ver la comunicación ida y vuelta
  pinMode(13, OUTPUT);

  //"LED´s"
  pinMode(led_1,INPUT_PULLUP);
  pinMode(led_2,INPUT_PULLUP);

  //Botones
  pinMode(Boton_1,INPUT_PULLUP);
  pinMode(Boton_2,INPUT_PULLUP);

  //Boton switch
  pinMode(switch_boton,INPUT_PULLUP);

}

void loop(){
  String mensaje = "";
  String paquete = "";  // reinicio del pquete
  
  // Leer botones y "LEDs" (elegí este tipo de códificación por simplicidad de lectura)
  paquete += digitalRead(Boton_1) == LOW ? "A" : "a";  // "A" si está presionado, "a" si no
  paquete += digitalRead(Boton_2) == LOW ? "B" : "b";
  paquete += digitalRead(led_1) == LOW ? "C" : "c";
  paquete += digitalRead(led_2) == LOW ? "D" : "d";
  paquete += digitalRead(switch_boton) == LOW ? "E" : "e";

  // Enviar el paquete completo con delimitador de fin de línea '\n'
  Serial.println(paquete);

  //verifica si hay datos para leer en el puerto serail
  if (Serial.available() > 0) {
    mensaje = Serial.readStringUntil('\n');
  }
  //Si es C prende el led si es D lo apaga (simula lo que pasaría con 2 leds es solo para notar la comunicación ida y vuelta)
  if(mensaje.charAt(2)=='C'){
    val=true;
  }
  if(mensaje.charAt(3)=='D'){
    val=false;
  }
  
  if(val){
    digitalWrite(13, HIGH);
  }
  else{
    digitalWrite(13, LOW);
  }
  
  digitalRead(switch_boton) == LOW ? delay(500) : delay(0); //Un delay de 500 ms para evitar la sobreescritura en el puerto a la hora de cambiar de estados

  delay(100);  // Ajusta según la frecuencia de lectura deseada

}