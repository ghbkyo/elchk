import React, { useEffect, useContext } from "react";
import Hero9 from "../../components/heros/hero9";
import About from "./About";
import Footer from "../../components/footer/Footer";
import BackToTop from "../../components/BackToTop";
import Navbar4 from "../../components/navbars/Navbar4";
import PublicProgram from "../Program/PublicProgram";
import useState from "react-usestateref";
import Question from "../../components/Question";
import Banner from "../../components/Banner";
import Heading from "components/Heading";
import ProgramSlider from "pages/Program/ProgramSlider";
import { Container } from "react-bootstrap";
import moment from "moment";
import SearchAccordion from "pages/Program/SearchAccordion";
import CenterContext from "../../utils/CenterContext";
import SearchProgram from "pages/Program/SearchProgram";
import MobileFooter from "../../components/footer/MobileFooter"; // 新增导入


const Home = () => {
  const { center } = useContext(CenterContext);
  const [isSearch, setIsSearch] = useState(false)
  const [searchValues, setSearchValues] = useState({
    keyword: '',
    pageSize: 6,
    orderBy: "startDate",
    isOrderByAsc: false,
    centerId: center?.id,
    isShow: true,
    isInProgress: true,
    isTop: null
  });

  const handleSearch = (values) => {
    console.log("handleSearch.values", values);
    // remove date parameter if it is empty
    if (values.keyword) {
      setIsSearch(true)
    } else if (values.categoryIds.length) {
      setIsSearch(true)
    } else if (values.programMinFee !== null || values.programMaxFee !== null) {
      setIsSearch(true)
    } else if (values.centerId != 0) {
      setIsSearch(true)
    } else if (values.programObject != '') {
      setIsSearch(true)
    } else {
      setIsSearch(false)
    }
    if (!values.startDateFrom){
      delete values.startDateFrom;
    }
    if (!values.startDateTo){
      delete values.startDateTo;
    }
    if (!values.endDateFrom){
      delete values.endDateFrom;
    }
    if (!values.endDateTo){
      delete values.endDateTo;
    }
    
    setSearchValues({ ...values });
  };
  // const [content, setContent, contentRef] = useState();
  // useEffect(() => {
  //   fetch("https://service.elchk.org.hk/")
  //     .then((response) => response.text())
  //     .then((data) => {
  //       setContent(data);
  //       console.log("data", data);
  //     })
  //     .catch((error) => console.log(error));
  // }, []);

  return (
    <>
      <div>
        <Navbar4 fixedWidth />
      </div>

      <div className="top-menu-placeholder"></div>
      <div className="position-relative">
        <Banner />
      </div>
      <section id="main" className="border-top">
        <section className="position-relative d-none d-sm-block">
          <SearchAccordion handleSearch={handleSearch} />
        </section>
        {
          isSearch ? 
          <>
            <SearchProgram params={searchValues} />
          </> :
          <div>
            <section className="position-relative p-3">
              <Heading title="精選活動" subtitle="建立美好精彩人生" />
              <ProgramSlider
                showNavigators={true}
                showIndicators={false}
              ></ProgramSlider>
            </section>

            <Container className="border-bottom border-black mt-6 d-none d-sm-block"></Container>
            
            <section className="position-relative p-3">
              <Heading title="即將舉辦的活動" subtitle="活動即將開始，敬請期待!" />
              <PublicProgram showTag={false} />
            </section>
          </div>
        }

        <section className="position-relative">
          <Footer />
          <Question />
          <BackToTop />
          <MobileFooter />
        </section>
      </section>
    </>
  );
};

export default Home;
