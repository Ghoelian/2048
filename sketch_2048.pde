import java.lang.Integer;

int gridWidth = 4;
int gridHeight = 4;
Tile[][] grid = new Tile[gridWidth][gridHeight];
int gridSize;

HashMap<Integer, Colour> colours = new HashMap<Integer, Colour>();

boolean gameOver = false;
boolean won = false;

int score = 2048;

PFont roboto;

void setup() {
  roboto = createFont("Roboto-Regular.ttf", 48);

  size(640, 640);

  colours.put(2, new Colour(238, 228, 218));
  colours.put(4, new Colour(237, 224, 200));
  colours.put(8, new Colour(242, 177, 121));
  colours.put(16, new Colour(245, 149, 99));
  colours.put(32, new Colour(246, 124, 95));
  colours.put(64, new Colour(246, 94, 59));
  colours.put(128, new Colour(237, 207, 114));
  colours.put(256, new Colour(237, 204, 97));
  colours.put(512, new Colour(237, 200, 80));
  colours.put(1024, new Colour(237, 197, 63));
  colours.put(2048, new Colour(237, 194, 46));

  gridSize = width / grid.length;

  for (int i = 0; i < gridWidth; i++) {
    for (int j = 0; j < gridHeight; j++) {
      grid[i][j] = new Tile();
    }
  }

  randomTile();
  stroke(187, 173, 160);
  strokeWeight(15);
}

void draw() {
  if (won || gameOver) {
    fill(255, 255, 255, 255 * 0.33);
    stroke(115, 106, 98);
    rectMode(CENTER);
    rect(width/2, height/2, 300, 150, 30);

    fill(0);
    textAlign(CENTER, CENTER);
    if (won) {
      text("You won!", (width/2), (height/2) - 35);
    } else if (gameOver) {
      text("Game over", (width/2), (height/2) - 35);
    }

    text("Score: ", (width/2) - 30, (height/2) + 25);
    textAlign(LEFT, CENTER);
    text(score, (width/2) + 30, (height/2) + 25);

    noLoop();
  } else {
    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        grid[i][j].merged = false;
      }
    }

    for (int i = 0; i < gridWidth; i++) {
      for (int j = 0; j < gridHeight; j++) {
        Colour colour = colours.get(grid[i][j].value);

        if (colour == null) {
          colour = new Colour(205, 192, 180);
        }

        fill(colour.r, colour.g, colour.b);
        rect(i * gridSize, j * gridSize, gridSize, gridSize, 20);

        if (grid[i][j].value > 0) {
          if (grid[i][j].value > 4) {
            fill(255);
          } else {
            fill(0);
          }
          float halfGrid = gridSize / 2;

          textAlign(CENTER, CENTER);
          textSize(40);
          text(grid[i][j].value, ((i + 1) * gridSize) - halfGrid, ((j + 1) * gridSize) - halfGrid);
        }
      }
    }
  }
}

void randomTile() {
  boolean finished = true;

  for (int i = 0; i < gridWidth; i++) {
    if (!finished) {
      break;
    }

    for (int j = 0; j < gridHeight; j++) {
      if (grid[i][j].value == 0) {
        finished = false;
        break;
      }
    }
  }

  if (!finished) {
    int x = floor(random(4));
    int y = floor(random(4));

    if (grid[x][y].value > 0) {
      randomTile();
      return;
    }

    grid[x][y].value = 2;
  } else {
    gameOver = true;
  }
}

void keyPressed() {
  switch(keyCode) {
  case 38: // UP
    moveUp();
    break;
  case 39: // RIGHT
    moveRight();
    break;
  case 40: // DOWN
    moveDown();
    break;
  case 37: // LEFT
    moveLeft();
    break;
  }

  randomTile();
}

void moveUp() {
  for (int x = 0; x < gridWidth; x++) {
    for (int y = 0; y < gridHeight; y++) {
      for (int i = y; i > 0; i--) {
        // If tile is on the bottom row, it can't move or add to another tile
        if (y > 0) {
          if (grid[x][i - 1].value == 0) {
            grid[x][i - 1].value = grid[x][i].value;
            grid[x][i - 1].merged = grid[x][i].merged;

            grid[x][i].value = 0;
            grid[x][i].merged = false;
          } else if (!grid[x][i - 1].merged && !grid[x][i].merged && grid[x][i].value == grid[x][i - 1].value) {
            grid[x][i - 1].value += grid[x][i].value;
            grid[x][i - 1].merged = true;
            
            grid[x][i].value = 0;
            
            if (grid[x][i - 1].value > score) {
              score = grid[x][i - 1].value;

              if (grid[x][i - 1].value == 2048) {
                won = true;
              }
            }
            
            break;
          }
        }
      }
    }
  }
}

void moveDown() {
  for (int x = 0; x < gridWidth; x++) {
    for (int y = gridHeight - 1; y >= 0; y--) {
      for (int i = y; i < gridHeight - 1; i++) {
        // If tile is on the bottom row, it can't move or add to another tile
        if (y < gridHeight) {
          if (grid[x][i + 1].value == 0) {
            grid[x][i + 1].value = grid[x][i].value;
            grid[x][i + 1].merged = grid[x][i].merged;

            grid[x][i].value = 0;

            grid[x][i].merged = false;
          } else if (!grid[x][i].merged && !grid[x][i + 1].merged && grid[x][i].value == grid[x][i + 1].value) {
            grid[x][i + 1].value += grid[x][i].value;
            grid[x][i + 1].merged = true;

            grid[x][i].value = 0;

            if (grid[x][i + 1].value > score) {
              score = grid[x][i + 1].value;

              if (grid[x][i + 1].value == 2048) {
                won = true;
              }
            }
            
            break;
          }
        }
      }
    }
  }
}

void moveLeft() {
  for (int y = 0; y < gridHeight; y++) {
    for (int x = 0; x < gridWidth; x++) {
      for (int j = x; j > 0; j--) {
        // If tile is on the bottom row, it can't move or add to another tile
        if (x > 0) {
          if (grid[j - 1][y].value == 0) {
            grid[j - 1][y].value = grid[j][y].value;
            grid[j - 1][y].merged = grid[j][y].merged;

            grid[j][y].value = 0;
            grid[j][y].merged = false;
          } else if (!grid[j][y].merged && !grid[j - 1][y].merged && grid[j][y].value == grid[j - 1][y].value) {
            grid[j - 1][y].value += grid[j][y].value;
            grid[j - 1][y].merged = true;

            grid[j][y].value = 0;
            
            if (grid[j - 1][y].value > score) {
              score = grid[j - 1][y].value;

              if (grid[j - 1][y].value == 2048) {
                won = true;
              }
            }
            
            break;
          }
        }
      }
    }
  }
}

void moveRight() {
  for (int y = 0; y < gridHeight; y++) {
    for (int x = gridWidth - 1; x >= 0; x--) {
      for (int j = x; j < gridHeight - 1; j++) {
        // If tile is on the bottom row, it can't move or add to another tile
        if (x < gridHeight) {
          if (grid[j + 1][y].value == 0) {
            grid[j + 1][y].value = grid[j][y].value;
            grid[j + 1][y].merged = grid[j][y].merged;

            grid[j][y].value = 0;
            grid[j][y].merged = false;
          } else if (!grid[j][y].merged && !grid[j + 1][y].merged && grid[j][y].value == grid[j + 1][y].value) {
            grid[j + 1][y].value += grid[j][y].value;
            grid[j + 1][y].merged = true;

            grid[j][y].value = 0;
            
            if (grid[j + 1][y].value > score) {
              score = grid[j + 1][y].value;

              if (grid[j + 1][y].value == 2048) {
                won = true;
              }
            }
            break;
          }
        }
      }
    }
  }
}
