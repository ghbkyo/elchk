import React, { useEffect } from "react";
import { Button, Modal } from "react-bootstrap";
import FeatherIcon from "feather-icons-react";

const MyModal = (props) => {

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
      adjustFontSize()
    })

    return (<Modal
        {...props}
        backdrop="static"
        keyboard={false}
        centered
    >
        <Modal.Body
            style={{
                backgroundColor: '#0080CE',
                color: '#fff',
            }}
            className="my-modal"
        >
            <div className="py-3 text-center"><FeatherIcon icon='alert-octagon' size={30} /></div>
            <div className="text-center modal-title">{props.title}</div>
            <div className="text-center py-3 modal-text">{props.content}</div>
            <div className="d-flex justify-content-center gap-3 btns mt-3">
                <Button variant="primary" onClick={props.onConfirm}>{props.confirmText ? props.confirmText : '是'}</Button>
                { props.hideCancel ? <></> : <Button variant="secondary" onClick={props.onHide}>{props.cancelText ? props.cancelText : '否'}</Button> }
            </div>
        </Modal.Body>
    </Modal>)
}

export default MyModal;
