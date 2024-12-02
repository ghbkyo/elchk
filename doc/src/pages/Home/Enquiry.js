import { Container } from "react-bootstrap";
import Navbar4 from "../../components/navbars/Navbar4";
import Footer from "../../components/footer/Footer";
import EnquiryForm from "../../components/form/EnquiryForm";

const Enquiry = () => {
  return (
    <>
      <Navbar4 fixedWidth />
      <section className="position-relative p-5 bg-gradient2">
        <Container>
          <EnquiryForm />
        </Container>
      </section>
      <Footer />
    </>
  );
};
export default Enquiry;
