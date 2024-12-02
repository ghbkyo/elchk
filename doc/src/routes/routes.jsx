import * as React from "react";
import { Route, Routes } from "react-router-dom";
import LoginCallback from "../pages/auth/loginCallback";
import LogoutCallback from "../pages/auth/logoutCallback";
import SilentRenew from "../pages/auth/silentRenew";
import { PrivateRoute } from "./privateRoute";
import Login from "../pages/auth/Login"
import Logout from "../pages/auth/Logout";

import Home from "../pages/Home";
import Program from "../pages/Program";
import Settings from "../pages/other/account/Settings";
import ProgramDetail from "../pages/Program/ProgramDetail";
import About from './../pages/Home/About';
import Contact from './../pages/Home/Contact';
import Enquiry from './../pages/Home/Enquiry';
import UserGuide from "pages/Home/UserGuide";
import ProgramEnrollment from "pages/other/account/Settings/ProgramEnrollment";
import CenterInfo from "pages/other/account/Settings/CenterInfo";
import Bookmark from "pages/other/account/Settings/Bookmark";
import Privacy from "pages/Home/Privacy";

export const Routess = (
    <Routes>
        <Route exact={true} path="/login" element={<Login/>}/>
        <Route exact={true} path="/login-callback" element={<LoginCallback/>}/>
        <Route exact={true} path="/logout" element={<Logout/>}/>
        <Route exact={true} path="/logout-callback" element={<LogoutCallback/>}/>
        <Route exact={true} path="/silent-callback" element={<SilentRenew/>}/>
        <Route exact={true} path="/program" element={<PrivateRoute><Program/></PrivateRoute>}/>
        <Route exact={true} path="/program/detail/:id" element={<ProgramDetail/>}/>
        <Route exact={true} path="/other/account/home" element={<PrivateRoute activityKey="home"><Settings/></PrivateRoute>}/>
        <Route exact={true} path="/other/account/account" element={<PrivateRoute activityKey="account"><Settings/></PrivateRoute>}/>
        <Route exact={true} path="/other/account/familyMember" element={<PrivateRoute activityKey="familyMember"><Settings/></PrivateRoute>}/>
        <Route exact={true} path="/other/account/center" element={<PrivateRoute activityKey="center"><Settings/></PrivateRoute>}/>
        <Route exact={true} path="/other/account/programEnrollment" element={<PrivateRoute><ProgramEnrollment/></PrivateRoute>}/>
        <Route exact={true} path="/other/account/paymentHistory" element={<PrivateRoute activityKey="paymentHistory"><Settings/></PrivateRoute>}/>
        <Route exact={true} path="/other/account/password" element={<PrivateRoute activityKey="password"><Settings/></PrivateRoute>}/>
        <Route exact={true} path="/other/account/centerInfo" element={<PrivateRoute><CenterInfo/></PrivateRoute>}/>
        <Route exact={true} path="/other/account/bookmark" element={<PrivateRoute><Bookmark/></PrivateRoute>}/>
        <Route exact={true} path="/other/account/upgrade" element={<PrivateRoute activityKey="upgrade"><Settings/></PrivateRoute>}/>
        <Route exact={true} path="/other/account/volunteer" element={<PrivateRoute activityKey="volunteer"><Settings/></PrivateRoute>}/>
        <Route exact={true} path="/home" element={<Home/>} />
        <Route exact={true} path="/about" element={<About/>}/>
        <Route exact={true} path="/privacy" element={<Privacy/>}/>
        <Route exact={true} path="/contact" element={<Contact/>}/>
        <Route exact={true} path="/enquiry" element={<Enquiry/>}/>
        <Route exact={true} path="/user-guide" element={<UserGuide/>}/>
        <Route path="/" element={<Home />} />
        <Route path="*" element={<Home />} />
    </Routes>
);