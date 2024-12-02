import Navbar4 from "components/navbars/Navbar4";
import Footer from "../../../components/footer/Footer";
import { Container, Row, Col, Tab, Tabs } from "react-bootstrap";
import { NavLink } from "react-router-dom";
import FeatherIcon from "feather-icons-react";

import image01 from "./../../../assets/images/user-guide/01.PNG";
import image02 from "./../../../assets/images/user-guide/02.PNG";
import image03 from "./../../../assets/images/user-guide/03.PNG";
import image04 from "./../../../assets/images/user-guide/04.PNG";
import image05 from "./../../../assets/images/user-guide/05.PNG";
import image06 from "./../../../assets/images/user-guide/06.PNG";
import image07 from "./../../../assets/images/user-guide/07.PNG";
import image08 from "./../../../assets/images/user-guide/08.PNG";

const UserGuide = () => {
  return (
    <>
      <Navbar4 fixedWidth />
      <section className="position-relative p-5 bg-gradient2">
        <Container className="mt-3 mb-4">
          <Row data-aos="fade-up">
            <Col xs={12}>
              <div className="display-4 h4">用戶指南</div>
            </Col>
          </Row>

          <Tabs
            data-aos="fade-up"
            defaultActiveKey="enroll"
            id="fill-tab-example"
            className="mb-3"
          >
            <Tab eventKey="enroll" title="活動報名">
              <Row data-aos="fade-up">
                <Col xs={12}>
                  <div className="w-100 text-center pb-3">
                    <div className="h4 pt-3">
                      請先在右上角登錄，如果您還不是基督教香港信義會社會服務部的會員，請先前往
                      <NavLink to="/contact">鄰近中心</NavLink>進行註冊。
                    </div>
                    <img src={image01} className="my-2 user-guide-image"></img>
                    <div className="divider">
                      <div className="divider-text">
                        <FeatherIcon icon="arrow-down" size="35" />
                      </div>
                    </div>
                  </div>
                </Col>
                <Col xs={12}>
                  <div className="w-100 text-center pb-3">
                    <div className="h4 pt-3">
                      輸入用戶名稱和密碼，然後點擊登入。
                    </div>
                    <img src={image02} height="500" className="my-2"></img>
                    <div className="divider">
                      <div className="divider-text">
                        <FeatherIcon icon="arrow-down" size="35" />
                      </div>
                    </div>
                  </div>
                </Col>
                <Col xs={12}>
                  <div className="w-100 text-center pb-3">
                    <div className="h4 pt-3">
                      在首頁或活動搜尋頁面，選擇並點擊您感興趣的活動圖像或標題。
                    </div>
                    <img
                      src={image03}
                      // height="400"
                      className="my-2 user-guide-image"
                    ></img>
                    <div className="divider">
                      <div className="divider-text">
                        <FeatherIcon icon="arrow-down" size="35" />
                      </div>
                    </div>
                  </div>
                </Col>
                <Col xs={12}>
                  <div className="w-100 text-center pb-3">
                    <div className="h4 pt-3">
                      您可以在此處查看活動詳情。在活動場次，您可以在日曆中選擇活動場次的日期。
                    </div>
                    <img src={image04} className="my-2 user-guide-image"></img>
                    <div className="divider">
                      <div className="divider-text">
                        <FeatherIcon icon="arrow-down" size="35" />
                      </div>
                    </div>
                  </div>
                </Col>
                <Col xs={12}>
                  <div className="w-100 text-center pb-3">
                    <div className="h4 pt-3">
                      在選擇日期後，您可以在日曆右邊選擇活動場次。
                    </div>
                    <img src={image05} className="my-2 user-guide-image"></img>
                    <div className="divider">
                      <div className="divider-text">
                        <FeatherIcon icon="arrow-down" size="35" />
                      </div>
                    </div>
                  </div>
                </Col>
                <Col xs={12}>
                  <div className="w-100 text-center pb-3">
                    <div className="h4 pt-3">
                      點擊右上方的「報名」按鈕以報名。
                    </div>
                    <img src={image06} className="my-2 user-guide-image"></img>
                    <div className="divider">
                      <div className="divider-text">
                        <FeatherIcon icon="arrow-down" size="35" />
                      </div>
                    </div>
                  </div>
                </Col>
                <Col xs={12}>
                  <div className="w-100 text-center pb-3">
                    <div className="h4 pt-3">
                      您可以在此處更改和確認場次。然後按「報名」按鈕以報名。
                    </div>
                    <img src={image07} className="my-2 user-guide-image"></img>
                    <div className="divider">
                      <div className="divider-text">
                        <FeatherIcon icon="arrow-down" size="35" />
                      </div>
                    </div>
                  </div>
                </Col>
                <Col xs={12}>
                  <div className="w-100 text-center pb-3">
                    <div className="h4 pt-3">報名成功後會出現此畫面。</div>
                    <img src={image08} className="my-2 user-guide-image"></img>
                  </div>
                </Col>
              </Row>
            </Tab>
          </Tabs>
        </Container>
      </section>
      <Footer />
    </>
  );
};

export default UserGuide;
