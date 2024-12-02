import { Col, Container, Row } from "react-bootstrap";
import Navbar4 from "../../components/navbars/Navbar4";
import Footer from "../../components/footer/Footer";
import PageHeading from "components/PageHeading";

const Privacy = () => {
  return (
    <>
      <Navbar4 fixedWidth />
      <div id="main">
        <PageHeading title="條款及細則" subtitle="" />
        
        <section className="position-relative main-content">
          <Container className="pb-4">
            <Row data-aos="fade-up">
              <Col>
                <div className="h5 text-muted mb-4">
                  除註明外，基督教香港信義會社會服務部（下稱「本機構」）是本網站所有內容（包括但不限於所有文本、圖像、圖畫、圖片、照片以及數據或其他材料的匯編）的版權擁有人。
                </div>
                <div className="h5 text-muted mb-4">
                  所有載於本網站內由本機構擁有版權的內容及資訊，可供自由瀏覽、列示、下載、列印、發佈或複製作非商業用途，但必須保留網站內容原來的格式，及須註明有關內容原屬本機構所有，並複印此版權告示於所有複製本內。本機構保留所有本版權告示沒有明確授予的權利。任何人士需要使用前述的內容作任何其他並非上述所批准的用途，須事先得到本機構的書面同意。有關申請可電郵至 ccd@elchk.org.hk 處理。
                </div>
                <div className="h5 text-muted mb-4">
                  以上所給予的批准並不引伸至任何其他與本網站連結的網站，或在本網站內標明由第三者擁有版權的內容。如你需要使用該等內容，必須取得有關版權擁有人的授權或批准。
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

export default Privacy;
