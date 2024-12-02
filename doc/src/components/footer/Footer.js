import { Col, Container, Row, Navbar } from "react-bootstrap";
import { Link } from "react-router-dom";

// images
import logo_hkjc from "../../assets/images/logo-jockey-club.png";

const elcss_link = "https://service.elchk.org.hk/";

const Footer = ({ aosSetting }) => {
  /*
   data-aos="fade-up"
    */
  const dataAOS =
    aosSetting === ("disable" || undefined || "") ? "" : aosSetting;
  return (
    <section
      className="section pt-lg-6 pt-3 position-relative d-none d-sm-block"
      data-aos={dataAOS}
    >
      <div className="px-5">
        <Row className="align-items-center">
          <Col className="text-right">
            <div className="">捐助機構</div>
            <Navbar.Brand href={elcss_link} target="_blank" className="logo">
              <img src={logo_hkjc} height="60" className="mt-2 mb-4" alt="" />
            </Navbar.Brand>
          </Col>
        </Row>
      </div>
      <div className="copyright px-5 py-3 fw-medium">
        <Row className="align-items-center">
          <Col>
            <p className="fs-14">
              版權所有 &copy; {new Date().getFullYear()} 基督教香港信義會<br />
              基督教香港信義會是一所註冊慈善團體及擔保有限公司
            </p>
          </Col>
          <Col className="text-end">
            <div><Link to="/privacy" className="text-white">條款及細則</Link></div>
          </Col>
        </Row>
        
      </div>
    </section>
  );
};

export default Footer;
