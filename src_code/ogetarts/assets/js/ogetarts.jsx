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
        board: [[],[],[],[],[],[],[],[],[],[]]

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

  clicked(event) {
     return null;
  }


  render() {
    return (
      <Stage width={1000} height={1000}>
        <Layer>
            <GameBoard />
            <GamePieces root={this}/>
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
}

function GamePieces(props) {
    let {root} = props;
    let padding = 30;
    let pieceSize = 30;
    let nums = _.range(0,10);
    let rows = _.range(0,4);
    let x = 100;
    let y = 100;


    let pieces = _.map(root.state.board, (row, i) => {

         return _.map(row, (piece,j) => {
            let player = piece[2];

            if (player === 2) {
                return ([<Rect
                    key={i,j}
                    onClick = {() => root.clicked()}
                    width={pieceSize}
                    height={pieceSize}
                    stroke="black"
                    x={x + Math.round(j*padding)}
                    y={y + Math.round(i*padding)}
                    fill="blue" />]);
            }
            else {
                return ([<Rect
                    key={i,j}
                    onClick = {() => root.clicked()}
                    width={pieceSize}
                    height={pieceSize}
                    stroke="black"
                    x={x + Math.round(j*padding)}
                    y={y + Math.round(i*padding)}
                    fill="red" />]);
            }
        });
    });
    return pieces;
}



// function GamePieces(props) {
//     let {root} = props;
//     let padding = 30;
//     let pieceSize = 30;
//     let nums = _.range(0,10);
//     let rows = _.range(0,4);
//     let x = 100;
//     let y = 100;
//
//
//     let pieces = _.map(rows, (j) => {
//
//          return _.map(nums, (i) => {
//             return ([<Rect
//                 key={i}
//                 onClick = {() => root.clicked()}
//                 width={pieceSize}
//                 height={pieceSize}
//                 stroke="black"
//                 x={x + Math.round(i*padding)}
//                 y={y + Math.round(j*padding)}
//                 fill="blue" />]);
//         });
//     });
//     return pieces;
// }
