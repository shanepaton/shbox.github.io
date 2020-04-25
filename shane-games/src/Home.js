import React from 'react';
import Navbar from './components/Navbar';
import Footer from './components/Footer';
import Button from './components/Button';
import './App.css';

class Home extends React.Component {
  render() {
    return (
      <div>
        <Navbar/>
        <div className="center">
          <h1>Programer, Designer, Kid</h1>
          <Button/>
        </div>
        <Footer/>
      </div>
    );
  }
}

export default Home;
