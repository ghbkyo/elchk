import { Link } from 'react-router-dom';
import classNames from 'classnames';
import { Dropdown, Nav } from 'react-bootstrap';
import FeatherIcon from 'feather-icons-react';

const NotificationDropdown = ({ notifications }) => {
    return (
        <Dropdown as="li" className="nav-item">
            <Dropdown.Toggle as={Nav.Link} id="notifications">
                <span className="icon-xs">
                    <FeatherIcon icon="bell" className="icon-dual-dark" />
                </span>
            </Dropdown.Toggle>

            <Dropdown.Menu className="p-2" renderOnMount>
                {(notifications || []).map((notification, index) => {
                    return (
                        <Dropdown.Item className="p-2" key={index.toString()}>
                            <div className="d-flex align-items-center">
                                <span
                                    className={classNames(
                                        'bg-soft-' + notification.variant,
                                        'text-' + notification.variant,
                                        'avatar',
                                        'avatar-xs',
                                        'rounded icon',
                                        'icon-with-bg',
                                        'icon-xxs',
                                        'me-3',
                                        'flex-shink-0'
                                    )}
                                >
                                    <FeatherIcon
                                        icon={notification.icon}
                                        className={classNames('icon-dual-' + notification.variant)}
                                    />
                                </span>
                                <div className="flex-grow-1">
                                    <h6 className="fw-medium my-0 fs-13">{notification.text}</h6>
                                    <span className="text-muted">
                                        <small>{notification.time}</small>
                                    </span>
                                </div>
                            </div>
                        </Dropdown.Item>
                    );
                })}
                <Link to="#" className="btn btn-light btn-sm bg-light text-center fs-13 d-block mt-2">
                    View All
                </Link>
            </Dropdown.Menu>
        </Dropdown>
    );
};

export default NotificationDropdown;
