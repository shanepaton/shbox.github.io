import React from 'react';
import Navbar from './components/Navbar.jsx';
import Footer from './components/Footer.jsx';
import Button from './components/Button.jsx';
import './App.css';

class Home extends React.Component {
  render() {
    return (
      <div>
        <Navbar />
        <div className="center">
          <h1>Programer, Designer, Kid</h1>
          <Button />
        </div>
        <Footer />
      </div>
    );
  }
}

export default Home;
