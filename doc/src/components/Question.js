import { Link } from "react-router-dom";
import FeatherIcon from "feather-icons-react";
import classNames from "classnames";

const Question = ({ variant }) => {
  return (
    <div>
      <Link
        className={classNames(
          "btn",
          "btn-soft-" + variant,
          "shadow-none",
          "btn-icon",
          "btn-bottom-question"
        )}
        id="btn-bottom-question"
        to="/enquiry"
      >
        <FeatherIcon icon="help-circle" className="icon-xs" />
      </Link>
    </div>
  );
};

Question.defaultProps = {
  variant: "primary",
};

export default Question;
