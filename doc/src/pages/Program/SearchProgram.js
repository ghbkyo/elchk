import { Badge, Button, Col, Container, Row, Spinner } from "react-bootstrap";
import { useContext, useEffect, useReducer } from "react";
import useState from "react-usestateref";
import { getProgramInfo, getProgramCategory } from "../../services/apiCore";
import ProgramPost from "./ProgramPost";
import CenterContext from "../../utils/CenterContext";
import Select from "react-select";

const SearchProgram = ({ params }) => {
  const [searchParams, setSearchParams] = useState(params);
  const [maxPage, setMaxPage] = useState(1);
  const [pageOptions, setPageOptions] = useState();
  const [currentPageOption, setCurrentPageOption] = useState({
    value: 1,
    label: 1,
  });
  const [programs, setPrograms] = useState();
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setSearchParams(params);
  }, [params]);

  useEffect(() => {
    refreshPrograms();
  }, [searchParams]);

  const refreshPrograms = async () => {
    setLoading(true);
    // console.log("SearchProgram.refreshPrograms", searchParams);
    const result = await getProgramInfo(searchParams);
    const _programs = result?.data?.items || [];
    setPrograms(_programs);
    setMaxPage(result?.data?.totalPages);
    updatePageOptions(result?.data?.pageIndex, result?.data?.totalPages);
    setLoading(false);
  };

  const updatePageOptions = (currentPage, totalPages) => {
    let _pageOptions = [];
    for (let i = 1; i <= totalPages; i++) {
      _pageOptions.push({
        value: i,
        label: i,
      });
    }
    setPageOptions(_pageOptions);
    setCurrentPageOption({ value: currentPage, label: currentPage });
  };

  const handlePageChange = (changedOption) => {
    setSearchParams({ ...searchParams, pageNumber: changedOption.value });
    document.getElementById("programContainer")?.scrollIntoView();
  };

  const handlePageChangeButton = (type) => {
    switch (type) {
      case "PREVIOUS_PAGE":
        setSearchParams({
          ...searchParams,
          pageNumber: currentPageOption.value - 1,
          isTop: null
        });
        break;
      case "NEXT_PAGE":
        setSearchParams({
          ...searchParams,
          pageNumber: currentPageOption.value + 1,
        });
        break;
    }
    document.getElementById("programContainer")?.scrollIntoView();
  };

  return (
    <>
      {loading ? (
        <div className="w-100 p-5 text-center">
          <Spinner animation="border" variant="primary"></Spinner>
        </div>
      ) : (
        <Container>
          <Row className="justify-content-lg-between">
            <Col lg={12}>
              <div class="program-list d-flex flex-row flex-wrap">
              {(programs || []).map((program, index) => {
                return (
                  <div className="item">
                    <ProgramPost program={program} />
                  </div>
                );
              })}
              </div>
            </Col>
            

            <Row className="mt-5">
              <Col lg={12}>
                <div className="d-flex align-items-center justify-content-center">
                  <Button
                    variant="btn btn-sm btn-white"
                    onClick={() => handlePageChangeButton("PREVIOUS_PAGE")}
                    disabled={currentPageOption.value === 1 ? true : false}
                  >
                    <i className="icon icon-xxs icon-left-arrow me-2"></i>
                    上一頁
                  </Button>
                  <Select
                    name="page"
                    options={pageOptions}
                    value={currentPageOption}
                    onChange={(e) => {
                      handlePageChange(e);
                    }}
                  />
                  <Button
                    variant="btn btn-sm btn-white ms-2"
                    onClick={() => handlePageChangeButton("NEXT_PAGE")}
                    disabled={currentPageOption.value >= maxPage ? true : false}
                  >
                    下一頁<i className="icon-xxs icon-right-arrow ms-2"></i>
                  </Button>
                </div>
              </Col>
            </Row>
          </Row>
        </Container>
      )}
    </>
  );
};

export default SearchProgram;
