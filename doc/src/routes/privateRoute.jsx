
import React from "react";
import { Navigate } from "react-router-dom";
import { isLoggedIn } from './../services/AuthService';
import Login from "../pages/auth/Login";

export const PrivateRoute = ({ children, ...props}) => {
    return isLoggedIn() ? React.cloneElement(children, {...props}) : <Login url={window.location.href} />
};
// export const PrivateRoute = ({children, ...props}) => {
//     // return isLoggedIn() ? children : <Navigate to="/login" replace />
//     return isLoggedIn() ? children : <Login url={window.location.href} />
// };

