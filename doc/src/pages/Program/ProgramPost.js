import { Link } from "react-router-dom";
import classNames from "classnames";
import useState from "react-usestateref";
import { useContext, useEffect } from "react";
import moment from "moment";
import 'moment/locale/zh-hk'
import { getProgramInfoImage, postPayment, postProgramBookmark } from "../../services/apiCore";
import defaultImage from "../../assets/images/default-img.jpg";
import { Col, Container, Row, Badge, Nav, Button } from "react-bootstrap";
import FeatherIcon from "feather-icons-react";
import OverlayTrigger from "react-bootstrap/OverlayTrigger";
import Tooltip from "react-bootstrap/Tooltip";
import MemberContext from "utils/MemberContext";


moment.locale('zh-hk')

const ProgramPost = ({ program, paymentStatus, totalAmount, centerId, paymentId }) => {
  const paymentStatuses = {
    'Unpaid': '待付款',
    'Paid': '已成功'
  }
  const [programImage, setProgramImage] = useState();
  const [maxPerson, setmaxPerson] = useState(0);
  const [programFees, setprogramFees] = useState();
  const [showMore, setShowMore] = useState(false);
  const [isBookmarked, setIsBookmarked] = useState(program?.hasBookmark)

  const [windowSize, setWindowSize] = useState(window.innerWidth);
  const [isMobile, setIsMobile] = useState(window.innerWidth < 992);
  const handleWindowResize = (event) => {
    setWindowSize(window.innerWidth);
    setIsMobile(window.innerWidth < 992);
  };
  const { member } = useContext(MemberContext);

  const handleAddBookmark = async (event) => {
    try {
      const res = await postProgramBookmark({
        programInfoId: program.id,
        isEnabled: true
      });
      if (res.status == 200) {
        setIsBookmarked(res.data.isEnabled)
      }
      // 可以在这里添加一些成功提示或更新UI的逻辑
    } catch (error) {
      console.error('添加书签失败:', error);
      // 可以在这里添加错误处理逻辑
    }
  }

  useEffect(() => {
    window.addEventListener("resize", handleWindowResize);
    return () => {
      window.removeEventListener("resize", handleWindowResize);
    };
  }, [handleWindowResize]);

  useEffect(() => {
    let tempvalue = 0;
    program?.programSessions?.map((item) => {
      tempvalue = tempvalue + item.maximunNumberOfPaticipant;
    });
    setmaxPerson(tempvalue);
    let programFeesStr = "";
    if (program?.isFree === false) {
      program?.programFees?.map((item) => {
        if (item.memberType) {
          programFeesStr =
            programFeesStr +
            item.memberType?.nameZH +
            "$" +
            item.amount +
            ";  ";
        } else {
          programFeesStr = programFeesStr + "非會員$" + item.amount + ";  ";
        }
      });
    } else if (program?.isFree === true) {
      programFeesStr = "免費";
    } else {
      programFeesStr = "";
    }
    setprogramFees(programFeesStr);

    setProgramImage("");
    // get image
    const getImg = async () => {
      const img = await getProgramInfoImage(program?.id);
      setProgramImage(img?.data);
    };
    getImg();
  }, [program]);

  return (
    <>
      {!!program && (
        <>
          <div className="mx-2 position-relative rounded program-post-item">
            <div className={classNames('position-absolute', 'start-0', 'top-0', 'end-0', 'bottom-0', 'program-image')} 
              style={{backgroundImage: 'url('+(programImage || defaultImage)+')'}}>

            </div>
            { program?.isOnline ? 
            <div className="position-absolute start-0 top-0 p-3">
              <span className="px-3 py-1 tag pink">線上報名</span>
            </div> : <></> }
            <div className="position-absolute end-0 top-0 p-3 icons d-flex flex-row" style={{zIndex: 9}}>
              <span>
                <FeatherIcon icon="heart" color="#EB6685" fill={isBookmarked?'#EB6685':'transparent'} onClick={handleAddBookmark} />
              </span>
              <span>
                <FeatherIcon icon="share" color="#EB6685" />
              </span>
            </div>
            
            <div className={classNames("pt-9", "position-relative")}>
              <Row>
                <Col lg={8}>
                  {
                    paymentStatus ?
                    <div className="d-inline-block bg-red2">
                      <div className="px-3 bg-white">報名狀況</div>
                      <div className="px-3 text-white">{paymentStatuses[paymentStatus] ? paymentStatuses[paymentStatus] : paymentStatus}</div>
                    </div> : <></>
                  }
                </Col>
                <Col lg={4}>
                  <div class="program-post-fee text-end px-3 py-1">
                    {program?.isFree ? (
                      <span className="px-3 py-1 tag free">
                        免費
                      </span>
                    ) : (
                      <span className="px-3 py-1 tag fee">
                        收費
                      </span>
                    )}
                  </div>
                </Col>
              </Row>
              <div className="program-post-text px-2 py-2">
                <h4 className="fw-semibold mt-1">
                  <Link
                    to={"/program/detail/" + program?.id}
                    //state={{ id: program?.id }}
                  >
                    {program?.name}
                  </Link>
                </h4>

                <div className="tags">
                  {
                    program?.hashtags?.map((tag) => {
                      return <span className="px-1">
                        #{tag.name}
                        </span>
                    })
                  }
                </div>

                <div class="info d-flex w-100 flex-row align-items-center">
                  <div class="left">
                    <div class="item d-flex flex-row align-items-center">
                      <div>
                        <FeatherIcon
                          icon="map-pin"
                          size="20"
                        />
                      </div>
                      <span>地點: {program?.venue}</span>
                    </div>
                    <div class="item d-flex flex-row align-items-center">
                      <div>
                        <FeatherIcon
                          icon="clock"
                          size="20"
                        />
                      </div>
                      <span>時間: {moment(program?.startDate).format(
                            process.env.REACT_APP_TIME_FORMAT
                          )}
                          {"-"}
                          {moment(program?.endDate).format(
                            process.env.REACT_APP_TIME_FORMAT
                          )}</span>
                    </div>
                    <div class="item d-flex flex-row align-items-center">
                      <div>
                        <FeatherIcon
                          icon="user-check"
                          size="20"
                        />
                      </div>
                      <span>名額: {program?.programOnlineEnrollmentSetting?.enrollmentQuota}人</span>
                    </div>
                  </div>
                  <div class="right">
                    <div class="date-box d-flex flex-row align-items-center">
                      <div class="start-date date">
                        <span class="fw-bolder">{moment(program?.startDate).format('D')}</span>
                        <span className="d-block">{moment(program?.startDate).format('MMM')}</span>
                      </div>
                      {
                        (moment(program?.startDate).format('D MMMM') != moment(program?.endDate).format('D MMMM')) && (<><div>-</div><div class="end-date date">
                            <span class="fw-bolder">{moment(program?.endDate).format('D')}</span>
                            <span className="d-block">{moment(program?.endDate).format('MMM')}</span>
                          </div></>
                        )
                      }
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          {
            paymentStatus && <div className="mt-2">
              <Row>
                <Col className="d-flex justify-content-center flex-row gap-2">
                  <Button variant="gray" className="px-5 text-white">取消報名</Button>
                  {paymentStatus == 'Unpaid' && <Button variant="indigo" className="px-5 text-white" onClick={() => {
                    postPayment({
                      amount: totalAmount,
                      ar_Id: paymentId,
                      centerId: centerId,
                      redirect: process.env.REACT_APP_URL + '/program/detail/' + program.id
                    }, member);
                  }}>前往付款</Button>}
                </Col>
              </Row>
            </div>
          }
        </>
      )}
    </>
  );
};

export default ProgramPost;
