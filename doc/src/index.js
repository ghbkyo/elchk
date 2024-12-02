import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();


document.addEventListener('DOMContentLoaded', function () {
  setTimeout(function () {
    adjustFontSize();
  }, 1000); //await

  let previousUrl = window.location.href;

  document.addEventListener('click', function (event) {
    setTimeout(function () {
      adjustFontSize();
      console.log('click');
    }, 500); //await
    /* changeboxcss */
    const changesizecheckbox = document.getElementById('changesizecheckbox');
    const changesizebtn = document.querySelector('.changesizebtn')
      if(changesizecheckbox.checked){
        if (event.target !== changesizecheckbox || event.target == changesizebtn) {
            changesizecheckbox.checked = false;
        }
      }else{
        if (event.target == changesizebtn) {
          changesizecheckbox.checked = true;
      }
      }

    /* changeSize btn */
    const fontsizebuttons = document.querySelectorAll('.fontsizebuttons');

    fontsizebuttons.forEach(button => {
      button.addEventListener('click', function () {
        setTimeout(() => {
          let size = this.getAttribute('data-size');
          localStorage.size = size;
          document.body.style.setProperty("--size", localStorage.size);
          console.log('size', localStorage.size);
        }, 500); //await
      });
    });

    const currentUrl = window.location.href;

    if (currentUrl !== previousUrl) {
      setTimeout(function () {
        adjustFontSize();
      }, 1000); //await
    }
    previousUrl = currentUrl;
  });

});

/* adjustSize */
function adjustFontSize() {
  const textNodes = getTextNodes(document.body);
  document.body.style.setProperty("--size", localStorage.size);
  textNodes.forEach(node => {
    const orignFontSize = parseInt(window.getComputedStyle(node.parentNode).fontSize);
    if (node.parentNode.style.getPropertyValue("--sorignFontSize") == '') {
      node.parentNode.style.setProperty("--sorignFontSize", orignFontSize + "px");
      node.parentNode.style.fontSize = `calc(var(--sorignFontSize) * var(--size))`;
    }
  });
}
/* getnodes */
function getTextNodes(node) {
  let textNodes = [];
  if (node.nodeType === Node.TEXT_NODE) {
    textNodes.push(node);
  } else {
    const children = node.childNodes;
    if (children) {
      for (let i = 0; i < children.length; i++) {
        textNodes = textNodes.concat(getTextNodes(children[i]));
      }
    }
  }
  return textNodes;
}
