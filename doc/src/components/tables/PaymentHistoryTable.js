import { useState, useEffect, useCallback } from "react";
import DataGrid, {
  Column,
  Pager,
  Paging,
  Selection,
} from "devextreme-react/data-grid";
import { Col, Row } from "react-bootstrap";
import moment from "moment";

const PaymentHistoryTable = ({ tableData }) => {
  const pageSizes = [10, 25, 50, 100];
  const [windowSize, setWindowSize] = useState(window.innerWidth);

  const handleWindowResize = useCallback((event) => {
    setWindowSize(window.innerWidth);
  }, []);

  useEffect(() => {
    window.addEventListener("resize", handleWindowResize);
    return () => {
      window.removeEventListener("resize", handleWindowResize);
    };
  }, [handleWindowResize]);

  return (
    <div className="py-3 px-5">
      { (tableData || []).map((item, index) => (
        <Row key={index} className="border rounded my-4 py-2 align-items-end shadow">
          <Col style={{flexGrow: 1}}>
            <div class="fs-2 text-black">{item.paymentName}</div>
            <div class="fs-4" style={{color: '#6C6C6C'}}>{moment(item.paymentDate).format(process.env.REACT_APP_DATETIME_FORMAT)}</div>
          </Col>
          <Col style={{flexGrow: 0, width: '100px', textAlign: 'right'}}>
            <div className="fw-bold fs-1" style={{color: '#58C5E6'}}>${item.amount}</div>
          </Col>
        </Row>
      )) }
    </div>
  );
};

export default PaymentHistoryTable;
