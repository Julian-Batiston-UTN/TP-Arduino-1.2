import processing.serial.*;//Biblioteca para la comunicación en serie

//Variables globales para el Alto y el Ancho
float Al,An;

Serial myPort;  // Objeto para manejar la comunicación serial
char[] estados={'a','b','c','d','e'}; //Cadena de estado de los botones/"LED´s"

boolean v1,v2;

void setup(){
  size(800,400);
  Al=height;
  An=width;
  
  myPort = new Serial(this, Serial.list()[1], 9600);//Inicialización del puerto
  myPort.bufferUntil('\n');//Modo lectura
}

void draw(){
  //Variables con las que voy a trabajar
  float x=0,y=0,ancho=An*0.2,alto=Al*0.1;

  textAlign(CENTER,CENTER);
  textSize(height*0.07);
  
  background(241,233,212);
  
  //Dibujo de la parte de ENTRADAS y SALIDAS
  for(int i=0;i<2;i++){
    
    fill(238,170,186);
    x=An*0.2+(An*0.2*2*i);
    y=Al*0.1;
    rect(x,y,ancho,alto,20);
    
  }
  
  y=y+y/2;
  x=x+An*0.2/2;
  
  fill(0);
  text("SALIDAS",x,y);
  x=x-(An*0.2*2);
  text("ENTRADAS",x,y);
  /*--------------------------------------------------*/  
  
  //Función para leer las teclas presionadas por el arduino
  lecturaArduino();
  delay(100);
  
  for(int i=1;i<3;i++){
    for(int j=1;j<3;j++){
      
      //Color predeterminado
      fill(212,220,233);
      
      //Dependiendo de la letra leída se pinta de verde o gris
      validacionTeclas(i,j);
      
      x=An*0.2+(An*0.4*(i-1));
      y=Al*0.3+(Al*0.2*(j-1));
      
      //Función para detectar las acciones del mouse
      clickMouse(i,j,x, y, alto, ancho);
      
      //Dibujo de los rectangulos grises o verdes de las entradas y las salidas
      rect(x,y,ancho,alto,20);
    
      fill(0);
      x=An*0.3+(An*0.4*(i-1));
      y=Al*0.35+(Al*0.2*(j-1));
      
      if(i==1){
        text("ENTRADA "+j,x,y);
      }
      if(i==2){
        text("SALIDA "+j,x,y);
      }
      /*--------------------------------------------------*/

    }
  }
  
}

//Función de lectura del puerto
void lecturaArduino(){
  if (myPort.available() > 0) {  // Verifica si hay datos disponibles en el puerto serial
    String datos = myPort.readStringUntil('\n');  // Lee hasta el salto de línea
    if(datos!=null){
      datos = datos.trim();  // Elimina espacios extras o saltos de línea
      
      // Actualiza los estados con los nuevos valores recibidos
      for (int i = 0; i < datos.length(); i++) {
        estados[i] = datos.charAt(i);
      }
    }
  }
}


void validacionTeclas(int i, int j){
  
      //Verde en caso de que los "LED´s" o los botones esten encendidos o pulsados
      if(estados[0]=='A'&&i==1&&j==1){
        fill(163,196,183);
      }
      if(estados[1]=='B'&&i==1&&j==2){
        fill(163,196,183);
      }
      if(estados[2]=='C'&&i==2&&j==1){
        fill(163,196,183);
      }
      if(estados[3]=='D'&&i==2&&j==2){
        fill(163,196,183);
      }
  
  
}


//Función para saber en donde se encuentra el mouse en una zona delimitada por 4 puntos 
boolean interaccionMouse(float x1,float x2,float y1,float y2){
  if(mouseX>x1 && mouseX<x2 && mouseY>y1 && mouseY<y2){
    return true;
  }
  return false;
}


void clickMouse(int i,int j,float x, float y, float alto, float ancho){
  
  //Si se pulsa el mouse e "i==2" en ese caso se ve si la zona clickeada es la correcta
  if(mousePressed&&i==2){
    
    //La condición de j determina que se pinte la casilla adecuada
    
    if(interaccionMouse(x,x+ancho,y,y+alto)&&j==1){
      v1=!v1;
      
      myPort.write("abCde"); //Mando por el puerto serial C para lu procesado
      delay(50);
    }
    if(interaccionMouse(x,x+ancho,y,y+alto)&&j==2){
      v2=!v2;
      
      myPort.write("abcDe");//Mando por el puerto serial D para lu procesado
      delay(50);
    }
  }
  //Si el usuario pulsa el botón asociado a la letra E para el reinicio 
  if(estados[4]=='E'){
    
    estados[4]='e';
    
    if(v1 || v2){
      //Simulación de apagar los leds (en este caso el led de arduino pin13)
      v1=false;
      v2=false;
      myPort.write("abcDe");
    }
    else{
      v1=true;
      v2=true;
      //Simulación de prender los leds (en este caso el led de arduino pin13)
      myPort.write("abCde");
    }
    
  }
  
  //Si el usuario pulsa en una casilla se prende hasta que el usuario presiona el boton de reinicio de comunicación o la casilla nuevamente 
  if(v1&&i==2&&j==1){
    fill(163,196,183);
    
  }
  if(v2&&i==2&&j==2){
    fill(163,196,183);
    
  }
  
}
