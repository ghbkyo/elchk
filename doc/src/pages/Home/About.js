import { Col, Container, Row } from "react-bootstrap";
import Navbar4 from "../../components/navbars/Navbar4";
import Footer from "../../components/footer/Footer";
import PageHeading from "components/PageHeading";

const About = () => {
  return (
    <>
      <Navbar4 fixedWidth />
      <div id="main">
        <PageHeading title="關於我們" subtitle="基督教香港信義會社會服務部" />
        
        <section className="position-relative main-content">
          <Container className="pb-4">
            <Row data-aos="fade-up">
              <Col>
                <div className="h5 text-muted mb-4">
                  自1976年成立，是香港大型的綜合性社會服務機構，以創新的方式、關愛及以人為本的精神為基層及弱勢社群提供多元化的服務。本機構現時共有超過50個服務單位及30個特別計劃，服務範圍遍佈全港，由幼兒到長者，從家庭、學校以至職場，每年服務過百萬人次。
                </div>

                <div className="h5 text-muted">
                  創新服務
                  <ul>
                    <li>
                      生活再動計劃：賽馬會居家安老新里程 ─
                      以科技提升居家安老生活質素，重啟長者新生活
                    </li>
                    <li>
                      i-Change 賭博輔導平台 ─
                      以聊天機械人「阿信」為賭博成癮者提供24小時支援及跟進服務。
                    </li>
                    <li>
                      賽馬會「a家」樂齡科技教育及租賃服務 ─
                      由香港賽馬會慈善信託基金捐助、香港社會服務聯會主辦的服務，本機構主責營運樂齡科技的租賃服務，並提供跨專業團隊上門評估及建議。
                    </li>
                    <li>
                      屯門地區康健中心 ─
                      本機構營運的大型地區基層醫療發展項目，以科技結合服務，為於屯門區居住或工作的市民提供多項基層醫療健康服務，包括健康推廣、健康評估、慢性疾病管理和社區復康服務等。
                    </li>
                  </ul>
                </div>
                <h4 className="display-7 fw-semibold mt-4">系統/計劃簡介</h4>
                <div className="h5 text-muted mb-4">
                  為促進數碼化轉型發展，基督教香港信義會社會服務部在賽馬會信託基金的支持下，開發「4S服務管理系統」會員系統，會員可掌握完整的中心消息及活動資訊，登入系統後即可瀏覽及報名參加中心活動。另外，系統記錄了會員的個人資料，會員可隨時查閱積分、義工服務時數、繳費紀錄等。
                </div>
                <h4 className="display-7 fw-semibold mt-4">我們的使命</h4>
                <div className="h5 text-muted mb-4">
                  實踐耶穌基督傳揚福音和服務人群的精神
                </div>
                <h4 className="display-7 fw-semibold mt-4">願景</h4>
                <div className="h5 text-muted mb-4">
                  以人為本、關心弱勢社群。與時並進、銳意變革創新。邁向卓越、處處顯出關懷。
                </div>
              </Col>
            </Row>
          </Container>
        </section>
      </div>
      <Footer />
    </>
  );
};

export default About;
