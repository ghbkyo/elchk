import { useEffect, useState } from "react";
import { BrowserRouter, useLocation } from "react-router-dom";
import { Routess } from "./routes/routes";

import AOS from "aos";
import "bootstrap/dist/css/bootstrap.css";
import "devextreme/dist/css/dx.light.css";
// Themes
//  For Default import Theme.scss
import "./assets/scss/theme.scss";
// import default style for rsuite
import "rsuite/dist/rsuite.min.css";

import "primereact/resources/themes/lara-light-indigo/theme.css"; //theme
import "primereact/resources/primereact.min.css"; //core css
import "primeicons/primeicons.css"; //icons

import MemberContext from "./utils/MemberContext";
import CenterContext from "./utils/CenterContext";
import { CustomProvider } from "rsuite";
import { zhTW } from "rsuite/esm/locales";
import { Toaster } from "react-hot-toast";
import "./App.css";

function App() {
  const [center, setCenter] = useState(
    sessionStorage.getItem("center") &&
      JSON.parse(sessionStorage.getItem("center"))
  );
  const [member, setMember] = useState(
    sessionStorage.getItem("member") &&
      JSON.parse(sessionStorage.getItem("member"))
  );

  const syncSessionStorageForNewTab = () => {
    // https://stackoverflow.com/a/32766809
    // transfers sessionStorage from one tab to another
    var sessionStorage_transfer = function (event) {
      if (!event) {
        event = window.event;
      } // ie suq
      if (!event.newValue) return; // do nothing if no value to work with
      if (event.key == "getSessionStorage") {
        // another tab asked for the sessionStorage -> send it
        localStorage.setItem("sessionStorage", JSON.stringify(sessionStorage));
        // the other tab should now have it, so we're done with it.
        localStorage.removeItem("sessionStorage"); // <- could do short timeout as well.
      } else if (event.key == "sessionStorage" && !sessionStorage.length) {
        // another tab sent data <- get it
        var data = JSON.parse(event.newValue);
        for (var key in data) {
          sessionStorage.setItem(key, data[key]);
        }
      }
    };

    // listen for changes to localStorage
    if (window.addEventListener) {
      window.addEventListener("storage", sessionStorage_transfer, false);
    } else {
      window.attachEvent("onstorage", sessionStorage_transfer);
    }

    // Ask other tabs for session storage (this is ONLY to trigger event)
    if (!sessionStorage.length) {
      localStorage.setItem("getSessionStorage", "foobar");
      localStorage.removeItem("getSessionStorage", "foobar");
    }
  };

  const refreshSessionVar = () => {
    setTimeout(() => {
      !member && setMember(JSON.parse(sessionStorage.getItem("member")));
      !center && setCenter(JSON.parse(sessionStorage.getItem("center")));
    }, 2000);
  };

  // enable below two functions to share sessionStorage between tabs
  // syncSessionStorageForNewTab()
  // refreshSessionVar();

  useEffect(() => {
    AOS.init({
      duration: 1000,
    });

    if (!center && sessionStorage.getItem("center")) {
      setCenter(JSON.parse(sessionStorage.getItem("center")));
    }
    if (!member && sessionStorage.getItem("member")) {
      setMember(JSON.parse(sessionStorage.getItem("member")));
    }
  }, []);

  const changeCenter = (ctr) => {
    setCenter(ctr);
  };

  const changeMember = (mbr) => {
    setMember(mbr);
  };

  return (
    <CustomProvider locale={zhTW}>
      <MemberContext.Provider value={{ member, changeMember }}>
        <CenterContext.Provider value={{ center, changeCenter }}>
          <BrowserRouter children={Routess} basename={"/"} />
          <Toaster
            position="top-right"
            toastOptions={{
              className: "react-hot-toast",
              style: {
                padding: "10px",
                fontSize: "20px",
              },
            }}
          ></Toaster>
        </CenterContext.Provider>
      </MemberContext.Provider>
    </CustomProvider>
  );
}


export default App;
