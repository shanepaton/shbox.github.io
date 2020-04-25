import React from 'react';
import {Link} from 'react-router-dom';
import '../App.css';

export default class Navbar extends React.Component {
  render() {
    return (
      <header>
        <img src={'../logo.svg'} alt="shane-games"></img>
          <nav>
            <ul>
              <li><Link className="link" to="/">Home</Link></li>
            </ul>
            <ul>
              <li><Link className="link" to="about/">About</Link></li>
            </ul>
          </nav>
      </header>
    );
  }
}
