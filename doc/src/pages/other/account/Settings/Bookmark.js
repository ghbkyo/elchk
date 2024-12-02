import React, { useEffect, useState, useContext } from "react";
import { Col, Row, Button, Container } from "react-bootstrap";
import moment from "moment";
import {
  getProgramBookmark,
} from "../../../../services/apiCore";
import EnrollmentRecordTable from "../../../../components/tables/EnrollmentRecordTable";
import { Player } from "@lottiefiles/react-lottie-player";
import LottieLoadingFile from "assets/json/LottieLoadingFile.json";
import CenterContext from "utils/CenterContext";
import { isCenterContainOnlinePayment } from "../../../../utils/utils";
import Navbar4 from "components/navbars/Navbar4";
import Footer from "../../../../components/footer/Footer";
import PageHeading from "components/PageHeading";
import ProgramPost from "pages/Program/ProgramPost";

const Bookmark = () => {
  const { center } = useContext(CenterContext);
  const [programs, setPrograms] = useState([]);
  const [pageSize, setpageSize] = useState(21);
  const [showLoading, setShowLoading] = useState(false);
  const [centerPaymentMethod, setCenterPaymentMethod] = useState([]);

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
  }, [center]);

  const fetchData = async () => {
    setShowLoading(true);
    const _result = await getProgramBookmark({
      pageNumber: 1,
      pageSize: 999
    });
    setPrograms(
      _result?.data?.items
    );
    setShowLoading(false);
  };

  const handleRefresh = () => {
    fetchData();
  };

  return (
    <>
      <Navbar4 fixedWidth />
      <div id="main">
        <PageHeading title="我的收藏" icon="heart" />

        <Container>
          {!showLoading && (
            <div class="program-list d-flex flex-row flex-wrap">
              { (programs || []).map((program, index) => {
                return <div className="item"><ProgramPost key={index} program={program} /></div>
              } 
              ) }
            </div>
          )}
          {!!showLoading && (
            <Player
              autoplay
              loop
              // src="https://assets8.lottiefiles.com/private_files/lf30_fup2uejx.json"
              src={LottieLoadingFile}
              style={{ height: "280px", width: "280px" }}
              className=""
            ></Player>
          )}
        </Container>
      </div>

      <Footer aosSetting="disable" />

    </>
  );
};

export default Bookmark;
