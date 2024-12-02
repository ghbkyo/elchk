import { Container, Nav, Navbar, Row, Col } from "react-bootstrap";
import classNames from "classnames";
import { isLoggedIn, login, loginRedirect } from "../../../services/AuthService";
import Menu from "./Menu";
import ProfileDropdown from "./ProfileDropdown";
import MemberContext from "../../../utils/MemberContext";
import { useContext, useEffect, useState } from "react";
import { NavLink } from "react-router-dom";
import FeatherIcon from "feather-icons-react";
import Offcanvas from 'react-bootstrap/Offcanvas';

// Menu data
import { profileOptions } from "./data";

// images
import fourS_logo from "../../../assets/images/Web_ELCSS-HK Logo.png";

const hkjc_link = "https://www.charities.hkjc.com";

const Navbar4 = ({ isSticky, navClass, buttonClass, fixedWidth }) => {
  const [isLogin, setIsLogin] = useState(isLoggedIn());
  const { member } = useContext(MemberContext);

  // on scroll add navbar class
  useEffect(() => {
    const btnTop = document.getElementById("btn-back-to-top");
    const navbar = document.getElementById("sticky");
    window.addEventListener("scroll", (e) => {
      e.preventDefault();
      if (btnTop) {
        if (
          document.body.scrollTop >= 50 ||
          document.documentElement.scrollTop >= 50
        ) {
          btnTop.classList.add("show");
        } else {
          btnTop.classList.remove("show");
        }
      }
      if (navbar) {
        if (
          document.body.scrollTop >= 240 ||
          document.documentElement.scrollTop >= 240
        ) {
          navbar.classList.add("navbar-sticky");
        } else {
          navbar.classList.remove("navbar-sticky");
        }
      }
    });

    setIsLogin(isLoggedIn());
  }, []);

  useEffect(() => {
    setIsLogin(isLoggedIn());
  }, [member]);

  const handleLogin = () => {
    login();
  };

  return (
    <header className="border-bottom">
      <div className="topbar px-2 d-none d-sm-flex flex-row justify-content-end">
        <div></div>
        <div className="links d-flex flex-row align-items-center">
          <div class="changesizebox">
            <input class="d-none" id="changesizecheckbox" type="checkbox"></input>
            <a href="javascript:;" className="changesizebtn">文字大小</a>
            <div class="changesizelist">
              <button data-size="1" class="fontsizebuttons fontsizebuttonssm">A-</button>
              <button data-size="1.1" class="fontsizebuttons fontsizebuttonsmd">A</button>
              <button data-size="1.2" class="fontsizebuttons fontsizebuttonslg">A+</button>
            </div>
          </div>
          <div>
            {!!isLogin ? (
              <Nav as="ul" className="align-items-lg-center">
                <ProfileDropdown profileOptions={profileOptions} />
              </Nav>
            ) : (
              <a href="javascript:;" onClick={handleLogin}>登入 <FeatherIcon icon='log-out' size="22" /></a>
            )}
          </div>
        </div>
      </div>
      <Navbar
        id={isSticky ? "sticky" : ""}
        collapseOnSelect
        expand="lg"
        className={classNames("topnav-menu", navClass)}
      >
        <div fluid={!fixedWidth} className="d-flex w-100 px-4 align-items-center justify-content-between">
          <Navbar.Brand className="logo me-0">
            <NavLink to="/home">
              <img
                src={fourS_logo}
                className="align-top logo-dark top-menu-logo-lg mt-0"
                alt=""
              />
            </NavLink>
          </Navbar.Brand>

          <Navbar.Toggle
            className=""
            aria-controls="topnav-menu-content4"
          />

          <Navbar.Offcanvas id="topnav-menu-content4" placement="end">
            <Offcanvas.Header closeButton className="justify-content-end py-4 pe-4" />
            <Offcanvas.Body>
              <Menu
                navClass="ms-auto"
                buttonClass={buttonClass ? buttonClass : "btn-primary"}
              />
            </Offcanvas.Body>
          </Navbar.Offcanvas>
        </div>
      </Navbar>
    </header>
  );
};

export default Navbar4;
