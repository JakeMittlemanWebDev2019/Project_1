import _ from 'lodash';
import '../css/app.css';
import $ from 'jquery';
import React from 'react';
import ReactDOM from 'react-dom';
import Konva from 'konva';
import { Stage, Layer, Text, Rect } from 'react-konva';


export default function game_init(root, channel) {
  ReactDOM.render(<Ogetarts channel={channel}/>, root);
}

let WIDTH = window.innerWidth;
let HEIGHT = window.innerHeight;
let X1 = WIDTH/10;
let Y1 = HEIGHT/10;
let BOARDWIDTH = WIDTH/2;


class Ogetarts extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = {
      board: [
          {x: 60, y: 60}
      ]
      }
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
      var stage = new Konva.Stage({
          container: "board",
          width: BOARDWIDTH,
          height: 600
      });
  }
}

function Change(props) {
  let {root} = props;
  return (<button onClick={() => root.changeState()}>Change</button>);
}









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
