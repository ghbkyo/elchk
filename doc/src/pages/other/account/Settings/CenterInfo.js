import React, { useEffect, useState } from "react";

import Navbar4 from "../../../../components/navbars/Navbar4";
import Footer from "../../../../components/footer/Footer";
import PageHeading from "components/PageHeading";

import { Container, Col, Row, Button, Badge } from "react-bootstrap";
import moment from "moment";
import { Table } from "rsuite";
import { sortBy } from "lodash";
import { postNoticeMarkRead, getProgramNotice } from "../../../../services/apiCore";
import { Player } from "@lottiefiles/react-lottie-player";
import LottieLoadingFile from "assets/json/LottieLoadingFile.json";

const CenterInfo = () => {
  const colors = {
    'Program': '#CDD311',
  }
  const types = {
    'Program': '狀態更新'
  }
  const [resultData, setresultData] = useState();
  const [sortColumn, setSortColumn] = React.useState();
  const [sortType, setSortType] = React.useState();
  const [loading, setLoading] = React.useState(true);
  const [pageNumber, setPageNumber] = useState(1);
  useEffect(async () => {
    setLoading(true);
    const result = await getProgramNotice({
      pageSize: 10,
      pageNumber: pageNumber,
      orderBy: 'id',
      isOrderByAsc: false
    });
    setresultData(result.data.items);
    setLoading(false);
  }, []);
  const handleGetMore = async () => {
    setLoading(true);
    const param = { pageNumber: pageNumber + 1, pageSize: 10 };
    setPageNumber(pageNumber + 1);
    const result = await getProgramNotice(param);
    setresultData(result?.data);
    setLoading(false);
  };
  return (
    <>
      <Navbar4 fixedWidth />

      <div id="main">
        <PageHeading title="我的通知" />
        <Container>
          {loading && (
            <Player
              autoplay
              loop
              // src="https://assets8.lottiefiles.com/private_files/lf30_fup2uejx.json"
              src={LottieLoadingFile}
              style={{ height: "280px", width: "280px" }}
              className=""
            ></Player>
          )}
          {
            !loading && resultData.map((item, index) =>
              <div key={index} className="program-form-box p-3 mt-3">
                <div className="program-form-box-content" onClick={async () => {
                  await postNoticeMarkRead({
                    id: item.id,
                    isMarkRead: true
                  })
                  setresultData(resultData.map((_item) => {
                    if (_item.id == item.id) {
                      _item['active'] = !_item['active']
                      _item['isMarkRead'] = true
                    }
                    return _item;
                  }))
                  
                }}>
                    <Row>
                      <Col lg={10}>
                        <div className="fs-4 fw-bold">
                          { !item.isMarkRead && <Badge bg="danger" className="p-1 rounded-circle align-middle me-1"><span className="visually-hidden">unread</span></Badge> }
                          {item.title}</div>
                      </Col>
                      <Col lg={2} className="text-end fw-semibold" style={colors[item.noticeType] && {color: colors[item.noticeType]}}>{types[item.noticeType]}</Col>
                    </Row>
                    { item.active && <div>{item.remarks}</div> }
                    <div className="text-gray mt-2">{moment(item.sentOn ? item.sentOn : item.created).format(process.env.REACT_APP_DATETIME_FORMAT)}</div>
                </div>
              </div>
            )
          }
          <Row className="mb-12">
            <Col xs={12}>
              <Button variant="white" onClick={handleGetMore} hidden>
                更多
              </Button>
            </Col>
          </Row>
        </Container>
      </div>
      
      <Footer aosSetting="disable" />
    </>
  );
};

export default CenterInfo;
