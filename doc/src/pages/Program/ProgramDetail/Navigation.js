import { Button, Card, Col, Container, Row } from "react-bootstrap";
import FeatherIcon from "feather-icons-react";
import { useNavigate } from "react-router-dom";
import classNames from "classnames";
import { useState, useEffect } from "react";

const Navigation = () => {
  const navigate = useNavigate();
  const [firstComponentStyle, setFirstComponentStyle] = useState("pt-7");

  const handleClick = () => {
    // const path = `/program`
    // navigate(path)
    navigate(-1);
  };

  const [width, setWidth] = useState(window.innerWidth);
  const isMobile = width <= 768;

  function handleWindowSizeChange() {
    setWidth(window.innerWidth);
  }

  useEffect(() => {
    window.addEventListener("resize", handleWindowSizeChange);
    if (isMobile) {
      setFirstComponentStyle("pt-7");
    } else {
      setFirstComponentStyle("pt-3");
    }
    return () => {
      window.removeEventListener("resize", handleWindowSizeChange);
    };
  }, [isMobile]);

  return (
    <>
      <Card>
        <div
          className={classNames(
            "border-top",
            "border-bottom",
            "align-items-center",
            "pb-3",
            firstComponentStyle
          )}
        >
          <Row>
            <Col md={4} sm={6} className="text-md-start ps-5">
              <Button variant="outline-dark" onClick={handleClick}>
                <FeatherIcon icon="arrow-left" className="icon icon-xs me-2" />
                返回
              </Button>
            </Col>
            <Col md={4} className="text-md-center"></Col>
            <Col md={4} sm={6} className="text-md-end"></Col>
          </Row>
        </div>
      </Card>
    </>
  );
};

export default Navigation;
