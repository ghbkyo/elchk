import { Col, Container, Row } from "react-bootstrap";
import Navbar4 from "../../components/navbars/Navbar4";
import Footer from "../../components/footer/Footer";

const Contact = () => {
  return (
    <>
      <Navbar4 fixedWidth />
      <section className="position-relative p-5 bg-gradient2">
        <Container className="mt-2 mb-4">
          <Row data-aos="fade-up">
            <Col lg={4}>
              {/* <span className="border border-top w-100 border-soft-primary d-block"></span> */}
              <p className="display-4 fw-semibold mt-4">聯絡我們</p>
            </Col>
            <Col lg={8}>
              <div className="mt-4">
                <h4>基督教香港信義會社會服務部—總處</h4>
                <div className="py-2">
                  <ul>
                    <li className="">
                      <div className="h5">電話：(852) 2710-8313</div>
                    </li>
                    <li className="">
                      <div className="h5">電郵：admdept@elchk.org.hk</div>
                    </li>
                  </ul>
                </div>
              </div>
            </Col>
            <span className="border border-top w-100 border-soft-primary d-block"></span>
            <Col lg={4}>
              <p className="display-4 fw-semibold mt-4">成為會員</p>
            </Col>
            <Col lg={8}>
              <div className="mt-4">
                <h4>請親臨基督教香港信義會社會服務部各服務單位申請</h4>
                <h4>
                  <a
                    href="https://service.elchk.org.hk/unit_list.php?dowhat=service_search&search_key=&service_type=&district="
                    target="_blank"
                  >
                    各服務單位列表
                  </a>
                </h4>
              </div>
            </Col>
          </Row>
        </Container>
      </section>
      <Footer />
    </>
  );
};

export default Contact;
