import React from 'react';
import Navbar from './components/Navbar';
import Button from './components/Button';
import './App.css';

class Home extends React.Component {
  render() {
    return (
      <div>
        <Navbar/>
        <h1>Programer, Designer, Kid</h1>
        <Button/>
        <p className="footer">© 2019-2020 Shane-Games</p>
      </div>
    );
  }
}

export default Home;
