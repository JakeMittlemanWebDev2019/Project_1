import React from 'react';
import ReactDOM from 'react-dom';
import _ from 'lodash';
import '../css/app.css';
import $ from 'jquery';

export default function game_init(root, channel) {
  ReactDOM.render(<Ogetarts channel={channel}/>, root);
}

class Ogetarts extends React.Component {
  constructor(props) {
    super(props);
    this.channel = props.channel;
    this.state = {
      skel: 5,
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

  changeState() {
    if (this.state.skel == 5) {
      let state1 = _.assign({}, this.state, {skel: 2});
      this.setState(state1);
    }
    else {
      let state1 = _.assign({}, this.state, {skel: 5});
      this.setState(state1);
    };
  }

  render() {
    let val = this.state.skel
    return (
      <div>
        <div>
        {val}
        </div>
        <div>
        <Change root={this}/>
        </div>
      </div>
    );
  }
}

function Change(props) {
  let {root} = props;
  return (<button onClick={() => root.changeState()}>Change</button>);
}
