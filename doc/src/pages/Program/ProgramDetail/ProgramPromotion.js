import { Container, Row } from "react-bootstrap";
import { useEffect } from "react";
import useState from "react-usestateref";
import { getProgramInfo } from "../../../../src/services/apiCore";
import ProgramSlider from "../ProgramSlider";

const ProgramPromotion = ({ params }) => {
  const [programs, setPrograms] = useState();
  const [pageNum, setpageNum] = useState(1);

  const refreshPrograms = async () => {
    const param = { ...params, pageNumber: pageNum, pageSize: 3 };
    const result = await getProgramInfo(param);
    const filteredResult = (result?.data?.items || []).filter((item) => {
      return String(item.id) !== String(params.programId);
    });
    if (filteredResult.length > 2) {
      // set the program list size to 2
      filteredResult.length = 2;
    }
    setPrograms([filteredResult]);
  };

  useEffect(() => {
    !!params && !!params.centerId && refreshPrograms();
  }, [params]);

  const handlesliderChange = (nextSlide, currentSlide) => {
    if (nextSlide - currentSlide > 0) {
      setpageNum(pageNum + 1);
    } else {
      if (pageNum - 1 <= 0) {
        setpageNum(1);
      } else {
        setpageNum(pageNum - 1);
      }
    }
  };

  return (
    <>
      {/* <section className="position-relative p-3 bg-gradient2">
        <Container> */}
      {!!programs && programs.length > 0 && (
        <>
          <h3 className="py-3">你可能還會喜歡......</h3>
          <Row className="mt-3" data-aos="fade-up" data-aos-duration="300">
            <ProgramSlider
              programs={programs}
              showNavigators={false}
            ></ProgramSlider>
          </Row>
        </>
      )}
      {/* </Container>
      </section> */}
    </>
  );
};
export default ProgramPromotion;
