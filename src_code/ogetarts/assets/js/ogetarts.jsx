import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';
import '../css/app.css';
import $ from 'jquery';

export default function game_init(root) {
  ReactDOM.render(<Ogetarts />, root);
}

class Ogetarts extends React.Component {
  constructor(props) {
    super(props);
    // this.channel = props.channel;
    this.state = {
      nums: [5],
    };

    // this.channel.join()
    //             .receive("ok", this.onJoin.bind(this))
    //             .receive("error", resp => {console.log(resp);});
  }

  // onJoin({game}) {
  //   this.setState(game);
  // }
  render() {
    return (
      <div>
       <p>5</p>
      </div>
    );
  }
}

function GetArray() {
  return <p>5</p>;
}
