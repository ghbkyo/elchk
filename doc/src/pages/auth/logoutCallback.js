import React from "react";
import { logoutRedirect } from "../../services/AuthService";

const LogoutCallbackPage = () => {
    logoutRedirect()
    window.location.replace(process.env.REACT_APP_URL)
    
    return <></>
  }
  
  export default LogoutCallbackPage
