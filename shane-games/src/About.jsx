import React from 'react';
import Navbar from './components/Navbar.jsx';
import './App.css';

class About extends React.Component {
  render() {
    return (
      <div>
        <Navbar />
        <p className="footer">© 2019-2020 Shane-Games</p>
      </div>
    );
  }
}

export default About;
