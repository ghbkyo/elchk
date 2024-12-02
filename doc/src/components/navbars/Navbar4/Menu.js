import { Nav } from "react-bootstrap";
import { NavLink } from "react-router-dom";
import classNames from "classnames";
import { profileOptions } from "./data";

const Menu = ({ navClass, buttonClass }) => {
  return (
    <Nav as="ul" className={classNames('align-items-end', 'fs-3', navClass)}>
      <Nav.Item as="li">
        <NavLink
          to="/home"
          end
          className={classNames(
            "nav-link",
            ({ ...isActive }) => isActive && "active"
          )}
        >
          主頁
        </NavLink>
      </Nav.Item>
      <Nav.Item as="li">
        <NavLink
          to="/about"
          end
          className={classNames(
            "nav-link",
            ({ ...isActive }) => isActive && "active"
          )}
        >
          關於我們
        </NavLink>
      </Nav.Item>
      <Nav.Item as="li">
        <NavLink
          to={profileOptions[0]['redirectTo']}
          end
          className={classNames(
            "nav-link",
            ({ ...isActive }) => isActive && "active"
          )}
        >
          用戶資料
        </NavLink>
      </Nav.Item>
      <Nav.Item as="li">
        <NavLink
          to="/other/account/bookmark"
          end
          className={classNames(
            "nav-link",
            ({ ...isActive }) => isActive && "active"
          )}
        >
          我的收藏
        </NavLink>
      </Nav.Item>
      <Nav.Item as="li">
        <NavLink
          to="/other/account/programEnrollment"
          end
          className={classNames(
            "nav-link",
            ({ ...isActive }) => isActive && "active"
          )}
        >
          我的活動
        </NavLink>
      </Nav.Item>
      <Nav.Item as="li">
        <NavLink
          to="/other/account/centerInfo"
          end
          className={classNames(
            "nav-link",
            ({ ...isActive }) => isActive && "active"
          )}
        >
          我的通知
        </NavLink>
      </Nav.Item>
    </Nav>
  );
};

export default Menu;
