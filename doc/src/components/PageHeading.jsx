import FeatherIcon from "feather-icons-react";

const Heading = ({title, icon, subtitle}) => {
  return (<div className="page-heading container my-5"><div className="title border-bottom text-center py-3 d-flex align-items-center justify-content-center">
    <h1>
      { icon && <FeatherIcon icon={icon} size={46} color="#4E4F53" className="pe-2" /> }
      {title}
    </h1>
  </div>
  <h3 className="text-center subtitle mt-2">{subtitle}</h3>
  </div>);
};

export default Heading;
