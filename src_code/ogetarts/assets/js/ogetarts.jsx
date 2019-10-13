import _ from 'lodash';
import '../css/app.css';
import $ from 'jquery';
import React, { Component } from 'react';
import ReactDOM, { render } from 'react-dom';
import { Stage, Layer, Text, Rect } from 'react-konva';
import Konva from 'konva';


export default function game_init(root, channel) {
  ReactDOM.render(<Ogetarts channel={channel}/>, root);
}

class Ogetarts extends React.Component {
  constructor(props) {
    super(props);

    this.channel = props.channel;
    this.state = {
        WIDTH: 1000,
        HEIGHT: 1000,
        X1: 200,
        Y1: 200,
        // BOARDWIDTH: 800,
        // padding: BOARDWIDTH/10,
    };

    this.channel.join()
                .receive("ok", this.onJoin.bind(this))
                .receive("error", resp => {console.log(resp);});
  }

  onJoin({game}) {
    this.setState(game);
  }

  onUpdate({game}) {
    this.setState(game);
  }


  render() {
    return (
        <div>
            <GameBoard />
        </div>
        );
    }
}

function GameBoard(props) {
    var stage = new Konva.Stage( {
        container: 'container',
        width: 1000,
        height: 1000,
    });

    var layer = new Konva.Layer();

    var circle = new Konva.Circle({
        x: stage.width() / 2,
        y: stage.height() / 2,
        radius: 70,
        fill: 'red',
        stroke: 'black',
        strokeWidth: 4
    });

    layer.add(circle);
    stage.add(layer);
    layer.draw();
    stage.draw();
}






      // <Stage width={window.innerWidth} height={window.innerHeight}>
      //   <Layer>
      //     <Text text="Try to drag a star" />
      //     {[...Array(10)].map((_, i) => (
      //       <Star
      //         key={i}
      //         x={Math.random() * window.innerWidth}
      //         y={Math.random() * window.innerHeight}
      //         numPoints={5}
      //         innerRadius={20}
      //         outerRadius={40}
      //         fill="#89b717"
      //         opacity={0.8}
      //         draggable
      //         rotation={Math.random() * 180}
      //         shadowColor="black"
      //         shadowBlur={10}
      //         shadowOpacity={0.6}
      //         onDragStart={this.handleDragStart}
      //         onDragEnd={this.handleDragEnd}
      //       />
      //     ))}
      //   </Layer>
      // </Stage>







// function Change(props) {
//   let {root} = props;
//   return (<button onClick={() => root.changeState()}>Change</button>);
// }









// let val = this.state.skel
// return (
//   <div>
//     <div>
//     {val}
//     </div>
//     <div>
//     <Change root={this}/>
//     </div>
//   </div>

  // changeState() {
  //   if (this.state.skel == 5) {
  //     let state1 = _.assign({}, this.state, {skel: 2});
  //     this.setState(state1);
  //   }
  //   else {
  //     let state1 = _.assign({}, this.state, {skel: 5});
  //     this.setState(state1);
  //   };
  // }
