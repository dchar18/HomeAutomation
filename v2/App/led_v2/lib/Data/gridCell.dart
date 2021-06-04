import 'package:flutter/material.dart';
import 'package:led_v2/Data/devices.dart';

class GridCell {
  var selected;
  var row;
  var col;
  var red;
  var green;
  var blue;

  GridCell(int row, int col) {
    this.selected = true;
    this.row = row;
    this.col = col;
    this.red = 0;
    this.green = 0;
    this.blue = 0;
  }

  void setSelected(bool s) {
    this.selected = s;
  }

  bool getSelected() {
    return this.selected;
  }

  getCoordinates() {
    return [this.row, this.col];
  }

  void setRed(int r) {
    this.red = r;
  }

  void setGreen(int g) {
    this.green = g;
  }

  void setBlue(int b) {
    this.blue = b;
  }

  void setRGB(int r, int g, int b) {
    this.red = r;
    this.green = g;
    this.blue = b;
  }

  List<int> getRGB() {
    return [this.red, this.green, this.blue];
  }

  int getRed() {
    return this.red;
  }

  int getGreen() {
    return this.green;
  }

  int getBlue() {
    return this.blue;
  }
}

List<GridCell> generateGrid() {
  List<GridCell> cell = [];
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 10; c++) {
      cell.add(new GridCell(r, c));
    }
  }
  return cell;
}

void markRow(List<GridCell> grid, Device d) {
  // if the column was not selected yet
  if (d.getCell()[1] == -1) {
    // row was reset (both row and col = -1)
    if (d.getCell()[0] == -1) {
      // select all the cells
      grid.forEach((element) {
        element.selected = true;
      });
    } else {
      // iterate through all GridCell objects
      grid.forEach((element) {
        // if the chosen row is the same as the cell's row
        // select the entire column
        if (element.getCoordinates()[0] == d.getCell()[0]) {
          // the cells in that row are marked as selected
          element.selected = true;
        } else {
          // otherwise, it is unselected
          element.selected = false;
        }
      });
    }
  }
  // the row was reset but col is still set
  else if (d.getCell()[0] == -1) {
    // iterate through all GridCell objects
    grid.forEach((element) {
      // if the chosen column is the same as the cell's column
      // select the entire column
      if (element.getCoordinates()[1] == d.getCell()[1]) {
        // the cell in that column is marked as selected
        element.selected = true;
      } else {
        // otherwise, it is unselected
        element.selected = false;
      }
    });
  }

  // otherwise, the column was already selected and the row is a valid row
  else {
    // select the individual cell
    grid.forEach((element) {
      // select the entire column
      if ((element.getCoordinates()[0] == d.getCell()[0]) &&
          (element.getCoordinates()[1] == d.getCell()[1])) {
        element.selected = true;
      } else {
        element.selected = false;
      }
    });
  }
}

void markColumn(List<GridCell> grid, Device d) {
  // if the row was not selected yet
  if (d.getCell()[0] == -1) {
    // col was reset (both row and col = -1)
    if (d.getCell()[1] == -1) {
      // select all the cells
      grid.forEach((element) {
        element.selected = true;
      });
    } else {
      // iterate through all GridCell objects
      grid.forEach((element) {
        // if the chosen column is the same as the cell's column
        // select the entire column
        if (element.getCoordinates()[1] == d.getCell()[1]) {
          // the cell in that column is marked as selected
          element.selected = true;
        } else {
          // otherwise, it is unselected
          element.selected = false;
        }
      });
    }
  }
  // the column was reset but row is still set
  else if (d.getCell()[1] == -1) {
    // iterate through all GridCell objects
    grid.forEach((element) {
      // if the chosen column is the same as the cell's column
      // select the entire column
      if (element.getCoordinates()[0] == d.getCell()[0]) {
        // the cell in that column is marked as selected
        element.selected = true;
      } else {
        // otherwise, it is unselected
        element.selected = false;
      }
    });
  }
  // otherwise, the row was already selected and the column is a valid column
  else {
    // select the individual cell
    grid.forEach((element) {
      // select the entire column
      if ((element.getCoordinates()[0] == d.getCell()[0]) &&
          (element.getCoordinates()[1] == d.getCell()[1])) {
        element.selected = true;
      } else {
        element.selected = false;
      }
    });
  }
}
