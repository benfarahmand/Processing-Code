color ANT_COLOR = color(68, 0, 8);
int DIRT_R = 217;
int DIRT_G = 165;
int DIRT_B = 78;
color DIRT_COLOR = color(DIRT_R, DIRT_G, DIRT_B);
color FOOD_COLOR = color(158, 55, 17);
int HOME_R = 96;
int HOME_G = 85;
int HOME_B = 33;
//color PHER_HOME_COLOR = color(HOME_R, HOME_G, HOME_B);
int FOOD_R = 255;
int FOOD_G = 255;
int FOOD_B = 255;
//color PHER_FOOD_COLOR = color(FOOD_R, FOOD_G, FOOD_B);

Colony col;
Food food;
Map pherHome;
Map pherFood;

void setup() {
  size(800, 600, P3D);
  background(DIRT_COLOR);
  noStroke();
  //smooth();

  pherHome = new Map(width, height);
  pherFood = new Map(width, height);
  col = new Colony(100, 100, 100, pherHome, pherFood);
  food = new Food(width, height);

  // Sprinkle some crumbs around
  for (int i=0; i<10; i++) {
    food.addFood(int(random(0, width)), int(random(0,height)));
  }
}

void draw() {
  // Clear bg
  //background(DIRT_COLOR);

  // Add food
  if (mousePressed) {
    food.addFood(mouseX, mouseY);
  }

  loadPixels();
  for (int i=0; i<pherHome.length; i++) {
    color pixelColor;
    if (food.getValue(i)) {
      // Draw food
      pixelColor = FOOD_COLOR;
    } 
    else {
      // Draw pheromones
      // I found the direct math to be faster than blendColor()
      float pixelAlpha = pherHome.getPercentage(i);
      int pixel_r = int(HOME_R * pixelAlpha + DIRT_R * (1-pixelAlpha));
      int pixel_g = int(HOME_G * pixelAlpha + DIRT_G * (1-pixelAlpha));
      int pixel_b = int(HOME_B * pixelAlpha + DIRT_B * (1-pixelAlpha));
      
      pixelAlpha = pherFood.getPercentage(i);
      pixel_r = int(FOOD_R * pixelAlpha + pixel_r * (1-pixelAlpha));
      pixel_g = int(FOOD_G * pixelAlpha + pixel_g * (1-pixelAlpha));
      pixel_b = int(FOOD_B * pixelAlpha + pixel_b * (1-pixelAlpha));
      
      // Using bitwise color math instead of color() on the following line
      // upped the framerate from 43 to 58 on my computer
      //pixelColor = color(pixel_r, pixel_g, pixel_b);
      pixelColor = pixel_r << 16 | pixel_g << 8 | pixel_b;
    }
    // Set
    pixels[i] = pixelColor;
  }
  updatePixels();

  // Draw ants
  for (int i = 0; i < col.ants.length; i++) { 
    Ant thisAnt = col.ants[i];
    //if(thisAnt.id==1){
    //  println("-----------------");
    //  println("home pher: " + thisAnt.homePher);
    //  println("food pher: " + thisAnt.foodPher);
    //  println("bored: " + thisAnt.bored);
    //  stroke(color(255,0,0));
    //  ellipse(thisAnt.x,thisAnt.y,5,5);
    //  noStroke();
    //}
    thisAnt.step(); 

    int thisXi = thisAnt.intX;
    int thisYi = thisAnt.intY;
    float thisXf = thisAnt.x;
    float thisYf = thisAnt.y;

    fill(ANT_COLOR); 

    if (thisAnt.hasFood) {
      fill(FOOD_COLOR); 
      if (thisXi>col.x-10 && thisXi<col.x+10 && thisYi>col.y-10 && thisYi<col.y+10) {
        // Close enough to home
        thisAnt.hasFood = false;
        thisAnt.homePher = 100;
      }
    }
    else if(food.getValue(thisXi, thisYi)) {
      thisAnt.hasFood = true;
      thisAnt.foodPher = 100;
      food.bite(thisXi, thisYi);
    }

    if (abs(thisAnt.dx) > abs(thisAnt.dy)) {
      // Horizontal ant
      rect(thisXf,thisYf,3,2);
    } else {
      // Vertical ant
      rect(thisXf,thisYf,2,3);
    }
  }

  // Evaporate
  pherHome.step();
  pherFood.step();

  // Debug
  //println(frameRate);
  
  //draw colony
  fill(col.COLONY_COLOR);
  ellipse(col.x,col.y,col.radius,col.radius);
}
