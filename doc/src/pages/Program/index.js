import React, { useEffect, useContext, useState } from "react";
import { Col, Container, Row } from "react-bootstrap";

import Navbar4 from "../../components/navbars/Navbar4";
import { getProgramCategory } from "../../services/apiCore";
import CenterContext from "../../utils/CenterContext";
import SearchAccordion from "./SearchAccordion";
import Footer from "../../components/footer/Footer";
import SearchProgram from "./SearchProgram";
import ProgramScheduler from "./ProgramScheduler";

const Program = () => {
  const { center } = useContext(CenterContext);
  const [categories, setCategories] = useState();
  const [searchValues, setSearchValues] = useState({
    pageSize: 4,
    orderBy: "startDate",
    isOrderByAsc: false,
    centerId: center?.id,
    isShow: true,
  });

  useEffect(() => {
    const fetchProgramCategory = async () => {
      if (!!center) {
        const category_result = await getProgramCategory();
        setCategories(category_result?.data?.MobileMenuCategory);
        setSearchValues({ ...searchValues, centerId: center?.id });
      }
    };
    fetchProgramCategory();
  }, [center]);

  const handleSearch = (values) => {
    // console.log("handleSearch.values", values);
    // remove date parameter if it is empty
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

  return (
    <>
      {/* header */}
      <Navbar4 fixedWidth />

      <div className="top-menu-placeholder"></div>
      <section className="position-relative p-3 bg-gradient2">
        <Container>
          <Row>
            <Col xs={12}>
              <div className="h2">活動</div>
            </Col>
          </Row>

          <Row>
            <Col xs={12}>
              <SearchAccordion
                handleSearch={handleSearch}
                searchValues={searchValues}
                categories={categories}
              ></SearchAccordion>
            </Col>
          </Row>

          <Row>
            <Col xs={12}>
              <ProgramScheduler searchValues={searchValues} />
            </Col>
          </Row>

          <section className="position-relative p-3 bg-gradient2">
            <SearchProgram params={searchValues} />
          </section>
        </Container>
      </section>
      <Footer />
    </>
  );
};

export default Program;
