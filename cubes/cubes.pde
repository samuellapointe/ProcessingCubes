import ddf.minim.*;
import ddf.minim.analysis.*;
 
Minim minim;
AudioPlayer song;
FFT fft;

// Variables qui définissent les "zones" du spectre
// Par exemple, pour les basses, on prend seulement les premières 4% du spectre total
float specLow = 0.03; // 3%
float specMid = 0.125;  // 12.5%
float specHi = 0.20;   // 20%

// Il reste donc 64% du spectre possible qui ne sera pas utilisé. 
// Ces valeurs sont généralement trop hautes pour l'oreille humaine de toute facon.

// Valeurs de score pour chaque zone
float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

// Valeur précédentes, pour adoucir la reduction
float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;

// Valeur d'adoucissement
float scoreDecreaseRate = 25;

// Cubes qui apparaissent dans l'espace
int nbCubes;
Cube[] cubes;

// Spheres for mid frequencies
int nbSpheres;
Sphere[] spheres;

// Triangles
int nbTriangles;
Triangle[] triangles;

//Lignes qui apparaissent sur les cotés
int nbMurs = 2000;
Mur[] murs;

FloatDict spotifySongData;
 
color getEmotionColor(){
  // we are using HSB color scheme to differentiate between warm (happy, energetic) and cold (sad, calm)
  // H tells the warmth of the color, lowering S makes it pastel, "relaxed", "calm". By lowering B it becomes darker, "sad"?
  return 1;
}
void setup()
{
  // Get refreshed token from Spotify
  setupSpotify();
  
  // Get audio features based on song ID
  
  // Songs we have:
  // Bob Marley - One Love: 2iSXgduBpKrwJuQcuybkxP
  // Slipknot - People = Shit: 3nSK1M29hY2Jg2CjsJe98h
  // Kazoo Kid: 0mXu9RFixtjgppxSvcYcYI
  // Simon & Garfunkel - Sound of Silence: 2LkaNhCrNVmcYgXJeLVmsw 
  
  spotifySongData = new FloatDict();
  
  // Get several properties: tempo, energy, musicKey, loudness, mode, valence
  spotifySongData = getSpotifyData("2iSXgduBpKrwJuQcuybkxP");
  
  // Example on how to get specific data from the dictionary
  // spotifySongData.get("tempo"));
  
  //Faire afficher en 3D sur tout l'écran
  fullScreen(P3D);
 
  //Charger la librairie minim
  minim = new Minim(this);
 
  //Load the song (found in data folder) 
  song = minim.loadFile("song.mp3");
  
  //Créer l'objet FFT pour analyser la chanson
  fft = new FFT(song.bufferSize(), song.sampleRate());
  
  //Un cube par bande de fréquence
  // Added the multiplier at the end, to modify the number of cubes
  //1 = happy/energetic
  //0 = sad
  println("tempo: " + spotifySongData.get("tempo")); //50-200
  println("energy: " + spotifySongData.get("energy")); //0-1
  println("valence: " + spotifySongData.get("valence"));//0-1
  println("loudness: " + spotifySongData.get("loudness"));//-60 - 0 (dB)
  println("mode: " + spotifySongData.get("mode"));//0 or 1
  
  // nbCubes = (int)(fft.specSize()*specHi*(spotifySongData.get("energy")));

  // use it to diminish the number of elements displayed on screen
  float lessElements = 0.5;

  // Take only low frequencies for cubes (0-3%)
  nbCubes = (int)(fft.specSize() * specLow * lessElements);
  cubes = new Cube[nbCubes];
  println("nbCubes: " + nbCubes);

  // Take only medium frequencies for spheres (3%-12.5%)
  nbSpheres = (int)((fft.specSize()*specMid - nbCubes) * lessElements);
  spheres = new Sphere[nbSpheres];
  println("nbSpheres: " + nbSpheres);
  
  // Take only hi frequencies for triangles
  nbTriangles = (int)((fft.specSize()*specHi - nbSpheres - nbCubes) * lessElements);
  triangles = new Triangle[nbTriangles];
  println("nbTriangles: " + nbTriangles);
  
  //Autant de murs qu'on veux
  murs = new Mur[nbMurs];

  //Create the Cube objects
  for (int i = 0; i < nbCubes; i++) {
   cubes[i] = new Cube(); 
  }
  
  //Create the Sphere objects
  for (int i = 0; i < nbSpheres; i++) {
   spheres[i] = new Sphere(); 
  }
  
  //Create the Triangle objects
  for (int i = 0; i < nbTriangles; i++) {
   triangles[i] = new Triangle(); 
  }
  
  //Créer les objets murs
  //Murs gauches
  for (int i = 0; i < nbMurs; i+=4) {
   murs[i] = new Mur(0, height/2, 10, height); 
  }
  
  //Murs droits
  for (int i = 1; i < nbMurs; i+=4) {
   murs[i] = new Mur(width, height/2, 10, height); 
  }
  
  //Murs bas
  for (int i = 2; i < nbMurs; i+=4) {
   murs[i] = new Mur(width/2, height, width, 10); 
  }
  
  //Murs haut
  for (int i = 3; i < nbMurs; i+=4) {
   murs[i] = new Mur(width/2, 0, width, 10); 
  }
 
  //Fond noir
  background(0);
  
  //Commencer la chanson
  song.play(0);
}
 
void draw()
{
  //Faire avancer la chanson. On draw() pour chaque "frame" de la chanson...
  fft.forward(song.mix);
  
  //Calcul des "scores" (puissance) pour trois catégories de son
  //D'abord, sauvgarder les anciennes valeurs
  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;
  
  //Réinitialiser les valeurs
  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;
 
  //Calculer les nouveaux "scores"
  for(int i = 0; i < fft.specSize()*specLow; i++)
  {
    scoreLow += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++)
  {
    scoreMid += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++)
  {
    scoreHi += fft.getBand(i);
  }
  
  //Faire ralentir la descente.
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }
  
  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }
  
  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }
  
  //Volume pour toutes les fréquences à ce moment, avec les sons plus haut plus importants.
  //Cela permet à l'animation d'aller plus vite pour les sons plus aigus, qu'on remarque plus
  float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;

  //Canvas background color
  background(scoreLow/100, scoreMid/100, scoreHi/100);
  println("\n");
  
  // Cubes for the low frequencies
  for(int i = 0; i < nbCubes; i++)
  {
    // Band of frequence value
    float bandValue = fft.getBand(i);//amplitude of certain band of frequency
    //println("band value: " + bandValue); //0-15
    
    //La couleur est représentée ainsi: rouge pour les basses, vert pour les sons moyens et bleu pour les hautes. 
    //L'opacité est déterminée par le volume de la bande et le volume global.
    cubes[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
  
  // Spheres for the mid frequencies
  for(int i = 0; i < nbSpheres; i++)
  {
    // Band of frequence value
    float bandValue = fft.getBand(i);//amplitude of certain band of frequency
    //println("band value: " + bandValue); //0-15
    
    //La couleur est représentée ainsi: rouge pour les basses, vert pour les sons moyens et bleu pour les hautes. 
    //L'opacité est déterminée par le volume de la bande et le volume global.
    spheres[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
  
  // Triangles for the hi frequencies
  for(int i = 0; i < nbTriangles; i++)
  {
    // Band of frequence value
    float bandValue = fft.getBand(i);//amplitude of certain band of frequency
    //println("band value: " + bandValue); //0-15
    
    //La couleur est représentée ainsi: rouge pour les basses, vert pour les sons moyens et bleu pour les hautes. 
    //L'opacité est déterminée par le volume de la bande et le volume global.
    triangles[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
  
  //Murs lignes, ici il faut garder la valeur de la bande précédent et la suivante pour les connecter ensemble
  float previousBandValue = fft.getBand(0);
  
  //Distance entre chaque point de ligne, négatif car sur la dimension z
  float dist = -25;
  
  // Multiplier for diagonal lines (the higher the value, the bigger the arrows at the edges become)
  // We can use energy or loudness to increse/decrease it
  
  // The final value should be between 1 and 8 to be nice.
  //float heightMult = spotifySongData.get("energy")*8.0;
  float heightMult = 5;
  
  //Pour chaque bande
  for(int i = 1; i < fft.specSize(); i++)
  {
    // The value of the frequency band, the farther bands are multiplied so that they are more visible.
    float bandValue = fft.getBand(i)*(1 + (i/50));
    
    //Selection de la couleur en fonction des forces des différents types de sons
    stroke(100+scoreLow, 100+scoreMid, 100+scoreHi, 155-i);
    strokeWeight(.8 + (scoreGlobal/100));
    
    //diagonal line, left, lower
    
    //diagonal line, left, lower
    line(0, height-(previousBandValue*heightMult), dist*(i-1), 0, height-(bandValue*heightMult), dist*i); // upper
    line((previousBandValue*heightMult), height, dist*(i-1), (bandValue*heightMult), height, dist*i); // lower
    line(0, height-(previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), height, dist*i); // central
    
    //diagonal line, left, higher
    line(0, (previousBandValue*heightMult), dist*(i-1), 0, (bandValue*heightMult), dist*i);
    line((previousBandValue*heightMult), 0, dist*(i-1), (bandValue*heightMult), 0, dist*i);
    line(0, (previousBandValue*heightMult), dist*(i-1), (bandValue*heightMult), 0, dist*i);
    
    //diagonal line, right, lower
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width, height-(bandValue*heightMult), dist*i);
    line(width-(previousBandValue*heightMult), height, dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), height, dist*i);
    
    //diagonal line, left, higher
    line(width, (previousBandValue*heightMult), dist*(i-1), width, (bandValue*heightMult), dist*i);
    line(width-(previousBandValue*heightMult), 0, dist*(i-1), width-(bandValue*heightMult), 0, dist*i);
    line(width, (previousBandValue*heightMult), dist*(i-1), width-(bandValue*heightMult), 0, dist*i);
    
    previousBandValue = bandValue;
  }
  
  //Walls rectangles
  for(int i = 0; i < nbMurs; i++)
  {
    // Each wall is assigned a band, and its amplitude is sent to it.
    float intensity = fft.getBand(i%((int)(fft.specSize()*specHi)));
    
    murs[i].display(scoreLow, scoreMid, scoreHi, intensity, scoreGlobal);
  }
}


//Classe pour afficher les lignes sur les cotés
class Mur {
  //Position minimale et maximale Z
  float startingZ = -6000;
  float maxZ = 50;
  
  //Valeurs de position
  float x, y, z;
  float sizeX, sizeY;
  
  //Constructeur
  Mur(float x, float y, float sizeX, float sizeY) {
    //Faire apparaitre la ligne à l'endroit spécifié
    this.x = x;
    this.y = y;
    //Profondeur aléatoire
    this.z = random(startingZ, maxZ);  
    
    //On détermine la taille car les murs au planchers ont une taille différente que ceux sur les côtés
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  
  //======= WALL COLORS ==========
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    //Couleur déterminée par les sons bas, moyens et élevé
    //Opacité déterminé par le volume global
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, scoreGlobal);
    
    // Make the lines disappear in the distance to give an illusion of fog
    // fill(displayColor, ((scoreGlobal-5)/1000)*(255+(z/25)));
    fill(displayColor);
    noStroke();
    
    // Première bande, celle qui bouge en fonction de la force
    // Matrice de transformation
    
    // https://processing.org/reference/pushMatrix_.html
    
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Agrandissement
    if (intensity > 100) intensity = 100;
    scale(sizeX*(intensity/100), sizeY*(intensity/100), 5);
    
    //Création de la "boite"
    box(1);
    popMatrix();
    
    //Deuxième bande, celle qui est toujours de la même taille
    displayColor = color(scoreLow*0.5, scoreMid*0.5, scoreHi*0.5, scoreGlobal);
    fill(displayColor, (scoreGlobal/5000)*(255+(z/25)));
    //Matrice de transformation
    pushMatrix();
    
    //Déplacement
    translate(x, y, z);
    
    //Agrandissement
    scale(sizeX, sizeY, 10);
    
    //Création de la "boite"
    box(1);
    popMatrix();
    
    //Déplacement Z
    z+= (pow((scoreGlobal/150), 2));
    if (z >= maxZ) {
      z = startingZ;  
    }
  }
}