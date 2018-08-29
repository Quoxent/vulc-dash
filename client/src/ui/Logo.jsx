
const img = require('../img/whitelogo.png');
const React = require('react');

const Logo = (props) => (
  <div className="logo responsive-img">
    <img
      alt="Vulcano Home Node Dashboard"
      src={ img }
      title="Vulcano Home Node Dashboard" />
  </div>
);

module.exports = Logo;
