import _ from 'lodash';
import '../css/app.css';
import $ from 'jquery';
import React from 'react';
import ReactDOM from 'react-dom';
import { Stage, Layer, Text, Rect, Circle, Line } from 'react-konva';
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
      <Stage width={1000} height={1000}>
        <Layer>
          <GameBoard />
        </Layer>
      </Stage>
    );
  }
}

function GameBoard(props) {
  let padding = 30;
  let x = 100;
  let y = 100;
  let nums = _.range(0, 11);
  let grid = _.map(nums, (i) => {
    // returning an Array
    // [[Vertical Lines], [Horizontal Lines]]
    // This makes the grid
    // we'll need to not hard-code these values, but
    // at least it works :)
    return ([<Line
            key={i}
            points={[100 + Math.round(i*padding), 100,
                    100 + Math.round(i*padding), 400]}
            stroke="black"
            strokeWidth={2}
          />,
          <Line key={i+20}
                points={[100, 100 + Math.round(i*padding),
                        400, 100 + Math.round(i*padding)]}
                stroke="black"
                strokeWidth={2} />]);
  });
  return grid;

    // var stage = new Konva.Stage( {
    //     container: 'root',
    //     width: 1000,
    //     height: 1000,
    // });

    // var layer = new Konva.Layer();

    // var circle = new Konva.Circle({
    //     x: 1000 / 2,
    //     y: 1000 / 2,
    //     radius: 70,
    //     fill: 'red',
    //     stroke: 'black',
    //     strokeWidth: 4
    // });
    //
    // return (<Circle x={500} y={500} radius={70} fill='red' stroke='black'
    //         strokeWidth={4} />);

    // layer.add(circle);
    // stage.add(layer);
    // layer.draw();
    // stage.draw();
    // return layer;
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
