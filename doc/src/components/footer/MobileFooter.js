import { Container, Row, Col } from "react-bootstrap";
import { Link } from "react-router-dom";
import { FaHome, FaSearch, FaHeart, FaUser, FaBars } from "react-icons/fa";

const MobileFooter = () => {
  return (
    <section className="mobile-footer position-fixed bottom-0 w-100 bg-primary" style={{zIndex: 1000}}>
      <Container fluid>
        <Row className="align-items-center justify-content-between py-2">
          <Col xs={2} className="text-center">
            <Link to="/" className="text-dark">
              <FaHome size={24} color="white" />
              <div className="fs-12">首頁</div>
            </Link>
          </Col>
          <Col xs={2} className="text-center">
            <Link to="/search" className="text-dark">
              <FaSearch size={24} color="white" />
              <div className="fs-12">搜索</div>
            </Link>
          </Col>
          <Col xs={2} className="text-center">
            <Link to="/more" className="text-dark">
              <FaBars size={24} color="white" />
              <div className="fs-12">更多</div>
            </Link>
          </Col>
          <Col xs={2} className="text-center">
            <Link to="/favorites" className="text-dark">
              <FaHeart size={24} color="white" />
              <div className="fs-12">收藏</div>
            </Link>
          </Col>
          <Col xs={2} className="text-center">
            <Link to="/profile" className="text-dark">
              <FaUser size={24} color="white" />
              <div className="fs-12">我的</div>
            </Link>
          </Col>
        </Row>
      </Container>
    </section>
  );
};

export default MobileFooter;