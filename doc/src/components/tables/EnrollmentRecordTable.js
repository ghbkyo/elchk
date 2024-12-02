import { useState, useEffect, useCallback } from "react";
import { Button, Modal } from "react-bootstrap";
import DataGrid, {
  Column,
  Pager,
  Paging,
  Selection,
} from "devextreme-react/data-grid";
import PaymentCell from "../payment/PaymentCell";
import ProgramPost from "../../pages/Program/ProgramPost";

const EnrollmentRecordTable = ({ tableData }) => {
  const pageSizes = [10, 25, 50, 100];
  const [selectedItem, setSelectedItem] = useState({ isShow: false });
  const [selectedSession, setSelectedSession] = useState();
  const [windowSize, setWindowSize] = useState(window.innerWidth);

  const handleWindowResize = useCallback((event) => {
    setWindowSize(window.innerWidth);
  }, []);

  // console.log("tableData", tableData);

  useEffect(() => {
    window.addEventListener("resize", handleWindowResize);
    return () => {
      window.removeEventListener("resize", handleWindowResize);
    };
  }, [handleWindowResize]);

  useEffect(() => {
    setSelectedSession(selectedItem.sessions);
  }, [selectedItem]);

  const onCellClick = (e) => {
    if (e.column.dataField === "name") {
      const _ = e.data;
      !!_ &&
        setSelectedItem({
          name: _.name,
          sessions: _.item.programEnrollmentSessions,
          isShow: true,
        });
    }
  };

  const closeModal = () => {
    setSelectedItem({ ...selectedItem, isShow: false });
  };

  return (
    <>
      <Modal
        show={selectedItem.isShow}
        onHide={() => closeModal()}
        size="lg"
        backdrop="static"
      >
        <Modal.Header className="px-5" onHide={() => closeModal()} closeButton>
          <Modal.Title as="h3" className="py-3 w-100 text-center">
            <div>{selectedItem?.name}</div>
          </Modal.Title>
        </Modal.Header>
        <Modal.Body className="p-3 text-center">
          <DataGrid
            dataSource={selectedSession}
            allowColumnReordering={true}
            rowAlternationEnabled={true}
            showBorders={true}
            hoverStateEnabled={true}
            columnHidingEnabled={true}
          >
            <Column
              dataField="programSession.sessionNumber"
              caption="場次"
              dataType="string"
              width={50}
            />
            <Column
              dataField="programSession.startDate"
              caption="開始日期"
              dataType="datetime"
              width={150}
            />
            <Column
              dataField="programSession.endDate"
              caption="結束日期"
              dataType="datetime"
              width={150}
            />
            <Column
              dataField="programSession.venue"
              caption="場地"
              dataType="string"
            />
            <Pager allowedPageSizes={pageSizes} showPageSizeSelector={true} />
            <Paging defaultPageSize={10} />
          </DataGrid>
        </Modal.Body>
        <Modal.Footer className="text-center">
          <div>
            <Button variant="white" onClick={() => closeModal()}>
              離開
            </Button>
          </div>
        </Modal.Footer>
      </Modal>

      <div>
        <div class="program-list d-flex flex-row flex-wrap">
          {
            (tableData || []).map((item, index) => (
              <div class="item">
                <ProgramPost key={index} program={item.program} paymentStatus={item.paymentStatus} totalAmount={item.totalAmount} centerId={item.centerId} paymentId={item.paymentId} />
              </div>
            ))
          }
        </div>
        {/* <DataGrid
          dataSource={tableData}
          allowColumnReordering={true}
          rowAlternationEnabled={true}
          showBorders={true}
          hoverStateEnabled={true}
          onCellClick={onCellClick}
          columnHidingEnabled={windowSize > 1200 ? false : false}
        >
          <Selection mode="single" />
          <Column
            dataField="name"
            caption="活動名稱"
            dataType="string"
            cssClass="pointer"
            width={250}
          />
          <Column
            dataField="programNo"
            caption="活動編號"
            dataType="string"
            width={150}
          />
          <Column
            dataField="enrollmentDate"
            caption="報名日期"
            dataType="date"
            width={100}
          />
          <Column
            dataField="totalAmount"
            caption="報名費用"
            dataType="number"
            format="currency"
            width={80}
            // alignment="right"
          />
          <Column
            dataField="paymentStatus"
            caption="申請狀況"
            dataType="string"
            width={120}
            cellRender={PaymentCell}
          />

          <Pager allowedPageSizes={pageSizes} showPageSizeSelector={true} />
          <Paging defaultPageSize={10} />
        </DataGrid> */}
      </div>
    </>
  );
};

export default EnrollmentRecordTable;
