import React, { useState } from "react";
import AddPayment from "./AddPayment";

const Post = (props) => {
  // const log = useContext(LogContext)

  const [payment, setPayment] = useState({
    contractid: "",
    paymentdate: "",
    amountpaid: "",
    paymentstatus: "",
  });
  const createPayment = async () => {
    await AddPayment(payment);
  };
  const validate = (e) => {
    e.preventDefault();
    if (
      e.target.contractid.value === "" ||
      e.target.amountpaid.value === "" ||
      e.target.amountpaid.value === "" ||
      e.target.paymentstatus.value === ""
    ) {
      alert("please fill all valid data");
      return false;
    } else if (
      e.target.paymentstatus.value !== "Completed" &&
      e.target.paymentstatus.value !== "Pending"
    ) {
      alert(
        "Please enter valid payment status  .......  either pending or Completed"
      );
      return false;
    } else {
      createPayment();
    }
  };

  const onChange = (e) => {
    setPayment({ ...payment, [e.target.id]: e.target.value });
  };

  return (
    <>
      <h1 className="text-center mb-5" style={{ color: "#007bff" }}>
        Add a new Payments Ensure that a match can only be created if both
        PaymentDate and AmountPaid exist in the Payments table
      </h1>
      <form className="form-group container" onSubmit={validate}>
        <div className="form-group">
          <label htmlFor="contractid">ID:</label>
          <input
            type="number"
            className="form-control"
            id="contractid"
            value={payment.contractid}
            onChange={onChange}
            style={{ borderRadius: "10px" }}
          />
        </div>
        <div className="form-group">
          <label htmlFor="paymentdate">Payment Date:</label>
          <input
            type="Date"
            className="form-control"
            id="paymentdate"
            value={payment.paymentdate}
            onChange={onChange}
            style={{ borderRadius: "10px" }}
          />
        </div>
        <div className="form-group">
          <label htmlFor="amountpaid">Price:</label>
          <input
            type="number"
            className="form-control"
            id="amountpaid"
            value={payment.amountpaid}
            onChange={onChange}
            style={{ borderRadius: "10px" }}
          />
        </div>
        <div className="form-group">
          <label htmlFor="paymentstatus">Payment Status:</label>
          <input
            type="text"
            className="form-control"
            id="paymentstatus"
            value={payment.paymentstatus}
            onChange={onChange}
            style={{ borderRadius: "10px" }}
          />
        </div>
        <button
          type="submit"
          className="btn btn-primary m-2 p-2"
          style={{ borderRadius: "10px" }}
        >
          Add Payment
        </button>
      </form>
    </>
  );
};

export default Post;
