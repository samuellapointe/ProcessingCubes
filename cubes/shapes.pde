//Classe pour les cubes qui flottent dans l'espace
class Cube {
  //Position Z de "spawn" et position Z maximale
  float startingZ = -10000;
  
  // how close the cubes come to the user
  float maxZ = 1000; 
  
  //Valeurs de positions
  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  
  //Constructeur
  Cube() {
    //Faire apparaitre le cube à un endroit aléatoire
    x = random(0, width);
    //y = random(height-height/3, height); // put the cubes in the bottom third of the screen
    y = height*0.75;
    z = random(startingZ, maxZ);
    
    //Random rotation
    rotX = random(0, 1);
    rotY = random(0, 1);
    rotZ = random(0, 1);
  }
  
  //======= CUBE DISPLAY ==========
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    
    //Sélection de la couleur, opacité déterminée par l'intensité (volume de la bande)
    color displayColor = color(scoreLow*0.9, scoreMid*0.9, scoreHi*0.9, intensity*5);
    fill(displayColor, 255);
    
    // Color lines, they disappear with the individual intensity of the cube
    color strokeColor = color(255, 150-(20*intensity));
    stroke(strokeColor);
    strokeWeight(1 + (scoreGlobal/300));
    
    //Création d'une matrice de transformation pour effectuer des rotations, agrandissements
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Calcul de la rotation en fonction de l'intensité pour le cube
    sumRotX += intensity*(rotX/1000);
    sumRotY += intensity*(rotY/1000);
    sumRotZ += intensity*(rotZ/1000);
    
    //Application de la rotation
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
    //Création de la boite, taille variable en fonction de l'intensité pour le cube
    //box(100+(intensity/2));
    
    //Application de la matrice
    popMatrix();
    
    //Déplacement Z
    z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));
    
    //Replacer la boite à l'arrière lorsqu'elle n'est plus visible
    if (z >= maxZ) {
      x = random(0, width);
      y = height*0.75;
      z = startingZ;
    }
  }
}

class Triangle {
  //Position Z de "spawn" et position Z maximale
  float startingZ = -10000;
  
  // how close the cubes come to the user
  float maxZ = 1000; 
  
  //Valeurs de positions
  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  
  //Constructeur
  Triangle() {
    //Faire apparaitre le cube à un endroit aléatoire
    x = random(0, width);
    //y = random(0, height);
    y = height * 0.25;
    z = random(startingZ, maxZ);
    
    //Random rotation
    rotX = random(0, 1);
    rotY = random(0, 1);
    rotZ = random(0, 1);
  } 
  
  //======= TRIANGLE DISPLAY ==========
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    
    //Sélection de la couleur, opacité déterminée par l'intensité (volume de la bande)
    color displayColor = color(scoreLow*0.9, scoreMid*0.9, scoreHi*0.9, intensity*5);
    
    // Color lines, they disappear with the individual intensity of the cube
    color strokeColor = color(255, 150-(20*intensity));
    stroke(strokeColor);
    strokeWeight(1 + (scoreGlobal/300));
    
    //Création d'une matrice de transformation pour effectuer des rotations, agrandissements
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Calcul de la rotation en fonction de l'intensité pour le cube
    sumRotX += intensity*(rotX/1000);
    sumRotY += intensity*(rotY/1000);
    sumRotZ += intensity*(rotZ/1000);
    
    //Application de la rotation
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
    // creation of pyramid
    //beginShape();
    //vertex(-100, -100, -100);
    //vertex( 100, -100, -100);
    //vertex(   0,    0,  100);
    
    //vertex( 100, -100, -100);
    //vertex( 100,  100, -100);
    //vertex(   0,    0,  100);
    
    //vertex( 100, 100, -100);
    //vertex(-100, 100, -100);
    //vertex(   0,   0,  100);
    
    //vertex(-100,  100, -100);
    //vertex(-100, -100, -100);
    //vertex(   0,    0,  100);
    //endShape();
    
    fill(displayColor, 255);
    
    //Application de la matrice
    popMatrix();
    
    //Déplacement Z
    z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));
    
    // Replacer la boite à l'arrière lorsqu'elle n'est plus visible
    if (z >= maxZ) {
      x = random(0, width);
      y = height * 0.25;
      z = startingZ;
    }
  }
}


class Sphere {
  //Position Z de "spawn" et position Z maximale
  float startingZ = -10000;
  
  // how close the cubes come to the user
  float maxZ = 1000; 
  
  //Valeurs de positions
  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  
  //Constructeur
  Sphere() {
    //Faire apparaitre le cube à un endroit aléatoire
    x = random(0, width);
    //y = random(0 + height/3, height-height/3);
    y = height*0.5;
    z = random(startingZ, maxZ);
    
    //Random rotation
    rotX = random(0, 1);
    rotY = random(0, 1);
    rotZ = random(0, 1);
  } 
  
  //======= Sphere ==========
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    
    //Sélection de la couleur, opacité déterminée par l'intensité (volume de la bande)
    color displayColor = color(scoreLow*0.9, scoreMid*0.9, scoreHi*0.9, intensity*5);
    fill(displayColor, 255);
    
    // Color lines, they disappear with the individual intensity of the cube
    color strokeColor = color(255, 150-(20*intensity));
    stroke(strokeColor);
    strokeWeight(1 + (scoreGlobal/300));
    
    //Création d'une matrice de transformation pour effectuer des rotations, agrandissements
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Calcul de la rotation en fonction de l'intensité pour le cube
    sumRotX += intensity*(rotX/1000);
    sumRotY += intensity*(rotY/1000);
    sumRotZ += intensity*(rotZ/1000);
    
    //Application de la rotation
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);
    
    //sphere(50+(intensity/2));
    
    //Application de la matrice
    popMatrix();
    
    //Déplacement Z
    z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));
    
    // Replacer la boite à l'arrière lorsqu'elle n'est plus visible
    if (z >= maxZ) {
      x = random(0, width);
      y = height*0.5;
      z = startingZ;
    }
  }
}