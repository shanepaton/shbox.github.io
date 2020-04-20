import React from 'react';
import {Link} from 'react-router-dom';
import '../App.css';

export default class Navbar extends React.Component {
  render() {
    return (
      <div className="navbar">
        <ul>
          <img src={'../logo.svg'} alt="shane-games"></img>
          <li><Link to="/">Home</Link></li>
          <li><Link to="about/">About</Link></li>
        </ul>
      </div>
    );
  }
}
