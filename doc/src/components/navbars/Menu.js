import { Nav, Dropdown, Row, Col } from "react-bootstrap";
import { NavLink, Link, useLocation } from "react-router-dom";
import FeatherIcon from "feather-icons-react";
import classNames from "classnames";

const Menu = ({ navClass, buttonClass, showDownload, loggedInUser }) => {
  let location = useLocation();

  const isActiveRoute = (path) => {
    if (location.pathname) {
      return location.pathname.includes(path);
    }
    return false;
  };

  return (
    <Nav as="ul" className={classNames("align-items-lg-center", navClass)}>
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
          to="/program"
          end
          className={classNames(
            "nav-link",
            ({ ...isActive }) => isActive && "active"
          )}
        >
          活動搜尋
        </NavLink>
      </Nav.Item>
      <Nav.Item as="li">
        <NavLink
          to="/program"
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
          to="/program"
          end
          className={classNames(
            "nav-link",
            ({ ...isActive }) => isActive && "active"
          )}
        >
          聯絡我們
        </NavLink>
      </Nav.Item>
      <Dropdown as={"li"} className="nav-item">
        <Dropdown.Toggle
          as={Nav.Link}
          id="navbarDocs"
          className={classNames(
            isActiveRoute("/docs/introduction") ||
              isActiveRoute("/docs/bootstrap") ||
              isActiveRoute("/docs/change-log")
              ? "active"
              : ""
          )}
        >
          帳戶{" "}
          <FeatherIcon
            icon="chevron-down"
            className="d-inline-block icon icon-xxs ms-1 mt-lg-0 mt-1"
          />
        </Dropdown.Toggle>

        <Dropdown.Menu renderOnMount>
          <Nav as={"ul"} navbar={false}>
            <Nav.Item as="li">
              <NavLink
                to="/other/account/settings"
                end
                className={classNames(
                  "nav-link",
                  ({ ...isActive }) => isActive && "active"
                )}
              >
                個人資料
              </NavLink>
            </Nav.Item>
            <Nav.Item as="li">
              <NavLink
                to="/other/account/home"
                end
                className={classNames(
                  "nav-link",
                  ({ ...isActive }) => isActive && "active"
                )}
              >
                轉換中心
              </NavLink>
            </Nav.Item>
            <Nav.Item as="li">
              <hr className="my-2" />
            </Nav.Item>
          </Nav>
        </Dropdown.Menu>
      </Dropdown>
      
      {loggedInUser ? (
        <Nav.Item as="li">
          <NavLink to="/logout" className="nav-link btn me-2 shadow-none">
            登出
          </NavLink>
        </Nav.Item>
      ) : (
        <Nav.Item as="li">
          <NavLink to="/login" className="nav-link btn me-2 shadow-none">
            登入
          </NavLink>
        </Nav.Item>
      )}
      {showDownload && (
        <>
          <Nav.Item as="li">
            <Link to="#" className={classNames("btn", buttonClass)}>
              Download
            </Link>
          </Nav.Item>
        </>
      )}
    </Nav>
  );
};

export default Menu;
