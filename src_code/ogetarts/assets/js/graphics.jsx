import React, { Component } from 'react';
import ReactDOM, { Render } from 'react-dom';

import Konva from 'konva';
import { Stage, Layer, Text, Rect } from 'react-konva';



export default class Graphics extends React.Component {

    var stage = new Konva.Stage({
        container: "board",
        width: 600,
        height: 600
    });

    var layer = new Konva.Layer();
    stage.add(layer);



    function makeRectange(x, y, stage) {
        let rectangle = new Konva.Rect( {
            x: x,
            y: y,
            width: 60,
            height: 60
        });
    }




    render() {

    }

}




let WIDTH = 1000;
let HEIGHT = 1000;
let X1 = 200;
let Y1 = 200;
let BOARDWIDTH = 800;
var padding = BOARDWIDTH/10;

 var stage = new Konva.Stage({
          container: 'container',
          width: WIDTH,
          height: HEIGHT
      });

//vertical
var gridLayer = new Konva.Layer();
for(var i = 0; i <= 10; i++) {
    gridLayer.add(new Konva.Line({
    points: [Math.round(i*padding) + X1, Y1, Math.round(i*padding) + X1, Y1 + (10 * padding)],
    stroke: '#000000',
    strokeWidth: 2,
  }));
}

//horizontal
for(var i = 0; i <= 10; i++) {
    gridLayer.add(new Konva.Line({
    points: [X1,  Math.round(i*padding) + Y1,  X1 + (10 * padding), Math.round(i*padding) + Y1],
    stroke: '#000000',
    strokeWidth: 2,
  }));
}

stage.add(gridLayer);
