import { useEffect } from "react";
import useState from "react-usestateref";
import moment from "moment";
import { getProgramInfoImage } from "../../services/apiCore";
import defaultImage from "./../../assets/images/Placeholder.png";
import { Row, Col } from "react-bootstrap";

const ProgramAppointmentTooltip = (props) => {
  const [program, setProgram] = useState();
  const [programImage, setProgramImage] = useState();
  const getImg = async (id) => {
    const img = await getProgramInfoImage(id);
    setProgramImage(img?.data);
  };

  useEffect(() => {
    setProgram(props.data.appointmentData);
    getImg(props.data.appointmentData.id);
  }, []);

  const handleClick = () => {
    window.location = "/program/detail/" + program?.id;
  };

  return (
    // <Link to={"/program/detail/" + program?.id}>
    <div className="program-tooltip">
      <Row>
        <Col xs={12} className="align-left">
          <img src={programImage || defaultImage} className="text-left" />
          <div className="program-info">
            <div className="program-title">{program?.name}</div>
          </div>
        </Col>
      </Row>
      <Row>
        <Col xs={12}></Col>
        <div className="program-info">
          {/* <div className="program-title">{program?.name}</div> */}
          <div>
            日期:{" "}
            {moment(program?.startDate).format(
              process.env.REACT_APP_DATE_FORMAT
            )}{" "}
            -{" "}
            {moment(program?.endDate).format(process.env.REACT_APP_DATE_FORMAT)}
          </div>
          <div>場地: {program?.venue}</div>
        </div>
      </Row>
    </div>
    // </Link>
  );
};

export default ProgramAppointmentTooltip;
