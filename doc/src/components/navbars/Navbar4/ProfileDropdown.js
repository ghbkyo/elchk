import React, { useEffect, useState, useContext } from "react";
import { Dropdown, Nav } from "react-bootstrap";
import FeatherIcon from "feather-icons-react";
import { getUserimgStorage } from "../../../services/AuthService";
import MemberContext from "../../../utils/MemberContext";
import CenterContext from "../../../utils/CenterContext";
import { NavLink } from "react-router-dom";

// default imgae
import default_img from "../../../assets/images/avatars/default.png";

const ProfileDropdown = ({ profileOptions }) => {
  const [img, setImg] = useState(getUserimgStorage());
  const { member: _member } = useContext(MemberContext);
  const { center: _center } = useContext(CenterContext);
  const [member, setMember] = useState();
  const [center, setCenter] = useState();

  useEffect(() => {
    setImg(getUserimgStorage());
    setMember(_member);
    setCenter(_center);
  }, [_member, _center]);

  return (
    <Dropdown as="li">
      <Dropdown.Toggle as={Nav.Link} id="user">
        <div className="d-flex align-items-center">
          <div className="flex-shrink-0">
            <img
              src={img ? img : default_img}
              alt="user"
              className="avatar avatar-xs rounded-circle"
            />
          </div>
          <div className="flex-grow-1 ms-1 lh-base">
            <span className="fw-semibold fs-13 d-block line-height-normal">
              {!!member && member?.nameZH?.fullName}
            </span>
            <span className="text-muted fs-13">
              {!!center && center?.nameZH}
            </span>
          </div>
        </div>
      </Dropdown.Toggle>

      <Dropdown.Menu className="p-2" renderOnMount>
        {(profileOptions || []).map((profile, index) => {
          return (
            <React.Fragment key={index.toString()}>
              {index === profileOptions.length - 1 && (
                <Dropdown.Divider as="div" />
              )}
              <Dropdown.Item as="button" className="p-2">
                <NavLink
                  to={profile.redirectTo}
                  className="text-secondary w-100"
                >
                  <FeatherIcon
                    icon={profile.icon}
                    className="icon icon-xxs me-1 icon-dual"
                  />
                  {profile.label}
                </NavLink>
              </Dropdown.Item>
            </React.Fragment>
          );
        })}
      </Dropdown.Menu>
    </Dropdown>
  );
};

export default ProfileDropdown;
