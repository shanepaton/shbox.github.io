import React from 'react';
import '../App.css';

export default class Button extends React.Component {
        
    state = {
        title: "Click Me",
        clicks: 1
    };
    
    addVal = () => {
        this.setState({ clicks: this.state.clicks + 1, })
        this.setState({title: "Clicked " + this.state.clicks})
    }
  
    render() {

    return (
      <div>
          <button className="button" onClick={this.addVal}>{this.state.title}</button>
      </div>
    );
  }
}
