// component
import Navbar4 from "../../../components/navbars/Navbar4";
import Footer from "../../../components/footer/Footer";
import { useParams, useNavigate, useSearchParams } from "react-router-dom";
import { Card, Container } from "react-bootstrap";

import Hero from "./Hero";
import { useEffect, useContext } from "react";
import useState from "react-usestateref";
import { getSingleProgramInfo, getProgramInfoImage } from "../../../services/apiCore";
import CenterContext from "../../../utils/CenterContext";
import { isLoggedIn } from "../../../services/AuthService";
import Navigation from "./Navigation";
import ProgramSessions from "./ProgramSessions";
import defaultImage from "../../../assets/images/default-img.jpg";
import defaultBanner from "../../../assets/images/default-banner.png";
import ProgramPromotion from "./ProgramPromotion";
import ProgramEnrollmentModal from "./ProgramEnrollmentModal";

const ProgramDetail = () => {
  const navigate = useNavigate();
  const { center } = useContext(CenterContext);
  // const location = useLocation();
  // const id = location?.state?.id;
  const { id } = useParams();
  const [img, setImg] = useState();
  const [program, setProgram] = useState();
  const [sessions, setSessions] = useState();
  const [selectedSession, setSelectedSession] = useState();
  const [showEnrollmentBtn, setShowEnrollmentBtn] = useState(false);
  const [params, setParams] = useState();

  useEffect(() => {
    setParams({
      programId: id,
      centerId: program?.center?.id,
      categoryId: program?.programOnlineEnrollmentSetting?.categoryId,
      isShow: true,
      isTop: null,
      pageNumber: 1,
      pageSize: 3,
      isOrderByAsc: true,
    });

  }, [program]);

  useEffect(() => {
    function adjustFontSize() {
      const textNodes = getTextNodes(document.body);
      document.body.style.setProperty("--size", localStorage.size);
      textNodes.forEach(node => {
        const orignFontSize = parseInt(window.getComputedStyle(node.parentNode).fontSize);
      if (node.parentNode.style.getPropertyValue("--sorignFontSize") == '') {
        node.parentNode.style.setProperty("--sorignFontSize", orignFontSize + "px");
        node.parentNode.style.fontSize = `calc(var(--sorignFontSize) * var(--size))`;
      }
    });
  }
  /* getnodes */
  function getTextNodes(node) {
    let textNodes = [];
    if (node.nodeType === Node.TEXT_NODE) {
      textNodes.push(node);
    } else {
      const children = node.childNodes;
      if (children) {
        for (let i = 0; i < children.length; i++) {
          textNodes = textNodes.concat(getTextNodes(children[i]));
        }
      }
    }
    return textNodes;
  }
  async function fetchDataAndAdjust() {
    await fetchData();
    setTimeout(function () {
      adjustFontSize();
    }, 1000); //await
  }
  fetchDataAndAdjust();
    window.scrollTo({ top: 0, behavior: "smooth" });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id]);

  const fetchData = async () => {
    const img = (await getProgramInfoImage(id))?.data;
    setImg(img ? img : defaultBanner);

    const result = await getSingleProgramInfo({ id });
    if (!result?.data) {
      alert("沒有活動資料");
      navigate(-1);
    } else {
      const newSessions = result?.data?.programSessions.map((item, index) => {
        item['disabled'] = false;
        if (item.paymentAmount === null) {
          item['disabled'] = true;
        } else if (item.maxRegistrations - item.numberOfRegistered <= 0) {
          item['disabled'] = true;
        }
        return item;
      });
      setProgram(result?.data);
      setSessions(newSessions);
    }
  };

  const handleSelectedSession = (selectedSession) => {
    setSelectedSession(
      sessions.find((item) => String(item.id) === String(selectedSession))
    );
  };

  return (
    <>
      {/* header */}
      <Navbar4 fixedWidth />
      {/* <Navigation></Navigation> */}
      <div className="top-menu-placeholder"></div>
      <section className="position-relative">
        <Container>
          <div>
            <Hero
              program={program}
              img={img}
              sessions={sessions}
            />
            {/* <ProgramSessions
              sessions={sessions}
              handleSelectedSession={handleSelectedSession}
              selectedSession={selectedSession}
            ></ProgramSessions> */}
            <ProgramPromotion params={params}></ProgramPromotion>
          </div>
          {/* <ProgramEnrollmentModal
            program={program}
            show={showEnrollmentModal}
            handleClose={handleCloseEnrollmentModal}
            sessions={sessions}
            selectedSession={selectedSession}
          ></ProgramEnrollmentModal> */}
        </Container>
      </section>
      <Footer />
    </>
  );
};

export default ProgramDetail;
