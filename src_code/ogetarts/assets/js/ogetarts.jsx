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
        board: [],
        last_click: [],
        p1_piece_count: 33,
        p2_piece_count: 33,
        flag_found: false,
        last_message: "",
    };

    this.channel.join()
                .receive("ok", this.onJoin.bind(this))
                .receive("error", resp => {console.log(resp);});

    this.channel.on("new message", payload => {
      console.log("made it here")
      let state1 = _.assign({}, this.state, {last_message: payload.message})
      console.log(state1)
      console.log(payload.message)
      this.setState(state1)
    })
  }

  onJoin({game}) {
    this.setState(game);
  }

  onUpdate({game}) {
    this.setState(game);
    this.gameOver();
  }

  updateChat({game}) {
    // let state1 = _.assign({}, this.state, {last_message: message})
    this.setState(game)
  }

  gameOver(game) {
    if (this.state.flag_found || this.state.p1PieceCount == 0 || this.state.p2PieceCount == 0) {
      alert("Game Over!")


          this.channel.push("reset").
          receive("ok", this.onUpdate.bind(this));
      ;
  }
}


  clicked(key) {
      this.channel.push("click", {i: key[0], j: key[1]})
      .receive("ok", this.onUpdate.bind(this));
  }

  // https://www.youtube.com/watch?v=e5jlIejl9Fs
  sendChatMessage(event) {
    console.log(event.key);
    if (event.key === "Enter") {
      this.channel.push("chat", {message: event.target.value})
      // .receive("ok", this.updateChat.bind(this));
    }
  }

  render() {
    return (
      <div>
        <Stage width={1000} height={1000}>
          <Layer>
              <GameBoard />
              <GamePieces root={this}/>
              <Ranks root={this}/>
          </Layer>
        </Stage>
        <p>{this.state.last_message}</p>
        <Chat root={this} />
      </div>
    );
  
  }
}

function Chat(props) {
  let {root} = props;
  console.log(root.state.last_message)
  return (
    <div>
      <p id="chat">{root.last_message}</p> 
      <input id="chatInput" type="text" onKeyDown={(e) => root.sendChatMessage(e)}></input>
    </div>
  )};


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
            stroke="#2B043D"
            strokeWidth={2}
          />,
          <Line key={i+20}
                points={[100, 100 + Math.round(i*padding),
                        400, 100 + Math.round(i*padding)]}
                stroke="#2B043D"
                strokeWidth={2} />]);
  });
  return grid;
}

// This is needed to check if two arrays
// are equal because Javascript blows and can't do it by itself
function checkArrays(arrayA, arrayB) {
  for (let i = 0; i < arrayA.length; i++) {
    if (arrayA[i] != arrayB[i]) {
      return false
    }
  }
  return true
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

            // piece highlight.
            if (piece.length != 0 &&
              checkArrays(piece, root.state.last_click)) {

              return ([<Rect
                  key={i,j}
                  onClick = {() => root.clicked([i,j])}
                  width={pieceSize}
                  height={pieceSize}
                  stroke="#2B043D"
                  x={x + Math.round(j*padding)}
                  y={y + Math.round(i*padding)}
                  fill="#E30094" />]);
            }

            if (player === 2) {
              return ([<Rect
                  key={i,j}
                  onClick = {() => root.clicked([i,j])}
                  width={pieceSize}
                  height={pieceSize}
                  stroke="#2B043D"
                  x={x + Math.round(j*padding)}
                  y={y + Math.round(i*padding)}
                  fill="#246B61" />]);
            }
            else if (player === 1){
                return ([<Rect
                    key={i,j}
                    onClick = {() => root.clicked([i,j])}
                    width={pieceSize}
                    height={pieceSize}
                    stroke="#2B043D"
                    x={x + Math.round(j*padding)}
                    y={y + Math.round(i*padding)}
                    fill="#AA3939" />]);
            }
            else {
                return ([<Rect
                    key={i,j}
                    onClick = {() => root.clicked([i,j])}
                    width={pieceSize}
                    height={pieceSize}
                    stroke="#2B043D"
                    x={x + Math.round(j*padding)}
                    y={y + Math.round(i*padding)}
                    fill="white" />]);
            }
        });
    });
    return pieces;
}

// This puts ranks over the squares
function Ranks(props) {
  let {root} = props;
  let padding = 30;
  let pieceSize = 30;
  let x = 100;
  let y = 100;


  let ranks = _.map(root.state.board, (row, i) => {

       return _.map(row, (piece,j) => {
          let rank = piece[1]

          if (rank) {
            return (
              [<Text
                key={i,j}
                text={rank}
                fill="white"
                fontFamily="Georgia"
                fontSize={16}
                listening={false}
                x={x + Math.round(j*padding) + pieceSize/4}
                y={y + Math.round(i*padding) + pieceSize/4}
              />]);
          }
      });
  });
  return ranks;
}
