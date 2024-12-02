import { Link } from "react-router-dom";
import FeatherIcon from "feather-icons-react";
import classNames from "classnames";

const BackToTop = ({ variant }) => {
  return (
    <div>
      <Link
        className={classNames(
          "btn",
          "btn-soft-" + variant,
          "shadow-none",
          "btn-icon",
          "btn-back-to-top",
          "btn-bottom-back-to-top"
        )}
        id="btn-back-to-top"
        to="#"
        onClick={() => window.scrollTo({ top: 0, behavior: "smooth" })}
      >
        <FeatherIcon icon="arrow-up" className="icon-xxs" />
      </Link>
    </div>
  );
};

BackToTop.defaultProps = {
  variant: "primary",
};

export default BackToTop;
