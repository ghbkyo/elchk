import { Link } from "react-router-dom";
import FeatherIcon from "feather-icons-react";
import classNames from "classnames";
import { useState } from "react";
import {
  FacebookShareButton,
  FacebookIcon,
  LineShareButton,
  LineIcon,
  WhatsappShareButton,
  WhatsappIcon,
} from "react-share";
import Alert from "react-bootstrap/Alert";

const ShareIcons = () => {
  const [currentUrl, setcurrentUrl] = useState(window.location.href);
  const [show, setShow] = useState(false);

  const copyLink = () => {
    navigator.clipboard.writeText(currentUrl);
    setShow(true);
    setTimeout(() => {
      setShow(false);
    }, 2000);
  };

  return (
    <>
      <FacebookShareButton url={currentUrl} className="px-2">
        <FacebookIcon size={25} round={true}></FacebookIcon>
      </FacebookShareButton>
      <LineShareButton url={currentUrl} className="px-2">
        <LineIcon size={25} round={true}></LineIcon>
      </LineShareButton>
      <WhatsappShareButton url={currentUrl} className="px-2">
        <WhatsappIcon size={25} round={true}></WhatsappIcon>
      </WhatsappShareButton>
      <FeatherIcon
        icon="link"
        size="35"
        className="px-2 pointer"
        onClick={copyLink}
      />
      <Alert
        show={show}
        variant="success"
        onClose={() => setShow(false)}
        dismissible
        className="text-center"
      >
        連結已複製
      </Alert>
    </>
  );
};

export default ShareIcons;
