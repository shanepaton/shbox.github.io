import React from 'react';
import '../App.css';
import 'font-awesome/css/font-awesome.min.css'; 

export default class Footer extends React.Component {
  render() {
    return (
        <footer>
            <div className="footer">
                <p className="cpr">© 2019-2020 Shane-Games</p>
                <a href="https://github.com/shane-games" className="fa fa-github fa-2x"> </a>
                <a href="https://twitter.com/ShaneGamesDev" className="fa fa-twitter fa-2x"> </a>
                <a href="https://www.reddit.com/user/shanepaton" className="fa fa-reddit fa-2x"> </a>
                <a href="mailto:spaton08@gmail.com" className="fa fa-envelope fa-2x"> </a>
            </div>
        </footer>
    );
  }
}
